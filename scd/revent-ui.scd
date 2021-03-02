(var s = Server.default
;var opt_draw_k_text = true
;var opt_draw_p_text = true
;var opt_draw_grid_x = false
;var opt_draw_grid_y = false
;var opt_draw_grid_p = true
;var opt_draw_grid_x_mp = false
;var opt_draw_grid_y_mp = false
;var opt_draw_grid_ln = true
;var opt_frame_rate = 60
;var sensel_w = 230 // mm
;var sensel_h = 130 // mm
;var sensel_mul = 5
;var grid_fn = "/home/rohan/sw/hsc3-util/cmd/B.csv" // R-01 I K C
;var grid_dat = CSVFileReader.readInterpret(grid_fn)
;var grid_n = grid_dat.size
;var grid_x = grid_dat.flop.at(2)
;var grid_y = grid_dat.flop.at(3).collect({arg y; 1.0 - y}) // INVERT
;var grid_p = (0 .. grid_n - 1).collect({arg i; grid_x[i] @ grid_y[i]})
;var grid_x_loc = grid_x.as(Set).as(Array).sort
;var grid_y_loc = grid_y.as(Set).as(Array).sort
;var midpoint_f = {arg x; if(x.size > 1,{(1 .. x.size - 1).collect({arg i; x[i-1] + ((x[i] - x[i-1]) / 2)})},{[]})}
;var grid_x_loc_mp = midpoint_f.value(grid_x_loc)
;var grid_y_loc_mp = midpoint_f.value(grid_y_loc)
;var grid_ln_dat = grid_dat.collect({arg e; if(e.size > 6,{e.copyRange(6,e.size-1).clump(2).collect({arg p; p[0] @ (1.0 - p[1])})},{[]})})
;var ev_k0 = 13000
;var ev_nparts = 16
;var ev_elem = 9
;var ev_incr = 10
;var ev_data = Array.fill(ev_nparts,{Array.fill(9,{0.0})})
;var b = Bus.new(rate: \control, index: ev_k0, numChannels: ev_nparts * ev_incr, server: s)
;var wn = Window("REvent", Rect(100, 100, sensel_w * sensel_mul, sensel_h * sensel_mul))
;var recv_f =
 {arg bus_data
 ;ev_nparts.do({arg i; ev_data[i] = bus_data.copyRange(i * ev_incr,i * ev_incr + ev_elem)})
 ;{wn.refresh}.defer}
;var draw_f =
 {var x_mul = sensel_h * sensel_mul // aspect ratio...
 ;var y_mul = sensel_h * sensel_mul
 ;var r_mul = 25
 ;if(opt_draw_grid_x,
  {Pen.strokeColor_(Color.grey(grey: 0.65,alpha: 0.5))
  ;grid_x_loc.do({arg x; Pen.moveTo((x * x_mul) @ 0); Pen.lineTo((x * x_mul) @ y_mul); Pen.stroke})})
 ;if(opt_draw_grid_y,
  {Pen.strokeColor_(Color.grey(grey: 0.65,alpha: 0.5))
  ;grid_y_loc.do({arg y; Pen.moveTo(0 @ (y * y_mul)); Pen.lineTo(x_mul @ (y * y_mul)); Pen.stroke})})
 ;if(opt_draw_grid_p,
  {Pen.fillColor_(Color.blue(val: 0.85,alpha: 0.25))
  ;grid_p.do(
   {arg p
   ;var r = 2.5
   ;var rect = Rect.new(left: (p.x * x_mul) - r, top: (p.y * y_mul) - r, width: r * 2, height: r * 2)
   ;Pen.fillOval(rect)})})
 ;if(opt_draw_grid_ln,
  {Pen.strokeColor_(Color.grey(grey: 0.65,alpha: 0.5))
  ;grid_ln_dat.do({arg c; var m = x_mul @ y_mul; Pen.moveTo(c[c.size - 1] * m); (0 .. c.size - 1).do({arg i; Pen.lineTo(c[i] * m)}); Pen.stroke})})
 ;if(opt_draw_grid_x_mp,
  {Pen.strokeColor_(Color.red(val: 0.85,alpha: 0.25))
  ;grid_x_loc_mp.do({arg x; Pen.moveTo((x * x_mul) @ 0); Pen.lineTo((x * x_mul) @ y_mul); Pen.stroke})})
 ;if(opt_draw_grid_y_mp,
  {Pen.strokeColor_(Color.red(val: 0.85,alpha: 0.25))
  ;grid_y_loc_mp.do({arg y; Pen.moveTo(0 @ (y * y_mul)); Pen.lineTo(x_mul @ (y * y_mul)); Pen.stroke})})
 ;ev_data.do(
  {arg e, k
  ;if(e[0] > 0,
   {var x = e[1] * x_mul
   ;var y = (1.0 - e[2]) * y_mul
   ;var r = 5 + (e[3] * r_mul)
   ;var rect = Rect.new(left: x - r, top: y - r, width: r * 2, height: r * 2)
   ;var rx = 0.5 + (e[5] * 35)
   ;var ry = 0.5 + (e[6] * 35)
   ;Pen.strokeColor_(Color.black)
   ;Pen.strokeOval(rect)
   ;if(opt_draw_p_text,
    {var text_rect = Rect.new(left: x - (r_mul * 3), top: y - (r_mul * 2), width: r_mul * 6, height: r_mul * 2)
    ;Pen.stringCenteredIn((e[7] + e[8]).round(0.01).asString, text_rect, Font.sansSerif(size: 9), Color.black)})
   ;if(opt_draw_k_text,
    {var text_rect = Rect.new(left: x - (r_mul * 3), top: y + (r_mul * 0.25), width: r_mul * 6, height: r_mul * 2)
    ;Pen.stringCenteredIn(k.asString, text_rect, Font.sansSerif(size: 11), Color.black)})
   ;Pen.use(
    {Pen.rotate(e[4] * 2 * pi, x, y)
    ;Pen.strokeRect(rect)
    ;Pen.moveTo((x - (rx / 2)) @ y)
    ;Pen.lineTo((x + (rx / 2)) @ y)
    ;Pen.stroke
    ;Pen.moveTo(x @ (y + (ry / 2)))
    ;Pen.lineTo(x @ (y - (ry / 2)))
    ;Pen.stroke})})})}
;var get_rt = {inf.do({b.get(recv_f); (1 / opt_frame_rate).wait})}.fork
;wn.drawFunc_(draw_f)
;wn.onClose_({get_rt.stop})
;wn.front
)