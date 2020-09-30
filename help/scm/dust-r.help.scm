; dust-r

(import (rsc3) (rsc3 dot))

(define dust-r (mk-oscillator-id "DustR" (lo hi) 1))

; density=1 ; mean-iot=1
(dust ar 1)
(dust-r ar 0.0001 2)

; impulse
(dust-r ar 1 1)
(mul (impulse ar 1 0) (u:abs (white-noise ar)))

(dust ar (/ 1 0.025))
(dust-r ar 0.0001 0.05)

; Courtesy Julian Rohrhuber, sc-dev/2006-January/009747.html
; This seems a little flat, see related sc-dev post.

(define (dust-r* rt lo hi)
  (let ((d (dseq dinf (make-mce (list (dwhite 1 lo hi))))))
    (t-duty rt d 0 0 (u:abs (white-noise rt)) 0)))

(dust-r* ar 0.001 (mouse-x kr 0.001 1 1 0.1))
(dust-r ar 0.001 (mouse-x kr 0.001 1 1 0.1))

(mul (dust-r ar 0.001 0.001) (u:abs (white-noise ar)))
(mul (dust-r* ar 0.001 0.001) (u:abs (white-noise ar)))
(mul (impulse ar (/ 1 0.001) 0) (u:abs (white-noise ar)))
