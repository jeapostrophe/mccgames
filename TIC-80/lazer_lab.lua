-- title:  Lazer Labs
-- author: Balistic Ghoul Studios, with pixel art by Polyphorge
-- desc:   short description
-- script: lua

t=0
x=0
y=4*8

function TIC()

	if btnp(0) then y=y-8 end
	if btnp(1) then y=y+8 end
	if btn(2) then x=x-1 flp=1 end
	if btn(3) then x=x+1 flp=0 end

	cls(0)
	map(0,0)
	spr(84+t%120//30*1,x,y,0,1,flp,0,1,1)
	t=t+3
	
	spr(66,27*8,2.5*8,0)
	
	spr(115+t%120//30*1,5*8,3*8)
	
end

-- <TILES>
-- 001:3222322232223222322232224333433343334333433343334333433344444444
-- 002:3222322232223222322232224333322244444333433332224333322243333222
-- 003:2232232222322322223333223344432222344433223443222234432233444322
-- 004:0000000000111000000110100112311001132110010110000001110000000000
-- 005:0000000000011100011011000112301001032110001101100011100000000000
-- 006:0000000001101110011001100102300000032010011001100111011000000000
-- 007:0000000000110100011101100002311001132000011011100010110000000000
-- 008:0012000000120000000210000001200000002100000021000001200000021000
-- 009:0002100000012000000021000000210000012000000210000012000000120000
-- 010:0000210000002100000120000002100000120000001200000002100000012000
-- 011:0001200000021000001200000012000000021000000120000000210000002100
-- 012:3334444433344444333444444444444433344444333444443334444444444444
-- 013:4333433343334333433343334444444444444444444444444444444444444444
-- 014:4444444444444333444443334444433344444444444443334444433344444333
-- 015:3344444433444433334444334444443333444444334444333344443344444433
-- 016:2223333422233334222333343334444422233334222333342223333433344444
-- 017:4444444444444444444444444444444444444444444444444444444444444444
-- 018:4444433343333222433332224333322244444333433332224333322243333222
-- 019:2234443322344322223443223344432222344433223443222234432233444322
-- 020:0000000000000000000000000000000000000000000000000000000014411441
-- 021:0000000000000000000000000000000000000000001000100120012012411241
-- 022:0000000000000000001000100010001001200120012001200120012012411241
-- 023:0000000000000000000000000010001000100010012001200120012012411241
-- 024:2232232222433422343333432334434223344342343334432244442222322322
-- 025:2232232222433422343333432331134223311342343334432244442222322322
-- 026:2232232222433422343333432332234223322342343334432244442222322322
-- 027:2232232222333422333223432322223223222232333223432243342222322322
-- 028:0330000000033333022000000002222200000000000000000003333303300000
-- 029:0000000033333333000000002222222200000000000000003333333300000000
-- 030:0000033033333000000002202222200000000000000000003333300000000330
-- 031:2222222224444442341444433444444334444443322222233333333304444440
-- 032:2223333422233334222333343334444422233334222322232223222322232223
-- 033:4444444433343334333433343334333433343334222322232223222322232223
-- 034:4444433333343222333432223334322233343333222322222223222222232222
-- 035:2234443322344322223443223344432222344433223333222232232222322322
-- 036:0000000000000000000000112100122212222100001100000000000000000000
-- 037:0000000000000000110000002221001200122221000011000000000000000000
-- 038:0000000000000000001100001222210021001222000000110000000000000000
-- 039:0000000000000000000011000012222122210012110000000000000000000000
-- 040:0000000000000000000000000000000001100000121100001141011111441214
-- 041:0000000000000000000000000000000000000000001100111121112141144114
-- 042:0000000000000000000000000000000010000001110000124101111144121411
-- 043:0000000000000000000000000000000000000000110011002111211114411441
-- 044:0000000000003333000300000030022203002000030200000302000003020003
-- 045:0000000033333333000000002222222200002000000020003330200300302003
-- 046:0000000033330000000030002220030000020030000020303300203000302030
-- 047:0000000030200003302000030302003003020030030200300302003003020030
-- 048:2222322222223222333343332234444422344444333433342223222322232223
-- 049:3222322232223222433343334444444444444444333433342223222322232223
-- 050:3222322232223222433343334444432244444322333433332223222222232222
-- 051:2232232222322322334334332234432222344322334334332232232222322322
-- 052:0000000000220022220022000000000000000000000000000000000000000000
-- 053:0000000020022002022002200000000000000000000000000000000000000000
-- 054:0000000022002200002200220000000000000000000000000000000000000000
-- 055:0000000002200220200220020000000000000000000000000000000000000000
-- 056:0100010001100110011111102211144111111111032002303020203033222233
-- 057:0000000001000100211001102211111021111441111111110230022002200330
-- 058:0100010001100110011111102211144111111111023003202030302022333322
-- 059:0000000001000100211001102211111021111441111111110220023003300220
-- 060:0302000303020003030200000302222203020000030200000302000003020003
-- 061:0030200333002000000020002222222200002000000020000000200033002000
-- 062:0030203033302030000020302222203000002030000020300000203033302030
-- 063:0302003003020030030200300302003003020030030200300302003003020030
-- 064:4444444444444334444443344444433444444334433332234333322343333223
-- 065:4444444433344444333444443334444433344444222333342223333433344444
-- 066:0000000000000003000001130000022300000113000001130000000300000000
-- 067:0000000000000003000000130000002300000013000000130000000300000000
-- 068:0000000000044400004211400041414000411140044224004333240043442240
-- 069:0004211400041414000411140004224004434240433424004344240004042400
-- 070:4112400041414000411140000422340000423400042433400424440000400000
-- 071:0000000000044400004211400041414000411140044224004333240043442240
-- 072:0000000000000000000330002222430022224300000330000000000000000000
-- 073:0000000000000000000330000034430000322300000220000002200000022000
-- 074:0000000000000000000330000034222200342222000330000000000000000000
-- 075:0002200000022000000220000032230000344300000330000000000000000000
-- 076:0302000303020003030200000300200000300222000300000000333300000000
-- 077:0030200300302003333020030000200022222222000000003333333300000000
-- 078:0030203000302030330020300002003022200300000030003333000000000000
-- 079:0302003003020030030200300302003003020030302000033020000300000000
-- 080:4444433343333222433332224444433344444333444443334444433344444444
-- 081:3223333432233334322333344334444443344444433444444334444444444444
-- 082:0000000000000003000000130000012300000113000000130000000300000000
-- 083:0000000030000000310000003210000031100000310000003000000000000000
-- 084:0004440000421140004141400041114000422400044324004334240043442240
-- 085:0042114000414140004111400042240000423400043234000432400000422400
-- 086:0004440000421140004141400041114000422400044234004224340042443340
-- 087:0042114000414140004111400042240000432400042224000423400000433400
-- 088:0000000002200000022230000022430000344300000330000000000000000000
-- 089:0000000000000220000322200034220000344300000330000000000000000000
-- 090:0000000000000000000330000034430000342200000322200000022000000000
-- 091:0000000000000000000330000034430000224300022230000220000000000000
-- 092:0000000003300000000000000330000000000000033000000000000003300000
-- 093:0000000030303030303030300000000000000000000000000000000000000000
-- 094:0000000000300303000303030000000003300000000000000330000000000000
-- 095:0000000003030000030300300000030000000000000003300000000000000330
-- 096:0000000003330000030300000333000000000000033300000303000003330000
-- 098:0000000000003330000030300000333000000000000033300000303000003330
-- 099:2222322222223222222232223333433322234333222343332223433333344444
-- 100:0004440000421140004141400041114000422400004234000042340000423400
-- 101:0000000000000000000000000000000000000444044441124333214132222111
-- 104:0000000000000000002230000022130000221300002230000000000000000000
-- 105:0000000000000000000330000031130000222200002222000000000000000000
-- 106:0000000000000000000322000031220000312200000322000000000000000000
-- 107:0000000000000000002222000022220000311300000330000000000000000000
-- 108:0000000000000000000000000000000000000000030303030303030300000000
-- 109:0000033000000000000003300000000000000330000000000000033000000000
-- 110:0330000000000000033000000000000000300000030030300000303000000000
-- 111:0000000000000330000000000000033000000000303030003030030000000000
-- 112:0222222203333333000000000033300003330000433000004300000040000000
-- 113:0222222203333333000000000000000000000000000000000000000000000000
-- 114:0222222203333333000000000003330000003330000003340000003400000004
-- 115:0000000000000000000000000000000001111110001111000001100000000000
-- 116:0000000000000000000000000111111000111100000110000000000000000000
-- 117:0000000000000000011111100011110000011000000000000000000000000000
-- 118:0000000000000000000000000111111000111100000110000000000000000000
-- 120:0000000000020000002220000222130000211300000330000000000000000000
-- 121:0000000000002000000222000031222000311200000330000000000000000000
-- 122:0000000000000000000330000031120000312220000222000000200000000000
-- 123:0000000000000000000330000021130002221300002220000002000000000000
-- 124:0000000000000000000000000001100000011000000000000000000000000000
-- 125:0000000000000000000110000012210000122100000110000000000000000000
-- 126:2300002323333323233333232300002323000023233333232333332323000023
-- 127:0222222003333330000000000333333043300334430000344000000400000000
-- 128:2223422442342223444432334223433442344443244224333422234344423444
-- 129:2223422442342223444432334223433442344443344334333433334344433444
-- 130:2223422442342223444432334223433442344442344224233422234344423444
-- 131:2223422442342223444432334223433442344442244334233433334344433444
-- 132:0333333003222230032222300322333003223330032222300322223003222230
-- 133:0333333002222332022223320222333202223332022223320222233202222332
-- 134:0033322200233002002330020033300200333002002330020023300200233002
-- 135:0033222200330002003300020333000203330002003300020033000200330002
-- 136:2332332334444443323323320000000000011000000110000000000000000000
-- 137:3233233234444443233233230000000000011000000110000000000000000000
-- 138:3323323324444442332332330000000000011000000110000000000000000000
-- 139:2332332334444443323323320000000000011000000110000000000000000000
-- 140:0033330000000000000000000000000000000000000000000000000000000000
-- 141:0000000000000000300000003000000030000000300000000000000000000000
-- 142:0000000000000000000000030000000300000003000000030000000000000000
-- 144:2223433442343333444433334223433442344443244224333422234344423444
-- 145:3334433443343333444433334333433443344443344334333433334344433444
-- 146:3334422443442223444432333333433443344442344224233422234344423444
-- 147:2334432442343222444432234223433442344442244334233433334344433444
-- 148:0111111011111111111111111111111111111111111111111111111101111110
-- 149:0000000000000000000000000000000000000000000000000000230003023330
-- 150:0000000000000000000000000000000000000000000000000023002330323033
-- 151:0000000000000000000000000000000000000000000000000000002300230233
-- 152:2332332334444443323323320000000000022000000220000000000000000000
-- 153:3233233234444443233233230000000000022000000220000000000000000000
-- 154:3323323324444442332332330000000000022000000220000000000000000000
-- 155:2332332334444443323323320000000000022000000220000000000000000000
-- 156:0000000000000000000000000000000000000000000000000000000000333300
-- 160:2223433442342333444423334223423442344442244224223422234344423444
-- 161:3333433443343333444433344223433442344442344224223422234344423444
-- 162:3333422443342223444432334223433442344442244224223422234344423444
-- 163:2334432442343222444432234223433442344442244224223422234344423444
-- 164:0000000000000021000000000000021100000000000000210000000000000211
-- 165:1120000000000000120000000000000011200000000000001200000000000000
-- 166:0101010102010201000200020000000000000000000000000000000000000000
-- 167:0000000000000000000000000000000000000000200020001020102010101010
-- 168:0000000000000000033300002011111022111441211211110022300000000000
-- 169:0000000000000000033300000011111022111441011211110022300000000000
-- 170:0012210001200210120110212012210220122102120110210120021000122100
-- 172:1111111110101010101010100000000001010101000000000000000000000000
-- 173:0000011100010001000001110001000100000111000100010000011100010001
-- 174:0000000000000000000000001010101000000000010101010101010111111111
-- 175:1000100011100000100010001110000010001000111000001000100011100000
-- 176:2223422442342233444433334223433442344443244334223422234244423444
-- 177:2223422442342233444433334333433443344443344334322422234244423444
-- 178:2223422442342223444432334333433443344442344224222422234344423444
-- 179:2223422442342223444432334223433442344442344224222422234344423444
-- 180:0303000020111110221114412111111100000000233233233444444332332332
-- 181:0303000000111110221114410111111100000000323323323444444323323323
-- 182:0303000020111110221114412111111100000000332332332444444233233233
-- 183:0303000000111110221114410111111100000000233233233444444332332332
-- 192:4224444423222222243244232444443423444444234444443244444442444444
-- 193:4222224424333322444433344444434444444444444444444444444444444444
-- 194:2234233443223223433344424344442444444432444444324444444244444432
-- 195:4223223423323223243344422443442423444432234444324244444242444432
-- 196:0000000000000000000003000300030000303003300330300303003003030030
-- 197:0000000000000000000000000033000000030300030030030300303030033030
-- 198:0000000000000000000000000000000000000000000003000300300000303030
-- 199:0000000000000000001110000112211000011100000030000030330000030000
-- 208:2344444424444444234444442344444432444444424444444234444442344444
-- 209:4444444444444444444444444444444444444444444444444444444444444444
-- 210:4444442344444424444443244444432344444423444444224444443244444442
-- 211:2344442324444424234443242344432442444424424444224234443242344442
-- 212:3330033300000000030000300300003003000030030000300300003003000030
-- 213:0300003003000030030000300300003003000030030000300300003003000030
-- 214:3222222322323442223244422234443222444232244432322442323232222223
-- 215:0000000032223343000000003222334300000000322233430000000032223343
-- 224:2344444424444444244444443244444432444444244444442443322243322433
-- 225:4444444444444444444444444444444444444444444433444332223422244322
-- 226:4444444244444432444444234444442444444432444444423322243222433224
-- 227:2344444224444432244444233244442432444442244444422343243242224224
-- 228:0230000002310000044210000341200002301000023000000230000002300000
-- 229:0230000002311100044122100340111002300000023000000230000002300000
-- 230:0230010002311200044221000341100002300000023000000230000002300000
-- 231:0230000002310100044212000341210002301000023000000230000002300000
-- 240:4223333423222222243244233244443432444444244444442443322243322433
-- 241:3222223324333322444433344444434444444444444433444332223422244322
-- 242:2234223443223323433344324344442444444432444444423322243222433224
-- 243:4223223423323223243344322443442432444432244444422343243243323224
-- 244:0230000002300000044000000340000002300000023000000232100002312100
-- 245:0230000002300000044000000341000002310000023210000231200002301000
-- 246:0230000002300000044100000342100002312000023010000230000002300000
-- 247:0231000002321000044120000340100002301000023000000230000002300000
-- 255:2222222220333302233443322341413223444432233333332333333223222222
-- </TILES>

-- <SPRITES>
-- 000:0000000000000000002222000022020000222200002202000000000000000000
-- 001:0000000000000000002220000022200000220200002222000000000000000000
-- 002:0000000000000000002222000022000000220000002222000000000000000000
-- 003:0000000000000000002220000022020000220200002220000000000000000000
-- 004:0000000000000000002222000022200000220000002222000000000000000000
-- 005:0000000000000000002222000022000000222000002200000000000000000000
-- 006:0000000000000000002222000022000000220200002222000000000000000000
-- 007:0000000000000000002202000022220000220200002202000000000000000000
-- 008:0000000000000000002222000002200000022000002222000000000000000000
-- 009:0000000000000000002222000002200000022000002220000000000000000000
-- 010:0000000000000000002202000022200000222200002202000000000000000000
-- 011:0000000000000000002200000022000000220000002222000000000000000000
-- 012:0000000000000000002222000022220000220200002202000000000000000000
-- 013:0000000000000000002002000022020000202200002002000000000000000000
-- 014:0000000000000000002222000020020000200200002222000000000000000000
-- 015:0000000000000000002222000022020000222000002200000000000000000000
-- 016:0000000000000000002222000020020000202000002202000000000000000000
-- 017:0000000000000000002222000022020000222000002202000000000000000000
-- 018:0000000000000000002222000022000000002200002222000000000000000000
-- 019:0000000000000000002222000002200000022000000220000000000000000000
-- 020:0000000000000000002202000022020000220200002222000000000000000000
-- 021:0000000000000000002202000022020000220200000220000000000000000000
-- 022:0000000000000000002202000022020000222200002222000000000000000000
-- 023:0000000000000000002202000002220000222000002022000000000000000000
-- 024:0000000000000000002202000022020000022000000220000000000000000000
-- 025:0000000000000000002222000000200000020000002222000000000000000000
-- 048:0000000000000000002222000020220000202200002222000000000000000000
-- 049:0000000000000000002220000002200000022000002222000000000000000000
-- 050:0000000000000000002222000000220000220000002222000000000000000000
-- 051:0000000000000000002222000000220000022200002222000000000000000000
-- 052:0000000000000000002022000022220000002200000022000000000000000000
-- 053:0000000000000000002222000022000000022200002222000000000000000000
-- 054:0000000000000000002222000022000000202200002222000000000000000000
-- 055:0000000000000000002222000000220000022000000220000000000000000000
-- 056:0000000000000000000222000022020000202200002220000000000000000000
-- 057:0000000000000000002222000020220000222200000022000000000000000000
-- 080:0000000000000000001101000011010000011000000110000000000000000000
-- 081:0000000000000000001111000010010000100100001111000000000000000000
-- 082:0000000000000000001101000011010000110100001111000000000000000000
-- 084:0000000000000000001110000011010000110100001110000000000000000000
-- 085:0000000000000000001111000001100000011000001111000000000000000000
-- 086:0000000000000000001111000011100000110000001111000000000000000000
-- 087:0000000000000000001110000011010000110100001110000000000000000000
-- 088:0000000000111100001010000011110000010100001000100001110000100010
-- </SPRITES>

-- <MAP>
-- 000:1111111111111111111111111111111111111111111111111111111111112dcacaca0d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:1212121212121212121212121212121212121212121212121212121214112d0000000e1d1d1d1d1d1d1d1e1e1e1e1e1e1e1e1e1d1d1d1d1d1d1d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:fa0000f200000000000000000000f2000000f200000000000000000001112d000000000e1d1d1d1d1d2d000000004d000000000e1e1d1d1d1d1d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:fa0000f300000000000000000000c4d1d1d1e400000000008300000001112d7c000000000e1e1e1e1e2e000000005d000000004d000e1e1e1d1d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:fa0000f400f10000000000008300000000000000000089898989898901111d2c5c0000000000004d000000007c6c5d694c4b005d000000000e1d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:1010101010102000000000888888888888888888000000000000000001111d1d2c4c00000000005d0000004c0c1c1c1c1c2c5c5d00000000000d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:1104121212122200000000000000000000000000000000000000000001111d1d1d2c43434343435d4343430c1d1d1d1d1d1d1c1c2c6c00e7000d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:1121000000000000000000000000000000000000000000000000000001111d1d1d1d2c008a00005d00000c1d1d1d1d1d1d1d1d1d1e2f07e7270d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:11210000000000004b0000000000000089898989898988888800000001111d1d1d1d2d5c006c595d4c6c0d1d1d1d1d1d1e1e1e2e4d0000e7000d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:112100e70000361010101010200000000000000000007a7a7a7a7a7a01111d1d1d1d1d1c1c1c1c1c1c1c1d1d1d1d1e2e4d0000005d0000e7000d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:112107e717270111111111112100000083000000004a36101010101015111d1d1d1d1d1d1d1e1e1e1e1e1e1e1e2e00005d0000005d7c6ce75c0d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:112100e700000212121212122200000313132300004a021212121212121212121e1e1e1e2e00004d0000004d000000005d4b794c5d0c1c1c1c1d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:112100e700006a6a6a6a6a6a6a000000f2000000000080000000000000dafa0000004d000000005d0000005d00004c5c5d0c1c1c1c1e1e1e1e1e1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:112100e7000000000000000000000000c4e20000000080000000000000dafa0000005d00005c6c5d0000005d00000c1c1c1d1d1d2e00000000000d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:1105102000000000000000000000000000f30000000080000000000000dafa0059f15d4c6c0c1c2c4343435d430f1e1e1e1e1e2e434343aa43430d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:1111112100000036102000000036102000f30036101010101010101010101010101c1c1c1c1d1d2d4c8a795d6c0000000000000000000000000c1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:1111112182828201112182828201112182f482011111111111111111111d1d1d1d1d1d1d1d1d1d1d1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1d1d1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 119:000000000000000000000000000000000000000000000000000000000000110412121212121212121212121212121212121212121212121212121411111111111119111919191919191919191919191919191a1a1a1919191919191919191919191111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 120:00000000000000000000000000000000000000000000000000000000000004226a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a021212121212121a1a1a1a1a1a191919191919191919192900004d0a1a1a1a1a1a1a1a1a1a12121212121212121212911212121212121212911212121212121212129112121212121212121291121212121212121291121212121214000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 121:000000000000000000000000000000000000000000000000000000000000215a000000000000400000000000000000000091000091000040000000dafa0000004d0000004d00000a1919191919191919192900005d00004d00da000000000000000000000000000000800000000000000000800000000000000000008000000000000000000080000000000000000080000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 122:000000000000000000000000000000000000000000000000000000000000215a480000000000000000000000000040000080000080000000000000dafa0000005d0000005d0000000a19191919191919192a00005d00005d00da000000000000000000000000000000800000000000000000800000000000000000008000000000000000000080000000000000000080000000002401000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 123:000000000000000000000000000000000000000000000000000000000000e013131323000000000000000003230000000080000080000000000000dafa0000005d0000005d000000000a191919191919290000005d00005d00da000000000000000000000000000000800000000000000000800000000000000000008000000000000000000080000000000000000080000000e70001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 124:000000000000000000000000000000000000000000000000000000000000215a000000000000000000000000000000032380000080330000000003101010101018101818284343434343091919191919294343435d4308181818181818181018101010101010101010911010101010101010911010101010101010109110101010101010101091101010101010101091102007e72701000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 125:000000000000000000000000000000000000000000000000000000000000215a00aa0000400000032300400000000000008000008000000033004a011111111a1a1a1a1919286c000000091919191919295c6c005d0009191919191111191919111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111112100e70001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 126:000000000000000000000000000000000000000000000000000000000000215a00000000000000000000000000000000009100338000000000004a0111112a4d0000000a191928000000091919191919191828005d0009191919110412121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212122200e70001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 127:000000000000000000000000000000000000000000000000000000000000215a00914242424242429100000000032300000000008000000000004a011129005daa0000000919298a00000919191919191919298a5d00091919191121000000000000006a6a6a0000006a6a6a0000006a6a6a0000006a6a6a0000006a6a6a0000006a6a6a0000006a6a6a0000006a6a6a000000e70001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 128:00000000000000000000000000000000000000000000000000000000000005207a7a7a3610207a7a7a00000000000000000000008033000000004a011129005d000000000a1a290000000a191919191919192a005d0009191919112100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e70001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 129:00000000000000000000000000000000000000000000000000000000000011051010101511051010205a000000000000000000008000000000004a011129435d434343434d433a000000000a191919191a2a00005d6c09191919112100e700007a7a7a0000007a7a7a0000007a7a7a0000007a7a7a0000007a7a7a0000007a7a7a0000007a7a7a0000007a7a7a000000000000e70001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 130:00000000000000000000000000000000000000000000000000000000000011111111111111111111215a000323000040000000338000004000004a0119296c5d00008a005d006c69000000000a1a1a2a00008a005d0819191919112107e727031313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 131:0000000000000000000000000000000000000000000000000000000000001d1e1e1e1e1e1e1e1d11215a000000000000000000008000000000004a01111918286c0000005d6908284c008a00004d00000000004c5d0919191919112100e70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 132:0000000000000000000000000000000000000000000000000000000000002d000000000000000d11215a004000000000003300009100000000004a0119191919285c00005d081919286c7900005d0000795c6c08181919191919112100e70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa0001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 133:0000000000000000000000000000000000000000000000000000000000002d000000000000000d11215a000000032300000000000000000000004a011119191919284c6c081919191918285c695d794c08181819191919191919112100e70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 134:0000000000000000000000000000000000000000000000000000000000002d000000000048000d110520000000000000000000000000000000003615111919191919181819191919191919181818181819191919191919191919110510101020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000361010101015000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 135:0000000000000000000000000000000000000000000000000000000000002deaeaea0c1c1c1c1d1111218282828282828282828282828282828201111119191919191919191919191919191919191919191919191919191919191111111111218292a2b28292a2b28292a2b28292a2b28292a2b28292a2b28292a2b28292a2b28292a2b28292a2b28292a2b2828292a2011111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
-- 000:000000e01f3ffff8ed7b6960271d2c000000000000000000000000000000000000000000000000000000000000000000
-- </PALETTE>

