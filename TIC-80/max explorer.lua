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
	print("Shha shha shha...",84,84)
	t=t+1
end

-- <TILES>
-- 001:eccccccccc222222c0000000c0222222c0ccccccc0cc0cccc0cc0cccc0cc0ccc
-- 002:cccccec22222cc2c00000cc222200cecccc00ccc0cc00c0c0cc00c0c0cc00c0c
-- 003:eccccccccc222222c0000000c0222222c0ccccccc0cc0cccc0cc0cccc0cc0ccc
-- 004:cccccec22222cc2c00000cc222200cecccc00ccc0cc00c0c0cc00c0c0cc00c0c
-- 017:c0ccccccc0000000c0000000c0000000c0000000c2222222ccc000cceecccccc
-- 018:ccc000cc00000cce00000cee00000cee00000cee2222ccee000cceeecccceeee
-- 019:c0ccccccc0000000c0000000c0000000c0000000c2222222cc000cc0eccccccc
-- 020:ccc000cc00000cce00000cee00000cee00000cee2222ccee00ccceeeccceeeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:000000814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900333c57
-- </PALETTE>

