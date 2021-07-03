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
-- 001:1111112111111221111113311211333322233344113333441133444411334344
-- 002:1111211111121111111331113333333334334444443344344444444444444444
-- 003:1111111111111111333333313333333344444334433443344334444444444444
-- 004:1121111112111111133311113333311134333322443333214444311144443111
-- 005:1111111111111111111111111211311122233322113333211133311111333111
-- 006:0555555555555555555555555555555505555544055555445555444455554544
-- 007:5500555555555555555555555555555554554444445544544444444444444444
-- 008:0055555055555555555555555555555544444554455445544554444444444444
-- 009:0555555055555555555555555555555554555555445555554444555544445555
-- 010:0555555055555555555445555544445555444555555544555555445555444455
-- 017:1113444411133344113333442233334411134444111343341113433411134444
-- 018:4444444444444444444444444444444444444444444444444444444444444444
-- 019:4444444444444444444444444444444444444444444444444444444444444444
-- 020:4443311144443312444433214433331144333111443331114444332144333322
-- 021:1113311111133312113333212233331111133111111331111113332111133322
-- 022:5555444405555544055555445555554455554444555545545555455455554444
-- 023:4444444444444444444444444444444444444444444444444444444444444444
-- 024:4444444444444444444444444444444444444444444444444444444444444444
-- 025:4445555044445555444455554455555544555550445555504444555544555555
-- 026:5544445555544450554444505544555555545555554444555544455505444455
-- 033:1113444411334344113344441233334422333344123344441113344411134444
-- 034:4444444444444444444444444444444444444444444444444444444444444444
-- 035:4444444444444444444444444444444444444444444444444444444444444444
-- 036:4433332144333311444431114434311144443111443333214433332244443311
-- 037:1113332111333311113331111233311122333111123333211113332211133311
-- 038:5555444455554544055544440555554455555544555544445555544455554444
-- 039:4444444444444444444444444444444444444444444444444444444444444444
-- 040:4444444444444444444444444444444444444444444444444444444444444444
-- 041:4455555544555555444455554454555044445550445555554455555544445555
-- 042:0555445555554455554444555544545555444450555444505544445555444555
-- 049:1113444412334444223333441113334311133333111123331111211111221111
-- 050:4444444444433444434334334444443333333333331111132211111121111112
-- 051:4444444443334434433343444444444433333333331111132111111211111112
-- 052:4443311144443111343333214433332233333312113331111122111111122111
-- 053:1113311112333111223333211113332211133312111131111111111111222111
-- 054:5555444455554444555555445555554555555555555555555555555505555550
-- 055:4444444444455444454554554444445555555555555555555555555505555550
-- 056:4444444445554454455545444444444455555555555555555555555505550555
-- 057:4445555544445555545555504455555555555555555555555555555555500550
-- 058:0544445505554455555544555544445555445455555445555555555505555550
-- 065:1111121111111221211113312113333321333333111333111111221111122111
-- 066:1112111111222111113333313333333333333333333111331221111212111111
-- 067:1111211111112111111133113333333333333333331133312211121121111121
-- 068:1112111111122111333211113333111133333111113311111122111111121111
-- 069:1111111111133211113333211233332222333312133333311332133111122111
-- 070:0555005555555555555445545544455455444444555445445555555505555550
-- 071:5550055555555555444445444554444545544445544445445555555505555555
-- 072:5555005555555555445444455444444454445544444455445555555500555555
-- 073:5555555555555555555554554444444545544445455444555555555550055555
-- 074:0555555055555555555445555544445555445455555445555555555505555550
-- 081:0000000000010000000100000011200000112200011222202222600000066600
-- 082:0000000000000000000000000000000000000000000000000000011001101111
-- 083:0000000000000000000000000000000000020000000100000101020002020202
-- 084:00000000000000000000000000000000000000000000000000099a000099aaa0
-- 097:0000000000000000000000000000001200007710000077800000880000000000
-- 098:0000111200000000000000120000000001112221000000000001112200000000
-- 099:0000000000000000000000030000033300000333000000330000000300000000
-- 100:00000000000000010000000000000001000000120000002a000000aa0000000a
-- 113:0aaa990000a99000000000000000000000000000000000000000000000000000
-- 114:2020202000201010000010000000200000000000000000000000000000000000
-- 115:1111011001100000000000000000000000000000000000000000000000000000
-- 116:0066600000062222022221100022110000021100000010000000100000000000
-- 129:a0000000aa000000a20000002100000010000000000000001000000000000000
-- 130:0000000030000000330000003330000033300000300000000000000000000000
-- 131:0000000022111000000000001222111000000000210000000000000021110000
-- 132:0000000000880000087700000177000021000000000000000000000000000000
-- </TILES>

-- <MAP>
-- 012:000000000000000000000000000000000000102030203020302030202030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:203020302030203020302030203020302030313131313131313131313131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:313131313131313131313131313131313131313131313131313131313131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:313131313131313131313131313131313131313131313131313131313131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:313131313131313131313131313131313131313131313131313131313131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
-- 000:00000047f64108b23b81370414182e053239461c14da2424720d0d8b97b6686b72461c14000000000000000000000000
-- </PALETTE>
