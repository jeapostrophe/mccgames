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
-- 000:0009009900009009000990000099000900999099000999990000999990099995
-- 001:0099000090999000000999000009990090999009999900909999009959990099
-- 002:0000000000000000000000000000000000000077000077770007777700776677
-- 003:7700000077000000700770000077770007777700777777007777700077777000
-- 004:00000000000000000000000c000bb00000b00b0000b00b00000b0bbb0cc0bbbc
-- 005:0bb00000b00b0cc0000b0cc0c0b0c0000b0bb000b0b00b00bbb00000cbbb0000
-- 006:000000080000008d0000088800088ddd008d8dd8008d88d8008dd888008888dd
-- 007:00000000888000008dd800008d888000888dd800d8ddd80088dd880088888880
-- 008:000000000044003000404333c0000434b440444404044444000444c300444433
-- 009:03330000443444b04440004c44400400444400004444430034c43330b3444300
-- 010:00444000044444000044444000004444000004440000444e000044ee00044eee
-- 011:0044440004444400444440004444440044444440e4444444ee444004eee44004
-- 012:00000aaa000a00aa00aa000a00a000000000000a0a0000aaaa000aaaa000aa88
-- 013:a8aaaa00aaa8aaa0aa88a8aaaaaa8a8aaa8a88aaaaa8aaaaa88a8aaaaa8aaaa0
-- 014:000000000a003000a0a00000000a00a000000aaaa00a00a00aa0a0000000a00a
-- 015:00a000000a00a00000aa0a00000000a0000a000a00a3a00a000a00a0a00a00a0
-- 016:0009995500099551090955519009555599009555099009550090009500000009
-- 017:5599099055599000515590005155900955590090559009905900990090000000
-- 018:0776666777616166766161667666666607666666007666670007667000007700
-- 019:7777700077770000677700006770077070000770000077000007000000000000
-- 020:0cccbbcc000bbccc000bcccc000bccc10000bcc100000bcc000000bc0000000b
-- 021:ccbbb0cccccbb0ccccccbc00c1ccb000c1cb0000ccb00000cb000000b0000000
-- 022:008d8ddd0008dd1d008ddd1d008ddddd0008dddd00008ddd000008dd00000088
-- 023:d88ddd80dd888d801dd8dd801dd88800dd88d000d88d00008880000080000000
-- 024:004443b50044c355004455510044555100444555000444550000444500000044
-- 025:53344400553c4400515544005155440055544400554440005444000044000000
-- 026:0044eeee0044e5ee00044e5e000004ee0000004e000000440000000400000000
-- 027:eeee4400e5ee44005ee44000ee400000e4000000440000000400000004000000
-- 028:000aa88800aa888800a8888800a88188000a81810000a88100aa0a880aa000aa
-- 029:8aaaaa0088aaa000888a0000888a000088a00aa08a00aa00a000000000000000
-- 030:000a00aa00a00a1a0030aa1a0030aaaa00a00aaa000a00aa0000a00a00000a33
-- 031:aa000a00a1a00300a1aa0300aaaa0300aaa03000aa00a000a00a000033a00000
-- 032:00000000000000e000000e00000000060000006b0000067b0000677700006777
-- 033:0066000006bb60006bbbb600bb1bbb60bb1b1bb6bbbb1bb6bbbbbb607bbbb600
-- 034:0000003306000333600333320033332203333222033322120333221203333222
-- 035:3300060033300060233330062233330022233300212233302122333022233330
-- 036:0000300000000000000000030000000000000002000000220003002200000222
-- 037:0000030030003330030003003000030000000000202220002222200022220000
-- 038:0000300f000300ff00300fff0030ff1f0030ff1f00300fff000300ff0000300f
-- 039:f0030000ff003000fff00300ffff03001fff03001ff00300ff003000f0030000
-- 040:0000000200000021000002110000211100021101000211010002211100002211
-- 041:2000000012000000112000001112000011112000011120000112200011221000
-- 042:0000000000000888000088880008883300088388000888330000888800008889
-- 043:0000000088800000888800003388800088388000338880008888880098888800
-- 044:0000000000000008000aa00a000a00a800000a880000a888088a8888008a8881
-- 045:8000000080000000a00aa0008a00a00088a00000888a00008888a8008188a880
-- 046:0000000000000000000022220002ee11002eeee102ee1eee2eee1e1e2eeeee1e
-- 047:000000000000000022220000122220001122220011222200e2222200e2200000
-- 048:00067777000677770000677700e006770e000677000e00660000000000000e00
-- 049:77bb6000777600007760000066000000600e000000e000000000000000000000
-- 050:6333332206333332006333330000000000000000000000000000000000000000
-- 051:2233366023336660666666660006666600006660000666000666600066660000
-- 052:0000022300300333000033130000331300000333000000330000000300000000
-- 053:3320000033330000133300301333000033300000330000003000000000000000
-- 054:00003f000ff030000fff300fffff3f0ffff30f0fff300000ff3333000fffff3f
-- 055:00f3000000f30000f0f300f000030f0f00f0300ff000030f003333f0ffffff00
-- 056:0000022100000022000000120000012200001121000122220000112100000011
-- 057:1222000022210000121000001210000022100000222100002111000010000000
-- 058:0008889900088991000899910008999900088999000088990000088900000088
-- 059:9988880099988800919980009199800099988000998800009880000088000000
-- 060:0000a88100000a88000a00a8000aa00a000000a8000000a80000aaaa000aaaaa
-- 061:818a000088a000008a00a000a00aa0008a000000aa000000aa000000aaa00000
-- 062:21eeeeee211eeee22111ee222211222202222220022222220022222200000000
-- 063:2220000022220000222222002002220022000000022000000000000000000000
-- 064:000000000000000000000000000000d00000dddd0d0dddd90d95d55909555555
-- 065:0000000000000000000000000000000000000000dd99d000ddd99800999d8900
-- 066:000000060000006e000006e400006e440006e4440006e444006e334406e33334
-- 067:ee60000044e60000144e60001414e60044144e6044444e604444ee60444ee600
-- 068:0000880000089980008999980899999989999999899191998891919908899998
-- 069:0000000000080000000088008008988098899880989888008898800088888000
-- 070:0000000300000032000003220000322200032121000321210003322200033322
-- 071:3000000023000000223000002223000022223000222230002223300022333000
-- 072:0000000000000000000000000000000000000222000023320002333300231313
-- 073:0000000000000000000000000002200022222200222222002222220032222200
-- 080:05515155055151550955555d0095555900095599000000000000000000000000
-- 081:5d9d8800dd999880dd9888809989898098988880088988808888aaa88aaaaaa8
-- 082:6e3333336e3333336e3333336e3333336e33333e6e33333e06eeeee600666666
-- 083:44ee600033e600003e600000e600000060000000e60000006660000006660000
-- 084:0088998800088888000988880009998800000099000000090000000000000000
-- 085:9999800088898800898988808899888089988880898888808998880088988000
-- 086:0000333200003333033003333330033300303333000033330003333000000000
-- 087:2333300033330000333000003300000030000000000000000000000000000000
-- 088:0023131300023333000023320000022200000000000000000000000000000000
-- 089:3222220022222000220000000000000000000000000000000000000000000000
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
-- 000:0000003434348d8d8dffffffff007de23000009dfa00ff91fa9100ff5d00f6e600a5ff0000de008950007904e2ffc695
-- </PALETTE>

