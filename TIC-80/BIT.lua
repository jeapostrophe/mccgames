-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua

t=0
x=96
y=24

function TIC()

	if btn(0) then y=y-1 end
	if btn(1) then y=y+1 end
	if btn(2) then x=x-1 end
	if btn(3) then x=x+1 end

	cls(13)
	spr(1+t%60//30*2,x,y,14,3,0,0,2,2)
	print("HELLO WORLD!",84,84)
	t=t+1
end

-- <TILES>
-- 001:0000000000000000000000000000000000000000000700000000000000000000
-- 002:aaa0aaa000000000a0aaa0a000000000aaa0aaa000000000a0aaa0a000000000
-- 003:aaa0aaa000000000a0aaa0a00000000000000000000700000000000000000000
-- 004:aaa0aaa000000000a0aaa0a00000000000000000007700400777700000000000
-- 005:aaa0aaa000000000a0aaa0a000000000000b0b000b0b0b000b00000000000000
-- 006:aa00a0a000000000a0aa00a00000000000000000000700000000000000000000
-- 007:1010101000000000101010100000000010101010000000001010101000000000
-- 008:000000000aaaaaa00a0000a00a0000a00aaaaaa0000000000444444000000000
-- 009:000000000000000000a0770000007700077000000770a0000000000000000000
-- 010:00000000000000000000000000a0a0000000000000a0a0000000000000000000
-- 011:000000000b0000b00b0000b0000b0000000b0b000b0b0b000b00000000000000
-- 012:000000000b0b00400b0000000000b0000000b0b00b0000b00b0400b000000000
-- 013:3000000030330000303303300033033030000330303300003033033000000000
-- 014:7777777000000000770000007707700077077070770770707707707000000000
-- 015:6066606006000600606060606000006060606060060006006066606000000000
-- 016:0000000000000000000000000000000000000aa00000aaa00000aaa000000000
-- 017:00000000000000000000000000000000aaaaaaa0aaaaaaa0aaaaaaa000000000
-- 018:00000000000000000000000000000000aa000000aaa00000aaa0000000000000
-- 019:0aaaaaa0aaaaaaa0aaaaaaa0aaa00000aaa00000aaa00000aaa0000000000000
-- 020:aaaaaa00aaaaaaa0aaaaaaa00000aaa00000aaa00000aaa00000aaa000000000
-- 021:0aaaaaa0aaaaaaa0aaaaaaa0aaa00000aaa0aaa0aaa0aaa0aaa0aaa000000000
-- 022:0aaaaa00aaaaaaa0aaaaaaa0aaa0aaa0aaa0aaa0aaa0aaa0aaa0aaa000000000
-- 023:aaaaaa00aaaaaaa0aaaaaaa00000aaa0aaa0aaa0aaa0aaa0aaa0aaa000000000
-- 024:aaa0aaa0aaa0aaa0aaa00aa0aaa00000aaa00aa0aaa0aaa0aaa0aaa000000000
-- 025:aaaaaaa0aaaaaaa0aaaaaaa000000000aa000aa0aaa0aaa0aaa0aaa000000000
-- 026:0000aaa00000aaa000000aa000000000aa000aa0aaa0aaa0aaa0aaa000000000
-- 027:aaa00000aaa00000aa00000000000000aa000aa0aaa0aaa0aaa0aaa000000000
-- 028:aaaaaaa0aaaaaaa0aaaaaaa00000000000000aa00000aaa00000aaa000000000
-- 029:0000aaa00000aaa00000aaa00000aaa0aa00aaa0aaa0aaa0aaa0aaa000000000
-- 030:0000aaa00000aaa000000aa000000000aaaaaaa0aaaaaaa0aaaaaaa000000000
-- 031:aaa00000aaa00000aaa00000aaa00000aaa00aa0aaa0aaa0aaa0aaa000000000
-- 032:0000aaa00000aaa00000aaa00000aaa00000aaa00000aaa00000aaa000000000
-- 033:0aaaaa00aaaaaaa0aaaaaaa0aaa0aaa0aaaaaaa0aaaaaaa00aaaaa0000000000
-- 034:aaa00000aaa00000aaa00000aaa00000aaa00000aaa00000aaa0000000000000
-- 035:aaa00000aaa00000aaa00000aaa00000aaaaaaa0aaaaaaa00aaaaaa000000000
-- 036:0000aaa00000aaa00000aaa00000aaa0aaaaaaa0aaaaaaa0aaaaaa0000000000
-- 037:0aaaaaa0aaaaaaa0aaaaaaa0aaa00000aaaaaaa0aaaaaaa00aaaaaa000000000
-- 038:aaa0aaa0aaa0aaa0aa000aa000000000aa000aa0aaa0aaa0aaa0aaa000000000
-- 039:aaaaaa00aaaaaaa0aaaaaaa00000aaa0aaaaaaa0aaaaaaa0aaaaaa0000000000
-- 040:aaa0aaa0aaa0aaa0aa000aa000000000aaaaaaa0aaaaaaa0aaaaaaa000000000
-- 041:aaa0aaa0aaa0aaa0aa00aaa00000aaa0aa00aaa0aaa0aaa0aaa0aaa000000000
-- 042:aaa0aaa0aaa0aaa0aa000aa00000000000000aa00000aaa00000aaa000000000
-- 043:aaa0aaa0aaa0aaa0aa000aa000000000aa000000aaa00000aaa0000000000000
-- 044:aaa0aaa0aaa0aaa0aaa00aa0aaa00000aaa00000aaa00000aaa0000000000000
-- 045:aaa00000aaa00000aa00000000000000aaaaaaa0aaaaaaa0aaaaaaa000000000
-- 046:aaa0aaa0aaa0aaa0aa00aaa00000aaa00000aaa00000aaa00000aaa000000000
-- 047:aaaaaaa0aaaaaaa0aaaaaaa000000000aa000000aaa00000aaa0000000000000
-- 048:0000aaa00000aaa000000aa00000000000000000000000000000000000000000
-- 049:aaaaaaa0aaaaaaa0aaaaaaa00000000000000000000000000000000000000000
-- 050:aaa00000aaa00000aa0000000000000000000000000000000000000000000000
-- 051:aaaaaaa0aaaaaaa0aaaaaaa000000000aaaaaaa0aaaaaaa0aaaaaaa000000000
-- 052:aaa0aaa0aaa0aaa0aaa0aaa0aaa0aaa0aaa0aaa0aaa0aaa0aaa0aaa000000000
-- 053:aaa0aaa0aaa0aaa0aaa0aaa0aaa00000aaaaaaa0aaaaaaa00aaaaaa000000000
-- 054:aaa0aaa0aaa0aaa0aaa0aaa0aaa0aaa0aaaaaaa0aaaaaaa00aaaaa0000000000
-- 055:aaa0aaa0aaa0aaa0aaa0aaa00000aaa0aaaaaaa0aaaaaaa0aaaaaa0000000000
-- 056:0000aaa00000aaa000000aa000000000aa000000aaa00000aaa0000000000000
-- 057:aaa00000aaa00000aa0000000000000000000aa00000aaa00000aaa000000000
-- 058:0000aaa00000aaa000000aa00000000000000aa00000aaa00000aaa000000000
-- 059:00000000000000000000000000000000aa000aa0aaa0aaa0aaa0aaa000000000
-- 060:aaa0aaa0aaa0aaa0aa000aa00000000000000000000000000000000000000000
-- 061:aaa00000aaa00000aa00000000000000aa000000aaa00000aaa0000000000000
-- 062:7000000070770000707707700077077070000770707700007077077000000000
-- 063:00444000400000400044400040494040404e4040404440404044404000000000
-- 064:0600000090000000e90000000000000044000000000700004000000000000000
-- 065:00000000090000009e0000000000000044000000000700004000000000000000
-- 066:0000060000000090000009e00000000000000440000700000000004000000000
-- 067:000000000000090000000e900000000000000440000700000000004000000000
-- 068:0000000000000000000000000060600006f66600006660000006000000000000
-- 069:000000000060600000f660000066600000666000000600000000000000000000
-- 070:000000000000000000000000000000000060600006f666000066600000000000
-- 071:0000000000000550000055500500550000500000005500505055050000000000
-- 072:1010101000000000102220100020200010222010000000001010101000000000
-- 073:5005000005050050005505000000000055000005005055000500505000000000
-- 074:0000000000400000000004000000000000000000000400000000000000000000
-- 075:0000000000000070004007700000000000000000007700400777700000000000
-- 076:0000000000900000000009000900000000099000009009000099900000000000
-- 077:0000000000800800000880000880880008800000008880000888880000000000
-- 078:0030030000033000003003000330300003300000003330000333330000000000
-- 079:0000000000300300000330000330330003300000003330000333330000000000
-- 080:0000000000f0f000f0fff0f00fffff00fff0fff000000000fffffff000000000
-- 081:000000000f0f0f0000fff000fffffff00ff0ff0000000000fffffff000000000
-- 082:000000000000000000000000000a0000aa000aa0aaaaaaa0aaaaaaa000000000
-- 083:0000000000000000707070700000000000000000000000000000000000000000
-- 084:0099900009000900090009000099900009449900099999000099900000000000
-- 085:0099900009000900090009009499949099449990099999000099900000000000
-- 086:0700070070070070707770707007007070070070000000007077707000000000
-- 087:000000000aaaaaa00a4444a00a4ee4a00aaeeaa0000000000444444000000000
-- 088:0000000000007000000770700700770077707770000000007777777000000000
-- 089:7777777000000000777777700000000000000000000700000000000000000000
-- 090:aaa0aaa000000000a00000a000000000a00000a000000000a0aaa0a000000000
-- 091:3330333000000000303330300000000033303330000000003033303000000000
-- 092:1010101000000000102220100060600016f66610006660001016101000000000
-- 096:0000000000000000000000000000000000000000070007000077700000000000
-- 097:0000aaa00000aaa000000aa0000a0aa000000aa00000aaa00000aaa000000000
-- 098:0000000000000000000070000000000000007000000000000000700000000000
-- 099:aaa00000aaa00000aa000000aa0a0000aa000000aaa00000aaa0000000000000
-- 100:0000000000000000007000000000000000700000000000000070000000000000
-- 101:0000000000000000000000000fee00000e0eeee00eee0e000000000000000000
-- 102:00000000000000000fee00000e0eeee00eee0e00000000000000000000000000
-- 103:000000000000000000000000000000000fee00000e0eeee00eee0e0000000000
-- 104:0000000000000000000000000fee00000e0eeee00eee0e000000000000000000
-- 105:0aaaaa00aaaaaaa0aaaaaaa0a00000a000000000000000000000000000000000
-- 106:4040404000000000040404004040404044444440040404004444444000000000
-- 112:0000000000000000000000000000000000000000000000007000007007777700
-- 113:0000000000000000000000000000000000000000000000000000000077777770
-- 114:aaaaaaa0aaaaaaa0aa000aa0000a000000000000000000000000000000000000
-- 115:0000000000000000000000000000000000000000000000007070707000000000
-- 116:00000000000a000000aaa0000a0a0a00000a0000000000000000000000000000
-- 117:00000000000a00000000a0000aaaaa0000000000000000000000000000000000
-- 118:0000000000000a0000070a0007770a0000000000000000000000000000000000
-- 119:000000000000a00000000a0007070aa000000000000000000000000000000000
-- 120:00000000000a0000000aa000000a0000000a0000000000000000000000000000
-- 121:0000000000aaa00000aaa000000a0000000a0000000000000000000000000000
-- 122:000000000077700000007000000a0000000a0000000000000000000000000000
-- 123:00000000000700000070a0000070a000000a0000000000000000000000000000
-- 124:0000000000aa0a000a00aa000a0aaa0000000000000000000000000000000000
-- 125:000000000a0a0a0000aaa0000a0a0a00000a0000000000000000000000000000
-- 126:00000000fee00000e0eeee00eee0e00000000000000000000000000000000000
-- 128:aaa0aaa0aaa0aa00aa00a000a0a000a0aaa00aa00aa0aaa0aaa0aaa000000000
-- 129:00000000000000000000000000000000aa0aaaa0aaaa0aa0aaaaa0a000000000
-- 130:a0aaaaa0aaaa0aa0aaaaa0a000000000aa00aaa0aaa00aa0aaaa00a000000000
-- 131:0000500000050000099499009e999e909e999e9099e9e9900999990000000000
-- 132:000000000000b000006b600006f6660006666600066666000066600000000000
-- 133:00000000000000000032300003f3330003333300033333000033300000000000
-- 134:00000000000000000094900009f9990009999900099999000099900000000000
-- 142:00000bb000666000068666000666660000666000500000500555050000000000
-- 143:000000bb06666600686666606666666006666600500000500555050000000000
-- 144:0000aaa00000aa000000a0a00000aaa000000aa00000aaa00000aaa000000000
-- 145:0aaa0a00aaaaa0a00aaaaaa0aaa0a000a0aaaa00aa00aaa00aa00a0000000000
-- 146:aaa000000aa00000aaa00000a0a00000a0000000aa000000aaa0000000000000
-- 158:00000a900077700007fff700077f770000777000a00000a00aaa0a0000000000
-- 159:000000a9077777007fffff7077fff77007777700a00000a00aaa0a0000000000
-- 161:aaaaa0a0aaa0aaa0a00aaaa00000000000000000000000000000000000000000
-- 240:77777777777777777000000770a0aa077000000700aa0a007000000777777777
-- </TILES>

-- <SPRITES>
-- 000:0000000000000000005bb00005bbfb005bbbbfb05bbbbbb005bbbb0000000000
-- 001:00000000005bb00005bbfb0005bbfb0005bbbb0005bbbb00005bb00000000000
-- 002:0000000000000000005bb00005bbfb005bbbbfb05bbbbbb005bbbb0000000000
-- 003:00000000000000000000000005bbbbb05bbbbffb5bbbbbbb05bbbbb000000000
-- 004:00000000007b5000075b777007b57e7077b77770775b700077b577705b507070
-- 005:0000000000000000007b5000075b777007b57e7077b77770775b700077b57770
-- 006:00000000007b5000075b777007b57e7077b77770775b700077b577705b507070
-- 007:007b5000075b777007b57e7077b77770775b700077b577705b507070b7770000
-- 008:000000000bb00bb0b000b0000555050059555050555950505955550000000000
-- 009:00b000b000b000b00b000b000555050055555050595950505595550000000000
-- 010:000000000bb00bb0b000b0000555050055595050595550505559550000000000
-- 011:0bb00bb0b000b000500050000555050059595050559550505555550000000000
-- 012:0000000004442000440002004440000004444000204462202020220000000000
-- 013:0000000000000000044422004440000004444000204462202020220000000000
-- 014:0000000004442000440002004440000004444000204462202020220000000000
-- 015:0442000044002000400000004440000004444000204462202020220000000000
-- 016:000ff00000ffff0000f0f000f0fffff0fffff0f00fff00000000000000000000
-- 017:00000000000ff00000ffff0000f0f000f0fffff0fffff0f00fff000000000000
-- 018:0000000000000000000ff00000ffff0000f0f000f0fffff0fffff0f00fff0000
-- 019:00000000000ff00000ffff0000f0f000f0fffff0fffff0f00fff000000000000
-- 020:0000000000900000090099000909990000999990009990090009990900999900
-- 021:0000000000000000000990000009990909009909009999900009999000999900
-- 022:0000000000000900009900900099909009999900900999009099900000999900
-- 023:0000000000000000000990009099900090990090099999000999900000999900
-- 024:000000000062220000022b220062222200020000060222000200222000222200
-- 025:000000000062222200022b220062220000020000000222000000222006222200
-- 026:000000000062220000022b220062222200020000060222000200222000222200
-- 027:0000000000622200000222220062222200020000000222000000222006222200
-- 028:0000000000000000000770770007000700177770011767600777777007070700
-- 029:0000000000000000000077770007700700177770011767600777777007007700
-- 030:0000000000000000000007770000777700177770011767600777777000707700
-- 031:0000000000000000000077770007700700177770011767600777777000770700
-- 032:0007770000777700077676700777777077777770770700707077077000000000
-- 033:0007770000777700077777700777777077777770770700707077077000000000
-- 034:0000000000777700077777000777777077777770770700707077077000000000
-- 035:0000000000777700077777000776767077777770770700707077077000000000
-- 036:000000000a077700aaa0f070aa4fff70a0747700a07747700077747007777770
-- 037:0a000000aaa77700aa4ff070a074ff70a0774700007774700077777007777770
-- 038:000000000a077700aaa0f070aa4fff70a0747700a07747700077747007777770
-- 039:00000000000777000a70f070aaafff70aa477700a0747770a077477007777470
-- 040:00660000066006000660660000666000550b0000055055000055000000000000
-- 041:00066600006666600066000000066600550b0000055055000055000000000000
-- 042:00000000006660000666660000666600550b0000055055000055000000000000
-- 043:00066600006666600066000000066600550b0000055055000055000000000000
-- 044:0000000000000000000009000099900009900000099999900999969900909999
-- 045:0000000000099000009009000990000009990000099999900999969900909999
-- 046:0000000000000000000009000099900009900000099999900999969900909999
-- 047:0000000000000000000000000000900009990000999999900999969900909999
-- 048:0000000000000000000000000000000000110770011116700111170707070707
-- 049:0000000000000000000000000000000000110770011116700111170707007707
-- 050:0000000000000000000000000000000000110770011116700111170700707707
-- 051:0000000000000000000000000000000000110770011116700111170700770707
-- 052:0000000000000bb000000b6b00b00bbb050000500b0bb0bb0b5b5b5b00bb0bb0
-- 053:0000000000000bb000000b6b0b000bbb050000500bb505bb0b5b5b5b00bb5bb0
-- 054:0000000000000bb000000b6bb0000bbb050000500b0bb0bb0b5b5b5b00bb0bb0
-- 055:0000000000000bb000000b6b0b000bbb050000500bb505bb0b5b5b5b00bb5bb0
-- 056:00aff00a0affff0a0af0f00a444f0f0a4a4ffaaf444aa00404aff0000a000a00
-- 057:00aff0a00affffa00af0f0a0444f0fa04a4ffaf0444aa04004aff00000aaa000
-- 058:00aff00a0affff0a0af0f00a444f0f0a4a4ffaaf444aa00404aff0000a000a00
-- 059:00aff0a00affffa00af0f0a0444f0fa04a4ffaf0444aa04004aff00000aaa000
-- 060:0033300001ddd1000d000d000d000d0001dfd100a4fff4a0011f11003dddd300
-- 061:0033300001ddd1000d000d000d0f0d0001afa100afffffa001afa10003dfdd30
-- 062:0033300001ddd1000d000d000d000d0001dfd100a4fff4a0011f11003dddd300
-- 063:0033300001ddd1000d000d000d000d0001ddd100a44f44a0011d110003dddd30
-- 064:0022200001333180030003f003000300013331f0f44a44000113110023333200
-- 065:002220000133310003000380030003f0013331001f4a44f00113110002333320
-- 066:0022200001333180030003f003000300013331f0f44a44000113110023333200
-- 067:002220000133310003000380030003f0013331001f4a44f00113110002333320
-- 068:0088800002666290060006e006000600026662f0f44a44000226220086666800
-- 069:008880000266620006000690060006e0026662002f4a44f00226220008666680
-- 070:0088800002666290060006e006000600026662f0f44a44000226220086666800
-- 071:008880000266620006000690060006e0026662002f4a44f00226220008666680
-- 072:00fff00003aaa3d04a000af04a000a004faaafa0a44744004ffaff004aaaa300
-- 073:00fff00003aaa30004000ad004000af004aaaf00fa4744a004faff0004aaaa30
-- 074:00fff00003aaa3d04a000af04a000a004faaafa0a44744004ffaff004aaaa300
-- 075:00fff00003aaa30004000ad004000af004aaaf00fa4744a004faff0004aaaa30
-- 076:0011100002777200670007600700070062777260f64a46f68227228017777100
-- 077:0011100002777200670007600700070062777260f64a46f68227228001777710
-- 078:0011100002777200670007600700070062777260f64a46f68227228017777100
-- 079:0011100002777200670007600700070062777260f64a46f68227228001777710
-- 080:00bbb000075557b0450005f0450005004b555bf0f44a44004bb5bb0045555700
-- 081:00bbb00007555700040005b0040005f004555b00bf4a44f004b5bb0004555570
-- 082:00bbb000075557b0450005f0450005004b555bf0f44a44004bb5bb0045555700
-- 083:00bbb00007555700040005b0040005f004555b00bf4a44f004b5bb0004555570
-- 084:0044400e0e999e090900090e0900090f0e999efef44a44090ee9eefe4999949f
-- 085:004440000e999e0009000900090009000e999e00f44a44f00ee9ee0004999940
-- 086:0044400e0e999e090900090e0900090f0e999efef44a44090ee9eefe4999949f
-- 087:004440000e999e0009000900090009000e999e00f44a44f00ee9ee0004999940
-- 092:0000000000010aa00010aaaa0100a0a00120aaaa01040aa01004400210400400
-- 093:00010aa00010aaaa0010a0a00100aaaa10200aa0102000001000440010044000
-- 094:0000000000010aa00010aaaa0100a0a01020aaaa10200aa01000400010400400
-- 095:00010aa00010aaaa0010a0a00100aaaa01200aa0010400001004440210044000
-- 208:dddddddddddddddddddffdddddf0ffddddffffdddddffddddddddddddddddddd
-- 209:dddddddddd000dddd00f00ddd0fff0ddd00f00dddd000ddddd0f0ddddd000ddd
-- 210:dddddddddd000dddd00f0000d0fff0f0d00f0000dd000ddddddddddddddddddd
-- 211:dddddddddddddddd00000000f0f0f0f000000000dddddddddddddddddddddddd
-- 212:dddfdddddddfddddddfffdddfffffffdddfffddddddfdddddddfdddddddddddd
-- 213:ddfddddddfdfddddddfddfddddddfdfddfdddfddfdfddddddfdddddddddddddd
-- 214:ddddddddddfddddddddddddddddddfdddddddddddfdddddddddddddddddddddd
-- 221:0008888000888888008886880088868800886888000088880000888800008787
-- 222:8888888888888888888888888888888888888888888888888888888888666666
-- 223:8808888088888880888868888888688888888688888888008888880088787800
-- 224:ddddddddddddd000dddd00f0dddd0ff0dddd00f0ddddd000dddddddddddddddd
-- 225:dd0f0ddddd000ddddd0f0ddddd000ddddd0f0ddddd000ddddd0f0ddddd000ddd
-- 226:dddddddddddddddddddfddddddfffddddddfdddddddddddddddddddddddddddd
-- 227:dddddddddddfdddddddfdddddff0ffdddddfdddddddfdddddddddddddddddddd
-- 228:ddfffddddfffffddfffffffdfffffffdfffffffddfffffddddfffddddddddddd
-- 229:ddddddddddddddddddffddddddfffddddddffddddddddddddddddddddddddddd
-- 230:ddddddddddddddddddfdddddddddddddddddfddddddddddddddddddddddddddd
-- 237:0000887800008787000888880008888800088888000088880000008800000000
-- 238:8688888886878878868788788688888888666666888888888888668800888888
-- 239:6887880068787800688888806888888088888880888880008880000000000000
-- 240:0000000000080800008888000008388808088888880000008804440800400400
-- 241:0008080000888800000838880008888800800000088044000880440000044000
-- 242:0000000000080800008888000008388800088888088000000880440000800400
-- 243:0008080000888800000838880008888808000000880444008804440800044000
-- 244:dddddddddddddddddddddddddddddddddd000dddd00f00ddd0fff0ddd00000dd
-- 245:d00000ddd0fff0ddd00f00dddd000ddddddddddddddddddddddddddddddddddd
-- 246:dddddddd000ddddd0f00dddd0ff0dddd0f00dddd000ddddddddddddddddddddd
-- 247:000ddddd0f00dddd0ff00ddd0ffa0ddd0fa00ddd0a00dddd000ddddddddddddd
-- 252:fffffffff077770ff770077ff706067ff700007ff7777777f777777ff7ffffff
-- 253:00000fff00000f0f0000000f0000000000000000000000ff000000ff0000000f
-- 254:00000000f0000000ff0000ff000fffff00ff0000fff0000ff0000000f0000000
-- 255:00fff0000ff0f000fff000000000000000000000ffff00000fff00000ff00000
-- </SPRITES>

-- <MAP>
-- 000:00000000000000000000000000000000000000000000000000000000000001112100000000000000011111111111210111111111210000011111112100011111111111111121000000000000000000000000000000011111112101111111111111111111111111111111111111111111111111b311111121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:00000000000000000000000000000000000000000000000000000000000002e032111111112100000230403030402202303030302200000230303022000230403040303040220000000000000000000000000000000230e03022023030304340303063303030635030306345305563303030306330303022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:0000000000000000000000000111210000000000000000000000000000000210303030303022011142b410c410a4220210101010321111d1047534220142b4104510a4c4102201111111111111111111210000000002101010220204e734431012c4301012103010e4b03010121030105272103010751022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:00000000000000000000000002d022000000000000000000000000000000a33333f2134110f142303010a41010b4f1e1333371103030304310701022023010a4b445c410b42202303030303030303030321111112102101010220210101043a410b46110101061d4b0106155104561101010106110101022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:000000000000000000011111429532111121000000000000000000000000023030f11142104330103113411052f2e230303043105271104310701022021031c13333721052d2421051333391333371103030303032e171103123a372105262721052627210526233333382333333627210523362721052d3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:0000000000000000000220a520f320a5202200000000000000000000000002101043303010431031230002103022021061104310304310431470242202102202303030103030301043d030633030430470707010303043102200023010306350b0506330103043303030d030303043301030306330103022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:00000000000000000002304030103050302200000000000000000000000002101043103113e2102200000341102202105333827210431043101010220210220210513333333333339210103010104310707570246110631022000210051030c012b030101210430470701070703443105272103010121022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:0000000000000000000210101010101010220000000000000000000000000210104310321142102201111142102202103030303010431053721052d3021022021043505050503030430470c570344314707070104310301022000210101061b0b0c061101010431070707070701043101010106110101022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:000000000000000000021010a0a0a0101022000000000000000000000000021031e210303030102202303030102202103113131313e2103030103022021022021043b0b094746110c24110701051731070707034c21341102200a3721052627210526272105292107070c5707010813372105262721052d3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:0000000000000000000210b4a090a01010220000000000000000000000000210220341105133f2230210311313230210220111111142101010101022021032d1104374b0b0e8431032e171105173101010101010220142102200023010306350945063301030431410707070102443303010306330103022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:000000000000000000021010a0a0a010102200000000000000000000000002103211e1339230f11142102200000142102202303030301010101010220210304310439494b0b04310303043f343101051333333f2230230102200021012103094129430101210431012107010121043105272103010121022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:0000000000000000000245101010b410552200000000000000000000000002b050505050431043303010321111423010f1e133711010101010101022021015431043b0e894744310051063104310527330303032114210312300021010106174947461101010431010101010101043101010106110101022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:00000000000000000002554510101055c42200000000000000000000000002b094b074b063104310611030303030105192303043101010101010102202101063104374b0b0b04310101030104310303010611030303010220000a3721052627210526272105262333372f3523333627210523362721052d3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:0000000000000000000313134195311313230000000000000000000000000274b0b0b0b030106310c2131341103113e23010518272105233333333d3020510301053721051338233333333338272103113c31313131313230000023010306330103063301030633030301030303063301030306330103022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:00000000000000000000000002a62200000000000000000000000000000002b0b0e8b031411030102200000210321142105173303010303030303022021010611030301043303030303030303030102200000000000000000000021012103010121030101210301012707070121030105272103010e01022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:00000000000000000000000003962300000000000000000000000000000002e4b0b0942203131313230000021030303010433010311313131341d022021010c213131313e2101010101031131313132300000000000000000000021010106110101061101010611010101010101061101010106110101022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:00000000000000000000000000000000000000000000000000000000000003131313132300000000000000031313131313c31313230000000003132303131323000000000313131313132300000000000000000000000000000003131313c3131313c3131313c313131313131313c313131313c313131323000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:0000001d2b537e255383769cab5236008751ff004d5f574fff77a8ffa300c2c3c700e436ffccaa29adffffec27fff1e8
-- </PALETTE>
