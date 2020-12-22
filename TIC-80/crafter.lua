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
-- 000:5555555555555555555555555555552255555299555552945555244455529cc2
-- 001:5552255555222255222444254444429249942942492444429244492224449242
-- 002:5555555555551111551133aa51333aa3511aaaaa51113aaa511111a351111113
-- 003:5555555511555555a315555533315555aaa31555aaaa31153aaaa33133aa1a31
-- 004:5555555555555444555444495544449955444999544499995449999954499999
-- 005:5555555544455555999995559999995599999955999999959999999599999995
-- 006:5d555555d535355d5355555d555555dd555355dd555533dd5ddddd3355dd88d3
-- 007:55535555d55555d5d5555d538d5355358d5355558d3ddd5583d88dd5338ddd55
-- 016:5529c99c529c9ccc529c9c99529c9cc95529c99c5552cc945555222255555555
-- 017:2249244292224425c2299255c249955542255555255555555555555555555555
-- 018:5001111150001100510001105510001055511010555551105555555155555555
-- 019:a3aaa1711aaa3171011377710003777100037771000377151003715551131555
-- 020:5449999954499999544999995544999955444999555444495555544455555555
-- 021:9999999599999995999999959999995599999955999995554445555555555555
-- 022:5555dd835533333855555d8d5555d8dd5355dddd555ddd55555dd55555555555
-- 023:3333555538d333353d8dd5553dd8dd5335dddd5535555dd55553555555555555
-- 032:5555555555555500555550dd55550ddd5550dddd550bbbdd50bbbbbd50bbbbbd
-- 033:00ffffffffffffffdfffffffdddddfffddddddddddddddddddddddbbddddddbb
-- 034:ffffff00ffffffffffffffffffffffddddddddddddddddddbbddddddbbbddddd
-- 035:5555555500555555ff055555ddd05555dddd0555ddddd055dddddd05dddddd05
-- 048:0bbbbbbb0bbbbbbdbbbbbbddbbbbbbddbbbbbbddbbbbbbddbbbbbbbdbbbbbbbb
-- 049:dddddddbdddddddbdddddddbdddddddbdddddddddddddddddddddddddddddddd
-- 050:bbbbddddbbbbddddbbbbddddbbbbddddbbbbddddbbbbdddddbbbdddddbbbdddd
-- 051:ddddddd0ddddddd0dddddddddddbbbbddbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 064:bbbbbbbbbbbbbbbbdddbbbbbddddbbbbdddddbbbddddddbb0dddddbb0ddddddd
-- 065:bbddddddbbbdddddbbbbddddbbbbddddbbbbddddbbbbddddbbbdddddbbdddddd
-- 066:ddbbbddddddbbdddddddbddddddddddddddddddddddddddddddddddddddddddd
-- 067:bbbbbbbbdbbbbbbbddbbbbbbddbbbbbbddbbbbbbdbbbbbbbbbbbbbb0bbbbbbb0
-- 080:50dddddd50dddddd550ddddd5550dddd55550ddd555550ff5555550055555555
-- 081:dddddddddddddddddddddfffddffffffdfffffffffffffffffffffff00ffffff
-- 082:ddddddbbdddddbbbfddddbbbfffddbbbffffffbbffffffbbffffffffffffff00
-- 083:bbbbbb05bbbbbb05bbbbb055bbbb0555bbb05555bb0555550055555555555555
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
-- 000:0000001d2b537e255383769cab5236008751ff004d5f574fff77a8ffa300c2c3c700e436ffccaa29adffffec27ffffff
-- </PALETTE>
