(var s = Server.default
;var opt_draw_text = false
;var opt_draw_grid = true
;var opt_draw_grid_mp = false
;var sensel_w = 230 // mm
;var sensel_h = 130 // mm
;var sensel_mul = 5
;var grid_fn = "/home/rohan/sw/hsc3-util/cmd/R-01.csv"
;var grid_dat = CSVFileReader.readInterpret(grid_fn)
;var grid_x_loc = grid_dat.flop.at(2).as(Set).as(Array).sort
;var midpoint_f = {arg x; (1 .. x.size - 1).collect({arg i; x[i-1] + ((x[i] - x[i-1]) / 2)})}
;var grid_x_loc_mp = midpoint_f.value(grid_x_loc)
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
 {var x_mul = sensel_w * sensel_mul
 ;var y_mul = sensel_h * sensel_mul
 ;var r_mul = 25
 ;if(opt_draw_grid,
  {Pen.strokeColor_(Color.grey(grey: 0.65,alpha: 0.5))
  ;grid_x_loc.do({arg x; Pen.moveTo((x * x_mul) @ 0); Pen.lineTo((x * x_mul) @ y_mul)
  ;Pen.stroke})})
 ;if(opt_draw_grid_mp,
  {Pen.strokeColor_(Color.red(val: 0.85,alpha: 0.25))
  ;grid_x_loc_mp.do({arg x; Pen.moveTo((x * x_mul) @ 0); Pen.lineTo((x * x_mul) @ y_mul)
  ;Pen.stroke})})
 ;ev_data.do(
  {arg e
  ;if(e[0] > 0,
   {var x = e[1] * x_mul
   ;var y = (1.0 - e[2]) * y_mul
   ;var r = 5 + (e[3] * r_mul)
   ;var rect = Rect.new(left: x - r, top: y - r, width: r * 2, height: r * 2)
   ;var rx = 0.5 + (e[5] * 35)
   ;var ry = 0.5 + (e[6] * 35)
   ;Pen.strokeColor_(Color.black)
   ;Pen.strokeOval(rect)
   ;if(opt_draw_text,
    {var text_rect = Rect.new(left: x - (r_mul * 3), top: y - (r_mul * 2), width: r_mul * 6, height: r_mul * 2)
    ;Pen.stringCenteredIn((e[7] + e[8]).round(0.01).asString, text_rect, Font.sansSerif(size: 8), Color.black)})
   ;Pen.use(
    {Pen.rotate(e[4] * 2 * pi, x, y)
    ;Pen.strokeRect(rect)
    ;Pen.moveTo((x - (rx / 2)) @ y)
    ;Pen.lineTo((x + (rx / 2)) @ y)
    ;Pen.stroke
    ;Pen.moveTo(x @ (y + (ry / 2)))
    ;Pen.lineTo(x @ (y - (ry / 2)))
    ;Pen.stroke})})})}
;var frame_rate = 60
;var get_rt = {inf.do({b.get(recv_f); (1 / frame_rate).wait})}.fork
;wn.drawFunc_(draw_f)
;wn.onClose_({get_rt.stop})
;wn.front
;[grid_x_loc,grid_x_loc_mp].postln)
