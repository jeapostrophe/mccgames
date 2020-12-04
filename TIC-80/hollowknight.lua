-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua

--FLAGS
--0=solid
--1=Hazardous
--2=Breakeble

p={
 x=15*8,
 y=14*8,
 s=256,
 f=0
}

function TIC()

	function move(dx,dy)
	  local nx=p.x+dx
	  local ny=p.y+dy
		 if not fget(mget(nx,ny),0) then
		  p.x=nx
		  p.y=ny
		 end
	 end

	if btnp(0) then move(0,-8) p.s= 256 end
	if btnp(1) then move(0,8) p.s= 256 end
	if btn(2) then move(-1,0) p.s=257 p.f=1 end
	if btn(3) then move(1,0) p.s=257 p.f=0 end

	cls(1)
	map(0,119,30,17,0,0,8)
	map(0,0,30,17,0,0,8)
	spr(p.s,p.x,p.y,8,1,p.f)
	map(30,119,30,17,0,0,8)
end

-- <TILES>
-- 000:8888888888888888888888888888888888888888888888888888888888888888
-- 001:000000000f377110000000000011111088000000803710018071110088010000
-- 002:0000000077111110000000000011111000000000000000000000000000000000
-- 003:0000000011111770000000000011110000000000001011080000110801000008
-- 004:000000001a337111000000000011110000000000000000000000000000000000
-- 005:008099000900066b8096000000066b509000b50009600000006b00050bb00201
-- 006:0b5000000510bb50000015502005000221011002000002000050000501110000
-- 007:0099080056600090010069080156600020150009000106902050160000100150
-- 008:0b51000000515000000155000110151005111010800051018880050588880000
-- 009:0002005001001000050150150005005001000000100015080501500800000088
-- 010:8000000000333333037777770700000007000000070000000011111180000000
-- 011:0000000033333333777777770000000000000000000000001111111100000000
-- 012:0000000833337100777777100000001000000010000000101111110000000008
-- 016:8830830888f08f0888f08f0888ffff088800000888f08f0888f33a08883ff008
-- 017:8000000000371000007100000001001080000000037110000711010080100000
-- 019:0000000000010010000010100010110800001108010000080001710000001100
-- 021:0b5000500000000005500210b5110110b511000005105510000001000b550020
-- 022:0110000011001100100010000010000001100000010001000000100000000000
-- 023:0000155501550150001000000200155005000150000000000120015001101155
-- 024:00000bb001bb05510551001100020505b5000001b51022000115005500111550
-- 025:000b5b1002b555500b5b55710555577150575710110111110501105500055000
-- 026:883fa0108880001033fa3010800000108883f0008800000083fa300000000000
-- 027:0103af3301000008010f3888010000880003af3800000000000af38800000888
-- 028:38883888f038f088a0f0a03830a030a000000000037111110000000000111110
-- 029:000000000011100000000000a030a03030a0a0a088a030a08830883088888888
-- 032:883fa008880aa0088830030888affa088800000888a0830888f08f0888008008
-- 033:0001000080710000007100000000000000111000000000000711110000000000
-- 034:0000000000000000000000000000000000111000000000000711110000000000
-- 035:0000000000011710010017000000000800111000000000000711110000000000
-- 036:000000003aaaa37101777710000000001b10b505111055000050110501110000
-- 037:0b51000006515000090155006006151000690010809006610600090000806000
-- 038:0000211002200000000005010110550555511101111060060600900909000006
-- 039:0002005001001060050150900005600601009600166009080090006080060800
-- 040:0000000000005500000551050000110105100000511022000100210000000000
-- 041:0000511001100000022000010000110011005500551000051115550100011100
-- 048:888888888888888888888888888888888888880088888003888803038888030a
-- 049:888888888888888888888888888888880000000003030307030303070a0a0303
-- 050:8888888888888888888888888888888808888888008888880308888807088888
-- 051:8000000000371000007100000001001080000000037110000711010080100000
-- 052:0000000800017300000017000100100000000008000117300010117000000108
-- 053:888888008888880a8888000088800a308880a30088000000000a00030aa00701
-- 054:0a3000000310aa30000013307003000771011007000007000030000301110000
-- 055:0088888830088888010088880130088870130088000100087030100000100130
-- 056:0b51000000515000000155000110151005111010800051018880050588880000
-- 057:0002005001001000050150150005005001000000100015080501500800000088
-- 064:88880a0388880a0a88880000888033338803aaaa88000000888070708880a000
-- 065:030a0a070a0a0a030000000033377777aaaaa3a3000000008888888088888880
-- 066:0308888803088888000888887770888833370888000008887070888800a08888
-- 069:0a3000300000000003300710a3110110a311000003103310000001000a330070
-- 070:0110000011001100100010000010000001100000010001000000100000000000
-- 071:0000133301330130001000000700133003000130000000000170013001101133
-- 072:00000aa001aa03310331001100070303a3000001a31077000113003300111330
-- 080:888888888888888888880000888033338803aaaa88000000888070708880a000
-- 081:88888888888888880000000033377777aaaaa3a3000000008888888088888880
-- 082:8888888888888888000888887770888833370888000008887070888800a08888
-- 085:0a31000000313000800133008800131088800010888880018888880088888888
-- 086:0000711007700000000003010110330333311101111000000000000088888888
-- 087:0007003001001000030130880003008801000888100888880088888888888888
-- 089:0000311001100000077000010000110011003300331000031113330100011100
-- 096:888888888888888888880000888003338880aaaa88800000888070708880a000
-- 097:88888888888888880000000030377777aaaaa0a3000000008888888088888880
-- 098:8888888888888888000088887777088833370888000008887070888800a08888
-- 104:0000000000003300000331030000110103100000311077000100710000000000
-- 105:0000000000330000301330001011000000000130007701130017001000000000
-- 120:0000000001007100311077000310000000001101000331030000330000000000
-- 121:0000130000000000017011300770133000000300001100000113000000300000
-- 224:8888888888888888008888080008800800000088000000800000000000000000
-- 225:8880888888800888808800000008800000080000008800000000000000000000
-- 226:8888888888888888808888880008880000088000000080080000800800000000
-- 227:0000000080000008800000888800008888000088888008888880888888888888
-- 228:8888888888888888000008888000800800000000000000000000000080000008
-- 229:8888888888000088800000080000000000000000000000000000000080000008
-- 230:8888888808888088008800880000000800000000000000000000000000000000
-- 231:8088880880088008000000008008800880088008800880088008800880088008
-- 233:8888811188811111881111118111111181111111111111111111111111111111
-- 234:1118888811111888111111881111111811111118111111111111111111111111
-- 240:0000000000000000800000008000000080000000880080008808800088888800
-- 241:8000088888800088888800008888800088880000888800008000000000000000
-- 242:0000000000000000000000000000000880000008880008088800880888808888
-- 243:0000000080008000800088008808880088088880888888808888888088888888
-- 244:8888888888800008008000080080000800000008000000000000000000800008
-- 245:8800008800000000800000080000000800000000000000000000000080000008
-- 246:8888888888888888888888888888888088888800888888008888800088888000
-- 247:8888888888888888888888880888888800888888008888880008888800088888
-- 248:1111111111111111111111111111111111111111111111111111111111111111
-- 249:1111111111111111111111118111111181111111881111118881111188888111
-- 250:1111111111111111111111111111111811111118111111881111188811188888
-- </TILES>

-- <SPRITES>
-- 000:0ff0ff080f000f0880fff088807f70880afff0888011108880111a0880117088
-- 001:880f0888880f088880fff08880ff70880afff088801110888011108880117088
-- 002:000f0000000f000000fff00000ff70000afff000011100000111000001170000
-- 003:0000000000000000100011000011001100000000001001100101000100100110
-- 004:000f0000000f000010fff00000ff70000afff000111100000111000011170000
-- 005:0f000000f0f0aff0f0000000f0afff0ff0000000f000aff0f0f000000f000000
-- 006:000000000afffff0000affffa0aff7f7000affff0afffff00000000000000000
-- 007:00000ff00000fff00000ff000000fff000000ff000000fff000000ff00000000
-- 008:00000000f00f000f000f0f0ff0000f0ff0f00f0f00f00000f000f00fffffffff
-- 009:0ff000000fff000000ff00000fff00000ff00000fff00000ff00000000000000
-- 010:07a000007aaa0000aa00fff00a0ffaff00faffff00fffa0f00fff0a0000fff0a
-- 011:00ffff000aaffaa0faaffaafffffffffffa0a0fff0a0a00fff00a0ff0f0000f0
-- 012:00000a700000aaa70fff00aaffaff0a0ffffaf00f0afff000a0fff00a0fff000
-- 013:0000000f00000fff000000ff0000000f00000000000000000000000000000000
-- 014:fffff000ffffff00ffffffa0ffffaa00fffaaa000aaaa00000aa00000a0a0000
-- 016:07707700070007000077700000f7f0000a7770000007700000770a0000707000
-- 017:0007000000070000007770000077f0000a777000007700000007700000770000
-- 018:0007000000070000007770000077f0000a777000077070000077000007700000
-- 019:0000000000000000700077000077007700000000007007700707000700700770
-- 020:0007000000070000707770000077f0000a777000777070000077000077700000
-- 021:0777000070700177700000007017770770000000710017707070000007770000
-- 022:00017700017777700001777710177f7f00017777017777700001770000000000
-- 023:0000011000001770001077000000717000100770001007170001007700001111
-- 024:0000000010010001000701071000070770100707007000007000100777777777
-- 025:0110000007710000007701000717000007700100717001007700100011110000
-- 026:01700170177707707700fff0070ffaff00faffff00fffa0f17fff0a0770fff0a
-- 027:0077770001177110711771177777777777101077701010077700107707000070
-- 028:71000710770077710fff0077ffaff070ffffaf00f0afff000a0fff71a0fff077
-- 029:00000fff0000000f000000000000000000000000000000000000000000000000
-- 030:fffff000ffffff000ffffff000ffffff00aaaaaf0aaaaaaa00aaaaa000000000
-- 032:00fffffa00000000000000000fffffaa000000ff000000000000000000fffffa
-- 033:a00f00ff00f0a00000f00000a0f0afafa0f0afaa00f0000000f0a000a00f00ff
-- 034:000000f0000000f000000fffaff00ff7afa00fff000111000007110000000000
-- 035:8888888888800888880110888017710880777708880770888880088888888888
-- 036:8800008880affa0880fffa08807ff70880fffa08880aa0888880088888888888
-- 037:88000088803dd30880ddd308801dd10880ddd3080303308880800d0888888088
-- 038:8880088888099088809ee908807ee708809ee908880990888880088888888888
-- 040:0000000000000000000000000000000000000100000010000000110000001000
-- 041:0000000000000000000000000000000001000000001000000110000000100000
-- 042:000000000000000000000000000000000000000000099900009eeef009eefef0
-- 044:0000000000000000000000000000000000000000000008000000030000003830
-- 048:000a0000000aaaaa000aaaaa000aa7a700aa7aaa000a77a70000aaaa00777777
-- 049:0a000000aa000000aa007a70aa00aaa07aa07a707a000300a000030077700300
-- 050:0000000000000000000000000000000000f0f00000f0f00000f0f00000fff000
-- 051:011011000100010001101100011011000111110001fff100017f710000fff000
-- 052:011011000100010001101100011011000111110001fff100017f710000fff000
-- 053:011011000100010001101100011011000111110001fff100017f710000fff000
-- 054:000f00000000011100001aaa0f01a9aa0001aa770701a7aa0071111200077122
-- 055:0000000011000000aa1000f0a9a100007aa10000a7a107001111700021770000
-- 056:00001133000013f3000003330022022202662222026226660022222200216666
-- 057:31100000f3100000330000002202200022266200662262002222200066622100
-- 058:09eeff0000fff000009fe000a0fff0000a01110000a711000001110000111710
-- 059:0ff0ff000f000f000f000f000ff0ff000fffef000ffeff000f9f9f0000fff000
-- 060:08038f8388039f988108fff80107333708183337000733380000777000010001
-- 061:0000000008000000088000000180000010000000080000000000000000000000
-- 064:0733333311777777113333330777777707333333077777770133333301177777
-- 065:3337030077711300333113007777030033370300777703003331030077110300
-- 066:007f7000a0fff0000a06000000626000006620000066200000662a0000662000
-- 067:070a07007033307070aaa0707033307070aaa0707733377070aaa070770a0770
-- 068:070a07007033307070aaa0707033307070aaa0707733377070aaa070770a0770
-- 069:070a07007033307070aaa0707033307070aaa0707733377070aaa070770a0770
-- 070:000111220001122200111222001012200000007000f000700f0f000000f00000
-- 071:2111000022110000221110002710100007000000070f00f00700000000000000
-- 072:0012122200221666002112220002166600012222000002110000070100000700
-- 073:2222101066622010222221106622001022200100120000001700000007000000
-- 075:0333330033333330333333303333333033333330333730303377703030070070
-- 080:00000000000000000000000000f00f0f00f0f00f007979790073333300073333
-- 081:0000000000000000000000000f00f00000f0f0007979700033337000e3370000
-- 083:0070700000707000007070000070700000707000007070000070700000707000
-- 084:0070700000707000007070000070700000707000007070000070700000707000
-- 085:0070700000707000007070000070700000707000007070000070700000707000
-- 091:307070f030707fff007070f0007070f0007070f0007070f0007070f0007070f0
-- 096:0a007399a0a0739ea00a73990100733301107931010173310100077101000001
-- 097:93700a009e70a0a0937a00a03370010033901100337101007700010000000100
-- 130:0000000000000000000000000000000000000000000000000f0f00000fff0000
-- 134:00000000000500050555005500550b5b000055555005555555b5555555555b55
-- 135:000000000050000000550000055500005555050055555505b55b5555bb555555
-- 144:000000000fff000009f970000fff370001313700013137000077710000010100
-- 145:f0000000ffff000009f970000fff370001313700013137000077710000010100
-- 146:09f900000fff0000017170000171700001717000007770000010100000101000
-- 147:0000000000000000000000000a0a0a0000fff000afffffa0afffff70f1f1f1f0
-- 148:0000000000000000000000000303030003373300337773303777779071717170
-- 149:0000000005050500005555055555b55005b55bb555b5b7775b5b59795bbbb777
-- 150:05555b55505bbb555555bb555555bb5555b55bb555bb55bb55bbb5bb5bbbbbbb
-- 151:55bb5b5b55bbbb55b5777777bb77777755997799559977995b777777bb777777
-- 196:88888888888888aa8888ff77888f33ff88f3afff88f3ffff8a7fffff8a7fffff
-- 197:88888888aa88888877338888ff117888fff31788ffff1788ffffa178ffffa178
-- 198:88888888888888aa8888ff77888f770088f7000088f3ffff8a7fffff8a7fffff
-- 199:88888888aa888888773388880011788800000788ffff1788ffffa178ffffa178
-- 200:88888888888888aa8888ff77888f770088f7000088f700008a7000008a7fffff
-- 201:88888888aa8888887733888800117888000007880001078800110078ffffa178
-- 202:88888888888888aa8888ff77888f770088f7000088f700008a7000008a700000
-- 203:88888888aa888888773388880011788800000788000107880011007801110078
-- 204:88888888888888aa8888ff77888f770088f7000088f700008a7000008a700000
-- 205:88888888aa888888773388880011788800000788000107880011007801110078
-- 206:88888888888888aa8888ff77888f770088f7000088f700008a7000008a700000
-- 207:88888888aa888888773388880011788800000788000107880011007801110078
-- 208:8888888888888888888008888807708888073088888008888888888888888888
-- 212:8a7fffff8a7fffff8831ffff88313fff888311aa888833118888887788888888
-- 213:fffaa178fffa3178ffaa1788aaa71788a3117888117788887788888888888888
-- 214:8a7fffff8a7fffff8831ffff88313fff888311aa888833118888887788888888
-- 215:fffaa178fffa3178ffaa1788aaa71788a3117888117788887788888888888888
-- 216:8a7fffff8a7fffff8831ffff88313fff888311aa888833118888887788888888
-- 217:fffaa178fffa3178ffaa1788aaa71788a3117888117788887788888888888888
-- 218:8a7000008a7aaaaa8831aaaa88313aaa88831133888833118888887788888888
-- 219:11110078aaa33178aa3317883337178837117888117788887788888888888888
-- 220:8a7000008a7000018831011188313aaa88831133888833118888887788888888
-- 221:1111007811110078111007883337178837117888117788887788888888888888
-- 222:8a7000008a700001883101118831001188831100888833008888887788888888
-- 223:1111007811110078111007881100078800007888007788887788888888888888
-- 224:0000000000000000000000000000000000f0001f00f000f000f000f000f000f0
-- 225:000000000000ffff013f300000000000f10f000f0f0f000f0f0f000f0f0f0f0f
-- 226:0000003ff33000f000ffffff00000000000f00f0000f00f0000f0f00000ff000
-- 227:30000000f00033fffffff00000000000f00f0fffff0f00f0f0ff00f0f00f00f0
-- 228:00000000fff00000003f31000000000000fff0f00f0000f00f0000ff0f0ff0f0
-- 229:000000000000000000000000000000000f0fff000f00f000ff00f0000f00f000
-- 240:00f000f000fff01f000000000000013000000003000000000000000000000000
-- 241:0f0ff0fff10f000f000000000003ffffffff00000000030f000010f300000000
-- 242:000f0f00000f00f000000000ff330000000ffff0ff0000ff033ffff000000000
-- 243:f00f00f0f00f0fff0000000000033fffffff0000f0000fffffff330300000000
-- 244:0f00f0f000fff0f000000000fff30000000fffff03000000f010000000000000
-- 245:0f00f0000f00f000000000000310000030000000000000000000000000000000
-- </SPRITES>

-- <MAP>
-- 000:212121740000542121212121740000000000000000542121212121212121212121212121212121212121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:212186750000542121212121740000000000000000542121212121212121212121212121212121212121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:218675000000542121212121740000000000000000542121212121212121212121212121212121212121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:867500000000542121212121740000000000000000542121212121212121212121212121212121212121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:740000000000542121212186750000000000000000559621212121212121212121212121212121212121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:74000053c1c1972121218675000000000000000000005596212121212121212121212121212121212121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:740000542121212121867500000000000000000000000055962121212121212121212121212121212121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:740000542121212186750000000000000000000000000000559621212121212121212121212121212121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:740000542121212174000000000000000000000000000000005421212121212121212121212121212121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:740000542121212174000000000000000000000000000000005421212121212121212121212121212121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:740000542121212174000000000000000000000000000000005496212121212121212121212121212121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:740000542121212174000000000000000000000000000000005565656565656565956565656565656565656565656595656565656565656565656565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:740000556565659674000000000000000000000000000000000000000000000000840000000000000000000000000084000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:740000000000003343000000000000000000000000000000000000000000000000010000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:740000000000003343000000000000000000000000000000000000000000000000020000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:876363636363639787636363636363636363636363636363636363636363636363636363636363730616265363636363636363636363636363636363000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:212121212121212121212121212121212121212121212121212121212121212121212121212121876363639721212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 119:212121212121212121212121212121212121212121212121212121212121646464646464647400000000000000000000000000000055966464646464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 120:212121212121212121212121212121212121212121212121212121212121646464646464647400000000000000000000000000000000546464646464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 121:2121212121212121212121212f2121212121212121212121212121212121646464646464647400000000000000000000000000000000559664646464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 122:212f3f21212121212121212f000f21212121212f3f21212121212121212f646464646464647400000000000000000000000000000000005464646464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 123:3e00002f3e3f212121212f0000000f2121213e00002f3e3f212121212f00646464646464867500000000000000000000000000000000005596646464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 124:0000000000002f3f2f3e0000000000212f3e0000000000002f3f2f3e0000646464646486750000000000000000000000000000000000000054646464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 125:0000000000000000000000000000003e0000000000000000000000000000646464648675000000000000000000000000000000000000000055659664000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 126:000000000000000000000000000000000000000000000000000000000000646464867500000000000000000000000000000000000000000000005565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 127:000000000000000000000000000000000000000000000000000000000000646464740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 128:000000000000000000000000000000000000000000000000000000000000646464740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 129:0000000000000000001f0e000000000000000000000000000000001f0e00646464876373000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 130:0000001f0e00001f1e21212e0000000000000000001f0e00001f1e21212e646464646487730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 131:001f1e21210e1e21212121211e2e00000000001f1e21210e1e2121212121646464646464877300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 132:1f212121212121212121212121210e1e2e1e1f2121212121212121212121646464646464647400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 133:212121212121212121212121212121212121212121212121212121212121646464646464647400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 134:212121212121212121212121212121212121212121212121212121212121646464646464647400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 135:212121212121212121212121212121212121212121212121212121212121646464646464648773000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <FLAGS>
-- 000:00101010103010301010101000000000101010100010101010003030303000001010101010303030101000000000000000000050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010000000000000000000000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </FLAGS>

-- <PALETTE>
-- 000:0000001d2b537e255383769cab5236008751ff004d5f574fff77a8ffa300c2c3c700e436ffccaa29adffffec27fff1e8
-- </PALETTE>

