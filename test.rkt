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



