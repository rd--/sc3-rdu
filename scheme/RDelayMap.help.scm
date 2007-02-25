;; UGen definit-1n

(define-filter* RDelayMap (bufnum in dyn specArray) 1)

;; Allocate buffer

(->< s (/b_alloc 0 88200 1))

;; Simple delay (static)

(let* ((x (MouseX kr 110 440 0 0.1))
       (y (MouseY kr 0.0 0.2 0 0.1))
       (s (Mul (SinOsc ar x 0) y)))
  (Mce (RDelayMap 0 s 0
		  (Mce -1 0 0 0.5
		       1 -1 1 1))
       s))

;; Simple feedback circuit (static)

(define (pulse f)
  (Mul (Decay (Impulse ar f 0) 0.1)
       (Mul (WhiteNoise ar) 0.2)))

(->< s (/b_zero 0))

(RDelayMap 0 (pulse 5/4) 0
	   (Mce -1  0  0 1
		1/9 0  1  8/9
		1   -1 0 1))

;; Simple feedback circuit (dynamic)

(->< s (/b_zero 0))

(let ((x (MouseX kr 0.05 1.05 0 0.1))
      (y (MouseY kr 0.05 0.95 0 0.1)))
  (RDelayMap 0 (pulse (Mce 1/3 5/4)) 1
	     (Mce -1 0  0 1
		  y  0  1  x
		  1  -1 0 1)))

(->< s (/b_free 0))
