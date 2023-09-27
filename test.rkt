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


 





