#lang play
(print-only-errors)

;; PARTE 1A, 1B, 1F

#|
  Expr ::= (num num)
         | (tt)
         | (ff)
         | (id sym)
         | (add Expr Expr)
         | (sub Expr Expr)
         | (mult Expr Expr)
         | (leq Expr Expr)
         | (ifc Expr Expr Expr)
         | (fun (list Expr*) Expr)
         | (app (id sym) (list Expr*))
|#
;; Datatype que representa expresiones aritméticas y lógicas, con suma, resta, multiplicación, 
;; menor e igual, if, definición de funciones y aplicación de funciones

(deftype Expr
  ;; core
  (num n)
  (tt)
  (ff)
  (id x)
  (add l r)
  (sub l r)
  (mul l r)
  (leq l r)
  (ifc b t f)
  (fun args e)
  (app f args))

;; parse :: s-expr -> Expr
;; Transforma una s-expr a una Expr
(define (parse s-expr)
  (match s-expr
    [n #:when (number? n) (num n)]
    [bool #:when (equal? bool 'true) (tt)] 
    [bool #:when (equal? bool 'false) (ff)] 
    [x #:when (symbol? x) (id x)]
    [(list '+ l r) (add (parse l) (parse r))]
    [(list '- l r) (sub (parse l) (parse r))]
    [(list '* l r) (mul (parse l) (parse r))]
    [(list '<= l r) (leq (parse l) (parse r))]
    [(list 'if b t f) (ifc (parse b) (parse t) (parse f))]
    [(list 'fun (list args ...) e) (fun args (parse e))]
    [(list f args ...) #:when (symbol? f) (app (id f) (map parse args))]))

;; PARTE 1C, 1G

#|
  Val ::=  (numV num)
         | (boolV Expr-Bool)
         | (closureV args body env)
|#
;; Datatype que representa los valores al evaluar expresiones, estos pueden ser
;; números, verdadero o falso y clausuras.

(deftype Val
  (numV n)
  (boolV bool)
  (closureV id body env))

;; ambiente de sustitución diferida
(deftype Env
  (mtEnv)
  (aEnv args val env))

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

;; PARTE 1D

;; num2num-op :: ...
(define (num2num-op) '???)

;; num2bool-op :: ...
(define (num2bool-op) '???)

;; PARTE 1E, 1G

;; eval :: ...
(define (eval) '???)

;; PARTE 2A

(define swap* '???)
(define curry* '???)
(define uncurry* '???)
(define partial* '???)

;; PARTE 2B

;; run :: ...
(define (run) '???)
