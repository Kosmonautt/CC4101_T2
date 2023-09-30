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
         | (boolV Boolean)
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


;; num2num-op :: (Number Number -> Number) -> (Val Val -> Val)
;; Función que recibe una función binaria que realiza una operación binaria sobre dos números 
;; y retorna un bool, retorna una fucnión que recibe dos valores (de tipo Val), realiza la 
;;operación de la función dada originalmente y retorna el resultado de este en forma de Val

(define (num2num-op f)
  (lambda (n1 n2) 
    (define v1 
      (match n1
        [(numV n) #:when (number? n) n]
        [else #t]))
    (define v2 
      (match n2
        [(numV n) #:when (number? n) n]
        [else #t]))

      (if (or (equal? v1 #t) (equal? v2 #t)) (error "num-op: invalid operands") (numV (f v1 v2)))))


;; num2bool-op :: (Number Number -> Boolean) -> (Val Val -> Val)
;; Función que recibe una función binaria que realiza una operación binaria sobre dos números 
;; y retorna un num, retorna una fucnión que recibe dos valores (de tipo Val), realiza la 
;;operación de la función dada originalmente y retorna el resultado de este en forma de Val
(define (num2bool-op f)
  (lambda (n1 n2) 
    (define v1 
      (match n1
        [(numV n) #:when (number? n) n]
        [else #t]))
    (define v2 
      (match n2
        [(numV n) #:when (number? n) n]
        [else #t]))

      (if (or (equal? v1 #t) (equal? v2 #t)) (error "num-op: invalid operands") (boolV (f v1 v2)))))


;; num+ :: (Val Val -> Val)
;; Función que recibe dos Val de tipó númerico y retorna la suma de estos en forma de Val
(define num+ (num2num-op +))

;; num- :: (Val Val -> Val)
;; Función que recibe dos Val de tipó númerico y retorna la resta de estos en forma de Val
(define num- (num2num-op -))

;; num* :: (Val Val -> Val)
;; Función que recibe dos Val de tipó númerico y retorna la multiplicación de estos en forma de Val
(define num* (num2num-op *))

;; num<= :: (Val Val -> Val)
;; Función que recibe dos Val de tipó númerico y retorna si el un booleano que dice si el primer valor
;; es menor o igual al segundo
(define num<= (num2bool-op <=))

;; PARTE 1E, 1G

;; extend-env-multiple :: Listof[id] Listof[Expr] Env -> Env
;; 

(define (extend-env-multiple ids Vals env)
  (define (extend-env-multiple-rec ids_ Vals_ env_) 
    (if (= (length ids_) 0) env (aEnv (car ids_) (car Vals_) (extend-env-multiple-rec (cdr ids_) (cdr Vals_) env_)) ))

  (if (= (length ids) (length Vals)) (extend-env-multiple-rec ids Vals env) (error "number of arguments given do not match number of arguments defined on the function")))

;; eval-list :: Listof[Expr] Env -> Listof[Val]
;;

(define (eval-list Exprs env)
  (match Exprs
    ['() '()]
    [(cons h t) (append (list (eval h env)) (eval-list t env))]))

;; eval :: Expr Env -> Val
;; evalúa una expresión con un ambiente dado
(define (eval expr env) 
  (match expr
    [(num n) (numV n)]
    [(tt) (boolV #t)]
    [(ff) (boolV #f)]
    [(id x) (env-lookup x env)]
    [(add l r) (num+ (eval l env) (eval r env))]
    [(sub l r) (num- (eval l env) (eval r env))]
    [(mul l r) (num* (eval l env) (eval r env))]  
    [(leq l r) (num<= (eval l env) (eval r env))]
    [(ifc c l r) 
                (def (boolV b) (eval c env)) 
                (if b 
                  (eval l env)
                  (eval r env))]
    [(fun id body) (closureV id body env)]
    [(app f e) (def (closureV the-args the-body the-claus-env) (eval f env)) 
               (def the-ext-env (extend-env-multiple the-args (eval-list e env) the-claus-env)) 
               (eval the-body the-ext-env)
    ]
    ))

(define l (list ))

;; PARTE 2A

(define swap* '???)
(define curry* '???)
(define uncurry* '???)
(define partial* '???)

;; PARTE 2B

;; run :: ...
(define (run) '???)
