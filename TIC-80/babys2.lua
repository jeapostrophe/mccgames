-- title:  Space Baybys
-- author: Floer fairys
-- desc:   short description
-- script: lua

function foreach(t, f)
 for k,v in pairs(t) do
	 f(v)
	end
end
function abs(x)
 if x < 0 then return -1*x end
	return x
end
function clamp(sm,x,lg)
 if x < sm then return sm end
	if x > lg then return lg end
	return x
end
cx=0
cy=0
function camera(nx, ny)
 cx=nx
	cy=ny
end
function _map(x,y)
 x=x+cx/8
	y=y
	w=30+1
	h=17+1
	sx=-1-cx%8
	sy=0

 map(x,y,w,h,sx,sy)
end
function _spr(id, x, y, colorkey, scale, flip, rotate, w, h)
 x=x-cx
	y=y-cy
 colorkey=colorkey or -1
	scale=scale or 1
	flip=flip or 0
	rotate=rotate or 0
	w=w or 1
	h=h or 1
 spr(id, x, y, colorkey, scale, flip, rotate, w, h)
end
function _print(text, x, y, color, fixed, scale, smallfont)
 x=x or 0
	y=y or 0
	x=x-cx
	y=y-cy
	color=color or 15
	fixed=fixed or false
	scale=scale or 1
	smallfont=smallfont or false
 print(text, x, y, color, fixed, scale, smallfont)
end

--variables

function _init()
	player={
		sp=256,
		x=0,
		y=9,
		w=8,
		h=8,
		flp=false,
		dx=0,
		dy=0,
		max_dx=2,
		max_dy=3,
		acc=0.5,
		boost=4,
		anim=0,
		running=false,
		jumping=false,
		falling=false,
		sliding=false,
		landed=false,
		shot_delay=0,
		hp=3,
		vdelay=0
	}

 mob_kinds={}
 
 -- shuriken=1
 mob_kinds[1] = {
  sp=277,
		spck=10,
  w=3,
  h=3,
  up=shuriken_up
 }
 -- stealth ninja=2
 mob_kinds[2] = {
  sp=48,
  w=8,
  h=8,
  up=stealth_up
 }
 -- enemy ninja=3
 mob_kinds[3] = {
 	sp=32,
 	w=8,
 	h=8,
 	up=ninja_up
 }
 --scorpion=4
 mob_kinds[4] = {
  sp=60,
  w=8,
  h=8,
  up=enemy_up
 }
 
	
	max_objs=100000000000000000000000000
	objs={}
	
	gravity=0.2
	friction=0
	
	--simple camera
	cam_x=0
	cam_y=0
	
	--map limits
	map_start=0
	map_end=164*8
	
	--map variables
	map_x=0
	map_y=0
	
	--levels
	level=0
	levels=1
	
	init_lv()
end

function _update()
	player_update()
	player_animate()

 foreach(objs,obj_update)
	
	--simple camera
	cam_x=player.x-64+(player.w/2)
	if cam_x<map_start then
		cam_x=map_start
	end
	if cam_x>map_end-128 then
		cam_x=map_end-128
	end
	camera(cam_x,cam_y)
end

function _draw()
	cls()
	_map(map_x,map_y)
	px=player.x
	py=player.y
	pf=0
	if player.flip then pf=1 end
	_spr(player.sp,px,py,0,1,pf)

 foreach(objs,obj_draw)
	
	--todo: use for loop
	if player.hp==3 then
	 _print("3",cam_x,0,8)
	elseif player.hp==2 then
		_print("2",cam_x,0,8)
	elseif player.hp==1 then
		_print("1",cam_x,0,8)
	elseif player.hp==0 then
		cls()
		_print ("game over! :(",cam_x+38,cam_y+64,2)
		_print("press Z to play again!",cam_x+20,cam_y+72,5)
	end
	_print(player.dx,cam_x,8,8)
	_print(player.dy,cam_x,16,8)
end

function TIC()
 _update()
	_draw()
end

-->8
--collision

function collide_map(obj,aim,flag)
	--obj = table;needs x,y,w,h
	--aim = left,right,up,down,here
	
	local x=obj.x local y=obj.y
	local w=obj.w local h=obj.h
	
	local x1=0 local y1=0
	local x2=0 local y2=0
	
	if aim=="left" then
		x1=x-1   y1=y
		x2=x     y2=y+h-1
		
	elseif aim=="right" then
		x1=x+w-1   y1=y
		x2=x+w y2=y+h-1
		
	elseif aim=="up" then
		x1=x+2   y1=y-1
		x2=x+w-3 y2=y
		
	elseif aim=="down" then
		x1=x+2     y1=y+h
		x2=x+w-3   y2=y+h
		
	elseif aim=="here" then
		x1=x       y1=y
		x2=x+w     y2=y+h
				
	end
	
	--[[---test-----
	x1r=x1  y1r=y1
	x2r=x2  y2r=y2
	--------------]]
	
	--pixels
	x1=x1/8  y1=y1/8
	x2=x2/8  y2=y2/8
	
	if fget(mget(map_x+x1,map_y+y1), flag)
	or fget(mget(map_x+x1,map_y+y2), flag)
	or fget(mget(map_x+x2,map_y+y1), flag)
	or fget(mget(map_x+x2,map_y+y2), flag) then
		return true
	else
		return false
	end
	
end
-->8
--player

function player_update()
	if collide_map(player,"down",2) then
		--sand=f2
		friction=0.50
		player.boost=2
	elseif collide_map(player,"down",3) then
		--ice=f3
		friction=0.95
		player.max_dx=3
	elseif collide_map(player,"down",4) then
		--lava=f4
		player.x=0
		player.y=9
		player.hp=player.hp-1
	elseif collide_map(player,"up",7) then
		--coin=f7
		level=(level+1)%levels
		init_lv()
		player.hp=3
	else
		--default settings
		friction=0.85
		player.max_dx=2
		player.boost=4
	end

	--physics!
	player.dy=player.dy+gravity
	player.dx=player.dx*friction
	
	--win/die
	if btn(4) then
		level=0
		init_lv()
		player.hp=3
	end
		
	--weapon
	if btn(5) and player.shot_delay==0 then
 	ds=1
 	if player.flip then
 	 ds = -1
 	end
		add_obj({
 	 k=1,
 	 x=player.x+ds*8,
 	 y=player.y,
 	 f=false,
 	 dx=ds*2.1,
 	 dy=0 })
  player.shot_delay=30
	end
	if player.shot_delay > 0 then
	 player.shot_delay=player.shot_delay-1
	end
	
	--controls
	if btn(2) then
		player.dx=player.dx-player.acc
		player.running=true
		player.flip=true
	end
	if btn(3) then
		player.dx=player.dx+player.acc
		player.running=true
		player.flip=false
	end
	
	--slide
	if player.running
	and not btn(2)
	and not btn(3)
	and not player.falling
	and not player.jumping then
		player.running=false
		player.sliding=true
	end
	
	--jump
	if btnp(0)
	and player.landed then
		player.dy=player.dy-player.boost
		player.landed=false
	end
	
	--check collide�
	if player.dy>0 then
		player.falling=true
		player.landed=false
		player.jumping=false
		
		player.dy=limit_speed(player.dy,player.max_dy)
		
		if collide_map(player,"down",0) then
			player.landed=true
			player.falling=false
			player.dy=0
			-- player.y=player.y-((player.y+player.h+1)%8)-1
			--[[----test-----
			collide_d="yes"
		else
			collide_d="no"
			---------------]]
		end
	
	elseif player.dy<0 then
		player.jumping=true
		if collide_map(player,"up",1) then
		 player.dy=0
		 
		 --[[----test-----
			collide_u="yes"
		else
			collide_u="no"
			---------------]]
		end
	end
	
	--check collide ⬅️/➡️
	if player.dx<0 then
	
		player.dx=limit_speed(player.dx,player.max_dx)
	
		if collide_map(player,"left",1) then
			player.dx=0
			
			--[[----test-----
			collide_l="yes"
		else
			collide_l="no"
			--------------]]
			
		end
	elseif player.dx>0 then
	
		player.dx=limit_speed(player.dx,player.max_dx)
	
		if collide_map(player,"right",1) then
			player.dx=0
			
			--[[----test-----
			collide_r="yes"
		else
			collide_r="no"
			--------------]]
			
		end
	end
	
	--slide
	if player.sliding then
		if abs(player.dx)<.2
		or player.running then
			player.dx=0
			player.sliding=false
		end
	end
	
	player.x=player.x+player.dx
	player.y=player.y+player.dy
	
	--limit player to map
	if player.x<map_start then
		player.x=map_start
	end
	if player.x>map_end-player.w then
		player.x=map_end-player.w
	end
	
	if player.vdelay>0 then
		player.vdelay=player.vdelay-1
	end
end

function player_animate()
	if player.jumping then
		player.sp=259
	elseif player.falling then
		player.sp=260
	elseif player.sliding then
		player.sp=257
	elseif player.running then
		if time()-player.anim>.1 then
			player.anim=time()
			player.sp=player.sp+1
			if player.sp>258 then
				player.sp=256
			end
		end
	else --player idle 
		if time()-player.anim>.3 then
			player.anim=time()
			player.sp=player.sp+1
			if player.sp>260 then
				player.sp=259
			end
		end
	end
end

function limit_speed(num,maximum)
	return clamp(-maximum,num,maximum)
end

function player_touch(o)
 if player.vdelay>0 then
 	return 
 end
 
 if rect_intersect(
     player.x,player.y,
     player.w,player.h,
     o.x,o.y,
     o.w,o.h) then
  player.hp=player.hp-1
  player.vdelay=45
  -- sfx(1)
 end
end

function rect_intersect(x1,y1,w1,h1,x2,y2,w2,h2)
 return line_intersect(x1,w1,x2,w2) and line_intersect(y1,h1,y2,h2)
end

function line_intersect(x1,w1,x2,w2)
 return (x1 <= x2+w2) and (x1+w1 >= x2)
end
-->8
--levels

function init_lv()
	objs={}
 if level==0 then
 	map_x=0
 	map_y=0
 	player.x=0
 	player.y=9
 	-- music(0)
 	print("lv 1",96,56,3)
 	--add_ninja(12,9)
 	--add_ninja(91,7)
 	--add_ninja(33,13)
 elseif level==1 then
	 map_x=0
  map_y=16
	 player.x=0
	 player.y=24
	 print("lv 2",8,184,3)
	 music(0)
	 add_enemy(14,29)
	 add_enemy(102,29)
	elseif level==2 then
		map_x=0
		map_y=32
		player.x=0
		player.y=39
		print("lv 3",16,312,3)
		music(0)
	elseif level==3 then
		map_x=0
		map_y=48
		player.x=0
		player.y=54
		print("lv 4",40,360,3)
		music(3)
		add_stealth(24,61)
		add_stealth(74,61)
		add_stealth(93,61)
		add_stealth(106,61)
		add_stealth(107,56)
		add_stealth(118,54)
		add_stealth(10,61)
	end
end

-->8
--projectiles and enemys
function add_obj(o)
	ok=mob_kinds[o.k]
 o.w=ok.w
 o.h=ok.h

	objs[1+#objs]=o
end

function obj_update(o)
	ok=mob_kinds[o.k]
	ok.up(o)
end

function shuriken_up(o)
 o.x=o.x+o.dx
 o.y=o.y+o.dy
	
	if o.dx < 0 then
		o.f=true
	end

 if collide_map(o,"here",0) then
 	o.dx=0 
 	o.dy=0
 end
end

function obj_draw(o)
	ok=mob_kinds[o.k]
	sp=ok.sp
	if o.sp then
		sp=o.sp
	end
	local fi=0
	if o.f then fi=1 end
 _spr(sp,o.x,o.y,ok.spck,1,fi)
end

function add_ninja(mx,my)
	add_obj({
	 k=3,
	 x=mx*8,
  y=my*8,
	 f=false,
	 sp=32,
	 anim=0,
	 dx=0,
 	dy=0 })	
end

function add_enemy(mx,my)
	add_obj({
	 k=4,
	 x=mx*8,
  y=my*8,
	 f=false,
	 sp=60,
	 anim=0,
	 dx=0,
 	dy=0 })	
end

function add_stealth(mx,my)
	add_obj({
	 k=2,
	 x=mx*8,
  y=my*8,
	 f=false,
	 sp=48,
	 anim=0,
	 dx=0,
 	dy=0 })	
end

function stealth_up(o)
 fs=-1 fm=0.5
 if o.f then fs=1 fm=1 end
 dx=0
 if fget(mget((o.x+fm*fs*o.w)/8,(o.y+o.h)/8),0) and (not fget(mget((o.x+fm*fs*o.w)/8,o.y/8),0)) then
  dx=fs*1*friction
 else
  o.f=not o.f
 end
 o.x=o.x+dx

 player_touch(o)

	if time()-o.anim>.3 then
		o.anim=time()
		o.sp=o.sp+1
		if o.sp>49 then
			o.sp=48
		end
	end
end

function ninja_up(o)
 fs=-1 fm=0.5
 if o.f then fs=1 fm=1 end
 dx=0
 if fget(mget((o.x+fm*fs*o.w)/8,(o.y+o.h)/8),0) and (not fget(mget((o.x+fm*fs*o.w)/8,o.y/8),0)) then
  dx=fs*1*friction
 else
  o.f=not o.f
 end
 o.x=o.x+dx

 player_touch(o)

	if time()-o.anim>.3 then
		o.anim=time()
		o.sp=o.sp+1
		if o.sp>33 then
			o.sp=32
		end
	end
end

function enemy_up(o)
 fs=-1 fm=0.5
 if o.f then fs=1 fm=1 end
 dx=0
 if fget(mget((o.x+fm*fs*o.w)/8,(o.y+o.h)/8),0) and (not fget(mget((o.x+fm*fs*o.w)/8,o.y/8),0)) then
  dx=fs*1*friction
 else
  o.f=not o.f
 end
 o.x=o.x+dx

 player_touch(o)

	if time()-o.anim>.3 then
		o.anim=time()
		o.sp=o.sp+1
		if o.sp>63 then
			o.sp=60
		end
	end
end

_init()

-- <TILES>
-- 001:aaaaaaaaaaaaaaaaaaaaa666aaa66666aa666666a6666666a6666666a6666666
-- 002:aaaaaaaaaaaaaaaa666aaaaa66666aaa666666aa6666666a6666666a6666666a
-- 003:3333333322222222333333332222222233333333222222223333333322222222
-- 004:1111111122222222111111112222222211111111222222221111111122222222
-- 005:5555555566666666555555556666666655555555666666665555555566666666
-- 006:aaaaaaaaaaaaaaaa13a31aaa33a33aaaaa2a2a31aaa22233aaa22aaaaaa22aaa
-- 007:66666666666666666ee66e6ee6ee6eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 008:aa7777aaaa7ff7aaaa7ff7aaaa7777aaaaa55aaaa6a55aa66aa55a6aa6a55a6a
-- 009:aaaaaaaaaaaaaaaaaaaaaaaaaaaa1aaaaa1aa1aaa1aa11aaa1aa11aaaa1aa1aa
-- 010:1111111111111111188118188188188888888888888888888888888888888888
-- 011:aaaaaaaaaaaaaaaaaf65665aaf66556aaf66556aaf66666aafaaaaaaafaaaaaa
-- 012:aaaaaaaaaaaaaaaaad88222aad88cccaad22222aadcccccaadaaaaaaadaaaaaa
-- 013:aaacaaaaacaaacaaaf65665acf66556caf66556aaf66666acfaaaacaafaacaaa
-- 014:acaaaacaaacacaaacd88222aad88cccaad22222acdcccccaadaaaaaccdacaaaa
-- 016:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 017:a6666666a6666666a6666666aa666666aaaaeeeeaaaaeeeeaaaaeeeeaaaaeeee
-- 018:6666666a6666666a6666666a666666aaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaa
-- 019:aa322aaaaa222aaaaa223aaaaa232aaaaa222aaaaa322aaaaa223aaaaa322aaa
-- 020:aa211aaaaa111aaaaa112aaaaa121aaaaa111aaaaa211aaaaa112aaaaa211aaa
-- 021:aa566aaaaa666aaaaa665aaaaa656aaaaa666aaaaa566aaaaa665aaaaa566aaa
-- 022:2222222222222222233223233233233333333333333333333333333333333333
-- 023:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 024:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadadadadadadadadcdcdcdcdcdcdcdcd
-- 025:cdcdcdcdcdcdcdcdadadadadadadadadaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 026:8888888888888888888888888888888888888888888888888888888888888888
-- 027:cdcdcdcdcdcdcdcdad1d2dadad1d1dadaa111aaaaa211aaaaa112aaaaa211aaa
-- 028:99999999999999999f6566599f6655699f6655699f6666699f9999999f999999
-- 029:99999999999999999d8822299d88ccc99d2222299dccccc99d9999999d999999
-- 032:9999999999999999999999999999999999999999999999999999999999999999
-- 033:aaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeee
-- 034:eeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaa
-- 035:aaaaaaaaaaaaaa5aaaa5a556aa55555aa6555aaaa5565aaaa5555aaaa6556aaa
-- 036:aaaaddddaaaaaaccaaaaddddaaaaaaccaaaaddddaaaaaaccaaaaddddaaaaaacc
-- 037:6666666666666666655665655655655555555555555555555555555555555555
-- 038:3333333333333333333333333333333333333333333333333333333333333333
-- 039:ddaaaddadddadddaaddaddaaaadddaaaaadddaaaaadddaaaaadddaaaaadddaaa
-- 040:dddddddadddddddadddddddaddaaaddadddddddadddddddaddaaaddaddaaadda
-- 041:ddaaaddadddadddaaddaddaaaadddaaaaadddaaaaadddaaaaadddaaaaadddaaa
-- 042:aaaddaaaaaaddaaaaaaddaaaaaaddaaaaaaddaaaaaaaaaaaaaaddaaaaaaddaaa
-- 043:aa566aaaaa665aaaaa566aaaaa666aaaad6d6dadad6d5dadcdcdcdcdcdcdcdcd
-- 044:aa322aaaaa223aaaaa322aaaaa222aaaad2d2dadad2d3dadcdcdcdcdcdcdcdcd
-- 045:998ff99999ff8999998ff99999fff9999dfdfd9d9dfd8d9dcdcdcdcdcdcdcdcd
-- 046:aa211aaaaa112aaaaa211aaaaa111aaaad1d1dadad1d2dadcdcdcdcdcdcdcdcd
-- 047:cabccaaaaaccbacaaabccaaaaacccaaccdcdbdadadcdcdadbdbdbdbdbdbdbdbd
-- 048:9999999999999999999999999999999999999999999999999999999999999999
-- 049:aaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeee
-- 050:eeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaa
-- 051:cc999999dddd9999cc999999dddd9999cc999999dddd9999cc999999dddd9999
-- 052:ccaaaaaaddddaaaaccaaaaaaddddaaaaccaaaaaaddddaaaaccaaaaaaddddaaaa
-- 053:5555555555555555555555555555555555555555555555555555555555555555
-- 054:88888888ffffffff88888888ffffffff88888888ffffffff88888888ffffffff
-- 055:dd999dd9ddd9ddd99dd9dd9999ddd99999ddd99999ddd99999ddd99999ddd999
-- 056:999999999ddddd99ddddddd9dd999dd9dd999dd9dd999dd9ddddddd99ddddd99
-- 057:99999999999999999dd99dd99dd99dd99dd99dd99dd99dd99dddddd999dddd99
-- 058:9999999999999999d999999ddd99d9dd9dd9d9d999ddddd99999999999999999
-- 059:99999999999d999999999999999d9999999d9999999d9999999d9999999ddddd
-- 060:999999999d9999999dd99d999d9d9d999d99dd999d999d999d999d99dddd9d99
-- 061:ddcacddadddadddaaddcddacaadddaaacadddcacaadddaaaacdddaaccadddcaa
-- 062:dddddddcdddddddadddddddaddcacddcdddddddadddddddcddaacddaddcaaddc
-- 063:caaddacaaacddaaacaaddaaaaaaddcacaaaddaaaacaaacaaaaaddaaacaaddaac
-- 064:aaaaaaaaaaa66aaaa666666a6666666666666666a6666666a666666aaa66666a
-- 065:aaaacaaaacaaaaaaaaaaaacaaaaaaaaaaacaaaaaaaaacaaaacaaaacaaaaaaaaa
-- 066:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 067:9999dddd999999cc9999dddd999999cc9999dddd999999cc9999dddd999999cc
-- 068:bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
-- 069:acaaaaaaaabbbacaacbbbcaaaccbccacaacccaaacaacaacaaaaacaaaacacaaac
-- 070:998ff99999fff99999ff899999f8f99999fff999998ff99999ff8999998ff999
-- 071:bbbbbbbbbbbbbbbbbccbbcbccbccbccccccccccccccccccccccccccccccccccc
-- 072:fffffffffffffffff88ff8f88f88f88888888888888888888888888888888888
-- 073:fffff323fffff333f88ff8328f88f88888888888888888888888888888888888
-- 074:3232332333333233323233238888888888888888888888888888888888888888
-- 075:323fffff333fffff238ff88f888f88f888888888888888888888888888888888
-- 076:6666666a6666666a6666666a666666aaeeeeacaaeeeefcafeeeeaffaeeeeaffa
-- 077:aaaaaaaaaaaaaaaaaaaaa666aaa66666aa666666a6666666a6666666a6666666
-- 078:aaaaaaaaaaaaaaaa666aaaaa66666aaa666666aa6666666a6666666a6666666a
-- 079:eeeefaafeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaa
-- 080:aaaeeaaaaaaeeaaaaaaeeaaaaaaeeaaaaaaeeaaaaaaeeaaaaaaeeaaaaaaeeaaa
-- 081:ddfffdddddff0dddddf0fddddd0ffdddddfffdddddff0dddddf0fddddd0ffddd
-- 082:88888888f8f8f8f8ffffffffffffffffffffffffffffffffffffffffffffffff
-- 083:cdcdcdcdcdcdcdcd9d9d9d9d9d9d9d9d99999999999999999999999999999999
-- 084:999999999999999999999999999999999d9d9d9d9d9d9d9dcdcdcdcdcdcdcdcd
-- 085:aaaaaaaaaaaaaaaaabbbbbbbbcbbbcbcbcbcbcbcacbcbcbcaaabbcbcbcbcbcbc
-- 086:aaaaaaaaaaaaaaaabbbbbbbabcbcbcbcbcbcbcbcbcbbbbbabcbaaaaabcbcbcbc
-- 087:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 088:8888888888888888888888888888888888888888888888888888888888888888
-- 089:9999999999999999999999999989999999f9989999ffff99999f99f999f99998
-- 090:aaaae566aaaac666aaaac66caaaaecccaaaaecc6aaaaecccaaaaec6caaaacc66
-- 091:dddddddddddddddddfaaaaaddfaaddaddfaabbaddfaaaaaddfdddddddfdddddd
-- 092:dddddddddddddddddf88222ddf88cccddf22222ddfcccccddfdddddddfdddddd
-- 093:a6666666a6666666a6666666aa666666aaaaeeeeaaaaeeeeaaaaeeeeaaaaeeee
-- 094:6666666a6666666a6666666a666666aaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaaa
-- 096:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa22aaaaa733aaaaaa333aaaaaa7aaa
-- 097:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa22aaaaaa337aaaa333aaaaaa7aaaa
-- 098:aaaaaaaaaaaaaaaaaaaaaaaaaaa3322aaa2733aaa222a33aaaaaaaaaaaaaaaaa
-- 099:aaaaaaaaaaaaaaaaaaaaaaaaaaa22aaaaaa337aaaa333aaa4ee4eee4a4eee4ea
-- 100:aaaaaaaaaaaaaaaaaaaaaaaaaaa22aaaaca337aacc333cca4ee4eee4a4eee4ea
-- 101:aaaaaaaaaaaaaaaaaaaaaaaaaaaccaaaaaccccaaaaccccaaaaccccaaaaaccaaa
-- 102:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 103:ccccccccbbbbbbbbccccccccbbbbbbbbccccccccbbbbbbbbccccccccbbbbbbbb
-- 104:999d0ded999d0d6d999d0d4d999d0d9d999d049d999d0d8d999d0d8d999ddddd
-- 105:ed0d99996d0d99994d0d99999d0d9999940d99998d0d99998d0d9999dddd9999
-- 106:fffff565fffff555f88ff8568f88f88888888888888888888888888888888888
-- 107:5656556555555655565655658888888888888888888888888888888888888888
-- 108:565fffff555fffff658ff88f888f88f888888888888888888888888888888888
-- 112:aaaaaaaaaaaaaaaaaaaaaaaaa22aa33aaa2333aaaaa7322aaaaaaaaaaaaaaaaa
-- 113:aaaaaaaaaaaaaaaaaaaaaaaaa33aa22aaa3332aaa2237aaaaaaaaaaaaaaaaaaa
-- 114:aaaaaaaaaaaaaaaaaaaaaaaaa2233aaaaa3372aaa33a222aaaaaaaaaaaaaaaaa
-- 115:0f0f0f0ff0f0f0f00f0f0f0fdd0ffdddddfffdddddff0dddddf0fddddd0ffddd
-- 116:ddddddddddddddddddddddddddddddddd6d6d6d6d6d6d6d65656565656565656
-- 117:aaaaaaaaaaaaaaaaaaaaaaaaaaa56aaaaa5555aaaa5656aaaa5555aaaa6556aa
-- 118:66666666666666666ee66e6ee6ee6eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 119:cabccaaaaacccaacaaccbaaacacbcaaaaacccacaacbccaaaaaccbcaacabccaac
-- 120:9999999999999999999999999999999999988999992ff999999fff9999992999
-- 121:9999999999999999999999999999999999988999999ff29999fff99999929999
-- 122:999999999999999999999999999ff8899982ff9998889ff99999999999999999
-- 123:aaaaaaaccaacaaaaaaaaacaaacaaaaaaadadadadadadadadcdcdcdcdcdcdcdcd
-- 124:cdcdcdcdcdcdcdcdadadadadadadadadacaaaaaaaaaaacaacaacaaaaaaaaaaac
-- 125:ccaaaacaddddcaaaccaaaaaaddddaacaccaaaaaaddddacaaccaaaaaaddddaaac
-- 126:caaaddddaaaaaaccaacaddddaaaaaaccacaaddddaaaaaaccaaacddddacaaaacc
-- 128:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa88aaaaa799aaaaaa999aaaaaa7aaa
-- 129:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa88aaaaaa997aaaa999aaaaaa7aaaa
-- 130:aaaaaaaaaaaaaaaaaaaaaaaaaaa9988aaa8799aaa888a99aaaaaaaaaaaaaaaaa
-- 131:aaaaaaaaaaaaaaaaaaaaaaaaaaa88aaaaaa997aaaa999aaa4ee4eee4a4eee4ea
-- 132:aaaaaaaaaaaaaaaaaaaaaaaaaaa88aaaaca997aacc999cca4ee4eee4a4eee4ea
-- 133:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 134:aaaaeeeeaaaaeeeeaaaaeeeeaaaaeeeeaaa22eeeaa733eeeaaa333eeaaaa7eee
-- 136:99999999999999999999999998899ff9998fff999992f8899999999999999999
-- 137:9999999999999999999999999ff9988999fff899988f29999999999999999999
-- 138:999999999999999999999999988ff99999ff28999ff988899999999999999999
-- 144:aaaaaaaaaaaaaaaaaaaaaaaaa88aa99aaa8999aaaaa7988aaaaaaaaaaaaaaaaa
-- 145:aaaaaaaaaaaaaaaaaaaaaaaaa99aa88aaa9998aaa8897aaaaaaaaaaaaaaaaaaa
-- 146:aaaaaaaaaaaaaaaaaaaaaaaaa8899aaaaa9978aaa99a888aaaaaaaaaaaaaaaaa
-- 147:0f0f0f0ff0f0f0f00f0f0f0fddffffdddbddddbdddbbbbdddddddddddddbbddd
-- 148:ddfffdddddff0dddddf0fddddd0ffdddd6f606d6d6f6f6d65656565656565656
-- 149:88888565f8f8f555ffffff56ffffffffffffffffffffffffffffffffffffffff
-- 150:565655655555565556565565ffffffffffffffffffffffffffffffffffffffff
-- 151:565888885558f8f865ffffffffffffffffffffffffffffffffffffffffffffff
-- 160:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa11aaaaa722aaaaaa222aaaaaa7aaa
-- 161:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa11aaaaaa227aaaa222aaaaaa7aaaa
-- 162:aaaaaaaaaaaaaaaaaaaaaaaaaaa2211aaa1722aaa111a22aaaaaaaaaaaaaaaaa
-- 163:aaaaaaaaaaaaaaaaaaaaaaaaaaa11aaaaaa227aaaa222aaa4ee4eee4a4eee4ea
-- 164:aaaaaaaaaaaaaaaaaaaaaaaaaaa11aaaaca227aacc222cca4ee4eee4a4eee4ea
-- 176:aaaaaaaaaaaaaaaaaaaaaaaaa11aa22aaa1222aaaaa7211aaaaaaaaaaaaaaaaa
-- 177:aaaaaaaaaaaaaaaaaaaaaaaaa22aa11aaa2221aaa1127aaaaaaaaaaaaaaaaaaa
-- 178:aaaaaaaaaaaaaaaaaaaaaaaaa1122aaaaa2271aaa22a111aaaaaaaaaaaaaaaaa
-- 192:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa66aaaaa755aaaaaa555aaaaaa7aaa
-- 193:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa66aaaaaa557aaaa555aaaaaa7aaaa
-- 194:aaaaaaaaaaaaaaaaaaaaaaaaaaa5566aaa6755aaa666a55aaaaaaaaaaaaaaaaa
-- 195:aaaaaaaaaaaaaaaaaaaaaaaaaaa66aaaaaa557aaaa555aaa4ee4eee4a4eee4ea
-- 196:aaaaaaaaaaaaaaaaaaaaaaaaaaa66aaaaca557aacc555cca4ee4eee4a4eee4ea
-- 208:aaaaaaaaaaaaaaaaaaaaaaaaa66aa55aaa6555aaaaa7566aaaaaaaaaaaaaaaaa
-- 209:aaaaaaaaaaaaaaaaaaaaaaaaa55aa66aaa5556aaa6657aaaaaaaaaaaaaaaaaaa
-- 210:aaaaaaaaaaaaaaaaaaaaaaaaa6655aaaaa5576aaa55a666aaaaaaaaaaaaaaaaa
-- 212:aaaaaaaaaaaaaaaaaaaaaaaaacceeaaaaaee7caaaeeacccaaaaaaaaaaaaaaaaa
-- 224:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaddaaaaa7ccaaaaaacccaaaaaa7aaa
-- 225:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaddaaaaaacc7aaaacccaaaaaa7aaaa
-- 226:aaaaaaaaaaaaaaaaaaaaaaaaaaaccddaaad7ccaaadddaccaaaaaaaaaaaaaaaaa
-- 228:aaaaaaaaaaaaaaaaaaaaaaaaaaaddaaaaaacc7aaaacccaaa4ee4eee4a4eee4ea
-- 229:aaaaaaaaaaaaaaaaaaaaaaaaaaaddaaaa9acc7aa99ccc99a4ee4eee4a4eee4ea
-- 240:aaaaaaaaaaaaaaaaaaaaaaaaaddaaccaaadcccaaaaa7cddaaaaaaaaaaaaaaaaa
-- 241:aaaaaaaaaaaaaaaaaaaaaaaaaccaaddaaacccdaaaddc7aaaaaaaaaaaaaaaaaaa
-- 242:aaaaaaaaaaaaaaaaaaaaaaaaaddccaaaaacc7daaaccadddaaaaaaaaaaaaaaaaa
-- 243:aaaaaaaaaaaaaaaaaaaaaaaaaffffaaaaaff7faaaffafffaaaaaaaaaaaaaaaaa
-- 244:aaaaaaaaaaaaaaaaaaaaaaaaaaaffaaaaaaff7aaaafffaaa4ee4eee4a4eee4ea
-- 245:aaaaaaaaaaaaaaaaaaaaaaaaaaaffaaaacaff7aaccfffcca4ee4eee4a4eee4ea
-- </TILES>

-- <TILES1>
-- 001:0000000000eee000006460000044400009999900049994000099900000909000
-- </TILES1>

-- <TILES2>
-- 001:e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4
-- 002:eeeeeeee44444444eeeeeeee44444444eeeeeeee44444444eeeeeeee44444444
-- 003:0ee000000ee000000ee000000ee000000ee000000ee000000ee000000ee00000
-- 004:00000000000000000000000000000000eeeeeeeeeeeeeeee0000000000000000
-- 005:000ee000000ee000000ee000000ee000000ee000000ee000000ee000000ee000
-- 006:000000000000000000000000000000000007700004eee440dee4eeed0dddddd0
-- 007:000000000000000000077000044eee4004ee4e400e4444e0deee4eed0dddddd0
-- 008:0000000000eee000006460000044400009999900049994000099900000909000
-- 009:0000000000000000000000000000000000000000000b330000bb333000f333f0
-- 010:0000000000000000000000000000000000000000000b660000bb666000f666f0
-- 011:0000000000000000000000000000000000000000000b110000bb111000f111f0
-- 012:000000000000000000000000000000000000000000bccf000bbccf300ccccf00
-- 013:0000000000000000000000000000000000000000000000000466644444060040
-- 014:000000000000000000000000000000000b30ddddbb3033d3333dddddf0f0f0f0
-- 015:0000000000000000000000f000070fff007770f0007770bb0660222b0660222b
-- 016:fffffffffddddddffddddddffddddddffddddddfffffffff000ff00000ffff00
-- 017:000000000000000000000000000000000000000000dddd0000d65d0000d56d00
-- 018:000000000000000000000000000000000000000000fd270000fd5a0000d00d00
-- 019:eeeeeeeeeee4444eeeee444ee4eee44ee44eee4ee444eeeee4444eeeeeeeeeee
-- 020:00000000000000000000000000000000000ddd0000db33d000bb33300df333fd
-- 021:0000000000000000000d000000d4d000004440000d444dd004404440d440444d
-- 022:00000000000000000000000ee00000cee2222ccee2222eeeeee2eeeee000000e
-- 023:eeeeeeeee00ee00e0e0ee0e000eeee00000ee000000ee000000ee000000ee000
-- 024:ffffffffd00dd00d0d0dd0d000dddd00000dd000000dd00000ddd000000dd000
-- 025:0000000000000000000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeee
-- 026:0000000000555d00005dd700005557700ddd047403a30e4403a30cce03330eec
-- 027:00eeeee000e000e000eeeee000e000e000eeeee000e000e000eeeee000e000e0
-- 028:0000000000777000076467000744470001c1c100041c14000011100000111000
-- 029:000000000000000000e0e00000fef00000e3e0000eeeee0000eee00000e0e000
-- 030:000770000007700000c77c00c077770c7c0770c70770077000c00c0000000000
-- 031:0000000000000000000110000001100000511500901111091901109101100110
-- 032:0000d000000d00000000d000000d0000000dd000000770000007700000000000
-- 033:00dddd00000dd000233ddaa9000dd00000000000000000000000000000000000
-- 034:000000000000000000055000005555000066660000555500000dd00000dddd00
-- 035:ccc00000ccccc0000cccccc0000ccccc00000ccc000000ccddddddccddddddcc
-- 036:00000000000dd00000dabd0000aaaa0000abaa0000aaba0000fbbf000dffffd0
-- 037:000000000000000000000000000000000000000cc0cc00dcccc00dcdc0cc0cdc
-- 038:00000000000000000000000000000000066655600006666000ffffff00dffffd
-- 039:0000000000000000000000000dbbbba00d1111200d4444f00d5555600d333320
-- 040:0000000000f000000f0cccc00f066660f013333701022227010aaaa7100bbbb7
-- 041:000000000000000000eeee0000ee4e0001a44a10e044440e0111111000111100
-- 042:00001100000110000011110000ee4e000ea44ae00e4444e00111111000111100
-- 043:000000000000000000011000001111000033330000111100000dd00000dddd00
-- 044:00000000001010000010100000f1f00000141000001110000011110000101000
-- 045:00000000eece0000e2cce0000dc90000ccddc000cccc00000ccc00000c0cddd2
-- 046:00000000000000000000000000000000000000770b737770bb733770f7777f70
-- 047:000000000abbbbb007bb5bb00abb5bb00ab575b007bb5bb00abbbbb000000000
-- 048:0000000000eee0000064600000444d0002222d0004222d0000fff0d000f0f000
-- 049:00000000007770000764670007444700088888000488840000fff00000f0f000
-- 050:000000000000000000eeee0000ee4e0001a44a10e044440e0444444000444400
-- 051:0000000000000000000000000000000000000000000000000025b70003bbbb10
-- 052:d0ccc0d0d0fcf0d0c0cfc0c00ccccc0000dcd00000ccc00000c0c00000000000
-- 053:000000000000000000000000fff00ffffdf00fdffdf00fdf0d0000d00d0000d0
-- 054:0d0ccc0d0d0fcf0d0c0cfc0c00ccccc0000dcd00000ccc00000c0c0000000000
-- 055:0000000000000000220022223322333333333323332273333232223337332233
-- 056:3333333332233323323333232227332333232323332223333732237333333333
-- 057:0000000000ccc0000cfcfc000ccccc000ccccc000cfcfc000f0f0f0000000000
-- 058:000d00000000d000000d50000505d505005ccc500556c655005c6c5005055505
-- 059:00000000000000000000000000000000000000cca22000aa0cc00022eeeeeeee
-- 060:00000000000000000000000000000000c0000000a0000aa220000cc0eeeeeeee
-- 061:000000000001010000010100000f1f0000014100000111000011110000010100
-- 062:0000d000000d00000000d000000d0000000dd000011111100017710000000000
-- 063:4444444444eeee444eeeeee44eeeee744edeeee44eeeeee44eeeee744eeeeee4
-- 064:0000000000000000e0000000e0000000e4444444eeeeeeeee0000000e0000000
-- 065:000000000000000e0000000e00444cce4444ccceeeeeeeee0000000e0000000e
-- 066:0000000e000000e000000e000000e000000e000000e000000e000000e0000000
-- 067:0000000000eee0000064600000444000022222000422240000fff00000f0f000
-- 068:ccc00ccccfc00cfcccc00ccc0300003003300030003000330330000303000003
-- 069:c00000c0c0000c0001111b00012121000cb11c0011ccc1011b111b10011b1100
-- 070:0000000000000ccc00000cfc00000ccc00000000000000000000000000000000
-- 071:00000000d00000000d00000000d000000b30ddddbb3033d3333dddddf0f0f0f0
-- 072:00000000d00dcd00d001d100d00d1d00ecdcccd0e001d1c0000dcd00000c0c00
-- 073:0000000000555d0000566d0000555d000ddd044403a30e4403a30cce03330eec
-- 074:000ddd0000ccc0d0eeeeeeede0e0e0e0e0e0e0e0e1e1e1e0eeeeeee0e00000e0
-- 075:eeeeeeeeeeeeeeee000000ee000000ee000000ee000000ee000000ee000000ee
-- 076:eeeeeeeeeeeeeeeeee000000ee000000ee000000ee000000ee000000ee000000
-- 077:00000000eeeeeeeeeeeeeeee00eeee0000eeee0000eeee0000eeee0000eeee00
-- 078:000ddd0000ccc0d0eeeeeeede0e0e0e0e0e0e0e0e1e1e1e0eeeeeee0e00000e0
-- 079:0000000000000000022200000232222202023232022203030333000000000000
-- 080:00000000000000000000000000000000000000000000070000007070eeeeeeee
-- 081:001000100001100100111010076467d0074447d0711111d00011100000101000
-- 082:000000000000000000eeee0000ee4e0001a44a10e044440e04444440004cc400
-- 083:eeeeeeeee123567ee123567eeeeeeeeeef89abceef89abceeeeeeeeee000000e
-- 084:0030003300300003030002200332222022f2fff22fcccccf2fcccccf02fffff2
-- 085:001000b000b00010001000b000b00010001000b000b00010001000b001b10b1b
-- 086:000000000fff000002110f0f0101f1f202f11211011200000000000000000000
-- 087:0000cccc00cccccc0ccccc00cccc0000ccc00000cc000000cc0dddddcc0ddddd
-- 088:00000000eeeeeeeeeeeeeeee00eeee0000eeee0000eeee0000eeee0000eeee00
-- 089:000000000000000000000000000000000000001cc1cc11dcccc11d1dc1cc1cd1
-- 090:00000000000000000ccc00000c2cc0000cccffff0c2ccfdf0ccc0d0d00000000
-- 091:0000000000000000077700000737777707073737077703030333000000000000
-- 092:00000000000000000ddd00000dcddddd0d0dcdcd0ddd0c0c0ccc000000000000
-- 093:00000000000000000fff00000f3fffff0f0f3f3f0fff03030333000000000000
-- 094:0000000000000000066700000757777707073636066606050565050000500000
-- 095:00000000000000000aaa00000a9aaaaa0a0a9a9a0aaa09090999000000000000
-- 096:0dd22dd000cccc0000c0c0000000000000000000005c0c0005c5c5005dd22d55
-- 097:000000000000000000000000cf00cf00cc00cc00010010000011000001001000
-- 098:000dd000000dd000000dd000000dd000000dd000000dd000000dd000022dd220
-- 099:0000003300003337000333330733337300373333000333330000037300000033
-- 100:000ddd22000ddd220000cccc0000cccc0000cc000000c0000005000000000000
-- 101:22ddd00022ddd000cccc0000cccc0000cc0c00000c0000005000000000000000
-- 102:dddddddddddddddddddddddd0000000000000000000000000000000000000000
-- 103:0000d000000d00000000d000000d00000000d000000d00000000d000000d0000
-- 104:dddddddddffffffddf0000fddf0600fddf0000fddf0000fddffffffddddddddd
-- 105:dddddddddffffffddf0000fddf0200fddf0000fddf0000fddffffffddddddddd
-- 106:00000000d00dcd00d001d100d00d1d00acdcccd0e001d1c0000dcd00000c0c00
-- 107:0000cccc00cccccc0ccccc00cccc0000ccc00000cc000000cc0dddddcc0ddddd
-- 108:ccc00000ccccc0000cccccc0000ccccc00000ccc000000ccddddddccddddddcc
-- 109:00000000000000000000000000000111000001f1000001110000001f000111ff
-- 110:000000000000000000000000111000001f10000011100000f1000000ff111000
-- 111:4eeeeee44eeeee744eeeeee44edeeee44eeeee744eeeeee444eeee4444444444
-- 112:010010000011000001001000cc00cc00cf00cf00000000000000000000000000
-- 113:000cc000101cf0000100000001000000101cc000000cf0000000000000000000
-- 114:022dd220000dd000000dd000000dd000000dd000000dd000000dd000000dd000
-- 115:3300000073330000333330003733337033337300333330003730000033000000
-- 116:0000000000000000000000cc00050c0c0055c5cc0055cc5c055ddd22550ddd22
-- 117:00000000000000000555500005cc5500cccc0550cccc005022ddd00522ddd005
-- 118:000cc000000fc1010000001000000010000cc101000fc0000000000000000000
-- 119:000000000033310003a4a3000344430031111130041114000011100000111000
-- 120:dd555ddddff5fffddf0005f55f050055550050f55f5000fddfff5ffdddd555dd
-- 121:dddddddddffffffddf000cfddf0c00fddf00c0fddf0000fddcfffffdcddddddd
-- 122:0000000000dddd000ddddddd0dd0adad0dd0adad0dd0dada0dd00a0a0dd00a0a
-- 123:cc0dd0d0cc0dd0d7cc0dd7d4cc0dd7d1cc0dd7d1cc0dd1d1cc0dddddcc0ddddd
-- 124:d0d0ddccd0deddccded4ddccded2ddccded2ddccd2d2ddccddddddccddddddcc
-- 125:0010011f01000111001001110000001101000011001001010001100100000010
-- 126:f110010011100010111001001100000011000010101001001001100001000000
-- 127:0000000000dddd000ddddddd0dd0fdfd0dd0dddd0dd0dfdf0dd000000dd00000
-- 128:0000000009999900099999900999999909999999009999990000999900000999
-- 129:000000000000000000000000999999999999999999999999999999999cc2cccc
-- 130:00000000000000000000000090000000999900009999999099999999ccccc999
-- 131:000000000000000000000000d0d0d0d00d0d0d0d000000000000000000000000
-- 132:00000000000000000000000ee00000cee6666ccee6666eeeeee6eeeee000000e
-- 133:00111100011ff11011f11f111f1f11f11f11f1f111f11f11011ff11000111100
-- 134:0099990009988990998998999898998998998989998998990998899000999900
-- 135:0073730003233330072223600332233007323220036232700732223000373300
-- 136:000909000009990000499940009999900004440000064600000eee0000000000
-- 137:0007e7ee00e7e7ee00e7e7ee00e7e7e700e7e7e700e7e7ee00e7e7ee00e7e7ee
-- 138:ee7e7000ee7e7e00ee7e7e007e7e7e007e7e7e00ee7e7e00ee7e7e00ee7e7e00
-- 139:0022220002233220223223222323223223223232223223220223322000222200
-- 140:0000000000eee000077677000476740007767700077677000099900000909000
-- 141:0000000000eee000011211000412140001121100011211000099900000909000
-- 142:0000000000eee0000ddcdd0004dcd4000ddcdd000ddcdd000099900000909000
-- 143:0000000000eee000022322000423240002232200022322000099900000909000
-- 144:0000099900000099000000990000009900000099000000000000000000000000
-- 145:9cc22ccc9ccc222c9ccccc2c92222fff9ccc2fff9ccccfff0ccccfff0cc222cc
-- 146:ccccc999cc2cc999c222c299f2c22299fcccc999fcccc999fcccc999c22cc999
-- 147:9900000099000000990000009000000090000000900000009000000099000000
-- 148:cc0dd0d9cc0dd9dccc0dd9dfcc0dd9dccc0dd9d9cc0dd0d0cc0dddddcc0ddddd
-- 149:00e444e000e040e000eeeee000e000e000eeeee000e000e000eeeee000e000e0
-- 150:00000000ccc00ccccfc00cfcccc00ccc01000010001111000011110001000010
-- 151:f000000fccc00ccccfc00cfcccc00ccc01000010001111000011110001000010
-- 152:cccccccccdccccccccdccccccccdcdccccccccdccdccccccccdccccccccdcdcc
-- 153:ddd00dddd0eeee0df0ee4e0fd134431de044440ed444444dd04cc40ddddddddd
-- 154:0000eee000006460aaaa444acccccccccccccccccccccccccccccccccccccccc
-- 155:c000000cc000000c0f6566f002f66f20066665600665665006cfcf6005fcfc60
-- 156:000000000000000000000000cccccccccccccccccccccccccccccccccccccccc
-- 157:0000000000200000000000020000000000000000010000010100000101101101
-- 158:0000000000000000000000200000000000000000000110000001000210010000
-- 159:0000000000eee000066566000465640006656600066566000099900000909000
-- 160:0000000900000999000009990000999900009999000099000000990000099900
-- 161:9cc2cccc9cc2cccc922ccccc9999999999999999099999990999999909909999
-- 162:c222c999c2c22999c2cc22999999999999999999999999999999909999000000
-- 163:9900000000000000990000009900000099000000990000009900000099000000
-- 164:0000f0000000f0000000f0000000f0000000f0000000f0000000f0000000f000
-- 165:0000000000eee000002420000044400009999900049994000099900000909000
-- 166:ddeeedd0d02420d0df444fd0f99999f0d49994d0d09990d0d09090d0ddddddd0
-- 167:dddddddddffffff7df7ff7ffdffffffcdf7f7fccdfffffccdfffffcbdf7f7fcc
-- 168:ddddddddffff7f7df7fffffdfffddffdcfddfdfdcfddddfdcffddffdcfffff7d
-- 169:55555555511aa775511aa7755acaaac55aaacaa5566aa335566aa33555555555
-- 170:0000000060000666060666565666566606566600650000000000000000000000
-- 171:0666666066666566666666666566666566666666066656600666666005666660
-- 172:0000000066600005566650606666665600656660000000660000000000000000
-- 173:0010110000101000201010000010110100100101001011010100110101000101
-- 174:1001100010001100100110001001000000010002000100000001000000011000
-- 175:0000000000eee0000aabaa0004aba4000aabaa000aabaa000099900000909000
-- 176:0009990000099000009990000099000009990000999099999900999999000990
-- 177:0990999009909990099099009990990099909999990099999900009900000099
-- 178:9900000099999000999999009999990000009990000099909000099990000999
-- 179:9990000099999000099999000009990000009990000099999000099990000000
-- 180:000d0000000d0000000d0000000d0000000d0000000d0000000d0000000d0000
-- 181:0000000f000000f000000f000000f000000f000000f000000f000000f0000000
-- 182:f00000000f00000000f00000000f00000000f00000000f00000000f00000000f
-- 183:dfffffccd7fff7ccdff7ffccd7ff7f33dfffff2fdf7ffff3dffff7ffdddddddd
-- 184:cf7f7ffdcffffffdcf7f7f7d3ffffffd2ff7f7fdff7ffffd7ffff7fddddddddd
-- 185:0000000000eeee0000ee4e000064460000444400022222200022220000200200
-- 186:0000000000eeee0000ee4e000064460000444400066666600055550000600600
-- 187:0666066606660566065606660665066506660666555506666555065655650565
-- 188:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 189:0010001020102010001000100010010001111e11011111110011e111001111e1
-- 190:11011000100100001201000210010000111e11101111111011e1e11011111100
-- 191:0000000000030000000030000003000000003000000300000003300000333300
-- 192:000d0000000d0000000d00000055500005555500d3dbd7d00ddddd0000000000
-- 193:0000000000000000aaaaaaaacccccccccccccccccccccccccccccccccccccccc
-- 194:000000000003f700aaaa777acccccccccccccccccccccccccccccccccccccccc
-- 195:00000ddd00000ddd00000ddd00000ddd00000ddd00000ddd00000ddd00000ddd
-- 196:ddd00000ddd00000ddd00000ddd00000ddd00000ddd00000ddd00000ddd00000
-- 197:0000000d000000d000000d000000d000000d000000d000000d000000d0000000
-- 198:000e000000e4e000004e40000004000000e4e000004e400000040000000e0000
-- 199:fffffffff1f5f222fffff2229fffffdfff77ffdfff77ffdfffffffffffffffff
-- 200:dddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
-- 201:dddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
-- 202:0dd22dd000cccc0000c0c0000000000000000000000c0c0000cccc000dd22dd0
-- 203:0dd77dd00055550000565500005665000056650000556500005555000dd77dd0
-- 204:032cc23032c22c232c2992c2c29ff92cc29ff92c2c2992c232c22c23032cc230
-- 205:0001ff112000ff11000001110000000000000000002000000000000000000000
-- 206:11ff100011ff0002111000000000000002000020000000002000200000000000
-- 207:0033330000033000000300000000300000030000000030000003000000000000
-- 208:01000010001111000011110001000010ccc00ccccfc00cfcccc00ccc00000000
-- 209:0000ccc01001cfc00110ccc001100000011000000110ccc01001cfc00000ccc0
-- 210:0ccc00000cfc10010ccc011000000110000001100ccc01100cfc10010ccc0000
-- 211:00000ddd00000ddd00000ddd00000ddd00000ddd00000ddd00000ddd00000ddd
-- 212:ddd00000ddd00000ddd00000ddd00000ddd00000ddd00000ddd00000ddd00000
-- 213:0000000000fff0000f141f000f444d000d8dd90004ddf900007dd00000d0d000
-- 214:dd000dd0d00000d0df000fd0f00000f0d00000d0d00000d0d00000d0ddddddd0
-- 215:dddddddddd1111ddd111111dd111119dd181111dd111111dd111119dd111111d
-- 216:0000000000eeee0000ee4e000064460000444400044444400044440000400400
-- 217:0000000000eeee0000ee4e00006446000044440004444440004cc40000400400
-- 218:0dd77dd00055550000566500005565000056550000556500005555000dd77dd0
-- 219:0dd77dd00055650000566500005555000056550000556500005655000dd77dd0
-- 220:0000000000000000300000003303030033303030300000000000000000000000
-- 221:0000000000000000000000030030303303030333000000030000000000000000
-- 222:0ccc000c0cfc000c0ccc00000000300300000332000003ccccc032c9cfc33c29
-- 223:fc000ccccc000cfc30000ccc33003000c23300002cc3000099c23cccf92c3cfc
-- 224:ffffffffffffffffffffddddfffffdddffdfffddffddfffdffdddfffffddddff
-- 225:ffffffffffffffffddddffffdddfffffddfffdffdfffddfffffdddffffddddff
-- 226:000000000dddd0000d000d000dddd0000d000d000d000d000dddd00000000000
-- 227:00000000000dd00000ddd000000dd000000dd000000dd00000dddd0000000000
-- 228:00000000000000000dddd0000000dd0000ddd0000dd000000ddddd0000000000
-- 229:000000000ddddd000000dd00000dd0000d00dd0000ddd0000000000000000000
-- 230:0000000000000000000dd00000ddd0000dd0d0000ddddd000000d00000000000
-- 231:0000000000ddddd000dd000000dddd0000000dd000dddd000000000000000000
-- 232:0000000000000000000ddd0000dd000000dddd0000dd00d0000ddd0000000000
-- 233:000000000ddddd000000dd00000dd00000dd00000dd000000000000000000000
-- 234:0000000000dddd0000d00d0000dddd0000d00d0000d00d0000d00d0000000000
-- 235:dd0000000d0000d0ddd00d000000d000000d0ddd00d000d00d000ddd00000000
-- 236:000000000000000000dddd000000dd00000dd00000000000000dd00000000000
-- 237:ddd00000dd0000d0d0000d00ddd0d000000d000000d00ddd0d0000d0000000dd
-- 238:ccc032c9000003cc00000332000030030ccc00000cfc000c0ccc000c0000000c
-- 239:99c23ccc2cc30000c23300003300300030000ccccc000cfcfc000ccccc000000
-- 240:ffddddffffdddfffffddfffdffdfffddfffffdddffffddddffffffffffffffff
-- 241:ffddddfffffdddffdfffddffddfffdffdddfffffddddffffffffffffffffffff
-- 242:0000000000c0c00000c0c00000fcf00000c4c00000ccc00000cccc0000c0c000
-- 243:0000000000000000ddddddddcbbbbb7ccdb3b5bccddbb6bcc442444cdddddddd
-- 244:ddddddddabb22babbbb22bbbba7227bb3b2222b323b22b3242244224dddddddd
-- 245:0000dddd0000cbba0000cabb0000cdbd0000cddd0000cdfd0000c4440000dddd
-- 246:dddd0000bbbc0000b5bc0000b6bc0000bb5c0000b6bc0000444c0000dddd0000
-- 247:0000000000000000000565000006060000000500000006004065650004565600
-- 248:00000000000000000e444e000e646e00044344000044400000444e0000404000
-- 249:000000000f000f000fffff000f7f7f000ffdff0000fff00000ffff0000f0f000
-- 250:0000000000000000000000000000000000000000e00000000eeeeeee00e0e0e0
-- 251:0000000010f0f010110f0110111f1110111f1110111f1110110f011000000000
-- 252:0000000020f0f020220f0220222f2220222f2220222f2220220f022000000000
-- 253:00000000a0f0f0a0aa0f0aa0aaafaaa0aaafaaa0aaafaaa0aa0f0aa000000000
-- 254:d0d9ddccd9d9ddccd9d0ddccd9d0ddccd9d9ddccd0d0ddccddddddccddddddcc
-- 255:d00000000d00000000d00000000d00000000d00000000d00000000d00000000d
-- </TILES2>

-- <TILES3>
-- 001:cccccccccccccccccdccccccccdccdccccccdccccccccccccdccccccccdccccc
-- 002:0000000000d4d00000a4a000004440000cf2fc0004fcf40000fff00000e0e000
-- 003:0000000000eee00000646000004440000c9c9c000499a4000099900000909000
-- 004:66666666e6666e666ee6eee666eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 005:44444444eeeeeeee44444444eeeeeeee44444444eeeeeeee44444444eeeeeeee
-- 006:e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4
-- 007:04e000000e40000004e000000e40000004e000000e40000004e000000e400000
-- 008:000004e000000e40000004e000000e40000004e000000e40000004e000000e40
-- 009:0000004000000e4e000004e40000004000000e4e000004e400000040000000e0
-- 010:0000000000000000001b3000006c500000782000000c0000000c0000000c0000
-- 011:00000000000000000000000000000000000000000000000d04e44e4fe000000d
-- 012:cccccccccc2222ccc002200cc000000cc000000cc000000cc000000ccccccccc
-- 013:0000000060666606060660600660066006600660060660606066660600000000
-- 014:00000cd000000dc000000cd000000dc000000cd000000dc000000cd000000dc0
-- 015:ffffffff000000000d0000c0deeeeecc0d0000c000000000ffffffff00000000
-- 016:4e4444447e7e77e744444444ee77777744444ee4777e7777ee44444e777777e7
-- 017:0000000000eee00000646000004440000ff5ff0004f5f4000099900000909000
-- 019:cccccccccc2222ccc2c22c2cc22cc22cc22cc22cc2c22c2ccc2222cccccccccc
-- 020:00000000000cee0000c6c600000c440000c9c9c0004a99400009990000090900
-- 021:3333333322222222333333332222222233333333222222223333333322222222
-- 022:2323232323232323232323232323232323232323232323232323232323232323
-- 023:0eee00003efe00000eeeee00eeeeeee0eeeeeeee0eeeeeee00eeeeee00030030
-- 024:0ccc00003cfc00000ccccc00ccccccc0cccccccc0ccccccc00cccccc00030030
-- 025:0777000037f70000077777007777777077777777077777770077777700030030
-- 026:0000000000000000000000000000000000777000037f70000077770000303000
-- 027:0000000000000000000000000000000000ccc00003cfc00000cccc0000303000
-- 028:0000000000000000000000000000000000eee00003efe00000eeee0000303000
-- 029:00077000007777000777cc7007777c7007777770077777700777777000777700
-- 030:000ee00000eeee000eeeeee00eeeeee00eeeeee00eeeeee00eeeeee000eeee00
-- 031:000dd00000ddcc000ddcccc00dccccc00dccccc00dccccc00ddcccc000dddc00
-- 032:0000000000000000000000000000000000000000000eeeee000e2376000e2376
-- 033:0000000000000000000000000000000000000000eeeee000914ee000914ee000
-- 034:eeeeeeeee237691ee237691eeeeeeeeeef89abceef89abceeeeeeeeee000000e
-- 035:0004000000eee00000646000004440000eeeee000499a40000eee00000949000
-- 036:0000000000eeee0000ee4e0000644600004444000c2cc2c00022220000200200
-- 037:0000000000eeee0000ee4e000a6446a00a4444a00c2cc2c00022220000200200
-- 038:ffffffff000000000c0000d0cceeeeed0c0000d000000000ffffffff00000000
-- 039:0000000000eee0000a646a00044444000c9c9c000099a0000099900000909000
-- 040:0000f00000333000002320003033303003333300337773300033300003330000
-- 041:0999000039f90000099999009999999099999999099999990099999900030030
-- 042:0fff00003f2f00000fffff00fffffff0ffffffff0fffffff00ffffff00030030
-- 043:0000000000000000000000000000000000fff00003f2f00000ffff0000303000
-- 044:0222000073f300000777770066666660aaaaaaaa099999990011111100070070
-- 045:0002f00000ffff000ffff2f00f2ffff00ffffff00ff2f2f002fffff000ff2f00
-- 046:0000000007ee00000eee000007ee000044444440eeeeeee0eeeeeee0e000000e
-- 047:0000000000000000000000000000000000237000075f600000a9810000707000
-- 048:000eeeee000ef89a000ef89a000eeeee000eeee7000eeeee000ee000000ee000
-- 049:eeeee000bdcee000bdcee000eeeee0007eeee000eeeee000000ee000000ee000
-- 050:000d000000d00000000d000000d00000000d000000d00000000d000000d00000
-- 051:000dd00000dddd000dddddd00077770000777700000000000000000000000000
-- 052:0000000f000000f000000f000000f000000f000000f000000f000000f0000000
-- 053:f00000000f00000000f00000000f00000000f00000000f00000000f00000000f
-- 054:0000000000eeee0000ee4e0001a44a10e044440e071771700011110000111100
-- 055:0000000000eeee0000ee4e0001ffff10e044440e0f1771f0f011110ff011110f
-- 056:0000f00000aaa00000faf000a0aaa0a00aaaaa000033300000aaa000000aaa00
-- 057:0000000000000000000000000000000000999000039f90000099990000303000
-- 058:0002300000237500023756a003756a900756a980056a981006a981f000981f00
-- 059:cccccccccbbbbbbccbbcbbbccbbbcbbccbbbbbbccbcbbbbccbbbbbbccccccccc
-- 060:004eee4000400040004eee4000400040004eee4000400040004eee4000400040
-- 061:3222222232f222223f2f2ff23222122232217122322212223222522236666666
-- 062:000000000abbbbb007bb5bb00abb5bb00ab575b007bb5bb00abbbbb000000000
-- 063:0000000000000000000000000000000000000000003030000077770066666666
-- 064:0000000000000000000000000000000000000066000006660000666600066666
-- 065:0000000000000000006666006666622666666226622666666226666666666666
-- 066:0000000000000000006666006666666666662266666622662266666622666666
-- 067:0000000000000000000000000000000066000000666000006666000066666000
-- 068:0000000007eeee70e7eeee7ee7eeee7e77777777e7e77e7ee7eeee7ee7eeee7e
-- 069:00000000000000000eeeee00eeeeee00eeeeeee0eeeee777eeeee7770eeeeee7
-- 070:eeeeee000eeee00002222000eeeeee00eeeeee00eeeeee00eeeeee000eeee000
-- 071:00eeee0000ee4e0001a44a10e044440e071771700d1111d00300003000333300
-- 072:00000000000000000300000030000000f0fffff0ffff3f0f00f3fff00fffff00
-- 073:00000000000000000a000000a0000000707777707777a707007a777007777700
-- 074:00000000000000000d000e000d0ee0000d0ee0000feeee0e0004ee0e00eeeee0
-- 075:00000000000000000f000d000f0dd0000f0dd0000edddd0d000cdd0d00ddddd0
-- 076:00000000000000000d000e000d0ee0000d0ee00006eeee0e0004ee0e00eeeee0
-- 077:00000000000700700011111109999999aaaaaaaa666666600777770066666666
-- 078:0000000000030030007777770777777777777777777777700777770066666666
-- 079:00000000000000000000000000000000000000000070700000a9810066666666
-- 080:0006666600666666066662226666622266666222666666666666666666666666
-- 081:6666666666666666666666666666666666666222666662226666622266666666
-- 082:6666622266666222666662226666666666666666666666666666666666222666
-- 083:6666666666666666666666666666666666666660222666662226666622266666
-- 084:0000066600066666006666660066666606666666066666660666666666666666
-- 085:6666666666666666ee666666ee666666666666666666666666ee666666ee6666
-- 086:666666666ee666666ee66666666666666ee666666ee6666e6666666e66666666
-- 087:666ee666666ee666666666666666666666666666e6666666e666666666666666
-- 088:6666ee666666ee66666666666666666666666666ee666666ee666ee666666ee6
-- 089:666666666666666666666666ee666666ee6666666666ee666666ee666666666e
-- 090:6666600066666000ee666600ee66666066666666666666ee666666eee6666666
-- 091:0c0c000000e0000000e0000000d0dd0000ede0d000e2eee0002e2ee000eee00e
-- 092:eeeeeeeeccccccccc2ccc222c222c2c2c2c2c222cccccccc222c2c2c2c2c2c22
-- 093:eeeeeeeecccccccccc222ccccc2c2ccccc22cc22cc2c2ccc2c222cccccccccc2
-- 094:000000000000000000d000f0000dd0f0000dd0f0d0dddde0d0ddc0000ddddd00
-- 095:000000000000000000d000f0000dd0f0000dd0f0d0dddda0d0ddc0000ddddd00
-- 096:6666666666622266666222666662226666666666666666666666666606666666
-- 097:66666666666666666666666666666666666ee666eeeeeeeeeeeeeeeeeeeeeeee
-- 098:66222666662226666666666666666666eeee6666eeee0666eeee0666eeee0666
-- 099:6666666066666660666666606666666066666000666000006000000000000000
-- 100:66666666666666ee666666ee66666666666ee666666ee6666666666666666666
-- 101:66666666666666666666666666666ee666666ee6666666666666666666666666
-- 102:666666666666666666ee666666ee66666666666666666666666666ee666666ee
-- 103:66666666666ee666666ee66666666666666666666666666666ee666666ee6666
-- 104:66666666666666666666666666ee666666ee6666666666666666666666666666
-- 105:6666666e666666666ee666666ee666666666666666666666666ee666666ee666
-- 106:e666666666666666666666eeee6666eeee666666666666666666666666666666
-- 107:6660000066600000666000006660000066600000666000006660000066000000
-- 108:222cc2ccccccc2c2cccccccccccccccc22222cc22cc2c2c22cc2ccc22222ccc2
-- 109:2cccccc2ccccccccccccccc2cccccc2ccccccc22cccccc22ccc222cc22c2c2cc
-- 110:000000000000000000d00000000dd0e0000dd00ed0dddd0ed0ddc0e00ddddd00
-- 111:44eeeee44eeeeeee6deeeeee4eeee77e6eeee77e4eeeeeee6deeeeee4eeeeeee
-- 112:066666660066666600006666000006660000000e0000000e0000000e000000ee
-- 113:eeeeeeee6eeeeeee6eeeeeee6eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 114:eeee0000eeeee000eeeee000eeee0000eeee0000eeeee000eeeee000eeeeee00
-- 115:000000000033320003a4a3200344430002222200042224000322230003222300
-- 116:66666666666666ee666666ee6666666606666666066666660666666600666666
-- 117:666ee666666ee66666666666666666666666666666666ee666666ee6ee666666
-- 118:6ee666666ee66666666666666666666666666666666666ee666666ee66666666
-- 119:6ee666666ee666666666666e6666666e6666666666666666666666666666ee66
-- 120:6666ee666666ee66e6666666e66666666ee666666ee666666666666666666666
-- 121:6666666666666666666666eeee6666eeee66666666666666666666666ee66666
-- 122:6666ee666666ee6666666666666666666666666666666666ee666666ee666666
-- 123:0000000000fff1000fa4af000f444f0007171700041124000f111f0000101000
-- 124:0000000000000000000000000000000000d0deff00d2ddd0002d2dd000ddd00d
-- 125:0000000000000000000000000000000000e0efdd00e2eee0002e2ee000eee00e
-- 126:0000000b0b000000000b0b000000000bb0000000000b0b00000000000b0000b0
-- 127:0004000003030300033333000373730003777300deeeeed0ddddddd000000000
-- 128:000000ee0000000e000000ee000000ee0000eeee0000eeee00000eee00000eee
-- 129:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 130:eeeeeee0eeeeeee0eeeeeee0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 131:000000000000000000000000e0000000ee000000ee000000ee000000ee000000
-- 132:0006666600066666000066660000066600000066000000000000000000000000
-- 133:ee666666666666666666ee666666ee6666666666000000000000000000000000
-- 134:ee666666ee666666666666666666666666666600000000ee000000ee0000000e
-- 135:6666ee66666666666666666666666666eeeeee66eeeeeeeeeeeeeeeeeeeeeeee
-- 136:666666666666ee666666ee666666666666666666e6666666eeeeeeeeeeeeeeee
-- 137:6ee666666666666666666666666666666666660066600000e0000000e0000000
-- 138:66666600666ee600666ee6006666660066666600000000000000000000000000
-- 139:000000000000000000000e000d0ee000d00ee000d0eeee0e0d04ee0e00eeeee0
-- 140:eeeeeeeeeeeeeeeeee000000ee000000ee000000ee000000ee000000ee000000
-- 141:eeeeeeeeeeeeeeee000000ee000000ee000000ee000000ee000000ee0000000e
-- 142:00000000000000000077700000a4a000004440000999994004bbb000000bbb00
-- 143:0000000000eeee0000ee4e0001a44a10e044440e071771700011110000022220
-- 144:00000000000000000000000000000000000ddddd000ddddd000dd55d000dd55d
-- 145:00000000000000000000000000000000ddd00000ddd00000d5500000d5500000
-- 146:0000000000000000000ddd000dd000ddd0d777d0d0d777d00dd777d000ddddd0
-- 147:000000000022200000343000004440000ff3ff0004f3f4000022200000202000
-- 148:0000000000000000000000000000000000000000000666000099ff6f0999ffff
-- 149:000000000999a9990999a9f90999af9f0999a9990999a9990999a99900000000
-- 150:0000000e0000000e0000000e0000000e0000000e0000000e000000ee000000ee
-- 151:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 152:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 153:e0000000e0000000e0000000e000000000000000e0000000ee000000ee000000
-- 154:000000000077700007646700074447007c1c1c7004c1c40000ccc00000ccc000
-- 155:ffffffffffffffffff3ffffffff3fffffffffffffffff3ffffff3fffffffffff
-- 156:00000b000b000000000b000b000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 157:b0b000b0000000000000b00b00000000bbbbbcc0bbbbbbcbbbbbbbbbbbbbbbbb
-- 158:0000000000000000000000000000000000000000000000000000000000005070
-- 159:00dd00000d0000000ddd00d00ddddd000dcddd000d0d000000e00e00000ee000
-- 160:000ddddd000dd222000ddd22000ddddd0dd00ddd0dd00ddd000dd000000dd000
-- 161:ddd000002220000022ddd000ddddd000d0000000d00000000dd000000dd00000
-- 162:000000000000000000000000000000000000000004e00e40de4004ed0dddddd0
-- 163:00000600000060000006550000655c50065f5fc506555555065fff5506555555
-- 164:00000100000060000006550000655c50065f5fc506555555065fff5506555555
-- 165:cccccccccccccccc000000000000000000000000000000000000000000000000
-- 166:000000ee000000ee000000ee00000eee00000eee00000eee0000eeee0000eeee
-- 167:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 168:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 169:ee000000eee00000eee00000eeee0000eeeee000eeeeee00eeeeeee0eeeeeee0
-- 170:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 171:0000000000000000000000000000000000000000deeeeed0ddddddd000000000
-- 172:bbbbbbbb0bbbbbbb00bbbbbbb00bbbbb0000bbbbb0b00bbb000000bb0b00b00b
-- 173:bbbbbbbbbbbbbbb0bbbbbb00bbbbb0b0bbbb0000bbb00000bb000b0bb00b0000
-- 174:00007c7c000077770033ccff0033ccff0000cccc0000cccc0000330000003300
-- 175:7c00000077000000cc000000cc000000cccc0000cccc00003300000033000000
-- 176:000000000000fff00000f9f300fffff00ffff0000ffff3000fff000030030000
-- 177:0000000000000000000000000000000000000000fffffff0fffffaf33f3ffff0
-- 178:0f00c00f0f0ccc0f0f00e00f0f00e00f0f00e00f0f00e00f0f0ded0f0f00d00f
-- 179:000000000000fff0000f2f2f00ffffff0f0f2f2f000ff2ff000f0f0f00000000
-- 180:0000eee0000eeeee000f2f2fee0fffffe0ef2f2fee0ff2ff000f0f0f00000000
-- 181:6666666666666666666666666666666666666666666666666666666666666666
-- 182:0000eeee0000eeee0000eeee000eeeee000eeeee000eeeee00eeeeee00eeeeee
-- 183:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 184:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 185:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 186:e0000000e0000000e0000000e0000000ee000000ee000000ee000000eee00000
-- 187:0000000000000000000000000000ee0000ded0e000d2ddd0002d2dd000ddd00d
-- 188:000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc
-- 189:dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00
-- 190:000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc
-- 191:dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00
-- 192:000000000000000000000000000000000a3300000a136670d111677d0dddddd0
-- 193:0000000000000000000000ee000000ee00000000000000000000000000000000
-- 194:00000000000000000000000000000000ee00ee00ee00ee0000dd000000ddd000
-- 195:cccccccccccccccccc000000cc000000cc000000cc000000cc000000cc000000
-- 196:cccccccccccccccc000000cc000000cc000000cc000000cc000000cc000000cc
-- 197:00000000000000000000000e00000eee00eeeeee00eeeeee00eeeeee00eeeeee
-- 198:0eeeeeee0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 199:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 200:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 201:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 202:eeeee000eeeee000eeeee000eeeee000eeeeee00eeeeeee0eeeeeee0eeeeeee0
-- 203:747474e4747474e474e4e47474e47474e474e4e474e47474747474e4747e74e4
-- 204:000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc
-- 205:dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00
-- 206:000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc0ddddddd0ccccccc
-- 207:dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00ddddddddcccccccc
-- 208:ccccccccc237691cc237691ccccccccccf89abeccf89abecccccccccc000000c
-- 209:0600f000006ffe00f0ff4fef0f9449f00f4444fff464464f0066660000400400
-- 210:ee0ddd00ee00ddd700007dd70007777700777777077777770777777777777777
-- 211:0777777777777777777777777777777777777777773337777332237773232377
-- 212:7770000077770000777700007777700077777700777777707777777077777777
-- 213:00b07000007c7c7c0077777733ccffcc33ccffcc00cccccc00cccccccccccccc
-- 214:0000000000000000000000000000000000000000cccc0000cccc0000cccccc00
-- 215:00000000000000000000000cc000000cc000001cc888811cccccccccc000000c
-- 216:00000000000000000000000cc000000cc000003cc222233cccccccccc000000c
-- 217:0000000000000000000000000000dd0000ede0d000e2eee0002e2ee000eee00e
-- 218:6000000066000000666000006666000066666000666666006666666066666666
-- 219:0000000600000066000006660000666600066666006666660666666666666666
-- 220:0ccccccc0ddddddd000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc
-- 221:ccccccccdddddddddcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00
-- 222:46464646dddddddddfddddddddfddfdfdfddfdfdfddddddddddddddd46464646
-- 223:00000000000000000000000040000000400000044eeeeee44444444440000004
-- 224:000d0000000d00000025600002a506002a050060a00000000000000000000000
-- 225:0000000000000007000000070000000700000077000007770000077700007777
-- 226:7777777777777777777722277777222777772227777777777777777777777777
-- 227:7322337777333777777777777777777777777777777777777777777777777777
-- 228:77777777aaa77777aaa77777aaa7777777777777777777777777777777777777
-- 229:cccccccccccccccccccccccc00cccccc00cccccc0000cccc0000cccc00003300
-- 230:cccccc00cccccccccccccccccccccccccccccccccccccccccccccccc00330000
-- 231:0000000000000000000000070000007700000777000077770000777700077bb7
-- 232:0770000007700000777770001177770011777770777777777777777777722777
-- 233:02200000222200000cc000000cc00000ddddddd0ccccccc0ccccccc0c00000c0
-- 234:0000000000000000000000000000000000000000000000000000022200002223
-- 235:0000000000000000000000000000000000000000000000003330000033330000
-- 236:000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc000cdcdc
-- 237:dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00dcdcdc00
-- 238:0000000000000000000000000000000000f00000cc070000d2d07000ccc2c300
-- 239:000000000000000000000000000000000000000000000000099a99009ccccc90
-- 240:4464464444644644666666664464464444644644666666664464464444644644
-- 241:0000777700077777000777770077777707777777077777770777777707777777
-- 242:77777777777bbb77777bbb77777bbb7777777777777777777777777777777777
-- 243:7777777777777777777777777777776677777766777777667777777777777777
-- 244:7777777777777777777777776777777767777777677777777777777777777777
-- 245:00000000000000000000000cc000000cc00000dccffffddcccccccccc000000c
-- 246:0000f00c003330e000232d003033303003333300337773300033300003330000
-- 247:00077bb700777777007777770077777707777777077755777777557777777777
-- 248:7772277777777777777777773377777733777777777777777777777777777777
-- 249:000d000000010000001010000100010001111100011711000111110000000000
-- 250:000223330022323302223f2302233ff302233333022233ff002223ff00022233
-- 251:3cc330003c23330032fcc3303ffcc33033333330ff333330ff33330033333000
-- 252:000d000000020000002020000200020002222200022722000222220000000000
-- 253:00000000006fffe0f0f54e0f0f8448f0f044440f048448400088880000488400
-- 254:eeeeeeeeeeeeeeeeee000000ee000000ee000000ee000000ee000000ee000000
-- 255:eeeeeeeeeeeeeeee000000ee000000ee000000ee000000ee000000ee000000ee
-- </TILES3>

-- <TILES4>
-- 001:0000eee0000eeeee000f2f2fee0fffffe0ef2f2fee0ff2ff000f0f0f00000000
-- </TILES4>

-- <TILES5>
-- 001:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 002:0000000000000000000000000000000000000000fffffff0fffffaf33f3ffff0
-- 003:000000000000fff00000f9f300fffff00ffff0000ffff3000fff000030030000
-- 004:00000000000000000000000000000000000000000fffff000fff8f3003f3ff00
-- 005:0666666066556556566565665565666666665656656565566566655665566656
-- 017:6666666666666666e6e66e6ee6e6ee6ee6eeeee6eeeeeeeeeeeeeeeeeeeeeeee
-- </TILES5>

-- <TILES6>
-- 001:0000000000eee00000646000004440000ee4ee0004eee40000fff00000f0f000
-- 002:0000000006666000066660000666666006666660000666660006666600000666
-- 003:0066660000666600006666000066666600066666666666666666666666666666
-- 004:6666000066660000666600666666006666660066666666666666666666666666
-- 005:0000666600666666666666666666666666666600666600006666000066660000
-- 006:0000600000060000000060000006000000006000000600000000600000060000
-- 007:666666666666666666ee6ee66ee66ee6eee6ee6eeeeeeeeeeeeeeeeeeeeeeeee
-- 008:fffffffffdfffdffdfffdfffffffffdfffdffffdfffdfffffdfffdffdfffffdf
-- 009:0fdfff000ffdff0000fff000000f000000000000000000000000000000000000
-- 010:00000000000000000000000000000000000f000000fff0000ffdff000fdfff00
-- 011:0000f0dd0fff0fdd000000000ffff0ddf0000fdd00000000ffff00dd0000ffdd
-- 012:6666566665666656000060000006000000006000000600000000600000060000
-- 013:66eeeeee65eeeeee66eeeeee66eeeeee56eeeeee66eeeeee65eeeeee66eeeeee
-- 014:cc070000cc70777000000000cc077770cc70000700000000cc007777cc770000
-- 015:000d0d00000fff00000fff00000fff00000f2f00000fff0000f000f000000000
-- 017:000000d000eee0d0006460d0004440d00ee4ee4004eee06000fff00000f0f000
-- 018:0000066600066666000666666666666666666666666606666666066600000666
-- 019:6666666666666666666666666666666666666666600eeeee600eeeee60044444
-- 020:6666666666666666666666666666666666666666eee06666eee0666644406666
-- 021:6600000066000000660000006666000066660000666600006666000000000000
-- 025:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 030:000000000000000000000000000ffff000f2ff000fff0ff00000000000000000
-- 033:0000000000eee0000ea4ae000e444e00e66466e0046654000066600000e0e000
-- 034:00000000003330000064600000444040062626000426200000fff00000f0f000
-- 035:00044444000eeeee0004444400044444000eeeee0004444400044444000eeeee
-- 036:44400000eee000004440000044400000eee000004440000044400000eee00000
-- 037:3337333373333323332333333333373337323337233323333233333233373333
-- 038:000000000000000000000000e0e0e0e0eeeeeeeeeee4ee4ee4ee4eeeeeeeee4e
-- 039:eeeeeeeeeee4eeeeeeeeee4eeeeeeeeeee4eeeeeeeeee4eee4eeeeeeeee4eeee
-- 042:dd0f0000ddf0fff000000000dd0ffff0ddf0000f00000000dd00ffffddff0000
-- 043:000070cc077707cc00000000077770cc700007cc00000000777700cc000077cc
-- 044:0000000000000000000000000ff00ff000ffff000002fff00000000000000000
-- 045:0000000000000000000000000ff00ff000ffff000fff20000000000000000000
-- 046:0000000000000000000000000ffff00000ff2f000ff0fff00000000000000000
-- 050:0cccccc0ccccccccccfccfcccfcfcccccccccccc0cccccc00c0ccc00c0000000
-- 051:0004444400044444000eeeee0004444400044444000eeeee0004444400044444
-- 052:4440000044400000eee000004440000044400000eee000004440000044400000
-- 054:000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 055:00000000000000000000000000000000bbbbbcc0bbbbbbcbbbbbbbbbbbbbbbbb
-- 056:00000000000000000000000000ee7ee707ee7ee707ee7ee707ee7ee707ee7ee7
-- 057:000000000000000000000000ee7e7e00ee7e7e70ee7e7e70ee7e7e70ee7e7e70
-- 058:00000000000000000000000000000000000000000000000000000000dddddddd
-- 059:0000000000000000000000000000000000000000000eeeee000e2376000e2376
-- 060:0000000000000000000000000000000000000000eeeee000914ee000914ee000
-- 061:e00e00000280000001d00000e00d00000000d00000000d00000000d00000000d
-- 064:0000000000000000000000000000000000022000007330000003330000007000
-- 065:0000000000000000000000000000000000022000000337000033300000070000
-- 066:0000000000000000000000000003322000273300022203300000000000000000
-- 067:0000000000000000000000000000000000ee00000044000004ee400000ff0000
-- 069:dd6dd0dddd0dd6dd66060066dd6dd0dddd6dd6dd66066066dd0dd6dddd6dd6dd
-- 070:bbbbbbbb0bbbbbbb00bbbbbb000bbbbb0000bbbb00000bbb000000bb0000000b
-- 071:bbbbbbbbbbbbbbb0bbbbbb00bbbbb000bbbb0000bbb00000bb000000b0000000
-- 072:07ee7ee7077727770727367907ee7e7707ee3ee707ee7ee707ee23e707e33233
-- 073:ee7e7e7073723770721737b07e7e2e70e37e7e70ee7e7e70ee7e3e70ee7e7e70
-- 074:44444444444e4444444444e44444444444e4444444444e444e444444444e4444
-- 075:000eeeee000ef89a000ef89a000eeeee000eeee7000eeeee000ee000000ee000
-- 076:eeeee000bdcee000bdcee000eeeee0007eeee000eeeee000000ee000000ee000
-- 077:0eeeee000e000e000eeeee000e000e000eeeee000e000e000eeeee000e000e00
-- 080:0000000000000000000000000220033000233300000732200000000000000000
-- 081:0000000000000000000000000330022000333200022370000000000000000000
-- 082:0000000000000000000000000223300000337200033022200000000000000000
-- 084:00f000f00f000f0000f000f00f000f0000f000f00f000f0000f000f00f000f00
-- 085:dd6dd6dddd6dd6dd66666666dd6dd6dddd6dd6dd66666666dd6dd6dddd6dd6dd
-- 087:00e7e7e707e7e7e70733e7e70733333307e3333307e3ff3307e3ff3307e33333
-- 088:e7e7e700e7e7e770e7e733703333337033333e703ff33e703ff33e7033333e70
-- 096:0000000000000000000000000000000000099000007aa000000aaa0000007000
-- 097:0000000000000000000000000000000000099000000aa70000aaa00000070000
-- 098:000000000000000000000000000aa9900097aa0009990aa00000000000000000
-- 100:000000000000000006000000600000600dd600000dd00006dd00dd00dd06dd60
-- 103:07e3333307e2277207222672072e2e77022e2ee722ee22e727ee722707ee7227
-- 104:33333220777277202212f2202272e2702e72e2222e72ee7222727e72e2727e70
-- 105:00000000000000000000000000000bbb00000bbb0000b000000bb00000bb0000
-- 106:0000000000000000bbbbbbb0bbbb0bbb0000000b0000000b0000000b00000000
-- 107:00000000000000000000000000000000bb000000bbb00000bbbb00000bbbb000
-- 109:cbcbcbcbcbeeebcbcbc4cbcb4b444b4bcee4eecbcbeeebcbcbfffbcbcbfbfbcb
-- 112:00000000000000000000000009900aa0009aaa000007a9900000000000000000
-- 113:0000000000000000000000000aa0099000aaa900099a70000000000000000000
-- 114:000000000000000000000000099aa00000aa79000aa099900000000000000000
-- 115:00044444000eeeee0004444400044444000eeeee00044fff0004feee000efee7
-- 116:44400000eee000004440000044400000eee0000044400000f4400000fee00000
-- 117:000000000000000000000000d000000000000000000000000000000000000000
-- 118:2333233336233363333332333fd233f22f332df33363632332ff32f323f33ff2
-- 121:00b0000000b0000000b0000000b0000000b0000000bb000000bb000000bb0000
-- 122:700700000280000001d00000700d00000000d00000000d00000000d00000000d
-- 123:00bbbbb0000bbbbb00000bbb000000bb000000bb0000000b0000000000000000
-- 124:0000000000000000b0000000bb000000bbb00000bbb00000bbb00000bbb00000
-- 125:cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
-- 126:00000000000000000033000000333333000333330003ff330003ff3300033333
-- 127:00000000000000000002230033322200333322003ff330003ff3300033333000
-- 128:0000000000000000000000000000000000011000007220000002220000007000
-- 129:0000000000000000000000000000000000011000000227000022200000070000
-- 130:0000000000000000000000000002211000172200011102200000000000000000
-- 131:0004feee0004ffff000eeeee0004444400044444000eeeee0004444400044444
-- 132:f4400000f4400000eee000004440000044400000eee000004440000044400000
-- 133:0000000000000000000000000000000000032000003233000033230000023000
-- 135:00000000000000000000000000000d0000ee0d000044060004ee470000ff0000
-- 137:0ddddd000ddddddd0ddddddddddddddddddddddddddddddddddddddddddddddd
-- 138:00000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 139:00000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 140:bbb00000bbd00000ddddd000ddddd000dddddd00dddddd00dddddd00dddddd00
-- 142:0003333300022002002220020020200002202000220022002000022000000220
-- 143:3333322000020020220202202202020020020222200200022202000202020000
-- 144:0000000000000000000000000110022000122200000721100000000000000000
-- 145:0000000000000000000000000220011000222100011270000000000000000000
-- 146:0000000000000000000000000112200000227100022011100000000000000000
-- 148:00000000000000000000000000000000ddddd000dddddd00ddddddd0dddddddd
-- 149:00000000000000000000000000000000000000000000000000000000dd000000
-- 150:00000000000000000000000000000000000000000000000000000000000000dd
-- 151:00000000000000000000000000000000000ddddd00dddddd0ddddddddddddddd
-- 153:0000000700005776066777550676777607672227766752267777727757772216
-- 154:7700000077577500657007502227667766527667711272666775276627712126
-- 160:0000000000000000000000000000000000066000007550000005550000007000
-- 161:0000000000000000000000000000000000066000000557000055500000070000
-- 162:0000000000000000000000000005566000675500066605500000000000000000
-- 164:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd00
-- 165:ddd00000ddddd000dddd0000ddd00000dd000000d00000000000000000000000
-- 166:00000ddd000ddddd0000dddd00000ddd000000dd0000000d0000000000000000
-- 167:dddddddddddddddddddddddddddddddddddddddddddddddddddddddd00dddddd
-- 169:6777266757727166277567162577527612777777022257760622212200699216
-- 170:6775271577752725627521267772571267577712777771126117777761166620
-- 172:00000000000000000bbbbb00bbbbbbb0bb7bbbb0b76dddb0bb7bbbb00ddddd00
-- 173:00000000000000000cbbbb00bbcb0cb0bb000bb0bc000cb0c0bbbbc00ddddd00
-- 176:0000000000000000000000000660055000655500000756600000000000000000
-- 177:0000000000000000000000000550066000555600066570000000000000000000
-- 178:0000000000000000000000000665500000557600055066600000000000000000
-- 179:0dddddd0ddddddddff6ff6ffff6ff6ff66666666ff6ff6ffff6ff6ff66666666
-- 181:0073330000332300002333000033370000323300007373000033330000233300
-- 188:000000000000000000000000000707000000600000070d00000000d00000000d
-- 190:00000000000000000033000000333333000333330003ff330003ff3300033333
-- 191:00000000000000000002230033322200333322003ff330003ff3300033333000
-- 192:00000000000000000000000000000000000dd000007cc000000ccc0000007000
-- 193:00000000000000000000000000000000000dd000000cc70000ccc00000070000
-- 194:000000000000000000000000000ccdd000d7cc000ddd0cc00000000000000000
-- 199:ff6ff6ffff6ff6ff66666666ff6ff6ffff6ff6ff66666666ff6ff6ffff6ff6ff
-- 202:dd6dd6dddd6dd6dd66666666ddfff6dddfeeefdd6fee7f66dfeeefdddfffffdd
-- 206:0003333300022002002220020020200002202000220022002000022000000220
-- 207:333332200002eee22202646222024420200222ee200422242202ff220202f0f0
-- 208:0000000000000000000000000dd00cc000dccc000007cdd00000000000000000
-- 209:0000000000000000000000000cc00dd000cccd000ddc70000000000000000000
-- 210:0000000000000000000000000ddcc00000cc7d000cc0ddd00000000000000000
-- 215:2232232222322322333333332232232222322322333333332232232222322322
-- 229:23eee222236463324d444d43dee4eed222eee22233fff23323f2f2322d333d32
-- 231:2232232222d22d223d3333d322322322223223223333333322d22d222d3223d2
-- </TILES6>

-- <TILES7>
-- 001:0000000000eeee0000ee4e000064460000444400022222200022220000200200
-- 008:00000000000777000076467000744470008c8c80004ccc40d0dfcc000d0d0f00
-- 009:00000000000000000000000000000000000000000fff00000fffd0d00fff0d0d
-- 010:000000000000000000000000000000000ddd00000dfddddd0dddfdfd0fff0f0f
-- 019:000000000000000000000000044444440444444404444444000eeeee00044444
-- 020:000000000000000000000000444444404444444044444440eeeee00044444000
-- 021:666666666666666666666666e66eee66ee66ee66ee66eee6eeeeeeeeeeeeeeee
-- 022:666666666666666666666666eeee66ee6eee66ee6ee666eeeee66eeeeeeeeeee
-- 023:4444444444444444eeeeeeeeeeeeeeee44444444eeeeeeeeeeeeeeee44444444
-- 024:4444444444444444eeeeeeeeeeeeeeee44444444eeeeeeeeeeeeeeee44444444
-- 025:ee4ee4eeee4ee4eeee4ee4eeee4ee4eeee4ee4eeee4ee4eeee4ee4eeee4ee4ee
-- 026:4ee4ee444ee4ee444ee4ee444ee4ee444ee4ee444ee4ee444ee4ee444ee4ee44
-- 027:444eeeee44eeeeee44eeeeee44eeeeee4477eeee4477eeee44eeeeee44eeeeee
-- 028:eeeeee44eeeeeee4eeeeeee4eeeeeee4eeeeeee4eeeeeee4eeeeeee4eeee77e4
-- 030:000000000000000000000000000000000000044000000440000eeeee000eeeee
-- 032:3333333333223333332233223333332233333333223333222233332233333333
-- 033:3333333333322333333223333333333333322333333223333333322333333223
-- 035:0004444400044ee40004eeee0004ee4e00044444000444440004444400044444
-- 036:444440004ee44000eee44000e444400044444000444440004444400044444000
-- 037:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 038:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 039:eeeeeeeeeeeeeeee44444444eeeeeeeeeeeeeeee44444444eeeeeeeeeeeeeeee
-- 040:eeeeeeeeeeeeeeee44444444eeeeeeeeeeeeeeee44444444eeeeeeeeeeeeeeee
-- 041:ee4ee4eeee4ee4eeee4ee4eeee4ee4eeee4ee4eeee4ee4eeee4ee4eeee4ee4ee
-- 042:4ee4ee444ee4ee444ee4ee444ee4ee444ee4ee444ee4ee444ee4ee444ee4ee44
-- 043:44eeeeee44eeeeee44eeeeee4477eeee4477eeee44eeeeee44eeeeee44eeeeee
-- 044:eeee77e4eeeeeee4eeeeeee4eeeeeee4eeeeeee4eeeeeee4eeeeeee4eeeeeee4
-- 045:00000000000000000000000e0000000e00000444000004440000eeee0000eeee
-- 046:0444444404444444eeeeeeeeeeeeeeee4444444444444444eeeeeeeeeeeeeeee
-- 048:3332233322322333223333333333332233333322223333332233333333333333
-- 049:3333333322333223223332233333333333333333333333333322333333223333
-- 051:eeeeeeeeeeeeeeeeee000000ee000000ee000000ee000000ee000000ee000000
-- 052:eeeeeeeeeeeeeeee000000000000000000000000000000000000000000000000
-- 053:eeeeeeeeeeeeeeee000000000000000000000000000000000000000000000000
-- 054:eeeeeeeeeeeeeeee000000000000000000000000000000000000000000000000
-- 055:eeeeeeeeeeeeeeee000000000000000000000000000000000000000000000000
-- 056:eeeeeeeeeeeeeeee000000ee000000ee000000ee000000ee000000ee000000ee
-- 058:0e1100000e1100000e1100000e1100000e1100000e1100000e1100000e110000
-- 067:ee000000ee000000ee000000ee000000ee000000ee000000ee000000ee000000
-- 072:000000ee000000ee000000ee000000ee000000ee000000ee000000ee000000ee
-- 074:0e1100000e1111110e1111110eeeeeee0ee000000ee000000ee000000ee00000
-- 075:000000001111110011111100eeeeee000000ee000000ee000000ee000000ee00
-- 076:1111111111111111eeeeeeeeeeeeeeeeee000000ee000000ee000000ee000000
-- 077:1111000011110000eeee0000eeee000000ee000000ee000000ee000000ee0000
-- 078:00007000000e4e0000ffffff00d0d0d0000d3d000fffffff0ffddddd0ffdcccc
-- 079:07000000e4e00000fffff000d0d0d0000d3d0000ffffff00dddfff00ccdfff00
-- 080:000000000000000000000000000eeeee000eeeee000eeeee0006664400066644
-- 081:000000000000000000000000eeee0000eeee0000eeee00004666000046660000
-- 082:000000000000000000000000000eeeee000eeeee000eeeee0006664400066644
-- 083:000000000000000000000000eeee0000eeee0000eeee00004666000046660000
-- 086:000000000000000000000000000000000000000000e4e00e7777777707777777
-- 087:00000000000000000000000000000000000000004e0e4e007777777077777700
-- 094:0ffddddd0fffffff0ffddddd0ffdcccc0ffddddd0fffffff0fffffff0fff0000
-- 095:dddfff00ffffff00dddfff00ccdfff00dddfff00ffffff00ffffff00000fff00
-- 096:0006664400044444000444440004444499999999999999999999999944499999
-- 097:4666000044440000444400004444000099999990999999909999999099994440
-- 098:0006664400044444000444440004444499999999999999999999999944499999
-- 099:4666000044440077444400774444000799999997999999979999999799994447
-- 100:0000000007700000777000007000000070000000700000007000000070000000
-- 104:000000000eeeeeee0eeeeeee0eeeeeee0eee00000eee00000eee00000eee0000
-- 105:00000000eeeeee00eeeeee00eeeeee00000eee00000eee00000eee00000eee00
-- 107:00eeeeee00eeeeee00ee000000ee000000eeeeee00eeeeee00ee000000ee0000
-- 108:eeeee000eeeee000000ee000000ee000eeeee000eeeee000000ee000000ee000
-- 112:4449999944499999000999990009999900099999000999000009990000099900
-- 113:9999444099994440999900009999000099990000099900000999000009990000
-- 114:4449999944499999000999990009999900099999000999000009990000099900
-- 115:9999444799994447999900009999000099990000099900000999000009990000
-- 116:7000000070000000000000000000000000000000000000000000000000000000
-- 117:000000000000000000000000000000000dd000000dd00000ddddddddd000000d
-- 118:000000000000000000000000000000000000000000000000ddddddddd000000d
-- 122:000011e0000011e0000011e0000011e0000011e0000011e0000011e0000011e0
-- 123:00eeeeee00eeeeee00ee000000ee000000eeeeee00eeeeee00ee000000ee0000
-- 124:eeeee000eeeee000000ee000000ee000eeeee000eeeee000000ee000000ee000
-- 125:000000000000000000000000000000000007000000e4e00e1c2c2c2c01c1c1c1
-- 126:00000000000000000000000000000000700070004e0e4e002c2c2c20c1c1c100
-- 128:00000000000000000000eeee0000eeee0000eeee0000eeee0000664400006644
-- 129:0000000000000000eeee0000eeee000044ee000044ee00004466000044660000
-- 130:00000000000000000000eeee0000eeee0000eeee7777eeee7777664407706644
-- 131:0000000000000000eeee0000eeee000044ee000044ee00004466000044660000
-- 137:00000000001111110011111100eeeeee00ee000000ee000000ee000000ee0000
-- 138:000011e0111111e0111111e0eeeeeee000000ee000000ee000000ee000000ee0
-- 144:0000444400004444002222220022222200002222000022220000220000002200
-- 145:4444000044440000222222002222220022220000222200000022000000220000
-- 146:0770444407704444772222227722222200002222000022220000220000002200
-- 147:4444000044440000222222002222220022220000222200000022000000220000
-- 149:000000dd000000dd0000dd000000dd00000000dd000000dd0000dd000000dd00
-- 157:000000000000000000000000000000000000000000e4e00edddddddd0ddddddd
-- 158:00000000000000000000000000000000000000004e0e4e00ddddddd0dddddd00
-- 165:000000dd000000dd0000dd000000dd00000000dd000000dd0000dd000000dd00
-- 173:fffdddddffddddddffddddddffddddddffe7ddddff7eddddffddddddffdddddd
-- 174:ddddddffdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfddddf7df
-- 176:0000000000000000000000000000000000000000ee000000ee000000ee000000
-- 177:00000000000000000000000000000000000000ee000000ee000000ee000000ee
-- 178:00000000ddddddddddd02020ddd02020ddd02020ddd02e2eddd02e2eddd02a24
-- 179:00000000dddddddd202020dd202020dd202020dd2e2020dd2e2020dd2a2020dd
-- 189:ffddddddffddddddffddddddffe7ddddff7eddddffddddddffddddddffdddddd
-- 190:dddf7edfddddffdfddddffdfdddddddfdddddddfdddddddfdddddddfdddddddf
-- 192:ee000000ee000000ee222222ee222222eeeee22eeeeee22eee000000ee000000
-- 193:0000ccee0000ccee22ccccee22cccceeeeeeeeeeeeeeeeee000000ee000000ee
-- 194:ddded424ddd01121ddd02121ddd02121dddddddddddddddddd000000dd000000
-- 195:242e20dd211020dd212020dd212020dddddddddddddddddd000000dd000000dd
-- 208:0000000000000000000000000000000000000000ee000000ee000000ee000000
-- 209:00000000000000000000000000000000000000ee000000ee000000ee000000ee
-- 224:ee000000ee000000ee666666ee666666eeeee66eeeeee66eee000000ee000000
-- 225:0000ccee0000ccee66ccccee66cccceeeeeeeeeeeeeeeeee000000ee000000ee
-- </TILES7>

-- <SPRITES>
-- 000:000000000000000000333300003349000334440000111100000110000010f000
-- 001:0000000000000000003333000033490003344400001111000001100000010f00
-- 002:000000000000000000333300003349000334440000111100000110000001f000
-- 003:0000000000000000003333000394493003444430011111100011110000100100
-- 004:0000000000000000003333000394493001444410001111000011110000100100
-- 005:000200000022200000222000004490000044430000999c0000994c0000202000
-- 006:000200000022200000222000004490000044430000999c0000499c0000022000
-- 016:000000000000000000cccc0000c3330000cc330000cccc00000cc00000c0d000
-- 017:000000000000000000cccc0000c3330000cc330000cccc00000cc000000c0d00
-- 018:000000000000000000cccc0000c3330000cc330000cccc00000cc000000cd000
-- 019:000000000000000000cccc000033330000c33c000cccccc000cccc0000c00c00
-- 020:000000000000000000cccc00003333000cc33cc000cccc0000cccc0000c00c00
-- 021:aaaaaaaaaaaaaaaaaeaaeaaaaaeeeefeaae44eeaaeeeeefeaaaaeaaaaaaaaaaa
-- 022:000000000000000000eeee0000ee49000ee4440000111100000110000010f000
-- 023:000000000000000000eeee0000ee49000ee44400001111000001100000010f00
-- 024:000000000000000000eeee0000ee49000ee4440000111100000110000001f000
-- 025:000000000000000000eeee000e9449e00e4444e0011111100011110000100100
-- 026:000000000000000000eeee000e9449e001444410001111000011110000100100
-- 032:0000000000000000000220000072270000222200307227032302203202200220
-- 033:0000000000000000000220000072270000222200007227003302203322200222
-- 034:0000000000022000007227000022220000222200307227032302203202200220
-- 035:00000000000000000022200000cfc00000ccc000033333002022202000303000
-- 036:00000000000000000022200000cfc00020ccc020033333000022200000333000
-- 037:0000000000000000002220000022200000cfc000033333002022202000303000
-- 048:0050005000055500055ccc55066cfc66006ccc60000505000000000000000000
-- 049:0050005000055500005ccc50005cfc50006ccc60006505600060006000000000
-- 050:0065656000656560006555600055655000555550000555000050005000000000
-- 051:0000000000000000060006000056500000666000099999000099900000909000
-- 052:0000000000000000060006000056500000666000099999000099900000999000
-- 053:0000000000000000000000000656560000666000099999000099900000909000
-- 064:0000000000000000000000000100010000ccc00000cfc00001ccc10000101000
-- 065:0000000000000000000000000010100000ccc00001cfc10000ccc00000111000
-- 066:00000000000000000000000001000100001110000011100001cfc10000101000
-- 067:000000000000000000000000010001000011100001c2c10000ccc00000101000
-- 068:000000000000000000000000001010000011100000c2c00001ccc10000111000
-- 069:00000000000000000000000001000100001110000111110000c2c00000101000
-- 080:000000000000000000000000ffff0000ffff0f2ffdff8ff3dffd8dffd00d00d0
-- 081:000000000000000000000000ffff0000ffff0f2ffdff8ff3fdfd8ddf0d00d000
-- 082:00000000000000000000000000000000ffff0000fdff0f2fdffd8df3dffd8fdf
-- 083:00000000800000808fffff800f888f000f323f00ff333ff00fffff000f000f00
-- 084:00000000800000808fffff800f888f000f323f00ff333ff00fffff0000fff000
-- 085:00000000800000808fffff800f888f000f888f00ff323ff00fffff000f000f00
-- 096:00b000b0000bbb000bbcccbb0aacfcaa00accca0000b0b000000000000000000
-- 097:00b000b0000bbb0000bcccb000bcfcb000accca000ab0ba000a000a000000000
-- 098:00ababa000ababa000abbba000bbabb000bbbbb0000bbb0000b000b000000000
-- 099:0000000000c00c0000cccc0000fbbf0000cbbc000cccccc000cbbc0000c00c00
-- 100:0000000000c00c0000cccc0000fbbf0000cbbc000cccccc000cbbc00000cc000
-- 101:0000000000c00c0000cccc0000fbbf000ccbbcc000cccc0000cbbc0000c00c00
-- 112:000d000000ddd00000fbf00000bbb0000abbba000abbba000ababa000bbabb00
-- 113:000d000000ddd000a0fbf0a0a0bbb0a00abbba0000bbb00000aba0000aabaa00
-- 114:000d000000ddd00000bbb00000bbb0000abbba000abbba000ababa000bbabb00
-- 115:00000000000000000cc0000dccccddddccccd000dddddddddfcfcfcd0dddddd0
-- 116:00000000000000000cc0000dccccddddccccd000dddddddddcfcfcfd0dddddd0
-- 117:00d000000ddd0000cbbf000dcbbbddddccccd000dddddddddfcfcfcd0dddddd0
-- </SPRITES>

-- <SPRITES2>
-- 000:0000000000eee000006460000044400049999940009990000099900000909000
-- 001:000000000000000000eeee0000ee4e0000a44a00004444000111111000111100
-- 002:000000000077700007646700074447000fcfcf0004fcf40000fff00000fff000
-- 016:0000000000eee0000064600000444000422222400022200000fff00000f0f000
-- 017:000000000000000000eee20000ee4e0000a44a00004444000333333000333300
-- 018:00000000007770000764670007444700088888000488840000fff00000f0f000
-- 033:000000000000000000eeee0000ee4e0000a44a000044440004444440004cc400
-- 048:0000000000000500000005000000500000505000000550000000000000000000
-- 049:0000000000000500000005000000500000505000000550000000000000000000
-- 050:0000000000000500000005000000500000505000000550000000000000000000
-- 051:0000000000000500000005000000500000505000000550000000000000000000
-- 052:0000000000000500000005000000500000505000000550000000000000000000
-- 053:0000000000000000002002000002200000022000002002000000000000000000
-- 054:0000000000000000002002000002200000022000002002000000000000000000
-- 055:0000000000000500000005000000500000505000000550000000000000000000
-- 056:0000000000000500000005000000500000505000000550000000000000000000
-- 057:0000000000000500000005000000500000505000000550000000000000000000
-- 058:0000000000000500000005000000500000505000000550000000000000000000
-- 059:0000000000000500000005000000500000505000000550000000000000000000
-- 060:0000000000000500000005000000500000505000000550000000000000000000
-- 061:0000000000000000002002000002200000022000002002000000000000000000
-- 062:0000000000000500000005000000500000505000000550000000000000000000
-- 063:0000000000000500000005000000500000505000000550000000000000000000
-- 064:000000000dddddd00d2227d00d3332d00d7233d00dddddd00ddddd0000000000
-- 065:000000000dddddd00d5656d00d6565d00db665d00dddddd00ddddd0000000000
-- 066:000000000dddddd00dfe4fd00d4ff4d00df4efd00dddddd00ddddd0000000000
-- 067:000000000dddddd00d1122d00d2ff2d00d2211d00dddddd00ddddd0000000000
-- 068:000000000dddddd00d7abad00dbbbbd00daba7d00dddddd00ddddd0000000000
-- 069:000000000dddddd00d5665d00d5335d00d5355d00dddddd00ddddd0000000000
-- 070:000000000dddddd00dff7fd00d7777d00dff7fd00dddddd00ddddd0000000000
-- 071:0000000000bbbb0000b77b0000b77b0000bbbb0000bffb0000bbbb0000000000
-- 072:0000000000aaaa00007673000037670000aaaa0000affa0000aaaa0000000000
-- 073:0000000000f2f200002f2f000023320000733200007722000077770000000000
-- 074:0000000000626200006626000066620000262600002266000022260000000000
-- 075:0000000000dccc0000dfcf0000dc3c0000dcc20000d22c0000dccc0000000000
-- 076:0000000000777700007667000076770000776700007667000077770000000000
-- 077:0000000000556500005655000056650000533500005535000055550000000000
-- 078:0000000000111100001ff1000011f10000121200001122000012220000000000
-- 079:0000000000ffff000077f700007f770000ffff0000f77f0000ffff0000000000
-- </SPRITES2>

-- <MAP>
-- 000:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101014d01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101013f3f0101013f3f3f3f0101013f010101010101013f010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101728292a201010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:01010101010101010101010101012c01010101010127010101010101010101010101010129010101010101010101010101010101010101010101010101010101010101010101012d0101010101010101010129010101010101013f01013f01013f01013f010101013f010101010101013f01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101012d0101010101010101290101013f013f013f013f01013f013f3f3f3f3f0101013f3f3f3f3f010101010101010101010101010101010101010101010101010101010101010101010101010101010101010114140101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:010101010101010101010101010101010101010101010101010101010101010101815681815681010156012f010101010101010101010101568101010101010127010101010101010101012b010101012d0101010101010101013f3f013f01013f3f3f3f010101013f010101010101013f01010101010101010101010101010101010101010101010101010101010101010101010101010101010101011455651401010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:0101010101010101012701012c0101010101010101010101010101010101505050505050505050505050500101010101010101010101505050505050500101010101010101010101010101010101010101010101018101010101013f3f3f0101560101010101013f010101010101013f0101010101010101505001010101010101010101010101010101010101010101010101010101010101010101011444441401010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:01010101010101010101010101010101010101010101018181810101b001510101010101010101010101510101010101010101010101510101010101510101010101010101010101010101010101010101012d01012901012901010101505050505050505001010101010101010101010101010101010101015050505050018181010156010101010101010101010101010101010101010101010101011444441401010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:01010101010101010101010101010101010101015050505050505050500151012b01010101010101010151010101018181815601010151010101010151010101010101010101012b012d01010101010101010101010101010101010101510101010101015150500101010101010101010101010156018101015101010150505050505050500101010101010101010101010101010101010101560101011444441401010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:010101010101012c01010101010101018101560151010101010101015101510101010101012f01010101510101505050505050500101510101010101510101015601810101010101010101010101b00101010181810101560101010101510101010101015151510101010101010101010150505050505001015101010101010101510101505050010181010101010101010101010101010150505001011444441401010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:01480148010101014a0101010150505050505001512c014a012b014c510151013c01014c0138014e01565101015101014e0101512701513c0101010151013c50505050505001012b01010101707070707050505050505050505050500151014f015f014f5151510156018181010101010151010101015101015101010101010101510101015150505050500181010101010101010101010101515050505050500101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:102010200101011020560146015110201020510151011020d4e41020510151291020d4e4d4e410201020510101510110201020511020511020d4e401511020511020102051010101010101707171717171708101011020102010205101511020d4e4102051515150505050505050011020511020102051102051d4e401d4e40101510110205101102051505050500181815601010150010101510101010101510101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:112111210101011121505050015111211121510151011121d5e51121510151011121d5e5d5e511211121512f01510111211121511121511121d5e501511121511121112151010101010170666666666666667081011121112111215101511121d5e5112151515151010101010151011121511121112151112151d5e501d5e50101510111215101112151010101515050505050505050010101510101010101510101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:1222132201010112220151012c5112221222510151011222122212225101510112221222122212221222510101510112221222511222511222122201511222511222122251010101017066666666666666667170811222122212225101511222122212225151515101010101015101122251122212225112225112220112220101510112225101122251010101510101510101010151010101510101010101510101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:122313238181801323565101015113231323511a51801323132313235101510113231323132313231323518001510113236823511323511323132301511323511323132351818181707166666666666666667171701323132313235101511323132313235151515181818181815101132351132313235113235113230113230101510113235101132351010101510101510101010151010101510101010101510101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707166666666666666667171717070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707067707070707070707070010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171716666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171716671717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 017:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 018:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 019:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101b00101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 020:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010130303030303030303030303030303030303030303030010101010101010101010101010101010101010101010101010101010101728292a20101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 021:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101013001010101010101010101010101010101010101010131010101010101010101010101010101010101010101010101010101010101015565010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 022:010101010101010101010101010101010101010101013001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101303101010101010101010101010101010101010101010131010101010101010101010101010101010101010101010101010101010101014444010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 023:0101010101010101010101303030303030303030010131010101300101010101010181818181818181010101010130010101010101010101010101b0010101010101010101010101010101010101010101010101010101010101010101303030300101010130013101010101010101010101010101010101010101010131010101010101010101010101010101303030303030300101010101010101014444010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 024:010101010101010101300131010101010101013101013130010131010101303030303030303030303030303030013101010130013030303030303030303030013001300130013001300130013001300130013001010101013030303030010101310101013031013101010101010101010101010101010101010101010131010101010101010130010101010101310101010101310101010101010101014444010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 025:010101010101010101310131010101010101013101013131010131010101310101010101010101010101010131013101010131013101010101010101010131013101310131013101310131013101310131013101013001010101310101010101310101010131013101010101010101010101010101010101010101010131010130300101010131010101013001310101010101310101013001013030303030303001010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 026:010101010101013001310131010101010101013101013131010131010101310101010101010101010101010131013101010131013101010101010101010131013101310131013101310131013101310131013101013101010101310101010101310101010131013101010101010101010101010101010101010101010131010131310101010131010101013101310101010101310101013101013101010101013101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 027:010101010130013101310131010101010101013101013131010131010101310101010101010101010101010131013101010131013101010101010101010131013101310131013101310131013101310131013101013101010101310101010101310101010131013101010101010101010101010101010101010101010131010131310101010131010101013101310101010101310101013101013101010101013101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 028:010101300131013101310131010101010101013101013131010131010101310101010101010101010101010131013101010131013101010101010101010131013101310131013101310131013101310131013101013101010101310101010101310101010131013101010101010101010101010101010101010101010131010131310101010131010101013101310101010101310101013101013101010101013101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 029:0101013101310131013101310101010101010131010131310101310101013101010101010101010101010101310131010101316031016060816060016060c281c281c281c281c281c281c281c281c281c281c201603101816001316001606001316081816031603101606001606001606001606001606001606001606031606031316081606031606081603101316001606001316081603101813181818181813101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 030:606001318131603181310131600160600160603160606161816031606081316001606001606001606001606031603101608131616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 031:616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626201010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 032:626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626201010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 033:626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626201010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 034:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 035:0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010150010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101728292a2010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 036:010101010101010101010101010101015001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101015101010150010101010101010101810101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101556501010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 037:010101010101010101010101010101015101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010150505050015101010151010101010101010101500101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101444401010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 038:010101010101010101010101015001015101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101b00101010101010101010151010151015001010151010101010101010101510101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101444401010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 039:010101010101010101010101015101015101010101505001010101010101010101010101010101010101010101010101010101010101010101010101010101500101010101010101010151010151015101010151010101500101015001510101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101500101010101010101444401010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 040:01010101010101010101010101500150510101010151510101010101010101010101010101b001010101010101500101010101010101010101010101010101510101010101010101010151010151015001010151010101510101015101510101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101510101010101010101444401010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 041:010101010101010101010101015101515101010101515101010101010101010101010101505050010101010101510101010101500101010101500101010101510101010101010101010151010151015101010151010101510101015101510150010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101500101510101010150505050505050505001010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 042:010101010101010101010101505101515101010101515101015001010101015001010101510151010101500101510101010101510101010101510101010101510150010101010101010151010151015101010151010101510101015101510151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101510101510101010151010101010101015101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 043:010101010101015050505050015101515101010101515101015101010101015101010101510151010101510101510101500101510101500101510101015001510151010101010101505050505050015101010151010101510101015101510151010150010101010101010101010101010101010101010101015001010101015001010101500101010150010101015001510101510101010151010101010101015101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 044:01010101010101510101015101510151510101010151510101510101015001510101010151015101010151010151010151010151010151010151010101510151015101010101010151010101015101510101015101010151010101510151015101015101010101010101b001010101010101010101010101015101010101015101010101510101010151015001015101510101510101010151010101010101015101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 045:010150505050015101010151015101515101010101515101015101010151015101010101510151010101510101510101510101510101510101510101015101510151010101010101510101010151015101010151010101510101015101510151010151010101500150015001500101500150015001500150015101010101015101500101510101500151015101015101515001510101010151010101010101015101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 046:010151010151015101010151015101515101010101515101015101010151015101010101510151010101510101510101510101510101510101510101015101510151010101010101510101010151015101010151010101510101015101510151010151010101510151015101510101510151015101510151015101015001015101510101510101510151015101015101515101510101010151010101010101015101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 047:010151320151815101320151015132515181328181515181325181813251815132818181513251328181518181518181518181518181513281518181815181518151818181328181518181328151815181813251818181518132815181518151328151328101b281b281b281b28181b232b281b281b232b281b28181b28132b281b28132b28181518151325181815181515181518181818151818181813281815101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 048:525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525201010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 049:535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535301010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 050:535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535353535301010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 051:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 052:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 053:0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101728292a2010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 054:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101556501010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 055:01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101b001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101444401010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 056:010101014240430101010101010101010101010101010101010101010101010101010101010101010101010101010101010142404301010101010101010101014240430101014240430101424043014240430101010101010101010101010101010101010101010142404301010101010101010142404301010101010101010101010101010101010101010101010101010101010101010101010101010101444401010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 057:0101010101b10101424043010101014240430101424043010101010101b0010142404301010101010101014240430101010101b101010101424043014240430101b10101010101b101010101b1010101b1010101010142404301424040404301424043424043010101b10101010101010101010101b10101014240430101010101424043010101010101010101010101010101010101010101010101010101444401010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 058:014240430141010101b1010101010101b101010101b10101010101014240430101b101010101014240430101b1010101010101410142404301b1010101b142404341010142404341424043014142404341010101010101b10101424091b1010101b10101b1010101014101014240430101424043014101010101b101010101010101b101010101010101010101010101010101014240430101010101010181444481010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 059:0101b10101410101014101014240430141010101014101010101010101b101010141014240430101b101010141010101424043410101b10101414240434101b10141010101b1014101b101014101b1014101014240430141010101b10141010101410101410101010141010101b101010101b101014101010101410101424043010141014240430101010101010142404301010101b1010101010101424040404040400100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 060:40434101014101010141010101b101014101424043410142404301010141014240410101b1010101414240434101010101b1014101014101014101b1014101410141010101410141014101014101410141010101b10101414043014101410101014101014101010101410101014101010101410101414240430141010101b1010101410101b1010101424043010101b1010101010141014240430101014191919191410100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 061:b1014101014101010141010101410101410101b101410101b101424043410101b1410101410101014101b1014101010101410141010141010141014101410141014101010141014101410101410141014101010141010141b1010141014101810141010141010101014142404341010101014101014101b1010141010101410101014101014142404301b101018101410101424043410101b1014240434101010101410100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 062:414240430141010101410101014101014101014101410101410101b101410101414101014101010141014101410101010141014101014101014101410141014101410101014101410141010141014101410101014101014141010141014142b14341010141010101014101b1014101010101410101410141010141010101410101014101014101b10101410142404341010101b101410101410101b1014101010101410100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 063:4101b1010141010101410101014101014101014101410101410101410141010141410101410101014101410141010101014101410101410101410141014101410141010101410141014101014101410141010101410101414101014101410141014101014101010101410141014101010101410101410141010141010101410101014101014101410101410101b10141010101410141010141010141014101010101410100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 064:419041909041818181418181814181814181814181418181418181418141818141418181418181814181418141818181814190419081418190418141904181419041908181419041814190904181418141818141418181414181814181419041814190814190818181418141904181818181418181418141908141908190419081904181814181419081418190418141908190418141818141818141814181818101410100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 065:a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a001410100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 066:a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a101410100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 067:a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a101410100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 068:020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 069:020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 070:020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 071:020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202630202630202630202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203030303030200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 072:020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202640202640202640202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203738393030200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 073:020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202026302640202640202640202020202020202020202020202020202020202020202020202020202020202980202029802020298020202980202020202020202020202020202020202020202020263020202020202020202020202020202020202020203a3b3c3030200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 074:020202020202020202020202020202020202020202020202020202630202020202020202020202020202020202020202020202020202020202020202026402640202640202640202630202020202020202029802020202029802029802029802029802029802020202020202020202020202020202020202020202020202020202020298020202980264020202020202630202020202026302020202020202028696030200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 075:020202020202020202020202020202020202020202026302020202640202020202020263020202020202020202020202020202020202020202020263026402640202640202640202640202020202a80202020202020202020202020202020202020202020202020298020202980202029802020202020202020202980202020202020202020202020264020202020202640202020202026402020202020263636363630200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 076:020202020202020202020202020202020202020202026402020202640202020202020264020202020263020202020263020202020202020202020264026402640202640202640202640202020202020202020202020202020202020202020202020202020202020202020202020202020202020202980202020202020202029802020202020202020264020202020202640202020202026402020202020264020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 077:0202020202026302020202026302020202020202020264020263026402630202630202640202020202640202020202640202020202630202026302640264026402026402026302026402a702020202020202020202a802020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020264020202630202640202020202026402020202020264020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 078:020202020202640202020202640202020202026302026402026402640264020264020264020263020264020263020264020202020264020202640264026402640202640202640202640202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202029802020202020202020202020202020264020202640202640202026302026402020202630264020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 079:020202026302640202630202640202630202026402026402026402640264020264020264020264020264020264020264020263020264026302640264026402640202640202640202640202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020264020202640202640202026402026402020202640264020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 080:026302026402640202640202640202640202026402026402026402640264020264020264020264020264020264020264020264020264026402640264026402640202640202640202640202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020264020202640202640202026402026402020202640264020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 081:026402026402640202640202640202640202026402026402026402640264020264020264020264020264020264020264020264020264026402640264026445d24545d24545d24545d202020202020202020202024545454545454545454545454502020202020202020202020245450202020202020202024545454545454545454545454545454545d2454545d24545d2454545d24545d245454545d245d2454545450200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 082:84848494a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4b48484848484848484848494a4a4a4a4a4a4a4a4a4b48484848484848484848484848484848494a4a4a4a4a4a4a4b48484a6b6b6b6b6b6b6b6c6848484848484848484848484848484848484848484848484848484848484848484848484848484848402020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 083:858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858502020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 084:858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858502020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 085:141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 086:141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 087:141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414d0141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414d3e3d3f300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 088:141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414761414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141455651400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 089:141414141414141414147614141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414771414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141444441400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 090:141414141414761414147714141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141476141414141414141414141414761414141414141476141414141414141414771414141414141414141414141414141414141414141414141414141414141414141414141414141414141476141414141414141414141414141414141444441400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 091:141414141414771414147714141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414761414141477141414141414141414141414771414141414141477141414141414761414761414141414141414761414141414141414141414141414141414141414141414141414141414141414141477141414147614141414761414141414141444441400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 092:141414141414771414147714141476141414147614761476147614761476141476147614761476147614761476147614147614761476147614761476141414771414141477141476141476141476147614771414141414141477141414141414771414771414147614141414771414141414147614141414141476141414141414141414141414141414141414141477141414147714141414771414141414141444441400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 093:141414141414771476147714141477141414147714771477147714771477141477147714771477147714771477147714147714771477147714771477141414771414761477141477141477141477147714771414147614141477141476141414771414771414147714761414771414761414147714141414141477141414141476141414141414141414141476141477141476147714147614771414761414147676761400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 094:141414141414771477147714141477141414147714771477147714771477141477147714771477147714771477147714147714771477147714771477147614771414771477141477141477141477147714771414147714141477141477141414771414761414147714771414771414771414147714147614141477141476141477141414141414141414141477141477141477147714147714771414771414147714141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 095:141414141476771477147714141477141414147714771477147714771477141477147714771477147714771477147714147714771477147714771477147714771414771477141477141477141477147714771414147714141477141477141414771414771414147714771414771414771414147714147714141477141477141477141476141414141414141477141477141477147714147714771414771414147714141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 096:141414141477771477147714141477141414147714771477147714771477141477147714771477147714771477147714147714771477147714771477147714771414771477141477141477141477147714771414147714141477141477141414771414771414147714771414771414771414147714147714141477141477141477141477141414141414141477141477141477147714147714771414771414147714141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 097:141476141477771477147714141477141414147714771477147714771477141477147714771477147714771477147714147714771477147714771477147714771414771477141477141477141477147714771414147714141477141477141414771414761414147714771414771414771414147714147714141477141477141477141477141414147614141477141477141477147714147714771414771414147714141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 098:1454f2b754f2f254f2b7f2b7b754f2b754b7b7f2b7f254f2b7f2b7f25477b754f2b777b7775477b777b777b777b777b7b777b777b777b777b777b777b777b777b75477b777b7b777b7b777b7b777b7775477b754b77754b7b777b7b777b7b75477b75477b754b7775477b7547754b777b754b77754b777b7b7547754b77754b77754b77754b7b75477b754b777b7547754b777b777b75477547754b777b754b777b7541400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 099:747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474741400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 100:757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575751400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 101:757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575751400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 102:242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 103:242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 104:242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 105:242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 106:242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242439242424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 107:242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242439242424242424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 108:242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424245565242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 109:242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242439242424242424392424242424392424242424243924242424242424242424244444242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 110:242424242424242424242424242424243939393939393939393939393939242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424372424392424243924242424242424392424242424392424242424242424242424243924242424242424244444242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 111:242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424152424242424242424242424242424242424242424242424242424242424242424242424242424242424244444242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 112:242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424372424242424242424242424242424242424242424242424242424373937242424372424372437242437242437242424242424242424242424242424372424152424242424242424242424242424242424242424242424242424242424242424242424392439242439244444242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 113:242424242424242424243724243724243724372437243724372437243724242424242424242424242424242424242424242424372424152424242424242424242424242424242424242424242424242424152415242424152424152415242415242415242424242439242424242424372424152424152424242424242424242424242424242424242424242424242424242424242424242424242424242424244444242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 114:242424242424243724241524241524241524152415241524152415241524243739393939393937242424242424242424243724152424152424242424243924242424242424243924242424242424372424152415242424152424152415242415242415243724242424242424243724152424152424152424242424242424242424242424242424242424242424242424242424242424242424242424242424244444242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 115:242424242424474947474947474947474947494749474947494749474947474947474747474749472424244747474747471524154747494724242447474747474724b52447474747472424243724152424152415242424152424152415242415242415241524474747474747241524494747494747492424474747474747474747474747474747474747474747474747474747474747474747474747474747474444474700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 116:252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525596969696969696969696969696969696969696969696969696979252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 117:585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 118:585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585858585800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <MAP2>
-- 000:200000000000000020200000000000202000000000000000002020000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000000000000000000000202000000000000000000000000000202000000000000000000000000000202000000000000000000000000000002020000000000000002020000000000020200000000000000000000020
-- 001:000000000000002020000000000020200000000000000000202000000000000000000000000000202000000000000020200000000000000000000000000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000000000000000000020200000000000000000000000000000202000000000000000202000000000002020000000000000000000002020
-- 002:000000000000202000000000002020000000000000000020200000000000000000000000000020200000000000002020000000000000000000000000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002020000000000000000000000000002020000000000000000000000000000020200000000000000020200000000000202000000000000000000000202000
-- 003:000000000020200000000000202000000000000000002020000000000000000000000000002020000000000000202000000000cecece000000000000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000000000000000000000202000000000000000000000000000202000000000000000000000000000202000000000000000000000000000002020000000000000002020000000000020200000000000000000000020200000
-- 004:000000002020000000000020200000000000000000202000000000000000000000000000202000000000000020200020202020202020202020100000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000000000000000000020200000000000000000000000000000202000000000000000202000000000002020000000000058000000002020000000
-- 005:000000202000000000002020000000000000000020200000000000000000000000000020200000000000002020001044000000000000000050100000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002020000000000000000000000000002020000000000000000000000000000020200000000000000020200000000000202020202020202020202020202000000000
-- 006:00002020000000000020200000000000000000202000000000000000000000000000202000000000000020200010004500580000006474005010000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020100000000000000000002020000000000000000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000000000000000000020200000000000000000000000000000202000000000000000202000000000b120200000000200009494949494949494949400
-- 007:00202000000000002020000000000000000020200000000000000000000000000020200000000000002020002020202020202020202020205010000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202037100000000000000000202000000000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002020000000000000000000000000002020000000000000000000000000000020200000000000000020200000000000b100000000000000949494949494949494949494
-- 008:202000000000002020000000000000000020200000000000000000000000000020200000000000002020001044000000540000000000000050100000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202037361000000000000000202000000000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002020000000000000000000000000002020000000000000000000000000000020200000000000000020200000000000202020202020202020202020202020202020202020
-- 009:0000000000002020000000000000000020200000000000000000000000000020200000000000002020000010450000005500000000647400501000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202037003610000000000000202000000000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002020000000000000000000000000002020000000000000000000000000000020200000000000000020200000000000202000000065d9e9f6000078b8203e20202020202010
-- 010:000000000020200000000000000000202000000000000000000000000000202000000000000020207600002020b120202020202020202020201000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200e1e373610000000000020200000000000000000000000000000202000000000000020200000000000000000000000202000000000000000000000000000202000000000000000000000000000202000000000000000000000000000002020000000000000002020000000000020200000000000daea1020202020202020202020202010
-- 011:00000000202000000000000000002020000000000000000000000000002020000000000000202000fb00001000b100000000202052005353001000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020370f1f373610000000002020000000000000000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000000000000000000020200000000000000000000000000000202000000000000000202000000000002020000000000000dbeb100000000000e100000000000010
-- 012:000000202000000000000000002020000000000000000000000000002020000000000000202038ddcccd381000b100b90000002020524363531000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202037000e1e370026000000202000000000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002020000000000000000000000000002020000000000000000000000000000020200000000000000020200000000000202000001000000000dcec1000000000000000000000000000
-- 013:00002020000000000000000020200000000000000000000000000020200000000000002020000000fc00001000b1aabaca000054202052006310000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202037b6c60f1f37002700202020000000000000000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000000000000000000020200000000000000000000000000000202000000000000000202000000000002020000000100000de0000001000000000000000000000000000
-- 014:002020000000000000000020200000000000000000000000000020200000000000002020ffff000076005c1000b100bb00680055002020525210000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020203700b7c70e1e37362020200000000000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002020000000000000000000000000002020000000000000000000000000000020200000000000000020200000000000202000000000102020202020201000000000000000000000000000
-- 015:2020000000000000000020200000000000000000000000000020200000000000002020ffffff0818285c5c102020200520202020202020202020000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020370000b4c40f1f37362020000000000000000000000000000000202000000000000020200000000000000000000000202000000000000000000000000000202000000000000000000000000000202000000000000000000000000000002020000000000000002020000000000020200000000000000000000000000000001370919191600000000000
-- 016:2020000000000000000020000000000000000000000000002020000000000000202000ffffff0919295c5c5cff007676001000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020202020202020202020202000000000000000000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000000000000000000020200000000000000000000000000000202000000000000000202000000000002020000000000000000000000000000000007120003300208100000020
-- 017:200000000000000000202000000000000000000000000020200000000000002020000000ffff0a1a2a3a5c5c00ff76765c1000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000760000100000000000000000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002020000000000000000000000000002020000000000000000000000000000020200000000000000020200000000000202000000000000000000000000000002020202020202020202020202020
-- 018:00000000000000002020000000000000000000000000202000000000000020200000000000ff0b1b2b3b5c0000007532001000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000760000100000000000000000000000000000000000202000000000000020200000000000000000000000202000000000000000000000000000202000000000000000000000000000202000000000000000000000000000002020000000000000002020000000000020200000000000000000000000000000202000b80000000000000050100000
-- 019:0000000000000020200000000000000000000000002020000000000000202038383838383838383838383838383849ef381000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000760000100000000000000000000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000000000000000000020200000000000000000000000000000202000000000000000202000000000002020000000000000000000000000000020200010202020202020202050100000
-- 020:000000000000202000000000000000000000000020200000000000002020000000000000000000000000000000006666001000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202076000000000000760000100000000000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002089890000000000000000000000002020000000000000000000000000000020200000000000000020200000000000202000000000000000000000000000002020000010000000000000000050100000
-- 021:000000000020200000000000000000000000002020000000000000202000000000000000000000000000000000000000001000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200076465646564656760000100000000000000000000000000000202000000000000020200000000000000000000000202000000000000000000000000000208900890000000000000000000000202000000000000000000000000000002020000000000000002020000000000020200000000000000000000000000000202000000010b12020202020202020100000
-- 022:000000002020000000000000000000000000202000000000000020204656465646560000000000000000000000000000001000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000076475747574757760000100000000000000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020890000890000000000000000000020200000000000000000000000000000202000000000000000202000000000002020000000000000000000000000000020200000000010b10000000000000050100000
-- 023:000000202000000000000000000000000020200000000000002020004757475747570000000000000000877c967c867c971000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000066666666666666660000100000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002089000000890000000000000000002020000000000000000000000000000020200000000000000020200000000000202000000000000000000000000000002020000000000010202020202020202050100000
-- 024:000020200000000000000000000000002020000000000000202020bcadbdbcbdad060606ac06060606068c9c8c9c8c8c9c10000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000000000001000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002089000089b1890000000000000000202000000000000000000000000000002020000000000000002020000000000020200000000000000000000000000000202000000000000010000000000000000050100000
-- 025:0020200000000000000000000000002020000000000000202020202020202020202020202020202020202020202020202010000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000000000000001000000000000000000000202000000000000020200000000000000000000000202000000000000000000000000000208900008900b1890000000000000020200000000000000000000000000000202000000000000000202000000000002020000000000000000000000000000020200000000000000010b12020202020202020100000
-- 026:2020000000000000000000000000202000000000000020200000000000000000000000000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000000000000000001000000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020890000890000b1890000000000002020000078002e00000000000000000020200000000000000020200000000000202000000000000000000000000000002020000000000000000010b10000000000000078100000
-- 027:2000000000000000000000000020200000000000002020000000000000000000000000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000000000000000001000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002089898989890000b1890000000000202000002020202020202010000000002020000000000000002020000000000020200000000000000000000000000000202078000000000000000010202020202050002000000020
-- 028:000000000000000000000000202000000000000020200000000000000000000000000000007d00000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020580000acacacacacacacbcadbdacacacac681000000000000000202000000000000020200000000000000000000000202000000000000000000000000000208900e10000240000b1890000000020200000100002000002000010000000202000000000000000202000000000002020000000000000000000000000000020200000000000000000000010000000000050202000002020
-- 029:000000000000000000000020200000000000002020000000000000000000000000202020202020202000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202020202020202020202020202020202020202020200000000000002020000000000000202000000000000000000000002020000000000000000000000000002089000000b18900d6e6b1890000002020000010000000000000000000000020202020202020000020200000000000202000000000000000000000000000002020000000000000006800000010000000000020200000202000
-- 030:000000000000000000002020000000000000202000000000000000000000000000103131313131311000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000000000000000000000000000000000000202000000000000020200000000000000000000000202000000000000000000000000000208900000000b18900d7e7b18900002020000010420000000000000000000020200000e1000000002020000000000020200000000000000000000000000000202000202020202020202020200020202020202020000020200000
-- 031:000000000000000000202000000000000020200000000000000000000000000000103131313131311000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000000000000000000000000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020890000000000b18989898989000020202020103131720000000000000000208e31c30000000020202000000000002020000000000000000000000000000020200000000000000000000000000000000000000000002020000000
-- 032:000000000000000020200000000000002020000000000000000000000000000000103131317e31311000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000000000000000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002089000000000000b1890000000000202000106810523131d2011121000000202020202020b1041410000000000000202000000000000000000000000000002020000000000000000000000000000000000000000000202000000000
-- 033:000000000000002020000000000000202000000000000000000000000000000000103131313131311000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000010000000000000000000000000000000000000202000000000000020200000000000000000000000202000000000000000000000000000208900000000000000b189000000002020000020202020202020202020202020200000000000b10e1e10000000000020200000000000000000000000000000202000000000000000202020202020202020202020202020200000000000
-- 034:000000000000202000000000000020200000000000000000000000000000000000103131313131311000002020000000000000000000000000202000000000000000000000000000002020000000000020200000000000000000000010000000000000000000000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020890000000000000000b189000000202000000000000000000000000000000000f30000000000b10f1f10000000002020000000000000000000000000000020200000000000000020201000000000000000000000007600101000000000
-- 035:000000000020200000000000002020000000000000000000000000000000000000103131313131005000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000010000000000000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002089000000f70000000089898900002020000000000000000000000000000000002020202020202020202020000000202000000000000000000000000000002020000000000000002020001000000000000000000000007600100000000000
-- 036:0000000020200000000000002020000000000000000000000000000000000000001031313131500050202000000000000000000000000020200000000000000000000000000000202000000000000000009e202000000000000000b110000000000000000000000000000000202000000000000020200000000000000000000000202000000000000000000000000000208905000000cbc9c90000890000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000010000000005b6b00000000007600100000000000
-- 037:00000020200000000000002020000000000000000000000000000000000000000031310050005000202000000000000000000000000020200000000000000000000000000000202000102020202020202020202020202020202020b1100000000000000000000000000000202000000000000020200000000000000000000000202000000000000000000000000000202089b189898989898989898900002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000100000005b00006b000000007600100000000000
-- 038:00002020000000000000202000000000000000000000000000000000000000000050500031313120200000580000000000000000002020000000000000000000000000000020200000100000000000000000500000000000000010b1100000000000000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000b1000000000000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000001000005b000000006b005d007600100000000000
-- 039:00202000000000000020200000000000000000000000000000000000000000000020202020202020202020202020000000000000202000000000000000000000000000002020000000100000000000000000500000000000000010b1100000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002020000000b10000000000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000010005b0000000000007c867c7600100000000000
-- 040:202000000000000020200000000000000000000000000000000000000000000020200000000000000000000000000000000000202000000000000000000000000000002020000000001000000000000000005000005f4f6f3f0010b1100000000000000000000000202000000000000020200000000000000000000000202000000000000000000000000000202000000000b100000000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000106a6a6a6a999999998c8c9c6b00100000000000
-- 041:2000000000000020200000000000000000000000000000000000000000000020200000000000000000000000000000000000202000000000000000000000000000002020000000000010002f009f00000000508f00d4d4d4d47f10b1100000000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000b100000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000104a666666666666666666665b007d0000000020
-- 042:000000000000202000000000000000000000000000000000000000000000202000000000000000000000000000000000002020000000000000000000000000000020200000000000001020202020202020b1502020202020202010b11000000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000104a0000000000000000005b0020200000002020
-- 043:000000000020200000000000000000000000000000000000000000000020200000000000000000000000000000000000202000000000000000000000000000002020000000000000001000000000000000b15000cf000000000010b11000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000104a00000000000000005b002020000000202000
-- 044:00000000202000000000000000000000000000000000000000000000202000000000000000000000000000000000002020000000000000000000000000000020200000000000000000000000df00000000b1500000000000bf0010b11000000000000000202000000000000020200000000000000000000000202000000000000000000000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000104a000000000000005b00202000000020200000
-- 045:000000202000000000000000000000000000000000000000000000202000000000000000000000000000000000002020000000000000000000000000000020200000000000000000000000000000000000b150000000af00000010b11000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000000004a0000000000005b0020200000002020000000
-- 046:00002020000000000000000000000000000000000000000000002020000000000000000000000000000000000020200000000000000000000000000000202000000000000000000000202020202020202020202020202020202010b11000000000002020000000000000202000000000000000000000002020000000000000000000000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000000000006a6a6a6a999999992020000000202000000000
-- 047:002020000000000000000000000000000000000000000000002020000000000000000000000000000000000020200000000000000000000000000000202000000000000000000000202000000000000000000000000000000000000010000000002020000000000000202000000000000000000000002020000000000000000000000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000000020202020202020202020202000000020200000000000
-- 048:202000000000000000000000000000000000000000000000202000000000000000000000000000000000002020000000000000000000000000000020200000000000000000000020200000000000000000000000000000000000000010000000202000000000000020200000000000000000000000202000000000000000000000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000002020000000000000000000000000002020000000000000
-- 049:201000000000000000000000000000000000000000000020200000000000000000000000000000000000202000000000000000000000000000002020000000000000000000002020000000000000000000000000000000000000002020000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000000202000000000000000000000000000202000000000000020
-- 050:0d1000000000000000000000000000000000000000002020000000000000000000000000000000000020200000000000000000000000000000202000000000000000000000202000000000000000000000000000000000000020202000002020000000000000202000000000000000000000002020000000000000000000000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000000020200000000000000000000000000020200000000000002020
-- 051:00100000000000000000000000000000000000000020200000000000000000000000000000000000202000000000000000000000000000002020000000000000000000002020000000000000000000000000000000000000202000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000000202000000000000000000000000000202000000000000020200d
-- 052:2d1000000000000000000000000000000000000020200000000000000000000000000000000000202000000000000000000000000000002020000000000000000000002020000000000000000000000000002020202020202000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000000202000000000000000000000000000202000000000000020200000
-- 053:00100000000000000000000000000000000000202000000000000000000000000000000000002020000000000000000000000000000020200000000000000000000020200000000000000000000000000020200000000000000000202000000000000020200000000000000000000000202000000000000000000000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000002020000000000000000000000000002020000000000000202000edfd
-- 054:2d100000000000000000000000000000000020200000000000000000000000000000000000202000000000000000000000000000002020000000000000000000002020000000000000000000000000002020000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000000202000000000000000000000000000202000000000000020200d00eefe
-- 055:0010000000000000000000000000000000202000000000000000000000000000000000002020000000000000000000000000000020200000000000000000000020200000000000000000000000000020200000000000000000202000000000000020200000000000000000000000202000000000000000000000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000002020000000000000000000000000002020000000000000202000000000fb
-- 056:cd10000000000000000000000000000020200000000000000000000000000000000000202000000000000000000000000000002020000000000000000000002020000000000000000000000000002020000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000000202000000000000000000000000000202000000000000020200d00edfdddcc
-- 057:00100000000000000000000000000020200000000000000000000000000000000000202000000000000000000000000000002020000000000000000020202020000000000000000000000000002020000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000000202000000000000000000000000000202000000000000020200d0000eefe00fc
-- 058:2d1000000000000000000000000020200000000000000000000000000000000000202000000000000000000000000000002020000000000000000020200000000000000000000000000000002020000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020202000000000000000000000000000202000000000000020200d00000000000000
-- 059:6710000000000000000000000020200000000000000000000000000000000000202000000000000000000000000000002020000000000000002020200000000000000000000000000000002020000000000000000020200000000000002020000000000000000000000000b10000000000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200d000000edfd000000
-- 060:2d10000000000000000000002020000000000000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000000000000000202000000000000000002020000000000000202000000000000000000000002020b100000000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200d00edfd00eefe000000
-- 061:0010000000000000000000202000000000000000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000000000000000020200000000000000000202000000000000020200000000000000000000000202000b100000000000000000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020070000eefe000000000000
-- 062:0010000000000000000020200000000000000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000000000000000002020000000000000000020200000000000002020000000000000000000000020200000b10000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200d000000000000fb00000000
-- 063:2d10000000000000002020000000000000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000100000000000202000000000000000002020000000000000202000000000000000000000002020000000b100000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200d00edfd000000ddcccd000000
-- 064:0010000000000000202000000000000000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000000100000000020200000000000000000202000000000000020200000000000000000000000202000000000b1000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200d0000eefe00000000fc00000000
-- 065:671000000000002020000000000000000000000000000000000020200000000000000000000000000000202000000000000000202000000000ae6800b800000000100000002020000000000000000020200000000000002020000000000000000000000020200000000000b1000000000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000000000000000000000000000
-- 066:6810000000002020000000000000000000000000000000000020200000000000000000000000000000202000000000000000202000102020202020202010000000100000202000000000000000002020000000000000202000000000000000000000002020000000000000b1000000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000691679006900000000000000000000
-- 067:202000000020200000000000000000000000000000000000202000000000000000000000000000002020000000000000002020001000005000005000020010000010b120200000000000000000202000000000000020200000000000000000000000202000000000000000b1000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020202020202020b12020202020202020202020
-- 068:000000002020000000000000000000000000000000000020200000000000000000000000000000202000000000000000202000100000005000005000000000100010b1100000000000000000202000000000000020200000000000000000000000202000b120202020202020000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000d000d0000b11000000000000000000000
-- 069:000000202000000000000000000000000000000000002020000000000000000000000000000020200000000000000020200010000062005000c05000000000001000b1100000000000000020200000000000002020000000000000000000000020200000b100000000000000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000b11000000000000000000000
-- 070:000020200000000000000000000000000000000000202000000000000000000000000000002020000000000000002020001000000020202000202020000000001000b1100000000000002020000000000000202000000000000000000000002020000000b1000000000000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000fb000000b11000000000000000000000
-- 071:002020000000000000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000100200000200000000e01000b1100000000000202000000000000020200000000000000000000000202000000000b1000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200d000000ddcccd0000b11000000000000000000000
-- 072:20200000000000000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000000000f000000000100000b1100000000020200000000000002020000000000000000000000020200000000000b10000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020201d0000000000fc00edfdb11000000000000000000000
-- 073:200000000000000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000d00000900000001000a0b010000000b1100000002020000000000000202000000000000000000000002020000000000000b1000000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000edfd000000eefeb11000000000000000000020
-- 074:000000000000000000000000000000000020200000000000000000000000000000202000000000000000202000000000002020202020202020202020202020000000b1100000202000000000000020200000000000000000000000202000b12020202020200000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000fb000000eefe0000000000b11000000000000000002020
-- 075:00000000000000000000000000000000202000000000000000000000000000002020000000000000002020000000000020200000000000000000000000000000202020000020200000000000002020000000000000000000000020200000b10000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020201dddcccd00000000fb00edfd00b11000000000000000202000
-- 076:00000000000000000000000000000020200000000000000000000000000000202000000000000000202000000000002020000000000000000000000000202020200000002020000000000000202000000000000000000000002020000000b10000000000000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020100000fc00edfd00ddcccdeefe00b11000000000000020200000
-- 077:00000000000000000000000000002020000000000000000000000000000020200000000000000020200000000000202000000000000000000000202020200000000000202000000000000020200000000000000000000000202000000000b10000000000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000101d000000eefe0000fc00000000b11000000000002020000000
-- 078:000000000000000000000000002020000000000000000000000000000020200000000000000020200000000000202000000000000000000000202000000000000000202000000000000020200000000000000000000000202000b12020202000000000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000001000000000000000000000000000b11000000000202000000000
-- 079:000000000000000000000000202000000000000000000000000000002020000000000000002020000000000020200000000000000000000020200000000000000020200000000000002020000000000000000000000020200000b10000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000001058006900000000000000000000b11000000020200000000000
-- 080:000000000000000000000020200000000000000000000000000000202000000000000000202000000000002020000000000000000000002020000000000000002020000000000000202000000000000000000000002020000000b10000000000000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000002020202020202020202020202020202000002020000000000000
-- 081:000000000000000000002020000000000000000000000000000020200000000000000020200000000000202000000000000000000000202000000000000000202000000000000020200000000000000000000000202000000000b10000000000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000202000000000000000
-- 082:000000000000000000202000000000000000000000000000002020000000000000002020000000000020200000000000000000000020200000000000000020200000000000002020000000000000000000000020200000000000b10000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000000000000000000000000000000000000000000020200000000000000000
-- 083:000000000000000020200000000000000000000000000000202000000000000000202000000000002020000000000000000000002020000000000000002020000000000000202000000000000000000000002020000000000000b10000000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000000000000000000000000000000000000000002020000000000000000000
-- 084:000000000000002020000000000000000000000000000020200000000000000020200000000000202000000000000000000000202000000000000000202000000000000020200000000000000000000000202000002020202020200000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000202000000000000000000000
-- 085:000000000000202000000000000000000000000000002020000000000000002020000000000020200000000000000000000020200000000000000020200000000000002020000000000000000000000020200000202000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000000000000000000000000000000000000000000020200000000000000000000000
-- 086:000000000020200000000000000000000000000000202000000000000000202000000000002020000000000000000000002020000000000000002020000000000000202000000000000000000000002020000020200000000000000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000000000000000000000000000000000000000002020000000000000000000000000
-- 087:000000002020000000000000000000000000000020200000000000000020200000000000202000000000000000000000202000000000000000202000000000000020200000000000000000000000202000002020000000000000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000202000000000000000000000000000
-- 088:000000202000000000000000000000000000002020000000000000002020000000000020200000000000000000000020200000000000000020200000000000002020000000000000000000000020200000202000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000000000000000000000000000000000000000000020200000000000000000000000000000
-- 089:000020200000000000000000000000000000202000000000000000202000000000002020000000000000000000002020000000000000002020000000000000202000000000000000000000002020000020200000000000000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000000000000000000000000000000000000000002020000000000000000000000000000000
-- 090:002020000000000000000000000000000020200000000000000020200000000000202000000000000000000000202000000000000000202000000000000020200000000000000000000000202000002020000000000000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000202000000000000000000000000000000000
-- 091:202000000000000000000000000000002020000000000000002020000000000020200000000000000000000020200000000000000020200000000000002020000000000000000000000020200000202000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000000000000000000000000000000000000000000020200000000000000000000000000000000000
-- 092:200000000000000000000000000000202000000000000000202000000000002020000000000000000000002020000000000000002020000000000000202000000000000000000000002000000020200000000000000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000000000000000000000000000000000000000002020000000000000000000000000000000000020
-- 093:0000000000000000000000000000202000000000000000202000000000002020000000000000000000002020000000000000002020000000000000202000000000000000000000002020b1102020000000000000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000202000000000000000000000000000000000002020
-- 094:0000000000000000000000000020200000000000000020200000000000202000000000000000000000202000000000000000202000000000000020200000000000000000000000202000b1100000000000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000000000000000000000000000000000000000000020200000000000000000000000000000000000202000
-- 095:0000000000000000000000002020000000000000002020000000000020200000000000000000000020200000000000000020200000000000002020000000000000000000000020200000b1100000000000000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000000000000000000000000000000000000000002020000000000000000000000000000000000020200000
-- 096:0000000000000000000000202000000000000000202000000000002020000000000000000000002020000000000000002020000000000000202000000000000000000000002020cececeb1100000000000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000202000000000000000000000000000000000002020000000
-- 097:0000000000000000000020200000000000000020200000000000202000000000000000000000202000000000000000202000000000000020200000000000000000000000202000000000b1100000000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000000000000000000000000000000000000000000020200000000000000000000000000000000000202000000000
-- 098:0000000000000000002020000000000000002020000000000020200000000000000000000020200000000000000020200000000000002020000000000000000000000020200000000000b1100000000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000000000000000000000000000000000000000002020000000000000000000000000000000000020200000000000
-- 099:0000000000000000202000000000000000202000000000002020000000000000000000002020000000000000002020000000000000202000000000000000000000002020000000000000b1100000000000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000202000000000000000000000000000000000002020000000000000
-- 100:0000000000000020200000000000000020200000000000202000000000000000000000202000000000000000202000000000000020200000000000000000000000202000000000000000b1100000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000000000000000000000000000000000000000000020200000000000000000000000000000000000202000000000000000
-- 101:0000000000002020000000000000002020000000000020200000000000000000000020200000000000000020200000000000002020000000000000000000000020200000000000000000b1100000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000000000000000000000000000000000000000002020000000000000000000000000000000000020200000000000000000
-- 102:000000000020200000000000000020200000000000202000000000000000000000202000000000000000202000000000000020200000000000000020102020202020202020202020202020200000202000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000202000000000000000000000000000000000002020000000000000000000
-- 103:00000000202000000000000000202000000000002020000000000000000000002020000000000000002020000000000000202000000000000000202010000000000000a3000000a3000000000020200000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000000000000000000000000000000000000000000020200000000000000000000000000000000000202000000000000000000000
-- 104:000000202000000000000000202000000000002020000000000000000000002020000000000000002020000000000000202000000000000000202000100093000000000000000000000000002020000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000000000000000000000000000000000000000002020000000000000000000000000000000000020200000000000000000000000
-- 105:0000202000000000000000202000000000002020000000000000000000002020000000000000002020000000000000202000000000000000202000001000000010b1202020202020202020201000000000002020000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000202000000000000000000000000000000000002020000000000000000000000000
-- 106:0020200000000000000020200000000000202000000000000000000000202000000000000000202000000000000020200000000000000020200000001073737310b1000053005300530050001000000000202000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000000000000000000000000000000000000000000020200000000000000000000000000000000000202000000000000000000000000000
-- 107:2020000000000000002020000000000020200000000000000000000020200000000000000020200000000000002020000000000000002020000000001083688310b1930043006300930050000000000020200000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020100000000000000000000000000000000000000000002020000000000000000000000000000000000020200000000000000000000000000000
-- 108:2000000000000000202000000000002020000000000000000000002020000000000000002020000000000000202000000000000000202000000000001083838310b1000000000000520050001020002000000000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000100000000000000000000000000000000000000000202000000000000000000000000000000000002020000000000000000000000000000020
-- 109:0000000000000020200000000000202000000000000000000000202000000000000000202000000000000020200000000000000020200000000000002020202020b1202020202020202020202010001000000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000100000000000000000000000000000000000000020200000000000000000000000000000000000202000000000000000000000000000002020
-- 110:0000000000002020000000000020200000000000000000000020200000000000000020200000000000002020000000000000002020000000000000000000000000b1202020202020202020202010581000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000100000000000000000000000000000000000002020000000000000000000000000000000000020200000000000000000000000000000202000
-- 111:0000000000202000000000002020000000000000000000002020000000000000002020000000000000202000000000000000202000000000000000000000000000b1100000006c127a8a00001020202000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000100000000000000000000000000000000000202000000000000000000000000000000000002020000000000000000000000000000020200000
-- 112:000000002020000000000020200000000000000000000020200000000000000020200000000000002020000000000000002020000000000000000000000000002020100000006c007b8b0022104e000000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000000000100000000000000000000000000000000020200000000000000000000000000000000000202000000000000000000000000000002020000000
-- 113:0000002020000000000020200000000000000000000020200000000000000020200000000000002020000000000000002020000000000000000000000000002020500094f1d16c00000061821000000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000000000100000000000000000000000000000002020000000000000000000000000000000000020200000000000000000000000000000202000000000
-- 114:000020200000000000202000000000000000000000202000000000000000202000000000000020200000000000000020200000000000000000000000000020200050102020206c20102020201000000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000100000000000000000000000000000202000000000000000000000000000000000002020000000000000000000000000000020200000000000
-- 115:00202000000000002020000000000000000000002020000000000000002020000000000000202000000000000000202000000000000000000000000000202000005010000c006c005000e3001000000020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020201020202020202020100000000000000000000000000020200000000000000000000000000000000000202000000000000000000000000000002020000000000000
-- 116:20200000000000202000000000000000000000202000000000000000202000000000000020200000000000000020200000000000000000000000000020200000005010489b356c0092f2c2a41000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020001000000000000000100000000000000000000000002020000000000000000000000000000000000020200000000000000000000000000000202000000000000000
-- 117:200000000000202000000000000000000000202000000000000000202000000000000020200000000000000020200000000000000000000000000020206898a80050202020205920202020200000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000001000000000000000100000000000000000000000202000000000000000000000000000000000002020000000000000000000000000000020200000000000000020
-- 118:00000000002020000000000000000000002020000000000000002020000000000000202000000000000000202000000000000000000000000000202000202020202000000000b10050000000002020000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000000020000000000000000000000000000020200000000000002020000000100000000000000020202020202020202020b120200000000000000000000000000000000000202000000000000000000000000000002020000000000000002020
-- 119:00000000202000000000000000000000202000000000000000202000000000000020200000000000000020200000000000000000000000000020200000000000000000000000b10050000000202000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000002000000000000000000000000000002020000000000000202000000000100000000000000010000000000000000000b100000000000000000000000000000000000020200000000000000000000000000000202000000000000000202000
-- 120:00000020200000000000000000000020200000000000000020200000000000002020000000000000002020000000000000000000000000002020000000000000202020202020202020202020200000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000000200000000000000000000000000000202000000000000020200000000000100000000000000010000000000000000000b100000000000000000000000000000000002020000000000000000000000000000020200000000000000020200000
-- 121:000020200000000000000000000020200000000000000020200000000000002020000000000000002020000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000000200000000000000000000000000000202000000000000020200000000000001000000000000000106ebe00000000000000b100000000000000000000000000000000202000000000000000000000000000002020000000000000002020000000
-- 122:00202000000000000000000000202000000000000000202000000000000020200000000000000020200000000000000000000000000020200000000000002020000000000000000000000000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000002000000000000000000000000000002020000000000000202000000000000000100000000000000010000000000000000000b100000000000000000000000000000020200000000000000000000000000000202000000000000000202000000000
-- 123:20200000000000000000000020200000000000000020200000000000002020000000000000002020000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000000200000000000000000000000000000202000000000000020200000000000000000000000000000000010000000000000000000b100000000000000000000000000002020000000000000000000000000000020200000000000000020200000000000
-- 124:20000000000000000000002020000000000000002020000000000000202000000000000000202000000000000000000000000000202000000000000020200000000000000000000000000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000000020200000000000000000000000000020200000000000002020000000000000000000000020202020202020000000000000000000b100000000000000000000000000202000000000000000000000000000002020000000000000002020000000000020
-- 125:00000000000000000000202000000000000000202000000000000020200000000000000020200000000000000000000000000020200000000000002020000000000000000000000000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000002000000000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000000000b100000000000000000000000020200000000000000000000000000000202000000000000000202000000000002020
-- 126:00000000000000000020200000000000000020200000000000202020000000000000002020000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000000200000000000000000000000000000202000000000000020200000000000000000000000202000000000000000000000006e00680000b100000000000000000000002020000000000000000000000000000020200000000000000020200000000000202000
-- 127:00000000000000002020000000000000002020000000000020200000000000000000202000000000000000000000000000202000000000000020200000000000000000000000000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000000000000000000020200000000000000000202020202020202020b120000000000000000000202000000000000000000000000000002020000000000000002020000000000020200000
-- 128:000000000000002020000000000000002020000000000020200000000000000000202000000000000000000000000000202000000000000020200000000000000000000000000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000000000000000000020200000000000000000001000000000e3000000b110000000000000000020200000000000000000000000000000202000000000000000202000000000002020000000
-- 129:00000000000020200000000000000020200000000000202000000000000000002020000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000000000000000000000202000000000000000000000100000000000000000b110000000000000002020000000000000000000000000000020200000000000000020200000000000202000000000
-- 130:0000000000202000000000000000202000000000002020000000000000000020200000000000000000000000000020200000000000002020000000000000000000000000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000000000b3c3000000b110000000000000202000000000000000000000000000002020000000000000002020000000000020200000000000
-- 131:0000000020200000000000000020200000000000202000000000000000002020000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000000000000000000000202000000000000000000000000000000085b4c4d40000b110000000000020200000000000000000000000000000202000000000000000202000000000002020000000000000
-- 132:000000202000000000000000202000000000002020000000000000000020200000000000000000000000000020200000000000002020000000000000000000000000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002020202020202020202020000000002020000000000000000000000000000020200000000000000020200000000000202000000000000000
-- 133:000020200000000000000020200000000000202000000000000000002020000000000000000000000000002020000000000000202000000000000000000000000000000000000000000000000000000020200000000000000000000000002020000000000000000000000000000020200000000000000020200000000000000000000020200000000000000000000000000000202000000000000020200000000000000000000000202000000000000000000000000000202000000000000000000000000000202000000000000000000000000000002020000000000000002020000000000020200000000000000000
-- 134:002020000000000000002020000000000020200000000000000000202000000000000000000000000000202000000000000020200000000000000000000000000000000000000000000000000000002020000000000000000000000000202000000000000000000000000000002020000000000000002020000000000000000000002020000000000000000000000000000020200000000000002020000000000000000000000020200000000000000000000000000020200000000000000000000000000020200000000000000000000000000000202000000000000000202000000000002020000000000000000000
-- 135:202000000000000000202000000000002020000000000000000020200000000000000000000000000020200000000000002020000000000000000000000000000000000000000000000000000000202000000000000000000000000020200000000000000000000000000000202000000000000000202000000000000000000000202000000000000000000000000000002020000000000000202000000000000000000000002020000000000000000000000000002020000000000000000000000000002020000000000000000000000000000020200000000000000020200000000000202000000000000000000000
-- </MAP2>

-- <MAP3>
-- 000:000000000000000000000000000000000000000000000060505050b3b35050505000b05300000000000000000000000000000000000000000000000000000000b300000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:000000000000000000000000000000000000000000000060646464000060002300906000530000000000000000000000c000000000000000000000000000005000000000c3500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:0000000000000000000000000000000000000000000000606464640000600023d09060000053000000000000000000310031000000000000000000000000505050505050c3005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:0000000000000000000000000000000000000000000000606444540000600023009060000000530000000000000031000000310000000000000000000000600000000000c3006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:000000000000000000000000000000000000000000000060505050500060002300906000000000530000000000310000d000003100000000000000000000600000000000c3006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:0000000000000000000000000000000000000000000000600000006000600033009060000000000053000000310000000000000031000000000000000000600000000000c300b300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:00000000000000000000000000000000000000000000000000eefe600060000000006000000000000053003102120212021202120031000000000000000060000000d3e3c3006050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:0000000000000000000000000000000000000000000000b000efff490000430053006000000000000000310003130313031303132200310000000000000000000000c8d8c3000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:00000000000000000000000000000000000000000000905050505050505050505050500000000000003131313131313131313131313131310000000000c350505050505050505070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000836f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:000000000000000000000000000000000000000000009000700000000000000000007000000000000000610000000000000000000000610000000000000000465666768696a6b670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:00009d9d00000000009d9d000000009d9d00000000009000700000000000000000007000000000000000b3004b000000000000000000b30000000000000000475767778797a700700000bbe60000000000e6e600000000e6e600000000e6e60000000000bbbb000000000000bbbb000000000000bbbb00000000bbbb00000000bbbb000000e6bb00000000bbbb00000000e6e60000000000e6e600000000b5b80000000000b8b80000000000b8b8000000000000b8b8000000000000b8b80000000000b8b8000000000000b8b800000000b8b800000000b8b80000000000b8b800000000009d9d00000000009d9d0000
-- 011:000414243400000004142434000004142434000000009000700000000000000000007000000000000000610000000000d00000000000610000000000000000485868788898a80070000414243400000004142434000004142434000004142434000000041424340000000004142434000000000414243400000414243400000414243400041424340000041424340000041424340000000414243400000414243400000004142434000000041424340000000004142434000000000414243400000004142434000000000414243400000414243400000414243400000004142434000000041424340000000414243400
-- 012:0005152535000000051525350000051525350000000090007000000000000000000070000000000000006100e9000000000000000000610000000000000000000069798999000070000515253500000005152535000005152535000005152535000000051525350000000005152535000000000515253500000515253500000515253500051525350000051525350000051525350000000515253500000515253500000005152535000000051525350000000005152535000000000515253500000005152535000000000515253500000515253500000515253500000005152535000000051525350000000515253500
-- 013:0006162636000000061626360000061626360000000090007000000000005d6d000070000000000000000000eafa000000000000f10051516100000000000000006ac5d59a000070000616263600000006162636000006162636000006162636000000061626360000000006162636000000000616263600000616263600000616263600061626360000061626360000061626360000000616263600000616263600000006162636000000061626360000000006162636000000000616263600000006162636000000000616263600000616263600000616263600000006162636000000061626360000000616263600
-- 014:0007172700000000071727000000071727000000000090007000000000005e6e000070000000000000000000b1c193000000e100a3b2a2d26100000000000000006bc6d69bab007000001727000000000717270000000717270000000717270000e500071727000000000007172700000000000717270000000717270000000717270000071727000000071727000000071727000000000717270000000717270000000007172700000000071727000000000007172700000000000717270000000007172700000000000717270000000717270000000717270000000007172700000000071727000000000717270000
-- 015:d7d71828d7d7d7d7081828d7d7d7081828d7d7d7d7d790007000000000718171819270000000d4e4f3f4515151515151515151515151615151000000000000005c6c7c8c9cac007000081828a4c7c7c7a41828a4c7c7a41828a4c7c7a41828e5e594e5081828c7c7a4c7a4a41828c7c7c7a4a4a41828c7c7a4a41828a4e5a4081828e5c7a41828e5c7a4a41828e5c7c7a41828c7a4a4f5c41828e5f5c4a41828380084a4081828e5e5d7d7d71828d7c7d7a4a4081828a4d7d7d7d7081828a4d7d7d7081828d7d7d7d7d7081828a4d7d7081828d7d7d7081828d7d7d7d7d71828a4d7d7d7081828a4d7d7d7081828a4d7
-- 016:404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040
-- 043:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bdad0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 044:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bd5b5bad00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 045:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bd5b5b5b5bad000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 046:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bc00000000bc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 047:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bc00000000bc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 048:000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f60000fde2bc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 049:000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101001ddf00ba00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 050:000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404040404040404040404040404040404040404040404040404040404040000000000000000000000000000000000000000000000000000000000000
-- 051:000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 052:000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 053:0000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000001000000000000000000000000000000000aaaaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 054:00000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000010000000000000000000000000000000aaaa0b0000aaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 055:000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000100000000000000000000000000000aaaa0b00000000aaaa000000000000000000000000000000000000000000000000000000000000000000000000000000aaaaaaaaaaaaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 056:0000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000001000000000000000000000000000aaaa0b0b000000000000aa000000000000000000000000000000000000000000000000000000000000000000000000aaaaaa0000aaaa00aaaaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 057:000000000000000000000000000000000000000000000000000000000000000000000000000010009f00000e0000cf0000000000000000000010000000000000000000000000aaaa0b0b0b000000000000aaaa0000000000000000000000000000000000000000000000000000000000000000aaaaaaaa0000000000aa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 058:000000000000000000000000000000000000000000000000000000000000000000000000000010007d9e0d8d9e0d5f9e0d0000000000000000100000000000000000000000aaaa0b0b000000000000000000aaaa00000000000000000000000000000000000000000000000000000000000000aa000000000000000000aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 059:0000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010100000000000001000000000000000000000aaaa0b0b0b00000000000000000000aaaa0000000000003b00000000000000000000000000000000000000000000aaaa000000000000000000aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 060:0000000000000000000000000000000000000000000000000000000000000000000000000000100000e0000000000000e0001010000000000010000000000000000000aaaa0b0b0b0b0000000000000000000000aaaa000000000000003b003b00003b000000000000000000000000000000aa0000b00b0b0b0000aaaaaaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 061:0000000000000000000000000000000000000000000000000000000000000000000000000000100000e0000000000000e00000101000000000100000000000000000aaaa0b0b0b0b0000000000000000000000000000aa000000003b00003b003b0000003b0000003b00000000003b000000aaaa90aaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 062:0000000000000000000000000000000000000000000000000000000000000000000000000000100000e0000000000000e00000000000101000100000000000000000aaaaaaaaaa0b0b00000000000000000000000000aaaa00000000003b003b003b003b0000003b0000003b00003b00003b000090aa000000000000aaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 063:0000000000000000000000000000000000000000000000000000000000000000000000000000100000e0000000000000e0000000001010e00010000000000000000000000000aaaa0b0000000000000000000000000000aaaa00000000000000003b000000000000000000000000000000003b0090aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 064:0000000000000000000000000000000000000000000000000000000000000000000000000000100000e0000000000000e0000000101000e0001000000000000000000000000000aa00000000000000000000000000000000aaaa0000003b003b000000003b003b00003b0000003b0000b00b0b0baaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 065:0000000000000000000000000000000000000000000000000000000000000000000000000000000000e0390c290c2a0c37000010100000e000100000000000000000000000000000aa00000000000000000000000000000000aa000000000000003b3b003b003b3b000000003b000090aaaaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 066:0000000000000000000000000000000000000000000000000000000000000000000000000000002000e0003c5a5a5a4ce0a91010000000e00010000000000000000000000000000000aaaa0000000000000000000000000000aa00000000000000000000000000003b003b00003b0090aa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 067:0000000000000000000000000000000000404040404040404040404040404040404040404040101010101010101010101010101010101010101040400000000000000000000000000000aaaa000000000000000000000000aa000000000000000000aaaaaaaaaa000000000000000090aa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 068:0000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaaaaaaaaaaaaaaaaaa000000000000000000000000000000000000000000000000aaaa00000000000000000000aa000000000000000000aaaa000000aaaa00003b003b00b0aaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 069:0000000000000000000000000000000000000000000000000000000000000000000000000000000000aa0000000000000000aaaaaaaaaaaaaa00000000000000000000000000000000000000aaaa0000000000000000aa0000000000aa000000aaaa0000000000aaaa0000000090aaaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 070:0000000000000000000000000000000000000000000000000000000000000000000000000000000000aa003b0000003b0000000000000000aa0000000000000000000000000000000000000000aaaa000000000000aa000000000000aa0000aaaa0000003b000000aaaa003b0b90aaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 071:0000000000000000000000000000000000000000000000000000000000000000000000000000000000aa00000000000000000000003b0000aa000000000000000000000000000000000000000000aaaaaaaaaa00aa00000000000000aaaaaaaa000000000000000000aaaa0b0baaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 072:0000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaa00000000003b003b0000000000aa00000000000000000000000000000000000000000000000000aa00aa00000000000000aa000000000000000000000000000b0baaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 073:000000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaaaaaa00000000000000000000aaaa000000000000000000000000000000000000000000000000aa00aa0000000000000000aaaaaa0000003b003b00003b000baaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 074:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaa003b00003b003b000000aaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000000000aa00aa00000000000000000000aaaa00000000003b000b0baaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 075:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa0000000000000000000000000000000000000000000000aaaa00000000000000000000aa00aa0000000000000000000000aa0000000000000b0baaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bdad00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 076:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa000000003b00003b000000aaaaaa00003b003b0000000000aaaa000000000000000000aa00aa000000aaaaaaaaaaaaaaaaaa003b00003b0b0baaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bd5b5bad000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 077:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa003b0000000000000000aaaa00aa00000000003b00003b0000aaaa0000000000000000aa00aa0000aaaa000000aaaa000000000000000b0baaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bd5b5b5b5bad0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 078:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa000000003b003b0000aaaa0000aa0000003b0000000000000000aaaa00aaaaaaaaaaaaaa00aa00aaaa003b000000aaaa0000000b0b0b0baaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bd5b5b5b5b5b5bad00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 079:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa0000000000000000aaaaaa0000aaaa0000000000003b00003b0000aaaa0b0000000000000000aaaa000000003b0000aaaa003b0b0000aaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 080:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaaaaaaaaaaaaaaaa000000000000aa00003b000000000000000000aaaaaaaaaaaaaaaaaaaaaa00003b003b00003b00aaaa0b0b00aaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 081:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa000000000b0000003b00000000000000000000003b00000b0b0b0b0b0b0b0b0b0b0b00aaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f0fededed0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 082:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaaaaaaaaaa000000003b0000003b00003b000000000baaaaaaaaaaaaaaaaaaaaaaaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 083:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaa00003b00003b00003b0000003b000baaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f0f0ff60f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 084:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaa000000000000000b000b000b00aaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404040404040404040404040404040404040404040404040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 085:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa00000000b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 086:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 087:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b90000000000000000000000000000000000000000aebe00000000b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 088:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b90000000000000000000000000000000000000000afbf00000000b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 089:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b900000000000000000000000000e80000000000e7e7e7e7000000b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 090:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b900000000000000000000000000000000000000e7c9d9e7000000b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 091:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b900000000000000000000000000000000000000e7cadae7000000b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 092:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b90000000000000000000000000000000000000000cddd00000000b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 093:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b90000000000000000000000000000000000000000cede00000000b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 094:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b90000000000000000000000000000000000000000ccdc00000000b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 095:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b900000000000000000000000000000000004a0000ccdc00000000b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 096:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b90000001c2c00000000000000001c2c0000000000ccdc00000000b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 097:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b9000000002d3d4d000000000000002d3d4d000000ccdc004a0000b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 098:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b90000001e2e3e4e007e8e007e8e1e2e3e4e000000ebfb00000000b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 099:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b90000001f2f3f4f007f8f007f8f1f2f3f4f003a00ecfc0000003ab9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 100:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 101:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 134:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 135:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP3>

-- <MAP5>
-- 000:1a1a1a1a101010101010101111111110000000111111111111111111001110101010101010101000101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000100010101010101010101010101a1a1a1a1a1a1a
-- 001:1a1a1a1a10101010101010100000000000000010001010000000000000000000100000000000000010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000010000000001010101010101010101a1a1a1a1a1a
-- 002:1a101a1a1010101010101010101000001010101010000000000000000000000000000000001010001010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101000000000101010101010000000001a1a1a1a1a
-- 003:1a1a1a1010101010101010100000100010000010100000000000000010000000100000000000000000001010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000001010101010000000000000001a001a
-- 004:1a1a10101010101010000000000000001010000000000000000000000000000000000000000000000000101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000010001000000000000010
-- 005:1a0000101000101000000000000000000010100000000000000000000000000000000000000000000000001010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000010001000000000001010000000000000
-- 006:001010101000000000000000000000000000100000000000000000100010101000000000000000000000001010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000100000001000100000000000
-- 007:000010101000000000000000000000000000000000000000000000000000100010000000000000000000001010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000010001010101010101010001010
-- 008:100000101000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000010101010001010101010101010
-- 009:101000001000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000010101010101000001010101010101010
-- 010:000000000000000000000000000000000000000000000000000000000000000000000010000000000000101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000010001010000010101010101010
-- 011:000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 012:000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 013:000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 014:000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 015:000000000000000000000000000000000000000000000000000000000000001010000010101010101010101010101010101010101010101010001010101010000000001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 016:000000000000000000000010101010101010101010101000101000101010000000001010101010101010101010101010101010101010101010001010101000000000000010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 017:101010100000000000000010101010101010101010100000101010101010101010101010101010101010101010101010101010101010101010001010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 018:101010000000000000000000001000000000001010000010100000001010101010101010100000101010101010101010101010101010101010001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 019:100000000000000000000000000000101010000000001010000010000010101010101010000000001010101010101010101010101010101010001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 020:000000000000000000000000001000101000000000000000001010100000101010101000000010001010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000
-- 021:000000000000000000000000000000101010000000000000000000000000000000000000000000001010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000
-- 022:000000000000000000000000000010101000100000000000000000001010000000000000000000101010000000000000101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000
-- 023:101010101010000010000000000000000000000000000000000000001010000000000000000000001000000010000000001010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 024:101010101010100000000000101010101010001010000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 025:101010101010101000000000101010101010001010000000101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 026:101010101010101010000000101010101010000000001010101010101010101010101000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 027:101010101010101010100000001010101010101010101010101010101010101010101000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 028:101010101010101010101000001010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 029:101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 030:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 031:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000010101010101010101010101010101010101010101010101010101010101010101010101010000000100000000010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 032:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000010101010101010101010101010101010101010101010101010101010101010000000101000001000100010000010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 033:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000101010101010101010101010101010101010101010101010101010101010001000000000101000101000001010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 034:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000101010101010101010101010101010101010101010101010101010101010100010000010100000101000000010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 035:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000101010101010101010101010101010101010101010101010100000000000001000000010000010101000100000001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 036:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000101010101010101010101010101010101010101010101010100000000000000000000000001010101000000010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 037:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000101010101010101010101010101010101010101010101010100000000000101010101000001010100000000010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 038:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000101010101010101010101010101010101010101010101010104040404040001010101010000000000040404010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 039:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000101010101010101010101010101010101010101010101010105050505050101010101010101010101050505010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 040:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 041:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 042:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 043:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 044:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 045:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 046:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 047:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 048:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 049:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 050:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 051:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 052:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 053:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 054:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 055:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 056:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 057:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 058:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 059:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 060:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 061:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 062:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 063:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 064:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 065:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 066:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 067:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 068:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 069:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 070:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 071:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 072:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 073:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 074:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 075:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 076:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 077:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 078:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
-- 079:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101a101010101010101010101010101010101010101010101010101010101010101010101010
-- 080:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101a10101010101a1a1a10101010101010101010101010101010101010101010101010101010
-- 081:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101a1a101a1a1010101a1a1a1a1a1010101010101010101010101010101010101010101010101010
-- 082:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a101a10101a1a1a1a101a1010101010101010101010101010101010101010101010101010
-- 083:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a1a101a1a1a1a1a1a1a101a1010101010101010101010101010101010101010101010101010
-- 084:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a101a1a1a1a1010101010101010101010101010101010101010101010
-- 085:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a101a1a10101010101010101010101010101010101010101010
-- 086:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a101a1a1a1a1a1a1a1a101010101a1a101010101010101010101010101010
-- 087:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a101a1a1a1a1a1010101a1a1a1010101010101010101010101010
-- 088:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101a1a1a1a401a1a1a1a10101a1a1a1010101a1a1a1a1a1a1a1a1a1a10101a1a1a1a1a1a1a1a1a1a101010101010
-- 089:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101a101a1a1a50001a1a101010101010101010101a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a101a1a101010101010
-- 090:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101a1a101010101010101010101010101010101010101010101a1a10101a1a1a1a1a101a1a1a1a10101010101010
-- 091:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101a101010101010101010101010101010101010101010101a1a1a101a1a1a1a1a1a1a101a1a1a10101010101010
-- 092:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a101a1a1a10101a1a1a1a1010101010101010
-- 093:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a101a1a1a1a1a1a10101010101010101010
-- 094:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1010101010101010101010
-- 095:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1010101010101010101010
-- 096:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a10101010101010101010101010
-- 097:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a10101a10101010101010101010101010
-- 098:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a101a1a10101010101010101010101010
-- 099:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a10101010101010101010101010
-- 100:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a10101010101010101010101010101010
-- 101:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1010101a1010101010101010101010101010101010
-- 102:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a10101a101010101010101010101010101010101010
-- 103:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a101a10101010101010101010101010101010101010
-- 104:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1010101010101010101010101010101010101010
-- 105:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a10101010101010101010101010101010101010
-- 106:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a101a1a101a1a1a1a1a1a1a1010101010101010101010101010101010
-- 107:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a101a1a1a1a1a1a1a1a1a1a1a1010101010101010101010101010
-- 108:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1010101010101010101010
-- 109:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a101a1a1a101010101010101010101010
-- 110:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1010101010101010101010
-- 111:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1010101010101010101010
-- 112:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a10101010101010101010
-- 113:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a10101010101010
-- 114:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a10101010101010
-- 115:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1010101010101010
-- 116:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a101010101010101010
-- 117:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1010101010101010
-- 118:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a1a1a1a1a1a1010101010101010101010
-- 119:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a1a1a1a101010101010101010101010
-- 120:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a10101010101010101010101010
-- 121:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1a1010101010101010101010
-- 122:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1010101010101010101010
-- 123:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1010101010101010101010
-- 124:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a10101010101010101010
-- 125:1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a101a1a1a101010101010101010
-- 126:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a10101a101010101010
-- 127:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a101010101010
-- 128:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a101010101010
-- 129:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a10101010
-- 130:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a1010
-- 131:10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a101010
-- 132:1a1a1a1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a10
-- 133:1a1a1a101010101010101010000000000000000000000000000000000010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a1a
-- 134:1a1a1010101010101010101000000000100010000000000000000000000010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a
-- 135:1a1a1a10101010101010101000000010000000100000000000000000000010101010101010101010101010101010101010101010101010101000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100010101010101010101010101010101010101010101010101010101010001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101a1a1a1a1a1a1a
-- </MAP5>

-- <MAP6>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252520000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091919191919191919191910000000000000000000000000000910000000091000000000000000000005252525252525252525252525200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:000000000000000000000000000000000000000000000000000000000000000000009191919191919191919191919191919191919100000000000000000000009100000000000000000000919100000000000000000000000000910000000091000000000000000000525252525252525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:555555555555555555555555555555555555555555555555555555555555555555555400000000000000000000000000000000009191000000000000000000910000000000000000000000009191000000000000000000000000910000000091000000000000000000525252525252525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
-- 004:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091919191919191919191000000000000000000000000000091919191919191919191919191910000000091000000000000000000525252525252525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555555555555555555555000000000000c0000000000000c000000000c000000000000000000000c0000000000000000000c00000000000000000c00000000000000000c00000
-- 005:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091000000000091919191910052525252525252525252525200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055000000000000000000000000000000000000600000000000006000450000600000000000000000000060000000000000000000600000000000000000600000000000000000600000
-- 006:460000000000000000000000000000000000000000000000000000000000000000004600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091000000009191000000009100000000000000525252525200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055000000000000000000000000000000000000600000000000006000450000600000000000000000000060000000000000000000600000000000000000600000000000000000600000
-- 007:5555555555555555555555555555555555555555555555555555555555555555555554919191919191919191919191919191919191919191919191919191919191919191919191919191919191919191919191911200000000000096a6b6c691919191919100006373000091000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055000000000000000000000000000000000000600000000000006000450000600000000000000000000060000000000000000000600000000000000000600000000000000000600000
-- 008:c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c000c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0d09100000000000097a7b7c70000b3c3000000006474000091000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055000000000000000000000000000000000000600000000000006000450000600000000000000000000060000000000000000000600000000000000000600045000000000000600091
-- 009:6060000460006000600060606000601c60606000000060606060000800000000600000606000600000606060006000600000600000600060006060006000006000600060001800006000006000606000601c00d09100839300000098a8b8c80000b4c4000091919191919191000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055000000000000000000000000000000000000600000000000006000450000600000000000000000000060000000000000000000600000000000000000600045000000000000600091
-- 010:6020304050006020304050606020304050606020304050606020304050000020304050600020304050606060203040500000602030405060203040506000203040500060203040506000203040506020304050d0910084940000009191919191919191919100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555555555556262626262626255000000600000450045006000450000000045000000000000000060000000000000000000600000000000000000600045000000004500600091
-- 011:6021314151006021314151606021314151006021314151600021314151000021314151600021314151600060213141510000602131415160213141516000213141510060213141516000213141516021314151d0919191919191919180808080808080808080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000557272727272727255000000000000450045006000450045000045000000000000000000000000000000000000000000000045000000600045000000004500600091
-- 012:600032420000600033430000600032420000000032420000000032420000002732420060000032420060176000324200090060003242006000324200600000324200006000324200000000324200600032420080808080808080808000f000f00000f0000080808080000000000000008080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000557272727272727255000000000000450045004500450045000045000000000000000000000000000000000000000000000045000000000045000000004500600091
-- 013:0000324200000000374700006000324200000000324200000000324200000000324200000000324200000000003242000000600032420060093242006000003242000060003242001b00003242006000324200b0e09000f000f0009000000000000000000000f000008000800000008080f0009000f08080808080808080800000000000000000000000000000000000000000000000000080808080808000000000000000000000000000000000557272727272727255000000000000455252525252525252525252520000000000450000004500000000000000000000000045000000000045000000004500000091
-- 014:99a9324200000000384800000000324200000000324200000000324200000000324200000000324200000000003242000000000032420060003242000000003242000060003242000000003242000000324200b0e0000000000000000000c20000c200c2000000000000809080008080000000c200000000900000f000008080000000000000000000000080808000000000000000000000809000f0008080000000000000000000000000000000557272727272727255000000000000525252525252525252525252520045000000450000004500000000000000450000000045000000000045000000004500000091
-- 015:9aaa3242000000583343000014003242000000003242000a0000324245454545324200000000324200000000003242000000000032420000003242000000003242000000003242000000003242000018324200b0e000a000a000a000a0000000a0000000a00000a0000000000080800000000000000000000000c2000000908080000000000000000000808080808080808000000000000080000000009080800000000000000000000000000000557272727272727255000000000052525252525252525252525252520045000000450000004500000000000000450000000045000000000045000000004500000091
-- 016:7070707070707070707070707070707070707070707070707070707052525252707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070808080808080808080808080808080808080808080808000a00000f000808080800000a00000000000c20000008080808080000000008080f00090008000000000000000008000d200000000800000000000000000000000000000557272727272727255000000000052525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525291
-- 017:000000000000000000000000000000000000000000000000000000557272727255000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008080800000808000008080808080800000c2000000000000f000808000008080000000000080808080808080808080000000000080800000000000000000000080808080808000000000000000000000000052525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252
-- 018:00000000000000000000000000000000000000000000000000000055a4a4a4a4550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000808000000000000000008080000000008080808000000080808080f00000000000000000000000909000000000d2008080000000000000000000000080909090008080000000000000808080808052525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252
-- 019:000000000000000000000000000000000000000000000000000000550000000055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000808080000000000000000000008080a00080800000808000000000000000c2000000808080808080808080808080a000008000000000000000000000000080000000009080800000000080f0f000808052525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252
-- 020:000000000000000000000000000000000000000000000000000000550000000055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080808080000000008000000080808000000000808000000000000000000000808000008080808080808080808000000080000000000000808000000080000080805252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252
-- 021:000000000000000000000000000000000000000000000000000000550000000055000000555555555555555555555555555555555555555555555555555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000008000008000a000a0800000000000000000000000008000a000000000f00000f0008080008080000000000000908080000080000080525252525252525252808080808052525252525252525252525252525252525252525252525252525252525252525252525252525252
-- 022:000000000000000000000000000000000000000000000000000000550000000055000000550000000000000000000000000000000000000000000000000000000000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000a080000080808080808000000000000000000000000080808080808000a00000000090808090000000a000000000f08080808000808080808080525252525280f0f0f08052525252525252525252525252525252525252525252525252525252525252525252525252525252
-- 023:000000000000000000000000000000000000000000000000000000550000000055000000550000000000000000000000000000000000000000000000000000000000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008080800000000000000000000000000000000000000000000000000000808080800000c20000f00000008080800000000000f00000000090009000808052525252800000008052525252525252525252525252525252525252525252525252525252525252525252525252525252
-- 024:0000000000007c7c7c7c7c7c00000000000000000000000000000055000000005500000055000000000000000000000000000000000000000000000000000000000055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080a000000000000000008080800000c20000000000000000000000008052525280800000008080808080808000000000000000000000000000000000000000000000000000000000000000000000
-- 025:0000000000007c000000007c0000000000000000000000000000005500000000550000005500000000000000000000000000000000000000000000000000000000005500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080a00000a0000000a0008080a0000000000000000000000000000080808080800000c200f0f0f0f0f0f0f080000000000000000000000000000000000000000000000000000000000000000000
-- 026:0000000000007c000000007c0000000000000000000000000000005500000000550000005500000000000000000000000000000000000000000000000000000000005500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000808080808080808080808080a00000000000000000c20000000000f00000f000d2e1e1d200000000000080000000000000000000000000000000000000000000000000000000000000000000
-- 027:000000000000ac0000ca007c000000000000000000000000000000550000000055555555550000000000000000000000000000000000000000000000000000000000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008080a000a0000000000000c200000000000000000000d2e1e100d200e1000080808080808080000000000000000000000000000000000000000000000000000000
-- 028:0000000000007c7c7c3b7c7c00000000000000000000000000000055000000000000000000000000000000000000000000000000000000000000000000000000000055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008080808080a00000000000000000000000000000c200d2c200e100c2000000f0000090b2a2000000000000000000000000000000000000000000000000000000
-- 029:000000000000000000000000000000000000000000000000000000550000000000000000000000000000000000000000000000000000000000000000000000000000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000808000a000a0000000000000000000d2e1e1e1e1d200d200c2000000000000b2a2000000000000000000000000000000000000000000000000000000
-- 030:0000000000000000000000000000000000000000000000000000005500000000000000000000000000000000000000000000000000000000000000000000000000005500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080808080808080a000000000000000e1e1d20000c200000000d20000a000b2a2000000000000000000000000000000000000000000000000000000
-- 031:0000000000000000000000000000000000000000000000000000005500000000000000000000000000000000000000000000000000000000000000000000000000005500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080800000a00000a000d2e100d200000000d20000008080808070707000000000000000000000000000000000000000000000000000
-- 032:00000000000000000000000000000000000000000000000000000055555555555555555555555555555555555555555555555555555555555555555555555555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008080808080808080a000000000d20000000000008000000091917070000000000000000000000000000000000000000000000000
-- 033:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008080000000a00000a00000a0008000000000919170700000000000000000000000000000000000000000000000
-- 034:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008080808080808080808080808000000000009191707000000000000000000000000000000000000000000000
-- 035:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091917070000000000000000000000000000000000000000000
-- 036:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000919170700000000000000000000000000000000000000000
-- 037:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009191707000000000000000000000000000000000000000
-- 038:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007070707070707000000000000000000000000000000000707070707070700000000000000070707070707070000000000070707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091917070000000000000000000000000000000000000
-- 039:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000709191919191917070000000000000000000000000000070919191919191917000000000007091919191919170700000000091919191919170700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000919170700000000000000000000000000000000000
-- 040:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070709191919191919170700000000000000000000000007091919191919191919170000000707091919191919191700000000091919191919191707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009191707000000000000000000000000000000000
-- 041:000000000000000000000000000000000000000000000000000000007070707070707070910000000000000070919191919191919170707070910000000000000070707091919191919191919170707070707070707070707070706262626270707070707070707070707000000000000000000000000000000000000070707070707070000000000000000000000000707070707070700000000000000000000000000070707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091917070000000000000000000000000000000
-- 042:000000000000000000000000000000000000000000000000000000007091919191919191919100000000009191919191919191919191919191919100000000009191919191919191919191919191919191919191919191919191917272727291919191919191919191919170000000000000007070707070000000007091919191919170700000000000000000000070919191919191707000000000000000000000007091919191919170700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000919170700000000000000000000000000000
-- 043:000000000000000000000000000000000000000000000000000070709100000000000000000091000000910000000000000000000000000000000091000000910000000000000000000000000000000000000000000000000000917272727291000000000000000000919191700000000000709191919191700000707091919191919191707000000000000000007070919191919191917070000000000000000000707091919191919191707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009191707000000000000000000000000000
-- 044:707070709100000000000000707070000000000000000000007070919100000000000000000000910091000000000000000000000000000000000000910091000000000000000000000000000000000000000000000000000000917272727291000000000000000000009191917000000070919191000091917070707070707070707070707091000000000000007070707070707070707070910000000000000070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707091917070910000000000000070707070
-- 045:919191919191000000000091919170700000000000000000707091910000000000000000000000009100000000000000000000000000000000000000009100000000000000000000000000000000000000000000000000000000917272727291000000000000000000000091917070707070919100000091919191919191919191919191919191910000000000919191919191919191919191919100000000009191919191919191919191919191919191919191919191919191919191919191919191919191919191919191919191919191919191919191919191919191919191919191919100000000009191919191
-- 046:000000000000910000009100009191707000000000000070709191000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000919191919191910000000000000000000000000000000000000000009100000091000000000000000000000000000091000000910000000000000000000000000000000000000000000000000000000000009191000000000000000000000000000000000000000000000000000000000000000000000000000091000000910000000000
-- 047:000000000000009100910000000091919100000000000091919100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000000000000000000000000000000000000000000000000000000000000091009100000000000000000000000000000000910091000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910091000000000000
-- 048:000000000000000091000000000000919191000000000091910000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000910000000000000000000000000000000000009100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009100000000000000
-- 049:000000000000000000000000000000000000910000009100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 050:000000000000000000000000000000000000009100910000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 051:000000000000000000000000000000000000000091000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 052:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 053:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007272727272727272000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 054:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007272727272727272000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 055:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007272727272727272000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 056:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007272727272727272000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 057:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000005555555555555555557272727272727272555555555555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 058:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000005572727272727272727272727272727272727272727272727255000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 059:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000005572727272727272727272727272727272727272727272727255000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 060:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000005572727272727272727272727272727272727272727272727255000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 061:550000000000000000555555550000000000000000555555555500000000000000555555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000005572727272727272727272727272727272727272727272727255000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555555
-- 062:555500000000000055550000555500000000000055550000005555000000000055550000005555000000000000005555555555000000000000555555555555000000000000000055555555555555000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000005572727272727272727272727272727272727272727272727255000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055550000
-- 063:005555000000005555000000005555000000005555000000000055550000005555000000000055550000000000555500000055550000000055550000000055550000000000005555000000000055550000000000555555555555910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000005572727272727272727272727272727272727272727272727255000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555000000000000005555000000
-- 064:000055550000555500000000000055550000555500000000000000555500555500000000000000555500000055550000000000555500005555000000000000555500000000555500000000000000555500000055550000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000005572727272727272727272727272727272727272727272727255000000000000000000000000000000000000000000000000000000000000000055555555000000000000005555000055550000000000555500000000
-- 065:000000555555550000000000000000555555550000000000000000005555550000000000000000005555005555000000000000005555555500000000000000005555000055550000000000000000005555555555000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000005572727272727272727272727272727272727272727272727255000000005555555500000000000000000000005555555555000000000000005555000055550000000000555500000000555500000055550000000000
-- 066:000000000000000000000000000000000000000000000000000000000055000000000000000000000055555500000000000000000000000000000000000000000055555555000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000005572727272727272727272727272727272727272727272727255000000555500005555000000000000000000555500000055550000000000555500000000555500000055550000000000005555005555000000000000
-- 067:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000005572727272727272727272727272727272727272727272727255000055550000000055550000000000000055550000000000555500000055550000000000005555005555000000000000000055555500000000000000
-- 068:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555000000000000000000555555555500000000000000000055555555550000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000005572727272727272727272727272727272727272727272727255005555000000000000555500000000005555000000000000005555555555000000000000000055555500000000000000000000000000000000000000
-- 069:000000000000000000005555550000000000000000000000000055550000000000000000000000005555550000000000000000005555000055550000000000000055550000005555000000000000005555000000555500000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000005500000000000000000000000000000000000000000000000055555500000000000000005555000000005500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 070:000000000000000000555500555500000000000000000000005500005500000000000000000000550000555500000000000000555500000000555500000000005555000000000055550000000000555500000000005555000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000005500000000000000000000000000000000000000000000000055550000000000000000000055550000555500000000000000000000000000000000000000000000000000000000000000000000000000005555555500
-- 071:000000000000000055550000005555000000000000000000550000000055000000000000000055000000005555000000000055550000000000005555000000555500000000000000555500000055550000000000000055550000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000005500000000000000000000000000000000000000000000005555000000000000000000000000555555550000000000000000000000000000000000000000000000555555550000000000000000000000555500005555
-- 072:550000000000005555000000000055550000000000000055000000000000550000000000005500000000000055550000005555000000000000000055555555550000000000000000005555005555000000000000000000555500910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000005555555500000000000000000000005500000000000000000000000000000000000000000000000055000000000000000000000000000000000000000000000000555555000000000000000000000055550000555500000000000000000055550000000055
-- 073:555500000000555500000000000000555500000000005500000000000000005500000000550000000000000000555500555500000000000000000000000000000000000000000000000055555500000000000000000000005555910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000550000000055000000000000000000005500000000000000000000000000000000000000000000000055000000000000000000000000550000000000000000000055550055550000000000000000005555000000005555000000000000005555000000000000
-- 074:005555000055550000000000000000005555000000550000000000000000000055000055000000000000000000005555550000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000055000000000000550000000000000000005500000000000000000000000000000000000000000000000055000000000000000000000055555500000000000000005555000000555500000000000000555500000000000055550000000000555500000000000000
-- 075:000055555555000000000000000000000055555555000000000000000000000000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000005500000000000000005500000000000000005500000000000000000000000000000000000000000000000000000000000000000000005500005555000000000000555500000000005555000000000055550000000000000000555500000055550000000000000000
-- 076:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000550000000000555500000055555555555555555500000000000000000000000000000000000000000000000000000000000000000000550000000055550000000055550000000000000055550000005555000000000000000000005555005555000000000000000000
-- 077:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000055000000000055555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055000000000000555500005555000000000000000000555500555500000000000000000000000055555500000000000000000000
-- 078:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000005500000000005555000055550000000000000000000000000000000000000000000000000000000000000000000000000000000000005500000000000000005555555500000000000000000000005555550000000000000000000000000000000000000000000000000000
-- 079:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000550055555555555500000000555555555500000000000000000000005555555555555555550000555555555555555555555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 080:000000555555555555555555555555555555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000055555555550000000000000000000000005555000000005555550000555500000000000000550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 081:000055550000000000000000000000000000000055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000055555500000000000000000000000055555555555500550000550000000000000000550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 082:005555000000000000000000000000000000000000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000555555000000000000000000000000000000000000550000550000000000000000550000550000000000000000000000000000000000000000000000005555555500000000005555555500000000000000005555550000000000555555000000000055555500000000
-- 083:555500000000000000000000000000000000000000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252520000000000000000000000000000000000550055550000000000000000000000000000000000550000550000000000000000550000555555555555555555555555550000000055555555550000555500005555000000555500000055555555000000555500555500000055550055550000005555000055000000
-- 084:550000000000000055550000000000000000000000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252520000000000000000000000000000000000550000555500000000000000000000000000000000550000550000000000000000550000555500000000000000000000555500005555000000555555550000000055555555550000000000000055550055550000005555005555000000555555555500000000550055
-- 085:000000000000005500555500000000000000000055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000000000000000000000000000555500005555000000000000000000000000000000550000550000000000000000550000000000000055555555550000005555555500000000000000000000000000000000000000000000000000555555000000000055555500000000000000000000000000005555
-- 086:000000000000550000005555000000000000000055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000000000000000000000000000005555000055550000000000000000000000000000550000550000000000000000550000000000005555000000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 087:000000000055000000000055550000000000005555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000000000000000000000000000000055550000555555550000000000000000000000550000550000000000000000555500000000555500000000005555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 088:000000005500000000000000555500000000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000000000000000000000000000000000555500000000555500000000000000000000550000550000000000000000005555555555550000000000000055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 089:555555550000000000000000005555000055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000000000000000000000000000000000005555555555005555000000000000000000550000550000000000000000000000000000000000000000000000555500000055555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
-- 090:000000000000000000000000000055555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000000000000000000000000000000000000000000055550055000000000000000000550000550000000000000000000000000000000000000000000000005555005555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 091:000000000000000000000000000000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000000000000000000000000000000000000000000000550055000000000000000000550000550000000000000000000000000000000000000000000000000055555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 092:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000000000000000000000000000000000000000000000550055000000000000000000550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 093:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000000000000000000000000000000000000000000000550055000000000000000000550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 094:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000000000000000000000000000000000000000000000550055000000000000000000550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 095:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000000000000000000000000000000000000000000000550055000000000000000000550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 096:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000000000000000000000000000000000000000000000550055000000000000000000550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 097:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000000000000000000000000000000000000000000000550055000000000000000000550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 098:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000000000000000000000000000000000000000000000550055000000000000000000550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 099:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000000000000000000000000000000000000000000000550055000000000000000000550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 100:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000525252525252525252525252520000000000000000000000000000000000000000000000000000550055000000000000000000550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 101:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000525252525252525252525252520000000000000000000000000000000000000000000000000000550055000000000000000000550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 102:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000525252525252525252520000000000000000000000000000000000000000000000000000000000550055000000000000000000550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 103:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000525252525252525252520000000000000000000000000000000000000000000000000000000000550055000000000000000000550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 104:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000525252525252525252525252520000000000000000005555550000000000000000000000000000550055000000000000000000550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 105:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009100000000910000000000000000005252525252525252525252525200000000000000005555005555000000000000000000000000005500550000000000000000005599a9550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 106:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000525252525252525252525252520000000000000055550000005555000000000000000000000000550055000000000000000000559aaa550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 107:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000005555000000000055550000000000000000000000550055000000000000000000555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 108:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000000555500000000000000555500000000000000000000550055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 109:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000000525252525252525252520000000055550000000000000000005555000000000000000055550000555555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 110:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252520000005555000000000000000000000055555555555555555555000000000000005555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 111:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000555500000000000000000000000000000000000000000000000000000000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 112:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000055550000000000000000000000000000000000000000000000000000000055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 113:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252005555000000002300230000000000000000000000000000000000000000005555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 114:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252555500000000220022000000000000000000000000000000000000000000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 115:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525255555555555555555555555555555555555555555500000000000000000055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 116:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000055000000000000005555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 117:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000550000000000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 118:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000005500000055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 119:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000055005555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 120:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 121:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091000000009100000000000000000000007d7d7d7d7d7d7d7d7d7d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 122:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091000000009100000000000000000000007d005b5b0000005b5b7d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 123:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091000000009100000000000000000000007d005b5b0000e7f75b7d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 124:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091000000009100000000000000000000007d005b5b005ee8f85b7d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 125:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091000000009100000000000000000000007d005b5b0000005b5b7d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 126:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091000000009100000000000000000000007d005b5b0000005b5b7d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 127:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091000000009100000000000000000000007d005b5b0000005b5b7d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 128:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091000000009100000000000000000000007d7d7d7d7d7d7d7d7d7d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 129:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 130:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 131:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 132:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 133:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 134:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 135:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000910000000091000000000000000000000052525252525252525252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP6>

-- <MAP7>
-- 000:0000000091a100000000000000000000000000b7c70000000000000091a1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000526252625262031303130313031303130303131303130313031352625262526200000000
-- 001:0000000092a200000000000000000000000000b7c70000000000000092a2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000031302120212021202120202121202120212021200000000000000000000
-- 002:0000000091a100000000000000000000000000b7c70000000000000092a2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021203130313031303130302121303130313031300000000000000000000
-- 003:0000000092a200000000000000000000000000b6c60000000000000091a1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000031302120212021202120203131202120212021200000000000000000000
-- 004:0000000091a100000000000000000000000000b7c70000000000000092a2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021203130313031303130313031303130313031300000000000000000000
-- 005:0000000092a200000000000000000000000000b7c70000000000000091a1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021202120212021202120212021202120212021200000000000000000000
-- 006:0000000091a100000000000000000000000000b7c70000000000000092a2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000031303130313031303130313031303130313031300000000000000000000
-- 007:0000000092a200000000000000000000000000b6c60000000000000091a1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:0000000091a100000000000000000000000000b7c70000000000000092a2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:0000000091a100000000253545000031410000b6c60000000000000091a1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:0000000092a20000200026364600003242000028380000000000000092a2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:00000000b1c1001121a32737473343536373832939a700009080e4f491a1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:00000000b2c2000022a4b400003444546474840098a800008696e5f592a2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:0000d1e17181718171817181718171817181718171817181718171817181000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:0000d2e27282728272827282728272827282728272827282728272827282000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161516151615161
-- 016:526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262526252625262
-- 122:000000000000000000000000000000007171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 123:000000000000000000000000000000007272000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 124:000000000000000000000000000000718171810000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 125:000000000000000000000000000000728272820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000516151615161516151615161000000000000000000000000
-- 126:00000000000000000000000000718171a071817181000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000526252625262526252625262000000000000000000000000
-- 127:000000000000000000000000007282728272827282000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000059690000000000000000000000000000000000
-- 128:000000000000000000000071817100000000000081718100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000059690000000000000000000000000000000000
-- 129:00000000000000000000007282720000000000008272820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005a6a0000000000000000000000000000000000
-- 130:00000000000000000071817181710000000000000000817181000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005a6a0000000000000000000000000000000000
-- 131:00000000000000000072827282720000000000000000827282000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005a6a0000000000000000000000000000000000
-- 132:00000000000000718171812b3bdaea000d1d0000000b1b00817181000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000059000000000000000000000000000000000000
-- 133:00000000000000728272822c3cdbeb000e1e0000000c1c00827282000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 134:00000000007181718171817181718171817181b6c6718171817181718100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 135:00000000007282728272827282728272827282b7c7728272827282728200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000516151615161021202120212021202120202121202120200001251615161516100000000
-- </MAP7>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <FLAGS>
-- 000:00000010101000101000001010000000000000101010101008080008000000000000001808101010101010080808080808000008081000000000000000000000100000080000000000080808001010001000000808101000000000000010100000000000001000000000000000000000000000100800000000000008080808000000000000000000000000000000000000000010080808080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </FLAGS>

-- <PALETTE>
-- 000:000000814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc94199e273eff7f4f4f494b0c2ae6900333c57
-- </PALETTE>

-- <PALETTE1>
-- 000:000000814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900333c57
-- </PALETTE1>

-- <PALETTE2>
-- 000:000000814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900333c57
-- </PALETTE2>

-- <PALETTE3>
-- 000:000000814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900333c57
-- </PALETTE3>

-- <PALETTE4>
-- 000:000000814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900333c57
-- </PALETTE4>

-- <PALETTE5>
-- 000:000000814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900333c57
-- </PALETTE5>

-- <PALETTE6>
-- 000:000000814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900333c57
-- </PALETTE6>

-- <PALETTE7>
-- 000:000000814085b13e53ef6557ffcaa1a7f07038b764ffe60429366f3b5dc941a6f673eff7f4f4f494b0c2ae6900333c57
-- </PALETTE7>

