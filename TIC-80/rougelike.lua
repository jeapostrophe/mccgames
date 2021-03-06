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
-- 001:5555555555455555555454555554555455555545545545555545555555555555
-- 002:55555555555555455555555555555555545555555ff555555c85545555555555
-- 003:5555555555555555555b955555999b5559b99995555cc555444dd44554544545
-- 004:55555555ffffff55ffffff5588ccfff5ccc8fff5c888cccfccffc88f44ffcccc
-- 005:555755555573755555575455555455e455555e6e542545e55272555555255555
-- 006:eeeeeeeeddddddddd08d080dddddddddd0d80d8ddddddddd555cc555555dd555
-- 007:5555555555555554555544415554111255412222551222225422222251222222
-- 008:5555555544555544114554112215412222241222222122222222222222222222
-- 009:5555555544555555114455552211455522221555222224552222215522222255
-- 016:5555555555455555555454555554555455555545545545555545555555999955
-- 017:4545445488c4cc4cf8888ccc8ccc8888f8ccccccf888cccc48c8888c54444444
-- 018:4545445488c4cc48c888c888ccc888cc8cccccccc88ccccccc8888c844444444
-- 019:454544558884884888ccccc8c888ccc8ccc88cc88c8cc88888c8cc8444444445
-- 020:ff55fffffff5fffffff5ccccfff55555fff5fffffff5ffffcff5cffc5cc55cc5
-- 021:fffffff5cfffffff5ccccccc55555555fff55ffffff5ffffcff5cffc5cc55cc5
-- 022:ccccccccccccccccc000000cc0f0ff0cc000000c00ff0f00c000000ccccccccc
-- 023:5522222255522222555222225552222255522222555222225542222255122222
-- 024:2222222222222222222222222222222222222222222222222222222222222222
-- 025:2222224522222215222222552222225522222255222225552222245522222155
-- 032:598888959999999989999998989999895988889555999955555cc55555999955
-- 033:4545445488c4cc4cf8888ccc8ccc8888f8ccccccf888ccccc8c8888cfccccccc
-- 034:4545445488c4cc48c888c888ccc888cc8cccccccc88ccccccc8888c88ccccc8c
-- 035:454544558884884888ccccc8c888c8c8ccc88cc88c8cc88888c8cc8ccc8c88c8
-- 036:5555555555545444554d4ddd54dddddd4ddddddd5ddddddd55dddddd54dddddd
-- 037:555555555545544444d44ddddddddddddddddddddddddddddddddddddddddddd
-- 038:5555555544555555dd445555dddd4555ddddd455dddddd55dddddd55dddddd55
-- 039:5522222255222222555222225555522255555552555555555555555555555555
-- 040:2222222222222222222222222222222222222222552222225555522255555555
-- 041:2225555525555555245555552145555522145555222555552555555555555555
-- 048:598888959999999989999998989999895988889555999955555cc555555dd555
-- 049:88c8888cf8cccc88f8888ccc8ccc8888f8ccccccf888cccc48c8888c54444444
-- 050:cc88888c88cc8cc8c888c888ccc888cc8cccccccc88ccccccc8888c844444444
-- 051:ccc8cc88888c88c888ccccc8c888c8c8ccc88cc88c8cc88888c8cc8444444445
-- 052:5ddddddd5ddddddd55dddddd55dddddd54dddddd55dddddd54dddddd5ddddddd
-- 053:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 054:ddddd555ddddd455dddddd55ddddd555dddd5555dddd4555ddddd455dddddd55
-- 055:5455545448444848cc88cc8cffffffffffffffffffffffffcccccccc8fc00000
-- 056:4544554584884484cc8c8888ffffffffffffffffffffffffcccccccc00000cf8
-- 057:88888cc8c8ccc8c8cc88cc8cffffffffffffffffffffffffcccccccc8fc00000
-- 058:c8cc888c8c88cc8ccc8c8888ffffffffffffffffffffffffcccccccc00000cf8
-- 064:0000000000f0f000f0fff0f00fffff00fff0fff0000000003333333000000000
-- 065:4545445488c4cc4cf8848ccc8cc44448f8ccc544f888ccc4c8c85884fcc44444
-- 066:4545445488c4cc48c548c888cc4888cc8c45ccc558844ccccc8848c88cc54c8c
-- 067:4545445588848548445cc4484888c45844c544c8544c48884444458c4c8c88c8
-- 068:5ddddddd5ddddddd5ddddddd55dddddd54dddddd55dddddd555ddddd55555dd5
-- 069:ddddddddddddddddddddddddddddddddddddddddddddddddddd55ddd555555d5
-- 070:dddddd55dddddd45ddddddd5dddddd55dddddd55dddd5555ddd5555555555555
-- 071:c3fc0000c3fc0000c3fc0000c3fc0000c3fc0000c3fc0088f33f08884ff48888
-- 072:0000cf3c0000cf3c0000cf3c0000cf3c0000cf3c8800cf3c8880f33f88884ff4
-- 080:000000000f0f0f0000fff000fffffff00ff0ff00000000003333333000000000
-- 081:88c4885cf8c4cc88f8844ccc8c5c8488f8cc445cf8844ccc48c4888c54444444
-- 082:cc84458c884c8cc5c848c888cc4588cc844cccc4548ccc54c48888c444444444
-- 083:45c85c88444c84c88845c4c8444844c845c84cc88c8c458848c84c8444444445
-- 084:fcc8888888ccc888f8888ccc8ccc8888f8ccccccf888ccccc8c8888cfccccccc
-- 085:ccc8888c88cc8cc8c888c888ccc888cc8cccccccc88ccccccc8888c88ccccc8c
-- 086:c8ccc8c8888c88c888ccccc8c888c8c8ccc88cc88c8cc88888c8cc8ccc8c88c8
-- 087:5445dddd5554dddd555ddddd555ddddd554ddddd55dddddd55dffddd54dc8ddd
-- 088:dddd5445dddd4555ddddd555ddfdd555ddcfd455dddcdd55ddd8dd55ddddd555
-- 096:000000000000000000000000000000000000fff00000fff00000fff000000000
-- 097:00000000000000000000000000000000fffffff0fffffff0fffffff000000000
-- 098:00000000000000000000000000000000fff00000fff00000fff0000000000000
-- 099:fffffff0fffffff0fffffff0fff00000fff00000fff00000fff0000000000000
-- 100:fffffff0fffffff0fffffff00000fff00000fff00000fff00000fff000000000
-- 101:fffffff0fffffff0fffffff0fff00000fff0fff0fff0fff0fff0fff000000000
-- 102:fffffff0fffffff0fffffff0fff0fff0fff0fff0fff0fff0fff0fff000000000
-- 103:fffffff0fffffff0fffffff00000fff0fff0fff0fff0fff0fff0fff000000000
-- 104:fff0fff0fff0fff0fff0fff0fff00000fff0fff0fff0fff0fff0fff000000000
-- 105:fffffff0fffffff0fffffff000000000fff0fff0fff0fff0fff0fff000000000
-- 106:0000fff00000fff00000fff000000000fff0fff0fff0fff0fff0fff000000000
-- 107:fff00000fff00000fff0000000000000fff0fff0fff0fff0fff0fff000000000
-- 108:fffffff0fffffff0fffffff0000000000000fff00000fff00000fff000000000
-- 109:0000fff00000fff00000fff00000fff0fff0fff0fff0fff0fff0fff000000000
-- 110:0000fff00000fff00000fff000000000fffffff0fffffff0fffffff000000000
-- 111:fff00000fff00000fff00000fff00000fff0fff0fff0fff0fff0fff000000000
-- 112:0000fff00000fff00000fff00000fff00000fff00000fff00000fff000000000
-- 113:fffffff0fffffff0fffffff0fff0fff0fffffff0fffffff0fffffff000000000
-- 114:fff00000fff00000fff00000fff00000fff00000fff00000fff0000000000000
-- 115:fff00000fff00000fff00000fff00000fffffff0fffffff0fffffff000000000
-- 116:0000fff00000fff00000fff00000fff0fffffff0fffffff0fffffff000000000
-- 117:fffffff0fffffff0fffffff0fff00000fffffff0fffffff0fffffff000000000
-- 118:fff0fff0fff0fff0fff0fff000000000fff0fff0fff0fff0fff0fff000000000
-- 119:fffffff0fffffff0fffffff00000fff0fffffff0fffffff0fffffff000000000
-- 120:fff0fff0fff0fff0fff0fff000000000fffffff0fffffff0fffffff000000000
-- 121:fff0fff0fff0fff0fff0fff00000fff0fff0fff0fff0fff0fff0fff000000000
-- 122:fff0fff0fff0fff0fff0fff0000000000000fff00000fff00000fff000000000
-- 123:fff0fff0fff0fff0fff0fff000000000fff00000fff00000fff0000000000000
-- 124:fff0fff0fff0fff0fff0fff0fff00000fff00000fff00000fff0000000000000
-- 125:fff00000fff00000fff0000000000000fffffff0fffffff0fffffff000000000
-- 126:fff0fff0fff0fff0fff0fff00000fff00000fff00000fff00000fff000000000
-- 127:fffffff0fffffff0fffffff000000000fff00000fff00000fff0000000000000
-- 128:0000fff00000fff00000fff00000000000000000000000000000000000000000
-- 129:fffffff0fffffff0fffffff00000000000000000000000000000000000000000
-- 130:fff00000fff00000fff000000000000000000000000000000000000000000000
-- 131:fffffff0fffffff0fffffff000000000fffffff0fffffff0fffffff000000000
-- 132:fff0fff0fff0fff0fff0fff0fff0fff0fff0fff0fff0fff0fff0fff000000000
-- 133:fff0fff0fff0fff0fff0fff0fff00000fffffff0fffffff0fffffff000000000
-- 134:fff0fff0fff0fff0fff0fff0fff0fff0fffffff0fffffff0fffffff000000000
-- 135:fff0fff0fff0fff0fff0fff00000fff0fffffff0fffffff0fffffff000000000
-- 136:0000fff00000fff00000fff000000000fff00000fff00000fff0000000000000
-- 137:fff00000fff00000fff00000000000000000fff00000fff00000fff000000000
-- 138:0000fff00000fff00000fff0000000000000fff00000fff00000fff000000000
-- 139:00000000000000000000000000000000fff0fff0fff0fff0fff0fff000000000
-- 140:fff0fff0fff0fff0fff0fff00000000000000000000000000000000000000000
-- 141:fff00000fff00000fff0000000000000fff00000fff00000fff0000000000000
-- 144:fff0fff000000000f0fff0f00000000000000000000c00000000000000000000
-- 145:ccccccc000000000ccccccc00000000000000000000c00000000000000000000
-- 146:00000000000000000000000000000000ff0ffff0ffff0ff0fffff0f000000000
-- 147:f0fffff0ffff0ff0fffff0f000000000ff00fff0fff00ff0ffff00f000000000
-- 148:fff0fff0fff0ff00ff00f000f0f000f0fff00ff00ff0fff0fff0fff000000000
-- 149:000000000000000000f0cc000000cc000cc000000cc0f0000000000000000000
-- 150:00000000000000000000000000f0f0000000000000f0f0000000000000000000
-- 151:fff0fff000000000f0fff0f0ffffffffffffffffffffffffcccccccc0fc22222
-- 152:fff0fff000000000f0fff0f0ffffffffffffffffffffffffcccccccc22777cf0
-- 160:fff0fff000000000f0fff0f000000000fff0fff000000000f0fff0f000000000
-- 161:0000fff00000ff000000f0f00000fff000000ff00000fff00000fff000000000
-- 162:ff00f0f000000000f0ff00f000000000ff00fff000000000f0f0f00000000000
-- 163:fff000000ff00000fff00000f0f00000f0000000ff000000fff0000000000000
-- 164:f0000000f0ff0000f0ff0ff000ff0ff0f0000ff0f0ff0000f0ff0ff000000000
-- 165:fffffff000000000ff000000ff0ff000ff0ff0f0ff0ff0f0ff0ff0f000000000
-- 167:c3fc2222c3fc2222c3fc2222c3fc2255c3fc255dc3fc55ddf33f5ddd0ff0dddd
-- 168:2227cf3c2222cf3c2222cf3cd522cf3c5552cf3cdd55cf3cfdd5f33fdddd0ff0
-- 176:fff0fff000000000f00000f000000000f00000f000000000f0fff0f000000000
-- 178:fffff0f0fff0fff0f00ffff00000000000000000000000000000000000000000
-- 183:0000dddd0000dddd000dd0d0000ddddd000d0d0d00dcd0d0000000000d0d0d0d
-- 184:dddd0000dddd0000d0d0d000ddddd0000d0d0000d0dcd000000000000d0d0d00
-- 192:ff00f0f000000000f0ff00f00000000000000000000c00000000000000000000
-- 193:0e000000700000003700000000000000dd000000000c0000d000000000000000
-- 194:00000000070000007300000000000000dd000000000c0000d000000000000000
-- 195:00000e0000000070000007300000000000000dd0000c0000000000d000000000
-- 196:0000000000000700000003700000000000000dd0000c0000000000d000000000
-- 208:0000000000000000000000000000000000000000000c00000000000000000000
-- 209:1010101000000000101010100000000010101010000000001010101000000000
-- 210:1010101000000000109990100090900010999010000000001010101000000000
-- 224:000000000ffffff00fddddf00fd77df00ff77ff00eeeeee00dddddd000000000
-- 225:0ff77ff00f0000f00f0880f00f8888f00ff77ff00eeeeee00dddddd000000000
-- </TILES>

-- <SPRITES>
-- 001:0fcccf00fccfccf0fcfffcf0fccfccf0fccfccf0ccccccc0fcfffcf000000000
-- </SPRITES>

-- <MAP>
-- 000:101010101010201010101010401222222222552210201010101040101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:1222222222222222222222223255555593a3555512222121212121212122000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:455555555555555555555555652323237484232345651040201010101045000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:132323232323232323232323331010107585601013231222222222223223000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:101010101010101010101010101010104363101010101323232323233310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:101070808080808090101010101010104363101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:101072818181818181901010101010104363101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:101010718181818181911010101010104353525252525252525252526210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:101010718181818181911010101010104454545454545454545454536310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:101010718181818181911010101010101010101010101010101010436310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:101010728282828181921010101010101010101010101010101010436310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:101010101010107292101010101010101010101010101010101010436310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:101010101010101010101010101010101010101010101010101010435352000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:101010101010101010101010101010101010101010101010101010445454000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
-- 000:1b0f284c668483bfcaf4f9e6233e38357b458ab954f2e05a3120396e2745c6434ee7937e5442429e523be985498d8878
-- </PALETTE>

