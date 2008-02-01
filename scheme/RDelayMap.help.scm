;; UGen definition

(define-filter* RDelayMap (bufnum in dyn specArray) 1)

;; Allocate buffer

(with-sc3 
 (lambda (fd) 
   (->< fd (/b_alloc 0 88200 1))))

;; Simple delay (static)

(audition
 (let* ((x (MouseX kr 110 440 0 0.1))
	(y (MouseY kr 0.0 0.2 0 0.1))
	(s (Mul (SinOsc ar x 0) y))
	(d (Mce -1 0 0 0.5
		1 -1 1 1)))
   (Out 0 (Mce (RDelayMap 0 s 0 d) s))))

;; Simple feedback circuit (static)

(define (pulse f)
  (Mul (Decay (Impulse ar f 0) 0.1)
       (Mul (WhiteNoise ar) 0.2)))

(with-sc3 
 (lambda (fd) 
   (->< fd (/b_zero 0))))

(audition
 (let ((d (Mce -1  0  0 1
	       1/9 0  1  8/9
	       1   -1 0 1)))
   (Out 0 (RDelayMap 0 (pulse 5/4) 0 d))))

;; Simple feedback circuit (dynamic)

(with-sc3 
 (lambda (fd) 
   (->< fd (/b_zero 0))))

(audition
 (let* ((x (MouseX kr 0.05 1.05 0 0.1))
	(y (MouseY kr 0.05 0.95 0 0.1))
	(d (Mce -1 0 0 1
		y  0 1 x
		1 -1 0 1)))
   (Out 0 (RDelayMap 0 (pulse (Mce 1/3 5/4)) 1 d))))

(with-sc3 
 (lambda (fd) 
   (->< fd (/b_free 0))))
