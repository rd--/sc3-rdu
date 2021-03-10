(var s = Server.default
;var opt_draw_index_text = true
;var opt_draw_pitch_text = true
;var opt_draw_grid_x = false
;var opt_draw_grid_y = false
;var opt_draw_grid_point = true
;var opt_draw_grid_circle = true
;var opt_draw_grid_text = true
;var opt_draw_grid_polygon = true
;var opt_frame_rate = 60
;var opt_aspect = 'i' // aspect ratio: i | x | y
;var sensel_w = 230 // mm
;var sensel_h = 130 // mm
;var sensel_mul = 5
;var x_mul = if(opt_aspect == \y,{sensel_h * sensel_mul},{sensel_w * sensel_mul})
;var y_mul = if(opt_aspect == \x,{sensel_w * sensel_mul},{sensel_h * sensel_mul})
;var x_to_scr = {arg x; x * x_mul}
;var y_to_scr = {arg y; y_mul - (y * y_mul)}
;var pt_to_scr = {arg p; x_to_scr.(p.x) @ y_to_scr.(p.y)}
;var grid_fn = "/home/rohan/sw/hsc3-util/cmd/C.csv"
;var grid_dat = CSVFileReader.readInterpret(grid_fn)
;var grid_n = grid_dat.size
;var grid_x = grid_dat.flop.at(2)
;var grid_y = grid_dat.flop.at(3)
;var grid_p = (0 .. grid_n - 1).collect({arg i; grid_x[i] @ grid_y[i]})
;var grid_w = grid_dat.flop.at(5)
;var grid_h = grid_dat.flop.at(6)
;var grid_txt = grid_dat.flop.at(7)
;var grid_x_loc = grid_x.as(Set).as(Array).sort
;var grid_y_loc = grid_y.as(Set).as(Array).sort
;var grid_ln_dat = grid_dat.collect({arg e; if(e.size > 9,{e.copyRange(9,e.size-1).clump(2).collect({arg p; p[0] @ p[1]})},{[]})})
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
 {var r_mul = 25
 ;if(opt_draw_grid_x,
  {Pen.strokeColor_(Color.grey(grey: 0.65,alpha: 0.5))
  ;grid_x_loc.do({arg x; Pen.moveTo(x_to_scr.(x) @ 0); Pen.lineTo(x_to_scr.(x) @ y_to_scr.(y)); Pen.stroke})})
 ;if(opt_draw_grid_y,
  {Pen.strokeColor_(Color.grey(grey: 0.65,alpha: 0.5))
  ;grid_y_loc.do({arg y; Pen.moveTo(0 @ y_to_scr.(y)); Pen.lineTo(x_to_scr.(1) @ y_to_scr.(y)); Pen.stroke})})
 ;if(opt_draw_grid_point,
  {Pen.fillColor_(Color.blue(val: 0.85,alpha: 0.25))
  ;grid_p.do(
   {arg p
   ;var r = 2.5
   ;var rect = Rect.new(left: x_to_scr.(p.x) - r, top: y_to_scr.(p.y) - r, width: r * 2, height: r * 2)
   ;Pen.fillOval(rect)})})
 ;if(opt_draw_grid_circle,
  {Pen.strokeColor_(Color.grey(grey: 0.35,alpha: 0.25))
  ;(0 .. grid_n - 1).do(
   {arg i
   ;var p = grid_p[i]
   ;var w = grid_w[i] * x_mul
   ;var h = grid_h[i] * y_mul
   ;var rect = Rect.new(left: x_to_scr.(p.x) - (w / 2), top: y_to_scr.(p.y) - (h / 2), width: w, height: h)
   ;[p,w,h].postln
   ;Pen.strokeOval(rect)})})
 ;if(opt_draw_grid_text,
  {Pen.strokeColor_(Color.grey(grey: 0.35,alpha: 0.25))
  ;(0 .. grid_n - 1).do(
   {arg i
   ;var p = grid_p[i]
   ;var w = grid_w[i] * x_mul
   ;var h = grid_h[i] * y_mul
   ;var txt = grid_txt[i]
   ;var rect = Rect.new(left: x_to_scr.(p.x) - (w / 2), top: y_to_scr.(p.y) - 24, width: w, height: 12)
   ;Pen.stringCenteredIn(txt, rect, Font.sansSerif(size: 9), Color.black)})})
 ;if(opt_draw_grid_polygon,
  {Pen.strokeColor_(Color.grey(grey: 0.65,alpha: 0.5))
  ;grid_ln_dat.do({arg c; Pen.moveTo(pt_to_scr.(c[c.size - 1])); (0 .. c.size - 1).do({arg i; Pen.lineTo(pt_to_scr.(c[i]))}); Pen.stroke})})
 ;ev_data.do(
  {arg e, k
  ;if(e[0] > 0,
   {var x = x_to_scr.(e[1])
   ;var y = y_to_scr.(e[2])
   ;var r = 5 + (e[3] * r_mul)
   ;var rect = Rect.new(left: x - r, top: y - r, width: r * 2, height: r * 2)
   ;var rx = 0.5 + (e[5] * 35)
   ;var ry = 0.5 + (e[6] * 35)
   ;Pen.strokeColor_(Color.black)
   ;Pen.strokeOval(rect)
   ;if(opt_draw_pitch_text,
    {var text_rect = Rect.new(left: x - (r_mul * 3), top: y - (r_mul * 2), width: r_mul * 6, height: r_mul * 2)
    ;Pen.stringCenteredIn((e[7] + e[8]).round(0.01).asString, text_rect, Font.sansSerif(size: 9), Color.black)})
   ;if(opt_draw_index_text,
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
