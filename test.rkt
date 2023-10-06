#lang play
(require "T2.rkt")

(print-only-errors #t)

#| P1 |#

#| Parte A |#

(test (parse 1) (num 1))
(test (parse 155) (num 155))
(test (parse '(+ 5 10)) (add (num 5) (num 10)))
(test (parse '(+ 0 1)) (add (num 0) (num 1)))
(test (parse '(- 2 2)) (sub (num 2) (num 2)))
(test (parse '(+ 7 (- 6 3))) (add (num 7) (sub (num 6) (num 3))))
(test (parse '(- 10 (- 3 3))) (sub (num 10) (sub (num 3) (num 3))))
(test (parse '(* 10 2)) (mul (num 10) (num 2)))
(test (parse '(* 10 (+ 1 1))) (mul (num 10) (add (num 1) (num 1))))
(test (parse '(* (- 4 2) (+ 1 1))) (mul (sub (num 4) (num 2)) (add (num 1) (num 1))))
(test (parse 'true) (tt))
(test (parse 'false) (ff))
(test (parse '(<= 1 10)) (leq (num 1) (num 10)))
(test (parse '(<= 10 1)) (leq (num 10) (num 1)))
(test (parse '(<= (* (+ 2 5) 3) (- 10 7))) (leq (mul (add (num 2) (num 5)) (num 3)) (sub (num 10) (num 7))))
(test (parse '(if true 1 2)) (ifc (tt) (num 1) (num 2)))
(test (parse '(if false 1 2)) (ifc (ff) (num 1) (num 2)))
(test (parse '(if (<= 3 5) 2 4)) (ifc (leq (num 3) (num 5)) (num 2) (num 4)))
(test (parse '(if (<= (* 2 (+ 6 3)) (- 22 2)) 2 (+ 5 6))) (ifc (leq (mul (num 2) (add (num 6) (num 3))) (sub (num 22) (num 2))) (num 2) (add (num 5) (num 6))))

#| Parte B |#

(test (parse 'x) (id 'x))
(test (parse '(+ 2 x)) (add (num 2) (id 'x)))
(test (parse '(+ y x)) (add (id 'y) (id 'x)))
(test (parse '(+ (* x (+ y 4) ) (- 2 z))) (add (mul (id 'x) (add (id 'y) (num 4))) (sub (num 2) (id 'z))))
(test (parse '(if (<= x y) z 0)) (ifc (leq (id 'x) (id 'y)) (id 'z) (num 0)))

(test (parse '(fun (x y) (+ x y))) (fun (list 'x 'y) (add (id 'x) (id 'y))))
(test (parse '(fun (x y) (+ (+ x 3) y))) (fun (list 'x 'y) (add (add (id 'x) (num 3)) (id 'y))))
(test (parse '(fun (x) x)) (fun (list 'x) (id 'x)))
(test (parse '(fun (x) (+ x x))) (fun (list 'x) (add (id 'x) (id 'x))))
(test (parse '(fun () 0)) (fun (list) (num 0)))
(test (parse '(fun () (+ 2 (* 4 2)))) (fun (list) (add (num 2) (mul (num 4) (num 2)))))
(test (parse '(fun (x y z) (* (+ x y) (- x z)))) (fun (list 'x 'y 'z) (mul (add (id 'x) (id 'y)) (sub (id 'x) (id 'z)))))
(test (parse '(fun (a b c) (if (<= a b) c 0))) (fun (list 'a 'b 'c) (ifc (leq (id 'a) (id 'b)) (id 'c) (num 0))))

(test (parse '(my-function 2 3 4)) (app (id 'my-function) (list (num 2) (num 3) (num 4))))
(test (parse '(fun-1 7)) (app (id 'fun-1) (list (num 7))))
(test (parse '(fun0)) (app (id 'fun0) (list)))
(test (parse '(my-function (+ 2 (* 3 7)) (- 10 8) (if (<= 100 5) 8 74))) (app (id 'my-function) (list (add (num 2) (mul (num 3) (num 7))) (sub (num 10) (num 8)) (ifc (leq (num 100) (num 5)) (num 8) (num 74)))))
(test (parse '(f (+ 9 (* 2 7)) (- 10 x) 4)) (app (id 'f) (list (add (num 9) (mul (num 2) (num 7))) (sub (num 10) (id 'x)) (num 4))))


#| Parte D |#

(test (num+ (numV 3) (numV 4)) (numV 7))
(test (num+ (numV 4) (numV 3)) (numV 7))
(test (num+ (numV 0) (numV 4)) (numV 4))
(test (num+ (numV 0) (numV 0)) (numV 0))
(test/exn (num+ (numV 4) (boolV #t)) "num-op: invalid operands")

(test (num- (numV 3) (numV 4)) (numV -1))
(test (num- (numV 4) (numV 2)) (numV 2))
(test (num- (numV 4) (numV 0)) (numV 4))
(test (num- (numV 0) (numV 0)) (numV 0))
(test/exn (num+ (boolV #f) (numV 4)) "num-op: invalid operands")

(test (num* (numV 3) (numV 4)) (numV 12))
(test (num* (numV 4) (numV 3)) (numV 12))
(test (num* (numV 0) (numV 4)) (numV 0))
(test (num* (numV 1) (numV 7)) (numV 7))
(test (num* (numV -5) (numV 3)) (numV -15))
(test/exn (num* (numV #t) (boolV #f)) "num-op: invalid operands")

(test (num<= (numV 3) (numV 8)) (boolV #t))
(test (num<= (numV 3) (numV 3)) (boolV #t))
(test (num<= (numV 3) (numV 2)) (boolV #f))
(test (num<= (numV 15) (numV 5)) (boolV #f))
(test/exn (num<= (numV 10) (boolV #t)) "num-op: invalid operands")
(test/exn (num<= (boolV #f) (numV 12)) "num-op: invalid operands")
(test/exn (num<= (boolV #t) (boolV #f)) "num-op: invalid operands")

#| Parte E |#

(test (eval (parse 1) empty-env) (numV 1))
(test (eval (parse 155) empty-env) (numV 155))
(test (eval (parse '(+ 5 10)) empty-env) (numV 15))
(test (eval (parse '(+ 0 1)) empty-env) (numV 1))
(test (eval (parse '(- 2 2)) empty-env) (numV 0))
(test (eval (parse '(+ 7 (- 6 3))) empty-env) (numV 10))
(test (eval (parse '(- 10 (- 3 3))) empty-env) (numV 10))
(test (eval (parse '(* 10 2)) empty-env) (numV 20))
(test (eval (parse '(* 10 (+ 1 1))) empty-env) (numV 20))
(test (eval (parse '(* (- 4 2) (+ 1 1))) empty-env) (numV 4))

(test (eval (parse 'true) empty-env) (boolV #t))
(test (eval (parse 'false) empty-env) (boolV #f))
(test (eval (parse '(<= 1 10)) empty-env) (boolV #t))
(test (eval (parse '(<= 10 1)) empty-env) (boolV #f))
(test (eval (parse '(<= (* (+ 2 5) 3) (- 10 7))) empty-env) (boolV #f))
(test (eval (parse '(if true 1 2)) empty-env) (numV 1))
(test (eval (parse '(if false 1 2)) empty-env) (numV 2))
(test (eval (parse '(if (<= 3 5) 2 4)) empty-env) (numV 2))
(test (eval (parse '(if ( <= (* 2 (+ 6 3)) (- 22 2)) 2 (+ 5 6))) empty-env) (numV 2))
(test (eval (parse '(if ( <= (* 3 (+ 6 3)) (- 22 2)) 2 (+ 5 6))) empty-env) (numV 11))

(test (eval (parse 'x) (extend-env 'x (numV 1) empty-env)) (numV 1))
(test (eval (parse 'y) (extend-env 'y (numV 1) empty-env)) (numV 1))
(test (eval (parse '(* x x)) (extend-env 'x (numV 4) empty-env)) (numV 16))
(test (eval (parse '(+ 5 100)) (extend-env 'x (numV 4) empty-env)) (numV 105))
(test (eval (parse '(+ 2 x)) (extend-env 'x (numV 10) empty-env)) (numV 12))
(test (eval (parse '(+ y x)) (extend-env 'x (numV 9) (extend-env 'y (numV 7) empty-env))) (numV 16))
(test (eval (parse '(+ y x)) (extend-env 'y (numV 9) (extend-env 'x (numV 7) empty-env))) (numV 16))
(test (eval (parse '(+ (* x (+ y 4) ) (- 2 z))) (extend-env 'y (numV 9) (extend-env 'x (numV 7) (extend-env 'z (numV 20) empty-env)))) (numV 73))
(test (eval (parse '(if (<= x y) z 0)) (extend-env 'z (numV 9) (extend-env 'x (numV 7) (extend-env 'y (numV 20) empty-env)))) (numV 9))
(test (eval (parse 'bool) (extend-env 'bool (boolV #t) empty-env)) (boolV #t))
(test (eval (parse 'bool) (extend-env 'bool (boolV #f) empty-env)) (boolV #f))
(test (eval (parse '(if b x y)) (extend-env 'x (numV 9) (extend-env 'b (boolV #t) (extend-env 'y (numV 20) empty-env)))) (numV 9))
(test (eval (parse '(if b x y)) (extend-env 'x (numV 9) (extend-env 'b (boolV #f) (extend-env 'y (numV 20) empty-env)))) (numV 20))


(define l_id_1 (list 'x 'y 'z 'b))
(define l_id_2 (list 'a 'b))
(define l_val_1 (list (numV 10) (numV 15) (numV -4) (boolV #f)))
(define l_val_2 (list (numV 4) (numV 7)))
(define l_val_3 (list (numV 5) (numV 17) (numV 22) (boolV #t)))
(define l_env (aEnv 'v (numV 8) empty-env))

(test (extend-env-multiple l_id_1 l_val_1 empty-env) (aEnv 'x (numV 10) (aEnv 'y (numV 15) (aEnv 'z (numV -4) (aEnv 'b (boolV #f) empty-env)))))
(test (extend-env-multiple l_id_1 l_val_1 l_env) (aEnv 'x (numV 10) (aEnv 'y (numV 15) (aEnv 'z (numV -4) (aEnv 'b (boolV #f) (aEnv 'v (numV 8) empty-env))))))
(test (extend-env-multiple l_id_1 l_val_3 l_env) (aEnv 'x (numV 5) (aEnv 'y (numV 17) (aEnv 'z (numV 22) (aEnv 'b (boolV #t) (aEnv 'v (numV 8) empty-env))))))
(test (extend-env-multiple l_id_2 l_val_2 empty-env) (aEnv 'a (numV 4) (aEnv 'b (numV 7) empty-env)))
(test (extend-env-multiple l_id_2 l_val_2 l_env) (aEnv 'a (numV 4) (aEnv 'b (numV 7) (aEnv 'v (numV 8) empty-env))))
(test/exn (extend-env-multiple l_id_1 l_val_2 empty-env) "number of arguments given do not match number of arguments defined on the function")
(test/exn (extend-env-multiple l_id_1 l_val_2 l_env) "number of arguments given do not match number of arguments defined on the function")
(test/exn (extend-env-multiple l_id_2 l_val_1 empty-env) "number of arguments given do not match number of arguments defined on the function")
(test/exn (extend-env-multiple l_id_2 l_val_1 l_env) "number of arguments given do not match number of arguments defined on the function")


(test (eval-list (list) empty-env) (list))
(test (eval-list (list (num 5)) empty-env) (list (numV 5)))
(test (eval-list (list (num 5) (tt) (num 10)) empty-env) (list (numV 5) (boolV #t) (numV 10)))
(test (eval-list (list (add (num 70) (num 2)) (num 10)) empty-env) (list (numV 72) (numV 10)))
(test (eval-list (list (id 'x)) (aEnv 'x (numV 10) empty-env)) (list (numV 10)))
(test (eval-list (list (add (num 7) (id 'x))) (aEnv 'x (numV 10) empty-env)) (list (numV 17)))
(test (eval-list (list (add (num 7) (id 'x)) (ifc (id 'b) (num 5) (num 8))) (aEnv 'x (numV 10) (aEnv 'b (boolV #t) empty-env))) (list (numV 17) (numV 5)))
(test (eval-list (list (add (num 7) (id 'x)) (ifc (id 'b) (num 5) (mul (id 'x) (num 8)))) (aEnv 'x (numV 10) (aEnv 'b (boolV #f) empty-env))) (list (numV 17) (numV 80)))


(define f_0 (eval (parse '(fun () 0)) empty-env))
(define f_1 (eval (parse '(fun (a) (+ a x))) (extend-env 'x (numV 10) empty-env)))
(define f_bool (eval (parse '(fun (x) (if (<= x 10) true false))) empty-env))
(define f_2 (eval (parse '(fun (x y) (+ x y))) empty-env))
(define g_2 (eval (parse '(fun (x y) (* x (f x y)))) (extend-env 'f f_2 empty-env)))
(define f_3 (eval (parse '(fun (x y z) (* z (+ x y)))) empty-env))

(test f_0 (closureV '() (num 0) empty-env))
(test f_1 (closureV '(a) (add (id 'a) (id 'x)) (extend-env 'x (numV 10) empty-env)))
(test f_bool (closureV '(x) (ifc (leq (id 'x) (num 10)) (tt) (ff)) empty-env))
(test f_2 (closureV '(x y) (add (id 'x) (id 'y)) empty-env))
(test g_2 (closureV '(x y) (mul (id 'x) (app (id 'f) (list (id 'x) (id 'y)))) (extend-env 'f f_2 empty-env)))
(test f_3 (closureV '(x y z) (mul (id 'z) (add (id 'x) (id 'y))) empty-env))

(test (eval (parse '(f)) (extend-env 'f f_0 empty-env)) (numV 0))
(test (eval (parse '(+ 10 (f))) (extend-env 'f f_0 empty-env)) (numV 10))
(test (eval (parse '(h)) (extend-env 'h f_0 empty-env)) (numV 0))
(test (eval (parse '(f 5)) (extend-env 'f f_1 empty-env)) (numV 15))
;; scope estático, no dinámico
(test (eval (parse '(f 5)) (extend-env 'f f_1 (extend-env 'x (numV 5) empty-env))) (numV 15))
(test (eval (parse '(f x)) (extend-env 'f f_1 (extend-env 'x (numV 5) empty-env))) (numV 15))
(test (eval (parse '(b x)) (extend-env 'b f_bool (extend-env 'x (numV 5) empty-env))) (boolV #t))
(test (eval (parse '(b x)) (extend-env 'b f_bool (extend-env 'x (numV 10) empty-env))) (boolV #t))
(test (eval (parse '(b x)) (extend-env 'b f_bool (extend-env 'x (numV 11) empty-env))) (boolV #f))
(test (eval (parse '(f 7 3)) (extend-env 'f f_2 empty-env)) (numV 10))
(test (eval (parse '(f (+ 70 2) (* 5 2))) (extend-env 'f f_2 empty-env)) (numV 82))
(test (eval (parse '(f (if true 7 5) 10)) (extend-env 'f f_2 empty-env)) (numV 17))
(test (eval (parse '(f (if false 7 5) 10)) (extend-env 'f f_2 empty-env)) (numV 15))
(test (eval (parse '(g 7 3)) (extend-env 'g g_2 empty-env)) (numV 70))
(test (eval (parse '(* 2 (g 7 3))) (extend-env 'g g_2 empty-env)) (numV 140))
(test (eval (parse '(* (g 8 5) (g 7 3))) (extend-env 'g g_2 empty-env)) (numV 7280))
(test (eval (parse '(f 7 3 6)) (extend-env 'f f_3 empty-env)) (numV 60))
(test (eval (parse '(* (g 7 3) (+ (f x 3) (f (+ 70 2) 10)))) (extend-env 'f f_2 (extend-env 'x (numV 7) (extend-env 'g g_2 empty-env)))) (numV 6440))

(test/exn (eval (parse '(f 3)) (extend-env 'f f_2 empty-env)) "number of arguments given do not match number of arguments defined on the function")
(test/exn (eval (parse '(f 5)) (extend-env 'f f_0 empty-env)) "number of arguments given do not match number of arguments defined on the function")
(test/exn (eval (parse '(f)) (extend-env 'f f_1 empty-env)) "number of arguments given do not match number of arguments defined on the function")

#| Parte F |#

(test (parse '(tuple 1)) (tupl (list (num 1))))
(test (parse '(tuple 1 2 3)) (tupl (list (num 1) (num 2) (num 3))))
(test (parse '(tuple (+ 1 2) (- (* 2 x) (+ 8 9)) 3)) (tupl (list (add (num 1) (num 2)) (sub (mul (num 2) (id 'x)) (add (num 8) (num 9))) (num 3))))
(test (parse '(tuple 2 true (if (<= x 4) 9 22))) (tupl (list (num 2) (tt) (ifc (leq (id 'x) (num 4)) (num 9) (num 22)))))
(test (parse '(tuple (fun (x y z) (* (+ x y) (- z 10))) (f_2 (+ 4 (- 10 3)) (<= x y)) (f_0))) (tupl (list (fun (list 'x 'y 'z) (mul (add (id 'x) (id 'y)) (sub (id 'z) (num 10)))) (app (id 'f_2) (list (add (num 4) (sub (num 10) (num 3))) (leq (id 'x) (id 'y)))) (app (id 'f_0) (list)))))
(test (parse '(tuple 1 2 (tuple 1 (tuple 1 2)))) (tupl (list (num 1) (num 2) (tupl (list (num 1) (tupl (list (num 1) (num 2))))))))

(test (parse '(proj (tuple 10 20 30) 1)) (proj (tupl (list (num 10) (num 20) (num 30))) (num 1)))
(test (parse '(proj (tuple 10 (+ 20 4) true) 2)) (proj (tupl (list (num 10) (add (num 20) (num 4)) (tt))) (num 2)))
(test (parse '(proj (tuple 10 20 30) (proj (tuple 4 3 2 1) 2))) (proj (tupl (list (num 10) (num 20) (num 30))) (proj (tupl (list (num 4) (num 3) (num 2) (num 1))) (num 2))))


#| Parte G |#

(test (eval (parse '(tuple 1)) empty-env) (tuplV (list (numV 1))))
(test (eval (parse '(tuple 1 2 3)) empty-env) (tuplV (list (numV 1) (numV 2) (numV 3))))
(test (eval (parse '(tuple (+ 1 2) (- (* 2 x) (+ 8 9)) 3)) (extend-env 'x (numV 10) empty-env)) (tuplV (list (numV 3) (numV 3) (numV 3))))
(test (eval (parse '(tuple 2 true (if (<= x 4) 9 22))) (extend-env 'x (numV 4) empty-env)) (tuplV (list (numV 2) (boolV #t) (numV 9))))
(test (eval (parse '(tuple 2 true (if (<= x 4) 9 22))) (extend-env 'x (numV 5) empty-env)) (tuplV (list (numV 2) (boolV #t) (numV 22))))
(test (eval (parse '(tuple (fun (x y z) (* (+ x y) (- z 10))) 10)) empty-env) (tuplV (list (closureV '(x y z) (mul (add (id 'x) (id 'y)) (sub (id 'z) (num 10))) empty-env) (numV 10)))) 
(test (eval (parse '(tuple 1 2 (tuple 1 (tuple 1 2)))) empty-env) (tuplV (list (numV 1) (numV 2) (tuplV (list (numV 1) (tuplV (list (numV 1) (numV 2))))))))


(test (i-element (list 10 20 30 40) 1) 10)
(test (i-element (list 10 20 30 40) 2) 20)
(test (i-element (list 10 20 30 40) 3) 30)
(test (i-element (list 10 20 30 40) 4) 40)


(test (eval (parse '(proj (tuple 10 20 30) 1)) empty-env) (numV 10))
(test (eval (parse '(proj (tuple 10 20 30) 2)) empty-env) (numV 20))
(test (eval (parse '(proj (tuple 10 20 30) 3)) empty-env) (numV 30))
(test (eval (parse '(proj (tuple 10 (+ 20 4) true) 2)) empty-env) (numV 24))
(test (eval (parse '(proj (tuple 10 (+ 20 4) true) 3)) empty-env) (boolV #t))
(test (eval (parse '(proj (tuple (fun (x y z) (* (+ x y) (- z 10))) 20 30) 1)) empty-env) (closureV '(x y z) (mul (add (id 'x) (id 'y)) (sub (id 'z) (num 10))) empty-env))
(test (eval (parse '(proj (tuple 10 20 30) x)) (extend-env 'x (numV 1) empty-env)) (numV 10))
(test (eval (parse '(proj (tuple 10 20 30) x)) (extend-env 'x (numV 2) empty-env)) (numV 20))
(test (eval (parse '(proj (tuple 10 20 30) x)) (extend-env 'x (numV 3) empty-env)) (numV 30))

#| P1 |#

#| Parte A |#
     
#| swap* |#
(define f_sub '(fun (x y) (- x y))) ;; s-expr
(define f_cond '(fun (x y) (+ (if x 100 0) (if y 50 0)))) ;; s-expr
(define f_sub_V (eval (parse f_sub) empty-env)) ;; Val (closure)
(define f_cond_V (eval (parse f_cond) empty-env)) ;; Val (closure)

(test (eval (parse '(f 4 3)) (extend-env 'f f_sub_V empty-env)) (numV 1))
(test (eval (parse '(f 3 4)) (extend-env 'f f_sub_V empty-env)) (numV -1))
(test (eval (parse '(f 8 4)) (extend-env 'f f_sub_V empty-env)) (numV 4))
(test (eval (parse '(f 4 8)) (extend-env 'f f_sub_V empty-env)) (numV -4))

(test (eval (parse '(f false false)) (extend-env 'f f_cond_V empty-env)) (numV 0))
(test (eval (parse '(f false true)) (extend-env 'f f_cond_V empty-env)) (numV 50))
(test (eval (parse '(f true false)) (extend-env 'f f_cond_V empty-env)) (numV 100))
(test (eval (parse '(f true true)) (extend-env 'f f_cond_V empty-env)) (numV 150))

(define my-program-f_sub (parse (list 'swap f_sub)))
(define my-program-f_cond (parse (list 'swap f_cond)))

(define f_sub_swap_V (eval my-program-f_sub     ;; mismo closure de la línea 236 pero con los argumentos en orden contrario (y diferente env)
                        (extend-env 'swap swap* empty-env)))    

(define f_cond_swap_V (eval my-program-f_cond     ;; mismo closure de la línea 237 pero con los argumentos en orden contrario (y diferente env)
                        (extend-env 'swap swap* empty-env))) 

;; se comparan los resultados de las funciones originales y sus contrapartes con swap, verificando que dan lo mismo con los parámetros en orden contrario
(test (eval (parse '(f 4 3)) (extend-env 'f f_sub_V empty-env)) (eval (parse '(f 3 4)) (extend-env 'f f_sub_swap_V empty-env)))
(test (eval (parse '(f 3 4)) (extend-env 'f f_sub_V empty-env)) (eval (parse '(f 4 3)) (extend-env 'f f_sub_swap_V empty-env)))
(test (eval (parse '(f 8 4)) (extend-env 'f f_sub_V empty-env)) (eval (parse '(f 4 8)) (extend-env 'f f_sub_swap_V empty-env)))
(test (eval (parse '(f 4 8)) (extend-env 'f f_sub_V empty-env)) (eval (parse '(f 8 4)) (extend-env 'f f_sub_swap_V empty-env)))

(test (eval (parse '(f true true)) (extend-env 'f f_cond_V empty-env)) (eval (parse '(f true true)) (extend-env 'f f_cond_swap_V empty-env)))
(test (eval (parse '(f true false)) (extend-env 'f f_cond_V empty-env)) (eval (parse '(f false true)) (extend-env 'f f_cond_swap_V empty-env)))
(test (eval (parse '(f false true)) (extend-env 'f f_cond_V empty-env)) (eval (parse '(f true false)) (extend-env 'f f_cond_swap_V empty-env)))
(test (eval (parse '(f false false)) (extend-env 'f f_cond_V empty-env)) (eval (parse '(f false false)) (extend-env 'f f_cond_swap_V empty-env)))


#| curry* |#
;; se crean las versiones currificadas
(define f_sub_curry (eval (parse (list 'curry f_sub))     
                            (extend-env 'curry curry* empty-env))) 

(define f_cond_curry (eval (parse (list 'curry f_cond))     
                            (extend-env 'curry curry* empty-env))) 

;; se crean otras funciones que se les da el primer parámetro
(define f_sub_curry_200 (eval (parse (list 'f 200))     
                            (extend-env 'f f_sub_curry empty-env)))  

(define f_sub_curry_15 (eval (parse (list 'f 15))     
                            (extend-env 'f f_sub_curry empty-env)))   

(define f_cond_curry_true (eval (parse (list 'f 'true))     
                            (extend-env 'f f_cond_curry empty-env)))   

(define f_cond_curry_false (eval (parse (list 'f 'false))     
                            (extend-env 'f f_cond_curry empty-env)))   

;; se prueban las funciones
(test (eval (parse '(f 10)) (extend-env 'f f_sub_curry_200 empty-env)) (numV 190))
(test (eval (parse '(f 100)) (extend-env 'f f_sub_curry_200 empty-env)) (numV 100))
(test (eval (parse '(f 210)) (extend-env 'f f_sub_curry_200 empty-env)) (numV -10))

(test (eval (parse '(f 10)) (extend-env 'f f_sub_curry_15 empty-env)) (numV 5))
(test (eval (parse '(f 100)) (extend-env 'f f_sub_curry_15 empty-env)) (numV -85))
(test (eval (parse '(f 210)) (extend-env 'f f_sub_curry_15 empty-env)) (numV -195))

(test (eval (parse '(f true)) (extend-env 'f f_cond_curry_true empty-env)) (numV 150))
(test (eval (parse '(f false)) (extend-env 'f f_cond_curry_true empty-env)) (numV 100))

(test (eval (parse '(f true)) (extend-env 'f f_cond_curry_false empty-env)) (numV 50))
(test (eval (parse '(f false)) (extend-env 'f f_cond_curry_false empty-env)) (numV 0))


#| uncurry* |#
;; funciones currificadas (s-expr)
(define f_sub_curry_s '(fun (x) (fun (y) (- x y)))) ;; s-expr
(define f_cond_curry_s '(fun (x) (fun (y) (+ (if x 100 0) (if y 50 0))))) ;; s-expr
;; evaluadas (closure)
(define f_sub_curry_2 (eval (parse f_sub_curry_s) empty-env)) ;; Val (closure)
(define f_cond_curry_2 (eval (parse f_cond_curry_s) empty-env)) ;; Val (closure)

;; se comprueba que tengan el comportamiento esperado con los mismos tests de la parte anterior
(define f_sub_curry_200_2 (eval (parse (list 'f 200))     
                            (extend-env 'f f_sub_curry_2 empty-env)))  

(define f_sub_curry_15_2 (eval (parse (list 'f 15))     
                            (extend-env 'f f_sub_curry_2 empty-env)))   

(define f_cond_curry_true_2 (eval (parse (list 'f 'true))     
                            (extend-env 'f f_cond_curry_2 empty-env)))   

(define f_cond_curry_false_2 (eval (parse (list 'f 'false))     
                            (extend-env 'f f_cond_curry_2 empty-env)))   

;; se prueban las funciones
(test (eval (parse '(f 10)) (extend-env 'f f_sub_curry_200_2 empty-env)) (numV 190))
(test (eval (parse '(f 100)) (extend-env 'f f_sub_curry_200_2 empty-env)) (numV 100))
(test (eval (parse '(f 210)) (extend-env 'f f_sub_curry_200_2 empty-env)) (numV -10))

(test (eval (parse '(f 10)) (extend-env 'f f_sub_curry_15_2 empty-env)) (numV 5))
(test (eval (parse '(f 100)) (extend-env 'f f_sub_curry_15_2 empty-env)) (numV -85))
(test (eval (parse '(f 210)) (extend-env 'f f_sub_curry_15_2 empty-env)) (numV -195))

(test (eval (parse '(f true)) (extend-env 'f f_cond_curry_true_2 empty-env)) (numV 150))
(test (eval (parse '(f false)) (extend-env 'f f_cond_curry_true_2 empty-env)) (numV 100))

(test (eval (parse '(f true)) (extend-env 'f f_cond_curry_false_2 empty-env)) (numV 50))
(test (eval (parse '(f false)) (extend-env 'f f_cond_curry_false_2 empty-env)) (numV 0))

;; se crean las versiones uncurrificadas
(define f_sub_uncurry (eval (parse (list 'uncurry f_sub_curry_s))     
                                (extend-env 'uncurry uncurry* empty-env))) 

(define f_cond_uncurry (eval (parse (list 'uncurry f_cond_curry_s))     
                                (extend-env 'uncurry uncurry* empty-env))) 

;; se testea que funcionen apropiadamente
(test (eval (parse '(f 4 3)) (extend-env 'f f_sub_uncurry empty-env)) (numV 1))
(test (eval (parse '(f 3 4)) (extend-env 'f f_sub_uncurry empty-env)) (numV -1))
(test (eval (parse '(f 8 4)) (extend-env 'f f_sub_uncurry empty-env)) (numV 4))
(test (eval (parse '(f 4 8)) (extend-env 'f f_sub_uncurry empty-env)) (numV -4))

(test (eval (parse '(f false false)) (extend-env 'f f_cond_uncurry empty-env)) (numV 0))
(test (eval (parse '(f false true)) (extend-env 'f f_cond_uncurry empty-env)) (numV 50))
(test (eval (parse '(f true false)) (extend-env 'f f_cond_uncurry empty-env)) (numV 100))
(test (eval (parse '(f true true)) (extend-env 'f f_cond_uncurry empty-env)) (numV 150))


#| partial* |#
(define my-program-f_sub_200 (parse (list 'partial f_sub 200)))  
(define my-program-f_sub_15 (parse (list 'partial f_sub 15)))

(define my-program-f_cond_true (parse (list 'partial f_cond 'true)))
(define my-program-f_cond_false (parse (list 'partial f_cond 'false)))

(define f_sub_partial_200 (eval my-program-f_sub_200     
                            (extend-env 'partial partial* empty-env)))  

(define f_sub_partial_15 (eval my-program-f_sub_15     
                            (extend-env 'partial partial* empty-env)))  

(define f_cond_partial_true (eval my-program-f_cond_true     
                            (extend-env 'partial partial* empty-env)))  

(define f_cond_partial_false (eval my-program-f_cond_false     
                            (extend-env 'partial partial* empty-env)))  

(test (eval (parse '(f 10)) (extend-env 'f f_sub_partial_200 empty-env)) (numV 190))
(test (eval (parse '(f 100)) (extend-env 'f f_sub_partial_200 empty-env)) (numV 100))
(test (eval (parse '(f 210)) (extend-env 'f f_sub_partial_200 empty-env)) (numV -10))

(test (eval (parse '(f 10)) (extend-env 'f f_sub_partial_15 empty-env)) (numV 5))
(test (eval (parse '(f 100)) (extend-env 'f f_sub_partial_15 empty-env)) (numV -85))
(test (eval (parse '(f 210)) (extend-env 'f f_sub_partial_15 empty-env)) (numV -195))

(test (eval (parse '(f true)) (extend-env 'f f_cond_partial_true empty-env)) (numV 150))
(test (eval (parse '(f false)) (extend-env 'f f_cond_partial_true empty-env)) (numV 100))

(test (eval (parse '(f true)) (extend-env 'f f_cond_partial_false empty-env)) (numV 50))
(test (eval (parse '(f false)) (extend-env 'f f_cond_partial_false empty-env)) (numV 0))


#| Parte B |#

(define sum* (closureV
                (list 'x 'y)
                (add (id 'x) (id 'y))
                empty-env))

(define sub* (closureV
                (list 'x 'y)
                (sub (id 'x) (id 'y))
                empty-env))

(define mul* (closureV
                (list 'x 'y)
                (mul (id 'x) (id 'y))
                empty-env))


(define globals ( list
                    (cons 'swap swap*)
                    (cons 'curry curry*)
                    (cons 'uncurry uncurry*)
                    (cons 'partial partial* )))

(define globals2 ( list
                    (cons 'swap swap*)
                    (cons 'curry curry*)
                    (cons 'uncurry uncurry*)
                    (cons 'partial partial* )
                    (cons 'sum sum*)
                    (cons 'sub sub*)
                    (cons 'mul mul*)))

(test (global-f_names (list )) (list ))
(test (global-f_names globals) (list 'swap 'curry 'uncurry 'partial))
(test (global-f_names globals2) (list 'swap 'curry 'uncurry 'partial 'sum 'sub 'mul))




 
                        