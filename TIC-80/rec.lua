-- title:  R.E.C.
-- author: Balistic Ghoul Studios
-- desc:   short description
-- script: lua

x=8
y=12*8
s=288

hx=1*8
hy=15*8

ix=8*8
iy=15*8

itmspr=501
gunspr=486-- chosen itm
driverspr=503
bulletspr=504
riflespr=505
clipspr=506
bazzokaspr=507
roketspr=508
ak47spr=509
grenadespr=510

function TIC()

	if btnp(0) then y=y-8 s=256 end
	if btnp(1) then y=y+8 s=256 end
	if btnp(2) then x=x-8 s=320 end
	if btnp(3) then x=x+8 s=288 end
	
	if btnp(5) then 
		if bulletspr>344 then 
			bulletspr=bulletspr-16
		else
			bulletspr=344
			gunspr=502
	 end
	end
	
 --if btnp(4) then 
	 --Interact
 --end
	
	cls(0)
	map(0,0)
	spr(416,17*8,8*8,3,1,0,0,2,2)
	spr(418,20*8,4*8,3,1,0,0,2,2)
	spr(s,x,y,3,1,0,0,2,2)
	--HP Draw
	spr(480,hx,hy,0)
	spr(480,hx+8,hy,0)
	spr(480,hx+16,hy,0)
	spr(480,hx+24,hy,0)
	spr(480,hx+32,hy,0)
	spr(480,hx+40,hy,0)
	--ITEMS Draw
	spr(gunspr,ix,iy)
	spr(bulletspr,ix+8,iy)
	spr(itmspr,ix+16,iy)
	spr(itmspr,ix+24,iy)
	spr(itmspr,ix+32,iy)
	spr(itmspr,ix+40,iy)
	
	--print("10",ix+8,iy+8,12,0,1,1)
end

-- <TILES>
-- 000:9999999999999999999999999999999999999999999999999999999999999999
-- 001:5555555565656565e6e5e6e5eee6eee6eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 003:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 004:0000000f000000ff000005ff00000ff00000d000000000000000000000000000
-- 005:0000000f000000ff000002ff00000ff00000d000000000000000000000000000
-- 006:9998800099988000999880009998800099988000999880009998800099988000
-- 007:99999999999999999999999999999999ffff9999ffff9999ffff9999ffff9999
-- 008:00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd
-- 009:dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00ddffdd00
-- 010:00dddddf00dddddf00dddddf00dddddf00dddddf00dddddf00ddddf200dddf22
-- 011:fddddd00fddddd00fddddd00fddddd00fddddd00fddddd002fdddd0032fddd00
-- 012:00dddddd00dddd2d00ddddd200dddd2200dddd2d00dddddd00dddd2d00dddddd
-- 013:dddddd002ddddd002ddddd002ddddd00dddddd002ddddd00dddddd00ddffdd00
-- 016:9999999f999999ff999995ff99999ff99999d999999999999999999999999999
-- 017:9999999f999999ff999992ff99999ff99999d999999999999999999999999999
-- 018:999dd000999dd000999dd000999dd000999dd000999dd000999dd000999dd000
-- 019:0dddddd000777700000770000000000000000000000000000000000000000000
-- 020:0dddddd000cc0c00000c00000000000000000000000000000000000000000000
-- 021:ffffffffffffffffffffffffffffffffeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 022:222f2222f22ff2fff2fffff2fffff2ffee2eeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 024:00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd
-- 025:ddffdd00ddffdd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00
-- 026:00dddf2200ddddf200dddddf00dddddf00dddddf00dddddf00dddddf00dddddf
-- 027:22fddd002fdddd00fddddd00fddddd00fddddd00fddddd00fddddd00fddddd00
-- 028:00dddddd002ddddd00ddd2dd002ddddd002222dd00222ddd0022222d00222222
-- 029:ddffdd00ddffdd00dddddd00dddddd002ddddd00dddddd00dddddd00dddddd00
-- 032:99999999999999999999999999999999999966669996bbbb9996fbbf9996bfbb
-- 033:9999999999999999999999999999999966699999bbb69999bbb69999fbb69999
-- 034:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 035:ffffffffffffffffffdddddfffdddddfffdddddfffdddddfffdddddfffdddddf
-- 036:fffffffffffffffffdddddfffdddddfffdddddfffdddddfffdddddfffdddddff
-- 037:00dd3d0000d77d0000dddd000000000000000000000000000000000000000000
-- 038:f0000000ff000000ff2000000ff00000000d0000000000000000000000000000
-- 039:f0000000ff000000ff5000000ff00000000d0000000000000000000000000000
-- 040:00dddddd00dddddd00dddddd00ddd7f700dddf7f00dddddd00dddddd00dddddd
-- 041:dddddd00dddddd00dddddd007f7ddd00f77ddd00dddddd00dddddd00ddffdd00
-- 042:00dddddd00dddddd00ddddff00ddddff00ddddff00dddfdf00ddddfd00dddddd
-- 043:dddddd00dddddd00fddddd00fddddd00fddddd00dfdddd00fddddd00ddffdd00
-- 044:00dddf8800dddf8800dddf8800dddf8800dddf8800dddf8800ddf88800df8888
-- 045:88fddd0088fddd0088fddd0088fddd0088fddd0088fddd00822fdd002232fd00
-- 048:9996bbfb9966666699677ddd9967cdcd99666ddd99fdf66699fdf99999fdf999
-- 049:bfb6999966666999dd776999cd7c6999dd66699966fdf99999fdf99999fdf999
-- 050:000000000000000000000000000000000000000000dddd0000d22d0000d3dd00
-- 051:ffdddddfffdddddfffdddddfffdddddfffdddddfffdddddfffdddddfffdddddf
-- 052:fdddddfffdddddfffdddddfffdddddfffdddddfffdddddfffdddddfffdddddff
-- 053:222f2222f22ff2fff2fffff2fffff2ffff2fffffffffffffffffffffffffffff
-- 056:00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd
-- 057:ddffdd00ddffdd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00
-- 058:00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd
-- 059:ddffdd00ddffdd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00
-- 060:00df888800ddf88800dddf8800dddf8800dddf8800dddf8800dddf8800dddf88
-- 061:2222fd00822fdd0088fddd0088fddd0088fddd0088fddd0088fddd0088fddd00
-- 064:00000000dfffffd0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0dfffffd000000000
-- 065:000000000000000000000000000000000000000000ffff0000f66f0000ffff00
-- 066:0000000000000000000000000000000000000000000fffff000f3070000fffff
-- 067:0000000000000000000000000000000000000000fffff0003070f000fffff000
-- 068:0000000000000002000020000000000202002222000002220002222200222222
-- 069:0000000020000000000200002000000022220020222000002222200022222200
-- 072:00dddddd00dddddd00ddddff00ddddff00ddddff00dddfdf00ddddff00dddddd
-- 073:dddddd00dddddd00fddddd00fddddd00fddddd00dfdddd00fddddd00ddffdd00
-- 074:0dddddd80dddddd80dddddd80dddddd80dddddd80dddddd80dddddd80ddffdd8
-- 075:ffffff00ffffff008fffff008fffff0088ffff0088ffff00888fff00888fff00
-- 080:0000000000000000002020000002200000222000002000000000200000200000
-- 081:00f56f0000f65f0000ffff000000000000000000000000000000000000000000
-- 082:0000000002000200000200000022220000222000022220000002002000000000
-- 083:2220222202200200020000020000020000200000000000000000000000000000
-- 084:0022222200022222000002220200222200000002000020000000000200000000
-- 085:2222220022222000222000002222002020000000000200002000000000000000
-- 088:00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd
-- 089:ddffdd00ddffdd00dddddd00dddddd00dddddd00dddddd00dddddd00dddddd00
-- 090:0ddffdd80ddffdd80dddddd80dddddd80dddddd80dddddd80dddddd80dddddd8
-- 091:8888ff008888ff0088888f0088888f0088888800888888008888880088888800
-- 096:00ddd65500dddddd000555660005566600055666000556660005556600055656
-- 097:56ddd000ddddd000666500006665000066650000665500006555000056550000
-- 098:00ddd23300dddddd000ccccc055ccccc555ccccc555c55c50555555500055555
-- 099:32ddd000ddddd000cccc0000cccc0550cccc5550cc5c55505c55555555555555
-- 100:5550555505500500050000050000050000500000000000000000000000000000
-- 101:0000000000000005000050000000005505005555000005650005555600556566
-- 102:0000000050000000000500005000000055550050565000006555500066565500
-- 112:00056556000565560005556500055565000555650005556500dddddd00dddddd
-- 113:556500005565000065550000665600006565000065550000ddddd000ddddd000
-- 114:000555550555555c0555555c05555c5c0005cccc000ccccc00dddddd00dddddd
-- 115:55555555555c55005c5c5500cccc5500cccc0000cccc0000ddddd000ddddd000
-- 116:0000000005000500000500000055550000555000055550000005005000000000
-- 117:0055656600055556000005650500555500000005000050000000000500000000
-- 118:6656550065555000565000005555005055000000000500005000000000000000
-- </TILES>

-- <SPRITES>
-- 000:33333333333333333333333333333300333330ff33330fff33330fcf33330fff
-- 001:33333333333333333333333303333333f0333333ff033333cf033333ff033333
-- 002:33333333333333333333333333333300333330663333066633330fcf33330fff
-- 003:333333333333333333333333033333336033333366033333cf033333ff033333
-- 004:eeeeeeeeee0eeeeee030eeee03000eee073030ee03000eeee030eeeeee0eeeee
-- 005:eeeeeeeeeeeeeeeee000eeee033300ee0730030e033300eee000eeeeeeeeeeee
-- 006:eeeeeeeeeeeeeeeeeeeeeeeeee0000eeee0dd0eeee0000eeeeeeeeeeeeeeeeee
-- 013:2222222222022202200020002020000222000000200020002200000022002002
-- 014:2222222222202222020002220000002000200020000000000000002000002000
-- 015:2222222222020022000020020000002220200222000000220000000220002022
-- 016:333330ff33330f0f3330f00f3330f00f333300f0333330f0333330f0333330f0
-- 017:f03333330f03333300f033330efd0333f0ed0333f00d0333f00d0333f0303333
-- 018:333300ff3330ee0f3330efdf3333000d333330f0333330f0333330f0333330f0
-- 019:f03333330f0333330f033333d0d03333ed033333f0d03333f0033333f0333333
-- 020:eeeeeeeeeeeee0eeeeee030eeee00030ee030370eee00030eeee030eeeeee0ee
-- 021:eeeeeeeeeeeeeeeeeeee000eee003330e0300370ee003330eeee000eeeeeeeee
-- 022:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000eeeee070eeeee000eeeeeeeeeee
-- 023:eeeeeeeeeeeeeeeeee000eeeee070eeeee000eeeee070eeeee000eeeeeeeeeee
-- 024:eeeeeeeeee000eeeee070eeeee070eeeee000eeeee070eeeee000eeeeeeeeeee
-- 025:ee000eeeee070eeeee070eeeee070eeeee000eeeee070eeeee000eeeeeeeeeee
-- 029:2200000022200000220020002000000022000002222000002222202022200000
-- 030:0020000000000020000000000202000000000000000002200200000000000000
-- 031:0000022202022222000002222000002200000002000200220000022200000022
-- 032:33333333333333333333333333333300333330ff33330fff33330fff33330fff
-- 033:33333333333333333333333303333333f0333333ff033333cf033333ff000003
-- 034:33333333333333333333333333333300333330663333066633330fef33330fef
-- 035:333333333333333333333333033333336033333366033333cf033333ff030333
-- 036:e0ee0eee0c00c0eee0ee0eeee0eeeeee0c0eeeeee0eeeeeeeeeeeeeeeeeeeeee
-- 037:e0ee0eee0c00c0eee0c00c0ee00ee0ee0c0eeeeee0c0eeeeee0eeeeeeeeeeeee
-- 038:e0ee0eee0c00c0eee0c00c0ee00c00c00c00ee0ee0c0eeeeee0c0eeeeee0eeee
-- 039:eeeeeeeee00000ee0ccccc0e00c0c00e0000000e0c0c0c0e0ccccc0ee00000ee
-- 040:eeeeeeeeeeeeeeeee00000ee0ccccc0e00c0c00e0c0c0c0e0ccccc0ee00000ee
-- 041:eeeeeeeeeeeeeeeeeeeeeeeee00000ee0ccccc0e0ccccc0e0ccccc0ee00000ee
-- 045:2202000220000000220000002220020222000000200200002200202222222222
-- 046:0000200000000020000000000020002000000020020002222220222222222222
-- 047:2002002200000022000200020000002220000202000200022022202222222222
-- 048:333330ff33330f0f3330f00f3330f00f333300f0333330f0333330f0333330f0
-- 049:f00dddd00fffe003000e033300303333f0333333f0333333f0333333f0333333
-- 050:333330fe33330eed3330fe0f33330f0f333330f0333330f0333330f0333330f0
-- 051:f000d033dddddd030fefe03300f00333f0033333f0333333f0333333f0333333
-- 064:33333333333333333333333333333300333330ff33330fff33330fcf00000fff
-- 065:33333333333333333333333303333333f0333333ff033333ff033333ff033333
-- 066:33333333333333333333333333333300333330663333066633330fcf33030fff
-- 067:333333333333333333333333033333336033333366033333ef033333ef033333
-- 072:cc8888ccc000000c80000008800000088000000880000008c000000ccc8888cc
-- 074:cc8888ccc000000c80000008800000088000000880000008c000000ccc8888cc
-- 080:dddd00ff00efff0f330e000f3330300f333330f0333330f0333330f0333330f0
-- 081:f03333330f03333300f0333300f03333f0033333f0333333f0333333f0333333
-- 082:30d000fe0ddddddd30efef0f3300f00f333300f0333330f0333330f0333330f0
-- 083:f0333333ee0333330ef033330f033333f0333333f0333333f0333333f0333333
-- 088:fffffffff000000ff000000ff000000ff000000ff000000ff000000fffffffff
-- 090:fffffffff000000ff000000ff000000ff000000ff000000ff000000fffffffff
-- 096:33333333333333333333333333333300333330ff33330fff33330fff33330fff
-- 097:33333333333333333333333303333333f0333333ff033333ff033333ff033333
-- 098:33333333333333333333333333333300333330663333066633330f6633330fff
-- 099:3333333333333333333333330333333360333333660333336f033333ff033333
-- 104:fffffffff000000ff007000ff700700ff700030ff303770ff000000fffffffff
-- 106:fffffffff000000ff008800ff00ff00ff0f8800ff08f000ff000000fffffffff
-- 112:333330ff33330f0f3330f00f3330f00f333300f0333330f0333330f0333330f0
-- 113:f03333330f03333300f033330efd0333f0ed0333f00d0333f00d0333f0303333
-- 114:333300ff3330ef0f3330efdf3333000f333330f0333330f0333330f0333330f0
-- 115:f03333330f0333330f033333dfd03333fd033333f0d03333f0033333f0333333
-- 120:fffffffff000000ff007000ff700700ff70003ccf303770cf00000cfffffffcc
-- 122:fffffffff000000ff008800ff00ff00ff0f880ccf08f000cf00000cfffffffcc
-- 128:3333333333333333333333333333330033333088333308883333081833330888
-- 129:3333333333333333333333330333333380333333880333331803333388033333
-- 130:3333333333333333333333333333300033330888333088883330888833330888
-- 131:3333333333333333333333330333333380333333880333331803333388033333
-- 132:3333333333333333333333333333330033333088333308883333081833330888
-- 133:3333333333333333333333330033333388033333888033338880333388033333
-- 134:3333333333333333333333333333330033333088333308883333088833330f88
-- 135:333333333333333333333333033333338033333388033333880333338f033333
-- 136:fffffffff000000ff007000ff700700ff700030ff30377ccf00000cfffffffcc
-- 138:fffffffff000000ff008800ff00ff00ff0f8800ff08f00ccf00000cfffffffcc
-- 140:cc8888ccc000000c80000008800000088000000880000008c000000ccc8888cc
-- 142:cc8888ccc000000c80000008800000088000000880000008c000000ccc8888cc
-- 144:333330c233330828333080083330800833330080333330803333308033330880
-- 145:c03333330803333320803333008000338f000f0380f0f033800f033388003333
-- 146:333330883333080833308008300080080f000f8030f0f080330f008033300880
-- 147:c203333308033333208033330080333380033333803333338033333388033333
-- 148:333302c833330808333080283330800833330080333330803333308033330880
-- 149:803333330803333300803333008000338f000f3380f0f033800f033388003333
-- 150:333330ff33330f0f3330f02f3330f00f333300f8333330f0333330f033330ff0
-- 151:f03333332f03333300f0333300f0003388000803f0808033f0080333ff003333
-- 152:fffffffff000000ff007000ff700700ff700030ff3037c0cf00000ccfffffffc
-- 154:fffffffff000000ff008800ff00ff00ff0f8800ff08f0c0cf00000ccfffffffc
-- 156:fffffffff000000ff000000ff000000ff000000ff000000ff000000fffffffff
-- 158:fffffffff000000ff000000ff000000ff000000ff000000ff000000fffffffff
-- 160:3333333333333333333333333333333333333333233333333333333333333223
-- 161:3333333333333333333333333333333333333333333333333332333333333333
-- 162:33333333333333333333332333323223333333333333233333223333332233ff
-- 163:33333333333333333333233332333333333333333332332233323322f3333333
-- 164:3333333333333333333333333333333333333333333333333333333333333333
-- 165:3333333333333333333333333333333333333333333333333333333333333333
-- 166:3333333333333333333333333333333333333333333333333333333333333333
-- 167:3333333333333333333333333333333333333333333333333333333333333333
-- 168:fffffffff000000ff007000ff700700ff70003ccf30377cff000000cffffffcc
-- 170:fffffffff000000ff008800ff00ff00ff0f880ccf08f00cff000000cffffffcc
-- 172:fffffffff000022ff000222ff002220ff0c2200ffdcc00cff0d000ccffffffcc
-- 174:fffffffff000000ff000dd0ff065d00ff6565d0ff5656dcff05600ccffffffcc
-- 176:333233333332233333333333333fff3333fff8f333f8fff333ff2fffff32f23f
-- 177:32233333322333333333333333332333f3333333f33ffff33ff333332322fff3
-- 178:33323fff33233f8f33233fff323f33f23223ff3f3333333f33333332333ffff3
-- 179:8f333333ff33333322333333f33323333f33333233ff333333333333ffff3333
-- 180:3333333333333333333000333302880330888f80308f8880008882c08208c208
-- 181:3333333333333333333333333333333333300003300888800880000380028880
-- 182:33333333333333333330003333026603306266603e2ff8fee028fff0f20fff0f
-- 183:3333333333333333333333333333333333300003300ffff0eff00003f002fff0
-- 184:fffffffff000000ff007000ff700700ff700030ff30377cff00000ccffffffcc
-- 186:fffffffff000000ff008800ff00ff00ff0f8800ff08f00cff00000ccffffffcc
-- 188:fffffffff000022ff000222ff002220ff0c220ccfdcc00cff0d0000cffffffcc
-- 190:fffffffff000000ff000dd0ff065d00ff6565dccf5656dcff056000cffffffcc
-- 200:fffffffff000000ff007000ff700700ff700030ff30377ccf000000cfffffffc
-- 202:fffffffff000000ff008800ff00ff00ff0f8800ff08f00ccf000000cfffffffc
-- 204:fffffffff000022ff000222ff002220ff0c2200ffdcc0c0cf0d000ccfffffffc
-- 206:fffffffff000000ff000dd0ff065d00ff6565d0ff5656c0cf05600ccfffffffc
-- 216:fffffffff000000ff007000ff700700ff700030ff30377ccf00000ccffffffcc
-- 218:fffffffff000000ff008800ff00ff00ff0f8800ff08f00ccf00000ccffffffcc
-- 220:fffffffff000022ff000222ff002220ff0c2200ffdcc00ccf0d000cfffffffcc
-- 222:fffffffff000000ff000dd0ff065d00ff6565d0ff5656dccf05600cfffffffcc
-- 224:0000000008808800822822808222228082222280082228000082800000080000
-- 225:000000000880ff008228ddf08222ddf0822dddf00822df00008df000000f0000
-- 226:000000000ff0ff00fddfddf0fdddddf0fdddddf00fdddf0000fdf000000f0000
-- 227:0000000006606600655655606555556065555560065556600665600000060060
-- 229:cc8888ccc000000c80000008800000088000000880000008c000000ccc8888cc
-- 230:cc8888ccc0000d0c80ddddd88edcdcd88ee000088ee00008c000000ccc8888cc
-- 231:cc8888cccd00000c80d00008800d20088002220880002228c000020ccc8888cc
-- 232:fffffffff000000ff007000ff700700ff700030ff30377ccf00000ccfffffffc
-- 233:cc8888ccc00d0d0c8000de08800de00880dd00088eed0008cee0000ccc8888cc
-- 234:fffffffff000000ff008800ff00ff00ff0f8800ff08f00ccf00000ccfffffffc
-- 235:cc8888ccc006060c80006668800f660880f7600886765008c060600ccc8888cc
-- 236:fffffffff000022ff000222ff002220ff0c220ccfdcc000cf0d000cfffffffcc
-- 237:cc8888ccc00f0f0c8000f808800f800880ff0808888f0808c880000ccc8888cc
-- 238:fffffffff000000ff000dd0ff065d00ff6565dccf5656d0cf05600cfffffffcc
-- 239:cc8888cccddd000c8d000d0880000d0880d0ddd880d00008cddd000ccc8888cc
-- 240:0000000000000000000000000080800008282800082228000082800000080000
-- 241:0000000000000000000000000080f0000828df000822df000082f00000080000
-- 242:0000000000000000000000000080f0000828df00082ddf00008df000000f0000
-- 243:00000000000000000000000000f0f0000fdfdf000fdddf0000fdf000000f0000
-- 244:0000000000000000000000000060600006565600065556000065660006060000
-- 245:fffffffff000000ff000000ff000000ff000000ff000000ff000000fffffffff
-- 246:fffffffff0000d0ff0dddddffedcdcdffee0000ffee0000ff000000fffffffff
-- 247:fffffffffd00000ff0d0000ff00d200ff002220ff000222ff000020fffffffff
-- 248:fffffffff000000ff007000ff700700ff700030ff303c7ccf000c0ccffffcfcc
-- 249:fffffffff00d0d0ff000de0ff00de00ff0dd000ffeed000ffee0000fffffffff
-- 250:fffffffff000000ff008800ff00ff00ff0f8800ff08fc0ccf000c0ccffffcfcc
-- 251:fffffffff006060ff000666ff00f660ff0f7600ff676500ff060600fffffffff
-- 252:fffffffff000022ff000222ff002220ff0c2200ffdcc000ff0d0000fffffffff
-- 253:fffffffff00f0f0ff000f80ff00f800ff0ff080ff88f080ff880000fffffffff
-- 254:fffffffff000000ff000dd0ff065d00ff6565d0ff5656d0ff056000fffffffff
-- 255:fffffffffddd000ffd000d0ff0000d0ff0d0dddff0d0000ffddd000fffffffff
-- </SPRITES>

-- <MAP>
-- 000:000000000000000000000000000000000000000000000000003242300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:000000000000000000000000000000000000000000000000003343303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:000000000000000000000000303030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:000000000000000000000000307220203120204120202031202434403000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:000000000000000000000000302005809020809020c0d020233242203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:000000000000000000000000302004819120819144c1d120523343203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:000000000000000000000000303030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:000000000000000000000000307220204120203120352031202434403000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:000000000000000000000000302014a0b020a2b220849420233242203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:000000000000000000000000302015a1b120a3b320859520523343203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:000000000000000000000000303030303053535330303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:000000000000000000000001307220203135203120202041202434403000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:021200000000000000000000212020809020829220809020233242203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:031300000000000000000000212004819120839320819120523343203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:101010101010101010101010515151515151515151515151515151515110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:222222222222222222222222222222222222222222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:222222222222222222222222222222222222222222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
-- 000:000000753071ca3e53f2712cffc689a7f05d28a561ffda043434343b5dc941a6f673eff7ffffffaeaeae9d5900484848
-- </PALETTE>

