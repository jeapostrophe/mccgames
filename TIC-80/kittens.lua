-- title:  Kittens
-- author: Charlotte Awesome
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
	print("Awesome Kittens",84,84)
	t=t+1
end

-- <TILES>
-- 001:6666666665666566656566666665666666666566656665666566666666666666
-- 255:ccccccccc044440cc44bb44cc4baba4cc4bbbb4cc777777bc777777ccbcccccc
-- </TILES>

-- <SPRITES>
-- 000:b0bbb0bb0d000d0b0ddedd0b0dadad0b0dd2dd0bb0ddd0bbb0dddd0bb0d0d0bb
-- 001:b0bbb0bb0d000d0b0ddedd0b0dadad0b0dd2dd0bb0ddd0bbb0dddd0bb0ddd0bb
-- 002:b0bbb0bb0d000d0b0ddedd0b0dadad0b0dd2dd0b0eddd0bbb0dddd0bb0d0d0bb
-- 003:b0bbb0bb0d000d0b0ddedd0b0dadad0b0dd2dd0befddd0bb00dddd0bb0d0d0bb
-- </SPRITES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:0000005d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f6ffccaaf4f4f494b0c2566c86333c57
-- </PALETTE>

