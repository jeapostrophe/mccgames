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
-- 001:0000000000eee0000064600000444000022222000422240000fff00000f0f000
-- 002:4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e
-- 003:44444444eeeeeeee44444444eeeeeeee44444444eeeeeeee44444444eeeeeeee
-- 004:0000000000e0e000ccceccc0dddeddd0ccceccc0dddeddd0ccceccc0dddeddd0
-- 005:00000000000000000eeeeeee0e0000000e0000000e0000000e0000000e000000
-- 006:0000000000000000eeeeeee0000000e0000000e0000000e0000000e0000000e0
-- 007:6666666666666666e6ee6ee6e6ee6ee6eee66e6eeeeeeeeeeeeeeeeeeeeeeeee
-- 008:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 009:06066066066666220666662206622666006226660666666606666666000000e4
-- 010:60660660666226606662266066666660622666606226660066666000e4000000
-- 016:0000000000eee0000064600009444900029292000492940000fff00000f0f000
-- 017:0000000000eee0000223220004232400022322000223220000fff00000f0f000
-- 018:0000000000eee000099a9900049a9400099a9900099a990000fff00000f0f000
-- 019:0000000000eee0000665660004656400066566000665660000fff00000f0f000
-- 020:ccceccc0dddeddd0ccceccc0dddeddd0ccceccc0dddeddd0ccceccc0dddeddd0
-- 021:00ccecc000ccecc0044444440400000004000000040000000400000004000000
-- 022:000000000f77d200444444400000004000000040000000400000004000000040
-- 025:000000e400000ee400000ee400000e4400000e4e0000ee4e0000e4ee00eee4ee
-- 026:e4e00000e4e00000e44e0000ee4ee000ee4ee000ee44e000eee44e004eee4ee0
-- 027:0000000000000000eee00000646220004442220c020222c00402fff00004f0f0
-- 028:ff000000ffc99c22ff9999ccff9c9922ff999cccff222222ffccccccff222222
-- 029:0000000022222222cccccccc22222222cccccccc22222222cccccccc22222222
-- 033:000000000000000022232220244d4420244d4420244d44202223222000000000
-- 034:0000000000000000999a9990944d4490944d4490944d4490999a999000000000
-- 035:000000000000000066656660644d4460644d4460644d44606665666000000000
-- 037:00000000000000000000000000000000000000000000000000e0e0000ccecc00
-- 039:4444444444eeee444eeeeee447eeeee44eeee7e44eeee7e447eeeee44eeeeee4
-- 040:0000000000000000000000000dddddd00dffdfd00dfdfdd00dddddd000000000
-- 041:0ddfdd000dfdfd000ddfdd000dfffd000ddfdd000dfdfd000000000000000000
-- 042:0ddfdd000dfdfd000ddfdd000dfffd000ddfdd000dfffd000000000000000000
-- 044:ffccccccff000000ff000000ff000000ff000000ff000000ff000000ff000000
-- 045:cccccccc00000000000000000000000000000000000000000000000000000000
-- 049:00223220024444420eeeeeee0e0000000e0000000e0000000e0000000e000000
-- 050:0099a990094444490eeeeeee0e0000000e0000000e0000000e0000000e000000
-- 051:00665660064444460eeeeeee0e0000000e0000000e0000000e0000000e000000
-- 060:ff000000ff000000ff000000ff000000ff000000ff000000ff000000ff000000
-- 065:00000000000000000000000003222000032f200003f2f0000322200003222000
-- 066:0000000000000000000000000a9990000a9f90000af9f0000a9990000a999000
-- 067:00000000000000000000000005666000056f600005f6f0000566600005666000
-- 076:ff000000ff000000ff000000ff000000ff000000ff000000ff000000ff000000
-- 081:0000000000000000000000000000000000000000003220000032200000322000
-- 082:000000000000000000000000000000000000000000a9900000a9900000a99000
-- 083:0000000000000000000000000000000000000000005660000056600000566000
-- 192:ee000ee000eee00000646000004440000accc60004c2c40000fff00000f0f000
-- 194:00000000000eee00000949000404440000fffff0000fcf400008880000080800
-- 208:00000000b0aba0000acfc0b0b0ccc0a00ababa000bababb0b0bab00000a0b000
-- 209:000000000003330000094900000444040022e22000427200000fff00000f0f00
-- 210:0000000000eee00000949000004440400fffff0004fcf0000088800000808000
-- 211:0000000000cccc0000c0c00000cccc00000c0c00000000000000000000000000
-- 212:0000000000cccc00000c0c0000cccc0000c0c000000000000000000000000000
-- 213:00000000000b000000bbb0000bbccb000bbbcb0000bbb0000000000000000000
-- 215:000000000000c000000000000c00000000000000000000c00c00000000000000
-- 216:0000000000c0000000000c00000000000c00000c000cd00000cccc000cdccdc0
-- 224:0000000000eee0000e646e000e444e0008888800048884000088800000888000
-- 225:0000000000777000009490000044400006666600046664000088800000808000
-- 226:0000000000eee0000e949e000e444e00011111000411140000fff00000f0f000
-- 227:0000b00000777b00076467b00744470009999900049994000788870000888000
-- 228:0000000000eee1000e949e000e444e0003333300043334000e222e0000202000
-- 229:0202000022022000000000772202277702027777000073770000273300002277
-- 230:000000000000000077ee000077ee0ff077700fff370000ff7200f0ff220fffff
-- 239:000000080800000000000f00f8f0f8f8808f8f0f08f808f0008f8f000008f000
-- 240:0000000000eee00000949000004440000cc2cc0004c2c40000fff00000f0f000
-- 241:00000000003330000094900000444000022e22000427240000fff00000f0f000
-- 242:0000000000eee00000949000004440000fffff0004fcf4000088800000808000
-- 243:00000000003330000fafaf00004440000cc5cc0004c5c40000fff00000f0f000
-- 244:0000000000077e0000777000002720000f737f00007770000e77f00000f0f000
-- 245:0fff7733ffff7333fff07777ff077373ffee733300ee73730000ff000000ff00
-- 246:77fffff037ffff007700000077000000ff000000ff000000ff000000ff000000
-- 247:00000000000000000000000e00002264000242440022224600fff20e00f0f400
-- 248:000000000eee0b0009490b0004440000fffff0004fcf40000088800000808000
-- 249:0e644e0000446000022222000422240000fff00000f0f0000000000000000000
-- 250:0000000000000000e0000000462200004424200064222200e02fff00004f0f00
-- 251:0e949e0040b4b0400fbfbf0000bcb00000b8b00008b0b80000b0b0000dcdcd00
-- 252:000000000f0f0fff0fff0f0f0f0f0fff0f0f0f0f000000000000000000000000
-- 253:000000000f0f0f000f0f0f00000000000f0f0f00000000000000000000000000
-- 254:0000000000eee000006410000044f000022222000422240000fff00000f0f000
-- </TILES>

-- <MAP>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000303000000030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030300000003030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030000000303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000303000000030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030300000003030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030000000303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:000000000000000000000000000000000000000000000000fe0000000000000000000000000000000000000000000000000000303000000030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:000000000000000000000000000000000000000000000000b1c1d1000000000000000000000000000000000000000000000030300000003030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:00000000000000000000000000000000000000000000000000c400000000000000000000000000000000000000000000003030000000303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:00000000000000000000000000000000000000000000000000c400000000000000000000000000000000000000000000303000000030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:00000000000000000000000000000000000000000000000000c400000000000000000000000000000000000000000000300000003030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:00000000000000000000000000000000000000000000000000c400000000005d5d003030303030303030303030303030300000303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:00000090a000000000000090a0000000005d000090a0cfcfdfc4cfdf90a000fefe000000000000000000000000000000000030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:00000091a100003f004f0091a1000000004e000091a11d0000c4002c91a1001e2e000000000000000000000000000000003030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:707070707070707070707070707070707070707070707070707070707070707070703030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:808080808080808080808080808080808080808080808080808080808080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:808080808080808080808080808080808080808080808080808080808080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 129:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030303030303030303030303030303030303030303030303030303030200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 130:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000303000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 131:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030300000820000000082000000000000000000000082000000000082000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 132:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000303000000072000000007200000092720072a200000072000000003d724d0000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 133:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000303000000030303030303030303030303030303030303030303030303030303030200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 134:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030300000003030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 135:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030000000303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
-- 000:000000814085b13e53ef7930ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900484848
-- </PALETTE>

