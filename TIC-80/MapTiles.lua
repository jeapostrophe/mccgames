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
-- 001:ddddddddd3dddddddddddddddddddd3ddddddddddddddddddd3ddddddddddddd
-- 002:ddddddddd3ffffdddffffffddfffffaddaffffddddaffadddd3aaddddddddddd
-- 003:bbbbbbbbb5bbbbbbbbbbbbbbbbbbbb5bbbbbbbbbbbbbbbbbbb5bbbbbbbbbbbbb
-- 004:eeeeeeeee9eeeeeeeeeeeeeeeeeeee9eeeeeeeeeeeeeeeeeee9eeeeeeeeeeeee
-- 005:eeeeeeeee99eee999ee9e9eeeeeeeeeeeeee99eeeee9ee9eee9eeeeeeeeeeeee
-- 006:fffffffffaffffffffffffffffffffafffffffffffffffffffafffffffffffff
-- 007:777aa777777aa77777aaaa7777aaaa777aaaaaa77aaaaaa7aaaaaaaaaaaaaaaa
-- 008:777ff777777ff77777ffff7777afaf777aaaaaa77aaaaaa7aaaaaaaaaaaaaaaa
-- 016:b5555555155151b5b1151b115bb5555b5b5555551b1b51b15151151524242424
-- 017:dddddd42d3dd4442dddddd46dddd4466dddd4422dddddd22dd3d4444dddddd46
-- 018:ffddddddaffdffdddaadffffddddaffafffddaadafffdddddaaadddddddddddd
-- 019:b5bbbbbbb5b5bbbbbbb5bb5bbbbbbb5b5bbb5bbb5b5b5b5bbb5bbb5bbbbbbbbb
-- 020:eff3dffefe3dddeff3cccceffdc11cdffe9eee9ffcec9ecfaffffffaeaa11aae
-- 021:eeeeeaaee9ee3eeaaaeeaeeaaaaeae9aee3eeeeeeeeeeeaeea3eea3eeeeeeeee
-- 022:ffff5ffffaf515fffff151fff5ff2faf515ff5ff151f515ff2af151ffffff2ff
-- 023:77777777777777777a969ea77a9e9aa7a96a9eaaaeaaa9aaa99aa9aa6e9a69ea
-- 032:bbbbb33bb5bb7bb333bb3bb3333b3b53bb7bbbbbbbbbbb3bb37bb37bbbbbbbbb
-- 033:ddddddddd3dddddddddddddddddddd3ddddddddddddddddddd3aaddddddeeddd
-- 034:ddddddddd3ddfdddddddafdddfdddaaddafdfdddddadaffddd3ddaaddddddddd
-- 035:bb27752bb227722b5447744b7777777777277727b2277225b447744bbb577bbb
-- 036:eeeeeeeee92222eeee42222eee44444eee42424eee424449ee42424ee4924244
-- 038:fffff22ffaff2222f22f313322223333a2a2a1a3aaaaaaaaa3113aaa33113333
-- 049:dddffdddd3d66ddddddffdddddd66d3ddbbffbbdd4bbbb4dda4444adddaaaadd
-- 051:bbbbb22bb5bb2222b22b313322223333a2a2a1a3aaaaaaaaa3113aaa33113333
-- 054:fffff77ffaff1ff777ff7ff7777f7fa7ff1fffffffffff7ff71ff71fffffffff
-- 240:4444444444444444222222222222222200000000000000000000000000000000
-- </TILES>

-- <SPRITES>
-- 000:0000000000000000000474000071714004711140041117000047400000000000
-- 001:0000000000000000000757000051b17007b11170071115000075700000000000
-- 002:0000000000000000000fdf0000d1d1f00fd111f00f111d0000fdf00000000000
-- 016:000000000000000000000000000ddddd000ddddd000000000000000000000000
-- 017:000000000000000000000000dddddddddddddddd000000000000000000000000
-- 018:000000000000000000000000ddddd000ddddd000000000000000000000000000
-- 020:000000000000bbb00000b5b00070047700007777000000000000000000000000
-- 021:0000000000000000000000007777777777777777000000000000000000000000
-- 022:0000000000000000000000007777000077700700000000000000000000000000
-- 032:0000000000000000000000000000dddd000ddddd000ddd00000dd000000dd000
-- 033:000000000000000000000000ddd00ddddddddddd00dddd00000dd000000dd000
-- 034:000000000000000000000000dddd0000ddddd00000ddd000000dd000000dd000
-- 035:000000000000000000000000000dd000000dd000000dd000000dd000000dd000
-- 036:0000000000bbb00000b5b00000047777a0077777a30777000007700000077000
-- 037:0000000000044000000240007777477777777777000770000007700000077000
-- 038:0000000000000000000000007777000077777000007770000007700000077000
-- 039:00000000000000000007bbb00000b5b0a0007400a3077000a307700000077000
-- 048:000dd000000dd000000ddd000000dddd0000dddd000ddd00000dd000000dd000
-- 049:000dd000000dd00000dddd00dddddddddddddddd00dddd00000dd000000dd000
-- 050:000dd000000dd00000ddd000dddd0000dddd000000ddd000000dd000000dd000
-- 051:000dd000000dd000000dd000000dd000000dd000000dd000000dd000000dd000
-- 052:0007700000077000044770000247777700477777000770000007700000077000
-- 053:0447700002477000004770007777744777777247000770400007700000077000
-- 054:0007700000077000000744007777240077777400000770000007700000077000
-- 055:0007700000077000000770000007700000077000000770000007700000077000
-- 064:000dd000000dd000000ddd00000ddddd0000dddd000000000000000000000000
-- 065:000dd000000dd00000dddd00ddddddddddd00ddd000000000000000000000000
-- 066:000dd000000dd00000ddd000ddddd000dddd0000000000000000000000000000
-- 067:000dd000000dd000000dd000000dd000000dd000000000000000000000000000
-- 068:0007bbb00007b5b0000774000007777700007777000000000000000000000000
-- 069:0007700000077000000770007774477777724777000040000000000000000000
-- 070:0007700000077000007770007777700077770000000000000000000000000000
-- 071:000770000007700000077003000070a3000000a3000700000000000000000000
-- 080:0040400000404d4d0000dd4d04000dd004dd000404ddd0040dddd40000000400
-- 081:000000000dd4d0000dd4d40004ddd4d404ddddd40dd4ddd000d4dd4000000040
-- 082:00000000055bb00054b5db0004ddddb00bddd55000bd5b45000bb04000000000
-- 083:0224006022440666024006160000000000600000066600000616000000000000
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

