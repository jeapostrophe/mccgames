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

-- <SPRITES>
-- 000:00000000007007000077770000f77f0000777700022222200722227000700700
-- 001:00000000003030000033300000f3f00000333000031113000311130000303000
-- 016:00606600006666000f8f8f800888888000f8f80000888800000f800000088000
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
-- 000:000000be4085b13e53ff91ffffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900383838
-- </PALETTE>

-- <PALETTE1>
-- 000:040000814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f44c4c48ae6900333c57
-- </PALETTE1>

-- <PALETTE2>
-- 000:1a1c2c814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900333c57
-- </PALETTE2>

-- <PALETTE3>
-- 000:1a1c2c814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900333c57
-- </PALETTE3>

-- <PALETTE4>
-- 000:1a1c2c814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900333c57
-- </PALETTE4>

-- <PALETTE5>
-- 000:1a1c2c814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900333c57
-- </PALETTE5>

-- <PALETTE6>
-- 000:000000814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900333c57
-- </PALETTE6>

-- <PALETTE7>
-- 000:080008814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900333c57
-- </PALETTE7>
