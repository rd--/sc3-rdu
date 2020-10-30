; r-delay-map ; simple delay (static)
(let* ((b (clear-buf (local-buf 1 88200)))
       (x (mouse-x* kr 110 440 0 0.1))
       (y (mouse-y* kr 0.0 0.2 0 0.1))
       (s (mul (sin-osc ar x 0) y))
       (d (make-mce (list -1 0 0 0.5 1 -1 1 1))))
  (mce2 (r-delay-map b s 0 d) s))

; r-delay-map ; simple feedback circuit (static)
(let ((b (clear-buf (local-buf 1 88200)))
      (d (make-mce (list -1  0  0 1
                         1/9 0  1  8/9
                         1   -1 0 1)))
      (pulse (lambda (f) (mul (decay (impulse ar f 0) 0.1) (mul (white-noise ar) 0.2)))))
  (r-delay-map b (pulse 5/4) 0 d))

; r-delay-map ; simple feedback circuit (dynamic)
(let* ((b (clear-buf (local-buf 1 88200)))
       (x (mouse-x kr 0.05 1.05 0 0.1))
       (y (mouse-y kr 0.05 0.95 0 0.1))
       (d (make-mce (list -1  0 0 1
                          y  0 1 x
                          1 -1 0 1)))
       (pulse (lambda (f) (mul (decay (impulse ar f 0) 0.1) (mul (white-noise ar) 0.2)))))
  (r-delay-map b (pulse (mce2 1/3 5/4)) 1 d))
