pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

__gfx__
000000000ccccc000000000000000000000000000000000006dd66600104d11000111000004d1110000000000000000000000000000000000000000000000000
00000000cccfff00000000000000000000000000000000000600006001004d00001100000004d100000000000000000000000000000000000000000000000000
00000000ccf0f000000000000000000000000000000000000600006000004000000100000004d100000000000000000000000000000000000000000000000000
00000000cccfff000009000000000000000000000000000006dd666000000000000100000004d000000000000000000000000000000000000000000000000000
000000000ccddd000000909000000000000000000000000006000060000000000000000000004000000000000000000000000000000000000000000000000000
000000000fccd0f00009a900b0000000000000000000000006000060000000000000000000004000000000000000000000000000000000000000000000000000
000000000c2220000009a9000300b030000000000000000006dd6660000000000000000000000000000000000000000000000000000000000000000000000000
0000000000f00f000f44f4f0b3030b3b000000000000000006000060000000000000000000000000000000000000000000000000000000000000000000000000
566666501ddddd100000000000000000610001000010001600000000000000004141414100000000000000000000000000000000000000000000000000000000
66656550ddd1d1100000000000000000600100000000100600000000000000000000000001111100000000000000000000000000000000000000000000000000
66555550dd1111100000000000000000d00000000000000d00000000000000000000000011222110000000000000000000000000000000000000000000000000
65655550d1d111100000000000000000d10110000001101d00000000000000000000000012121210000000000000000000000000000000000000000000000000
565555501d1111100000000000000000000100000000100000000000000000000000000012828210000000000000000000000000000000000000000000000000
55555550111111100000000030000000610110000001101600000000000000000000000012222210000000000000000000000000000000000000000000000000
05555500011111000000000001003030d00000000000000d00000000111100000000000001212100000000000000000000000000000000000000000000000000
00550000001100000000000031030113d00100000000100d00011110101000000000000000111000000000000000000000000000000000000000000000000000
06666666666666600566665000000000000000000000000000001010011100000000000000000000000000000000000000000000000000000000000000000000
666656556555555566666555000ddd00000000000000000000011100000100000000000000000000000000000000000000000000000000000000000000000000
66666565555555006656555500dd00000000000000ddd000000000011100000000dd0000000dd000000000000000000000000000000000000000000000000000
65665655555550506565555000d00000000000000000d00000110010100111000d1dd0ddd0dd1d00000000000000000000000000000000000000000000000000
56565555555555005656555000d000000000000000000000011110111100101000001dd7dd100000000000000000000000000000000000000000000000000000
55555555555555006565555000dd000dd00000d00000d00001010001100111100000017471000000000000000000000000000000000000000000000000000000
655555555555505055555550000dd000dd0000d00000d00000111000000110000000001010000000000000000000000000000000000000000000000000000000
6555555555555000555555500000dd000d0000dd0000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000
555555555555050055555555000d0d000d00000d000dd0000009000000b00000f4f4f4f400000000000000000000000000000000000000000000000000000000
55555555550050005555555000000dd00d00000dd00d0000000000000b7b00000000000000000000000000000000000000000000000000000000000000000000
555555555550000055555555000000d0dd0000dd0dd1000000009000b733b0000000000000000000000000000000000000000000000000000000000000000000
055555555505000055555550000000ddd0000ddd11000000000900000b3b00000000000000000000000000000000000000000000000000000000000000000000
0555555505500000555550500000000dd000d10000000000009a900000b000000000000000000000000000000000000000000000000000000000000000000000
05555550500500000555050000000000dd0dd0000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000
005505050500000000505000000000000ddd10000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000dd100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddddddddddddd001dddd110000000000d1000000000000000000000000000000000dd001000000000000000000000000000000000000000000000000000000
dddd1d11d1111111ddddd1110000000000d100000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000
ddddd1d111111100dd1d11110000000000d100000000000000000000000000000000d00010000000000000000000000000000000000000000000000000000000
d1dd1d1111111010d1d11110000000000dd100000000000000000000000000000000d00001000000000000000000000000000000000000000000000000000000
1d1d1111111111001d1d1110000000000dd000000000000000000000000ff00000000dd000111011000000000000000000000000000000000000000000000000
1111111111111100d1d11110000000000dd00000000000000000000000ffff000000000ddd000100000000000000000000000000000000000000000000000000
d11111111111101011111110000000000dd000000000000000000000000f0f000000000000000100000000000000000000000000000000000000000000000000
d11111111111100011111110000000000dd000000a0000001111100000fff0000000000d00000100000000000000000000000000000000000000000000000000
11111111111101001111111100000000ddd100000000000010001000000000000000000d00070011000000000000000000000000000000000000000000000000
1111111111001000111111100000000ddd01000000000000101010000000000000000000dd700000000000000000000000000000000000000000000000000000
1111111111100000111111110000000ddd0d00000000000011101000000000000000000000700000000000000000000000000000000000000000000000000000
011111111101000011111110000000ddd00d10000000000000001000000000000000000000070000000000000000000000000000000000000000000000000000
0111111101100000111110100000001dd100d1000000001111111000000000000000000000007700000000000000000000000000000000000000000000000000
0111111010010000011101000001111d11000d100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00110101010000000010100001110d11101000dd0000111111001111000000000000001110000000000000000000000000000000000000000000000000000000
000000000000000000000000010dddd10001000d0000100001000001000077700000001010000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000777777770000101101000011000777777000001000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000001001000000077777700000001111110100000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000001111000000777777000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000007777770000000111111100000000000000000000000000000000000000000000000000000
00000000000000001000000000000000000000000000000000000077777700000000100000000000000000000000000000000000000000000000000000000000
00000000100000001010001100000000000000000000000000000077777700000000101110000000000000000000000000000000000000000000000000000000
00000001100000001010001000100000000000000000000000000077777000000000100010000000000000000000000000000000000000000000000000000000
00000111100000001100001100110100000000000000000000000777777000000000111110000000000000000000000000000000000000000000000000000000
00000011111000001000001000010100770700770000000000000777777000000000000000000000000000000000000000000000000000000000000000000000
00000111100000001110001000011100000000000007700000000777777000000000000000000000000000000000000000000000000000000000000000000000
00011111000000000011001000011000000000000000070000000077777000000000000000000000000000000000000000000000000000000000000000000000
00011111110000000001111000011000000000000000007000000077777700000000000000000000000000000000000000000000000000000000000000000000
00001111110000000000011000110000000000000000007dd0000077777700000000000000000000000000000000000000000000000000000000000000000000
0001111000000000000000110110000000000000011007000d000007777770000000000000000000000000000000000000000000000000000000000000000000
1111111110110000000000011110000000000000100100000d0000007777770000000000000dd000000000000000000000000000000000000000000000000000
01111111111000000000000011100000000000000001000000000000077777700000000000d000d0000000000000000000000000000000000000000000000000
00001111110000000000000011100000707770070001000ddd000000000777777000000000d000d0000000000000000000000000000000000000000000000000
10011111100110000000000111100000000000000110111000dd000000007770000000dd0d000000000000000000000000000000000000000000000000000000
1111111111111000000000011100000000000000000000010000d0000000000000000d000d001100000000000000000000000000000000000000000000000000
0011111111100000000000011100000000000000000000001000d0000000000000000d000d010010000000000000000000000000000000000000000000000000
00000111000000000000000111000000000000000000000010000000000000000000770000100000000000000000000000000000000000000000000000000000
00000111000000000000001111100000000000000000000100dd0000000000000007007000100000000000000000000000000000000000000000000000000000
00000011100000000000111111110000000000000000000000000000000000000070000000100000000000000000000000000000000000000000000000000000
00000111110000000111111111110000000000000000000000000000000000000070000111000000000000000000000000000000000000000000000000000000
11111111ddddddddcccccccc66666666555555550000000000000000000000000000001000100000000000000000000000000000000000000000000000000000
11111111ddddddddcccccccc66666666555555550000000000001000000000000000001000100000000000000000000000000000000000000000000000000000
11111111ddddddddcccccccc66666666555555550000000000d0d0d0000100000000000100000000000000000000000000000000000000000000000000000000
11111111ddddddddcccccccc66666666555555550007000000006000000d00000000000000000000000000000000000000000000000000000000000000000000
11111111ddddddddcccccccc66666666555555550000000001d676d101d6d1000000000000000000000000000000000000000000000000000000000000000000
11111111ddddddddcccccccc66666666555555550000000000006000000d00000000000000000000000000000000000000000000000000000000000000000000
11111111ddddddddcccccccc66666666555555550000000000d0d0d0000100000000000000000000000000000000000000000000000000000000000000000000
11111111ddddddddcccccccc66666666555555550000000000001000000000000000000000000000000000000000000000000000000000000000000000000000
22222222eeeeeeee8888888899999999aaaaaaaa77777777ffffffff4444444433333333bbbbbbbb000000000000000000000000000000000000000000000000
22222222eeeeeeee8888888899999999aaaaaaaa77777777ffffffff4444444433333333bbbbbbbb000000000000000000000000000000000000000000000000
22222222eeeeeeee8888888899999999aaaaaaaa77777777ffffffff4444444433333333bbbbbbbb000000000000000000000000000000000000000000000000
22222222eeeeeeee8888888899999999aaaaaaaa77777777ffffffff4444444433333333bbbbbbbb000000000000000000000000000000000000000000000000
22222222eeeeeeee8888888899999999aaaaaaaa77777777ffffffff4444444433333333bbbbbbbb000000000000000000000000000000000000000000000000
22222222eeeeeeee8888888899999999aaaaaaaa77777777ffffffff4444444433333333bbbbbbbb000000000000000000000000000000000000000000000000
22222222eeeeeeee8888888899999999aaaaaaaa77777777ffffffff4444444433333333bbbbbbbb000000000000000000000000000000000000000000000000
22222222eeeeeeee8888888899999999aaaaaaaa77777777ffffffff4444444433333333bbbbbbbb000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000dddddddddddddd0000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000dddd2d22d2222222000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000ddddd2d222222200000000000000000000000000000000000000000000000000
0000770070007007700000007700700770077000000770000000000000000000d2dd2d2222222020000000000000000000000000000000000000000000000000
00070070070700700700000070707070007007000070070000000000000000002d2d222222222200000000000000000000000000000000000000000000000000
00007700007000077000000077007070007007000007700000000000000000002222222222222200000000000000000000000000000000000000000000000000
0007007007070070070000007000707000700700007007000000000000000000d222222222222020000000000000000000000000000000000000000000000000
0000770070007007700000007000700770077000000770000000000000000000d222222222222000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000002222222222220200000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000002222222222002000000000000000000000000000000000000000000000000000
00077700707000000000007770707007000700000700707770070700700000002222222222200000000000000000000000000000000000000000000000000000
00070070707000000000070000707007707700000700707007070700700000000222222222020000000000000000000000000000000000000000000000000000
00077700077000000000007700707007070700000700707770070700700000000222222202200000000000000000000000000000000000000000000000000000
00070070070000000000000070777707000700000700707070077770700000000222222020020000000000000000000000000000000000000000000000000000
00077700700000000000077700007007000700000077007007000700700000000022020202000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000007770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000665665666565550000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006655555151515100000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006555151515111500000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005551515151111000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005515151111111100000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005551511111111000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005515111111110100000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005151111111111000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005515111111110100000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005151111111101010000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005511111111110100000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005111111110101010000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000001511111101010100000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000001111111010101000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000101010101010000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000010101010100000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000950000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000460048490000950000000000000000000000009700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000055565758590000000000000000960000000000000000000095000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000065666768690000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000075767700000000232425000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000085868788890000333435000000000000282900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000098990000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000060610000535402011316170000000000000095000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000070710000202122101026270000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000080810022303132421110221862630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000003620212232b8b911524041323872730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000001030313242c8c908095051202182831300000037000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
646484647464646464000000005207134700191130312210220013d8d9646474648400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000221000004041423200321010e8e9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000003211100050515200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
