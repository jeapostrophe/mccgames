-- title: Jackmon
-- author: Balistic Ghoul Studios
-- desc:  A game like pokemon (See PICO-8 for my other games)
-- script: lua
DEBUG=true

B_OK=5
B_BACK=4

ACTIVE_MONS=4

scene=nil

function TIC()
 scene()
end

function draw_box(mx,my,tw,th)
 rect(mx+4,my+4,tw*8-4,th*8-4,0)
	for i=1,tw-1 do
	 spr(269,mx+8*i,my,-1)
		spr(301,mx+8*i,my+8*th,-1)
	end
	for i=1,th-1 do
	 spr(284,mx,my+8*i,-1)
		spr(286,mx+8*tw,my+8*i,-1)
	end
	spr(268,mx,my,6)
	spr(300,mx,my+8*th,6)
	spr(270,mx+8*tw,my,6)
	spr(302,mx+8*tw,my+8*th,6)
end

function start_title() 
 scene=sc_title
end
function sc_title()
	cls(0)
	map(0,0)
	print("Press X",11*8,14*8)
	if btnp(B_OK) then
		start_explore()
	end
end

function tablesAndStuff() end

rooms={}
roomn=nil
room=nil
exitn=nil

player={ spr=260  -- *** change later
       , i_hp=0
							, i_max=0
							, i_swim=0
							, i_rock=0
							, i_file=0
							, i_bonus=0
							, flp=false }

mons={}
play_mons={}
seen_mons={}
active_mons={}

function healthy_mons()
 for mn,mi in pairs(active_mons) do
	 return true
	end
	return false
end

function get_mon(mn)
 play_mons[mn]= { hp=mons[mn].hp
	               , xp=mons[mn].xp }
	seen_mons[mn]=true
end

function start_explore() 
 scene=sc_explore
 if not DEBUG then
	  enter_room(2,1)
 else
	  enter_room(4,1)
	end
end

function enter_room(rn,en)
 room=rooms[rn]
	if room.weird then
	 room.ext[room.weird].r=roomn
		room.ext[room.weird].e=exitn
	end
 roomn=rn
	ent=room.ent[en]
	player.x=ent.px-room.mx
	player.y=ent.py-room.my
end

function draw_explore()
	cls(0)
	map(room.mx,room.my)
	if DEBUG then print("ROOM #"..roomn) end
	p=player
	spr(p.spr,p.x*8,p.y*8,0)
end

function sc_explore()
	draw_explore()
				
	function move(dx,dy)
	 nx=p.x+dx
		ny=p.y+dy
		mnx=room.mx+nx
		mny=room.my+ny
		if room.ext then
		for ei,e in ipairs(room.ext) do
		 if mnx==e.x and mny==e.y then
			 exitn=ei
			 enter_room(e.r,e.e)
				return
			end
		end
		end
		local mt=mget(mnx,mny)
		local cliff=fget(mt,2)
		if (fget(mt,1) and not healthy_mons()) then
			scene=mk_sc_obj(act_msg("You can't go in there!")(room,nil))
		elseif (not fget(mt,0))
		   and (not cliff or dy==1)
					and (not fget(mt,3) or p.i_rock>0)
					and (not fget(mt,4) or p.i_swim>0)
		then
		 p.x=nx
			if cliff then ny=ny+1 end
			p.y=ny
			
			if fget(mt,1) then
			 if math.random() <= 0.1 then
   		scene=mk_sc_obj(act_msg("A wild mon approaches!")(room,nil))
				 return
				end
			end
			
			return
		end
		--- XXX add a bump sound
	end
	if btnp(0,1,10) then move(0,-1) end
	if btnp(1,1,10) then move(0,1) end
	if btnp(2,1,10) then move(-1,0) end
	if btnp(3,1,10) then move(1,0) end
	
	if btnp(B_BACK) then start_menu() end
	
	if btnp(B_OK) and room.obj then
	 for oi,o in ipairs(room.obj) do
		 if o.x==room.mx+p.x and o.y==room.my+p.y-1 then
			 scene=mk_sc_obj(o.a(room,oi))
				return
			end
  end
	end
end

function mk_sc_obj(draw_obj)
 return function()
  draw_explore()
	 local obj_done = draw_obj()
	 if btnp(B_BACK) or obj_done then 
		 scene=sc_explore
		end
 end
end

function act_msg(m)
 return function(_r,_oi)
	 return function()
	  local mx=1
		 local my=15*8-1
	  local w=(string.len(m)+2)*5+2
		 draw_box(mx,my,math.ceil((w)/8),1)
	  print(m,mx+3,my+6,15)
		end
	end
end

have_starter=false
function act_starter(mn)
 return function(r,oi)
	 if have_starter then
		 return act_msg("Urm, you already have a starter.")(r,oi)
		else
	  local m="It's a " .. mons[mn].name .. ", choose it?"
	  local mf=act_msg(m)(r,oi)
	  return function()
    mf()
				if btnp(B_OK) then
				 have_starter=true
					get_mon(mn)
					return true
				end
		 end
		end
	end
end

function act_ani(m)
 return function(r,oi)
	 local mf=act_msg(m)(r,oi)
		local o=r.obj[oi]
		local t=10
		local m=0
	 return function()
   mf()
			local f=nil
			if m<o.a_s_l then 
			 f=o.a_s_s-m
			 t=t-1
				if t==0 then
				 m=m+1
					t=10
				end
			else
			 local mm=m-o.a_s_l
			 f=o.a_m_s+mm
				t=t-1
				if t==0 then
				 m=o.a_s_l+(mm+1)%o.a_m_l
					t=10
				end
			end
			spr(f,(o.x-room.mx)*8,(o.y-room.my)*8,-1)
  end
	end
end

mpos=nil
function start_menu() 
 scene=sc_menu
	mpos=0
end
function sc_menu()
 draw_explore()
	
	local 
	 mx=20*8
		my=2*8
		Mmax=#menu
	
	draw_box(mx,my,6,Mmax)
	for i=1,#menu do 
	 print(menu[i].lab,mx+4+8,my-2+8*i)
	end
	spr(285,mx-4+8,my-4+8*(1+mpos),0)

 function move(dm)
	 mpos=(mpos+dm)%Mmax
	end
	if btnp(0,1,10) then move(-1) end
	if btnp(1,1,10) then move(1) end
	
	if btnp(B_BACK) then scene=sc_explore end
	if btnp(B_OK) then menu[mpos+1].a() end
end

itms=
	 { i_hp={480,"HP token"}
		, i_rock={481,"TM Rock Break"} --Yep, I do "rock"... get it?
		, i_swim={482,"TM Swim"}
		, i_max={483,"Max HP token"}
		, i_bonus={484,"Power up token"}
		, i_file={485,"Capture File"} } 

function act_itm(i)
 return function(room,oi)
	 room.obj[oi].a=act_msg("Nothing's here")
	 player[i]=player[i]+1
		return act_msg("You found a " .. itms[i][2] .. "!")(room,oi)
 end
end

function start_itms()
 scene=sc_itms
end
function sc_itms()
 draw_explore()
	local p=player

	local 
	 mx=20*8
		my=2*8
		
	--- XXX Why not #itms?
	local Mmax=0
	for itc,iti in pairs(itms) do
	 Mmax=Mmax+1
	end
	
	draw_box(mx,my,3,Mmax)
	local i=1
	for itc,iti in pairs(itms) do
	 spr(iti[1],mx+8,my-4+8*i)
		print(p[itc],mx+8+10,my-2+8*i)
		i=i+1
	end
	
	if btnp(B_BACK) then scene=sc_menu end
end

function start_select_active_mon()
 scene=sc_select_active_mon
	sam_idx=0
end
function sc_select_active_mon()
 draw_explore()

	local i=0
	local mn=nil
	for mn_,mi_ in pairs(play_mons) do
	 mn=mn_
	 if i == sam_idx then break end
	 i=i+1
	end
	if not mn then
	 scene=sc_mons
		return
	end
	
	local 
	 mx=5*8
		my=3*8
		mw=16
		mh=5
	
	draw_box(mx,my,mw+1,mh+1)
	spr(400+mn, mx+5, my+5, 0, 4)	

 function move(dm)
	 sam_idx=(sam_idx+dm)%(#play_mons+1)
	end
	if btnp(2,1,10) then move(-1) end
	if btnp(3,1,10) then move(1) end

 if btnp(B_OK) then
	 active_mons[mn]=true
		scene=sc_mons
	end
	if btnp(B_BACK) then scene=sc_mons end
end

mons_idx=nil
function start_mons()
 scene=sc_mons
	mons_idx=0
end
function sc_mons()
 draw_explore()

	local 
	 mx=5*8
		my=3*8
		mw=16
		mh=(ACTIVE_MONS*2)-1
	
	draw_box(mx,my,mw+1,mh+1)
	for i=0,ACTIVE_MONS-1 do
	 print((i+1), mx+5+8, my+5+(i*2)*8+4)
	end
	local i=0
	for mn,_ in pairs(active_mons) do
	 spr(400+mn, mx+5+8+3, my+i*8, 0, 3.5)
		print("HP: "..play_mons[mn].hp, mx+5+8+3+8*4, my+8+i*8)
		print("XP: "..play_mons[mn].xp, mx+5+8+3+8*4, my+8+i*8+8)
	 i=i+1
	end
	
	spr(285, mx+5, my+5+(mons_idx*2)*8+2)

 function move(dm)
	 mons_idx=(mons_idx+dm)%ACTIVE_MONS
	end
	if btnp(0,1,10) then move(-1) end
	if btnp(1,1,10) then move(1) end

 if btnp(B_OK) then start_select_active_mon() end
	if btnp(B_BACK) then scene=sc_menu end
end

function start_dex()
 scene=sc_dex
end
function sc_dex()
 draw_explore()

	local 
	 mx=5*8
		my=3*8
		mw=16
		mh=5
	
	draw_box(mx,my,mw+1,mh+1)
	for i=0,mh-1 do
	 for j=0,mw-1 do
		 local mn=i*mw+j
			if mn>=74 then
			 break
			end
			local mmx=mx+(j+1)*8
			      mmy=my+(i+1)*8
			local sn=501
			if seen_mons[mn] then
			 sn=monspr(mn)
			end
		 spr(sn,mmx,mmy,0)
			if play_mons[mn] then
			 spr(502,mmx,mmy,0)
			end
		end
	end
 	
	if btnp(B_BACK) then scene=sc_menu end
end

menu={{lab="ITEMS",a=start_itms}
     ,{lab="MONS",a=start_mons}
					,{lab="DEX",a=start_dex}}

function monspr(mn) return 400+mn end

function MonTables() end

e_poison=1
e_paralize=2
e_ink=3
e_confuse=4
e_burn=5
e_bonus=6
e_sleep=7
e_hallucinate=8
e_vampire=9

t_water="Water"
t_grass="Grass"
t_fire="Fire"
t_normal="Normal"
t_earth="Earth"
t_spirit="Spirit"
t_corrupt="Corrupt"
t_dragon="Dragon"
t_air="Air"

atk_grass={name="Razor Leaf", type=t_grass,
           dmg=30, s=488, e=nil}

atk_poison={name="Poison Spit", type=t_corrupt,
           dmg=10, s=505, e=e_poison}

atk_fire={name="Flamethrower", type=t_fire,
           dmg=30, s=486, e=e_poison}
											
atk_air={name="Tornado", type=t_air,
           dmg=30, s=493, e=nil}
											
atk_bubble={name="Bubble Beam", type=t_water,
           dmg=30, s=487, e=nil}

atk_bite={name="Bite", type=t_normal,
           dmg=30, s=504, e=nil}
										
atk_dragon={name="Dragon Pulse", type=t_dragon,
           dmg=50, s=510, e=e_confuse}
											
atk_zap={name="Thunder Bolt", type=t_air,
           dmg=30, s=492, e=a_paralize}
											
atk_Cfire={name="Corrupted Flame", type=t_corrupt,
           dmg=30, s=489, e=e_burn}
											
atk_Cbubble={name="Corrupted Bubble Beam", type=t_corrupt,
           dmg=30, s=490, e=nil}
											
atk_punch={name="Karate Chop", type=t_earth,
           dmg=40, s=494, e=e_confuse}
										
atk_rock={name="Rock Throw", type=t_earth,
           dmg=40, s=495, e=nil}
											
atk_fear={name="Scary Face", type=t_normal,
           dmg=nil, s=506, e=e_ink}
											
atk_cut={name="Slash", type=t_normal,
           dmg=30, s=507, e=nil}
											
atk_swipe={name="Fury Swipes", type=t_normal, --This ATK can happen between 1-4 times in arow
           dmg=50, s=508, e=nil} --Ok this one is weird, It technacly has Two diffrent ATK spries but for now I'll Just put down one

atk_vamp={name="Vampire Bite", type=t_corrupt,
           dmg=20, s=479, e=e_vamp}

-----------------------------------------------------------
------------------------MONS-------------------------------
-----------------------------------------------------------

mons[0]={name="Blobb", hp=60, xp=100, types={t_grass},
         atks={{atk_grass,1}, {atk_poison,0.5}}}

mons[1]={name="Blobbo", hp=100, types={t_grass},
         atks={{atk_grass,2}, {atk_poison,1}}}
									
mons[2]={name="Blord", hp=140, types={t_grass},
         atks={{atk_grass,3}, {atk_poison,2}}}

mons[3]={name="Flegg", hp=50, xp=100, types={t_fire},
         atks={{atk_fire,1}, {atk_air,1}}}
									
mons[4]={name="Fyrunt", hp=90, types={t_fire},
         atks={{atk_fire,1}, {atk_bite,1}}}
									
mons[5]={name="Fyroar", hp=130, types={t_dragon},
         atks={{atk_fire,1}, {atk_bite,2}}}

mons[6]={name="Pirrah", hp=60, xp=100, types={t_water},
         atks={{atk_bubble,1}, {atk_bite,1}}}
									
mons[7]={name="Pirrachomp", hp=100, types={t_water},
         atks={{atk_bubble,2}, {atk_bite,2}}}
									
mons[8]={name="Pirgnash", hp=140, types={t_water},
         atks={{atk_bubble,3}, {atk_bite,2}}}
									
mons[9]={name="Bater", hp=40, types={t_corrupt},
         atks={{atk_vamp,1}, {atk_bite,1}}}
									
mons[10]={name="Batger", hp=80, types={t_corrupt},
         atks={{atk_vamp,2}, {atk_bite,2}}}
									
mons[11]={name="GIode", hp=60, types={t_earth},
         atks={{atk_punch,1}, {atk_rock,1}}}
									
mons[12]={name="GIger", hp=100, types={t_earth},
         atks={{atk_punch,2}, {atk_rock,2}}}
									
mons[13]={name="Cink", hp=40, types={t_normal},
         atks={{atk_swipe,1}, {atk_fear,1}}}
									
mons[14]={name="Compi", hp=80, types={t_normal},
         atks={{atk_swipe,2}, {atk_fear,1}}}
									
mons[15]={name="Coglow", hp=40, types={t_earth},
         atks={{atk_rock,1}, {atk_zap,1}}}
									
mons[16]={name="Reapo", hp=60, types={t_spirit},
         atks={{atk_cut,1}, {atk_vamp,1}}}
									
mons[17]={name="Reaplur", hp=100, types={t_spirit},
         atks={{atk_cut,2}, {atk_vamp,1}}}
									
mons[18]={name="Potlil", hp=60, types={t_grass},
         atks={{atk_grass,1}, {atk_bite,1}}}
									
mons[19]={name="Venaomp", hp=100, types={t_grass},
         atks={{atk_poison,1}, {atk_bite,1}}}

mons[24]={name="Toxobb", hp=60, types={t_corrupt},
         atks={{atk_poison,1}}}

function RoomTables() end

rooms[1]={  
 mx=0,
	my=17,
	obj={
	[1]={
  x=1,
		y=29,
		a=act_msg("The Lab")
	},
	[2]={
	 x=26,
		y=22,
		a=act_msg("The Woods->")
	},
	[3]={
	 x=16,
		y=30,
		a=act_msg("MT. Monsa -V")
	} },
	ent={
	 [1]={
	  px=13,
		 py=21
			},
	 [2]={
	  px=2,
		 py=29
			},
	 [3]={
	  px=14,
		 py=33
			},
	 [4]={
	  px=29,
		 py=20
		} },
		ext={
		 [1]={
			 x=13,
				y=21,
				r=3,
				e=2
				},
			[2]={
			 x=2,
				y=28,
				r=4,
				e=1 },
			[3]={
			 x=14,
				y=33,
				r=5,
				e=1 },
			[4]={
			 x=29,
				y=20,
				r=13,
				e=1 }
		}
}

rooms[2]={ 
  mx=30,
	 my=17,
		obj={
		 [1]={
			 x=40,
				y=24,
				a_s_s=367,
				a_s_l=3,
				a_m_s=356, --356 for lv 1 372 for lv 2
				a_m_l=9,
				a=act_ani("15 Edition game station. From DAD.")
			}
		},
		ent={
		 [1]={
		  px=44,
		  py=26
			 },
			[2]={
			 px=41,
				py=22
			} },
	 ext={
		 [1]={
			 x=41,
				y=22,
				r=3,
				e=1
			} }
}

rooms[3]={ 
  mx=60,
	 my=17,
		obj={
		 [1]={
			 x=78,
				y=23,
				a=act_msg("'And on todays action news...'")
			} },
	 ent={
		 [1]={
		  px=75,
		  py=21
				},
			[2]={
			 px=75,
				py=28
			} },
		ext={
		 [1]={
			 x=75,
				y=28,
				r=1,
				e=1
			},
			[2]={
			 x=75,
				y=21,
				r=2,
				e=2 }
		} 
}

rooms[4]={ 
  mx=0,
	 my=34,
		obj={
		 [1]={
			 x=13,
				y=39,
				a=act_starter(0)},
			[2]={
			 x=14,
				y=39,
				a=act_starter(3)},
			[3]={
			 x=15,
				y=39,
				a=act_starter(6)}},
		ent={
		 [1]={
		  px=14,
		  py=47
			} },
		ext={
		 [1]={
			 x=14,
				y=47,
				r=1,
				e=2
			} }
}

rooms[5]={ 
  mx=0,
	 my=51,
		obj={
		 [1]={
			 x=27,
				y=65,
				a=act_itm("i_hp")
			}
		},
		ent={
		 [1]={
		  px=14,
		  py=51
			 },
			[2]={
			 px=24,
				py=56
			} },
		ext={
		 [1]={
			 x=14,
				y=51,
				r=1,
				e=3
				},
			[2]={
			 x=24, 
				y=56,
				r=6,
				e=1
			} }
}

rooms[6]={ 
  mx=30,
	 my=34,
		obj={
		[1]={
		 x=47,
			y=46,
			a=act_itm("i_rock")
		}},
		ent={
		 [1]={
		  px=32,
		  py=43
				},
			[2]={
			 px=59,
				py=45
			} },
		ext={
		 [1]={
			 x=32,
				y=43,
				r=5,
				e=2
			},
			[2]={
			 x=59,
				y=45,
				r=7,
				e=1
			} }
}

rooms[7]={ 
  mx=60,
	 my=34,
		ent={
		 [1]={
		  px=60,
		  py=45
				},
			[2]={
			 px=87,
				py=42
			} },
		ext={
		 [1]={
		  x=60,
			 y=45,
			 r=6,
			 e=2
		 },
			[2]={
			 x=87,
				y=42,
				r=8,
				e=1
			} } 
}

rooms[8]={
 mx=30,
	my=51,
	obj={
	 [1]={
	  x=58,
		 y=61,
		 a=act_msg("The PLains -V")},
		[2]={
		 x=46,
			y=53,
			a=act_itm("i_max")
		} },
	ent={
	 [1]={
		 px=33,
			py=56
			},
		[2]={
		 px=57,
			py=67
		} },
	ext={
		[1]={
		 x=33,
			y=56,
			r=7,
			e=2
			},
		[2]={
		 x=57,
			y=67,
			r=9,
			e=1
		} }
}

rooms[9]={ 
  mx=90,
	 my=34,
		obj={
		[1]={
		 x=98,
		 y=38,
		 a=act_msg("HEALTH CENTER")},
		[2]={
		 x=101,
			y=36,
			a=act_itm("i_file")
		} },
		ent={
		 [1]={
		  px=93,
		  py=34},
			[2]={
			 px=96,
				py=38},
			[3]={
			 px=117,
				py=50
			} },
		ext={
		 [1]={
			 x=93,
				y=34,
				r=8,
				e=2
			},
			[2]={
			 x=96,
				y=37,
				r=24,
				e=1
			},
			[3]={
			 x=117,
				y=50,
				r=10,
				e=1
			} }
}

rooms[10]={ 
  mx=30,
	 my=68,
		obj={
		[1]={
		 x=57,
			y=81,
			a=act_itm("i_hp")
		} },
		ent={
		 [1]={
		  px=57,
		  py=68},
			[2]={
			 px=30,
				py=75} },
		ext={
		 [1]={
			 x=57,
				y=68,
				r=9,
				e=3
			},
			[2]={
			 x=30,
				y=75,
				r=11,
				e=2
			} } 
}

rooms[11]={ 
  mx=0,
	 my=68,
		obj={
		[1]={
		 x=7,
			y=74,
			a=act_itm("i_max")
		} },
		ent={
		 [1]={
		  px=12,
		  py=68
				},
			[2]={
			 px=29,
				py=75
				},
			[3]={
			 px=17,
				py=84
			} },
		ext={
		 [1]={
			 x=12,
				y=68,
				r=12,
				e=2
			},
			[2]={
			 x=29,
				y=75,
				r=10,
				e=2
			},
			[3]={
			x=17,
			y=84,
			r=14,
			e=1
			} } 
}

rooms[12]={ 
  mx=60,
	 my=51,
		ent={
		 [1]={
		  px=61,
		  py=51
				},
			[2]={
			 px=76,
				py=67
			} },
		ext={
		 [1]={
			 x=76,
				y=67,
				r=11,
				e=1
			},
			[2]={
			 x=61,
				y=51,
				r=13,
				e=2
			} }
}

rooms[13]={ 
  mx=90,
	 my=17,
		obj={
		 [1]={
		 x=116,
		 y=30,
		 a=act_msg("The Beach -V")},
			[2]={
			 x=97,
			 y=22,
				a=act_itm("i_swim") }},
		ent={
		 [1]={
		  px=90,
		  py=20},
			[2]={
			 px=115,
				py=33
			} },
		ext={
		 [1]={
			 x=90,
				y=20,
				r=1,
				e=4
			},
			[2]={
			 x=115,
				y=33,
				r=12,
				e=1
			} }
}

rooms[14]={ 
  mx=60,
	 my=68,
		obj={
		 [1]={
			 x=65,
				y=77,
				a=act_msg("HEALTH CENTER")	},
			[2]={
			 x=85,
				y=71,
				a=act_itm("i_file")
			} },
		ent={
		 [1]={
		  px=73,
		  py=68},
			[2]={
			 px=66,
				py=77},
			[3]={
			 px=85,
				py=84
			} },
		ext={
		 [1]={
			 x=73,
				y=68,
				r=11,
				e=3
			},
			[2]={
			 x=66,
				y=76,
				r=24,
				e=1
			},
			[3]={
			 x=85,
				y=84,
				r=15,
				e=1
			} }
}

rooms[15]={ 
  mx=90,
	 my=68,
		obj={
		 [1]={
		  x=118,
		  y=71,
		  a=act_itm("i_hp")
		 },
			[2]={
			 x=109,
				y=77,
				a=act_itm("i_bonus")
			} },
		ent={
		 [1]={
		  px=93,
		  py=68
			},
			[2]={
			 px=109,
				py=84},
			[3]={
			 px=114,
				py=76
			},
			[4]={
			 px=119,
				py=78
			} },
		ext={
		 [1]={
			 x=93,
				y=68,
				r=14,
				e=3
			},
			[2]={
			 x=109,
				y=84,
				r=16,
				e=1
			},
			[3]={
			 x=114,
				y=76,
				r=19,
				e=1
			},
			[4]={
			 x=119,
				y=78,
				r=18,
				e=2
			} }
}

rooms[16]={ 
  mx=90,
	 my=85,
		obj={
		 [1]={
			 x=115,
				y=98,
				a=act_msg("HEALTH CENTER")},
			[2]={
			 x=114,
				y=86,
				a=act_itm("i_file")
			} },
		ent={
		 [1]={
		  px=109,
		  py=85
				},
			[2]={
			 px=116,
				py=99
				},
			[3]={
			 px=119,
				py=93
			},
			[4]={
			 px=90,
				py=99,
			} },
		ext={
		 [1]={
			 x=109,
				y=85,
				r=15,
				e=2
			},
			[2]={
			 x=116,
				y=98,
				r=24,
				e=1
			},
			[3]={
			 x=119,
				y=93,
				r=17,
				e=1
			},
			[4]={
			 x=90,
				y=99,
				r=25,
				e=1
			} }
}

rooms[17]={ 
  mx=120,
	 my=85,
		obj={
		 [1]={
			 x=121,
				y=97,
				a=act_itm("i_hp")
			} },
		ent={
		 [1]={
		  px=120,
		  py=93
				},
			[2]={
			 px=144,
				py=85
			},
			[3]={
			 px=135,
				py=88} },
		ext={
		 [1]={
			 x=120,
				y=93,
				r=16,
				e=3
			},
			[2]={
			 x=144,
				y=85,
				r=18,
				e=1
			},
			[3]={
			 x=135,
				y=88,
				r=28,
				e=2} }
}

rooms[18]={
  mx=120,
	 my=68,
		obj={
		 [1]={
			 x=121,
				y=69,
				a=act_itm("i_file")
			} },
		ent={
		 [1]={
		  px=144,
		  py=84
				},
			[2]={
			 px=120,
				py=78
			} },
		ext={
		 [1]={
			 x=144,
				y=84,
				r=17,
				e=2
			},
			[2]={
			 x=120,
				y=78,
				r=15,
				e=4
			} }
}

rooms[19]={ 
  mx=120,
	 my=51,
		ent={
		 [1]={
		  px=141,
		  py=63
				},
			[2]={
			 px=127,
				py=56
			} },
		ext={
		 [1]={
			 x=141,
				y=63,
				r=15,
				e=3
			},
			[2]={
			 x=127,
				y=56,
				r=20,
				e=1
			} }
}

rooms[20]={ 
  mx=120,
	 my=34,
		obj={
		 [1]={
			 x=122,
				y=37,
				a=act_itm("i_max")
			} },
		ent={
		 [1]={
		  px=127,
		  py=37
				},
			[2]={
			 px=138,
				py=41
			} },
		ext={
		 [1]={
			 x=127,
				y=37,
				r=19,
				e=2
			},
			[2]={
			 x=138,
				y=41,
				r=21,
				e=1
			} }
}

rooms[21]={ 
  mx=120,
	 my=17,
		ent={
		 [1]={
		  px=139,
		  py=30
				},
			[2]={
			 px=141,
				py=21
			} },
		ext={
		 [1]={
			 x=139,
				y=30,
				r=20,
				e=2
			},
			[2]={
			 x=141,
				y=21,
				r=22,
				e=1
			} }
}

rooms[22]={ 
  mx=150,
	 my=17,
		obj={
		 [1]={
			 x=162,
				y=26,
				a=act_msg("HEALTH CENTER")
			},
			[2]={
			 x=170,
				y=20,
				a=act_itm("i_bonus")
			} },
		ent={
		 [1]={
		  px=160,
		  py=20
				},
			[2]={
			 px=160,
				py=27
			 },
			[3]={
			 px=173,
				py=33
			} },
		ext={
		 [1]={
			 x=160,
				y=20,
				r=21,
				e=2
			},
			[2]={
			 x=160,
				y=26,
				r=24,
				e=1
			},
			[3]={
			 x=173,
				y=33,
				r=23,
				e=1
			} }
}

rooms[24]={ 
  mx=90,
	 my=51,
		obj={}, -- XXX This room will have an obj, but it will require extra code, for now we'll leave it empty XXX
		ent={
		 [1]={
		  px=104,
		  py=62
				} },
		weird=1,
		ext={
		  [1]={
				 x=104,
					y=62,
					r=nil,
					e=nil } } 
}

rooms[23]={ 
  mx=150,
	 my=34,
		ent={
		 [1]={
		  px=173,
		  py=34
				} },
		ext={
		 [1]={
			 x=173,
				y=34,
				r=22,
				e=3
			} }
}

rooms[25]={ 
  mx=60,
	 my=85,
		obj={
		 [1]={
			 x=61,
				y=87,
				a=act_itm("i_file")},
			[2]={
			 x=66,
				y=96,
				a=act_msg("The Abandoned Mine")} },
		ent={
		 [1]={
		  px=89,
		  py=99
				},
			[2]={
			 px=62,
				py=96,
			} },
		ext={
		 [1]={
			 x=89,
				y=99,
				r=15,
				e=4
			},
			[2]={
			 x=62,
				y=96,
				r=26,
				e=1 } }
}

rooms[26]={ 
  mx=150,
	 my=85,
		ent={
		 [1]={
		  px=156,
		  py=91
				},
			[2]={
			 px=170,
				py=85} },
		ext={
		 [1]={
			 x=156,
				y=91,
				r=25,
				e=2
			},
			[2]={
			 x=170,
				y=85,
				r=27,
				e=1} }
}

rooms[27]={ 
  mx=150,
	 my=68,
		obj={
		 [1]={
			 x=169,
			 y=72,
			 a=act_itm("i_file")} },
		ent={
		 [1]={
		  px=170,
		  py=84
				},
			[2]={
			 px=156,
				py=84},
			[3]={
			 px=156,
				py=68} },
		ext={
		 [1]={
			 x=170,
				y=84,
				r=26,
				e=2
			},
			[2]={
			 x=156,
				y=84,
				r=29,
				e=1
			},
			[3]={
			 x=156,
				y=68,
				r=28,
				e=1
			} }
}

rooms[28]={ 
  mx=150,
	 my=51,
		ent={
		 [1]={
		  px=156,
		  py=67
				},
			[2]={
			 px=174,
				py=60} },
		ext={
		 [1]={
			 x=156,
				y=67,
				r=27,
				e=3
			},
			[2]={
			 x=174,
				y=60,
				r=17,
				e=3
			} }
}

rooms[29]={ 
  mx=180,
	 my=68,
		obj={
		 [1]={
			 x=196,
			 y=79,
			 a=act_itm("i_file")} },
		ent={
		 [1]={
		  px=188,
		  py=69
			} },
		ext={
		 [1]={
			 x=188,
				y=69,
				r=27,
				e=2
	  } }
}

function TODO()
end

if not DEBUG then
  start_title()
else
  start_explore()
end


-- <TILES>
-- 001:bbbbbbbbbbb5bbbbb55bbbbbbbbbbbbbbbbb5bbbb5bbb55bbb5bbbbbbbbbbbbb
-- 002:bbfbbbbbbfcfbb5bb5f5bbbbbb5bbbdbbbbbbdedb8bbbbdbbb5bbb5bbbbbbbbb
-- 003:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb49494bb494949bbbbbbbb
-- 004:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9494949449494949bbbbbbbb
-- 005:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb949494bb49494bbbbbbbbbbb
-- 006:bbbbbbbbb77bbbbbb7777bbbb77f77bbb277f77b52777775b522775bbb5555bb
-- 007:11dd11dddd11dd1111dd11dddd11dd1111dd11dddd11dd1111dd11dddd11dd11
-- 008:113311333771331117777133377f77111277f773327777711122773333113311
-- 009:11dd11dddd11d44911dd4494dd14494911449499d449494914449449d4444494
-- 010:11dd11dd499eed119999eedd9f999e119ff99edd99ff9ee1999ff9ed99999991
-- 011:bbbbbbbbbbbbb449bbbb4494bbb44949bb449499b4494949b4449449b4444494
-- 012:bbbbbbbb499eebbb9999eebb9f999ebb9ff99ebb99ff9eeb999ff9eb9999999b
-- 013:bb7777bbb7fb517b7eb151e11b5515b511511b5050110105b500002bbb4121bb
-- 014:94444494444949944499999449499f949499f994999999944999994444994444
-- 015:a77777a7777a7aa777aaaaa77a7aafa7a7aafaa7aaaaaaa77aaaaa7777aa7777
-- 016:aaaaaaaaa777777aa700007aa7ff0f7aa700007aa706007aaa7777aaaaa3aaaa
-- 017:aaaaaaaaaaaaaaaaa444444aa4cccc4aa4c99c4aa4cccc4aa444444aa4aaaa4a
-- 018:aaaaaaaaaaaaaaaaaaaaaaaaa4aaaa4aa424424aa442244aa41ff14aaad11daa
-- 019:b44bb44b9999999944444444422424244242242444444444b22bb22b52255225
-- 020:bbbbbbbbbb377abbbb7d7abbbb777abbbbaaabbbb5bbb5bbbb555bbbbbbbbbbb
-- 021:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 022:bbbbbbbbbbbbbbbbbbbbbbbbbbb22222bb2f8888b2f8f6662f8f22222ff66666
-- 023:bbbbbbbbbbbbbbbbbbbbbbbb22221bbb888821bb6662221b2222212166666211
-- 024:2422024022444020249e94002e222900292004002920090524200405b555555b
-- 025:14444949d33444949994494949f94444449934443449339913331149dd11dd44
-- 026:4949494d94949431494943dd44443d99444319f99331499ff9dd444449913333
-- 027:b4444949b55444949994494949f944444499544454495599b555bb49bbbbbb44
-- 028:4949494b9494945b494945bb44445b994445b9f9955b499ff9bb4444499b5555
-- 029:11dd1aaadd1aaaff11aaffffdaafffff1affffffdaffffff1affffffdaffffff
-- 030:aaaaaaaaffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 031:aadd11ddfaaaad11ffffaaddfffffa11fffffaadffffffa1ffffffadffffffa1
-- 032:aaaa3aaaaaa3aaaaaaaa3aaaaaa3aaaaa77777aaa7b767aaa77777aaaaa3aaaa
-- 033:b5b5b5b57b7575755b5b575b5b575557b7b5557575b5b5b555757b755b5b5b5b
-- 034:aa1dd1aaaa1111aaaa1111aaa411114aa424424aa442244aa4aaaa4aaaaaaaaa
-- 035:aaaaaa44aaaaa444aaaa4444aaa44444aa444444aa444444aa4aa2aaaa4aaaaa
-- 036:4444444444444444fff44444ff44444a444444aa444444aaaaaaa4aaaaaaa4aa
-- 037:4aaaaaaa4aaaaaaa2aaaaaaa2aaaaaaa2aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 038:2f62222226666f222111f862b4941111b4449014b4949014b2229014bbbb2222
-- 039:2222621b6666661b1111111b1420021b2220011b2422221b1111111bbbbbbbbb
-- 040:2422024022444020249e94002e222900292004002920090724200407a777777a
-- 041:bbbbbbbbbbbbccccbbcccdddbbcdddddbbcdddddbbcdddddbbcdddddbbcddddd
-- 042:bbbbbbbbcccbbbbbddcccbbbddddccbbdddddccbddddddcbddddddcbddddddcb
-- 043:ffffffffffffaaaaffaaadddffadddddffadddddffadddddffadddddffaddddd
-- 044:ffffffffaaafffffddaaafffddddaaffdddddaafddddddafddddddafddddddaf
-- 045:1affffffdaafffff11afffffddafffff11afffffdaafffff1affffffdaffffff
-- 046:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 047:ffffffadffffffa1ffffffadffffffa1ffffffadffffffa1ffffffadffffffa1
-- 048:aaaa3aaaaaa3aaaaaaaa3aaaaaa777aaaaa7a7aaaaaaaaaaaaaaaaaaaaaaaaaa
-- 049:30000000303300003033033000330330300003303033000030330330aaaaaaaa
-- 050:aaaaaaaa0000000a3300000a3303300a3303303a3303303a3303303aaaaaaaaa
-- 051:77777777abbbbbbaab377abaab7b7abaab777abaabaaabbaabbbbbba77777777
-- 052:77777777a999999aa9377a9aa9797a9aa9777a9aa9aaa99aa999999a77777777
-- 053:77777777addddddaad377adaad7d7adaad777adaadaaaddaadddddda77777777
-- 054:bbbbbbb2bbbbb228bbb22ff8b22ff8f6b2f8f6f6b2868686b2f66686b2f68686
-- 055:2bbbbbbb222bbbbb24422bbb2424421b2422241b2424241b2424241b2424241b
-- 056:1aa711a1a171a17a711a11171a1aa1a1a1a171aa7177171a1711771171771177
-- 057:bbcdddddbbcdddddbbcdddddbbccddddbbbcddddbbbccdddbbbbccccbbbbbbbb
-- 058:ddddddcbddddddcbddddddcbddddddcbdddcddcbddcbcccbcccbbbbbbbbbbbbb
-- 059:ffadddddffadddddffadddddffaaddddfffaddddfffaadddffffaaaaffffffff
-- 060:ddddddafddddddafddddddafddddddafdddaddafddafaaafaaafffffffffffff
-- 061:1affffffdaffffff1affffffdaffffff1aaaffffdd1aaaff11dd1aaadd11dd11
-- 062:ffffffffffffffffffffffffffffffffffffffffffffffffaaafffffddaaaaaa
-- 063:ffffffadffffffa1ffffffadffffffa1fffffaadffffaa11ffaaa1ddaaa1dd11
-- 064:7777777777777777777777777777777777777777777777777777777777777777
-- 065:2222222222222222222222222222222222222222222222222222222222222222
-- 066:3333333333333333333333333333333333333333333333333333333333333333
-- 067:7000000070770000707707700077077070000770707700007077077033333333
-- 068:7000000070770000707707700077077070000770707700007077077022222222
-- 069:2222222200000002330000023303300233033032330330323303303222222222
-- 070:b2f68662b2866229b2622ccfb21ccfffbb2cf22fbb29f24cbb29f24cbb114224
-- 071:2222241b9222221bfcc2221bfffcc11bf22fc1bb900c91bb999991bb111111bb
-- 072:aaaaaaaaaaaaaaaaaaaeaeaeaae22222aaa26666aae26226aaa26266aae26666
-- 073:aaaaaaaaaaaaaaaaaeaeaeae2222222266666666626226266226262666666666
-- 074:aaaaaaaaaaaaaaaaaeaeaaaa22222aaa66662eaa62262aaa66262eaa66662aaa
-- 075:aaaaaaaaa777777aa711117aa71b1b7aa7565d7aa744447aaa7777aaaaaaaaaa
-- 076:aaaaaaaaa777777aa700007aa70e007aa700007aa700007aaa7777aaaaaaaaaa
-- 077:aaaaaaaaa777777aa700007aa704007aa700007aa700007aaa7777aaaaaaaaaa
-- 078:aaaaaaaaa777777aa700007aa705007aa700007aa700007aaa7777aaaaaaaaaa
-- 079:aaaaaaaaa777777aa700007aa706e07aa705d07aa700007aaa7777aaaaaaaaaa
-- 080:aaaaaaaa0000000a2200000a2202200a2202202a2202202a2202202aaaaaaaaa
-- 081:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 082:55555555555b55555bb55555555555555555b5555b555bb555b5555555555555
-- 083:aaaaaaaa2a2a2a2aaaaaaaaaa2a2a2a22a2a2a2a22222222a2a2a2a222222222
-- 084:1133113333113311113311333311331111331133331133111133113333113311
-- 085:bbbbbbbb0000000b3300000b3303300b3303303b3303303b3303303bbbbbbbbb
-- 086:aaaaaaaaaa2449aaaa4649aaaa4449aaaa999aaaa7aaa7aaaa777aaaaaaaaaaa
-- 087:dddddddddd377adddd7b7adddd777addddaaadddd1ddd1dddd111ddddddddddd
-- 088:aaa26666aae26226aaa26266aae26626aaa26226aae26666aaa26226aae26666
-- 089:6666626666266666262262266666626666266666622622626666626666266666
-- 090:66662eaa62262aaa66662eaa62262aaa62262eaa66662aaa62262eaa66662aaa
-- 091:aaaaaaaaa777777aa700007aa706007aa700007aa700007aaa7777aaaaaaaaaa
-- 092:aaaaaaaaa777777aa700007aa707007aa700007aa700007aaa7777aaaaaaaaaa
-- 093:aaaaaaaaa777777aa700007aa703007aa700007aa700007aaa7777aaaaaaaaaa
-- 094:aaaaaaaaa777777aa700007aa708007aa700007aa700007aaa7777aaaaaaaaaa
-- 095:aaaaaaaaa777777aa700007aa706007aa700007aa700007aaa7777aaaaaaaaaa
-- 096:40000000404400004044044000440440400004404044000040440440bbbbbbbb
-- 097:aaaaaaaaaa777777a77777777777777733333333333333333333333333333333
-- 098:aaaaaaaa77777777777777777777777733366333336666333366663333366333
-- 099:aaaaaaaa77777777777777777777777733333333333333333333333333333333
-- 100:aaaaaaaa777aaaaa773aaaaa733aaaaa333aaaaa333aaaaa33aaaaaa3aaaaaaa
-- 101:aaaaaaaaa777777aa700007aa70b007aa700007aa700007aaa7777aaaaaaaaaa
-- 102:3333333323232323333333333232323223232323222222223232323222222222
-- 103:22222222a2a2a2a2222222222a2a2a2aa2a2a2a2aaaaaaaa2a2a2a2aaaaaaaaa
-- 104:aaa26666aae26266aaa26226aae26666aaa22222aaaaeaeaaaaaaaaaaaaaaaaa
-- 105:6666666662662226222626266666666622222222eaeaeaeaaaaaaaaaaaaaaaaa
-- 106:66662eaa66262aaa62262eaa66662aaa22222eaaeaeaeaaaaaaaaaaaaaaaaaaa
-- 107:aaaaaaaaa777777aa700007aa70d007aa700007aa700007aaa7777aaaaaaaaaa
-- 108:aaaaaaaaa777777aa700007aa702007aa700007aa700007aaa7777aaaaaaaaaa
-- 109:aaaaaaaaa777777aa700007aa701007aa700007aa700007aaa7777aaaaaaaaaa
-- 110:aaaaaaaaa777777aa700007aa709007aa700007aa700007aaa7777aaaaaaaaaa
-- 111:aaaaaaaaa777777aa700007aa70c007aa700007aa700007aaa7777aaaaaaaaaa
-- 112:49449494949949494944994494994499bbbb5bbbb5bbb55bbb5bbbbbbbbbbbbb
-- 113:33333333333333333333333333333333aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 114:3333333333333333333333333333333322222222222222222222222222222222
-- 115:49449494949949494944994494994499aaaa7afaa7aaa77faa7aaaaaaaaaaaaa
-- 116:4944949494994949494499449499449911dd11dddd11dd1111dd11dddd11dd11
-- 117:3333333333333333333333333333333300000000000000000000000000000000
-- 118:4944949494994949494499449499449900000000000000000000000000000000
-- 119:aaaaaaaaa77aa55a11775b5a1d1f55aaa117f77af277722faf227262aaffff22
-- 120:aaaaaaaaa77aaaaaa7777aaaa77f77aaa277f77af277777faf2277faaaffffaa
-- 121:aaaaaaaaaaaaaaaa47474747a7a7a7a7a7a7a7a747474747aaaaaaaaaaaaaaaa
-- 122:aa4aa4aaaa7777aa477aa4aaa7a7a4aaa7aa74aa47444aaaaaaaaaaaaaaaaaaa
-- 123:aaaaaaaaaaaaaaaaaaa44474aa47aa7aaa4a7a7aaa4aa774aa7777aaaa4aa4aa
-- 124:11dd1cccdd1cccbb11ccbbbbdccbbbbb1cbbbbbbdcbbbbbb1cbbbbbbdcbbbbbb
-- 125:ccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 126:ccdd11ddbccccd11bbbbccddbbbbbc11bbbbbccdbbbbbbc1bbbbbbcdbbbbbbc1
-- 127:aa4aa4aaaa7777aaaa4aa774aa4a7a7aaa47aa7aaaa44474aaaaaaaaaaaaaaaa
-- 128:bbbbbbbbbbbbbbbbbbbbbbbbbbb77777bb7faaaab7faf3337faf77777ff33333
-- 129:bbbbbbbbbbbbbbbbbbbbbbbb77771bbbaaaa71bb3337771b7777717133333711
-- 130:bbbbbbbbbbbbbbbbbbbbbbbbbbb22222bb2e9999b2e9e4442e9e22222ee44444
-- 131:bbbbbbbbbbbbbbbbbbbbbbbb22221bbb999921bb4442221b2222212144444211
-- 132:bbbbbbbbbbbbbbbbbbbbbbbbbbb44444bb4ceeeeb4cec9994cec44444cc99999
-- 133:bbbbbbbbbbbbbbbbbbbbbbbb44441bbbeeee41bb9994441b4444414199999411
-- 134:bbbbbbb7bbbbb77abbb77ffab77ffaf3b7faf3f3b7a3a3a3b7f333a3b7f3a3a3
-- 135:7bbbbbbb777bbbbb73377bbb7373371b7377731b7373731b7373731b7373731b
-- 136:bbbbbbb2bbbbb229bbb22ee9b22ee9e4b2e9e4e4b2949494b2e44494b2e49494
-- 137:2bbbbbbb222bbbbb24422bbb2424421b2422241b2424241b2424241b2424241b
-- 138:bbbbbbb7bbbbb77dbbb77ffdb77ffdf3b7fdf3f3b7d3d3d3b7f333d3b7f3d3d3
-- 139:7bbbbbbb777bbbbb73377bbb7373371b7377731b7373731b7373731b7373731b
-- 140:1cbbbbbbdccbbbbb11cbbbbbddcbbbbb11cbbbbbdccbbbbb1cbbbbbbdcbbbbbb
-- 141:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 142:bbbbbbcdbbbbbbc1bbbbbbcdbbbbbbc1bbbbbbcdbbbbbbc1bbbbbbcdbbbbbbc1
-- 143:aaaaaaaaaaaaaaaa47444aaaa7aa74aaa7a7a4aa477aa4aaaa7777aaaa4aa4aa
-- 144:7f37777773333f777111fa37b4941111b4449014b4949014b2229014bbbb2222
-- 145:7777371b3333331b1111111b1420021b2220011b2422221b1111111bbbbbbbbb
-- 146:2e42222224444f222111f942b4941111b4449014b4949014b2229014bbbb2222
-- 147:2222421b4444441b1111111b1420021b2220011b2422221b1111111bbbbbbbbb
-- 148:4c94444449999c444111ce94b4941111b4449014b4949014b2229014bbbb2222
-- 149:4444941b9999991b1111111b1420021b2220011b2422221b1111111bbbbbbbbb
-- 150:b7f3a337b7a33779b7377ccfb71ccfffbb2cf22fbb29f24cbb29f24cbb114224
-- 151:7777731b9777771bfcc7771bfffcc11bf22fc1bb900c91bb999991bb111111bb
-- 152:b2e49442b2944229b2422ccfb21ccfffbb2cf22fbb29f24cbb29f24cbb114224
-- 153:2222241b9222221bfcc2221bfffcc11bf22fc1bb900c91bb999991bb111111bb
-- 154:b7f3d337b7d33779b7377ccfb71ccfffbb2cf22fbb29f24cbb29f24cbb114224
-- 155:7777731b9777771bfcc7771bfffcc11bf22fc1bb900c91bb999991bb111111bb
-- 156:1cbbbbbbdcbbbbbb1cbbbbbbdcbbbbbb1cccbbbbdd1cccbb11dd1cccdd11dd11
-- 157:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccbbbbbddcccccc
-- 158:bbbbbbcdbbbbbbc1bbbbbbcdbbbbbbc1bbbbbccdbbbbcc11bbccc1ddccc1dd11
-- 159:aa4aa4aaaa7777aaaa4aa4aaaa7777aaaa4aa4aaaa7777aaaa4aa4aaaa7777aa
-- 160:bbbbbbb7bbbbb77bbbb77ffbb77ffbf5b7fbf5f5b7b5b5b5b7f555b5b7f5b5b5
-- 161:7bbbbbbb777bbbbb75577bbb7575571b7577751b7575751b7575751b7575751b
-- 162:114d14dddd777711114dd4dddd77771114dd41dddd77d711114d14dddd11dd11
-- 163:aa4aa4aaaa7777faaa4aa4faaa7777aaa4aa4aaaaa77a7aaaa4aa4aaaaaaaaaa
-- 164:bbbbbbbbbbbbbbbbbbbbbbbbbbb77777bb7fddddb7fdf3337fdf77777ff33333
-- 165:bbbbbbbbbbbbbbbbbbbbbbbb77771bbbdddd71bb3337771b7777717133333711
-- 166:4444444442999e944293ee9444444444461995e4469195e4469915e444444444
-- 167:0000000000000000000000000000030000300003000000000000000000000000
-- 168:0000000000000000000000000d000d00000d000d000000000000000000000000
-- 169:0000000000000000000000000b000b00000b000b000000000000000000000000
-- 170:0000000000000000000000000e000e00000e000e000000000000000000000000
-- 171:0000000000000000000000000900090000090009000000000000000000000000
-- 172:0000000000000000000000000600606600060606000000000000000000000000
-- 173:bbbbbbbbbbbbbbbbbbbbbbbbbbb77777bb7fbbbbb7fbf5557fbf77777ff55555
-- 174:bbbbbbbbbbbbbbbbbbbbbbbb77771bbbbbbb71bb5557771b7777717155555711
-- 175:aaaaaaaaaaaaaaaa47444474a7aaaa7aa7aaaa7a474aa474aa7777aaaa4aa4aa
-- 176:b7f5b557b7b55779b7577ccfb71ccfffbb2cf22fbb29f24cbb29f24cbb114224
-- 177:7777751b9777771bfcc7771bfffcc11bf22fc1bb900c91bb999991bb111111bb
-- 178:0022220000262600002222000302203000300300000330000030030000000000
-- 179:aaaaaaaaaa4aa4aaaa7a77aaaaa4aa4aaa7777aaaf4aa4aaaf7777aaaa4aa4aa
-- 180:7f37777773333f777111fd37b4941111b4449014b4949014b2229014bbbb2222
-- 181:7777371b3333331b1111111b1420021b2220011b2422221b1111111bbbbbbbbb
-- 182:aaaaafffafffafafa4addf44abadda6677777777a7a77a7aa7a77a7a77a77a77
-- 183:0000000000000000000000006060600066060060000000000000000000000000
-- 184:0000000000000000000000009000900000900090000000000000000000000000
-- 185:000000000000000000000000e000e00000e000e0000000000000000000000000
-- 186:000000000000000000000000b000b00000b000b0000000000000000000000000
-- 187:000000000000000000000000d000d00000d000d0000000000000000000000000
-- 188:0000000000000000000000003000030000300000000000000000000000000000
-- 189:7f57777775555f777111fb57b4941111b4449014b4949014b2229014bbbb2222
-- 190:7777571b5555551b1111111b1420021b2220011b2422221b1111111bbbbbbbbb
-- 192:11dd11dddd41d411117d77dddd14dd41117777dddd4dd411117777dddd41d411
-- 193:0002000200200026022222662e22222622200022000002220060222000222200
-- 194:3232323223333333332222322323233333222232233232333333333223232323
-- 195:0777700077777770767670007777770077f77700077777000070077000700077
-- 196:aaaaaaaaaaaaaaaaaeaeaaaa22222aaa33332eaa32232aaa33232eaa33332aaa
-- 197:bbbbbbb4bbbbb44ebbb44cceb44ccec9b4cec9c9b4e9e9e9b4c999e9b4c9e9e9
-- 198:4bbbbbbb444bbbbb49944bbb4949941b4944491b4949491b4949491b4949491b
-- 199:0aa00aa00aa00aa00aa00aa00aaaaaa00aaaaaa0000aa000000aa000000aa000
-- 200:0aaaaaa0aaaaaaaaaa0000aaaa0000aaaa0000aaaa0000aaaaaaaaaa0aaaaaa0
-- 201:0aa000aa0aa000aa0aa000aa0aa000aa0aa000aa0aa000aa0aaaaaaa00aaaaa0
-- 202:aa000aa0aa000aa0aa000aa0aa000aa0aa0a0aa0aa0a0aa0aaaaaaa0aaaaaaa0
-- 203:aaaaaaa0aaaaaaa000aaa00000aaa00000aaa00000aaa000aaaaaaa0aaaaaaa0
-- 204:0aa000aa0aa000aa0aaa00aa0aaaa0aa0aaaaaaa0aa0aaaa0aa00aaa0aa000aa
-- 205:000aa000000aa000000aa000000aa000000aa00000000000000aa000000aa000
-- 206:337777aa337777aa77bb77aa77bb77aa777777aa777777aaaaaaaa00aaaaaa00
-- 208:0000000000aa0a000affafa0afaffafaaffeeffa0aaaeaa0000e000000000000
-- 209:33332eaa33232aaa32232eaa33332aaa22222eaaeaeaeaaaaaaaaaaaaaaaaaaa
-- 210:00aaaa000affffa0af7ff7faaff77ffaaff77ffaaf7ff7fa0affffa000aaaa00
-- 211:aaaaaaaaaaaaaaaaaeaeaeae2222222233333333323223233223232333333333
-- 212:00444000044444000444a44044444a4474444444744444440744444000774400
-- 213:b4c9e994b4e99449b4944ccfb41ccfffbb2cf22fbb29f24cbb29f24cbb114224
-- 214:4444491b9444441bfcc4441bfffcc11bf22fc1bb900c91bb999991bb111111bb
-- 215:0aaaaaa00aaaaaa0000aa000000aa000000aa000aa0aa000aaaaa0000aaa0000
-- 216:aaaaaaa0aaaaaaa0aa000aa0aa000aa0aaaaaaa0aaaaaaa0aa000aa0aa000aa0
-- 217:0aaaaaa0aaaaaaa0aa000000aa000000aa000000aa000000aaaaaaa00aaaaaa0
-- 218:aa00aa00aa00aa00aa0aaa00aaaaa000aaaaa000aa0aaa00aa00aa00aa00aa00
-- 219:aaaaaaa0aaaaaaa0aa0a0aa0aa0a0aa0aa000aa0aa000aa0aa000aa0aa000aa0
-- 220:0aaaaa00aaaaaaa0aa000aa0aa000aa0aa000aa0aa000aa0aaaaaaa00aaaaa00
-- 221:0aa000aa0aa000aa0aaa00aa0aaaa0aa0aaaaaaa0aa0aaaa0aa00aaa0aa000aa
-- 222:0aaaaaa0aaaaaaa0aa000000aaaaaaa00aaaaaaa000000aa0aaaaaaa0aaaaaa0
-- 224:aaaaaaaaaaaaaaaaaaaeaeaeaae22222aaa23333aae23223aaa23233aae23333
-- 225:000dd00000dddd000dddfdd0dddddfdddddddddd1ddddddd1ddddddd011dddd0
-- 226:33332eaa32232aaa33332eaa32232aaa32232eaa33332aaa32232eaa33332aaa
-- 227:00e0000e0ee0e0ee0eee9e9eee99999ee996969ee966669ee966669e09966990
-- 228:bbbbbbbbbbbbbbbbbbbbbbbbbbb77777bb783333b78382227838777778822222
-- 229:bbbbbbbbbbbbbbbbbbbbbbbb77771bbb333371bb2227771b7777717122222711
-- 230:7a77aaa2777aa229a7722ee9a22ee9e4a2e9e4e4a2949494a2e44494a2e49494
-- 231:2aaaaaaa222aaffa24422afa2424421a2422241a2424241a2424241a2424241a
-- 232:9999999999999999999999999999999999999999999999999999999999999999
-- 233:6666666666666666666666666666666666666666666666666666666666666666
-- 234:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 235:3333333333333333333333333333333333333333333333333333333333333333
-- 236:7777777777777777777777777777777777777777777777777777777777777777
-- 237:3333333332232223323333233232233333322323323333233222322333333333
-- 240:aaa23333aae23223aaa23233aae23323aaa23223aae23333aaa23223aae23333
-- 241:aaa23333aae23233aaa23223aae23333aaa22222aaaaeaeaaaaaaaaaaaaaaaaa
-- 242:bbbbb000b5b5bbb0bb5bbbb0b5b5b5b0bbbb5bb00bb5b5b00bbbbb5000000005
-- 243:3333333332332223222323233333333322222222eaeaeaeaaaaaaaaaaaaaaaaa
-- 244:782777777222287771118327b4941111b4449014b4949014b2229014bbbb2222
-- 245:7777271b2222221b1111111b1420021b2220011b2422221b1111111bbbbbbbbb
-- 246:a2e49442a2944224a242299ca2199cccaa29c22caa24c249ff24c249af114224
-- 247:2222241a4222221ac992221accc9911ac22c917a4009417a444441a7111111a7
-- 248:00000000aa000000a0a0aa00aa000aa0a0a0a0a0aa00aaa00000000000000000
-- 249:00000000aa00a0000a0000000a00a00a0a00a000aaa0a00a0000000000000000
-- 250:000000000000a000aa0aaa00a000a000aa00a000a0000a000000000000000000
-- 251:00000000a0000000000aa000a0a00000a0a00000a00aa0000000000000000000
-- 252:000000000aa0a000a000aa00aaa0a0a0a0a0a0a00aa0a0a00000000000000000
-- 253:00000000000000000a00a0a0a0a0a0a0a0a0a0a00a000aa00000000000000000
-- 254:00000000aa0000000a0000000a0000000a000000aaa000000000000000000000
-- 255:fffffffff077770ff770077ff706067ff700007ff7777777f777777ff7ffffff
-- </TILES>

-- <SPRITES>
-- 000:0000000000fff6000066666000c1c10000cccc000066660000c330c000300300
-- 001:0000000000fff6000066666000c1c10000cccc00006666000c0330c000033000
-- 002:0000000000fff6000066666000c1c10000cccc00006666000c033c0000300300
-- 003:0000000000fff6000066666000c1c10000cccc00006666000c0330c000033000
-- 004:0000000000fff6000066666000c1c10000cccc00006666000c0330c000300300
-- 005:0000000000fff6000066666000c1c10000cccc000c6666c00003300000300300
-- 006:0f0fffff707000ff7070770f77707070707070707070770f0f0070ffffff0fff
-- 007:ffffffff00000000aaaaaaaabbbbbbbbbbbbbbbbaaaaaaaa00000000ffffffff
-- 008:ffffffff0000000faaaaaaa0bbbbbbbabbbbbbbaaaaaaaa00000000fffffffff
-- 009:000000000aaaaaa0affffffaaffaaffaaffaaffaaffffffa0aaaaaa000000000
-- 010:0000000002222220233333322322223223322332233333320222222000000000
-- 011:00000000099999909eeeeee99e99e9e99e9e99e99eeeeee90999999000000000
-- 012:6777777777777777770000007700000077000000770000007700000077000000
-- 013:7777777777777777000000000000000000000000000000000000000000000000
-- 014:7777777677777777000000770000007700000077000000770000007700000077
-- 015:00000000000000000000000000377a00007e7a0000777a0000aaa00000000000
-- 016:000000000000000000aaaa0000a7c70000ccac0000ff6f0000cf60c000f00f00
-- 017:000000000000000000aaaa0000a7c70000ccac0000ff6f000c0f60c0000ff000
-- 018:000000000000000000aaaa0000a7c70000ccac0000ff6f000c0f6c0000f00f00
-- 019:000000000000000000aaaa0000a7c70000ccac0000ff6f000c0f60c0000ff000
-- 020:000000000000000000aaaa0000a7c70000ccac0000ff6f000c0f60c000f00f00
-- 021:000000000000000000aaaa0000a7c70000ccac000cff6fc0000f600000f00f00
-- 022:fffffffff00000000aaaaaaaa0000000a00000000aaaaaaaf0000000ffffffff
-- 023:ffffffff00000000aaaaaaaaeeeeeeeeeeeeeeeeaaaaaaaa00000000ffffffff
-- 024:ffffffff0000000faaaaaaa0eeeeeeeaeeeeeeeaaaaaaaa00000000fffffffff
-- 025:00000000077777707ff7fff77ff777f77f777ff77fff7ff70777777000000000
-- 026:00000000055555505bbbbbb55b555bb55bb555b55bbbbbb50555555000000000
-- 027:0000000006666660669999666996999669996996669669660666666000000000
-- 028:7700000077000000770000007700000077000000770000007700000077000000
-- 029:0000000000f0000000ff000000fff00000ffa00000fa000000a0000000000000
-- 030:0000007700000077000000770000007700000077000000770000007700000077
-- 031:00000000000000000000000000377a0000767a0000777a0000aaa00000000000
-- 032:0000000000000000006888000081c100008ccc0000dddd0000c220c000200200
-- 033:0000000000000000006888000081c100008ccc0000dddd000c0220c000022000
-- 034:0000000000000000006888000081c100008ccc0000dddd000c022c0000200200
-- 035:0000000000000000006888000081c100008ccc0000dddd000c0220c000022000
-- 036:0000000000000000006888000081c100008ccc0000dddd000c0220c000200200
-- 037:0000000000000000006888000081c100008ccc000cddddc00002200000200200
-- 038:0f0fffff606000ff6060660f66606060606060606060660f0f0060ffffff0fff
-- 039:ffffffff00000000aaaaaaaa0000000000000000aaaaaaaa00000000ffffffff
-- 040:ffffffff0000000faaaaaaa06666666a6666666aaaaaaaa00000000fffffffff
-- 041:00000000088888808cc8ccc88c8888c88cc88cc88c8cc8c80888888000000000
-- 042:00000000011111101dddddd111d1d1d11d1d1d111dddddd10111111000000000
-- 043:0000000004444440499449944949449449444494499449940444444000000000
-- 044:7700000077000000770000007700000077000000770000007777777767777777
-- 045:0000000000000000000000000000000000000000000000007777777777777777
-- 046:0000007700000077000000770000007700000077000000777777777777777776
-- 047:00000000000000000000000000377a00007b7a0000777a0000aaa00000000000
-- 048:00000000000000000044440000c1c10000cccc00006666000c0220c000200200
-- 049:00000000000000000044440000c1c10000cccc000c6666c00002200000200200
-- 050:0000000000000000006999000091c100009ccc0000bbbb000c0550c000500500
-- 051:0000000000000000006999000091c100009ccc000cbbbbc00005500000500500
-- 052:0000000000000000007777000071c10000777700002222000c0330c000300300
-- 053:0000000000000000007777000071c100007777000c2222c00003300000300300
-- 054:0000000003000000407777004071c10000777700002222000c0110c000100100
-- 055:0000000043000000407777000071c100007777000c2222c00001100000100100
-- 056:0000000000000000002222000021c10000222200007777000103301000300300
-- 057:0000000000000000002222000021c10000222200017777100003300000300300
-- 058:0000000000000e0000eeee0000c4c40000cccc000055550000c110c000100100
-- 059:0000000000000e0000eeee0000c4c40000cccc00005555000c0110c000011000
-- 060:0000000000000e0000eeee0000c4c40000cccc00005555000c011c0000100100
-- 061:0000000000000e0000eeee0000c4c40000cccc00005555000c0110c000011000
-- 062:0000000000000e0000eeee0000c4c40000cccc00005555000c0110c000100100
-- 063:0000000000000e0000eeee0000c4c40000cccc000c5555c00001100000100100
-- 064:00000000000000000099990000c5c50000cccc0000dddd000c0110c000100100
-- 065:00000000000000000099990000c5c50000cccc000cddddc00001100000100100
-- 066:0000000000000000002eee0000e1c10000eccc00009999000c0440c000400400
-- 067:0000000000000000002eee0000e1c10000eccc000c9999c00004400000400400
-- 068:00000000000000000044440000c5c50000cccc0000eeee000c0990c000900900
-- 069:00000000000000000044440000c5c50000cccc000ceeeec00009900000900900
-- 070:0000000000000000004eee0000e5c50000eccc00003333000c0220c000200200
-- 071:0000000000000000004eee0000e5c50000eccc000c3333c00002200000200200
-- 072:0000000000fff9000099999000c1c10000cccc00009999000c0ee0c000e00e00
-- 073:0000000000fff9000099999000c1c10000cccc000c9999c0000ee00000e00e00
-- 074:000000000000000000000000006666000671c100007777000c0770c000700700
-- 075:000000000000000000000000066666000071c1000c7777c00007700000700700
-- 076:00000000000000000099990000c5c50000cccc0000cccc000c0660c000c00c00
-- 077:00000000000000000099990000c5c50000cccc000cccccc00006600000c00c00
-- 078:0000000000000000000000000044440000c7c70000dddd000c0330c000300300
-- 079:0000000000000000000000000044440000c7c7000cddddc00003300000300300
-- 080:000000000000000000eeee0000c5c50000cccc00003333000c0220c000200200
-- 081:000000000000000000eeee0000c5c50000cccc000c3333c00002200000200200
-- 082:0000000000000000003444000045c500004ccc0000eeee000c0990c000900900
-- 083:0000000000000000003444000045c500004ccc000ceeeec00009900000900900
-- 084:000000000000000000574e0000e1c1000047550000bbbb000704407000400400
-- 085:000000000000000000574e0000e1c1000047550007bbbb700004400000400400
-- 086:000000000600000040574e0040e1c1000047550000bbbb000704407000400400
-- 087:000000004600000040574e0000e1c1000047550007bbbb700004400000400400
-- 088:0000000000fff1000011111000c5c50000cccc00001111000c0330c000300300
-- 089:0000000000fff1000011111000c5c50000cccc00001111000c0330c000300300
-- 090:00000000000000000470070040ee7e0040e1c100007eee000c0e70c000700e00
-- 091:00000000000000004470070040ee7e0000e1c1000c7eeec0000e700000700e00
-- 092:00000000020000009099990090c5c50000cccc0000c66c000c0660c000c00c00
-- 093:00000000920000009099990000c5c50000cccc000cc66cc00006600000c00c00
-- 094:0000000000000000030000004044440040c7c700008888000c0220c000200200
-- 095:0000000000000000430000004044440000c7c7000c8888c00002200000200200
-- 096:00000000000000000099990000c1c10000cccc0000bbbb000c0550c000500500
-- 097:00000000000000000099990000c1c10000cccc000cbbbbc00005500000500500
-- 098:0000000000000000008444000041c100004ccc00006666000c0220c000200200
-- 099:0000000000000000008444000041c100004ccc000c6666c00002200000200200
-- 100:aaaaaaaaa777777aa7dddd7aa7dddd7aa7d7bb7aa7bb447aaa7777aaaaa3aaaa
-- 101:aaaaaaaaa777777aa7dddd7aa7dd7d7aa7dbbb7aa7b4447aaa7777aaaaa3aaaa
-- 102:aaaaaaaaa777777aa7dddd7aa7d7dd7aa7bbbb7aa744447aaa7777aaaaa3aaaa
-- 103:aaaaaaaaa777777aa7dddd7aa7dd7d7aa7bbbb7aa744447aaa7777aaaaa3aaaa
-- 104:aaaaaaaaa777777aa7dddd7aa7d7dd7aa7bbbd7aa7444b7aaa7777aaaaa3aaaa
-- 105:aaaaaaaaa777777aa7dddd7aa7dd7d7aa7bbbd7aa7444b7aaa7777aaaaa3aaaa
-- 106:aaaaaaaaa777777aa7dddd7aa7dddd7aa7b7dd7aa74bbb7aaa7777aaaaa3aaaa
-- 107:aaaaaaaaa777777aa7dddd7aa7dddd7aa7dd7d7aa7bbbb7aaa7777aaaaa3aaaa
-- 108:aaaaaaaaa777777aa7dddd7aa7dddd7aa7d7db7aa7bbb47aaa7777aaaaa3aaaa
-- 109:aaaaaaaaa777777aa7dddd7aa7ffff7aa7d7bb7aa7ffff7aaa7777aaaaa3aaaa
-- 110:aaaaaaaaa777777aa7ffff7aa7ffff7aa7ffff7aa7ffff7aaa7777aaaaa3aaaa
-- 111:aaaaaaaaa777777aa7ffff7aa7dddd7aa7ffff7aa7bb447aaa7777aaaaa3aaaa
-- 112:000000000000000000eeee0000c1c10000cccc00009999000c0440c000400400
-- 113:000000000000000000eeee0000c1c10000cccc000c9999c00004400000400400
-- 114:0000000000000000002999000095c500009ccc0000dddd000c0110c000100100
-- 115:0000000000000000005999000095c500009ccc000cddddc00001100000100100
-- 116:aaaaaaaaa777777aa7dddd7aa7dddd7aa7d7337aa733337aaa7777aaaaa3aaaa
-- 117:aaaaaaaaa777777aa7dddd7aa7dd7d7aa7d3367aa733397aaa7777aaaaa3aaaa
-- 118:aaaaaaaaa777777aa7dddd7aa77ddd7aa736637aa739937aaa7777aaaaa3aaaa
-- 119:aaaaaaaaa777777aa7d7dd7aa7dddd7aa736637aa739937aaa7777aaaaa3aaaa
-- 120:aaaaaaaaa777777aa7dd7d7aa7dddd7aa736637aa739937aaa7777aaaaa3aaaa
-- 121:aaaaaaaaa777777aa7dddd7aa7d7dd7aa7633d7aa793337aaa7777aaaaa3aaaa
-- 122:aaaaaaaaa777777aa7dddd7aa7dddd7aa737dd7aa733337aaa7777aaaaa3aaaa
-- 123:aaaaaaaaa777777aa7dddd7aa7dddd7aa7dd7d7aa733337aaa7777aaaaa3aaaa
-- 124:aaaaaaaaa777777aa7dddd7aa7dddd7aa7d7d37aa733337aaa7777aaaaa3aaaa
-- 125:aaaaaaaaa777777aa7dddd7aa7ffff7aa7d7337aa7ffff7aaa7777aaaaa3aaaa
-- 126:aaaaaaaaa777777aa7ffff7aa7ffff7aa7ffff7aa7ffff7aaa7777aaaaa3aaaa
-- 127:aaaaaaaaa777777aa7ffff7aa7dddd7aa7ffff7aa733337aaa7777aaaaa3aaaa
-- 128:2222222220022002200220022000000220000002200000022000000220000002
-- 129:0222222020000002200000022000000220000002200000022000000202222220
-- 130:2200000222200002222200022022200220022202200022222000022220000022
-- 131:0222222020000000200000000222222002222220000000020000000202222220
-- 132:000dd00000dddd000dddfdd0dddddfdddddddddd1ddddddd1ddddddd011dddd0
-- 133:bbbbb000b5b5bbb0bb5bbbb0b5b5b5b0bbbb5bb00bb5b5b00bbbbb5000000005
-- 134:00e0000e0ee0e0ee0eee9e9eee99999ee996969ee966669ee966669e09966990
-- 135:00aaaa000affffa0af7ff7faaff77ffaaff77ffaaf7ff7fa0affffa000aaaa00
-- 136:00444000044444000444a44044444a4474444444744444440744444000774400
-- 137:0777700077777770767670007777770077f77700077777000070077000700077
-- 138:0022220000262600002222000302203000300300000330000030030000000000
-- 139:0002000200200026022222662e22222622200022000002220060222000222200
-- 140:0000000000aa0a000affafa0afaffafaaffeeffa0aaaeaa0000e000000000000
-- 143:0000000002222220266266622662266226622662266626620222222000000000
-- 144:00000000000000000000000000000000000bb00000bf5b0000b55b0000bbbb00
-- 145:000000000000000000000000000bb00000bf5b000bf555b00b5555b00bbbbbb0
-- 146:000000000000000000bbbb000bf555b0bf55555bb555555bb555555bbbbbbbbb
-- 147:0000000020000002960720699922229909227290007222000002700000000000
-- 148:00000000000000000222200006262060022226900077290000ee207002e27700
-- 149:0022206022262760222229960077299602ee729602ee7260072e2700f270f277
-- 150:00000000000000000d0dddd00dddd6d00ddd11100d0dddd00000000000000000
-- 151:0000000000000000010dddd0011dd6d00dddf7f0011dddf0010dddd000000000
-- 152:10001ddd110d61df111ddd0f0dddd000111ddf00110ddd0f1001dddf00111ddd
-- 153:0000000000000000077007700aa77aa000a77a00000000000000000000000000
-- 154:0000000070000007a700007aaa7777aa0a6776a000722700007f770000000000
-- 155:0000000000310000031aa00006a6a0000a88aa00707770a00007a00000700a00
-- 156:0a0310a0a031aa0aa06a6a0a0accc7a007a77a77070aaa07007ede70000a0a00
-- 157:000000000000000088800000dcd80000ccc00008008888c000c88c0000c00c00
-- 158:0303000033330000dcd33000ccc300030033000c0033333c00c33c3000c0cc00
-- 159:000000000904409000444400044f644004466440004444000904409000000000
-- 160:0000000000000000000777004a76f670a47fff70a0f777700074707000000000
-- 161:000000070a777777a76f6f77a7ffff7047777770a477770007f7777007747770
-- 162:00000000000066000006600000506600000b0000044744400044740000774700
-- 163:00000000000666000066666000660000000666005505000005b5b50000bb0000
-- 164:000666600066666605660f0f05060000005066605005055055b5b50505bb5500
-- 165:00000000000088000008800000708800000a0000044444400044440000444400
-- 166:00000000000333000033333000330000000333007707000007a7a70000aa0000
-- 167:000222200022222207220f0f07020000007022207007077077a7a70707aa7700
-- 168:0000000000000000000000000000000000033000003f23000032230000333300
-- 169:00000000000000000000000000033000003f230003f222300322223003333330
-- 170:00000000000000000033330003f222303f222223322222233222222333333333
-- 171:000000000000000000a0000000fa880008888800008080000000000000000000
-- 172:0000000000a0000008fa8880088f878888888888088888800800008000000000
-- 173:0a0000000fa8888008fa8880088f8788888888a80888888a0800008000000000
-- 174:000000000026000000eee0000e3e3e000e6e6e000e333e000330030000030000
-- 175:0026000000e6e0000eeeee000e3e3e000e6e6e000e333e000303330000303030
-- 176:0077770000777700077777700036360000333303330330333000300000030000
-- 177:0077770000777700077777700026260020222202220220220002200000200200
-- 178:000000000000000000ffff000af1f1000affff000fffff000a0ff0f006f00f00
-- 179:000000000000000000ffff0a00f6f60a00ffff03003fff3a030ff00600f00f00
-- 180:002222000026260020222200222222220002200200200200602fa2000aa0faf0
-- 181:0000000000aaa0000aaaaa000faaaf000ff7f7000fff4f0000fff00009909900
-- 182:00000000079797700dfddfd0f07ff70ff07dd70f909ff9090070070007700770
-- 183:090000900733337073afaf37797a7a9773777737033333300930039093900939
-- 184:0000600000e6e6000949949099966999409ee904040440400090090004904900
-- 185:000000000000000000000000000000000444440004bcb40004ccc40000c0c000
-- 186:000000000000a000000aaa0000444440004cac40004bcb400c4ccc4c0c00000c
-- 187:00000000000000000000000000000000bbb00000bbdbbbb5b5ccccb0000c00c0
-- 188:00008000000880000bbbbb000dbdbbb07575bbb55555bbb500ccccb000cc0cc0
-- 189:000000000000000000fff0000d33df000f373f000f737f0000fff00000a0a000
-- 190:00022220000a022000aaa02000dad02202a2a20002222200a02220a000020000
-- 191:a00a00a085aaa580a5dad5a0555a550005a5a5a005aaa55aa55555a00a055000
-- 192:0000000000000000000b000000b00000099990400e9e90400099440004004000
-- 193:000000000000b000009b9990094bb4900999990049e9e940c49494ccc444440c
-- 194:000000e000005500009955000c9e9cc0c949c90c49949c444449944404444440
-- 195:0000000000cc80000c8ccc0008cc8c000888880000cfc00000fff00000f0f000
-- 196:0000000000000000000000000c000c00040c04000bb4bbc05b5bbb40bbbbbbb0
-- 197:00f00000f0d0f0f0dfdfdfd00d0ddd000acaca00aaa4aaa0aa4a4aa00aaaaa00
-- 198:0000000000000000006000000666060000c00c060033330c032323c033333333
-- 199:00055500000a005006666005077776050555570507ff755005ff550005005000
-- 200:0b05500006555500bbb555007b7bb500cbcbbb05cccbbbb50cccbb0555005500
-- 201:00000000000700700033307000b3b30000303730030076700000070000000000
-- 202:002d002202d332dd00300300233323000b2b2770023372702007667000077700
-- 203:0000000000000000000000000000000000070000006960000099707000099600
-- 204:00000000000000000666600006cec60067e00e606600c607000e6666000cece6
-- 205:0076660007d67660066ccc76eec00c660000c760e00c66660ec7667c076cccc0
-- 206:0000707000077770000f7f700007777a0000770a0a0077700a007700a0a77770
-- 207:0000000000110d00001dd00001010b0b000000b008820bbb8220005008800505
-- 208:000000000000000000077700007777000777770007e2e7001327231013323331
-- 209:007770000737370002777200002220000077700023e7e3202027200270707070
-- 210:00000000000b000000b5b0001b444b1005e4e5000144410000b4b00000101000
-- 211:00b00000040b0400044444000be4eb00014141000b545b000055500000101000
-- 212:0000000000000000000000000aaa0000a2a0000a333aaa0a003333a000300300
-- 213:000000000000000000000000a0a0a0000aaa000007a7aaa07777777aa00a00a0
-- 214:00aaa00007777a00a7a7a7a002a2077aaaaaa7a000007a000007aaaa00077777
-- 215:0000d000000d00000066600000d6d00000666000006d606000090dc00006c000
-- 216:00d00060000d00c0009d90d00969690d96d6d609066d6600d00900000600d000
-- 217:0000cf000000f3000078780000cfcf0000f3f30000878a0000cfcf0000f3f700
-- 223:000000002000000262000026662222660612216000277200002f220000000000
-- 224:0000000000088000000860000666866006626660000620000002200000000000
-- 225:70000070007070000700f0700770f00002070f70027770700022070000000000
-- 226:0000000000ffff0000f0f0f00fffff00011ff1100dd11dd00dddddd000000000
-- 227:00000000000ff000000fb0000bbbfbb00bb5bbb0000b50000005500000000000
-- 228:0000000000032000000d300009ebd320069ebd300009e0000006900000000000
-- 229:000000000000000000000000377a00707b7a0777777a0070aaa0000000000000
-- 230:000060000066660000696600009999000099e90000eeee0000efee0000ffff00
-- 231:00000000000ff00000f00f000f0a00d00f0000d000d00d00000dd00000000000
-- 232:0000b0000bb005b005b00bb0b00000000000000b0bb00b500b500bb0000b0000
-- 233:000020000022220000232200003333000033830000888800008f880000ffff00
-- 234:0000000000088000008008000802008008000080008008000008800000000000
-- 236:00feef0000feff0000ffef0000feef0000feff0000ffef0000feef0000feff00
-- 237:000000000ffffff000aaaa000ffffff0000aa00000ffff00000aa00000000ff0
-- 238:0000000000000000090909000909090000000000090999000990990000000000
-- 239:0000000000040000004494000449944044944944999444994449994494449444
-- 240:0000000007777770077aaa7007a70070070a70700700a770077777700aaaaaa0
-- 241:000000000000050000005b000505b0000b5b000000b000000000000000000000
-- 242:0000000002000200062026000062600000262000026062000600060000000000
-- 243:0000000000bbbb000b5b550005bbb000005b5b000bbbb5000555500000000000
-- 244:000000000009000000999000099999000ee9ee000009000000090000000e0000
-- 245:0000000000aaaa000007aa70000aa77000007700000aa0000000770000000000
-- 246:b7a0000077a00000aa0000000000000000000000000000000000000000000000
-- 248:0000000020000020222222202020202020000020020202000222220000000000
-- 249:0200002020200002023333000032320000333300003030200000320200300020
-- 250:070000707670076776e77e67077777707a7777f77fafafa707fafa7000777700
-- 251:0600000069600000069600000669600006069600000669600600069600060660
-- 252:000000000e00e00000e00e00000e00e00e00e00e00e00e00000e00000000e000
-- 253:00000000000e00e000e00e000e00e000e00e00e000e00e000000e000000e0000
-- 254:0000000000050000001000000323215536335332235135150000000000000000
-- 255:fffffffff077770ff770077ff706067ff700007ff7777777f777777ff7ffffff
-- </SPRITES>

-- <MAP>
-- 000:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2bebebeaeaeaeaebeaeaeaeaeaeaeaebeaeaeaeaeaebeaeaeaeaeaebebebe9e9e9e8e8e8e8e9e8e8e8e8e8e8e8e9e8e8e8e8e8e9e8e8e8e8e8e9e9e9e000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000
-- 001:beaeaebebeaeaebebeaeaeaebeaeaebebeaeaeaebebeaeaebebeaeaeaebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2bebeaeaeaeaeaeaebeaebebebeaebeaeaebebebeaeaebeaeaeaeaeaebebe9e9e8e8e8e8e8e8e9e8e9e9e9e8e9e8e8e9e9e9e8e8e9e8e8e8e8e8e9e9e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e200e20000000000000000000000000000000000000000000000000000e200
-- 002:beaeaebebebeaebebebeaeaeaebebeaeaeaeaebebebeaebebebeaeaeaebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2beaebebebeaeaebeaeaeaeaeaeaeaebeaeaeaeaeaebeaeaeaebebebeaebe9e8e9e9e9e8e8e9e8e8e8e8e8e8e8e9e8e8e8e8e8e9e8e8e8e9e9e9e8e9e000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000000000000000000000000000000000000000000000000000e2e2e2000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000e2
-- 003:bebeaeaebebebeaebe0000bebe0000bebebe0000beaebebebeaeaeaebebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2aeaeaebeaebebebebebebeaeaeaebeaeaeaeaebebebebebebeaebeaeaeae8e8e8e9e8e9e9e9e9e9e9e8e8e8e9e8e8e8e8e9e9e9e9e9e9e8e9e8e8e8e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e20000000000000000000000000000000000000000000000000000e2e2e20000e200000000000000000000000000000000000000000000e20000e2
-- 004:beaebeaeaebebebeae007d8d9dadbdcdddedec00aebebebeaeaeaebeaebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2aebeaebeaeaeaebebeaeaebebebebebebebebeaeaebebeaeaeaebeaebeae8e9e8e9e8e8e8e9e9e8e8e9e9e9e9e9e9e9e9e8e8e9e9e8e8e8e9e8e9e8e0000000000000000007a8a9aaabaca7b8b9babbbcb000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e200e2000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000e200e2
-- 005:beaeaebeaeaebebeaebe000000000000000000beaebebeaeaeaebeaeaebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2aebeaeaeaebeaeaeaeaeaeaeaebebebebeaeaeaeaeaeaeaebeaeaeaebeae8e9e8e8e8e9e8e8e8e8e8e8e8e9e9e9e9e8e8e8e8e8e8e8e9e8e8e8e9e8e000000000000007a8a9aaabaca000000007b8b9babbbcb00000000000000000000000000000000000000000000000000000000000000000000000000e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e200e20000e2000000000000000000000000000000000000e20000e200e2
-- 006:bebeaeaebeaeaebeaebe000000002b00000000beaebeaeaeaebeaeaebebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2aebeaebeaeaeaebebeaeaebebebebebebebebeaeaebebeaeaeaebeaebeae8e9e8e9e8e8e8e9e9e8e8e9e9e9e9e9e9e9e9e8e8e9e9e8e8e8e9e8e9e8e00000000000000007a8a9aaabaca00007b8b9babbbcb0000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2000000000000000000000000000000000000e2e20000e2e2e200e200e2000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000e200e200e2
-- 007:bebebeaebebebebebe000000001c003c00000000bebebebebebebeaebebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2aeaeaebeaebebebebebebeaeaeaebeaeaeaeaebebebebebebeaebeaeaeae8e8e8e9e8e9e9e9e9e9e9e8e8e8e9e8e8e8e8e9e9e9e9e9e9e8e9e8e8e8e000000007a8a9aaabacadc7c8c9cdcdcacbcccdc7b8b9babbbcb00000000000000000000000000000000000000000000000000000000000000000000e2e20000e2e2000000000000000000000000000000000000e2e20000e2e2e200e200e20000e20000000000000000000000000000e20000e200e200e2
-- 008:bebeaebebebebebebe0000000d002d004d000000bebebebebebeaebebebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2beaebebebeaeaebeaeaeaeaeaeaeaebeaeaeaeaeaebeaeaeaebebebeaebe9e8e9e9e9e8e8e9e8e8e8e8e8e8e8e9e8e8e8e8e8e9e8e8e8e9e9e9e8e9e00000000000000007a8a9aaabaca00007b8b9babbbcb0000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e20000e2e2e200e200e200e20000e2e2e2e2e2e2e2e2e2e2e2e20000e200e200e200e2
-- 009:bebeaeaebeaeaebeaebe0000001e003e000000beaebeaeaeaebeaeaebebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2bebeaeaeaeaeaeaebeaebebebeaebeaeaebebebeaeaebeaeaeaeaeaebebe9e9e8e8e8e8e8e8e9e8e9e9e9e8e9e8e8e9e9e9e8e8e9e8e8e8e8e8e9e9e000000000000007a8a9aaabaca000000007b8b9babbbcb00000000000000000000000000000000000000000000000000000000000000000000000000e2e20000e2e2000000000000000000000000000000000000e2e20000e2e2e200e200e20000e20000000000000000000000000000e20000e200e200e2
-- 010:beaeaebeaeaebebeaebe000000002f00000000beaebebeaeaeaebeaeaebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2bebebeaeaeaeaebeaeaeaeaeaeaeaebeaeaeaeaeaebeaeaeaeaeaebebebe9e9e9e8e8e8e8e9e8e8e8e8e8e8e8e9e8e8e8e8e8e9e8e8e8e8e8e9e9e9e0000000000000000007a8a9aaabaca7b8b9babbbcb000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2000000000000000000000000000000000000e2e20000e2e2e200e200e2000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000e200e200e2
-- 011:beaebeaeaebebebeaebe000000000000000000beaebebebeaeaeaebeaebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e200e20000e2000000000000000000000000000000000000e20000e200e2
-- 012:bebeaeaebebebeaeae00be8f9fafbfcfdfefff00aeaebebebeaeaeaebebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e200e2000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000e200e2
-- 013:beaeaebebebeaeaebe0000bebe0000bebebe0000beaeaebebebeaeaeaebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e20000000000000000000000000000000000000000000000000000e2e2e20000e200000000000000000000000000000000000000000000e20000e2
-- 014:beaebebebeaeaebebebeaeaeaebebeaeaeaeaebebebeaeaebebebeaeaebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000000000000000000000000000000000000000000000000000e2e2e2000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000e2
-- 015:beaebebeaeaeaebebeaeaeaebeaeaebebeaeaeaebebeaeaeaebebeaeaebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e200e20000000000000000000000000000000000000000000000000000e200
-- 016:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebee2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000
-- 017:d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 018:d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000d0b0c0b0c0b0c0b0c01010101010101010b0c0b0c0b0c0b0c0b0c0b0c0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 019:d012b0c012d0d0d0d012d01010637310d0b0c068781010101010101010d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d01010101010d012d0121212d012121212121010101010101210101010d0000000000000000000000000000000000000000000000000000000000000d0b1c1b1c1b1c1b1c110e0e0e0e0e0e010b1c1b1c1b1c1b1c1b1c1b1c1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 020:d012b1c1121212121212d01010647410d0b1c16979101010101025252525000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004040400000000000000000000000000252525102510d012121212121212d012d0d0d0d0101010121212101010d0000000040404040404040404040404040404040404040404040404040000d06060101010202020e02310b0c0b0c0e010b0c041101020202020b0c0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 021:d01212121212121212d0d01010101010d0101010101010102525102525d0000000000000000000000404040000000000000000000000000000000000000000000000000000000004040404130404040400000000000000000000d02525251010d0d0d0d0d0d0d0d0d010101010d0d0d0d0d012d0d0d0d0d0000000041717171717171717171717171717171704131717171717040000d0b0c01020202020e0101010b1c1b1c112e0b1c110101010202020b1c1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 022:d0121212121210102838d0d0101010d0d010108898104e5e1010311010d0000000000000000000040423040404040404000000000000000000000000000000000000000000000004171717151717170400000000000000000000d01010101010d041121212121212d0d0d0d01010d01010d012d0121212d0000000040e4c515151510451515151515151515104515151515151040000d0b1c110102020e0b0c01010101010121212e01010101010102020b0c0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 023:d0121212d0101010293910d0d010d0d0b0c0108999104f5f1010101010d0000000000000000000041751171717171704000000000000000000000000000000000000000000000004111515151515b40400000000000000000000d01010101010d012121212121212101010d01010d01012d012d0121212d0000000040f2e515151510451515104040451510404515151515151040000d0b0c010102020e0b1c1b0c0101010101212e01010101212101020b1c1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 024:d01212d0d010101010101010101010d0b1c11020101010101010101010d0000000000000000000040151515151515104000000000000000000000000000000000000000000000004151515151515150400000000000000000000d01010101010d012121212121212121210d0d010d01212121212121212d0000000040f2e040404040404040404171751511704040404045104040000d0b1c112101010e0b0c0b1c1b0c010101010061010121212121010b0c0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 025:d0d0d0d0d0d01010105c6c1010daea10a8b82020104858104a5a101010d0000000000000000000040251515151515104000000000000000000000000000000000000000000000004151532425215150400000000000000000000d01010101010d0121210d0d0d010101010d01010d012d0d0d0d0d0d0d0d0000000040f2e041717171717171704515151515104041717175117040000d0b0c012121010e0b1c16171b1c120101010e01012121212121210b1c1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 026:d010101010d0d010105d6d1010dbeb10a9b92010104959104b5b101010d0000000000000000000040351515151512104000000000000000000000000000000000000000000000004151515515115150400000000000000000000d03040404050d0101212d010d0d0121210d01010d01212121212121212d0000000040f2e045151515151515104515151515117170e3d3d3d4c040000d0b1c112121210e010106272312020101010e010121212121212106060d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 027:d01008181010d01010b0c0101010101010101010101010101010101012d0000000000000000000045151515151512204000000000000000000000000000000000000000000000004151515151515150400000000000000000000d01010101010d0d01212d0121212121212d01012d01212101012121010d0000000040f2e045151045151040404040404040404040fdedede2e040000d0b0c012121212e010101010101010102020e01010121212121010b0c0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 028:d01009191010101010b1c1103040404040405010100a1a101010101212d0000000000000000000040404040404040404000000000000000000000000000000000000000000000004040404350404040400000000000000000000d01010101010d0101212d01212d0d0d0d0d0d012d030404040404050d0d0000000040f2e045151045151171717171717171717040fde2cde2e040000d0b1c11212121207e010b0c0b0c0b0c020e0071010101212101010b1c1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 029:d03110101010d0d0d0d0d0d01010251010102020100b1b101010101212d0000000000000000000575757575757575757000000000000000000000000000000000000000000000057575704040457575700000000000000000000d01210101010d0121212d01212d0121212d01212d01010102510101010d0000000040f2e045151045151515151045151515151040fdedede2e040000d0b0c0121212121207e0b1c1b1c1b1c1e0b0c01010101010251010b0c0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 030:d010101010101212121212d0d010102531101020201010101010121212d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000057575700000000000000000000000000d0121210101012121210d01212d012d012d01212d01020101025311010d0000000041f1d175151045151515151045151512351041f3f3f3f1d040000d0b1c112121212121207e0e0e0e0e0e007b1c11010101025101010b1c1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 031:d01010101212121012121212d01025251010101020201010121212b0c0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0121212101012121212d01212d012d012121212d01020102525101010d0000000040404040404040404040404040404040404040404040404040000d0b0c0b0c0b0c0b0c0b0c0b0c0b0c0b0c0b0c0b0c0b0c02525b0c0b0c0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 032:d01010121212121212121212d01025252510101010201012121212b1c1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0121212121010121210d012121212d010121212d01010102525251010d0000000575757575757575757575757575757575757575757575757570000d0b1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c12525b1c1b1c1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 033:d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 034:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 035:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d025252525d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d01010101025252525d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 036:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e000000000000000000000000000d0252525251061711010d0411060121212121212121212121212121012d0000404040404040404040404040404040404000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d010101010102010252525d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 037:0000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e00000000000000000000000000000e0e0e03737373737378737e0e0e00000000000000000000000d0251025251062721010d01010d0d01212121212121212121212121212d0000465171717045427272727272727272704000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d092a210101020202010252525d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 038:00000000000000040404040404040404040404040404000000000000000000000000000000e0e0e0e0e03737373737373737e0e000000000000000000000000000e03737838383f0f0f087f03737e0e0e0e00000000000000000d0101025101010103110d010d0d012121212121212d0d0d0d0d0121212d0000451515151041414141414141414141404000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d093a310102020202020252525d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 039:0000040404040404c404d404173343531704c504e50404040404040000000000000000e0e0e037373737f0f0f0f0f0f0838337e0e00000000000000000000000e0e08383838383f0f0f087f08383373737e0e0e0e0e000000000d0101010251020101010d0d0d01212121212121212d0d0d0d0d0121212d0000451515114041414040414040414141404000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d012121010102020201010252525d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 040:00000417171717045104510451515151510451045104171717170400000000000000e0e0373783f0f0f0f0f0f0f0e0e0f0838337e0e000000000000000000000e03783838383f0f0e0e0e0e0838383f0f037373737e0e0000000d0102010101020201010d012121212121212121212d0d0d0d0d0121212d0000451511414271414042714270414141404040404040404040000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0121212101020101010101012d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 041:000004162636460451045104516b6b6b51045104510415f5b61504000000000000e0e0378383f0e0e0f0f0f083e0e0e0f0f0838387e0e0000000000000000000e0e0838383f0e0e0e00000e0e08383f0f0f0f0f0f037e0e0e000d0d012d0d0d0d0d0d0d0d012121212121212121212d0d0d0d0d0121212d0000404040404041414041414140404040404442727272727040000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d01212121010101010121212d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 042:000004151515151551e451f45151515151b551d551151515151504000000e0e0e0e03783f0f0e0e0e0f0838383e0e0e0e0f0f0f08737e0e0000000000000000000e08383e0e0e00000000000e0e08383f0f0f0f0f0f0e082e000d01212121212121012121212121212121212101212d0d0d0d0d0121212d0005757575757041414041414140427272704141414141414040000000000d0d0d0d0d0d0d0d0d0d0d0d0d012121212121212121212121212d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 043:0000040404041515515151515132425251515151511515c6d61504000000e0378237f0f0f0e0e000e0e0e08383e0e0e0e0e0f0f087f037e0e0e0e0e0e0e0000000e0f0f0e00000000000000000e0e08383f0f0f0f0f037f0e000d012121212121212121212121212d0d0d0d01212121212121212121212d0000000000000041414040404040414141404141414141414040000000000d0d0d0d0d0101010d0d0d0d012121212d0d012121212121212d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 044:000004155615150404040404115151511104040404041515151504000000e0f0f0f0f0f083e0000000e0e0838337e0e0e0e0e0e0e0e0f037373737e0e0e0e00000e0e0f0e0e0e000000000000000e0e08383f0f0f0f0f0f0e000d012121212121212121212121212d0d0d0d01212121212121212121212d0000000000000041414272704272714141404141414141414040000000000d0d0d0d010101010101012121212d0d0d0d0d0d0121212d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 045:00000451515151046a6a6a04515151515104e604f6045132425204000000e0e0f0f0f08383e000000000e0e0838337e0e000000000e0e0e0f0f0f0373737e0e0e0e0e0f03737e0e0e0000000000000e0e0e0e0e0e0e0e0e0e000d01212d0d0d01212121212121212d0d0d0d01212121212121212121212d0000000000000041414141427141414141404141414141414040000000000d0d0d0d01010101010101012d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 046:00000404040404045151515151515151515151515104040404040400000000e0e0e0e0e0e0e00000000000e0e0838365e0e00000000000e0e0e0e0e0e0f03737e0e0e0f0f0f0373737e000000000000000000000000000000000d01212d0d0d01212121212121212d0d0d0d01212121212121212121010d0000000000000041414141404141414141427141414141414040000000000d0d9d9d910101010101010d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 047:0000575757575704040404040404350404040404040457575757570000000000000000000000000000000000e0e08383e0e000000000000000000000e0e0f0f0373737f08383838383e000000000000000000000000000000000d01212d0d0d01212121212121212121212121212121212121212101010d0000000000000040404040404040404040404040404040404040000000000a0707070a2101010101010d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 048:000000000000005757575757570404045757575757570000000000000000000000000000000000000000000000e0e0e0e0000000000000000000000000e0e0e0f0f0f08383838383e0e000000000000000000000000000000000d012121210121212121212121212121212121212121212121210101025d0000000000000575757575757575757575757575757575757570000000000a170707070a2d8d0101010d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 049:000000000000000000000000005757570000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e00000000000000000000000000000000000d012121212121212121210121212121212121212121012121210102525d0000000000000000000000000000000000000000000000000000000000000a07070707070c8d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 050:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0000000000000000000000000000000000000000000000000000000000000a190a090a070d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 051:d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0e0e0e0e0e0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 052:d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0e0e0e0e0e0e0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 053:d020201010101010101010101010252510d0d0d0d0d0d0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0101010101010d04110d010101212121212121212d0d0102510101010101010101010121210b0c01010101010101010101010d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 054:d020101010101010102010101010102510d0d0d0d0d0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e01010101010d01010d010101012121212121212d0d0251010101010101010101010121212b1c11010101010e0e0e0e0e010d0000000000000000000000000000000000000000000000000000000000000000000000000000004040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 055:d010121012101010102020101010251010d0d0d0d0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e01010101010d01010d010101010121212121212d0d0101010101010101010101012121212121010101010e0e0070707e010d0000000000000000000000404040404040404040404000000000000000000000000000000040404171717041717040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 056:d012121212101010101010101010101010d0d0d0d0d0d0d08110101010d0e0e0e081e0e0e0e0e0e0e0e0101010d01010d0d0d0d0d0101212121212d0d01010101010101010101212121212121212101010100607101010e0e0d0000000000000000000000417171717171717041704000000000000000000000000000000041317515151175151171704000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 057:d0121212d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d01010101010d0d0b0c0101010101010101006101010d01010d0d0d0d0d0101010121212d0e0e0e0e0e0101010101212121212e0e0e0e0e0e0e0e0e01010101007e0e0000000000000000000040451163626363646045604000000000000000000000000000000045151515151040e3d3d4c04040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 058:d01212121212121212121212d0d0d0d0d0b0c0d0d0d0d0d01010101010d0d0b1c11010101010101010e0101010d01010d0d0d0d0d0101010101012d0d0070707e0e0e0e0e0e0e0e0e0e0e00707070707070707101010101007d00000000000000000000417518494949494a4175104000000000000000000000000000000045151515151040fdede2e0417171717170400000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 059:d01212d01212121212121212d0d0d0d0d0b1c1d0d01212121012d0d0d0d0d0b0c010101010101010e007101010d01010d0d0d0d0d0102010101010d0d0101020070707b0c00707070707071010202010101010101010101012d00000000000000000000451518595959595a5515104000000000000000000000000000000040404040404040f2c2c2e175151515151040000000000000000000000000000e0e0e0e0e0e03737373737378237e0e0e0e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 060:d0d0d0d0d0d0d0d0d0d01212d0d0d01212101212d01212121212121212d0d0b1c1101010101010e007102010d0d01010d0d0d0d0d0102020101010d0d0101020201010b1c11010101010101010202020201010101010101012d00000000000000000000451518696969696a6515104000000000000000000000000000000041717171717170f2c2c2e0451515151510400000000000000000000000000e03737373737378383f0f0f0f0f9f037e082e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 061:d01212121212121012121212d0d0d01212121212d0d0d0d01212121212d0d0b0c01010101010e00710102010d010101010d0d0d0d0101010102531d0d010102020201010101010101010101010102020202010101010121212d0000000000000000000043242525151515151515104000000000000000000000000000000045151515151510fdede2e04515151515104000000000000000000000000e0e0838383838383838383f0f0f0f9f07737f037e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 062:d01212121212121212121212d0d0d01212121212d010121212d01212d0d0d0b1c110101010e0071010101010d0101212121010101010d010252510d0d010101020202010101010101010101010101010101010101012121212d0000000000000000000040404040435040404040404000000000000000000000000000000045151515151511f3f3f1d04515151515104000000000000000000000000e037838383e0e0e0e0838383f0f0f9f077f0f0f0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 063:d01212d0d0d0d0d0d0d0d0d0d0d0d01212d0d012d0121212d0d0121210d0d0e0e0e0e0e0e007101010201010d0121212121212101010d010252510d0d0d9d9d9d9d9d9d8d8d8d8d8d9d9d9d9d9d9d9d9d9d9d9d9d9d8d8d8d8d00000000000000000005757575704040457575757570000000000000000000000000000000404040404040404040404040404043504040000000000000000000000e037f083838337e0e0e0e0838383f0f9f077f0f0e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 064:d012121212d0121012d01212d0d0d01212d0d012d01212d0d0d012d0d0d0d00707070707071010102020101060121212121212121010d025252510d045707070707070c9d9d9d9e97090a070707070707070707070c9d9d9d9d00000000000000000000000000057575700000000000000000000000000000000000000005757575757575757575757575757040404570000000000000000000000e0f0f0f083838337e0e0e0e0838383f9f077f0f0e067000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 065:d01212d012d0121212121212d0d0d01212d0d012121212d0d0d01241d0d0d012121212121210101010101010d0121212121212121210d025252525d04570707070707070707070707091a170707070707070707070707070704500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005757570000000000000000000000e0e0f0f0f0f083838337378237838383f98377f0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 066:d01212d01212121212d012121212121212d0d0d0d0d0d0d0d0d01212d0d0d012121212121212121210101010d0121212121212121212d025252525d045707070707070707070707070707070707070707070707070707070704500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0f0f0f0f0f083838383f797979797a7837783e06700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 067:d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d045454545454545454545454545454545704545454545454545454545454500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e077e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 068:454545454545454545454545704545454545454545454545454545454545454545454545d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0454545454545454545454545457045454545454545454545454545454545d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0d0d0d0d0d0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000e0e0e077e0e0e0000000000000000000000000000000000000000000000000000000e0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 069:457070707070707070707070707070707070707070707070707070707045457070707070d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d02525d0457070707070707070707070707070707070707070707070707070707045d0d0d02525d0d0d0d0121212121212121212121212d010101010101010d0d041101212121212e0101010b0c0e01010101010101010101010b0c020d0000000e08237f037e0e0000000000000000000000000000000000000000000e0e0e0e0e0e0e082e0e0e0e0e0e0e0e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 070:457070707070707070707070707070707070707070707070707070707045457070707070c81010101010101010101010e012121212121006101025d0457070707070707070707070707070707070e0e0e0e0e0e0e0e0e0e0e045d0d0d02525d0d0d01010121212121212121210121260101010101010d0d0d010101212121212e0e01010b1c1e0e010101010b0c010101010b1c120d00000e0e0f983f0e0e067000000000000000000000000000000000000000000e03737823737e0704747474747474747e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 071:457070707070707070707070707070707070707070707070707070707045457070707070c81010101010101010101010e0121212121212e0101010d045707070707070707070707070707070e0e0e0b0c0b0c0b0c041b0c0e0e0d0d0d02525d0d01010101012121212121210101012e0e0e0e0e0101041d0d01212121212121210e0e010101007e010101010b1c110102020102020d00000e037f983e0e0670000000000000000e0e0e0e0e0000000000000000000e0e0f0f9f0e04770707070707090a07047e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 072:45707070707070707070707070707070707070d1e1e1e1e1f170707070454590a0707070c81010101010201010101010e01012d0d0d0d0e0101010d0d0d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7e01010b1c1b1c1b1c110b1c1d0e0d0b0c02525b0c010101010101212121292a21010e0e0e0e0e0e0e01010d0d0121212121212121210e0e0101010e01010e0e0e0e010102020202020d00000e083f983e06700000000000000e0e0e0376537e0e0000000000000000067e0e02a70477070707070707091a1707047e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 073:4570707070c7d7d7e770707070707070707070d2e2e2e2e2f270707070454591a1707070c81012101010102020101010e0121212121212e0e0e0e0d0d0b0c010b0c0b0c0b0c0b0c0b0c0b0c0e0e010b0c012b0c01010b0c0d0d0d0b1c12510b1c110101010101010101093a310e0e0e0e0e0e0e0e0e010d0d012121212121212121210e0b0c010e0101006070707e0101020202020d00000e083f983e000000000000000e0e03737f0f0f037e0e00000000000000000e04770707070707070707070707070707047e0e00000000000000000000000000000000000000000000000000000000000000000000000000000
-- 074:4570707070c8d041e870707070707070707070d2e2e2e2e2f27070707045457070707070c81012121210102020201010e0121212121210060707e0d0d0b1c110b1c1b1c1b1c1b1c1b1c1b1c1e0e0e0b1c112b1c11010b1c112d0d0101010251010e0e0e0e010101010101010e0e0e0e0e0e0e0e0e0e0e0d0d012121212121212121210e0b1c110e01010e010101007e010102020d0d00000e083f983e0e0000000e0e0e08237837777f0f0f037e00000000000000000e0707070707070707070707070e0e0e0707047e0e000000000000000000000000000000000000000000000000000000000000000000000000000
-- 075:4570707070c81212e870707090a07070707070d2e2e2e2e2f27070707070707070707070c81212121212102020201010e0e0e0e0e0e0e0e01010e0d0d0b0c010b0c06171b0c0b0c01212b0c00707e0e0121212b0c060601212d0d01010101010e0d01212e0101010101010e0e0e0e0e0e0e0e0e0e0e0e0d0d012121212121212121010e0e0e01007e0e0e010101010e0606060d0d0d00000e083f98337e0e0e0e0e03737f983f0f07777f0f0f0e00000000000000000e0e0707090a070707070e0e0e03737e070707047e000000000000000000000000000000000000000000000000000000000000000000000000000
-- 076:4570707070c9d9d9e970707091a17070707070d2e2e2e2e2f27070707045457070707070c8101212121210101010101007070706070707071012e0d0d0b1c110b1c16272b1c1b1c11212b1c1101207e0e01212b1c110121212d0d010121010e0d0121210e010101010b0c0e0e0e0e0e0e0e081e0e0e0e0d0d0121212121212121010101010061010d00707101010e0e010101010d0d00000e083f9838337373737378383f983f0f0f0777777f0e0000000000000000067e0e00c91a170707070e03737f0f0e0707070e0e000000000000000000000000000000000000000000000000000000000000000000000000000
-- 077:45707070707070707070707070707070807070d3e3e3e3e3f37070707045457070707070c81010121212101010101010101010e0101010121212e0d0d010101010311010101060121212121012101007061012121010101212d0d012121212e0d01210100610101010b1c1e0e041106010101010101010d0d0d0d0d0d0d0d0101010101010e01010d010101010e0e0101010101010d00000e083f98383f0f0f0838383833af0f0f0f0f0f07777e000000000000000000067e0f9e0e0e0e0e07047e0f0f0f0477070e0e06700000000000000000000000000000000000000000000000000000000000000000000000000
-- 078:457070707070707070707070707070707070707070707070707070707045457070707070c81010101010101010101010e0e0e0e0101012121212e0d0d0b0c010101010101010b0c01212b0c012121212e01210101010101012d0d012121212e0d0d01210e0101010101010e0e010106010101010252525252525252525102510101010e0e0e02010d01010e0e0e010101010101010d00000e083f98383f0f0f0f0f0f0f03bf0f0f0f0f0f083e0e000000000000000000000e0f7f8e06767e0e07047e0e0e0e070e0e0670000000000000000000000000000000000000000000000000000000000000000000000000000
-- 079:457070707070707070707070707070707070707070707070707070707045457070707070c81010101010101010101010e0101006101012121212e0d0d0b1c112101010101010b1c11212b1c1121212e0e03040404040404050d0d01212121207e0d0d012e010101010101007e010106010101010251025d0d025252525251010101010e007072010d01010e0101010101010101010d00000e083f98383f0f0f0f0f0f0f0f9f0f0f0f0f08383e00000000000000000000000e0e0f9e0e0e0e0e0e07047477547e0e067000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 080:457070707070707070708070707070707070707070707070707070707045457070707070c81010102010101010101010e01010e0e0e0e0e0e0e0e0d0d0101012101212121212126012121210121212e0072020101010251010d0d0121212121207e0e0e0e010101010101010e0e0e06010101010101010d0d0d0d0d0d0d0d010101010e020201010d01010e0201010101010101010d00000e0e0f7979797fa9797979797a7f0f08383838383e0e0000000000000000000e0e037f937474747474770707070e0e06700000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 081:457070707070707070707070707070707070707070707070707070707045457070707070c81010102020101010101010e01010e007070707074107d0d0b0c012b0c012b0c012b0c01212b0c0101210e0122020101025101010d0d012121212121207070707101010101010100707e0e0e010101010b0c0d0d012121212121220201010e020202010101010e0202020102510101010d0000067e0e0e070702a7070f0f0f0f0f0f0838383838383e0000000000000000000e037f0f9707070707070e0e070e0e0670000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 082:457070707070707070707070707070707070707070707080707070707045457070707070c81010102020202010101010e06060e010102020101010d0d0b1c112b1c112b1c112b1c16060b1c11010e0e0121210b0c02525b0c0d0d0121212121212121212121010101010102525250707e0e0e01010b1c1d0d012121212121212202010e0e0b0c010d01010e0b0c020101025101010d00000006767e0707070707070f0f0f08383838383838383e0000000000000000000e0f0f0f7f870707070e0e0e0e0e067000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 083:457070707070707070707070707070707070707070707070707070707045457070707070c81010102020202010101010e010101010101010101010d0d0d01212121212121212101010101010e0e0e007121212b1c12525b1c1d0d01212121212121212121212101010102510252525100707e0e0e0e0e0e0d01212121212121212202020e0b1c110d01010e0b1c120202525101010d000000000e047707070707070e0e0e08383838383838383e0000000000000000000e0e0e0f0f9f07070e0e06767676700000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 084:454545454545454545454545454545454570454545454545454545454545454545454545c8d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0e0d0d0d0d0d0d0d0d0d0d0d0d0d0e0e0e0e0e0e0e0d0d0d0d025d0d0d0d0d0000000e0e0457045e0e0e0e0e067e0e0e0e0e0e083e0e0e00000000000000000006767e0e0e0e0e0e067670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 085:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0e0e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d000000000000000000000000000000000e0e0e0e083e0e067000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 086:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0101010101010101010121212121212101010101010101012121212d0d0101010101212121212d0d0d0d0d0d0121210252510d0d04112d0d0d0d0d00707e0e0e010101010101010101010101010202020d010252510d012d000000000000000000000000000000000e03737378337e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 087:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d04110e0e0e0e010101010101212121212121010d0d0d0d0d010121212d0d0101010d0d0d012121212d0d0d0d0d0121210102510d0d0121212d0d0d0d012120707e0e0101010101010e0e0e0e0e010102020d010102510d012d000000000000000000000000000000000e0f0f0f0f0f0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 088:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d01010e0e0e0e0e01010101010101212121212d0d0121212d0d0101212d0d0101212d0d0d012121212d0d0d0d01212121025101010d0d0121212d0d0d01212121207e0e01010101010e0e081e0e0e0101020d010251010d012d0000000000000000000000000000000e0e0f0f0f0f0f0e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 089:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0d012d0d0d0d0d0d01212d01212121212d0101212d0d012121212d0121212d0d0d0d0d012121212101010101010d0d0121212d0d0121212121207e0e0e0101010e0071207e0e0101010d010101010d012d0000000000000e0e0e0e0e0e0e0e0e0e0377777777777e067000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 090:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0601010b0c012d0d012d0d0121212d0d0101212d0d0d0d0d0d01212d0d0d0101212121212d0d012121210101010d0d01212d0d01212121212100707e0101010e0e0121207e0101010d0d01010d0d012d000000000e0e0e0e0e037373737373737f0f0f0f0f0f0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 091:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0101010b1c11212d01212d0d0d012d010101012d0d0d0d0d0d0d012d0d0101010121212d0d0d0d0d0d0d0d0d0d0d0d01212d0d0d0d0d0d0d0101010e01010101006101212e010101010101010101212d000000000e0e082e037f0f077f0f0f0f0f0f0f0f0f08382e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 092:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e010101212121212d010121212d0121010101010d0d0d0d01012121212d0121010101212d0d0d012121212d0121210101010d0d025101010d0101010e0e0101010e0121212e010101010101010101212d000000000e037f037f0f0f07777f0f0f0f0f083838383f9e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 093:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e012121212121212d0101010121212d0d0d0d0d0d0d0d0d01010121212121212101010d0d0d01212121212121210102525252525252525101010101007e0e0e0e0e0101210e010101010101010101212d000000000e0f0f0f0f0f0f0f0b7979797979797979797a7e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 094:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e012121212121212d01010101212d0d0121212d0d0d0d01212121212121212d0d010d0d012d0d012121212d0121025102525d0d02525101010101010100707070707101010e010102010101010101212d000000000e06e7ef0f0f0f0f0f97777f0838383838383e067000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 095:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e030404040404050d010101010d0d01212121212d0d0d0d0d030404040404050d0d0d0121212d012d01212d0d0d0d0101010d0d025101010d01010101010201010101010e01010102020101010121212d000000000e06f7f9797979797a7f07783838383838383e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 096:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e081e0e0e0311010e012121212121212d01010101010121212121212d0d01212d0d0d01212121212d0d012121212d012d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d012121010201010101010e0b0c010202020101212b0c0d000000000e0f0f0f0f0f0f0f0f08383838383838383e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 097:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d01010101010101010e012121212121212d0101010d0d0121212121212d0d012121212d012d0121212d01212d0d0d0d01212121212121212617112d0d04112121212d0121212122010101010e0e0b1c110102020121212b1c1d000000000e0e0e0f0f0f0f0e083838383838383e0e0e06700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 098:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d010101010101010100610121212121212d0101010d012121212121212d0d0121212121212d0d0d012121212d0d0d0d0d0d0121212121231627212d0d01212121212d0121212121212101010e0b0c0b0c0b0c0b0c0b0c0b0c0d0000000006767e0e0e0e0e0e0e0e0e0e0e0e0e0e067670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 099:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d010101010101010e0e0d012121212d0d0b0c010d0d0121212121212121212121212121212d0d0d0d0d01212d0d0d0121212121212121210101012d0d01212121212d0121212121212121210e0b1c1b1c1b1c1b1c1b1c1b1c1d0000000000000676767676767676767676767676700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 100:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d060b1c110d01212121212121212d0d01212121212d0d0d0d0d0d012121212121212d0121212121010101212d0d0121212121212121212121212121212e0b0c0b0c0b0c0b0c0b0c0b0c0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 101:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0b1c1b1c1b1c1b1c1b1c1b1c1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:0007000510031001200f200d300b3009400840005000500060006000700070008000800090009000a000a000b000b000c000c000d000d000e000e000400000000009
-- 018:04000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040000a000000000
-- </SFX>

-- <FLAGS>
-- 000:00000040404080218010101010101000101010101000101010101010100000000020101010001010101010101000000000000010101010102010101010000000100000000000101000000010101010100000000010001010000000101010101000101010101000000000001010101010000000000100008080000000000000001010101010101010101010100000000010101010101010101010101000000000101011001010100000000000001010001010000010101000000000000010100011000000001010000000000000000000000000000010100000000000000000000000000010101010000000000000000000000000101010100000000000000000
-- </FLAGS>

-- <PALETTE>
-- 000:0000001d2b537e255383769cab5236008751ff004d5f574fff77a8ffa300c2c3c700e436ffccaa29adffffec27fff1e8
-- </PALETTE>

