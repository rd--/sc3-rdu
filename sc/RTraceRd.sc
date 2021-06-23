RTraceRd : UGen {
 *ar { arg  bufnum = 0.0, degree = 4.0, index = 0.0, axis = 1.0, mul = 1.0, add = 0.0;
  ^this.multiNew('audio', bufnum, degree, index, axis).madd(mul, add);
 }
 *kr { arg  bufnum = 0.0, degree = 4.0, index = 0.0, axis = 1.0, mul = 1.0, add = 0.0;
  ^this.multiNew('control', bufnum, degree, index, axis).madd(mul, add);
 }
}
