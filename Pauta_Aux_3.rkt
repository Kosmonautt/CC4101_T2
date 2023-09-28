#lang play

#| P1
a) Substitución directa
{with {x 5}
  {+ {with {y 6}
       {with {x {+ 1 y}}
         {+ x y}}}
     {with {y {+ x 5}}
       y}}}
-------------------------
{+ {with {y 6}
     {with {x {+ 1 y}}
       {+ x y}}}
   {with {y {+ 5 5}}
     y}}}
-------------------------
{+ {with {x {+ 1 6}}
     {+ x 6}}}
   {with {y {+ 5 5}}
     y}}}
-------------------------
{+ {+ 7 6}
   {with {y {+ 5 5}}
     y}}}
-------------------------
{+ 13
   {with {y {+ 5 5}}
     y}}}
-------------------------
{+ 13
   10}
-------------------------
23
-------------------------
-------------------------

Substitución diferida
{with {x 5}
  {+ {with {y 6}
       {with {x {+ 1 y}}
         {+ x y}}}
     {with {y {+ x 5}}
       y}}}
-------------------------
{+ {with {y 6}
     {with {x {+ 1 y}}
       {+ x y}}}
   {with {y {+ x 5}}
     y}}}
------------------------- Env x=5
{+ {with {x {+ 1 y}}
     {+ x y}}}
   {with {y {+ x 5}}
     y}}}
------------------------- Env y=6, x=5
{+ {with {x {+ 1 6}}
     {+ x y}}
   {with {y {+ x 5}}
     y}}
------------------------- Env y=6, x=5
{+ {+ x y}
   {with {y {+ x 5}}
     y}}
------------------------- Env x=7, y=6, x=5
{+ {+ 7 6}
   {with {y {+ x 5}}
     y}}
------------------------- Env x=7, y=6, x=5
{+ 13
   {with {y {+ x 5}}
     y}}
------------------------- Env x=5
{+ 13
   {with {y {+ 5 5}}
     y}}
------------------------- Env x=5
{+ 13
   y}
------------------------- Env y=10, x=5
{+ 13
   10}
------------------------- Env x=5
23
-------------------------
-------------------------

b) Producen el mismo resultado pero con la substitución directa se recorre multiples veces el programa, haciendo los
reemplazos, lo que puede resultar ineficiente, en especial si dicha variable no se utiliza.
|#

#| P2
a) 10     |10
b) Error y|0
c) Error y|40
d) Error y|54
e) Error y|-15
|#

#| P3
<expr> ::= <num>
         | {+ <expr> <expr>}
         | {- <expr> <expr>}
         | {if0 <expr> <expr> <expr>}
         | {with {<sym> <expr>} <expr>}
         | <id>
         | {<sym> <expr>*}                    P3.a)
         | {with-fun {<fundef>} <expr>} P3.b)
|#
(deftype Expr
  (num n)
  (add l r)
  (sub l r)
  (if0 c t f)
  (with id named-expr body)
  (id s)
  (app f-name args-expr)               ; P3.a)
  (with-fun fundef body))               ; P3.b)


;; parse-fundef :: s-fundef -> Fundef
#| where
   <s-fundef> ::= (list 'define <sym> <sym>* <expr>) P3.b)
|#
(define (parse-fundef s-fundef)
  (match s-fundef
    [(list 'define fname fargs ... body)
     (fundef fname fargs (parse body))]))

;; parse :: s-expr -> Expr
#| where
   <s-expr> ::= <num>
              | <sym>
              | (list '+ <s-expr> <s-expr>)
              | (list '- <s-expr> <s-expr>)
              | (list 'if0 <s-expr> <s-expr> <s-expr>)
              | (list 'with (list <sym> <s-expr>) <s-expr>)
              | (list <sym> <s-expr>*)                      P3.a)
              | (list 'with-fun <s-fundef> <s-expr>)        P3.b)
|#
(define (parse s-expr)
  (match s-expr
    [(? number?) (num s-expr)]
    [(? symbol?) (id s-expr)]
    [(list '+ l r) (add (parse l) (parse r))]
    [(list '- l r) (sub (parse l) (parse r))]
    [(list 'if0 c t f) (if0 (parse c)
                            (parse t)
                            (parse f))]
    [(list 'with (list x e) b)
     (with x (parse e) (parse b))]
    [(list 'with-fun s-fundef body) (with-fun
                                        (parse-fundef s-fundef)
                                        (parse body))]    ; P3.b)
    [(list f a ...) (app f (map parse a))]))              ; P3.a)
 
;; function definition
(deftype FunDef
  (fundef name args body))
 
;; lookup-fundef :: sym Listof(FunDef) -> FunDef
(define (lookup-fundef f funs)
  (match funs
    ['() (error 'lookup-fundef "function not found: ~a" f)]
    [(cons (and fd (fundef fn _ _)) rest)
     (if (symbol=? fn f)
         fd
         (lookup-fundef f rest))]))

;; ambiente de sustitución diferida
(deftype Env
  (mtEnv)
  (aEnv id val env))

;; interface ADT (abstract data type) del ambiente
(define empty-env (mtEnv))

;; "Simplemente" asigna un nuevo identificador para aEnv
;(define extend-env aEnv)
;;
;; es lo mismo que definir extend-env así:
;; (concepto técnico 'eta expansion')
(define (extend-env id val env) (aEnv id val env))

(define (env-lookup x env)
  (match env
    [(mtEnv) (error 'env-lookup "free identifier: ~a" x)]
    [(aEnv id val rest) (if (symbol=? id x) val (env-lookup x rest))]))

;; interp :: Expr Listof(FunDef) Env -> number
(define (interp expr funs env)
  (match expr
    [(num n) n]
    [(add l r) (+ (interp l funs env) (interp r funs env))]
    [(sub l r) (- (interp l funs env) (interp r funs env))]
    [(if0 c t f)
     (if (zero? (interp c funs env))
         (interp t funs env)
         (interp f funs env))]
    [(with bound-id named-expr bound-body)
     (interp bound-body
             funs
             (extend-env bound-id
                         (interp named-expr funs env)
                         env))]
    [(id x) (env-lookup x env)]
    [(app f args-expr)
     (def (fundef _ fargs fbody) (lookup-fundef f funs))
     (interp fbody
             funs
             (foldl (lambda (farg arg-expr new-env)        ; P3.a)
                      (extend-env farg (interp arg-expr funs env) new-env))
                    empty-env
                    fargs
                    args-expr))]
    [(with-fun fundef fbody)                               ; P3.b)
     (interp fbody
             (cons fundef funs)
             env)]))
 
;; run :: s-expr [listof(FunDef)] -> number
(define (run prog [funs '()])
  (interp (parse prog) funs empty-env))

; Tests P3.a)
(test (run '{add 1 2 3 4}
           (list (fundef 'add (list 'e1 'e2 'e3 'e4) (parse `(+ e1 (+ e2 (+ e3 e4)))))))
      10)

(test (run '{const5}
           (list (fundef 'const5 (list) (parse `5))))
      5)

; Tests P3.b)
(test (run `{with-fun {define add1 x {+ 1 x}}
              {add1 5}})
      6)

(test (run `{with-fun {define foo x {+ 1 x}}
              {foo 5}}
           (list (fundef 'foo (list 'x) (parse `{+ 10 x}))))
      6)

#| P4  |#
; a) factorial de 9
(define prog-a `{with-fun {define mult n m {if0 m 0 {+ n {mult n {- m 1}}}}}
                  {with-fun {define factorial n {if0 n 1 {mult n {factorial {- n 1}}}}}
                    {factorial 9}}})
(test (run prog-a) 362880)

; b) 49 es par?. Asumiendo que 1 es verdadero y 0 es falso
(define prog-b `{with-fun {define negate n {if0 n 1 0}}
                  {with-fun {define odd? n {if0 n 0 {negate {even? {- n 1}}}}}
                    {with-fun {define even? n {if0 n 1 {negate {odd? {- n 1}}}}}
                      {odd? 49}}}})
(test (run prog-b) 0)