;; UGen definition

(define r-delay-map (mk-filter-mce "RDelayMap" (buf in dyn spec-array) 1))

;; Allocate buffer

(with-sc3 
 (lambda (fd) 
   (async fd (b-alloc 0 88200 1))))

;; Simple delay (static)

(audition
 (let* ((x (mouse-x kr 110 440 0 0.1))
	(y (mouse-y kr 0.0 0.2 0 0.1))
	(s (mul (sin-osc ar x 0) y))
	(d (make-mce (list -1 0 0 0.5
                           1 -1 1 1))))
   (out 0 (mce2 (r-delay-map 0 s 0 d) s))))

;; Simple feedback circuit (static)

(define (pulse f)
  (mul (decay (impulse ar f 0) 0.1)
       (mul (white-noise ar) 0.2)))

(with-sc3 
 (lambda (fd) 
   (async fd (b-zero 0))))

(audition
 (let ((d (make-mce (list -1  0  0 1
                          1/9 0  1  8/9
                          1   -1 0 1))))
   (out 0 (r-delay-map 0 (pulse 5/4) 0 d))))

;; Simple feedback circuit (dynamic)

(with-sc3 
 (lambda (fd) 
   (async fd (b-zero 0))))

(audition
 (let* ((x (mouse-x kr 0.05 1.05 0 0.1))
	(y (mouse-y kr 0.05 0.95 0 0.1))
	(d (make-mce (list -1 0 0 1
                           y  0 1 x
                           1 -1 0 1))))
   (out 0 (r-delay-map 0 (pulse (mce2 1/3 5/4)) 1 d))))

(with-sc3 
 (lambda (fd) 
   (async fd (b-free 0))))
