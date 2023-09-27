#lang play
(print-only-errors)

;; PARTE 1A, 1B, 1F

#|
  Expr ::= (num <num>)
         | (tt)
         | (ff)
         | (add Expr Expr)
         | (sub Expr Expr)
         | (mult Expr Expr)
         | (leq expr expr)
         | (ifc expr expr expr)
|#
;; Datatype que representa expresiones aritméticas y lógicas


(deftype Expr
  ;; core
  (num n)
  (tt)
  (ff)
  (add l r)
  (sub l r)
  (mul l r)
  (leq l r)
  (ifc b t f))

;; parse :: ...
(define (parse s-expr)
  (match s-expr
    [n #:when (number? n) (num n)]
    [bool #:when (boolean? bool) (if bool (tt) (ff))] 
    [(list '+ l r) (add (parse l) (parse r))]
    [(list '- l r) (sub (parse l) (parse r))]
    [(list '* l r) (mul (parse l) (parse r))]
    [(list <= l r) (leq (parse l) (parse r))]
    [(list if b t f) (ifc (parse b) (parse t) (parse f))]
  )
)

;; PARTE 1C, 1G

(deftype Val
  ;...
  )

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
