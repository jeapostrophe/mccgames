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
-- 001:77777777778788777887788788f878788ff8888ff88ffff33ff33f3443355344
-- 002:4443544544453555444533333555344543334455455344534534455355355535
-- 003:3434344334343343343443433433434334334343343443433434334334343443
-- 004:f88f888f888ff88888f88f888f88f8ffff8888f888f88f88888ff888f888f88f
-- 005:1111111110000002100100021010000210000002100000021000000222222222
-- 006:1111111110000000100100001010000010000000100000001000000022222222
-- 007:1111111100000000000000000000000000000000000000000000000022222222
-- 008:1111111100000002000000020000000200000102000010020000000222222222
-- 009:7777777770000008700700087070000870000008700000087000000888888888
-- 010:7777777770000000700700007070000070000000700000007000000088888888
-- 011:7777777700000000000000000000000000000000000000000000000088888888
-- 012:7777777700000008000000080000000800000708000070080000000888888888
-- 016:4555555456666665566666655666666556666665566666655666666545555554
-- 017:ddddddddddedeedddeeddeedeefededeeffeeeeffeeffff33ff33f3aa33bb3aa
-- 018:aaa3baabaaab3bbbaaab33333bbb3aaba333aabbabb3aab3ab3aabb3bb3bbb3b
-- 019:d7fefed7dddefddffed7edeffddfedef7dff7ddffdddefd7fefd7fdffe7dfedf
-- 020:feefeeefeeeffeeeeefeefeeefeefeffffeeeefeeefeefeeeeeffeeefeeefeef
-- 021:1111111110000002100100021010000210000002100000021000000210000002
-- 022:1111111110000000100100001010000010000000100000001000000010000000
-- 023:1111111100000000000000000000000000000000000000000000000000000000
-- 024:1111111100000002000000020000000200000002000000020000000200000002
-- 025:7777777770000008700700087070000870000008700000087000000870000008
-- 026:7777777770000000700700007070000070000000700000007000000070000000
-- 027:7777777700000000000000000000000000000000000000000000000000000000
-- 028:7777777700000008000000080000000800000008000000080000000800000008
-- 033:5555555555b5bb555bb55bb5bbab5b5bbaabbbbaabbaaaa33aa33a3aa33bb3aa
-- 035:b53a3ab5bbba3bb33ab5aba33bb3aba35b335bb33bbba3b53a3b53b33a5b3ab3
-- 036:3aa3aaa3aaa33aaaaa3aa3aaa3aa3a3333aaaa3aaa3aa3aaaaa33aaa3aaa3aa3
-- 037:1000000210000002100000021000000210000002100000021000000210000002
-- 038:1000000010000000100000001000000010000000100000001000000010000000
-- 039:0000000000000000000000000000100000010000000000000000000000000000
-- 040:0000000200000002000000020000000200000002000000020000000200000002
-- 041:7000000870000008700000087000000870000008700000087000000870000008
-- 042:7000000070000000700000007000000070000000700000007000000070000000
-- 043:0000000000000000000000000000700000070000000000000000000000000000
-- 044:0000000800000008000000080000000800000008000000080000000800000008
-- 053:1000000210000002100000021000000210000102100010021000000222222222
-- 054:1000000010000000100000001000000010000000100000001000000022222222
-- 055:0000000000000000000000000000000000000000000000000000000022222222
-- 056:0000000200000002000000020000000200000102000010020000000222222222
-- 057:7000000870000008700000087000000870000708700070087000000888888888
-- 058:7000000070000000700000007000000070000000700000007000000088888888
-- 059:0000000000000000000000000000000000000000000000000000000088888888
-- 060:0000000800000008000000080000000800000708000070080000000888888888
-- 064:1111111111111111111111111111111111111111111111111111111111111111
-- 065:1111111111221211122312311111133112211111132122311131231111111111
-- 066:1111111111651611155415411111144115611111145165411141541111111111
-- 067:1111111111691611199419411111144119611111149169411141941111111111
-- 068:1111111111ba1b111aa31a31111113311ab1111113a1ba311131a31111111111
-- 069:6666666660000005600600056060000560000005600000056000000555555555
-- 070:6666666660000000600600006060000060000000600000006000000055555555
-- 071:6666666600000000000000000000000000000000000000000000000055555555
-- 072:6666666600000005000000050000000500000605000060050000000555555555
-- 073:bbbbbbbbb000000ab00b000ab0b0000ab000000ab000000ab000000aaaaaaaaa
-- 074:bbbbbbbbb0000000b00b0000b0b00000b0000000b0000000b0000000aaaaaaaa
-- 075:bbbbbbbb000000000000000000000000000000000000000000000000aaaaaaaa
-- 076:bbbbbbbb0000000a0000000a0000000a00000b0a0000b00a0000000aaaaaaaaa
-- 080:1111111111de1d111eef1ef111111ff11ed111111fe1def111f1ef1111111111
-- 081:1111111111116d1116d1de111de11111111116d1116d1de111de111111111111
-- 082:1111111111116711167178111781111111111671116717811178111111111111
-- 083:aaa3baabaaab69bba69b9433394b3aaba333a69bab69a943ab94abb3bb3bbb3b
-- 084:aaa3baabaa6636bba66636633bbb366ba663aabba6636663ab6a66b3bb3bbb3b
-- 085:6666666660000005600600056060000560000005600000056000000560000005
-- 086:6666666660000000600600006060000060000000600000006000000060000000
-- 087:6666666600000000000000000000000000000000000000000000000000000000
-- 088:6666666600000005000000050000000500000005000000050000000500000005
-- 089:bbbbbbbbb000000ab00b000ab0b0000ab000000ab000000ab000000ab000000a
-- 090:bbbbbbbbb0000000b00b0000b0b00000b0000000b0000000b0000000b0000000
-- 091:bbbbbbbb00000000000000000000000000000000000000000000000000000000
-- 092:bbbbbbbb0000000a0000000a0000000a0000000a0000000a0000000a0000000a
-- 096:333333333ddddd12311111123222222233333333dd123ddd1112311122223222
-- 097:000000000bbbbba30aaaaaa30333333300000000bba30bbbaaa30aaa33330333
-- 101:6000000560000005600000056000000560000005600000056000000560000005
-- 102:6000000060000000600000006000000060000000600000006000000060000000
-- 103:0000000000000000000000000000600000060000000000000000000000000000
-- 104:0000000500000005000000050000000500000005000000050000000500000005
-- 105:b000000ab000000ab000000ab000000ab000000ab000000ab000000ab000000a
-- 106:b0000000b0000000b0000000b0000000b0000000b0000000b0000000b0000000
-- 107:0000000000000000000000000000b000000b0000000000000000000000000000
-- 108:0000000a0000000a0000000a0000000a0000000a0000000a0000000a0000000a
-- 112:3333388387dddd12811171123222222238338833dd128ddd1172311122228222
-- 113:000000000bbbbba30aaa0aa30333303300000000bba30bbbaaa30aaa30330330
-- 117:6000000560000005600000056000000560000605600060056000000555555555
-- 118:6000000060000000600000006000000060000000600000006000000055555555
-- 119:0000000000000000000000000000000000000000000000000000000055555555
-- 120:0000000500000005000000050000000500000605000060050000000555555555
-- 121:b000000ab000000ab000000ab000000ab0000b0ab000b00ab000000aaaaaaaaa
-- 122:b0000000b0000000b0000000b0000000b0000000b0000000b0000000aaaaaaaa
-- 123:00000000000000000000000000000000000000000000000000000000aaaaaaaa
-- 124:0000000a0000000a0000000a0000000a00000b0a0000b00a0000000aaaaaaaaa
-- 128:333333333ddddd12311131123222232233333333dd123ddd1112311123223223
-- 133:ddddddddd000000ed00d000ed0d0000ed000000ed000000ed000000eeeeeeeee
-- 134:ddddddddd0000000d00d0000d0d00000d0000000d0000000d0000000eeeeeeee
-- 135:dddddddd000000000000000000000000000000000000000000000000eeeeeeee
-- 136:dddddddd0000000e0000000e0000000e00000d0e0000d00e0000000eeeeeeeee
-- 137:999999999000000a9009000a9090000a9000000a9000000a9000000aaaaaaaaa
-- 138:99999999900000009009000090900000900000009000000090000000aaaaaaaa
-- 139:99999999000000000000000000000000000000000000000000000000aaaaaaaa
-- 140:999999990000000a0000000a0000000a0000090a0000900a0000000aaaaaaaaa
-- 149:ddddddddd000000ed00d000ed0d0000ed000000ed000000ed000000ed000000e
-- 150:ddddddddd0000000d00d0000d0d00000d0000000d0000000d0000000d0000000
-- 151:dddddddd00000000000000000000000000000000000000000000000000000000
-- 152:dddddddd0000000e0000000e0000000e0000000e0000000e0000000e0000000e
-- 153:999999999000000a9009000a9090000a9000000a9000000a9000000a9000000a
-- 154:9999999990000000900900009090000090000000900000009000000090000000
-- 155:9999999900000000000000000000000000000000000000000000000000000000
-- 156:999999990000000a0000000a0000000a0000000a0000000a0000000a0000000a
-- 165:d000000ed000000ed000000ed000000ed000000ed000000ed000000ed000000e
-- 166:d0000000d0000000d0000000d0000000d0000000d0000000d0000000d0000000
-- 167:0000000000000000000000000000d000000d0000000000000000000000000000
-- 168:0000000e0000000e0000000e0000000e0000000e0000000e0000000e0000000e
-- 169:9000000a9000000a9000000a9000000a9000000a9000000a9000000a9000000a
-- 170:9000000090000000900000009000000090000000900000009000000090000000
-- 171:0000000000000000000000000000900000090000000000000000000000000000
-- 172:0000000a0000000a0000000a0000000a0000000a0000000a0000000a0000000a
-- 181:d000000ed000000ed000000ed000000ed0000d0ed000d00ed000000eeeeeeeee
-- 182:d0000000d0000000d0000000d0000000d0000000d0000000d0000000eeeeeeee
-- 183:00000000000000000000000000000000000000000000000000000000eeeeeeee
-- 184:0000000e0000000e0000000e0000000e00000d0e0000d00e0000000eeeeeeeee
-- 185:9000000a9000000a9000000a9000000a9000090a9000900a9000000aaaaaaaaa
-- 186:90000000900000009000000090000000900000009000000090000000aaaaaaaa
-- 187:00000000000000000000000000000000000000000000000000000000aaaaaaaa
-- 188:0000000a0000000a0000000a0000000a0000090a0000900a0000000aaaaaaaaa
-- </TILES>

-- <TILES1>
-- 001:fffffff0f0000000f0000000f0000000f0000000f0000000f000000000000000
-- 002:0000000f0ffffff10ffffff10ffffff10ffffff10ffffff10ffffff1f1111111
-- 003:fffffff1f1111112f1111112f1111112f1111112f1111112f111111212222222
-- 004:1111111212222223122222231222222312222223122222231222222323333333
-- 005:2222222323333334233333342333333423333334233333342333333434444444
-- 006:333333343444444c3444444c3444444c3444444c3444444c3444444c4ccccccc
-- 007:4444444c4ccccccc4ccccccc4ccccccc4ccccccc4ccccccc4ccccccccccccccc
-- 008:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 017:fffffff0f0000000f0000000f0000000f0000000f0000000f000000000000000
-- 018:0000000f0ffffff70ffffff70ffffff70ffffff70ffffff70ffffff7f7777777
-- 019:fffffff7f7777776f7777776f7777776f7777776f7777776f777777676666666
-- 020:7777777676666665766666657666666576666665766666657666666565555555
-- 021:666666656555555c6555555c6555555c6555555c6555555c6555555c5ccccccc
-- 022:5555555c5ccccccc5ccccccc5ccccccc5ccccccc5ccccccc5ccccccccccccccc
-- 023:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 024:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 033:fffffff0f0000000f0000000f0000000f0000000f0000000f000000000000000
-- 034:0000000f0ffffff80ffffff80ffffff80ffffff80ffffff80ffffff8f8888888
-- 035:fffffff8f8888889f8888889f8888889f8888889f8888889f888888989999999
-- 036:888888898999999a8999999a8999999a8999999a8999999a8999999a9aaaaaaa
-- 037:9999999a9aaaaaab9aaaaaab9aaaaaab9aaaaaab9aaaaaab9aaaaaababbbbbbb
-- 038:aaaaaaababbbbbbcabbbbbbcabbbbbbcabbbbbbcabbbbbbcabbbbbbcbccccccc
-- 039:bbbbbbbcbcccccccbcccccccbcccccccbcccccccbcccccccbccccccccccccccc
-- 040:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 049:fffffff0f0000000f0000000f0000000f0000000f0000000f000000000000000
-- 050:0000000f0ffffffe0ffffffe0ffffffe0ffffffe0ffffffe0ffffffefeeeeeee
-- 051:fffffffefeeeeeedfeeeeeedfeeeeeedfeeeeeedfeeeeeedfeeeeeededdddddd
-- 052:eeeeeeededdddddceddddddceddddddceddddddceddddddceddddddcdccccccc
-- 053:dddddddcdcccccccdcccccccdcccccccdcccccccdcccccccdccccccccccccccc
-- 054:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 055:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 056:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 064:fff1234cff1234ccf1234ccc1234ccccf765ccccff765cccfff765ccfff89abc
-- 080:ff89abccf89abccc89abccccfedcccccffedccccfffedcccffffedccfffffedc
-- </TILES1>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:1f0e1c8c8fae5845633e21379a6348d79b7df5edbac0c741647d34e4943a9d303bd2647170377f7ec4c134859d17434b
-- </PALETTE>

-- <PALETTE1>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE1>

-- <PALETTE2>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE2>

-- <PALETTE3>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE3>

-- <PALETTE4>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE4>

-- <PALETTE5>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE5>

-- <PALETTE6>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE6>

-- <PALETTE7>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE7>

