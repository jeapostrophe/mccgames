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
-- 001:ccccccccc2ccccccc2cccc2cc2cccc2ccccccc2cccc2ccccccc2cccccccccccc
-- 002:cc2222ccc222222cc222222ccc2662ccccc66cccccc66cccccc66ccccccccccc
-- 003:cccccccc66666666664464464466466466666666ccc66cccccc66ccccccccccc
-- 004:c737c737cc7ccc7c7ccc7ccc37c737c77ccc7ccccc7ccc7cc737c737cc7ccc7c
-- 005:cccc2ccccccc2cc2cccc2cc2cccc2cc2cc2c2cc2cc2ccccccc2ccccccc2ccccc
-- 006:cccccccccc2cc2cccc2cc2cccc2cc2cccc2cc2cccccccccccc22222222222222
-- 007:ccccccce2cc2ccce2cc2ccee2cc2ceee2cc2ceeccccc666c2222666222226662
-- 008:eeeccccceeecccccecccc2ccccc2c2ccccc2c2ccccc2c2cc22ccc2c2222cccc2
-- 021:cc2cccc2ccccc222cccc2222ccc2222fcc22222fc22222222222222222222222
-- 022:2222222222222222222222fff22222fff2222222222222222222222222222222
-- 023:2222666222226662222266622222666222222222222222222222222222222222
-- 024:2222ccc222222cc222222ccc222222cc222222ccff22222cff22222222222222
-- 037:222ff222222ff2222222222222222222cccccccecc2ccccfcc2ccccfcc2ccccf
-- 038:22ff222222ff22222222222222222222eeeeeeeeffffffffffff6666fff66666
-- 039:22ff222222ff22222222222222222222eeeeeeeeffee555e6ffe555e66ff555e
-- 040:222222222222ff222222ff2222222222ecccccccecccc2ccecccc2ccecccc2cc
-- 053:cc2ccccfcccc2ccfcccc2ccfc2cc2ccfc2cc2ccfc2cc2ccfc2cccccfcccccccf
-- 054:fff66666ff666666ff666666ff666666ff66ff66ff66ff66ff666666ff666666
-- 055:66ff555f666fffff666fffff666fffff666fffff666fffff666fffff666fffff
-- 056:ecccc2ccecccccccecccccccecc2cc2cecc2cc2cecc2cc2cecc2cc2ceccccccc
-- </TILES>

-- <SPRITES>
-- 000:000000000000000006aaa600062a26000aa9aa0000aaa00000aaaa0000a0a000
-- 001:000000000000000006aaa600062a26000aa9aa0000aaa00000aaaa0000aaa000
-- 002:000000000000000006aaa600062a26000aa9aa0000aaa00000aaaa0000a0a000
-- 003:00000000000a6600aaaa2a000aa9aa00aaaa2a000a0a66000000000000000000
-- 004:000000000000000006aaa600062a26000aa9aa0000aaa00000aaaa0000a0a000
-- 005:00000000000000000000000006aaa600062a26000aa9aa0000aaa00000aaaa00
-- 006:0000000000000000000000000000000006aaa600062a26000aa9aa0000aaa000
-- 007:0000000000000000000000000000000000000000000660000d6666d00bddddb0
-- 016:0002000000222000022222000a4a4a000aa9aa00001110000a111a0000202000
-- 017:00020000002220000022200000aa400000aaa900001110000011a00000202000
-- 018:00020000002220000022200000aa400000aaa9000011100000a1100000022000
-- 019:0000200000022200000222000004aa00009aaa0000011100000a110000020200
-- 020:0000200000022200000222000004aa00009aaa000001110000011a0000022000
-- 021:000000000200000000222000022222000aaaaa000a494a000011100000a1a000
-- 022:0088f80008888880888f88f88f88888888888f88000ff000000ff000000ff000
-- </SPRITES>

-- <MAP>
-- 000:202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:201010101010101010101010101010101010101010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:201010101010101010101010101010101010101010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:201010101010101010101010101010506070801010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:201010101010101010101010101010516171811010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:201010101010101010101010101010526272821010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:201010101010101010101010101010536373831010101010101010101030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:201010101010101010101010101010404040401010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:201010101010101010101010101010404040401010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:201010101010101010101010101010101010101010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:201010101010101010101010101010101010101010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:201010101010101010101010101010101010101010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:201010101010101010101010101010101010101010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:201010101010101010101010101010101010101010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:201010101010101010101010101010101010101010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:201010101010101010101010101010101010101010101010101010101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:202020202020202020202020202020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
-- 000:00000000488946af45ffca75453e787664fe833129ee4c7ddc534be18d79d6b97bbe34c6216c4bd365c8afaab9f5f4eb
-- </PALETTE>

