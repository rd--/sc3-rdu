(import (rsc3) (rsc3 dot))

; simple delay (static)
(define g-01
 (let* ((b (clear-buf (local-buf 1 88200)))
        (x (mouse-x* kr 110 440 0 0.1))
	(y (mouse-y* kr 0.0 0.2 0 0.1))
	(s (mul (sin-osc ar x 0) y))
	(d (make-mce (list -1 0 0 0.5 1 -1 1 1))))
   (mce2 (r-delay-map b s 0 d) s)))

(define pulse
  (lambda (f)
    (mul (decay (impulse ar f 0) 0.1)
         (mul (white-noise ar) 0.2))))

; simple feedback circuit (static)
(define g-02
 (let ((b (clear-buf (local-buf 1 88200)))
       (d (make-mce (list -1  0  0 1
                          1/9 0  1  8/9
                          1   -1 0 1))))
   (r-delay-map b (pulse 5/4) 0 d)))

; simple feedback circuit (dynamic)
(define g-03
 (let* ((b (clear-buf (local-buf 1 88200)))
        (x (mouse-x kr 0.05 1.05 0 0.1))
	(y (mouse-y kr 0.05 0.95 0 0.1))
	(d (make-mce (list -1  0 0 1
                            y  0 1 x
                            1 -1 0 1))))
   (r-delay-map b (pulse (mce2 1/3 5/4)) 1 d)))
