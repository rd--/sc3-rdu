;; (dust-r rate lo hi)

;; dust-r generates triggers where the inter-offset times are
;; generated randomly in the specified range (seconds) with linear
;; distribution.

(import (rsc3))

(define dust-r (mk-oscillator-id "DustR" (lo hi) 1))

(audition (out 0 (dust ar 1)))
(audition (out 0 (dust-r ar 0 2)))

(audition (out 0 (dust-r ar 1 1)))
(audition (out 0 (mul (impulse ar 1 0) (u:abs (white-noise ar)))))

(audition (out 0 (dust ar (/ 1 0.025))))
(audition (out 0 (dust-r ar 0 0.05)))

;; Courtesy Julian Rohrhuber, sc-dev/2006-January/009747.html
;; This seems a little flat, see related sc-dev post.

(define (dust-r* r lo hi)
  (let ((d (dseq dinf (make-mce (list (dwhite 1 lo hi))))))
    (t-duty r d 0 0 0 (u:abs (white-noise r)))))

(audition (out 0 (dust-r* ar 0.001 (mouse-x kr 0.001 1 1 0.1))))
(audition (out 0 (dust-r ar 0.001 (mouse-x kr 0.001 1 1 0.1))))

(audition (out 0 (mul (dust-r ar 0.001 0.001) (u:abs (white-noise ar)))))
(audition (out 0 (mul (dust-r* ar 0.001 0.001) (u:abs (white-noise ar)))))
(audition (out 0 (mul (impulse ar (/ 1 0.001) 0) (u:abs (white-noise ar)))))
