-- title:  ???
-- author: ???
-- desc:   ???
-- script: lua

function TIC()
end

--P.S. If you run this it will break! So DON'T!

--NO CODE JUST SPRITES!!
--[[
A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
a b c d e f g h i j k l m n o p q r s t u v w x y z
0 1 2 3 4 5 6 7 8 9
--]]

-------
--KEY--
-------

WHITE-Commented Out
RED-Error code
ORANGE-Quotes/Print
SLATE GREY-Normal Text
PINK-Custom Functions
GREEN-Built-in Functions
BLUE-Numbers/Operations

---------
--NOTES--
---------
 
	>You could probobly use pal()
	 to switch the pallate or 
		something. Would defenetly
		consurve sprites
	
	>Mouse sprites may not be 
	 useable, but still...
-- <TILES>
-- 001:0000000001000011010001010100010101000101011101100000000000000000
-- 002:0000000000110101010101010101011001010101011001010000000000000000
-- 003:0000000000000111000001010000011100000101000001010000000000000000
-- 004:0000000001110000001000000010000000100000001000000000000000000000
-- 005:0000000001110011010001000110010001000101010001110000000000000000
-- 006:0000000000000111000001000000011000000100000001000000000000000000
-- 007:0000000000110111010101010101011001010101011001010000000000000000
-- 008:0000000000000111000001110000010100000101000001010000000000000000
-- 009:0000000000110111010101010101011001010101011001010000000000000000
-- 010:0000000001110000010000000110000001000000011100000000000000000000
-- 016:0000000008800888008000080080088800800800088808880000000000000000
-- 017:0000000008880808000808080088088800080008088800080000000000000000
-- 018:0000000008880800080008000888088800080808088808880000000000000000
-- 019:0000000008880888000808080008088800080808000808880000000000000000
-- 020:0000000008880888080808080888080800080808000808880000000000000000
-- 032:0000000000800080008008080080080800000800008000880000000000000000
-- 033:0000000008080888088808800808008808880888080800800000000000000000
-- 034:0000000008080080000808080080000008000000080800000000000000000000
-- 035:0000000008800808088000800888088808080080088808080000000000000000
-- 036:0000000000800080080000080800000808000008008000800000000000000000
-- 037:0000000000000000000000000888000000000000000008880000000000000000
-- 038:0000000000000000008008880888000000800888000000000000000000000000
-- 039:0000000000880880008000800880008800800080008808800000000000000000
-- 040:0000000008800088080000080800000808000008088000880000000000000000
-- 041:0000000008000080008000800080008000800080000800800000000000000000
-- 042:0000000000000000008000800000000000800080080000000000000000000000
-- 043:0000000000000008000000800000080000800080080000080000000000000000
-- 044:0000000008000000008000000008000000800000080000800000000000000000
-- 045:0000000000080888008000080080008800800000080000800000000000000000
-- 046:0000000008000000008000080000088800000800000000000000000000000000
-- 047:0000000008080008080800800000000000000000000000000000000000000000
-- 048:0000000008880888080808080888088008080808080808880000000000000000
-- 049:0000000000880880080008080800080808000808008808880000000000000000
-- 050:0000000008880888080008000880088008000800088808000000000000000000
-- 051:0000000000880808080008080800088808080808088808080000000000000000
-- 052:0000000008880888008000800080008000800080088808800000000000000000
-- 053:0000000008080800080808000880080008080800080808880000000000000000
-- 054:0000000008880880088808080808080808080808080808080000000000000000
-- 055:0000000000880888080808080808088808080800088008000000000000000000
-- 056:0000000000800888080808080808088008800808008808080000000000000000
-- 057:0000000000880888080000800888008000080080088000800000000000000000
-- 058:0000000008080808080808080808080808080888008800800000000000000000
-- 059:0000000008080808080808080808008008880808088808080000000000000000
-- 060:0000000008080888080800080888008000080800088808880000000000000000
-- 064:0000000000000000008808800808088008880808080808880000000000000000
-- 065:0000000000000000008808800800080808000808008808800000000000000000
-- 066:0000000000000000088808880880088008000800008808000000000000000000
-- 067:0000000000000000008808080800080808080888088808080000000000000000
-- 068:0000000000000000088808880080008000800080088808800000000000000000
-- 069:0000000000000000080808000880080008080800080800880000000000000000
-- 070:0000000000000000088808800888080808080808080808080000000000000000
-- 071:0000000000000000008800880808080808080888088008000000000000000000
-- 072:0000000000000000008008800808080808800880008808080000000000000000
-- 073:0000000000000000008808880800008000080080088000800000000000000000
-- 074:0000000000000000080808080808080808080888008800800000000000000000
-- 075:0000000000000000080808080808008008880080088808080000000000000000
-- 076:0000000000000000080808880888000800080800088008880000000000000000
-- 080:0000000003300333003000030030033300300300033303330000000000000000
-- 081:0000000003330303000303030033033300030003033300030000000000000000
-- 082:0000000003330300030003000333033300030303033303330000000000000000
-- 083:0000000003330333000303030003033300030303000303330000000000000000
-- 084:0000000003330333030303030333030300030303000303330000000000000000
-- 096:0000000000300030003003030030030300000300003000330000000000000000
-- 097:0000000003030333033303300303003303330333030300300000000000000000
-- 098:0000000003030030000303030030000003000000030300000000000000000000
-- 099:0000000003300303033000300333033303030030033303030000000000000000
-- 100:0000000000300030030000030300000303000003003000300000000000000000
-- 101:0000000000000000000000000333000000000000000003330000000000000000
-- 102:0000000000000000003003330333000000300333000000000000000000000000
-- 103:0000000000330330003000300330003300300030003303300000000000000000
-- 104:0000000003300033030000030300000303000003033000330000000000000000
-- 105:0000000003000030003000300030003000300030000300300000000000000000
-- 106:0000000000000000003000300000000000300030030000000000000000000000
-- 107:0000000000000003000000300000030000300030030000030000000000000000
-- 108:0000000003000000003000000003000000300000030000300000000000000000
-- 109:0000000000030333003000030030003300300000030000300000000000000000
-- 110:0000000003000000003000030000033300000300000000000000000000000000
-- 111:0000000003030003030300300000000000000000000000000000000000000000
-- 112:0000000003330333030303030333033003030303030303330000000000000000
-- 113:0000000000330330030003030300030303000303003303330000000000000000
-- 114:0000000003330333030003000330033003000300033303000000000000000000
-- 115:0000000000330303030003030300033303030303033303030000000000000000
-- 116:0000000003330333003000300030003000300030033303300000000000000000
-- 117:0000000003030300030303000330030003030300030303330000000000000000
-- 118:0000000003330330033303030303030303030303030303030000000000000000
-- 119:0000000000330333030303030303033303030300033003000000000000000000
-- 120:0000000000300333030303030303033003300303003303030000000000000000
-- 121:0000000000330333030000300333003000030030033000300000000000000000
-- 122:0000000003030303030303030303030303030333003300300000000000000000
-- 123:0000000003030303030303030303003003330303033303030000000000000000
-- 124:0000000003030333030300030333003000030300033303330000000000000000
-- 128:0000000000000000003303300303033003330303030303330000000000000000
-- 129:0000000000000000003303300300030303000303003303300000000000000000
-- 130:0000000000000000033303330330033003000300003303000000000000000000
-- 131:0000000000000000003303030300030303030333033303030000000000000000
-- 132:0000000000000000033303330030003000300030033303300000000000000000
-- 133:0000000000000000030303000330030003030300030300330000000000000000
-- 134:0000000000000000033303300333030303030303030303030000000000000000
-- 135:0000000000000000003300330303030303030333033003000000000000000000
-- 136:0000000000000000003003300303030303300330003303030000000000000000
-- 137:0000000000000000003303330300003000030030033000300000000000000000
-- 138:0000000000000000030303030303030303030333003300300000000000000000
-- 139:0000000000000000030303030303003003330030033303030000000000000000
-- 140:0000000000000000030303330333000300030300033003330000000000000000
-- </TILES>

-- <SPRITES>
-- 000:0000000001110111010101010111011001010101010101110000000000000000
-- 001:0000000000110110010001010100010101000101001101110000000000000000
-- 002:0000000001110111010001000110011001000100011101000000000000000000
-- 003:0000000000110101010001010100011101010101011101010000000000000000
-- 004:0000000001110111001000100010001000100010011101100000000000000000
-- 005:0000000001010100010101000110010001010100010101110000000000000000
-- 006:0000000001110110011101010101010101010101010101010000000000000000
-- 007:0000000000110111010101010101011101010100011001000000000000000000
-- 008:0000000000100111010101010101011001100101001101010000000000000000
-- 009:0000000000110111010000100111001000010010011000100000000000000000
-- 010:0000000001010101010101010101010101010111001100100000000000000000
-- 011:0000000001010101010101010101001001110101011101010000000000000000
-- 012:0000000001010111010100010111001000010100011101110000000000000000
-- 016:0000000000000000001101100101011001110101010101110000000000000000
-- 017:0000000000000000001101100100010101000101001101100000000000000000
-- 018:0000000000000000011101110110011001000100001101000000000000000000
-- 019:0000000000000000001101010100010101010111011101010000000000000000
-- 020:0000000000000000011101110010001000100010011101100000000000000000
-- 021:0000000000000000010101000110010001010100010100110000000000000000
-- 022:0000000000000000011101100111010101010101010101010000000000000000
-- 023:0000000000000000001100110101010101010111011001000000000000000000
-- 024:0000000000000000001001100101010101100110001101010000000000000000
-- 025:0000000000000000001101110100001000010010011000100000000000000000
-- 026:0000000000000000010101010101010101010111001100100000000000000000
-- 027:0000000000000000010101010101001001110010011101010000000000000000
-- 028:0000000000000000010101110111000100010100011001110000000000000000
-- 032:0000000007770777070707070777077007070707070707770000000000000000
-- 033:0000000000770770070007070700070707000707007707770000000000000000
-- 034:0000000007770777070007000770077007000700077707000000000000000000
-- 035:0000000000770707070007070700077707070707077707070000000000000000
-- 036:0000000007770777007000700070007000700070077707700000000000000000
-- 037:0000000007070700070707000770070007070700070707770000000000000000
-- 038:0000000007770770077707070707070707070707070707070000000000000000
-- 039:0000000000770777070707070707077707070700077007000000000000000000
-- 040:0000000000700777070707070707077007700707007707070000000000000000
-- 041:0000000000770777070000700777007000070070077000700000000000000000
-- 042:0000000007070707070707070707070707070777007700700000000000000000
-- 043:0000000007070707070707070707007007770707077707070000000000000000
-- 044:0000000007070777070700070777007000070700077707770000000000000000
-- 048:0000000000000000007707700707077007770707070707770000000000000000
-- 049:0000000000000000007707700700070707000707007707700000000000000000
-- 050:0000000000000000077707770770077007000700007707000000000000000000
-- 051:0000000000000000007707070700070707070777077707070000000000000000
-- 052:0000000000000000077707770070007000700070077707700000000000000000
-- 053:0000000000000000070707000770070007070700070700770000000000000000
-- 054:0000000000000000077707700777070707070707070707070000000000000000
-- 055:0000000000000000007700770707070707070777077007000000000000000000
-- 056:0000000000000000007007700707070707700770007707070000000000000000
-- 057:0000000000000000007707770700007000070070077000700000000000000000
-- 058:0000000000000000070707070707070707070777007700700000000000000000
-- 059:0000000000000000070707070707007007770070077707070000000000000000
-- 060:0000000000000000070707770777000700070700077007770000000000000000
-- 064:0000000006660666060606060666066006060606060606660000000000000000
-- 065:0000000000660660060006060600060606000606006606660000000000000000
-- 066:0000000006660666060006000660066006000600066606000000000000000000
-- 067:0000000000660606060006060600066606060606066606060000000000000000
-- 068:0000000006660666006000600060006000600060066606600000000000000000
-- 069:0000000006060600060606000660060006060600060606660000000000000000
-- 070:0000000006660660066606060606060606060606060606060000000000000000
-- 071:0000000000660666060606060606066606060600066006000000000000000000
-- 072:0000000000600666060606060606066006600606006606060000000000000000
-- 073:0000000000660666060000600666006000060060066000600000000000000000
-- 074:0000000006060606060606060606060606060666006600600000000000000000
-- 075:0000000006060606060606060606006006660606066606060000000000000000
-- 076:0000000006060666060600060666006000060600066606660000000000000000
-- 080:0000000000000000006606600606066006660606060606660000000000000000
-- 081:0000000000000000006606600600060606000606006606600000000000000000
-- 082:0000000000000000066606660660066006000600006606000000000000000000
-- 083:0000000000000000006606060600060606060666066606060000000000000000
-- 084:0000000000000000066606660060006000600060066606600000000000000000
-- 085:0000000000000000060606000660060006060600060600660000000000000000
-- 086:0000000000000000066606600666060606060606060606060000000000000000
-- 087:0000000000000000006600660606060606060666066006000000000000000000
-- 088:0000000000000000006006600606060606600660006606060000000000000000
-- 089:0000000000000000006606660600006000060060066000600000000000000000
-- 090:0000000000000000060606060606060606060666006600600000000000000000
-- 091:0000000000000000060606060606006006660060066606060000000000000000
-- 092:0000000000000000060606660666000600060600066006660000000000000000
-- 096:0000000009990999090909090999099009090909090909990000000000000000
-- 097:0000000000990990090009090900090909000909009909990000000000000000
-- 098:0000000009990999090009000990099009000900099909000000000000000000
-- 099:0000000000990909090009090900099909090909099909090000000000000000
-- 100:0000000009990999009000900090009000900090099909900000000000000000
-- 101:0000000009090900090909000990090009090900090909990000000000000000
-- 102:0000000009990990099909090909090909090909090909090000000000000000
-- 103:0000000000990999090909090909099909090900099009000000000000000000
-- 104:0000000000900999090909090909099009900909009909090000000000000000
-- 105:0000000000990999090000900999009000090090099000900000000000000000
-- 106:0000000009090909090909090909090909090999009900900000000000000000
-- 107:0000000009090909090909090909009009990909099909090000000000000000
-- 108:0000000009090999090900090999009000090900099909990000000000000000
-- 112:0000000000000000009909900909099009990909090909990000000000000000
-- 113:0000000000000000009909900900090909000909009909900000000000000000
-- 114:0000000000000000099909990990099009000900009909000000000000000000
-- 115:0000000000000000009909090900090909090999099909090000000000000000
-- 116:0000000000000000099909990090009000900090099909900000000000000000
-- 117:0000000000000000090909000990090009090900090900990000000000000000
-- 118:0000000000000000099909900999090909090909090909090000000000000000
-- 119:0000000000000000009900990909090909090999099009000000000000000000
-- 120:0000000000000000009009900909090909900990009909090000000000000000
-- 121:0000000000000000009909990900009000090090099000900000000000000000
-- 122:0000000000000000090909090909090909090999009900900000000000000000
-- 123:0000000000000000090909090909009009990090099909090000000000000000
-- 124:0000000000000000090909990999000900090900099009990000000000000000
-- 128:0000000002200222002000020020022200200200022202220000000000000000
-- 129:0000000002220202000202020022022200020002022200020000000000000000
-- 130:0000000002220200020002000222022200020202022202220000000000000000
-- 131:0000000002220222000202020002022200020202000202220000000000000000
-- 132:0000000002220222020202020222020200020202000202220000000000000000
-- 133:0000000000000000000000000000000000000000002000000000000000000000
-- 144:0000000000100030001003030010030300000300001000330000000000000000
-- 145:0000000002020333022203300202003302220333020200300000000000000000
-- 146:0000000002020030000203030020000002000000020200000000000000000000
-- 147:0000000003300202033000200333022203030020033302020000000000000000
-- 148:0000000000300030030000030300000303000003003000300000000000000000
-- 149:0000000000000000000000000222000000000000000003330000000000000000
-- 150:0000000000000000002002220222000000200222000000000000000000000000
-- 151:0000000000330330003000300330003300300030003303300000000000000000
-- 152:0000000003300033030000030300000303000003033000330000000000000000
-- 153:0000000003000020003000200030002000300020000300200000000000000000
-- 154:0000000000000000003000300000000000300030030000000000000000000000
-- 155:0000000000000003000000300000030000300030030000030000000000000000
-- 156:0000000003000000003000000003000000300000030000100000000000000000
-- 157:0000000000030111003000010030001100300000030000100000000000000000
-- 158:0000000003000000003000030000033300000300000000000000000000000000
-- 159:0000000009090009090900900000000000000000000000000000000000000000
-- 160:0000000009900999009000090090099900900900099909990000000000000000
-- 161:0000000009990909000909090099099900090009099900090000000000000000
-- 162:0000000009990900090009000999099900090909099909990000000000000000
-- 163:0000000009990999000909090009099900090909000909990000000000000000
-- 164:0000000009990999090909090999090900090909000909990000000000000000
-- 176:0000000000900090009009090090090900000900009000990000000000000000
-- 177:0000000009090999099909900909009909990999090900900000000000000000
-- 178:0000000009090090000909090090000009000000090900000000000000000000
-- 179:0000000009900909099000900999099909090090099909090000000000000000
-- 180:0000000000900090090000090900000909000009009000900000000000000000
-- 181:0000000000000000000000000999000000000000000009990000000000000000
-- 182:0000000000000000009009990999000000900999000000000000000000000000
-- 183:0000000000990990009000900990009900900090009909900000000000000000
-- 184:0000000009900099090000090900000909000009099000990000000000000000
-- 185:0000000009000090009000900090009000900090000900900000000000000000
-- 186:0000000000000000009000900000000000900090090000000000000000000000
-- 187:0000000000000009000000900000090000900090090000090000000000000000
-- 188:0000000009000000009000000009000000900000090000900000000000000000
-- 189:0000000000090999009000090090009900900000090000900000000000000000
-- 190:0000000009000000009000090000099900000900000000000000000000000000
-- 240:0000000000000000000000000000000000000000000000000000000004440000
-- 241:0000000000010000001100000111111000110000000100000000000000000000
-- 242:0000000000110101010001010111011100010101011001010000000000000000
-- 243:0000000001110110010101010111010101010101010101110000000000000000
-- 244:0000000001110101010101010101010101010111011101110000000000000000
-- 245:0000000000110000010000000111000000010000011000000000000000000000
-- 246:0000000004444400043334000433440004545440044445400000444000000000
-- 247:0000000004444400043334000443440004434400045554000444440000000000
-- 248:0044400000434000444344404543334044533540044554400044440000000000
-- 249:0044440000433440444333404543334044533540044554400044440000000000
-- 250:0000000000444400044334400453334004533540044554400044440000000000
-- 251:0000000004444000041c440004caa440044a5740004474400004440000000000
-- 252:3333333334444443340000433400004334000043340000433444444333333333
-- 255:3333333330444403344004433408084334000043344444443444444334333333
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
-- 000:0000005d657500beffffffff505050cacaca00c200ff009dda0000ff9500ffff00ff00e2ffb681000000000000000000
-- </PALETTE>

