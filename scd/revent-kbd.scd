// debian: to turn key repeat off: xset r off
(var s = Server.default
;var wn = Window.new("revent-kbd", bounds: Rect.new(100, 100, 900, 300),resizable: false)
;var tx = TextView.new(wn).minHeight_(12 * 12)
;var key_coord = Dictionary.newFrom([$ , 0.3667 @ 0.1000,$z, 0.1000 @ 0.3000,$x, 0.1667 @ 0.3000,$c, 0.2333 @ 0.3000,$v, 0.3000 @ 0.3000,$b, 0.3667 @ 0.3000,$n, 0.4333 @ 0.3000,$m, 0.5000 @ 0.3000,$,, 0.5667 @ 0.3000,$., 0.6333 @ 0.3000,$/, 0.7000 @ 0.3000,$a, 0.1000 @ 0.5000,$s, 0.1667 @ 0.5000,$d, 0.2333 @ 0.5000,$f, 0.3000 @ 0.5000,$g, 0.3667 @ 0.5000,$h, 0.4333 @ 0.5000,$j, 0.5000 @ 0.5000,$k, 0.5667 @ 0.5000,$l, 0.6333 @ 0.5000,$;, 0.7000 @ 0.5000,$', 0.7667 @ 0.5000,$\r, 0.8333 @ 0.5000,$\t, 0.0333 @ 0.7000,$q, 0.1000 @ 0.7000,$w, 0.1667 @ 0.7000,$e, 0.2333 @ 0.7000,$r, 0.3000 @ 0.7000,$t, 0.3667 @ 0.7000,$y, 0.4333 @ 0.7000,$u, 0.5000 @ 0.7000,$i, 0.5667 @ 0.7000,$o, 0.6333 @ 0.7000,$p, 0.7000 @ 0.7000,$[, 0.7667 @ 0.7000,$], 0.8333 @ 0.7000,$`, 0.0333 @ 0.9000,$1, 0.1000 @ 0.9000,$2, 0.1667 @ 0.9000,$3, 0.2333 @ 0.9000,$4, 0.3000 @ 0.9000,$5, 0.3667 @ 0.9000,$6, 0.4333 @ 0.9000,$7, 0.5000 @ 0.9000,$8, 0.5667 @ 0.9000,$9, 0.6333 @ 0.9000,$0, 0.7000 @ 0.9000,$-, 0.7667 @ 0.9000,$=, 0.8333 @ 0.9000,$\v, 0.9000 @ 0.9000])
;var key_mnn = Dictionary.newFrom([$ , 48.0000,$z, 49.0000,$x, 50.0000,$c, 51.0000,$v, 52.0000,$b, 53.0000,$n, 54.0000,$m, 55.0000,$,, 56.0000,$., 57.0000,$/, 58.0000,$a, 59.0000,$s, 60.0000,$d, 61.0000,$f, 62.0000,$g, 63.0000,$h, 64.0000,$j, 65.0000,$k, 66.0000,$l, 67.0000,$;, 68.0000,$', 69.0000,$\r, 70.0000,$\t, 71.0000,$q, 72.0000,$w, 73.0000,$e, 74.0000,$r, 75.0000,$t, 76.0000,$y, 77.0000,$u, 78.0000,$i, 79.0000,$o, 80.0000,$p, 81.0000,$[, 82.0000,$], 83.0000,$`, 84.0000,$1, 85.0000,$2, 86.0000,$3, 87.0000,$4, 88.0000,$5, 89.0000,$6, 90.0000,$7, 91.0000,$8, 92.0000,$9, 93.0000,$0, 94.0000,$-, 95.0000,$=, 96.0000,$\v, 97.0000])
;var vc_free_list = LinkedList.newFrom((0 .. 15))
;var vc_dict = Dictionary.new(16)
;var vc_alloc = {arg char; var k = vc_free_list.popFirst; vc_dict.put(k,char); k}
;var vc_free = {arg char; var k = vc_dict.findKeyForValue(char); if(k.notNil,{vc_dict.removeAt(k); vc_free_list.add(k)}); k}
;tx.keyDownAction_(
 {arg view, char, modifiers, unicode, keycode, key
 ;var k = vc_alloc.(char)
 ;var c = key_coord.at(char)
 ;if(c.notNil,{s.sendMsg("/c_setn",13000 + (k * 10),10,1.0,c.x,c.y,0.25,0.5,0.5,0.5,key_mnn.at(char),0.0,0.0)})
 ;["down",[char],k,c,vc_free_list,vc_dict].postln})
;tx.keyUpAction_(
 {arg view, char, modifiers, unicode, keycode, key
 ;var k = vc_free.(char)
 ;var c = key_coord.at(char)
 ;if(c.notNil,{s.sendMsg("/c_setn",13000 + (k * 10),10,0.0,c.x,c.y,0.0,0.0,0.0,0.0,key_mnn.at(char),0.0,0.0)})
 ;["up",char,k,c,vc_free_list,vc_dict].postln})
;wn.layout = VLayout.new(tx)
;wn.front)
