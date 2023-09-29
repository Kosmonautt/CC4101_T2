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





