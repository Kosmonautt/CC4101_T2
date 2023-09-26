#lang play
(require "T2.rkt")

(print-only-errors #t)

#| P1 |#

#| Parte A |#

(test (parse 1) (num 1))
(test (parse 155) (num 155))
(test (parse (list '+ 5 10)) (add (num 5) (num 10)))
(test (parse (list '+ 0 1)) (add (num 0) (num 1)))
(test (parse (list '- 2 2)) (sub (num 2) (num 2)))
(test (parse (list '+ 7 (list '- 6 3))) (add (num 7) (sub (num 6) (num 3))))
(test (parse (list '- 10 (list '- 3 3))) (sub (num 10) (sub (num 3) (num 3))))
(test (parse (list '* 10 2)) (mul (num 10) (num 2)))
(test (parse (list '* 10 (list '+ 1 1))) (mul (num 10) (add (num 1) (num 1))))
(test (parse (list '* (list '- 4 2) (list '+ 1 1))) (mul (sub (num 4) (num 2)) (add (num 1) (num 1))))


(test (parse true) (tt))
(test (parse false) (ff))




