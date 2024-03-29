-- title: Jackamon 1.9
-- author: Balistic Ghoul Studios
-- desc:  A game like pokemon (See PICO-8 for my other games)
-- script: lua

DEBUG=false
--DEBUG=true
--sync(39,2)

B_OK=5
B_BACK=4

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
  print("Ver 1.9",1*8,15*8,7,0,1,1)
  print("Press X",11*8,14*8,15)
  if btnp(B_OK) then
    start_explore()
  end
end

function tablesAndStuff() end

rooms={}
roomn=nil
room=nil
exitn=nil

player={ spr_idle = { 256, 261 }
       , spr_move = { 256, 257, 258, 259, 260 }
       , spr_idle_t = 0
       , spr_idle_t_def = 45
       , spr_move_t = 0
       , spr_move_t_def = 20
       , spr_i = 1
       , spr=256  -- *** change later
              , i_hp=0
              , i_max=0
              , i_swim=0
              , i_rock=0
              , i_file=10
              , i_bonus=0
              , i_poi=0
              , i_par=0
              , i_con=0
              , i_bur=0
              , i_see=0
              , flp=0 }

mons={}
play_mons={}
seen_mons={}
active_mon=nil

function healthy_mons()
 for mn,mi in pairs(play_mons) do
   if mi.hp > 0 then
     return true
    end
  end
  return false
end

function get_mon(mn)
 play_mons[mn]= { hp=mons[mn].hp
                 , xp=mons[mn].xp }
  seen_mons[mn]=true
  if active_mon == nil then
   active_mon = mn
  end
end

function start_explore() 
 scene=sc_explore
 if not DEBUG then
    enter_room(2,1)
 else
    enter_room(1,2)
      get_mon(3)
      get_mon(1)
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
  spr(p.spr,p.x*8,p.y*8,0,1,player.flp)
end

function sc_explore()
  local p=player
  if p.spr_move_t > 0 then
    p.spr_move_t = p.spr_move_t - 1
    if p.spr_move_t == 0 then
      p.spr_idle_t = p.spr_idle_t_def
      p.spr_i = 1
    end
  end
  if p.spr_move_t == 0 then
    p.spr_idle_t = p.spr_idle_t - 1
    if p.spr_idle_t <= 0 then
      p.spr_idle_t = p.spr_idle_t_def
      p.spr_i = (p.spr_i % (#p.spr_idle)) + 1
    end
    p.spr = p.spr_idle[p.spr_i]
  end

  draw_explore()
        
  function move(dx,dy)
    p.spr_move_t = p.spr_move_t_def
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
         start_battle(room.mons[ math.random( #room.mons ) ] )
        return
        end
      end
      if not fget(mget(mnx,mny),0) then
       p.x=nx
        p.y=ny
        p.spr_i = (p.spr_i % (#p.spr_move)) + 1
        p.spr=p.spr_move[p.spr_i]
      end
      return
    end
    --- XXX add a bump sound
  end
  if btnp(0,1,10) then move(0,-1) end
  if btnp(1,1,10) then move(0,1) end
  if btnp(2,1,10) then move(-1,0) player.flp=1 end
  if btnp(3,1,10) then move(1,0) player.flp=0 end
  
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

battleSteps = {}
battleSteps["MSG"] = 
 { t = 32
 , next = "TRANS" }
battleSteps["TRANS"] = 
 { t = 32
 , next = "BATTLE" }
battleSteps["BATTLE"] =
 { t = 1
  , next = "BATTLE" }
battleSteps["BATMSG"] = 
 { t = 32
 , next = "BATTLE" }
battleSteps["BATOVER"] =
 { t = 1
  , next = "BATOVER" }

function batItems()
 batMessage(
   "You tried to look at your items...",
    batNotReady)
end
function batMon()
 local B=battle
  B.step="BATOVER"

 scene=sc_dex
  dex={ draw = sc_battle
      , selected=active_mon
      , select = true
      , after = function(smn)
              if smn then 
                 active_mon=smn
                  scene=sc_battle
                  batMessage(
                   "You switch to "..mons[smn].name,
                    batEnemyTurn)
                else
                  scene=sc_battle
                  B.step="BATTLE"
                end
            end }
end

function batEvalAttack(rator, ratora, rand, randa, atk, plvl, alive, dead)
 return function()
  --- XXX animation
   --- XXX effect
   --- XXX defense / type
   local ratori = ratora[rator]
   local randi = randa[rand]
   randi.hp = math.max(0, randi.hp - (atk.dmg * plvl))
    if randi.hp == 0 then
     dead()
    else
     alive()
    end
  end
end

function batEnemyTurn()
 local B=battle
 local en=B.en
  local mi=mons[en]
  local atks=mi.atks
 local atki=atks[ math.random( #atks ) ]
  local atk=atki[1]
  local power_lvl=atki[2]

 batMessage(
   "The "..mi.name.." used "..atk.name.."...",
    batEvalAttack(B.en, B.mons, active_mon, play_mons, atk, power_lvl,
     batBackToBattle, batPlayerDead))
end
function batNotReady()
  batMessage(
    "But, we didn't implement it yet!",
    nil)
end
function batRun()
 batMessage(
   "You try to run away...",
    function ()
   if math.random() <= 0.5 then
    batMessage(
         "...and you got away!",
          batOver)
    else
       batMessage(
         "...but you couldn't escape!",
          batEnemyTurn)
      end
   end)
end

function batMessage(m, after)
 local B=battle
  B.step="BATMSG"
  B.t=battleSteps[B.step].t
  if not after then after="BATTLE" end
 battleSteps[B.step].next=after
  B.msg=m
end
function batBackToBattle()
 local B=battle
 B.step="BATTLE"
  B.t=battleSteps[B.step].t  
end

function batDoAttack(atk, power_lvl)
 local B=battle
 batMessage(
   "You used "..atk.name.."...",
    batEvalAttack(active_mon, play_mons, B.en, B.mons, atk, power_lvl,
     batEnemyTurn, batEnemyDead))
end
function batAttack()
 local B=battle
 local bm={}
  local am=active_mon
  local mi=mons[am]
  
  bm.idx=0
  bm.back=function() B.bm=batMenuTop end
  bm.opts={}
  for aidx, ai in ipairs(mi.atks) do
   local atk=ai[1]
   bm.opts[aidx]=
     { label=atk.name
     , a=function ()
           bm.back() 
           batDoAttack(atk, ai[2])
              end }
  end
 B.bm=bm
end

function batPlayerDead()
 --- XXX switch active_mon
 batMessage(
   "Your "..mons[active_mon].name.." fainted!",
    batOver)
end
function batEnemyDead()
 local en=battle.en
  --- XXX do XP
 batMessage(
   "You defeated the "..mons[en].name.."!",
    batOver)
end

batMenuTop={ idx=0
                      , opts={ {label="ATTACK",a=batAttack}
                             , {label="ITEMS",a=batItems}
                                    , {label="MON",a=batMon}
                                    , {label="RUN",a=batRun} }
                      , back=function() end }

function batOver()
 scene=sc_explore
end

battle = nil
function start_battle(mn)
  local which_trans = math.random(2)

 battle={ t=battleSteps["MSG"].t
         , step="MSG"
         , trans=which_trans
         , en=mn
                , bm=batMenuTop
                , mons={} }
  battle.mons[mn] = { hp=mons[mn].hp 
                    , e=e_normal}
 seen_mons[mn] = true
  for pmn, pi in pairs(play_mons) do
   pi.e = e_normal
  end

  scene=sc_battle
end
function sc_battle()
 local B = battle
 if B.step == "MSG" then
   draw_explore()
   draw_msg("A wild " .. mons[B.en].name .. " approaches!")
 elseif B.step == "TRANS" then
    local trans_mx = 150 + 30*B.trans
   local trans_my = 0
   draw_explore()
    local clear = 0
    if ( B.t % 32 < 16 ) then clear = 15 end
    map(trans_mx, trans_my, 30, 17, 0, 0, clear)
  elseif B.step == "BATTLE" or B.step == "BATMSG" or B.step == "BATOVER" then
   local scr=battle_scrs[mget(room.mx+p.x,room.my+p.y)]
    map(scr.x, scr.y, 30, 17)
    
    local am=active_mon
    spr(monspr(B.en), scr.ex*8, scr.ey*8, 0, 4)
    spr(monspr(am), scr.px*8, scr.py*8, 0, 4)
    
    function showmoninfo(mn, mtab, ix, iy)
     local nm=mons[mn].name
      local hpx=(ix+1)*8
      local hpy=(iy+2)*8
      local hpw=5

      draw_box(ix*8, iy*8, hpw+5, 3)
      print(nm, (ix+1)*8, (iy+1)*8)
      spr(262, hpx+8*0, hpy, 8)
      spr(263, hpx+8*1.25, hpy, 8)
      for i=0,hpw-3 do
       spr(264, hpx+8*(2.25+i), hpy, 8)
      end
      spr(263, hpx+8*(0.25+hpw), hpy, 8, 1, 0, 2)
      
      local e=mtab[mn].e
      spr(278+16*(e//5)+e%5, hpx+8*(1.5+hpw), hpy, 8)
      
      local hp_per=mtab[mn].hp/mons[mn].hp
      local hpc=11
      if ( hp_per <= 0.5 ) then hpc=14 end
      if ( hp_per <= 0.25 ) then hpc=6 end
      rect(hpx+8*1.25+1, hpy+3, (14+8*(hpw-2))*hp_per, 2, hpc)
    end
    showmoninfo(B.en, B.mons, 1, 0.5)
    showmoninfo(am, play_mons, 12, 12.5)
    
    --- Show attack menu
    local Bm=B.bm
    local amx=23.5*8
    local amy=11.5*8
    local bmMax=#(Bm.opts)
    draw_box(amx, amy, 5, 4)
    for oidx, oi in ipairs(Bm.opts) do
     print(oi.label, amx+8, amy+4+8*(oidx-1))
    end
    spr(285, amx+1, (amy+2)+8*(Bm.idx), 0)
  
   if B.step == "BATMSG" then
     draw_msg(B.msg, 4*8, 6*8)
    elseif B.step == "BATOVER" then
     local nop=0
    else  
   function move(dm)
     Bm.idx=(Bm.idx+dm)%bmMax
    end
    if btnp(0,1,10) then move(-1) end
    if btnp(1,1,10) then move(1) end
  
    if btnp(B_BACK) then Bm.back() end
    if btnp(B_OK) then Bm.opts[Bm.idx+1].a() end
    end
  end

 B.t = B.t - 1
  if B.t == 0 then
    local next = battleSteps[B.step].next
    if type(next) == "function" then
     next()
    else
     B.step = next
     B.t = battleSteps[next].t
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

function draw_msg(m, mx, my)
  mx=mx or 1
  my=my or (15*8-1)
  local w=(string.len(m)+2)*5+2
  draw_box(mx,my,math.ceil((w)/8),1)
  print(m,mx+3,my+6,15,0,1,1)
end

function act_msg(m)
 return function(_r,_oi)
   return function()
     draw_msg(m)
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
   { i_hp={480,"an Avocado"}
    , i_rock={481,"TM Rock Break"}
    , i_swim={482,"TM Swim"}
    , i_max={483,"a Mango"}
    , i_bonus={484,"a Power up token"}
    , i_file={485,"a Capture File"}
    , i_poi={265, "a Poison Antidote"}
    , i_par={266, "a Paralasis Antidote"}
    , i_con={267, "Headache Pills"}
    , i_bur={283, "Burn Medication"}
    , i_see={299, "Glasses"} } 

function act_itm(i)
 return function(room,oi)
   room.obj[oi].a=act_msg("Nothing's here")
   player[i]=player[i]+1
    return act_msg("You found " .. itms[i][2] .. "!")(room,oi)
 end
end

function menu_itms()
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

function menu_mon()
 scene=sc_mon
end
function sc_mon()
 draw_explore()
  
  local 
   mx=5*8
    my=3*8
    mw=16
    mh=5
  
  draw_box(mx,my,mw+1,mh+1)
  if active_mon then
   local mn=active_mon
   spr(monspr(mn), mx+5, my+5, 0, 4)
    --- XXX Jack, adjust to taste  
    print("HP: "..play_mons[mn].hp, mx+5, my+5+4*8)
    print("XP: "..play_mons[mn].xp, mx+5, my+5+4*8+8)
 end
  
 if btnp(B_OK) then
  scene=sc_dex
   dex={ draw = draw_explore
       , selected=active_mon
       , select = true
       , after = function(smn)
               if smn then active_mon=smn end
               scene=sc_mon
             end }
  end
  if btnp(B_BACK) then scene=sc_menu end
end

dex=nil
function menu_dex()
 scene=sc_dex
  dex={ draw = draw_explore
      , selected=active_mon
      , select = false
      , after = function()
             scene=sc_menu
              end }
end
function sc_dex()
 dex.draw()
  
  local these_mons=seen_mons
  if dex.select then
   these_mons=play_mons
  end

  local 
   mx=5*8
    my=3*8
    mw=16
    mh=5
  
  draw_box(mx,my,mw+1,mh+1)
  for i=0,mh-1 do
   for j=0,mw-1 do
     local mn=i*mw+j
      if mn>=80 then
       break
      end
      local mmx=mx+(j+1)*8
            mmy=my+(i+1)*8
      local sn=501
      if these_mons[mn] then
       sn=monspr(mn)
      end
     spr(sn,mmx,mmy,0)
      if (not dex.select and play_mons[mn]) or
         (    dex.select and mn == dex.selected) then
       spr(502,mmx,mmy,0)
      end
    end
  end

 function move(dx, dy)
   if not dex.select then return end
    local dsx = dex.selected % 16
    local dsy = dex.selected // 16
    local ndsx = (dsx + dx) % 16
    local ndsy = (dsy + dy) % 5
    --- XXX adjust when there are more mons
    dex.selected = (ndsy * 16 + ndsx) % 80
  end
  if btnp(0,1,10) then move(0,-1) end
  if btnp(1,1,10) then move(0,1) end
  if btnp(2,1,10) then move(-1,0) end
  if btnp(3,1,10) then move(1,0) end
   
  if btnp(B_BACK) then dex.after(nil) end
  if btnp(B_OK) then 
   local sel = dex.selected
    if these_mons[sel] then
    dex.after(sel)
    end
  end
end

menu={{lab="ITEMS",a=menu_itms}
     ,{lab="MON",a=menu_mon}
          ,{lab="DEX",a=menu_dex}}

battle_scrs = {}

--- XXX add ajust ex, ey, px, py
battle_scrs[33]={x=30, y=0, ex=17, ey=7, px=6, py=10}
battle_scrs[7]={x=180, y=34, ex=17, ey=7, px=6, py=10}
battle_scrs[56]={x=180, y=17,ex=17, ey=7, px=6, py=10}
battle_scrs[81]={x=180, y=51, ex=17, ey=7, px=6, py=10} --XXX There might be a problem here

function monspr(mn) return 400+mn end

function MonTables() end

e_normal=0
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
t_glitch="ERROR"

atk_spurt={name="Gunk", type=t_corrupt,
           dmg=30, s=491, e=e_ink}

atk_grass={name="Leaf", type=t_grass,
           dmg=30, s=488, e=nil}

atk_poison={name="Poison", type=t_corrupt,
           dmg=10, s=505, e=e_poison}

atk_fire={name="Flame", type=t_fire,
           dmg=30, s=486, e=e_poison}
                      
atk_air={name="Fly", type=t_air,
           dmg=30, s=493, e=nil}
                      
atk_bubble={name="Beam", type=t_water,
           dmg=30, s=487, e=nil}

atk_bite={name="Bite", type=t_normal,
           dmg=30, s=504, e=nil}
                    
atk_dragon={name="Pulse", type=t_dragon,
           dmg=50, s=510, e=e_confuse}
                      
atk_zap={name="Zap Bolt", type=t_air,
           dmg=30, s=492, e=a_paralize}
                      
atk_Cfire={name="Cor Flame", type=t_corrupt,
           dmg=30, s=489, e=e_burn}
                      
atk_Cbubble={name="Cor Bubble", type=t_corrupt,
           dmg=30, s=490, e=nil}
                      
atk_punch={name="Karate Chop", type=t_earth,
           dmg=40, s=494, e=e_confuse}
                    
atk_rock={name="Rock Throw", type=t_earth,
           dmg=40, s=495, e=nil}
                      
atk_fear={name="Fear", type=t_normal,
           dmg=0, s=506, e=nil}
                      
atk_cut={name="Slash", type=t_normal,
           dmg=30, s=507, e=nil}
                      
atk_swipe={name="Fury Swipe", type=t_normal, --This ATK can happen between 1-4 times in arow
           dmg=50, s=508, e=nil} --Ok this one is weird, It technacly has Two diffrent ATK spries but for now I'll Just put down one

atk_vamp={name="Vamp Bite", type=t_corrupt,
           dmg=20, s=399, e=e_vamp}
                      
atk_glitch={name="ERROR", type=t_glitch,
           dmg=30, s=398, e=nil}

-----------------------------------------------------------
------------------------MONS-------------------------------
-----------------------------------------------------------

mons[0]={name="Blobb", hp=60, xp=100, types={t_grass},
         atks={{atk_grass,1}, {atk_poison,0.5}}}

mons[1]={name="Blobbo", hp=100, xp=100 ,types={t_grass},
         atks={{atk_grass,2}, {atk_poison,1}}}
                  
mons[2]={name="Blord", hp=140, xp=-1 ,types={t_grass},
         atks={{atk_grass,3}, {atk_poison,2}}}

mons[3]={name="Flegg", hp=50, xp=100, types={t_fire},
         atks={{atk_fire,1}, {atk_air,1}}}
                  
mons[4]={name="Fyrunt", hp=90, xp=100,types={t_fire},
         atks={{atk_fire,1}, {atk_bite,1}}}
                  
mons[5]={name="Fyroar", hp=130, xp=-1, types={t_dragon},
         atks={{atk_fire,1}, {atk_bite,2}}}

mons[6]={name="Pirrah", hp=60, xp=100, types={t_water},
         atks={{atk_bubble,1}, {atk_bite,1}}}
                  
mons[7]={name="Pirrachomp", hp=100, xp=100,types={t_water},
         atks={{atk_bubble,2}, {atk_bite,2}}}
                  
mons[8]={name="Pirgnash", hp=140, xp=-1, types={t_water},
         atks={{atk_bubble,3}, {atk_bite,2}}}
                  
mons[9]={name="Bater", hp=40, xp=100,types={t_corrupt},
         atks={{atk_vamp,1}, {atk_bite,1}}}
                  
mons[10]={name="Batger", hp=80, xp=-1, types={t_corrupt},
         atks={{atk_vamp,2}, {atk_bite,2}}}
                  
mons[11]={name="GIode", hp=60, xp=100, types={t_earth},
         atks={{atk_punch,1}, {atk_rock,1}}}
                  
mons[12]={name="GIger", hp=100, xp=-1, types={t_earth},
         atks={{atk_punch,2}, {atk_rock,2}}}
                  
mons[13]={name="Cink", hp=40, xp=100, types={t_normal},
         atks={{atk_swipe,1}, {atk_fear,1}}}
                  
mons[14]={name="Compi", hp=80, xp=-1, types={t_normal},
         atks={{atk_swipe,2}, {atk_fear,1}}}
                  
mons[15]={name="Coglow", hp=40, xp=-1, types={t_earth},
         atks={{atk_rock,1}, {atk_zap,1}}}
                  
mons[16]={name="Reapo", hp=60, xp=100, types={t_spirit},
         atks={{atk_cut,1}, {atk_vamp,1}}}
                  
mons[17]={name="Reaplur", hp=100, xp=-1, types={t_spirit},
         atks={{atk_cut,2}, {atk_vamp,1}}}
                  
mons[18]={name="Potlil", hp=60, xp=100, types={t_grass},
         atks={{atk_grass,1}, {atk_bite,1}}}
                  
mons[19]={name="Venaomp", hp=100, xp=100, types={t_grass},
         atks={{atk_poison,1}, {atk_bite,1}}}
                 
mons[20]={name="Carvenor", hp=140, xp=-1, types={t_grass},
         atks={{atk_poison,1.5}, {atk_bite,2}}}
                  
mons[21]={name="Corruplil", hp=60, xp=100, types={t_corrupt},
         atks={{atk_poison,1}, {atk_bite,1}}}
                  
mons[22]={name="Corrvena", hp=100, xp=100, types={t_corrupt},
         atks={{atk_poison,1}, {atk_bite,2}}}
                  
mons[23]={name="Corrvenor", hp=140, xp=-1, types={t_corrupt},
         atks={{atk_poison,2}, {atk_bite,3}}}

mons[24]={name="Toxobb", hp=60, xp=100, types={t_corrupt},
         atks={{atk_poison,1}}}
                  
mons[25]={name="Toxobbo", hp=100, xp=100, types={t_corrupt},
         atks={{atk_poison,1}, {atk_vamp,1}}}
                  
mons[26]={name="Toxord", hp=140, xp=-1, types={t_corrupt},
         atks={{atk_poison,2}, {atk_vamp,2}}}
                  
mons[27]={name="Flyrunt", hp=40, xp=100, types={t_air},
         atks={{atk_air,1}, {atk_zap,1}}}
                  
mons[28]={name="Flyig", hp=80, xp=100, types={t_air},
         atks={{atk_air,2}, {atk_zap,1}}}
                  
mons[29]={name="Flyoar", hp=120, xp=-1, types={t_air},
         atks={{atk_air,3}, {atk_cut,1}}}
                  
mons[30]={name="Legi", hp=40, xp=100, types={t_spirit},
         atks={{atk_fear,1}, {atk_vamp,1}}}
                  
mons[31]={name="Legonite", hp=80, xp=-1, types={t_spirit},
         atks={{atk_fear,2}, {atk_vamp,1}}}
                  
mons[32]={name="Majat", hp=40, xp=100, types={t_spirit},
         atks={{atk_fear,1}, {atk_vamp,1}}}
                  
mons[33]={name="Majite", hp=80, xp=-1, types={t_spirit},
         atks={{atk_fear,2}, {atk_vamp,1}}}
                  
mons[34]={name="Voodoll", hp=60, xp=100, types={t_spirit},
         atks={{atk_fear,1}, {atk_cut,1}}}
                
mons[35]={name="Voorip", hp=100, xp=100, types={t_spirit},
         atks={{atk_fear,2}, {atk_cut,2}}}
                  
mons[36]={name="Ripoll", hp=140, xp=-1, types={t_spirit},
         atks={{atk_fear,2}, {atk_cut,3}}}
                  
mons[37]={name="Mallo", hp=60, xp=-1, types={t_normal},
         atks={{atk_swipe,1} }}
                  
mons[38]={name="Erace", hp=100, xp=-1, types={t_earth},
         atks={{atk_rock,2}, {atk_zap,2}}}
                  
mons[39]={name="Erion", hp=100, xp=-1, types={t_earth},
         atks={{atk_fire,2}, {atk_rock,2}}}
                  
mons[40]={name="Eronze", hp=100, xp=-1, types={t_fire},
         atks={{atk_fire,2}, {atk_cut,2}}}

mons[41]={name="Boxsheell", hp=60, xp=100, types={t_normal},
         atks={{atk_swipe,1}, {atk_cut,1}}}
                  
mons[42]={name="Boxcrab", hp=100, xp=-1, types={t_normal},
         atks={{atk_swipe,2}, {atk_cut,2}}}
                  
mons[43]={name="Floatamus", hp=40, xp=100, types={t_grass},
         atks={{atk_grass,1}, {atk_bubble,1}}}
                  
mons[44]={name="Hippadrift", hp=80, xp=-1, types={t_gras},
         atks={{atk_grass,2}, {atk_bubble,2}}}
                  
mons[45]={name="Phlask", hp=40, xp=100, types={t_corrupt},
         atks={{atk_poison,0.5}, {atk_bite,1}}}
                  
mons[46]={name="Noxial", hp=80, xp=100, types={t_corrupt},
         atks={{atk_poison,1}, {atk_bite,2}}}
                  
mons[47]={name="Fumighast", hp=120, xp=-1, types={t_corrupt},
         atks={{atk_poison,2}, {atk_bite,3}}}
                  
mons[48]={name="Pottle", hp=60, xp=100, types={t_earth},
         atks={{atk_grass,1}, {atk_rock,1}}}
                  
mons[49]={name="Trikotta", hp=100, xp=100, types={t_earth},
         atks={{atk_grass,2}, {atk_rock,2}}}
                  
mons[50]={name="Terrocortta", hp=140, xp=-1, types={t_earth},
         atks={{atk_grass,3}, {atk_rock,3}}}
                  
mons[51]={name="Kertruffle", hp=40, xp=100, types={t_corrupt},
         atks={{atk_poison,.5}}}
                  
mons[52]={name="Masshroom", hp=80, xp=-1, types={t_corrupt,t_grass},
         atks={{atk_poison,1}, {atk_grass,1}}}
                  
mons[53]={name="Lumishroom", hp=80, xp=-1, types={t_corrupt,t_air},
         atks={{atk_poison,1}, {atk_zap,1}}}

mons[54]={name="Perishroom", hp=80, xp=-1, types={t_corrupt,t_spirit},
         atks={{atk_poison,1}, {atk_fear,1}}}

mons[55]={name="Dopple", hp=40, xp=100, types={t_normal},
         atks={{atk_swipe,1}, {atk_bite,1}}}
                  
mons[56]={name="Artifish", hp=80, xp=-1, types={t_normal},
         atks={{atk_cut,1}, {atk_bite,2}}}
                
mons[57]={name="Toxito", hp=40, xp=100, types={t_corrupt},
         atks={{atk_poison,0.5}, {atk_vamp,1}}}
                  
mons[58]={name="Sanguito", hp=80, xp=-1, types={t_corrupt},
         atks={{atk_poison,1}, {atk_vamp,2}}}

mons[59]={name="Loceam", hp=60, xp=100, types={t_fire},
         atks={{atk_fire,1}, {atk_bite,1}}}
                  
mons[60]={name="Flamain", hp=100, xp=100, types={t_fire},
         atks={{atk_fire,2}, {atk_bite,2}}}
                  
mons[61]={name="Inferail", hp=140, xp=-1, types={t_fire},
         atks={{atk_fire,3}, {atk_zap,2}}}
                  
mons[62]={name="Dollreap", hp=100, xp=-1, types={t_spirit},
         atks={{atk_fear,2}, {atk_cut,1}}}
                  
mons[63]={name="Flajel", hp=60, xp=-1, types={t_normal},
         atks={{atk_grass,1}, {atk_bubble,1}, {atk_fire,1}}}
                  
mons[64]={name="Inkwid", hp=40, xp=100, types={t_corrupt,t_water},
         atks={{atk_poison,0.5}, {atk_spurt,1}}}
                  
mons[65]={name="Inkokt", hp=80, xp=-1, types={t_corrupt,t_water},
         atks={{atk_poison,1}, {atk_spurt,2}}}
                  
mons[66]={name="Loneleaf", hp=40, xp=100, types={t_spirit,t_grass},
         atks={{atk_grass,1}, {atk_fear,1}}}

mons[67]={name="Forthorn", hp=80, xp=-1, types={t_spirit,t_grass},
         atks={{atk_grass,2}, {atk_fear,2}}}
                  
mons[68]={name="Orelett", hp=60, xp=100, types={t_earth,t_dragon},
         atks={{atk_rock,1}, {atk_dragon,1}}}
                  
mons[69]={name="Anvelid", hp=100, xp=100, types={t_earth,t_dragon},
         atks={{atk_rock,2}, {atk_dragon,2}}}
                  
mons[70]={name="Margoplex", hp=140, xp=-1, types={t_earth,t_dragon},
         atks={{atk_rock,3}, {atk_dragon,3}}}
                  
mons[71]={name="Phlantern", hp=40, xp=100, types={t_spirit},
         atks={{atk_fear,1}, {atk_fire,1}}}
                  
mons[72]={name="Lanturgheist", hp=80, xp=100, types={t_spirit},
         atks={{atk_fear,2}, {atk_fire,2}}}

mons[73]={name="Spiriturn", hp=120, xp=-1, types={t_spirit},
         atks={{atk_fear,3}, {atk_fire,3}}}
                  
mons[74]={name="Phlanrup", hp=40, xp=100, types={t_spirit,t_corrupt},
         atks={{atk_fear,1},{atk_Cfire,1}}}
                  
mons[75]={name="Corrlamp", hp=80, xp=100, types={t_spirit,t_corrupt},
         atks={{atk_fear,2},{atk_Cfire,2}}}
                  
mons[76]={name="Corrturn", hp=120, xp=-1, types={t_spirit,t_corrupt},
         atks={{atk_fear,3},{atk_Cfire,3}}}
                  
mons[77]={name="Dreadlone", hp=60, xp=100, types={t_corrupt},
         atks={{atk_grass,1},{atk_fear,1}}}
              
mons[78]={name="Corrthorn", hp=120, xp=-1, types={t_corrupt},
         atks={{atk_grass,2},{atk_fear,2}}}
                  
mons[79]={name="Entree", hp=80, xp=-1, types={t_grass},
         atks={{atk_grass,2}}}
                  
mons[109]={name="???", hp=100, xp=-1, types={t_glitch},
         atks={{atk_glitch,1} }}
                  
function RoomTables() end

rooms[1]={  
 mx=0,
  my=17,
  mons={0,9,18,43,51,55,57,24,79,71,27,109},
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
    mons={},
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
    mons={},
    obj={
     [1]={
       x=78,
        y=23,
        a=act_msg("'And on todays action news...'")
      },
      [2]={
      x=80,
      y=25,
      a=act_itm("i_max")}},
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
    mons={},
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
    mons={0,1,15,18,19,52,57,66,27},
    obj={
     [1]={
       x=27,
        y=65,
        a=act_itm("i_hp")
      },
      [2]={
       x=19,
        y=53,
        a=act_msg("RIP: BOB, 1920-2020")}
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
    mons={11,15,68,40,71},
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
    mons={11,15,68,40},
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
  mons={0,1,15,18,19,52,57,66},
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
    mons={0,9,18,43,51,55,57},
    obj={
    [1]={
     x=98,
     y=38,
     a=act_msg("HEALTH CENTER")},
    [2]={
     x=101,
      y=36,
      a=act_itm("i_poi")
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
    mons={6,11,41,55,56,64,65},
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
    mons={6,7,8,64,65},
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
    mons={6,11,41,55,56,64,65},
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
    mons={0,1,2,13,18,19,20,43,45,48,52,54,57,66,67},
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
    mons={0,9,18,43,51,55,57},
    obj={
     [1]={
       x=65,
        y=77,
        a=act_msg("HEALTH CENTER")  },
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
    mons={36,0,9,18,43,51,55,57,21,22,23,24,25,26,63,71,62,77,78,76,75,74,109},
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
    mons={109,35,0,9,18,43,36,51,55,57,21,22,23,24,25,26,63,71,62,79,77,78,76,75,74},
    obj={
     [1]={
       x=115,
        y=98,
        a=act_msg("HEALTH CENTER")},
      [2]={
       x=114,
        y=86,
        a=act_itm("i_see")
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
    mons={36,35,109,0,9,18,43,51,55,57,21,22,23,24,25,26,63,71,62,79,77,78,76,75,74},
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
    mons={109,36,35,0,9,18,43,51,55,57,21,22,23,24,25,26,63,71,62,79,17,53,77,78,76,75,74},
    obj={
     [1]={
       x=121,
        y=69,
        a=act_itm("i_bur")
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
    mons={},
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
    mons={},
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
    mons={},
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
    mons={38,39,40,20,79,109},
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
    mob={},
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
    mons={38,39,40,20,79,17,73,109},
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
    mons={0,9,18,43,51,55,57,21,22,23,79,24,25,26,63,71,62,29,28,31},
    obj={
     [1]={
       x=61,
        y=87,
        a=act_itm("i_con")},
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
    mons={45,68,32,16,79},
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
    mons={45,68,32,16,72,79},
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
    mons={45,68,32,16,72,34,35,36},
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
    mons={64,65,54,8,7,55,56},
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
-- 007:dddddddddddddddd11dd11dddd11dd11dddddddddddddddd11dd11dddd11dd11
-- 008:333333333773333317777133377f77113277f773327777731122773333113311
-- 009:ddddddddddddd44911dd4494dd144949dd449499d449494914449449d4444494
-- 010:dddddddd499eeddd9999eedd9f999e119ff99edd99ff9eed999ff9ed99999991
-- 011:bbbbbbbbbbbbb449bbbb4494bbb44949bb449499b4494949b4449449b4444494
-- 012:bbbbbbbb499eebbb9999eebb9f999ebb9ff99ebb99ff9eeb999ff9eb9999999b
-- 013:bb7777bbb7fb517b7eb151e11b5515b511511b5050110105b500002bbb4121bb
-- 014:94444494444949944499999449499f949499f994999999944999994444994444
-- 015:a77777a7777a7aa777aaaaa77a7aafa7a7aafaa7aaaaaaa77aaaaa7777aa7777
-- 016:aaaaaaaaa777777aa700007aa7ff0f7aa700007aa706007aaa7777aaaaa3aaaa
-- 017:2999999a2299999922444444224cccc4224c99c4224cccc42a444444aa4aaaa4
-- 018:aaaaaaaaaaaaaaaaaaaaaaaaa4aaaa4aa424424aa442244aa41ff14aaad11daa
-- 019:b44bb44b9999999944444444422424244242242444444444b22bb22b52255225
-- 020:bbbbbbbbbb377abbbb7d7abbbb777abbbbaaabbbb5bbb5bbbb555bbbbbbbbbbb
-- 021:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 022:bbbbbbbbbbbbbbbbbbbbbbbbbbb22222bb2f8888b2f8f6662f8f22222ff66666
-- 023:bbbbbbbbbbbbbbbbbbbbbbbb22221bbb888821bb6662221b2222212166666221
-- 024:2422024022444020249e94002e222900292004002920090524200405b555555b
-- 025:d4444949d33444949994494949f94444449934443449339913331149dd11dd44
-- 026:4949494d9494943d494943dd44443d994443d9f9933d499ff9dd444449913333
-- 027:b4444949b55444949994494949f944444499544454495599b555bb49bbbbbb44
-- 028:4949494b9494945b494945bb44445b994445b9f9955b499ff9bb4444499b5555
-- 029:dddddaaadddaaaff11aaffffdaafffffdaffffffdaffffff1affffffdaffffff
-- 030:aaaaaaaaffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 031:aaddddddfaaaadddffffaaddfffffa11fffffaadffffffadffffffadffffffa1
-- 032:aaaa3aaaaaa3aaaaaaaa3aaaaaa3aaaaa77777aaa7b767aaa77777aaaaa3aaaa
-- 033:b5b5b5b57b7575755b5b575b5b575557b7b5557575b5b5b555757b755b5b5b5b
-- 034:aa1dd1aaaa1111aaaa1111aaa411114aa424424aa442244aa4aaaa4aaaaaaaaa
-- 035:aaaaaa44aaaaa444aaaa4444aaa44444aa444444aa444444aa4aa2aaaa4aaaaa
-- 036:4444444444444444fff44444ff44444a444444aa444444aaaaaaa4aaaaaaa4aa
-- 037:4aaaaaaa4aaaaaaa2aaaaaaa2aaaaaaa2aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 038:2f62222226666f222111f862bcfc1111bcccf22cbcfcf24cb444f24cbbbb4224
-- 039:2222621b6666661b1111112b1c92292b9990022b9c99992b2222222bbbbbbbbb
-- 040:2422024022444020249e94002e222900292004002920090724200407a777777a
-- 041:bbbbbbbbbbbbccccbbcccdddbbcdddddbbcdddddbbcdddddbbcdddddbbcddddd
-- 042:bbbbbbbbcccbbbbbddcccbbbddddccbbdddddccbddddddcbddddddcbddddddcb
-- 043:dddddddddddddddd11dd11dfdd11dd11dddfddddfddddfdd11ff11ffffaaffaa
-- 045:daffffffdaafffff11afffffddafffffddafffffdaafffff1affffffdaffffff
-- 046:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 047:ffffffadffffffadffffffadffffffa1ffffffadffffffadffffffadffffffa1
-- 048:aaaa3aaaaaa3aaaaaaaa3aaaaaa777aaaaa7a7aaaaaaaaaaaaaaaaaaaaaaaaaa
-- 049:30000000303300003033033000330330300003303033000030330330aaaaaaaa
-- 050:aaaaaaaa0000000a3300000a3303300a3303303a3303303a3303303aaaaaaaaa
-- 051:77777777abbbbbbaab377abaab7b7abaab777abaabaaabbaabbbbbba77777777
-- 052:77777777a999999aa9377a9aa9797a9aa9777a9aa9aaa99aa999999a77777777
-- 053:77777777addddddaad377adaad7d7adaad777adaadaaaddaadddddda77777777
-- 054:bbbbbbb2bbbbb228bbb22ff8b22ff8f6b2f8f6f6b2868686b2f66686b2f68686
-- 055:2bbbbbbb222bbbbb24422bbb2424421b2422241b2424241b2424241b2424241b
-- 056:7111117111171771117777711717737171773771777777711777771111771111
-- 057:bbcdddddbbcdddddbbcdddddbbccddddbbbcddddbbbccdddbbbbccccbbbbbbbb
-- 058:ddddddcbddddddcbddddddcbddddddcbdddcddcbddcbcccbcccbbbbbbbbbbbbb
-- 059:9fafffa44dfdafd44ddddfd44ddfddd49fddddd49ddddfd44dddddd44dddddd4
-- 061:daffffffdaffffff1affffffdaffffffdaaaffffdddaaaff11dd1aaadd11dd11
-- 062:ffffffffffffffffffffffffffffffffffffffffffffffffaaafffffddaaaaaa
-- 063:ffffffadffffffadffffffadffffffa1fffffaadffffaaddffaaa1ddaaa1dd11
-- 064:7777777777777777777777777777777777777777777777777777777777777777
-- 065:2222222222222222222222222222222222222222222222222222222222222222
-- 066:000af0f0a0aaaf000aa00af0aa0000afaa0000af0aa00af000aaaf0f0a0af000
-- 067:7000000070770000707707700077077070000770707700007077077033333333
-- 068:7000000070770000707707700077077070000770707700007077077022222222
-- 069:2222222200000002330000023303300233033032330330323303303222222222
-- 070:b2f68662b2866229b2622ccfb21ccfffbb2cf22fbb29f24cbb29f24cbb114224
-- 071:2222241b9222221bfcc2221bfffcc11bf22fc1bb900c91bb999991bb111111bb
-- 072:aaaaaaaaaaaaaaaaaaaeaeaeaae22222aaa26666aae26226aaa26266aae26666
-- 073:aaaaaaaaaaaaaaaaaeaeaeae2222222266666666626226266226262666666666
-- 074:aaaaaaaaaaaaaaaaaeaeaaaa22222aaa66662eaa62262aaa66262eaa66662aaa
-- 075:aaaaaaaaa777777aa7dddd7aa7dccd7aa744447aa75b657aaa7777aaaaaaaaaa
-- 076:aaaaaaaaa777777aa700007aa70e007aa700007aa700007aaa7777aaaaaaaaaa
-- 077:aaaaaaaaa777777aa700007aa704007aa700007aa700007aaa7777aaaaaaaaaa
-- 078:aaaaaaaaa777777aa700007aa705007aa700007aa700007aaa7777aaaaaaaaaa
-- 079:aaaaaaaaa777777aa700007aa706e07aa705d07aa700007aaa7777aaaaaaaaaa
-- 080:aaaaaaaa0000000a2200000a2202200a2202202a2202202a2202202aaaaaaaaa
-- 081:b333333b3aaaaaa3aaaaaaaaa77a7a7aa7a77a7aaaaaaaaaa777a77aaaaaaaaa
-- 082:55555555555b55555bb55555555555555555b5555b555bb555b5555555555555
-- 083:aaaaaaaa3a3a3a3aaaaaaaaaa3a3a3a33a3a3a3a33333333a3a3a3a333333333
-- 084:3333333333333333113311333311331133333333333333331133113333113311
-- 085:bbbbbbbb0000000b3300000b3303300b3303303b3303303b3303303bbbbbbbbb
-- 086:aaaaaaaaaa2449aaaa4649aaaa4449aaaa999aaaa7aaa7aaaa777aaaaaaaaaaa
-- 087:4444444444377a44447b7a4444777a44ddaaadddd3ddd3dd113331dddd11dd11
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
-- 100:aaaaaaaa777aaaaa771aaaaa711aaaaa111aaaaa111aaaaa11aaaaaa1aaaaaaa
-- 101:aaaaaaaaa777777aa700007aa70b007aa700007aa700007aaa7777aaaaaaaaaa
-- 102:3333333323232323333333333232323223232323222222223232323222222222
-- 103:33333333a3a3a3a3333333333a3a3a3aa3a3a3a3aaaaaaaa3a3a3a3aaaaaaaaa
-- 104:aaa26666aae26266aaa26226aae26666aaa22222aaaaeaeaaaaaaaaaaaaaaaaa
-- 105:6666666662662226222626266666666622222222eaeaeaeaaaaaaaaaaaaaaaaa
-- 106:66662eaa66262aaa62262eaa66662aaa22222eaaeaeaeaaaaaaaaaaaaaaaaaaa
-- 107:aaaaaaaaa777777aa700007aa70d007aa700007aa700007aaa7777aaaaaaaaaa
-- 108:aaaaaaaaa777777aa700007aa702007aa700007aa700007aaa7777aaaaaaaaaa
-- 109:aaaaaaaaa777777aa700007aa701007aa700007aa700007aaa7777aaaaaaaaaa
-- 110:aaaaaaaaa777777aa700007aa709007aa700007aa700007aaa7777aaaaaaaaaa
-- 111:aaaaaaaaa777777aa700007aa70c007aa700007aa700007aaa7777aaaaaaaaaa
-- 112:44444444444444444444444444444444bbbb5bbbb5bbb55bbb5bbbbbbbbbbbbb
-- 113:33333333333333333333333333333333aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 114:3333333333333333333333333333333322222222222222222222222222222222
-- 115:44444444444444444444444444444444a7aafaa7aaaaaaa77aaaaa7777aa7777
-- 116:44444444444444444444444444444444dddddddddddddddd11dd11dddd11dd11
-- 117:3333333333333333333333333333333300000000000000000000000000000000
-- 118:4444444444444444444444444444444400000000000000000000000000000000
-- 119:aaaaaaaaa77aa55a11775b5a1d1f55aaa117f77af277722faf227262aaffff22
-- 120:aaaaaaaaa77aaaaaa7777aaaa77f77aaa277f77af277777faf2277faaaffffaa
-- 121:aaaaaaaaaaaaaaaa47474747a7a7a7a7a7a7a7a747474747aaaaaaaaaaaaaaaa
-- 122:aa4aa4aaaa7777aa477aa4aaa7a7a4aaa7aa74aa47444aaaaaaaaaaaaaaaaaaa
-- 123:aaaaaaaaaaaaaaaaaaa44474aa47aa7aaa4a7a7aaa4aa774aa7777aaaa4aa4aa
-- 124:dddddcccdddccccc11ccccccdcccccccdcccccccdcccccbc1ccccbcbdcccccbb
-- 125:ccccccccccccccccccccccccccccccccccccccccbcbcbcbccbcbcbcbbbbbbbbb
-- 126:ccddddddcccccdddccccccddcccccc11cccccccdbccccccdcbcccccdbcbcccc1
-- 127:aa4aa4aaaa7777aaaa4aa774aa4a7a7aaa47aa7aaaa44474aaaaaaaaaaaaaaaa
-- 128:bbbbbbbbbbbbbbbbbbbbbbbbbbb77777bb7faaaab7faf3337faf77777ff33333
-- 129:bbbbbbbbbbbbbbbbbbbbbbbb77771bbbaaaa71bb3337771b7777717133333711
-- 130:33333333333333333333777333337f73aa997779aa299999aa224444aa224ccc
-- 131:3333333333333333333bb333355b3333579799aa9999999a4444444ac4cccc4a
-- 132:aaaaaaaaaa7aaa3aabb7a3a355b573aaa55baa3aaa5aa777aaaaa7a7aaaaaaaa
-- 133:333333333333333333aaaaaa333aaaaaaa33ffffaa33faaaaa33faffaa33fafa
-- 134:3333333333333333aaa33333aaaa333cffffaaafaaafaaafffafaaafffafaaaa
-- 135:333333333333333333333333fc3fcf335fafdfaabfafffaaffaaaaa7aaaaaaa7
-- 136:33333333333333333333333333333333aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 137:7111117111244971114649711744497171999771707770711700071111771111
-- 138:1111111111111111111444741147117111417171114117741177771111411411
-- 139:1111111111111111474441111711741117171411477114111177771111411411
-- 140:dccccbcbdcccccbb11cccbcbddccccbbddcccbcbdcccccbb1ccccbcbdcccccbb
-- 141:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 142:bbcccccdbcbccccdbbcccccdbcbcccc1bbcccccdbcbccccdbbcccccdbcbcccc1
-- 143:aaaaaaaaaaaaaaaa47444aaaa7aa74aaa7a7a4aa477aa4aaaa7777aaaa4aa4aa
-- 144:7f37777773333f777111fa37b4941111b4449014b4949014b2229014bbbb2222
-- 145:7777371b3333331b1111111b1421121b2220011b2422221b1111111bbbbbbbbb
-- 146:aa224c99aa224cccaa224444aa224cccaa224c99aa224cccaa2a4444aaaa4aaa
-- 147:c4c99c4ac4cccc4a4444444ac4cccc4ac4c99c4ac4cccc4a4444444aaaaaaa4a
-- 148:33333333333333333333333333333333aaaaaaaaaaa222aaaa26662a2996f69a
-- 149:aa33faffaa33faaaaa33faffaa33fafaaa33fafaaa33fabfaaa3faaaaaaaffff
-- 150:6faf1111aaaf1911ffaf7777ffaf7aaafeaf7a33ffaf7affaaaf7ffaffff7777
-- 151:11fff6f7911ffaaa77733333ff73aaa33a73aa73aa73aa73aa73aaa377733333
-- 152:fdfaaaaaaaffaaaa3333aaaaaaa3aaaa7aa3aaaa7aa3aaaaaaa3aaaa3333aaaa
-- 153:1111111111111111474747471717171717171717474747471111111111111111
-- 154:1141141111777711477114111717141117117411474441111111111111111111
-- 155:1141141111777711114114111177771111411411117777111141141111777711
-- 156:dccccbcbdcccccbc1ccccccbdcccccccdcccccccdddccccc11dd1cccdd11dd11
-- 157:bbbbbbbbbcbcbcbccbcbcbcbccccccccccccccccccccccccccccccccddcccccc
-- 158:bbcccccdbcbccccdcbcccccdccccccc1cccccccdccccccddccccc1ddccc1dd11
-- 159:aa4aa4aaaa7777aaaa4aa4aaaa7777aaaa4aa4aaaa7777aaaa4aa4aaaa7777aa
-- 160:44444444444444444444444444444444b7b5557575b5b5b555757b755b5b5b5b
-- 161:4444444444444444444444444444444471773771777777711777771111771111
-- 162:dd4dd4dddd7777dd114dd4dddd777711d4dd4ddddd77d7dd114d14dddd11dd11
-- 163:aa4aa4aaaa7777faaa4aa4faaa7777aaa4aa4aaaaa77a7aaaa4aa4aaaaaaaaaa
-- 164:2239999923444444234cccc4324c99c4224cccc42a444444aa4aaaa4aaaaaaaa
-- 165:b5b5b5b57b377a755b7d7a5b5b777a57b7aaa57571b5b1b555111b755b5b5b5b
-- 166:bbbbbbbbbbbbbbbbbbbbbbbbbbb22222bb2f8888b2f8f6662f8f22222ff66666
-- 167:bbbbbbbbbbbbbbbbbbbbbbbb22221bbb888821bb6662221b2222212166666211
-- 168:4444444442999e944293ee9444444444461995e4469195e4469915e444444444
-- 169:0000000000000000000000000000030000300003000000000000000000000000
-- 170:0000000000000000000000000d000d00000d000d000000000000000000000000
-- 171:0000000000000000000000000b000b00000b000b000000000000000000000000
-- 172:0000000000000000000000000e000e00000e000e000000000000000000000000
-- 173:0000000000000000000000000900090000090009000000000000000000000000
-- 174:0000000000000000000000000600606600060606000000000000000000000000
-- 175:aaaaaaaaaaaaaaaa47444474a7aaaa7aa7aaaa7a474aa474aa7777aaaa4aa4aa
-- 178:0022220000262600002222000302203000300300000330000030030000000000
-- 179:aaaaaaaaaa4aa4aaaa7a77aaaaa4aa4aaa7777aaaf4aa4aaaf7777aaaa4aa4aa
-- 182:2f62222226666f222111f862b4941111b4449014b4949014b2229014bbbb2222
-- 183:2222621b6666661b1111111b1421121b2220011b2422221b1111111bbbbbbbbb
-- 184:aaaaafffafffafafa4addf44abadda6677777777a7a77a7aa7a77a7a77a77a77
-- 185:0000000000000000000000006060600066060060000000000000000000000000
-- 186:0000000000000000000000009000900000900090000000000000000000000000
-- 187:000000000000000000000000e000e00000e000e0000000000000000000000000
-- 188:000000000000000000000000b000b00000b000b0000000000000000000000000
-- 189:000000000000000000000000d000d00000d000d0000000000000000000000000
-- 190:0000000000000000000000003000030000300000000000000000000000000000
-- 191:4242424242424442424242424442424242424242424442424242424242444242
-- 192:dddddddddd4dd4dd117d77dddd14dd41dd7777dddd4dd4dd117777dddd41d411
-- 193:0002000200200026022222662e22222622200022000002220060222000222200
-- 194:3232323223333333332222322323233333222232233232333333333223232323
-- 195:0777700077777770767670007777770077f77700077777000070077000700077
-- 196:aaaaaaaaaaaaaaaaaeaeaaaa22222aaa33332eaa32232aaa33232eaa33332aaa
-- 199:0aa00aa00aa00aa00aa00aa00aaaaaa00aaaaaa0000aa000000aa000000aa000
-- 200:0aaaaaa0aaaaaaaaaa0000aaaa0000aaaa0000aaaa0000aaaaaaaaaa0aaaaaa0
-- 201:0aa000aa0aa000aa0aa000aa0aa000aa0aa000aa0aa000aa0aaaaaaa00aaaaa0
-- 202:aa000aa0aa000aa0aa000aa0aa000aa0aa0a0aa0aa0a0aa0aaaaaaa0aaaaaaa0
-- 203:aaaaaaa0aaaaaaa000aaa00000aaa00000aaa00000aaa000aaaaaaa0aaaaaaa0
-- 204:0aa000aa0aa000aa0aaa00aa0aaaa0aa0aaaaaaa0aa0aaaa0aa00aaa0aa000aa
-- 205:000aa000000aa000000aa000000aa000000aa00000000000000aa000000aa000
-- 206:337777aa337777aa77bb77aa77bb77aa777777aa777777aaaaaaaa00aaaaaa00
-- 207:1141141111777711114117741141717111471171111444741111111111111111
-- 208:0000000000aa0a000affafa0afaffafaaffeeffa0aaaeaa0000e000000000000
-- 209:33332eaa33232aaa32232eaa33332aaa22222eaaeaeaeaaaaaaaaaaaaaaaaaaa
-- 210:00aaaa000affffa0af7ff7faaff77ffaaff77ffaaf7ff7fa0affffa000aaaa00
-- 211:aaaaaaaaaaaaaaaaaeaeaeae2222222233333333323223233223232333333333
-- 212:00444000044444000444a44044444a4474444444744444440744444000774400
-- 215:aaaaaaa0aaaaaaa00000aaa0000aaa0000aaa0000aaa0000aaaaaaa0aaaaaaa0
-- 216:0aaaaa00aaaaaaa0aa000aa0aa000aa0aa000aa0aa000aa0aaaaaaa00aaaaa00
-- 217:aaaaaaa0aaaaaaa000aaa00000aaa00000aaa00000aaa000aaaaaaa0aaaaaaa0
-- 218:aaaaaa00aaaaaaa0aa000aa0aa000aa0aa000aa0aa000aa0aaaaaaa0aaaaaa00
-- 219:aaaaaaa0aaaaaaa000aaa00000aaa00000aaa00000aaa000aaaaaaa0aaaaaaa0
-- 220:0aaaaa00aaaaaaa0aa000aa0aa000aa0aa000aa0aa000aa0aaaaaaa00aaaaa00
-- 221:aa000aa0aa000aa0aaa00aa0aaaa0aa0aaaaaaa0aa0aaaa0aa00aaa0aa000aa0
-- 222:0aaaaa00aaaaaa00aa000000aaaaaa000aaaaaa000000aa00aaaaaa00aaaaa00
-- 223:4444444444444444444444444444444444444444444444444444444444444444
-- 224:aaaaaaaaaaaaaaaaaaaeaeaeaae22222aaa23333aae23223aaa23233aae23333
-- 225:000dd00000dddd000dddfdd0dddddfdddddddddd1ddddddd1ddddddd011dddd0
-- 226:33332eaa32232aaa33332eaa32232aaa32232eaa33332aaa32232eaa33332aaa
-- 227:00e0000e0ee0e0ee0eee9e9eee99999ee996969ee966669ee966669e09966990
-- 230:7a77aaa2777aa229a7722ee9a22ee9e4a2e9e4e4a2949494a2e44494a2e49494
-- 231:2aaaaaaa222aaffa24422afa2424421a2422241a2424241a2424241a2424241a
-- 232:9999999999999999999999999999999999999999999999999999999999999999
-- 233:6666666666666666666666666666666666666666666666666666666666666666
-- 234:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 235:3333333333333333333333333333333333333333333333333333333333333333
-- 236:9dddddf44dfddad44dddfdf44afddaf4ddfafdaddfdddfdd11df11dddd11dd11
-- 237:3333333332232223323333233232233333322323323333233222322333333333
-- 238:2222222222222222222222222222222222222222222222222222222222222222
-- 239:5555555555555555555555555555555555555555555555555555555555555555
-- 240:aaa23333aae23223aaa23233aae23323aaa23223aae23333aaa23223aae23333
-- 241:aaa23333aae23233aaa23223aae23333aaa22222aaaaeaeaaaaaaaaaaaaaaaaa
-- 242:bbbbb000b5b5bbb0bb5bbbb0b5b5b5b0bbbb5bb00bb5b5b00bbbbb5000000005
-- 243:3333333332332223222323233333333322222222eaeaeaeaaaaaaaaaaaaaaaaa
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

-- <TILES1>
-- 000:2222222200022000000220000002200000022000000220000002200022222222
-- 001:2222222200022000000220000002200000022000000220000002200000022000
-- 002:2222222220000000200000002222220020000000200000002000000022222222
-- 003:2222222220022002200220022000000220000002200000022000000220000002
-- 004:0222222020000000200000000222222002222220000000020000000222222220
-- 016:000000000000e000000eee0000ee7ee009e7ee00009ee0000009000000000000
-- 017:000000000000b000000bbb0000bbbb5005bbb500005b50000005000000000000
-- 018:0000000000009000000999000090799009970900009990000009000000000000
-- 019:00000000000060000006660000669660026e6600002660000002000000000000
-- 020:000000000000200000022200002222200122220000122a000001000000000000
-- 021:000000000000a00000028a00002838a00a83820000a82000000a000000000000
-- 022:0000000000008000000888000088f88003888800003880000003000000000000
-- 023:000000000000d000000ddd0000ddadd003dadd00003dd0000003000000000000
-- </TILES1>

-- <TILES2>
-- 001:9999999999949999944999999999999999994999949994499949999999999999
-- 002:9996999999666999999c99999994996999699666966699c999c9994999499999
-- 003:9999999999999999999999999999999999999999999737379973737399999999
-- 004:9999999999999999999999999999999999999999373737377373737399999999
-- 005:9999999999999999999999999999999999999999373737997373799999999999
-- 006:999999999779999997777999977f77999277f779427777749422774999444499
-- 007:11dd19dddd11dd4114dd11dd9d11dd1111dd41dddd11d911114d11ddd911dd11
-- 008:113311333771331117777133377f77111277f773327777711122773333113311
-- 009:11dd11dddd11d44911dd4494dd14494911449499d449494914449449d4444494
-- 010:11dd11dd499eed119999eedd9f999e119ff99edd99ff9ee1999ff9ed99999991
-- 011:9999999999999773999977379997737399773733977373739777377397777737
-- 012:99999999733aa9993333aa993f333a993ff33a9933ff3aa9333ff3a933333339
-- 013:9977779997f942797e9242e22944249422422940402202049400002999427299
-- 014:37777737777373377733333773733f373733f337333333377333337777337777
-- 015:a77777a7777a7aa777aaaaa77a7aafa7a7aafaa7aaaaaaa77aaaaa7777aa7777
-- 016:aaaaaaaaa777777aa700007aa7ff0f7aa700007aa706007aaa7777aaaaa3aaaa
-- 017:aaaaaaaaaaaaaaaaa444444aa4cccc4aa4c99c4aa4cccc4aa444444aa4aaaa4a
-- 018:aaaaaaaaaaaaaaaaaaaaaaaaa4aaaa4aa424424aa442244aa41ff14aaad11daa
-- 019:93399339aaaaaaaa333333333773737337377373333333339779977947744774
-- 020:9999999999377a99997d7a9999777a9999aaa999949994999944499999999999
-- 021:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 022:99999999999999999999999999922222992f888892f8f6662f8f22222ff66666
-- 023:9999999999999999999999992222199988882199666222192222212166666211
-- 024:1711017011777010173a37001a11130013100700131003041710070494444449
-- 025:14444949d33444949994494949f94444449934443449339913331149dd11dd44
-- 026:4949494d94949431494943dd44443d99444319f99331499ff9dd444449913333
-- 027:97777373944777373337737373f3777777334777477344339444997399999977
-- 028:73737379373737497373749977774933777493f33449733ff399777773394444
-- 029:11dd1aaadd1aaaff11aaffffdaafffff1affffffdaffffff1affffffdaffffff
-- 030:aaaaaaaaffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 031:aadd11ddfaaaad11ffffaaddfffffa11fffffaadffffffa1ffffffadffffffa1
-- 032:aaaa3aaaaaa3aaaaaaaa3aaaaaa3aaaaa77777aaa7b767aaa77777aaaaa3aaaa
-- 033:9494949429242424494942494942444292944424249494944424292449494949
-- 034:aa1dd1aaaa1111aaaa1111aaa411114aa424424aa442244aa4aaaa4aaaaaaaaa
-- 035:aaaaaa44aaaaa444aaaa4444aaa44444aa444444aa444444aa4aa2aaaa4aaaaa
-- 036:4444444444444444fff44444ff44444a444444aa444444aaaaaaa4aaaaaaa4aa
-- 037:4aaaaaaa4aaaaaaa2aaaaaaa2aaaaaaa2aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 038:2f62222226666f222111f8629494111194449014949490149222901499992222
-- 039:2222621966666619111111191420021922200119242222191111111999999999
-- 040:1711017011777010173a37001a111300131007001310030317100703a333333a
-- 041:999999999999cccc99cccddd99cddddd99cddddd99cddddd99cddddd99cddddd
-- 042:99999999ccc99999ddccc999ddddcc99dddddcc9ddddddc9ddddddc9ddddddc9
-- 045:1affffffdaafffff11afffffddafffff11afffffdaafffff1affffffdaffffff
-- 046:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 047:ffffffadffffffa1ffffffadffffffa1ffffffadffffffa1ffffffadffffffa1
-- 048:aaaa3aaaaaa3aaaaaaaa3aaaaaa777aaaaa7a7aaaaaaaaaaaaaaaaaaaaaaaaaa
-- 049:30000000303300003033033000330330300003303033000030330330aaaaaaaa
-- 050:aaaaaaaa0000000a3300000a3303300a3303303a3303303a3303303aaaaaaaaa
-- 051:77777777abbbbbbaab377abaab7b7abaab777abaabaaabbaabbbbbba77777777
-- 052:77777777a999999aa9377a9aa9797a9aa9777a9aa9aaa99aa999999a77777777
-- 053:77777777addddddaad377adaad7d7adaad777adaadaaaddaadddddda77777777
-- 054:999999929999922899922ff8922ff8f692f8f6f69286868692f6668692f68686
-- 055:2999999922299999244229992424421924222419242424192424241924242419
-- 056:1aa711a1a171a17a711a11171a1aa1a1a1a171aa7177171a1711771171771177
-- 057:99cddddd99cddddd99cddddd99ccdddd999cdddd999ccddd9999cccc99999999
-- 058:ddddddc9ddddddc9ddddddc9ddddddc9dddcddc9ddc9ccc9ccc9999999999999
-- 061:1affffffdaffffff1affffffdaffffff1aaaffffdd1aaaff11dd1aaadd11dd11
-- 062:ffffffffffffffffffffffffffffffffffffffffffffffffaaafffffddaaaaaa
-- 063:ffffffadffffffa1ffffffadffffffa1fffffaadffffaa11ffaaa1ddaaa1dd11
-- 064:7777777777777777777777777777777777777777777777777777777777777777
-- 065:2222222222222222222222222222222222222222222222222222222222222222
-- 066:3333333333333333333333333333333333333333333333333333333333333333
-- 067:7000000070770000707707700077077070000770707700007077077033333333
-- 068:7000000070770000707707700077077070000770707700007077077022222222
-- 069:2222222200000002330000023303300233033032330330323303303222222222
-- 070:92f686629286622992622ccf921ccfff992cf22f9929f24c9929f24c99114224
-- 071:2222241992222219fcc22219fffcc119f22fc199900c91999999919911111199
-- 072:aaaaaaaaaaaaaaaaaaaeaeaeaae22222aaa26666aae26226aaa26266aae26666
-- 073:aaaaaaaaaaaaaaaaaeaeaeae2222222266666666626226266226262666666666
-- 074:aaaaaaaaaaaaaaaaaeaeaaaa22222aaa66662eaa62262aaa66262eaa66662aaa
-- 075:aaaaaaaaa777777aa711117aa71b1b7aa7565d7aa744447aaa7777aaaaaaaaaa
-- 076:aaaaaaaaa777777aa700007aa70e007aa700007aa700007aaa7777aaaaaaaaaa
-- 077:aaaaaaaaa777777aa700007aa704007aa700007aa700007aaa7777aaaaaaaaaa
-- 078:aaaaaaaaa777777aa700007aa705007aa700007aa700007aaa7777aaaaaaaaaa
-- 079:aaaaaaaaa777777aa700007aa706e07aa705d07aa700007aaa7777aaaaaaaaaa
-- 080:aaaaaaaa0000000a2200000a2202200a2202202a2202202a2202202aaaaaaaaa
-- 081:9777777973333337333333333113131331311313333333333111311333333333
-- 082:4444444444494444499444444444444444449444494449944494444444444444
-- 083:aaaaaaaa2a2a2a2aaaaaaaaaa2a2a2a22a2a2a2a22222222a2a2a2a222222222
-- 084:1133113333113311113311333311331111331133331133111133113333113311
-- 085:9999999900000009330000093303300933033039330330393303303999999999
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
-- 096:4000000040440000404404400044044040000440404400004044044099999999
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
-- 112:7377373737337373737733773733773399994999949994499949999999999999
-- 113:33333333333333333333333333333333aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 114:3333333333333333333333333333333322222222222222222222222222222222
-- 115:73773737373373737377337737337733aaaaaafaa7aaa77faa7aaaaaaaaaaaaa
-- 116:7377373737337373737733773733773311dd11dddd11dd1111dd11dddd11dd11
-- 117:3333333333333333333333333333333300000000000000000000000000000000
-- 118:7377373737337373737733773733773300000000000000000000000000000000
-- 119:aaaaaaaaa77aa55a11775b5a1d1f55aaa117f77af277722faf227262aaffff22
-- 120:aaaaaaaaa77aaaaaa7777aaaa77f77aaa277f77af277777faf2277faaaffffaa
-- 121:aaaaaaaaaaaaaaaa47474747a7a7a7a7a7a7a7a747474747aaaaaaaaaaaaaaaa
-- 122:aa4aa4aaaa7777aa477aa4aaa7a7a4aaa7aa74aa47444aaaaaaaaaaaaaaaaaaa
-- 123:aaaaaaaaaaaaaaaaaaa44474aa47aa7aaa4a7a7aaa4aa774aa7777aaaa4aa4aa
-- 124:11dd1cccdd1ccccc11ccccccdccccccc1cccccccdccccc9c1cccc9c9dccccc99
-- 125:cccccccccccccccccccccccccccccccccccccccc9c9c9c9cc9c9c9c999999999
-- 126:ccdd11ddcccccd11ccccccddcccccc11cccccccd9cccccc1c9cccccd9c9cccc1
-- 127:aa4aa4aaaa7777aaaa4aa774aa4a7a7aaa47aa7aaaa44474aaaaaaaaaaaaaaaa
-- 128:99999999999999999999999999977777997faaaa97faf3337faf77777ff33333
-- 129:99999999999999999999999977771999aaaa7199333777197777717133333711
-- 130:99999999999999999999999999922222992e999992e9e4442e9e22222ee44444
-- 131:9999999999999999999999992222199999992199444222192222212144444211
-- 132:99999999999999999999999999944444994ceeee94cec9994cec44444cc99999
-- 133:99999999999999999999999944441999eeee4199999444194444414199999411
-- 134:999999979999977a99977ffa977ffaf397faf3f397a3a3a397f333a397f3a3a3
-- 135:7999999977799999733779997373371973777319737373197373731973737319
-- 136:999999929999922999922ee9922ee9e492e9e4e49294949492e4449492e49494
-- 137:2999999922299999244229992424421924222419242424192424241924242419
-- 138:999999979999977d99977ffd977ffdf397fdf3f397d3d3d397f333d397f3d3d3
-- 139:7999999977799999733779997373371973777319737373197373731973737319
-- 140:1cccc9c9dccccc9911ccc9c9ddcccc9911ccc9c9dccccc991cccc9c9dccccc99
-- 141:9999999999999999999999999999999999999999999999999999999999999999
-- 142:99cccccd9c9cccc199cccccd9c9cccc199cccccd9c9cccc199cccccd9c9cccc1
-- 143:aaaaaaaaaaaaaaaa47444aaaa7aa74aaa7a7a4aa477aa4aaaa7777aaaa4aa4aa
-- 144:7f37777773333f777111fa379494111194449014949490149222901499992222
-- 145:7777371933333319111111191420021922200119242222191111111999999999
-- 146:2e42222224444f222111f9429494111194449014949490149222901499992222
-- 147:2222421944444419111111191420021922200119242222191111111999999999
-- 148:4c94444449999c444111ce949494111194449014949490149222901499992222
-- 149:4444941999999919111111191420021922200119242222191111111999999999
-- 150:97f3a33797a3377997377ccf971ccfff992cf22f9929f24c9929f24c99114224
-- 151:7777731997777719fcc77719fffcc119f22fc199900c91999999919911111199
-- 152:92e494429294422992422ccf921ccfff992cf22f9929f24c9929f24c99114224
-- 153:2222241992222219fcc22219fffcc119f22fc199900c91999999919911111199
-- 154:97f3d33797d3377997377ccf971ccfff992cf22f9929f24c9929f24c99114224
-- 155:7777731997777719fcc77719fffcc119f22fc199900c91999999919911111199
-- 156:1cccc9c9dccccc9c1cccccc9dccccccc1cccccccdd1ccccc11dd1cccdd11dd11
-- 157:999999999c9c9c9cc9c9c9c9ccccccccccccccccccccccccccccccccddcccccc
-- 158:99cccccd9c9cccc1c9cccccdccccccc1cccccccdcccccc11ccccc1ddccc1dd11
-- 159:aa4aa4aaaa7777aaaa4aa4aaaa7777aaaa4aa4aaaa7777aaaa4aa4aaaa7777aa
-- 160:999999979999977b99977ffb977ffbf597fbf5f597b5b5b597f555b597f5b5b5
-- 161:7999999977799999755779997575571975777519757575197575751975757519
-- 162:114d14dddd777711114dd4dddd77771114dd41dddd77d711114d14dddd11dd11
-- 163:aa4aa4aaaa7777faaa4aa4faaa7777aaa4aa4aaaaa77a7aaaa4aa4aaaaaaaaaa
-- 164:99999999999999999999999999977777997fdddd97fdf3337fdf77777ff33333
-- 165:99999999999999999999999977771999dddd7199333777197777717133333711
-- 166:4444444442999e944293ee9444444444461995e4469195e4469915e444444444
-- 167:0000000000000000000000000000030000300003000000000000000000000000
-- 168:0000000000000000000000000d000d00000d000d000000000000000000000000
-- 169:0000000000000000000000000b000b00000b000b000000000000000000000000
-- 170:0000000000000000000000000e000e00000e000e000000000000000000000000
-- 171:0000000000000000000000000900090000090009000000000000000000000000
-- 172:0000000000000000000000000600606600060606000000000000000000000000
-- 173:99999999999999999999999999977777997fbbbb97fbf5557fbf77777ff55555
-- 174:99999999999999999999999977771999bbbb7199555777197777717155555711
-- 175:aaaaaaaaaaaaaaaa47444474a7aaaa7aa7aaaa7a474aa474aa7777aaaa4aa4aa
-- 176:97f5b55797b5577997577ccf971ccfff992cf22f9929f24c9929f24c99114224
-- 177:7777751997777719fcc77719fffcc119f22fc199900c91999999919911111199
-- 178:0022220000262600002222000302203000300300000330000030030000000000
-- 179:aaaaaaaaaa4aa4aaaa7a77aaaaa4aa4aaa7777aaaf4aa4aaaf7777aaaa4aa4aa
-- 180:7f37777773333f777111fd379494111194449014949490149222901499992222
-- 181:7777371933333319111111191420021922200119242222191111111999999999
-- 182:aaaaafffafffafafa4addf44abadda6677777777a7a77a7aa7a77a7a77a77a77
-- 183:0000000000000000000000006060600066060060000000000000000000000000
-- 184:0000000000000000000000009000900000900090000000000000000000000000
-- 185:000000000000000000000000e000e00000e000e0000000000000000000000000
-- 186:000000000000000000000000b000b00000b000b0000000000000000000000000
-- 187:000000000000000000000000d000d00000d000d0000000000000000000000000
-- 188:0000000000000000000000003000030000300000000000000000000000000000
-- 189:7f57777775555f777111fb579494111194449014949490149222901499992222
-- 190:7777571955555519111111191420021922200119242222191111111999999999
-- 191:4242424242424442424242424442424242424242424442424242424242444242
-- 192:11dd11dddd41d411117d77dddd14dd41117777dddd4dd411117777dddd41d411
-- 193:0002000200200026022222662e22222622200022000002220060222000222200
-- 194:3232323223333333332222322323233333222232233232333333333223232323
-- 195:0777700077777770767670007777770077f77700077777000070077000700077
-- 196:aaaaaaaaaaaaaaaaaeaeaaaa22222aaa33332eaa32232aaa33232eaa33332aaa
-- 197:999999949999944e99944cce944ccec994cec9c994e9e9e994c999e994c9e9e9
-- 198:4999999944499999499449994949941949444919494949194949491949494919
-- 199:0aa00aa00aa00aa00aa00aa00aaaaaa00aaaaaa0000aa000000aa000000aa000
-- 200:0aaaaaa0aaaaaaaaaa0000aaaa0000aaaa0000aaaa0000aaaaaaaaaa0aaaaaa0
-- 201:0aa000aa0aa000aa0aa000aa0aa000aa0aa000aa0aa000aa0aaaaaaa00aaaaa0
-- 202:aa000aa0aa000aa0aa000aa0aa000aa0aa0a0aa0aa0a0aa0aaaaaaa0aaaaaaa0
-- 203:aaaaaaa0aaaaaaa000aaa00000aaa00000aaa00000aaa000aaaaaaa0aaaaaaa0
-- 204:0aa000aa0aa000aa0aaa00aa0aaaa0aa0aaaaaaa0aa0aaaa0aa00aaa0aa000aa
-- 205:000aa000000aa000000aa000000aa000000aa00000000000000aa000000aa000
-- 206:337777aa337777aa77bb77aa77bb77aa777777aa777777aaaaaaaa00aaaaaa00
-- 207:e7779777796777e977979767e776e6977679676e77e677977967767676779777
-- 208:0000000000aa0a000affafa0afaffafaaffeeffa0aaaeaa0000e000000000000
-- 209:33332eaa33232aaa32232eaa33332aaa22222eaaeaeaeaaaaaaaaaaaaaaaaaaa
-- 210:00aaaa000affffa0af7ff7faaff77ffaaff77ffaaf7ff7fa0affffa000aaaa00
-- 211:aaaaaaaaaaaaaaaaaeaeaeae2222222233333333323223233223232333333333
-- 212:00444000044444000444a44044444a4474444444744444440744444000774400
-- 213:94c9e99494e9944994944ccf941ccfff992cf22f9929f24c9929f24c99114224
-- 214:4444491994444419fcc44419fffcc119f22fc199900c91999999919911111199
-- 215:0aaaaaa00aaaaaa0000aa000000aa000000aa000aa0aa000aaaaa0000aaa0000
-- 216:aaaaaaa0aaaaaaa0aa000aa0aa000aa0aaaaaaa0aaaaaaa0aa000aa0aa000aa0
-- 217:0aaaaaa0aaaaaaa0aa000000aa000000aa000000aa000000aaaaaaa00aaaaaa0
-- 218:aa00aa00aa00aa00aa0aaa00aaaaa000aaaaa000aa0aaa00aa00aa00aa00aa00
-- 219:aaaaaaa0aaaaaaa0aa0a0aa0aa0a0aa0aa000aa0aa000aa0aa000aa0aa000aa0
-- 220:0aaaaa00aaaaaaa0aa000aa0aa000aa0aa000aa0aa000aa0aaaaaaa00aaaaa00
-- 221:0aa000aa0aa000aa0aaa00aa0aaaa0aa0aaaaaaa0aa0aaaa0aa00aaa0aa000aa
-- 222:0aaaaaa0aaaaaaa0aa000000aaaaaaa00aaaaaaa000000aa0aaaaaaa0aaaaaa0
-- 223:1111111111111111111111111111111111111111111111111111111111111111
-- 224:aaaaaaaaaaaaaaaaaaaeaeaeaae22222aaa23333aae23223aaa23233aae23333
-- 225:000dd00000dddd000dddfdd0dddddfdddddddddd1ddddddd1ddddddd011dddd0
-- 226:33332eaa32232aaa33332eaa32232aaa32232eaa33332aaa32232eaa33332aaa
-- 227:00e0000e0ee0e0ee0eee9e9eee99999ee996969ee966669ee966669e09966990
-- 228:9999999999999999999999999997777799783333978382227838777778822222
-- 229:9999999999999999999999997777199933337199222777197777717122222711
-- 230:7a77aaa2777aa229a7722ee9a22ee9e4a2e9e4e4a2949494a2e44494a2e49494
-- 231:2aaaaaaa222aaffa24422afa2424421a2422241a2424241a2424241a2424241a
-- 232:9999999999999999999999999999999999999999999999999999999999999999
-- 233:6666666666666666666666666666666666666666666666666666666666666666
-- 234:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 235:3333333333333333333333333333333333333333333333333333333333333333
-- 236:7dddddf73dfdddd37dddfdf73dfdddf311fdf1fddf11df1111df11dddd11dd11
-- 237:3333333332232223323333233232233333322323323333233222322333333333
-- 238:2222222222222222222222222222222222222222222222222222222222222222
-- 239:44444b444445b444449999444999999449e99e9449999994449ee94444444444
-- 240:aaa23333aae23223aaa23233aae23323aaa23223aae23333aaa23223aae23333
-- 241:aaa23333aae23233aaa23223aae23333aaa22222aaaaeaeaaaaaaaaaaaaaaaaa
-- 242:9999900094949990994999909494949099994990099494900999994000000004
-- 243:3333333332332223222323233333333322222222eaeaeaeaaaaaaaaaaaaaaaaa
-- 244:7827777772222877711183279494111194449014949490149222901499992222
-- 245:7777271922222219111111191420021922200119242222191111111999999999
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
-- </TILES2>

-- <TILES3>
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
-- 023:bbbbbbbbbbbbbbbbbbbbbbbb22221bbb888821bb6662221b2222212166666221
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
-- 081:b333333b3aaaaaa3aaaaaaaaa77a7a7aa7a77a7aaaaaaaaaa777a77aaaaaaaaa
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
-- 191:4242424242424442424242424442424242424242424442424242424242444242
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
-- 207:e7779777796777e977979767e776e6977679676e77e677977967767676779777
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
-- 223:4444444444444444444444444444444444444444444444444444444444444444
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
-- 236:4dddddf49dfdddd94dddfdf49dfdddf911fdf1fddf11df1111df11dddd11dd11
-- 237:3333333332232223323333233232233333322323323333233222322333333333
-- 238:2222222222222222222222222222222222222222222222222222222222222222
-- 239:5555555555555555555555555555555555555555555555555555555555555555
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
-- </TILES3>

-- <SPRITES>
-- 000:0666666604c1c1c00cc1c1c00cccccc00066600000c66c000066600000101000
-- 001:0666666604c1c1c00cc1c1c00cccccc000666000006c60000066600000100000
-- 002:0666666604c1c1c00cc1c1c00cccccc00066600000c66c000066610001000000
-- 003:0666666604c1c1c00cc1c1c00cccccc000666000006c60000166600000000100
-- 004:0666666604c1c1c00cc1c1c00cccccc00066600000c66c000016600000001000
-- 005:0666666604ccccc00cc1c1c00ccc8cc00066600000c66c000066600000101000
-- 006:8888888878788888787877887778787878787878787877888888788888888888
-- 007:88888888888888888aaaaaaaa8888888a88888888aaaaaaa8888888888888888
-- 008:8888888888888888aaaaaaaa8888888888888888aaaaaaaa8888888888888888
-- 009:0000000000333300000220000033330000222200003223000033330000000000
-- 010:0000000000eeee000009900000eeee000099e900009e990000eeee0000000000
-- 011:00000000000066000006666000f666600fff66000ffff00000ff000000000000
-- 012:6777777777777777770000007700000077000000770000007700000077000000
-- 013:7777777777777777000000000000000000000000000000000000000000000000
-- 014:7777777677777777000000770000007700000077000000770000007700000077
-- 015:00000000000000000000000000377a00007e7a0000777a0000aaa00000000000
-- 016:0aaaaaaa0ac7c7c00cc7c7c00ccaaac000f6f00000c6fc0000fff00000a0a000
-- 017:0aaaaaaa0ac7c7c00cc7c7c00ccaaac000f6f00000fcf00000fff00000a00000
-- 018:0aaaaaaa0ac7c7c00cc7c7c00ccaaac000f6f00000c6fc0000fffa000a000000
-- 019:0aaaaaaa0ac7c7c00cc7c7c00ccaaac000f6f00000fcf0000afff00000000a00
-- 020:0aaaaaaa0ac7c7c00cc7c7c00ccaaac000f6f00000c6fc0000aff0000000a000
-- 021:0aaaaaaa0accccc00cc7c7c00ccaaac000f6f00000ca6c0000fff00000a0a000
-- 022:000000000aaaaaa0affffffaaffaaffaaffaaffaaffffffa0aaaaaa000000000
-- 023:0000000002222220233333322322223223322332233333320222222000000000
-- 024:00000000099999909eeeeee99e99e9e99e9e99e99eeeeee90999999000000000
-- 025:0000000001111110177177711771117117111771177717710111111000000000
-- 026:00000000055555505bbbbbb55b555bb55bb555b55bbbbbb50555555000000000
-- 027:0000000000999900000660000099990000996900009669000099990000000000
-- 028:7700000077000000770000007700000077000000770000007700000077000000
-- 029:0000000000f0000000ff000000fff00000ffa00000fa000000a0000000000000
-- 030:0000007700000077000000770000007700000077000000770000007700000077
-- 031:00000000000000000000000000377a0000767a0000777a0000aaa00000000000
-- 032:0688888808c1c1c008c1c1c008ccccc000ddd00000cddc0000ddd00000202000
-- 033:0688888808c1c1c008c1c1c008ccccc000ddd00000dcd00000ddd00000200000
-- 034:0688888808c1c1c008c1c1c008ccccc000ddd00000cddc0000ddd20002000000
-- 035:0688888808c1c1c008c1c1c008ccccc000ddd00000dcd00002ddd00000000200
-- 036:0688888808c1c1c008c1c1c008ccccc000ddd00000cddc00002dd00000002000
-- 037:0688888808ccccc008c1c1c080cc8cc000ddd00000cddc0000ddd00000202000
-- 038:0000000006666660669999666996999669996996669669660666666000000000
-- 039:00000000088888808cc8ccc88c8888c88cc88cc88c8cc8c80888888000000000
-- 040:00000000011111101dddddd111d1d1d11d1d1d111dddddd10111111000000000
-- 041:0000000004444440499449944949449449444494499449940444444000000000
-- 042:0000000002222220266262622622266226622262262626620222222000000000
-- 043:0000000000700000070000077077077007df7df707dd7dd70077077000000000
-- 044:7700000077000000770000007700000077000000770000007777777767777777
-- 045:0000000000000000000000000000000000000000000000007777777777777777
-- 046:0000007700000077000000770000007700000077000000777777777777777776
-- 047:00000000000000000000000000377a00007b7a0000777a0000aaa00000000000
-- 048:0000000000000000000000000000000000505000507b005005b5b50005b57500
-- 049:0000000000000000000000000000000000000000010001001000001001111100
-- 054:0777777077c1c1c007c1c1c0077777700022200000c22c000022200000101000
-- 055:077777707777777007c1c1c0077777700022200000c22c000022200000101000
-- 056:0222222022c1c1c002c1c1c00222222000777000001271000077700000303000
-- 057:022222202222222002c1c1c00222222000777000001271000077700000303000
-- 058:0eeeeeee0ec4c4c00ec4c4c00cccccc00055500000c55c000055500000101000
-- 059:0eeeeeee0ec4c4c00ec4c4c00cccccc000555000005c50000055500000100000
-- 060:0eeeeeee0ec4c4c00ec4c4c00cccccc00055500000c55c000055510001000000
-- 061:0eeeeeee0ec4c4c00ec4c4c00cccccc000555000005c50000155500000000100
-- 062:0eeeeeee0ec4c4c00ec4c4c00cccccc00055500000c55c000015500000001000
-- 063:0eeeeeee0eccccc00ec4c4c00ccc8cc00055500000c55c000055500000101000
-- 064:0999999909c5c5c00cc5c5c00cccccc004d4d00004c4dc00044dd00000101000
-- 065:0999999909ccccc00cc5c5c00ccc8cc004d4d00004c4dc00044dd00000101000
-- 066:0699999909c1c1c009c1c1c009ccccc009bbb00000cbbc0000bbb00000505000
-- 067:0699999909ccccc009c1c1c009cc8cc090bbb00000cbbc0000bbb00000505000
-- 068:04eeeeee0ec5c5c00ec5c5c00eccccc00e33300000c33c000333330000202000
-- 069:04eeeeee0eccccc00ec5c5c00ecc8cc0e033300000c33c000333330000202000
-- 070:3777777047c1c1c047c1c1c0477777704022200000c22c000022200000101000
-- 071:077777703777777047c1c1c0477777704022200040c22c000022200000101000
-- 072:0999999909c5c5c00cc5c5c00cccccc000ccc000009cc9000066600000c0c000
-- 073:0999999909ccccc00cc5c5c00ccc8cc000ccc000009cc9000066600000c0c000
-- 074:000000006666666007c1c1c007c1c1c0077777700077700000c66c0000101000
-- 075:00000000066666606777777007c1c1c0077777700077700000c66c0000101000
-- 076:000000000444444404c7c7c00cc7c7c00cccccc000ddd00000cddc0000101000
-- 077:000000000444444404ccccc00cc7c7c00ccc8cc000ddd00000cddc0000101000
-- 080:0444444404c5c5c00cc5c5c00cc444c00076700000c67c000077722000101220
-- 081:0444444404ccccc00cc5c5c00cc444c00076700000cf6c000077722000101220
-- 082:02eeeeee0ec1c1c00ec1c1c00eccccc00e7770000ec77c000077700007771700
-- 083:02eeeeee0eccccc00ec1c1c00ecc6cc00e777000e0c77c000077700007771700
-- 084:0575e4b00ec1c1c00bc1c1c005475e4000bbb000007bb70000bbb00000404000
-- 085:0575e4b00e5b45e00bc1c1c005475e4000bbb000007bb70000bbb00000404000
-- 086:6575e4b04ec1c1c04bc1c1c045475e4040bbb000007bb70000bbb00000404000
-- 087:0575e4b06e5b45e04bc1c1c045475e4040bbb000407bb70000bbb00000404000
-- 088:3999999999c5c5c09cc5c5c09cccccc0906c600000c66c000066600000c0c000
-- 089:0999999939ccccc09cc5c5c09ccc8cc0906c600090c66c000066600000c0c000
-- 090:070000e0eee7ee7047c1c1c04ec1c1c04e7eee7040ee700000ceec0000707000
-- 091:070000e00ee7ee70e7ee7ee04ec1c1c04e7eee7040ee700040ceec0000707000
-- 092:000000003444444444c7c7c04cc7c7c04cccccc04088800000c88c0000202000
-- 093:000000000444444434ccccc04cc7c7c04ccc8cc04088800040c88c0000202000
-- 096:0999999909c1c1c00cc1c1c00cccccff02b2b0fa02c2bca0022b400000505000
-- 097:0999999909ccccc00cc1c1c00ccc8cff02b2b0fa02c2bca0022b400000505000
-- 098:0844444404c1c1c004c1c1c004ccccc00066600000c66c000066600000202000
-- 099:0844444404ccccc004c1c1c040cc8cc00066600000c66c000066600000202000
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
-- 112:0eeeeeee0ec5c5c00ec5c5c00eeccce00046400000c64c000044477000202770
-- 113:0eeeeeee0eccccc00ec5c5c00eec8ce00046400000cf6c000044477000202770
-- 114:0299999909c5c5c009c5c5c009ccccc094d4d00004c4dc00044dd00000101000
-- 115:0299999909ccccc009c5c5c009cc8cc094d4d00004c4dc00044dd00000101000
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
-- 128:2222222222222222220220222202202222000022220000222200002222000022
-- 129:0222222022222222220000222200002222000022220000222222222202222220
-- 130:2200002222200022222200222222202222022222220022222200022222000022
-- 131:0222222022222220220000002222222002222222000000220222222202222220
-- 132:000dd00000dddd000dddfdd0dddddfdddddddddd3ddddddd3ddddddd033dddd0
-- 133:bbbbb000b5b5bbb0bb5bbbb0b5b5b5b0bbbb5bb00bb5b5b00bbbbb5000000005
-- 134:00e0000e0ee0e0ee0eee9e9eee99999ee996969ee966669ee966669e09966990
-- 135:00aaaa000affffa0af7ff7faaff77ffaaff77ffaaf7ff7fa0affffa000aaaa00
-- 136:00444000044444000444a44044444a4474444444744444440744444000774400
-- 137:0777700077777770767670007777770077f77700077777000070077000700077
-- 138:0022220000262600002222000302203000300300000330000030030000000000
-- 139:0002000200200026022222662e22222622200022000002220060222000222200
-- 140:0000000000aa0a000affafa0afaffafaaffeeffa0aaaeaa0000e000000000000
-- 141:000af0f0a0aaaf000aa00af0aa0000afaa0000af0aa00af000aaaf0f0a0af000
-- 142:cfcfcfcff3f3f3f378787878cfcfcfcff3f3f3f38a878a87cfcfcfcff7f3f7f3
-- 143:000000002000000262000026662222660612216000277200002f220000000000
-- 144:00000000000000000000000000000000000bb00000bf5b0000b55b000bbbbbb0
-- 145:000000000000000000000000000bb00000bf5b000bf555b00b5555b0bbbbbbbb
-- 146:000000000000000000bbbb000bf555b0bf55555bb555555bb555555bbbbbbbbb
-- 147:0000000020000002960720699922229909227290007222000002700000000000
-- 148:00000000000000000222200001212060022226900077290000ee207002e27700
-- 149:0022206022212760222229960077299602ee729602ee7260072e2700f270f277
-- 150:00000000000000000d0dddd00dddd6d00ddd11100d0dddd00000000000000000
-- 151:0000000000000000010dddd0011dd6d00dddf7f0011dddf0010dddd000000000
-- 152:10001ddd110d61df111ddd0f0dddd000111ddf00110ddd0f1001dddf00111ddd
-- 153:0000000000000000077007700aa77aa000a77a00000000000000000000000000
-- 154:0000000070000007a700007aaa7777aa0a6776a000722700007f770000000000
-- 155:0000000000170000017aa00006a6a0000a88aa00303330a00003a00000300a00
-- 156:0a0310a0a031aa0aa06a6a0a0accc7a007a77a77070aaa07007ede70000a0a00
-- 157:000000000000000088800000dcd80000ccc00008008888c000c88c0000c00c00
-- 158:0303000033330000dcd33000ccc300030033000c0033333c00c33c3000c0cc00
-- 159:000000000904409000444400044f644004466440004444000904409000000000
-- 160:0000000000000000000777004a76f670a47fff70a0f777700074707000000000
-- 161:000000070a777777a76f6f77a7ffff7047777770a477770007f7777007747770
-- 162:00000000000066000006600000506600000b0000044449000044900000449000
-- 163:00000000000666000066666000660000000666005505000005b5b50000bb0000
-- 164:000666600066666605660f0f05060000005066605005055055b5b50505bb5500
-- 165:00000000008022000002200000702200000a0000044449000044900000449000
-- 166:0080800000022200082222200022f0f0008222007707000007a7a70000aa0000
-- 167:080222200022222287220f0f07020000007022207807077077a7a70707aa7700
-- 168:0000000000000000000030000030000000033000003823000032230000333300
-- 169:0000000000030000000000000303300300382300038222300322223003333330
-- 170:0030000000000300303333000382223338222223322222233222222333333333
-- 171:000000000000000000a0000000fa880008888800008080000000000000000000
-- 172:0000000000a0000008fa8880088f878888888888088888800800008000000000
-- 173:0a0000000fa8888008fa8880088f8788888888a80888888a0800008000000000
-- 174:0066600002eeee006ee6e6002e36e6000ee33303003330000303000000000300
-- 175:02eeee006ee6e6002e36e6000ee3330000eee0a0039e934000e9e04003330040
-- 176:0077770000777700077777700036360000333303330330333000300000030000
-- 177:0077770000777700077777700026260020222202220220220002200000200200
-- 178:000000000000000000ffff000af1f1000affff000fffff000a0ff0f006f00f00
-- 179:30000000010000000333ff0a0036f10a00ffff03003fff3a030ff00633f00f00
-- 180:003333003036360330323203033333300033330003033030630fa0300aa0faf3
-- 181:0000000000aaa0000aaaaa000faaaf000ff7f7000fff4f0000fff00009909900
-- 182:00000000079797700dfddfd0f07ff70ff07dd70f909ff9090070070007700770
-- 183:090000900733337073afaf37797a7a9773777737033333300930039093900939
-- 184:0000600000e6e6000949949099966999409ee904040440400090090004904900
-- 185:000000000000000000000000000000000444440004bcb40004ccc40000c0c000
-- 186:000000000000a000000aaa0000444440004cac40004bcb400c4ccc4c0c00000c
-- 187:000000000000000000000000000000000bbb00000bbdbbb50b5cccb0000c00c0
-- 188:00008000000880000bbbbb000dbdbbb07575bbb55555bbb500ccccb000cc0cc0
-- 189:000000000000000000fff0000d33df000f373f000f737f0000fff00000a0a000
-- 190:00022220000a022000aaa02000dad02202a2a20002222200a02220a000020000
-- 191:a00a00a085aaa580a5dad5a0555a550005a5a5a005aaa55aa55555a00a055000
-- 192:0000000000000000000b000000b00000099990400e9e90400099440004004000
-- 193:000000000000b000009b9990094bb4900999990049e9e940c49494ccc444440c
-- 194:000000e000005500009955000c9e9cc0c949c90c49949c444449944404444440
-- 195:0000000000cc80000c8ccc0008cc8c000888880000cfc00000fff00000f0f000
-- 196:0000000000000000000000000c000c00040c04000bb4bbc05b5bbb40bbbbbbb0
-- 197:00f00000f0d0f0f0dfdfdfd00d0ddd000acaca00aaa7aaa0aa7a7aa00aaaaa00
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
-- 213:000000000000000000000000a0a0a0000aaa000002a2aaa00777777a0a0a00a0
-- 214:00aaa00007777a00a7a7a7a002a2077aaafaa7a000007a000007aaaa00077777
-- 215:0000d000000d00000066600000d6d00000666000006d606000090dc00006c000
-- 216:00d00060000d00c0009d90d00969690d96d6d609066d6600d00900000600d000
-- 217:90ddd09009666900e6d6d6ec096d69090996990690ddd090069cdd000000dddd
-- 218:0000300000030000002220000032300000222000002320200001038000028000
-- 219:0030003000030080001310300121210312323201022322003001000002003000
-- 220:1033301001222100723232780123210101121102103330100218330000003333
-- 221:00000000000a000003a7a30023333320076367000233320000a3a00000202000
-- 222:00a0000003030300033333000a636a00023232000a737a000077700000202000
-- 223:0055550005bb5b505b54bbb554b4445505474740000444000004940000404040
-- 224:0000000000055000005bb500005bb50005b22b5005b24b5005bbbb5000555500
-- 225:0004000000000000002449044046490000444900009990000000004004000000
-- 226:000000000000000000377a00007d7a0000777a0000aaad0000dd000000d00d00
-- 227:00000000006669000669ffe02269ffee06699eee06699eeb0066eeb000000000
-- 228:0000000000032000000d300009ebd320069ebd300009e0000006900000000000
-- 229:000000000000000000377a00007b7a0000777a0000aaa0000000000000000000
-- 230:000060000066660000696600009999000099e90000eeee0000efee0000ffff00
-- 231:00000000000ff00000f00f000f0a00d00f0000d000d00d00000dd00000000000
-- 232:0000b0000bb005b005b00bb0b00000000000000b0bb00b500b500bb0000b0000
-- 233:000020000022220000232200003333000033830000888800008f880000ffff00
-- 234:0000000000033000003003000302008003000080008008000008800000000000
-- 235:0000000002022010002112000217117002111170007117000107702000000000
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
-- 247:00ffff0000feef0000feef0000feef0000ffff0000feef0000feef0000ffff00
-- 248:0000000020000020222222202020202020000020020202000222220000000000
-- 249:0200002020200002023333000032320000333300003030200000320200300020
-- 250:070000707670076776e77e67077777707a7777f77fafafa707fafa7000777700
-- 251:0600000069600000069600000669600006069600000669600600069600060660
-- 252:000000000e00e00000e00e00000e00e00e00e00e00e00e00000e00000000e000
-- 253:0000cf000000f3000078780000cfcf0000f3f30000878a0000cfcf0000f3f700
-- 254:0000000000050000001000000323215536335332235135150000000000000000
-- 255:fffffffff077770ff770077ff706067ff700007ff7777777f777777ff7ffffff
-- </SPRITES>

-- <SPRITES1>
-- 000:2222222220022002200220022000000220000002200000022000000220000002
-- 001:0222222020000002200000022000000220000002200000022000000202222220
-- 002:2200000222200002222200022022200220022202200022222000022220000022
-- 003:0222222020000000200000000222222002222220000000020000000202222220
-- 004:000dd00000dddd000dddfdd0dddddfdddddddddd1ddddddd1ddddddd011dddd0
-- 005:bbbbb000b5b5bbb0bb5bbbb0b5b5b5b0bbbb5bb00bb5b5b00bbbbb5000000005
-- 006:00e0000e0ee0e0ee0eee9e9eee99999ee996969ee966669ee966669e09966990
-- 007:00aaaa000affffa0af7ff7faaff77ffaaff77ffaaf7ff7fa0affffa000aaaa00
-- 008:00444000044444000444a44044444a4474444444744444440744444000774400
-- 009:0777700077777770767670007777770077f77700077777000070077000700077
-- 010:0022220000262600002222000302203000300300000330000030030000000000
-- 011:0002000200200026022222662e22222622200022000002220060222000222200
-- 012:0000000000aa0a000affafa0afaffafaaffeeffa0aaaeaa0000e000000000000
-- 013:000af0f0a0aaaf000aa00af0aa0000afaa0000af0aa00af000aaaf0f0a0af000
-- 015:cfcfcfcff3f3f3f378787878cfcfcfcff3f3f3f38a878a87cfcfcfcff7f3f7f3
-- 016:00000000000000000000000000000000000bb00000bf5b0000b55b0000bbbb00
-- 017:000000000000000000000000000bb00000bf5b000bf555b00b5555b00bbbbbb0
-- 018:000000000000000000bbbb000bf555b0bf55555bb555555bb555555bbbbbbbbb
-- 019:0000000020000002960720699922229909227290007222000002700000000000
-- 020:00000000000000000222200006262060022226900077290000ee207002e27700
-- 021:0022206022262760222229960077299602ee729602ee7260072e2700f270f277
-- 022:00000000000000000d0dddd00dddd6d00ddd11100d0dddd00000000000000000
-- 023:0000000000000000010dddd0011dd6d00dddf7f0011dddf0010dddd000000000
-- 024:10001ddd110d61df111ddd0f0dddd000111ddf00110ddd0f1001dddf00111ddd
-- 025:0000000000000000077007700aa77aa000a77a00000000000000000000000000
-- 026:0000000070000007a700007aaa7777aa0a6776a000722700007f770000000000
-- 027:0000000000170000017aa00006a6a0000a88aa00303330a00003a00000300a00
-- 028:0a0310a0a031aa0aa06a6a0a0accc7a007a77a77070aaa07007ede70000a0a00
-- 029:000000000000000088800000dcd80000ccc00008008888c000c88c0000c00c00
-- 030:0303000033330000dcd33000ccc300030033000c0033333c00c33c3000c0cc00
-- 031:000000000904409000444400044f644004466440004444000904409000000000
-- 032:0000000000000000000777004a76f670a47fff70a0f777700074707000000000
-- 033:000000070a777777a76f6f77a7ffff7047777770a477770007f7777007747770
-- 034:00000000000066000006600000506600000b0000044744400044740000774700
-- 035:00000000000666000066666000660000000666005505000005b5b50000bb0000
-- 036:000666600066666605660f0f05060000005066605005055055b5b50505bb5500
-- 037:00000000000088000008800000708800000a0000044444400044440000444400
-- 038:00000000000333000033333000330000000333007707000007a7a70000aa0000
-- 039:000222200022222207220f0f07020000007022207007077077a7a70707aa7700
-- 040:0000000000000000000000000000000000033000003f23000032230000333300
-- 041:00000000000000000000000000033000003f230003f222300322223003333330
-- 042:00000000000000000033330003f222303f222223322222233222222333333333
-- 043:000000000000000000a0000000fa880008888800008080000000000000000000
-- 044:0000000000a0000008fa8880088f878888888888088888800800008000000000
-- 045:0a0000000fa8888008fa8880088f8788888888a80888888a0800008000000000
-- 046:000000000026000000eee0000e3e3e000e6e6e000e333e000330030000030000
-- 047:0026000000e6e0000eeeee000e3e3e000e6e6e000e333e000303330000303030
-- 048:0077770000777700077777700036360000333303330330333000300000030000
-- 049:0077770000777700077777700026260020222202220220220002200000200200
-- 050:000000000000000000ffff000af1f1000affff000fffff000a0ff0f006f00f00
-- 051:000000000000000000ffff0a00f6f60a00ffff03003fff3a030ff00600f00f00
-- 052:002222000026260020222200222222220002200200200200602fa2000aa0faf0
-- 053:0000000000aaa0000aaaaa000faaaf000ff7f7000fff4f0000fff00009909900
-- 054:00000000079797700dfddfd0f07ff70ff07dd70f909ff9090070070007700770
-- 055:090000900733337073afaf37797a7a9773777737033333300930039093900939
-- 056:0000600000e6e6000949949099966999409ee904040440400090090004904900
-- 057:000000000000000000000000000000000444440004bcb40004ccc40000c0c000
-- 058:000000000000a000000aaa0000444440004cac40004bcb400c4ccc4c0c00000c
-- 059:000000000000000000000000000000000bbb00000bbdbbb50b5cccb0000c00c0
-- 060:00008000000880000bbbbb000dbdbbb07575bbb55555bbb500ccccb000cc0cc0
-- 061:000000000000000000fff0000d33df000f373f000f737f0000fff00000a0a000
-- 062:00022220000a022000aaa02000dad02202a2a20002222200a02220a000020000
-- 063:a00a00a085aaa580a5dad5a0555a550005a5a5a005aaa55aa55555a00a055000
-- 064:0000000000000000000b000000b00000099990400e9e90400099440004004000
-- 065:000000000000b000009b9990094bb4900999990049e9e940c49494ccc444440c
-- 066:000000e000005500009955000c9e9cc0c949c90c49949c444449944404444440
-- 067:0000000000cc80000c8ccc0008cc8c000888880000cfc00000fff00000f0f000
-- 068:0000000000000000000000000c000c00040c04000bb4bbc05b5bbb40bbbbbbb0
-- 069:00f00000f0d0f0f0dfdfdfd00d0ddd000acaca00aaa7aaa0aa7a7aa00aaaaa00
-- 070:0000000000000000006000000666060000c00c060033330c032323c033333333
-- 071:00055500000a005006666005077776050555570507ff755005ff550005005000
-- 072:0b05500006555500bbb555007b7bb500cbcbbb05cccbbbb50cccbb0555005500
-- 073:00000000000700700033307000b3b30000303730030076700000070000000000
-- 074:002d002202d332dd00300300233323000b2b2770023372702007667000077700
-- 075:0000000000000000000000000000000000070000006960000099707000099600
-- 076:00000000000000000666600006cec60067e00e606600c607000e6666000cece6
-- 077:0076660007d67660066ccc76eec00c660000c760e00c66660ec7667c076cccc0
-- 078:0000707000077770000f7f700007777a0000770a0a0077700a007700a0a77770
-- 079:0000000000110d00001dd00001010b0b000000b008820bbb8220005008800505
-- 080:000000000000000000077700007777000777770007e2e7001327231013323331
-- 081:007770000737370002777200002220000077700023e7e3202027200270707070
-- 082:00000000000b000000b5b0001b444b1005e4e5000144410000b4b00000101000
-- 083:00b00000040b0400044444000be4eb00014141000b545b000055500000101000
-- 084:0000000000000000000000000aaa0000a2a0000a333aaa0a003333a000300300
-- 085:000000000000000000000000a0a0a0000aaa000002a2aaa00777777a0a0a00a0
-- 086:00aaa00007777a00a7a7a7a002a2077aaafaa7a000007a000007aaaa00077777
-- 087:0000d000000d00000066600000d6d00000666000006d606000090dc00006c000
-- 088:00d00060000d00c0009d90d00969690d96d6d609066d6600d00900000600d000
-- 089:90ddd09009666900e6d6d6ec096d69090996990690ddd090069cdd000000dddd
-- 090:0000300000030000002220000032300000222000002320200001038000028000
-- 091:0030002000030080001310300121210312323201022322003001000002003000
-- 092:1033301001222100723232780123210101121102103330100218330000003333
-- 093:00000000000a000000a7a0002a333a20076367000233320000a3a00000202000
-- 094:00a00000030a0300033333000a636a00023232000a737a000077700000202000
-- 095:0055550005bb5b505b54bbb554b4445505474740000444000004940000404040
-- 096:0000000000000000000000000000000000000000000000f000560f000066ff00
-- 097:00000000000000000000000000000000b000000f05660ff006660f00066fff00
-- 098:110110331e6e1306196913006d9d6033e999e5536e6e6555096900010e0e006e
-- 099:000000000000000000000400037599903a337970e3e59990333ab3b007037030
-- 100:00000000000004000000999903759e9e3a33e999e3e59ee9333ab3b007037030
-- 101:00005400000599950009e99e3093ee9e333399e9e33e9eee31139e9e07003703
-- 102:0000000000000000000100000a7a740009aaaa000f7f7a000aaaa90000400a00
-- 103:000bb0000033330000b33b007735537775355357773333777533335707033070
-- 104:0000e000000777000ffefeff0a3fff3a7af9e9fa0a3e9e3a00fffff007707077
-- 105:00266200022222202262622222aaaa22a9ae9a20aa2aa200ea722700fe300300
-- 106:400220400ffddff0f101701ff770777ff107101f02ff2f202402000220002402
-- 107:2008000220033002020ff02000200200800ff0083023320332008023200aa002
-- 108:0008880000083800000080000001230007033307070321070700300707707077
-- 109:0000dd000aaafff0aaadd33fa7a33ddfa7a33ddfa7add33faaadd33f0aaafff0
-- 255:0000cf000000f3000078780000cfcf0000f3f30000878a0000cfcf0000f3f700
-- </SPRITES1>

-- <SPRITES2>
-- 000:0000000000fff6000066666000c1c10000cccc000066660000c330c000300300
-- 001:0000000000fff6000066666000c1c10000cccc00006666000c0330c000033000
-- 002:0000000000fff6000066666000c1c10000cccc00006666000c033c0000300300
-- 003:0000000000fff6000066666000c1c10000cccc00006666000c0330c000033000
-- 004:0000000000fff6000066666000c1c10000cccc00006666000c0330c000300300
-- 005:0000000000fff6000066666000c1c10000cccc000c6666c00003300000300300
-- 006:8888888878788888787877887778787878787878787877888888788888888888
-- 007:88888888888888888aaaaaaaa8888888a88888888aaaaaaa8888888888888888
-- 008:8888888888888888aaaaaaaa8888888888888888aaaaaaaa8888888888888888
-- 009:0000000000333300000220000033330000222200003223000033330000000000
-- 010:0000000000eeee000009900000eeee000099e900009e990000eeee0000000000
-- 011:00000000000066000006666000f666600fff66000ffff00000ff000000000000
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
-- 022:000000000aaaaaa0affffffaaffaaffaaffaaffaaffffffa0aaaaaa000000000
-- 023:0000000002222220233333322322223223322332233333320222222000000000
-- 024:00000000099999909eeeeee99e99e9e99e9e99e99eeeeee90999999000000000
-- 025:0000000001111110177177711771117117111771177717710111111000000000
-- 026:00000000055555505bbbbbb55b555bb55bb555b55bbbbbb50555555000000000
-- 027:0000000000999900000660000099990000996900009669000099990000000000
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
-- 038:0000000006666660669999666996999669996996669669660666666000000000
-- 039:00000000088888808cc8ccc88c8888c88cc88cc88c8cc8c80888888000000000
-- 040:00000000011111101dddddd111d1d1d11d1d1d111dddddd10111111000000000
-- 041:0000000004444440499449944949449449444494499449940444444000000000
-- 042:0000000002222220266262622622266226622262262626620222222000000000
-- 043:0000000000700000070000077077077007df7df707dd7dd70077077000000000
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
-- 074:0000000000000000000ff00000ffff0000f1f10000ffff0000ffff0000f0f000
-- 075:0000000000000000000ff00000ffff0000f1f10000ffff0000ffff00000f0f00
-- 076:00000000000000000099990000c5c50000cccc0000cccc000c0660c000c00c00
-- 077:00000000000000000099990000c5c50000cccc000cccccc00006600000c00c00
-- 078:0000000000000000000000000044440000c7c70000dddd000c0330c000300300
-- 079:0000000000000000000000000044440000c7c7000cddddc00003300000300300
-- 080:000000000000000000eeee0000c5c50000cccc00003333000c0220c000200200
-- 081:000000000000000000eeee0000c5c50000cccc000c3333c00002200000200200
-- 082:0000000000000000003444000045c500004ccc0000eeee000c0990c000900900
-- 083:0000000000000000003444000045c500004ccc000ceeeec00009900000900900
-- 084:000000000000000000479e0000e1c10000974400009999000704407000400400
-- 085:000000000000000000479e0000e1c10000974400079999700004400000400400
-- 086:000000000600000040479e0040e1c10000974400009999000704407000400400
-- 087:000000004600000040479e0000e1c10000974400079999700004400000400400
-- 088:0000000000fff1000011111000c5c50000cccc00001111000c0330c000300300
-- 089:0000000000fff1000011111000c5c50000cccc00001111000c0330c000300300
-- 090:000000000000000004700700407777004071c100007777000c0770c000700700
-- 091:000000000000000044700700407777000071c1000c7777c00007700000700700
-- 092:00000000020000009099990090c5c50000cccc0000c66c000c0660c000c00c00
-- 093:00000000920000009099990000c5c50000cccc000cc66cc00006600000c00c00
-- 094:0000000000000000030000004044440040c7c700008888000c0220c000200200
-- 095:0000000000000000430000004044440000c7c7000c8888c00002200000200200
-- 096:00000000000000000099990000c1c10000cccc0000bbbb000c0550c000500500
-- 097:00000000000000000099990000c1c10000cccc000cbbbbc00005500000500500
-- 098:0000000000000000008444000041c100004ccc00006666000c0220c000200200
-- 099:0000000000000000008444000041c100004ccc000c6666c00002200000200200
-- 100:aaaaaaaaa777777aa7dddd7aa7dddd7aa7d7997aa799447aaa7777aaaaa3aaaa
-- 101:aaaaaaaaa777777aa7dddd7aa7dd7d7aa7d9997aa794447aaa7777aaaaa3aaaa
-- 102:aaaaaaaaa777777aa7dddd7aa7d7dd7aa799997aa744447aaa7777aaaaa3aaaa
-- 103:aaaaaaaaa777777aa7dddd7aa7dd7d7aa799997aa744447aaa7777aaaaa3aaaa
-- 104:aaaaaaaaa777777aa7dddd7aa7d7dd7aa7999d7aa744497aaa7777aaaaa3aaaa
-- 105:aaaaaaaaa777777aa7dddd7aa7dd7d7aa7999d7aa744497aaa7777aaaaa3aaaa
-- 106:aaaaaaaaa777777aa7dddd7aa7dddd7aa797dd7aa749997aaa7777aaaaa3aaaa
-- 107:aaaaaaaaa777777aa7dddd7aa7dddd7aa7dd7d7aa799997aaa7777aaaaa3aaaa
-- 108:aaaaaaaaa777777aa7dddd7aa7dddd7aa7d7d97aa799947aaa7777aaaaa3aaaa
-- 109:aaaaaaaaa777777aa7dddd7aa7ffff7aa7d7997aa7ffff7aaa7777aaaaa3aaaa
-- 110:aaaaaaaaa777777aa7ffff7aa7ffff7aa7ffff7aa7ffff7aaa7777aaaaa3aaaa
-- 111:aaaaaaaaa777777aa7ffff7aa7dddd7aa7ffff7aa799447aaa7777aaaaa3aaaa
-- 112:000000000000000000eeee0000c1c10000cccc00009999000c0440c000400400
-- 113:000000000000000000eeee0000c1c10000cccc000c9999c00004400000400400
-- 114:0000000000000000002999000095c500009ccc0000dddd000c0110c000100100
-- 115:0000000000000000002999000095c500009ccc000cddddc00001100000100100
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
-- 133:9999900094949990994999909494949099994990099494900999994000000004
-- 134:00e0000e0ee0e0ee0eee9e9eee99999ee996969ee966669ee966669e09966990
-- 135:00aaaa000affffa0af7ff7faaff77ffaaff77ffaaf7ff7fa0affffa000aaaa00
-- 136:00444000044444000444a44044444a4474444444744444440744444000774400
-- 137:0777700077777770767670007777770077f77700077777000070077000700077
-- 138:0022220000262600002222000302203000300300000330000030030000000000
-- 139:0002000200200026022222662e22222622200022000002220060222000222200
-- 140:0000000000aa0a000affafa0afaffafaaffeeffa0aaaeaa0000e000000000000
-- 142:cfcfcfcff3f3f3f378787878cfcfcfcff3f3f3f38a878a87cfcfcfcff7f3f7f3
-- 143:000000002000000262000026662222660612216000277200002f220000000000
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
-- 155:0000000000170000017aa00006a6a0000a88aa00303330a00003a00000300a00
-- 156:0a0310a0a031aa0aa06a6a0a0accc7a007a77a77070aaa07007ede70000a0a00
-- 157:000000000000000088800000dcd80000ccc00008008888c000c88c0000c00c00
-- 158:0303000033330000dcd33000ccc300030033000c0033333c00c33c3000c0cc00
-- 159:000000000a0330a000333300033f633003366330003333000a0330a000000000
-- 160:0000000000000000000777004a76f670a47fff70a0f777700074707000000000
-- 161:000000070a777777a76f6f77a7ffff7047777770a477770007f7777007747770
-- 162:0000000000006600000660000040660000090000044744400044740000774700
-- 163:0000000000066600006666600066000000066600440400000494940000990000
-- 164:000666600066666604660f0f0406000000406660400404404494940404994400
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
-- 187:000000000000000000000000000000000bbb00000bbdbbb50b5cccb0000c00c0
-- 188:00008000000880000bbbbb000dbdbbb07575bbb55555bbb500ccccb000cc0cc0
-- 189:000000000000000000fff0000d33df000f373f000f737f0000fff00000a0a000
-- 190:00022220000a022000aaa02000dad02202a2a20002222200a02220a000020000
-- 191:a00a00a085aaa580a5dad5a0555a550005a5a5a005aaa55aa55555a00a055000
-- 192:0000000000000000000b000000b00000099990400e9e90400099440004004000
-- 193:000000000000b000009b9990094bb4900999990049e9e940c49494ccc444440c
-- 194:000000e000005500009955000c9e9cc0c949c90c49949c444449944404444440
-- 195:0000000000cc80000c8ccc0008cc8c000888880000cfc00000fff00000f0f000
-- 196:0000000000000000000000000c000c00040c04000bb4bbc05b5bbb40bbbbbbb0
-- 197:00f00000f0d0f0f0dfdfdfd00d0ddd000acaca00aaa7aaa0aa7a7aa00aaaaa00
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
-- 210:0000000000090000009490001922291004626400012221000092900000101000
-- 211:0090000002090200022222000962690001212100094249000044400000101000
-- 212:0000000000000000000000000aaa0000a2a0000a333aaa0a003333a000300300
-- 213:000000000000000000000000a0a0a0000aaa000002a2aaa00777777a0a0a00a0
-- 214:00aaa00007777a00a7a7a7a002a2077aaafaa7a000007a000007aaaa00077777
-- 215:0000d000000d00000066600000d6d00000666000006d606000090dc00006c000
-- 216:00d00060000d00c0009d90d00969690d96d6d609066d6600d00900000600d000
-- 217:90ddd09009666900e6d6d6ec096d69090996990690ddd090069cdd000000dddd
-- 218:0000300000030000002220000032300000222000002320200001038000028000
-- 219:0030002000030080001310300121210312323201022322003001000002003000
-- 220:1033301001222100723232780123210101121102103330100218330000003333
-- 221:00000000000a000000a7a0002a333a20076367000233320000a3a00000202000
-- 222:00a00000030a0300033333000a636a00023232000a737a000077700000202000
-- 223:0099990009ee9e909e94eee994e4449909474740000444000004940000404040
-- 224:0000000000055000005bb500005bb50005b22b5005b24b5005bbbb5000555500
-- 225:000000000000000000377a0000797a0000777a0000aaa0000000000000000000
-- 226:000000000000000000377a00007d7a0000777a0000aaa0000000000000000000
-- 227:00000000006669000669ffe02269ffee06699eee06699eeb0066eeb000000000
-- 228:0000000000032000000d300009ebd320069ebd300009e0000006900000000000
-- 229:000000000000000000377a00007b7a0000777a0000aaa0000000000000000000
-- 230:000060000066660000696600009999000099e90000eeee0000efee0000ffff00
-- 231:00000000000ff00000f00f000f0a00d00f0000d000d00d00000dd00000000000
-- 232:0000e000099009e004900ee09000000000000004066004200620044000060000
-- 233:000020000022220000232200003333000033830000888800008f880000ffff00
-- 234:0000000000033000003003000302008003000080008008000008800000000000
-- 235:0000000002022010002112000217117002111170007117000107702000000000
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
-- 247:00ffff0000feef0000feef0000feef0000ffff0000feef0000feef0000ffff00
-- 248:0000000020000020222222202020202020000020020202000222220000000000
-- 249:0200002020200002023333000032320000333300003030200000320200300020
-- 250:070000707670076776e77e67077777707a7777f77fafafa707fafa7000777700
-- 251:0600000069600000069600000669600006069600000669600600069600060660
-- 252:000000000e00e00000e00e00000e00e00e00e00e00e00e00000e00000000e000
-- 253:0000cf000000f3000078780000cfcf0000f3f30000878a0000cfcf0000f3f700
-- 254:0000000000050000001000000323215536335332235135150000000000000000
-- 255:fffffffff077770ff770077ff706067ff700007ff7777777f777777ff7ffffff
-- </SPRITES2>

-- <SPRITES3>
-- 000:0000000000fff6000066666000c1c10000cccc000066660000c330c000300300
-- 001:0000000000fff6000066666000c1c10000cccc00006666000c0330c000033000
-- 002:0000000000fff6000066666000c1c10000cccc00006666000c033c0000300300
-- 003:0000000000fff6000066666000c1c10000cccc00006666000c0330c000033000
-- 004:0000000000fff6000066666000c1c10000cccc00006666000c0330c000300300
-- 005:0000000000fff6000066666000c1c10000cccc000c6666c00003300000300300
-- 006:8888888878788888787877887778787878787878787877888888788888888888
-- 007:88888888888888888aaaaaaaa8888888a88888888aaaaaaa8888888888888888
-- 008:8888888888888888aaaaaaaa8888888888888888aaaaaaaa8888888888888888
-- 009:0000000000333300000220000033330000222200003223000033330000000000
-- 010:0000000000eeee000009900000eeee000099e900009e990000eeee0000000000
-- 011:00000000000066000006666000f666600fff66000ffff00000ff000000000000
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
-- 022:000000000aaaaaa0affffffaaffaaffaaffaaffaaffffffa0aaaaaa000000000
-- 023:0000000002222220233333322322223223322332233333320222222000000000
-- 024:00000000099999909eeeeee99e99e9e99e9e99e99eeeeee90999999000000000
-- 025:00000000077777707ff7fff77ff777f77f777ff77fff7ff70777777000000000
-- 026:00000000055555505bbbbbb55b555bb55bb555b55bbbbbb50555555000000000
-- 027:0000000000999900000660000099990000996900009669000099990000000000
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
-- 038:0000000006666660669999666996999669996996669669660666666000000000
-- 039:00000000088888808cc8ccc88c8888c88cc88cc88c8cc8c80888888000000000
-- 040:00000000011111101dddddd111d1d1d11d1d1d111dddddd10111111000000000
-- 041:0000000004444440499449944949449449444494499449940444444000000000
-- 042:0000000002222220266262622622266226622262262626620222222000000000
-- 043:0000000000700000070000077077077007df7df707dd7dd70077077000000000
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
-- 142:cfcfcfcff3f3f3f378787878cfcfcfcff3f3f3f38a878a87cfcfcfcff7f3f7f3
-- 143:000000002000000262000026662222660612216000277200002f220000000000
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
-- 155:0000000000170000017aa00006a6a0000a88aa00303330a00003a00000300a00
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
-- 187:000000000000000000000000000000000bbb00000bbdbbb50b5cccb0000c00c0
-- 188:00008000000880000bbbbb000dbdbbb07575bbb55555bbb500ccccb000cc0cc0
-- 189:000000000000000000fff0000d33df000f373f000f737f0000fff00000a0a000
-- 190:00022220000a022000aaa02000dad02202a2a20002222200a02220a000020000
-- 191:a00a00a085aaa580a5dad5a0555a550005a5a5a005aaa55aa55555a00a055000
-- 192:0000000000000000000b000000b00000099990400e9e90400099440004004000
-- 193:000000000000b000009b9990094bb4900999990049e9e940c49494ccc444440c
-- 194:000000e000005500009955000c9e9cc0c949c90c49949c444449944404444440
-- 195:0000000000cc80000c8ccc0008cc8c000888880000cfc00000fff00000f0f000
-- 196:0000000000000000000000000c000c00040c04000bb4bbc05b5bbb40bbbbbbb0
-- 197:00f00000f0d0f0f0dfdfdfd00d0ddd000acaca00aaa7aaa0aa7a7aa00aaaaa00
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
-- 213:000000000000000000000000a0a0a0000aaa000002a2aaa00777777a0a0a00a0
-- 214:00aaa00007777a00a7a7a7a002a2077aaafaa7a000007a000007aaaa00077777
-- 215:0000d000000d00000066600000d6d00000666000006d606000090dc00006c000
-- 216:00d00060000d00c0009d90d00969690d96d6d609066d6600d00900000600d000
-- 217:90ddd09009666900e6d6d6ec096d69090996990690ddd090069cdd000000dddd
-- 218:0000300000030000002220000032300000222000002320200001038000028000
-- 219:0030002000030080001310300121210312323201022322003001000002003000
-- 220:1033301001222100723232780123210101121102103330100218330000003333
-- 221:00000000000a000000a7a0002a333a20076367000233320000a3a00000202000
-- 222:00a00000030a0300033333000a636a00023232000a737a000077700000202000
-- 223:0055550005bb5b505b54bbb554b4445505474740000444000004940000404040
-- 224:0000000000055000005bb500005bb50005b22b5005b24b5005bbbb5000555500
-- 225:000000000000000000377a0000797a0000777a0000aaa0000000000000000000
-- 226:000000000000000000377a00007d7a0000777a0000aaa0000000000000000000
-- 227:00000000006669000669ffe02269ffee06699eee06699eeb0066eeb000000000
-- 228:0000000000032000000d300009ebd320069ebd300009e0000006900000000000
-- 229:000000000000000000377a00007b7a0000777a0000aaa0000000000000000000
-- 230:000060000066660000696600009999000099e90000eeee0000efee0000ffff00
-- 231:00000000000ff00000f00f000f0a00d00f0000d000d00d00000dd00000000000
-- 232:0000b0000bb005b005b00bb0b00000000000000b0bb00b500b500bb0000b0000
-- 233:000020000022220000232200003333000033830000888800008f880000ffff00
-- 234:0000000000033000003003000302008003000080008008000008800000000000
-- 235:0000000002022010002112000217117002111170007117000107702000000000
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
-- 247:00ffff0000feef0000feef0000feef0000ffff0000feef0000feef0000ffff00
-- 248:0000000020000020222222202020202020000020020202000222220000000000
-- 249:0200002020200002023333000032320000333300003030200000320200300020
-- 250:070000707670076776e77e67077777707a7777f77fafafa707fafa7000777700
-- 251:0600000069600000069600000669600006069600000669600600069600060660
-- 252:000000000e00e00000e00e00000e00e00e00e00e00e00e00000e00000000e000
-- 253:0000cf000000f3000078780000cfcf0000f3f30000878a0000cfcf0000f3f700
-- 254:0000000000050000001000000323215536335332235135150000000000000000
-- 255:fffffffff077770ff770077ff706067ff700007ff7777777f777777ff7ffffff
-- </SPRITES3>

-- <MAP>
-- 000:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebed8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8bebebeaeaeaeaebeaeaeaeaeaeaeaebeaeaeaeaeaebeaeaeaeaeaebebebe9e9e9e8e8e8e8e9e8e8e8e8e8e8e8e9e8e8e8e8e8e9e8e8e8e8e8e9e9e9e000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000
-- 001:beaeaebebeaeaebebeaeaeaebeaeaebebeaeaeaebebeaeaebebeaeaeaebed8d8d8eed8d8d8eed8d8d8eed8d8d8eed8d8d8eed8d8d8eed8d8d8eed8d8bebeaeaeaeaeaeaebeaebebebeaebeaeaebebebeaeaebeaeaeaeaeaebebe9e9e8e8e8e8e8e8e9e8e9e9e9e8e9e8e8e9e9e9e8e8e9e8e8e8e8e8e9e9e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e200e20000000000000000000000000000000000000000000000000000e200
-- 002:beaeaebebebeaebebebeaeaeaebebeaeaeaeaebebebeaebebebeaeaeaebefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbbeaebebebeaeaebeaeaeaeaeaeaeaebeaeaeaeaeaebeaeaeaebebebeaebe9e8e9e9e9e8e8e9e8e8e8e8e8e8e8e9e8e8e8e8e8e9e8e8e8e9e9e9e8e9e000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000000000000000000000000000000000000000000000000000e2e2e2000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000e2
-- 003:bebeaeaebebebeaebe0000bebe0000bebebe0000beaebebebeaeaeaebebefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeaeaebeaebebebebebebeaeaeaebeaeaeaeaebebebebebebeaebeaeaeae8e8e8e9e8e9e9e9e9e9e9e8e8e8e9e8e8e8e8e9e9e9e9e9e9e8e9e8e8e8e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e20000000000000000000000000000000000000000000000000000e2e2e20000e200000000000000000000000000000000000000000000e20000e2
-- 004:beaebeaeaebebebeae007d8d9dadbdcdddedec00aebebebeaeaeaebeaebefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaebeaebeaeaeaebebeaeaebebebebebebebebeaeaebebeaeaeaebeaebeae8e9e8e9e8e8e8e9e9e8e8e9e9e9e9e9e9e9e9e8e8e9e9e8e8e8e9e8e9e8e00000000000000009aaabacadaea00009babbbcbdbeb0000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e200e2000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000e200e2
-- 005:beaeaebeaeaebebeaebe000000000000000000beaebebeaeaeaebeaeaebefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaebeaeaeaebeaeaeaeaeaeaeaebebebebeaeaeaeaeaeaeaebeaeaeaebeae8e9e8e8e8e9e8e8e8e8e8e8e8e9e9e9e9e8e8e8e8e8e8e8e9e8e8e8e9e8e000000000000009aaabacadaea000000009babbbcbdbeb00000000000000000000000000000000000000000000000000000000000000000000000000e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e200e20000e2000000000000000000000000000000000000e20000e200e2
-- 006:bebeaeaebeaeaebeaebe00002b1c2d0d240000beaebeaeaeaebeaeaebebe121212121212121212121212121212121212121212121212121212121212aebeaebeaeaeaebebeaeaebebebebebebebebeaeaebebeaeaeaebeaebeae8e9e8e9e8e8e8e9e9e8e8e9e9e9e9e9e9e9e9e8e8e9e9e8e8e8e9e8e9e8e00000000000000009aaabacadaea00009babbbcbdbeb0000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2000000000000000000000000000000000000e2e20000e2e2e200e200e2000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000e200e200e2
-- 007:bebebeaebebebebebe00000000003e0000000000bebebebebebebeaebebe121212121212121212121212121212121212121212121212121212121212aeaeaebeaebebebebebebeaeaeaebeaeaeaeaebebebebebebeaebeaeaeae8e8e8e9e8e9e9e9e9e9e9e8e8e8e9e8e8e8e8e9e9e9e9e9e9e8e9e8e8e8e000000009aaabacadaea007c8c9c00acbcccdc009babbbcbdbeb00000000000000000000000000000000000000000000000000000000000000000000e2e20000e2e2000000000000000000000000000000000000e2e20000e2e2e200e200e20000e20000000000000000000000000000e20000e200e200e2
-- 008:bebeaebebebebebebe00000000002f0000000000bebebebebebeaebebebe121212121212121212121212121212121212121212121212121212121212beaebebebeaeaebeaeaeaeaeaeaeaebeaeaeaeaeaebeaeaeaebebebeaebe9e8e9e9e9e8e8e9e8e8e8e8e8e8e8e9e8e8e8e8e8e9e8e8e8e9e9e9e8e9e00000000000000009aaabacadaea00009babbbcbdbeb0000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e20000e2e2e200e200e200e20000e2e2e2e2e2e2e2e2e2e2e2e20000e200e200e200e2
-- 009:bebeaeaebeaeaebeaebe000000001e00000000beaebeaeaeaebeaeaebebe121212121212121212121212121212121212121212121212121212121212bebeaeaeaeaeaeaebeaebebebeaebeaeaebebebeaeaebeaeaeaeaeaebebe9e9e8e8e8e8e8e8e9e8e9e9e9e8e9e8e8e9e9e9e8e8e9e8e8e8e8e8e9e9e000000000000009aaabacadaea000000009babbbcbdbeb00000000000000000000000000000000000000000000000000000000000000000000000000e2e20000e2e2000000000000000000000000000000000000e2e20000e2e2e200e200e20000e20000000000000000000000000000e20000e200e200e2
-- 010:beaeaebeaeaebebeaebe00000b4d0000000000beaebebeaeaeaebeaeaebe121212121212121212121212121212121212121212121212121212121212bebebeaeaeaeaebeaeaeaeaeaeaeaebeaeaeaeaeaebeaeaeaeaeaebebebe9e9e9e8e8e8e8e9e8e8e8e8e8e8e8e9e8e8e8e8e8e9e8e8e8e8e8e9e9e9e00000000000000009aaabacadaea00009babbbcbdbeb0000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2000000000000000000000000000000000000e2e20000e2e2e200e200e2000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000e200e200e2
-- 011:beaebeaeaebebebeaebe000000000000000000beaebebebeaeaeaebeaebe121212121212121212121212121212121212121212121212121212121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e200e20000e2000000000000000000000000000000000000e20000e200e2
-- 012:bebeaeaebebebeaeae00be8f9fafbfcfdfefff00aeaebebebeaeaeaebebe121212121212121212121212121212121212121212121212121212121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e200e2000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000e200e2
-- 013:beaeaebebebeaeaebe0000bebe0000bebebe0000beaeaebebebeaeaeaebe121212121212121212121212121212121212121212121212121212121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e20000000000000000000000000000000000000000000000000000e2e2e20000e200000000000000000000000000000000000000000000e20000e2
-- 014:beaebebebeaeaebebebeaeaeaebebeaeaeaeaebebebeaeaebebebeaeaebe121212121212121212121212121212121212121212121212121212121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000000000000000000000000000000000000000000000000000e2e2e2000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000e2
-- 015:beaebebeaeaeaebebeaeaeaebeaeaebebeaeaeaebebeaeaeaebebeaeaebe121212121212121212121212121212121212121212121212121212121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e200e20000000000000000000000000000000000000000000000000000e200
-- 016:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe121212121212121212121212121212121212121212121212121212121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000
-- 017:d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0e0fdfdfde0e0e0e0e0e0e0e0e0e0e0fdfdfde0e0fde0e0e0e0e0fde0e0000000000000000000000000000000000000000000000000000000000000
-- 018:d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000d0b0c0b0c0b0c010106010101010101010b0c0b0c0b0c0b0c0b0c0b0c0d0e0e0e0fde0e0e0e0e0e0e0e0e0e0e0e0e0e0fde0e0fde004e004e0e0fde0000000000000000000000000000000000000000000000000000000000000
-- 019:d012b0c012d0d0d0d012d01010637310d0b0c063736373101010101010d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d01010101010d012d0121212d012121212121010101010101210101010d0000000000000000000000000000000000000000000000000000000000000d0b1c1b1c1b1c1101010e0e0e0e0e0e010b1c1b1c1b1c1b1c1b1c1b1c1d0e0e0e0fde0e0e00404e00404e0e0e0e0e0e0fde0e0fde004e00404e0fdfd000000000000000000000000000000000000000000000000000000000000
-- 020:d012b1c1121212121212d01010647410d0b1c16474647410102525252525000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004040400000000000000000000000000252525102510d012121212121212d012d0d0d0d0101010121212101010d0000000040404040404040404040404040404040404040404040404040000d06060101010202020e02310b0c0b0c0e010601041101020202020b0c0d0e0e0e0fde0e0e0e0040404040404e0fde0e0e0e0e0fde00404040404e0e0000000000000000000000000000000000000000000000000000000000000
-- 021:d01212121212121212d0d01010251010d0102525252525252525252525d0000000000000000000000404040000000000000000000000000000000000000000000000000000000004040404130404040400000000000000000000d02525251010d0d0d0d0d0d0d0d0d010101010d0d0d0d0d012d0d0d0d0d0000000041717171717171717171717171717171704131717171717040000d0b0c01020202020e0101010b1c1b1c112e0601010101010202020b1c1d0e0e0e0fde0e0e0e00404e0040404e0e0e0e0fde0e0e0e0040404e004e0e0000000000000000000000000000000000000000000000000000000000000
-- 022:d0121212121210101010d0d0102510d0d0102510101010101010311010d0000000000000000000040423040404040404000000000000000000000000000000000000000000000004491717511717170400000000000000000000d0d0d060d0d0d05a121212121212d0d0d0d01010d01010d012d0121212d0000000040e4c515151510451515151515151515104515151515151040000d0b1c110102020e0b0c01010101010121212e01010101010102020b0c0d0e0e0e0fde0e0e0e0e004e004e0e0e0e0e0e0fde0e0fde0e0e004e004e0e0000000000000000000000000000000000000000000000000000000000000
-- 023:d0121212d0637310106171d0d025d0d0b0c02563736373617110101010d00000000000000000000417511717172838040000000000000000000000000000000000000000000000044a5151515151b40404040404040000000000d01212121212d012121212121212101010d01010d01012d012d0121212d0000000040f2e515151510451515104040451510404515151515151040000d0b0c010102020e0b1c1b0c0101010101212e01010101212101020b1c1d0e0e0fdfdfde0e0e0e0e0e0e0e0e0e0e0e0fdfdfde0e0e0e0e0e0e0e0e0e0000000000000000000000000000000000000000000000000000000000000
-- 024:d01212d0d064741010627210102510d0b1c12564746474627210101010d0000000000000000000040151515151293904000000000000000000000000000000000000000000000004515151515151510458687888040000000000d01212121212d012121212121212121210d0d010d01212121212121212d0000000040f2e040404040404040404171751511704040404045104040000d0b1c112101010e0b0c0b1c1b0c010101010061010121212121010b0c0d0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0000000000000000000000000000000000000000000000000000000000000
-- 025:d0d0d0d0d0d02525252525252525252525252525252525252525101010d0000000000000000000040251324252515104000000000000000000000000000000000000000000000004515132425251511759697989040000000000d01212121212d0121210d0d0d010101010d01010d012d0d0d0d0d0d0d0d0000000040f2e041717171717171704515151515104041717175117040000d0b0c012121010e0b1c16a7ab1c120101010e01012121212121210b1c1d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 026:d010101010d0d025101010101010101010102010101010101025101010d0000000000000000000040348515151512104000000000000000000000000000000000000000000000004515151515151515151515151040000000000d03040404050d0101212d010d0d0121210d01010d01212121212121212d0000000040f2e045151515151515104515151515117170e3d3d3d4c040000d0b1c112121210e010106b7b312020101010e010121212121212106060d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 027:d01008181010d02510b0c0101010101010101063736171637325101012d0000000000000000000045151515151512204000000000000000000000000000000000000000000000004515151515151515151515151040000000000d01010101010d0d01212d0121212121212d01012d01212101012121010d0000000040f2e045151045151040404040404040404040fdedede2e040000d0b0c012121212e010101010101010102020e01010121212121010b0c0d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 028:d01009192525252510b1c1103040404040405064746272647425101212d0000000000000000000040404040404040404000000000000000000000000000000000000000000000004040404350404040404040404040000000000d01010101010d0101212d01212d0d0d0d0d0d012d030404040404050d0d0000000040f2e045151045151171717171717171717040fde2cde2e040000d0b1c1121212120ae010b0c0b0c0b0c020e0071010101212101010b1c1d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 029:d03125252510d0d0d0d0d0d01010252525252525252525252525101212d0000000000000000000575757575757575757000000000000000000000000000000000000000000000057575704040457575757575757570000000000d01210101010d0121212d01212d0121212d01212d01010102510101010d0000000040f2e045151045151515151045151515151040fdedede2e040000d0b0c012121212120ae0b1c1b1c1b1c1e0b0c01010101010251010b0c0d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 030:d010101010101212121212d0d010252531101020201010101010121212d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000057575700000000000000000000000000d0121210101012121210d01212d012d012d01212d01020101025311010d0000000041f1d175151045151515151045151512351041f3f3f3f1d040000d0b1c11212121212120ae0e0e0e0e0e007b1c11010101025101010b1c1d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 031:d01010101212121012121212d01025252510101020201010121212b0c0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0121212101012121212d01212d012d012121212d01020102525101010d0000000040404040404040404040404040404040404040404040404040000d0b0c0b0c0b0c0b0c0b0c0b0c0b0c0b0c0b0c0b0c0b0c02525b0c0b0c0d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 032:d01010121212121212121212d01025252510101010201012121212b1c1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0121212121010121210d012121212d010121212d01010102525251010d0000000575757575757575757575757575757575757575757575757570000d0b1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c12525b1c1b1c1d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 033:d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 034:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0aeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeae000000000000000000000000000000000000000000000000000000000000
-- 035:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d025252525d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d01010101025252525d0d0d0d0d0d0aeaeaeaeaee2e2e2e2e2aeaeae51e2e2e2aeaeaee2e2aeaeaeaeaeaeaeae000000000000000000000000000000000000000000000000000000000000
-- 036:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e000000000000000000000000000d025252525106a7a1010d0411060121212121212121212121212121012d0000404040404040404040404040404040404000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d010101010102010252525d0d0d0d0d0d0aeaeaeaeae5151e2e2e2aeaeaeaee2e251aeaee2e2d8d8d8aeaeaeaeaeae000000000000000000000000000000000000000000000000000000000000
-- 037:0000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e00000000000000000000000000000e0e0e01a1a1a3737378737e0e0e00000000000000000000000d025102525106b7b1010d01010d0d01212121212121212121212121212d0000465171717045427272727272727272704000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d092a210101020202010252525d0d0d0d0d0aeaee2e2aeaeae515151aeaeaeae5151aeaeae51d8d8d8d8d8aeaeaeaeae000000000000000000000000000000000000000000000000000000000000
-- 038:00000000000000040404040404040404040404040404000000000000000000000000000000e0e0e0e0e03737373737371a1ae0e000000000000000000000000000e01a1a838383f0f0f087f01a1ae0e0e0e00000000000000000d0101025101010103110d010d0d012121212121212d0d0d0d0d0121212d0000451515151041414141414141414141404000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d093a310102020202020252525d0d0d0d0d0ae51e2e2aeaeaeaeaeaeaeaeaeaeaeaeaeaeaed8fed8fed8fed8aeaeaeae000000000000000000000000000000000000000000000000000000000000
-- 039:0000040404040404c404d404173343531704c504e50404040404040000000000000000e0e0e01a373737f0f0f0f0f0f083831ae0e00000000000000000000000e0e08383838383f0f0f087f083831a3737e0e0e0e0e000000000d0101010251020101010d0d0d01212121212121212d0d0d0d0d0121212d0000451515114041414040414040414141404000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d012121010102020201010252525d0d0d0d0aeae5151aeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaefbeefbeefbaeaeaeaeae000000000000000000000000000000000000000000000000000000000000
-- 040:00000417171717045104510451515151510451045104171717170400000000000000e0e01a1a83f0f0f0f0f0f0f0e0e0f083831ae0e000000000000000000000e01a83838383f0f0e0e0e0e0838383f0f037373737e0e0000000d0102010101020201010d012121212121212121212d0d0d0d0d0121212d0000451511414271414042714270414141404040404040404040000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0121212101020101010101012d0d0d0d0aeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaefbeefbeefbaeaeaeaeae000000000000000000000000000000000000000000000000000000000000
-- 041:000004162636460451045104518b8b8b51045104510451f5b65104000000000000e0e01a8383f0e0e0f0f0f083e0e0e0f0f0838387e0e0000000000000000000e0e0838383f0e0e0e06767e0e08383f0f0f0f0f0f037e0e0e000d0d012d0d0d0d0d0d0d0d012121212121212121212d0d0d0d0d0121212d0000404040404041414041414140404040404442727272727040000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d01212121010101010121212d0d0d0d045454545454545454545454545454545454545c81010101010e845454545000000000000000000000000000000000000000000000000000000000000
-- 042:000004515151515151e451f45151515151b551d551515151515104000000e0e0e0e01a83f0f0e0e0e0f0838383e0e0e0e0f0f0f08737e0e0000000000000000067e08383e0e0e06767000067e0e08383f0f0f0f0f0f0e082e000d01212121212121012121212121212121212101212d0d0d0d0d0121212d0005757575757041414041414140427272704141414141414040000000000d0d0d0d0d0d0d0d0d0d0d0d0d012121212121212121212121212d0d0d0d070707070707070707070707070707070707070c81010101010e870707070000000000000000000000000000000000000000000000000000000000000
-- 043:0000040404045151515151515132425251515151515151c6d65104000000e0378237f0f0f0e0e067e0e0e08383e0e0e0e0e0f0f087f037e0e0e0e0e0e0e0000000e0f0f0e06767000000000067e0e08383f0f0f0f0f037f0e000d012121212121212121212121212d0d0d0d01212121212121212121212d0000000000000041414040404040414141404141414141414040000000000d0d0d0d0d0101010d0d0d0d012121212d0d012121212121212d0d0d0d0d0707070707070707070707090a0707070707070c9d9d9d9d9d9e970707070000000000000000000000000000000000000000000000000000000000000
-- 044:000004515651510404040404115151511104040404045151515104000000e0f0f0f0f0f083e0670067e0e083831ae0e0e0e0e0e0e0e0f037373737e0e0e0e00000e0e0f0e0e0e000000000000067e0e08383f0f0f0f0f0f0e000d012121212121212121212121212d0d0d0d01212121212121212121212d0000000000000041414272704272714141404141414141414040000000000d0d0d0d010101010101012121212d0d0d0d0d0d0121212d0d0d0d0d0d0d0707070707070707070707091a17070707070707070707070707070707070000000000000000000000000000000000000000000000000000000000000
-- 045:00000451515151048a8a8a04515151515104e604f6045132425204000000e0e0f0f0f08383e000000067e0e083831ae0e067676767e0e0e0f0f0f0373737e0e0e0e0e0f03737e0e0e0000000000067e0e0e0e0e0e0e0e0e0e000d01212d0d0d01212121212121212d0d0d0d01212121212121212121212d0000000000000041414141427141414141404141414141414040000000000d0d0d0d01010101010101012d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0707070707070707070707070707070707070707070707070707070707070000000000000000000000000000000000000000000000000000000000000
-- 046:00000404040404045151515151515151515151515104040404040400000067e0e0e0e0e0e0e00000000067e0e0838398e0e00000006767e0e0e0e0e0e0f03737e0e0e0f0f0f01a1a1ae000000000006767676767676767676700d01212d0d0d01212121212121212d0d0d0d01212121212121212121010d0000000000000041414141404141414141427141414141414040000000000d0d9d9d910101010101010d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0707070707070707070707070707070707070707070707070707070707070000000000000000000000000000000000000000000000000000000000000
-- 047:0000575757575704040404040404350404040404040457575757570000000067676767676767000000000067e0e08383e0e000000000006767676767e0e0f0f0373737f08383838383e000000000000000000000000000000000d01212d0d0d01212121212121212121212121212121212121212101010d0000000000000040404040404040404040404040404040404040000000000a0707070a2101010101010d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d7d7d7d7d7d7d7e7707070707070707070707070707070707090a0707070000000000000000000000000000000000000000000000000000000000000
-- 048:000000000000005757575757570404045757575757570000000000000000000000000000000000000000000067e0e0e0e0670000000000000000000067e0e0e0f0f0f08383838383e0e000000000000000000000000000000000d012121210121212121212121212121212121212121212121210101025d0000000000000575757575757575757575757575757575757570000000000a170707070a2d8d0101010d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d010101010101010e8707070707070707070707070707070707091a1707070000000000000000000000000000000000000000000000000000000000000
-- 049:000000000000000000000000005757570000000000000000000000000000000000000000000000000000000000676767670000000000000000000000006767e0e0e0e0e0e0e0e0e0e06700000000000000000000000000000000d012121212121212121210121212121212121212121012121210102525d0000000000000000000000000000000000000000000000000000000000000a07070707070c8d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d010101010101010e870707070707070707070707070707070707070707070000000000000000000000000000000000000000000000000000000000000
-- 050:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000676767676767676767670000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0000000000000000000000000000000000000000000000000000000000000a190a090a045d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d010101010101010e870707070707070707070707070707070707070707070000000000000000000000000000000000000000000000000000000000000
-- 051:d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0e0e0e0e0e0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 052:d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0e0e0e0e0e0e0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 053:d020201010101010101010101010252510d0601560d0d0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0101010101010d04110d010101212121212121212d0d0102510101010101010101010121210b0c01010101010101010101010d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 054:d020101010101010102010101010102510d0102010d0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e01010101010d01010d010101012121212121212d0d0251010101010101010101010121212b1c11010101010e0e0e0e0e010d0000000000000000000000000000000000000000000000000000000000000000000000000000004040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 055:d010121012101010102020101010251010d0102510e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e01010101010d01010d010101010121212121212d0d0101010101010101010101012121212121010101010e0e0070707e010d0000000000000000000000404040404040404040404000000000000000000000000000000040404171717041717040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 056:d012121212101010101010101010101010d0102525d0d0d08110101010d0e0e0e081e0e0e0e0e0e0e0e0101010d01010d0d0d0d0d0101212121212d0d01010101010101010101212121212121212101010100607101010e0e0d0000000000000000000000417171717171717041704000000000000000000000000000000041317515151175151171704000000000000000000000000000000000000000000000000000000000000000000000000000000000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 057:d0121212d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d02525d0d01010101010d0d0b0c0101010101010101006101010d01010d0d0d0d0d0101010121212d0e0e0e0e0e0101010101212121212e0e0e0e0e0e0e0e0e01010101007e0e0000000000000000000040451163626363646045604000000000000000000000000000000045151515151040e3d3d4c04040404040404000000000000000000000000000000000000000000000000000000000000000000000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 058:d01212121212101010101012d0d0d0d0d0b0c0d0d025d0d01010101010d0d0b1c11010101010101010e0101010d01010d0d0d0d0d0101010101012d0d0070707e0e0e0e0e0e0e0e0e0e0e00707070707070707101010101007d00000000000000000000417518494949494a4175104000000000000000000000000000000045151515151040fdede2e0417171717170400000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 059:d01212d01212121010101012d0d0d0d0d0b1c1d0d01212121012d0d0d0d0d0b0c010101010101010e007101010d01010d0d0d0d0d0102010101010d0d0101020070707b0c00707070707071010202010101010101010101012d00000000000000000000451518595959595a5515104000000000000000000000000000000040404040404040f2c2c2e175151515151040000000000000000000000000000e0e0e0e0e0e03737373737378237e0e0e0e0e0000000bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe000000000000000000000000000000000000000000000000000000000000
-- 060:d0d0d0d0d0d0d0d0d0d01212d0d0d01212101212d01212121212121212d0d0b1c1101010101010e007102010d0d01010d0d0d0d0d0102020101010d0d0101020201010b1c11010101010101010202020201010101010101012d00000000000000000000451518696969696a6515104000000000000000000000000000000041717171717170f2c2c2e0451515151510400000000000000000000000000e03737373737378383f0f0f0f0f9f037e082e0e0000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 061:d01212121212121012121212d0d0d01212121212d0d0d0d01212121212d0d0b0c01010101010e00710102010d010101010d0d0d0d0101010102531d0d010102020201010101010101010101010102020202010101010121212d0000000000000000000043242525151515151515104000000000000000000000000000000045151515151510fdede2e04515151515104000000000000000000000000e0e0838383838383838383f0f0f0f9f07737f037e0000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 062:d01212121212121212121212d0d0d01212121212d010121212d01212d0d0d0b1c110101010e0071010101010d0101212121010101010d010252510d0d010101020202010101010101010101010101010101010101012121212d0000000000000000000040404040435040404040404000000000000000000000000000000045151515151511f3f3f1d04515151515104000000000000000000000000e037838383e0e0e0e0838383f0f0f9f077f0f0f0e0000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 063:d01012d0d0d0d0d0d0d0d0d0d0d0d01212d0d010d0101212d0d0121210d0d0e0e0e0e0e0e007101010201010d0121212121212101010d010252510d0d0d9d9d9d9d9d9d8d8d8d8d8d9d9d9d9d9d9d9d9d9d9d9d9d9d8d8d8d8d00000000000000000005757575704040457575757570000000000000000000000000000000404040404040404040404040404043504040000000000000000000000e037f08383831ae0e0e0e0838383f0f9f077f0f0e0e0000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 064:d010101010d0101010d01212d0d0d01212d0d010d01010d0d0d012d0d0d0d00a0a0a0a0a0a1010102020101060121212121212121010d025252510d045707070707070c9d9d9d9e97090a070707070707070707070c9d9d9d9d00000000000000000000000000057575700000000000000000000000000000000000000005757575757575757575757575757040404570000000000000000000000e0f0f0f08383831ae0e0e0e0838383f9f077f0f0e067000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 065:d01010d010d0101010101212d0d0d01212d0d010101010d0d0d0125ad0d0d012121212121210101010101010d0121212121212121210d025252525d04570707070707070707070707091a170707070707070707070707070704500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005757570000000000000000000000e0e0f0f0f0f08383831a1a821a838383b98377f0e0e000000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 066:d01010d01010101010d010121212121212d0d0d0d0d0d0d0d0d01212d0d0d012121212121212121210101010d0121212121212121212d025252525d045707070707070707070707070707070707070707070707070707070704500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0f0f0f0f0f083838383fc99999999a9837783e06700000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 067:d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d045454545454545454545454545454545704545454545454545454545454500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e077e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00000000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 068:454545454545454545454545704545454545454545454545454545454545454545454545d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0454545454545454545454545457045454545454545454545454545454545d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0d0d0d0d0d0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000e0e0e077e0e0e0000000000000000000000000000000000000000000000000000000e0b3e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 069:457070707070707070707070707070707070707070707070707070707045457070707070d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d02525d0457070707070707070707070707070707070707070707070707070707045d0d0d02525d0d0d0d0121212121212121212121212d010101010101010d0d041101212121212e0101010b0c0e01010101010101010101010b0c020d0000000e0821af037e0e0000000000000000000000000000000000000000000e0e0e0e0e0e0e0cee0e0e0e0e0e0e0e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 070:457070707070707070707070707070707070707070707070707070707045457070707070c81010101010101010101010e012121212121006101025d0457070707070707070707070707070707070e0e0e0e0e0e0e0e0e0e0e045d0d0d02525d0d0d01010121212121212121210121260101010101010d0d0d010101212121212e0e01010b1c1e0e010101010b0c010101010b1c120d00000e0e0b983f0e0e067000000000000000000000000000000000000000000e03737823737e0704747474747474747e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 071:457070707070707070707070707070707070707070707070707070707045457070707070c81010101010101010101010e0121212121212e0101010d045707070707070707070707070707070e0e0e0b0c0b0c0b0c041b0c0e0e0d0d0d02525d0d01010101012121212121210101012e0e0e0e0e0101041d0d01212121212121212e0e010101007e010101010b1c110102020102020d00000e01ab983e0e0670000000000000000e0e0e0e0e0000000000000000000e0e0f0f9f0e04770707070707090a07047e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 072:45707070707070707070707070707070707070d1e1e1e1e1f170707070454590a0707070c81010101010201010101010e01012d0d0d0d0e0101010d0d0d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7e01010b1c1b1c1b1c110b1c1d0e0d0b0c02525b0c010101010101212121292a21010e0e0e0e0e0e0e01010d0d0121212121212121212e0e0101010e01010e0e0e0e010102020202020d00000e083b983e06700000000000000e0e0e0376537e0e0000000000000000067e0e02a70477070707070707091a1707047e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 073:4570707070c7d7d7e770707070707070707070d2e2e2e2e2f270707070454591a1707070c81012101010102020101010e0121212121212e0e0e0e0d0d0b0c010b0c0b0c0b0c0b0c0b0c0b0c0e0e010b0c012b0c01010b0c0d0d0d0b1c12510b1c110101010101010101093a310e0e0e0e0e0e0e0e0e010d0d012121212121212121212e0b0c010e0101006070707e0101020202020d00000e083b983e000000000000000e0e01a37f0f0f037e0e00000000000000000e04770707070707070707070707070707047e0e00000000000000000000000000000000000000000000000000000000000000000000000000000
-- 074:4570707070c8d041e870707070707070707070d2e2e2e2e2f27070707045457070707070c81012121210102020201010e0121212121210060707e0d0d0b1c110b1c1b1c1b1c1b1c1b1c1b1c1e0e0e0b1c112b1c11010b1c112d0d0101010251010e0e0e0e010101010101010e0e0e0e0e0e0e0e0e0e0e0d0d012121212121212121210e0b1c110e01010e010101007e010102020d0d00000e083b983e0e0000000e0e0e0821a837777f0f0f037e00000000000000000e0707070707070707070707070e0e0e0707047e0e000000000000000000000000000000000000000000000000000000000000000000000000000
-- 075:4570707070c81212e870707090a07070707070d2e2e2e2e2f27070707070707070707070c81212121212102020201010e0e0e0e0e0e0e0e01010e0d0d0b0c010b0c06171b0c0b0c01212b0c0070ae0e0121212b0c060601212d0d01010101010e0d01212e0101010101010e0e0e0e0e0e0e0e0e0e0e0e0d0d012121212121212121010e0e0e01007e0e0e010101010e0606060d0d0d00000e083b9831ae0e0e0e0e01a1ab983f0f07777f0f0f0e00000000000000000e0e0707090a070707070e0e0e03737e070707047e000000000000000000000000000000000000000000000000000000000000000000000000000
-- 076:4570707070c9d9d9e970707091a17070707070d2e2e2e2e2f27070707045457070707070c8101212121210101010101007070706070707071012e0d0d0b1c110b1c16272b1c1b1c11212b1c1101207e0e01212b1c110121212d0d01012101012d0121210e010101010b0c0e0e0e0e0e0e0e081e0e0e0e0d0d0121212121212121010101010061010d00707101010e0e010101010d0d00000e083b983833737371a1a8383b983f0f0f0777777f0e0000000000000000067e0e00c91a170707070e03737f0f0e0707070e0e000000000000000000000000000000000000000000000000000000000000000000000000000
-- 077:45707070707070707070707070707070807070d3e3e3e3e3f37070707045457070707070c81010121212101010101010101010e0101010121212e0d0d01010101031101010106012121212101210100a061012121010101212d0d012121212e0d01210100610101010b1c1e0e041106010101010101010d0d0d0d0d0d0d0d0101010101010e01010d010101010e0e0101010101010d00000e083b98383f0f0f0838383833af0f0f0f0f0f07777e000000000000000000067e0f9e0e0e0e0e07047e0f0f0f0477070e0e06700000000000000000000000000000000000000000000000000000000000000000000000000
-- 078:457070707070707070707070707070707070707070707070707070707045457070707070c81010101010101010101010e0e0e0e0101012121212e0d0d0b0c010101010101010b0c01212b0c012121212e01210101010101012d0d012121212e0d0d01210e0101010101010e0e010106010101010252525252525252525102510101010e0e0e02010d01010e0e0e010101010101010d00000e083b98383f0f0f0f0f0f0f03bf0f0f0f0f0f083e0e000000000000000000000e0f7f8e06767e0e07047e0e0e0e070e0e0670000000000000000000000000000000000000000000000000000000000000000000000000000
-- 079:457070707070707070707070707070707070707070707070707070707045457070707070c81010101010101010101010e0101006101012121212e0d0d0b1c112101010101010b1c11212b1c1121212e0e03040404040404050d0d0121212120ae0d0d012e010101010101007e010106010101010251025d0d025252525251010101010e007072010d01010e0101010101010101010d00000e083b98383f0f0f0f0f0f0f0f9f0f0f0f0f08383e00000000000000000000000e0e0f9e0e0e0e0e0e07047477547e0e067000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 080:457070707070707070708070707070707070707070707070707070707045457070707070c81010102010101010101010e01010e0e0e0e0e0e0e0e0d0d0101012101212121212126012121210121212e00a2020101010251010d0d012121212120ae0e0e0e010101010101010e0e0e06010101010101010d0d0d0d0d0d0d0d010101010e020201010d01010e0201010101010101010d00000e0e0fc999999fa9797979797a7f0f08383838383e0e0000000000000000000e0e037f937474747474770707070e0e06700000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 081:457070707070707070707070707070707070707070707070707070707045457070707070c81010102020101010101010e01010e007070707074107d0d0b0c012b0c012b0c012b0c01212b0c0101210e0122020101025101010d0d01212121212120a0a0a0a101010101010100707e0e0e010101010b0c0d0d012121212121220201010e020202010101010e0202020102510101010d0000067e0e0e070702a7070f0f0f0f0f0f0838383838383e0000000000000000000e037f0f9707070707070e0e070e0e0670000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 082:457070707070707070707070707070707070707070707080707070707045457070707070c81010102020202010101010e06060e010102020101010d0d0b1c112b1c112b1c112b1c16060b1c11010e0e0121210b0c02525b0c0d0d0121212121212121212121010101010102525250707e0e0e01010b1c1d0d012121212121212202010e0e0b0c010d01010e0b0c020101025101010d00000006767e0707070707070f0f0f08383838383838383e0000000000000000000e0f0f0f7f870707070e0e0e0e0e067000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 083:457070707070707070707070707070707070707070707070707070707045457070707070c81010102020202010101010e010101010101010101010d0d0d01212121212121212101010101010e0e0e00a121212b1c12525b1c1d0d01212121212121212121212101010102510252525100707e0e0e0e0e0e0d01212121212121212202020e0b1c110d01010e0b1c120202525101010d00000000000e0707070707070e0e0e08383838383838383e0000000000000000000e0e0e0f0f9f07070e0e06767676700000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 084:454545454545454545454545454545454570454545454545454545454545454545454545d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0e0d0d0d0d0d0d0d0d0d0d0d0d0d0e0e0e0e0e0e0e0d0d0d0d025d0d0d0d0d00000000000e0b2e0e0e0e0e0e067e0e0e0e0e0e083e0e0e00000000000000000006767e0e0e0e0e0e067670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 085:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0e0e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d000000000000000000000000000000000e0e0e0e083e0e067000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 086:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0101010101010101010121212121212101010101010101012121212d0d0101010101212121212d0d0d0d0d0d0121210252510d0d05a12d0d0d0d0d00a0ae0e0e010101010101010101010101010202020d010252510d012d000000000000000000000000000000000e03737378337e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 087:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d04110e0e0e0e010101010101212121212121010d0d0d0d0d010121212d0d0101010d0d0d012121212d0d0d0d0d0121210102510d0d0121212d0d0d0d012120a0ae0e0101010101010e0e0e0e0e010102020d010102510d012d000000000000000000000000000000000e0f0f0f0f0f0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 088:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d01010e0e0e0e0e01010101010101212121212d0d0121212d0d0101212d0d0101212d0d0d012121212d0d0d0d01212121025101010d0d0121212d0d0d0121212120ae0e01010101010e0e081e0e0e0101020d010251010d012d0000000000000000000000000000000e0e0f0f0f0f0f0e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 089:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0d060d0d0d0d0d0d01212d01212121212d0101212d0d012121212d0121212d0d0d0d0d012121212101010101010d0d0121212d0d012121212120ae0e0e0101010e00a120ae0e0101010d010101010d012d0000000000000e0e0e0e0e0e0e0e0e0e0377777777777e067000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 090:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0101010b0c012d0d012d0d0121212d0d0101212d0d0d0d0d0d01212d0d0d0101212121212d0d012121210101010d0d01212d0d01212121212100707e0101010e0e012120ae0101010d0d01010d0d012d000000000e0e0e0e0e037373737373737f0f0f0f0f0f0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 091:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0101010b1c11212d01212d0d0d012d010101012d0d0d0d0d0d0d012d0d0101010121212d0d0d0d0d0d0d0d0d0d0d0d01212d0d0d0d0d0d0d0101010e01010101006101212e010101010101010101212d000000000e0e082e037f0f077f0f0f0f0f0f0f0f0f08382e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 092:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e010101212121212d010121212d0121010101010d0d0d0d01012121212d0121010101212d0d0d012121212d0121210101010d0d025101010d0101010e0e0101010e0121212e010101010101010101212d000000000e037f037f0f0f07777f0f0f0f0f083838383b9e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 093:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e012121212121212d0101010121212d0d0d0d0d0d0d0d0d01010121212121212101010d0d0d01212121212121210102525252525252525101010101007e0e0e0e0e0101210e010101010101010101212d000000000e0f0f0f0f0f0f0f0b7979797979999999999a9e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 094:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e012121212121212d01010101212d0d0121212d0d0d0d01212121212121212d0d010d0d010d0d012121212d0121025102525d0d02525101010101010100707070707101010e010102010101010101212d000000000e06e7ef0f0f0f0f0f97777f0838383838383e067000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 095:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e030404040404050d010101010d0d01212121212d0d0d0d0d030404040404050d0d0d0101010d012d01212d0d0d0d0101010d0d025101010d01010101010201010101010e0e010102020101010121212d000000000e06f7f9797979797a7f07783838383838383e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 096:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e081e0e0e0311010e012121212121212d01010101060121212121212d0d01212d0d0d01212121212d0d010101010d012d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d012121010201010101010e0b0c010202020101212b0c0d000000000e0f0f0f0f0f0f0f0f08383838383838383e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 097:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d01010101010101010e012121212121212d0101010d0d0121212121212d0d012121212d012d0121212d01010d0d0d0d012121212121212126a7a12d0d05a12121212d0121212122010101010e0e0b1c110102020121212b1c1d000000000e0e0e0f0f0f0f0e083838383838383e0e0e06700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 098:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d010101010101010100610121212121212d0101010d012121212121212d0d0121212121212d0d0d012121210d0d0d0d0d0d01212121212316b7b12d0d01212121212d0121212121212101010e0b0c0b0c0b0c0b0c0b0c0b0c0d0000000006767e0e0e0e0e0e0e0e0e0e0e0e0e0e067670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 099:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d010101010101010e0e0d012121212d0d0b0c010d0d0121212121212121212121212121212d0d0d0d0d01212d0d0d0121212121212121210101012d0d01212121212d0121212121212121210e0b1c1b1c1b1c1b1c1b1c1b1c1d0000000000000676767676767676767676767676700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 100:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d060b1c110d01212121212121212d0d01212121212d0d0d0d0d0d012121212121212d0121212121010101212d0d0121212121212121212121212121212e0b0c0b0c0b0c0b0c0b0c0b0c0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 101:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0b1c1b1c1b1c1b1c1b1c1b1c1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <MAP2>
-- 000:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebed8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8d8bebebeaeaeaeaebeaeaeaeaeaeaeaebeaeaeaeaeaebeaeaeaeaeaebebebe9e9e9e8e8e8e8e9e8e8e8e8e8e8e8e9e8e8e8e8e8e9e8e8e8e8e8e9e9e9e000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000000000000000000000000000000000000000000000000000000000
-- 001:beaeaebebeaeaebebeaeaeaebeaeaebebeaeaeaebebeaeaebebeaeaeaebed8d8d8eed8d8d8eed8d8d8eed8d8d8eed8d8d8eed8d8d8eed8d8d8eed8d8bebeaeaeaeaeaeaebeaebebebeaebeaeaebebebeaeaebeaeaeaeaeaebebe9e9e8e8e8e8e8e8e9e8e9e9e9e8e9e8e8e9e9e9e8e8e9e8e8e8e8e8e9e9e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000000000000000000000000000000000000000000000000000000000
-- 002:beaeaebebebeaebebebeaeaeaebebeaeaeaeaebebebeaebebebeaeaeaebefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbbeaebebebeaeaebeaeaeaeaeaeaeaebeaeaeaeaeaebeaeaeaebebebeaebe9e8e9e9e9e8e8e9e8e8e8e8e8e8e8e9e8e8e8e8e8e9e8e8e8e9e9e9e8e9e000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000000000000000000000000000000000000000000000000000e2e2000000000000000000000000000000000000000000000000000000000000
-- 003:bebeaeaebebebeaebe0000bebe0000bebebe0000beaebebebeaeaeaebebefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeaeaebeaebebebebebebeaeaeaebeaeaeaeaebebebebebebeaebeaeaeae8e8e8e9e8e9e9e9e9e9e9e8e8e8e9e8e8e8e8e9e9e9e9e9e9e8e9e8e8e8e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e20000000000000000000000000000000000000000000000000000e2e2000000000000000000000000000000000000000000000000000000000000
-- 004:beaebeaeaebebebeae007d8d9dadbdcdddedec00aebebebeaeaeaebeaebefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaebeaebeaeaeaebebeaeaebebebebebebebebeaeaebebeaeaeaebeaebeae8e9e8e9e8e8e8e9e9e8e8e9e9e9e9e9e9e9e9e8e8e9e9e8e8e8e9e8e9e8e0000000000000000007a8a9aaabaca7b8b9babbbcb000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2000000000000000000000000000000000000000000000000000000000000
-- 005:beaeaebeaeaebebeaebe000000000000000000beaebebeaeaeaebeaeaebefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaeeefbfbaebeaeaeaebeaeaeaeaeaeaeaebebebebeaeaeaeaeaeaeaebeaeaeaebeae8e9e8e8e8e9e8e8e8e8e8e8e8e9e9e9e9e8e8e8e8e8e8e8e9e8e8e8e9e8e000000000000007a8a9aaabaca000000007b8b9babbbcb00000000000000000000000000000000000000000000000000000000000000000000000000e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2000000000000000000000000000000000000000000000000000000000000
-- 006:bebeaeaebeaeaebeaebe000000002b00000000beaebeaeaeaebeaeaebebe121212121212121212121212121212121212121212121212121212121212aebeaebeaeaeaebebeaeaebebebebebebebebeaeaebebeaeaeaebeaebeae8e9e8e9e8e8e8e9e9e8e8e9e9e9e9e9e9e9e9e8e8e9e9e8e8e8e9e8e9e8e00000000000000007a8a9aaabaca00007b8b9babbbcb0000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2000000000000000000000000000000000000e2e20000e2e2000000000000000000000000000000000000000000000000000000000000
-- 007:bebebeaebebebebebe000000001c003c00000000bebebebebebebeaebebe121212121212121212121212121212121212121212121212121212121212aeaeaebeaebebebebebebeaeaeaebeaeaeaeaebebebebebebeaebeaeaeae8e8e8e9e8e9e9e9e9e9e9e8e8e8e9e8e8e8e8e9e9e9e9e9e9e8e9e8e8e8e000000007a8a9aaabacadc7c8c9cdcdcacbcccdc7b8b9babbbcb00000000000000000000000000000000000000000000000000000000000000000000e2e20000e2e2000000000000000000000000000000000000e2e20000e2e2000000000000000000000000000000000000000000000000000000000000
-- 008:bebeaebebebebebebe0000000d002d004d000000bebebebebebeaebebebe121212121212121212121212121212121212121212121212121212121212beaebebebeaeaebeaeaeaeaeaeaeaebeaeaeaeaeaebeaeaeaebebebeaebe9e8e9e9e9e8e8e9e8e8e8e8e8e8e8e9e8e8e8e8e8e9e8e8e8e9e9e9e8e9e00000000000000007a8a9aaabaca00007b8b9babbbcb0000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e20000e2e2000000000000000000000000000000000000000000000000000000000000
-- 009:bebeaeaebeaeaebeaebe0000001e003e000000beaebeaeaeaebeaeaebebe121212121212121212121212121212121212121212121212121212121212bebeaeaeaeaeaeaebeaebebebeaebeaeaebebebeaeaebeaeaeaeaeaebebe9e9e8e8e8e8e8e8e9e8e9e9e9e8e9e8e8e9e9e9e8e8e9e8e8e8e8e8e9e9e000000000000007a8a9aaabaca000000007b8b9babbbcb00000000000000000000000000000000000000000000000000000000000000000000000000e2e20000e2e2000000000000000000000000000000000000e2e20000e2e2000000000000000000000000000000000000000000000000000000000000
-- 010:beaeaebeaeaebebeaebe000000002f00000000beaebebeaeaeaebeaeaebe121212121212121212121212121212121212121212121212121212121212bebebeaeaeaeaebeaeaeaeaeaeaeaebeaeaeaeaeaebeaeaeaeaeaebebebe9e9e9e8e8e8e8e9e8e8e8e8e8e8e8e9e8e8e8e8e8e9e8e8e8e8e8e9e9e9e0000000000000000007a8a9aaabaca7b8b9babbbcb000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2000000000000000000000000000000000000e2e20000e2e2000000000000000000000000000000000000000000000000000000000000
-- 011:beaebeaeaebebebeaebe000000000000000000beaebebebeaeaeaebeaebe121212121212121212121212121212121212121212121212121212121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2000000000000000000000000000000000000000000000000000000000000
-- 012:bebeaeaebebebeaeae00be8f9fafbfcfdfefff00aeaebebebeaeaeaebebe121212121212121212121212121212121212121212121212121212121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000e2e2000000000000000000000000000000000000000000000000000000000000
-- 013:beaeaebebebeaeaebe0000bebe0000bebebe0000beaeaebebebeaeaeaebe121212121212121212121212121212121212121212121212121212121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e20000000000000000000000000000000000000000000000000000e2e2000000000000000000000000000000000000000000000000000000000000
-- 014:beaebebebeaeaebebebeaeaeaebebeaeaeaeaebebebeaeaebebebeaeaebe121212121212121212121212121212121212121212121212121212121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e20000000000000000000000000000000000000000000000000000e2e2000000000000000000000000000000000000000000000000000000000000
-- 015:beaebebeaeaeaebebeaeaeaebeaeaebebeaeaeaebebeaeaeaebebeaeaebe121212121212121212121212121212121212121212121212121212121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000000000000000000000000000000000000000000000000000000000
-- 016:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe121212121212121212121212121212121212121212121212121212121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2000000000000000000000000000000000000000000000000000000000000
-- 017:d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0e0fdfdfde0e0e0e0e0e0e0e0e0e0e0fdfdfde0e0fde0e0e0e0e0fde0e0000000000000000000000000000000000000000000000000000000000000
-- 018:d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000d0b0c0b0c0b0c010106010101010101010b0c0b0c0b0c0b0c0b0c0b0c0d0e0e0e0fde0e0e0e0e0e0e0e0e0e0e0e0e0e0fde0e0fde004e004e0e0fde0000000000000000000000000000000000000000000000000000000000000
-- 019:d012b0c012d0d0d0d012d01010637310d0b0c068781010101010101010d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d01010101010d012d0121212d012121212121010101010101210101010d0000000000000000000000000000000000000000000000000000000000000d0b1c1b1c1b1c1101010e0e0e0e0e0e010b1c1b1c1b1c1b1c1b1c1b1c1d0e0e0e0fde0e0e00404e00404e0e0e0e0e0e0fde0e0fde004e00404e0fdfd000000000000000000000000000000000000000000000000000000000000
-- 020:d012b1c1121212121212d01010647410d0b1c16979101010101025252525000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004040400000000000000000000000000252525102510d012121212121212d012d0d0d0d0101010121212101010d0000000040404040404040404040404040404040404040404040404040000d06060101010202020e02310b0c0b0c0e010601041101020202020b0c0d0e0e0e0fde0e0e0e0040404040404e0fde0e0e0e0e0fde00404040404e0e0000000000000000000000000000000000000000000000000000000000000
-- 021:d01212121212121212d0d01010101010d0101010101010102525102525d0000000000000000000000404040000000000000000000000000000000000000000000000000000000004040404130404040400000000000000000000d02525251010d0d0d0d0d0d0d0d0d010101010d0d0d0d0d012d0d0d0d0d0000000041717171717171717171717171717171704131717171717040000d0b0c01020202020e0101010b1c1b1c112e0601010101010202020b1c1d0e0e0e0fde0e0e0e00404e0040404e0e0e0e0fde0e0e0e0040404e004e0e0000000000000000000000000000000000000000000000000000000000000
-- 022:d0121212121210102838d0d0101010d0d010108898104e5e1010311010d0000000000000000000040423040404040404000000000000000000000000000000000000000000000004171717511717170400000000000000000000d0d0d060d0d0d041121212121212d0d0d0d01010d01010d012d0121212d0000000040e4c515151510451515151515151515104515151515151040000d0b1c110102020e0b0c01010101010121212e01010101010102020b0c0d0e0e0e0fde0e0e0e0e004e004e0e0e0e0e0e0fde0e0fde0e0e004e004e0e0000000000000000000000000000000000000000000000000000000000000
-- 023:d0121212d01010102939fed0d010d0d0b0c0108999fe4f5f1010101010d0000000000000000000041751171717171704000000000000000000000000000000000000000000000004115151515151b40400000000000000000000d01212121212d012121212121212101010d01010d01012d012d0121212d0000000040f2e515151510451515104040451510404515151515151040000d0b0c010102020e0b1c1b0c0101010101212e01010101212101020b1c1d0e0e0fdfdfde0e0e0e0e0e0e0e0e0e0e0e0fdfdfde0e0e0e0e0e0e0e0e0e0000000000000000000000000000000000000000000000000000000000000
-- 024:d01212d0d010101010101010101010d0b1c11020101010101010101010d0000000000000000000040151515151515104000000000000000000000000000000000000000000000004515151515151510400000000000000000000d01212121212d012121212121212121210d0d010d01212121212121212d0000000040f2e040404040404040404171751511704040404045104040000d0b1c112101010e0b0c0b1c1b0c010101010061010121212121010b0c0d0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0000000000000000000000000000000000000000000000000000000000000
-- 025:d0d0d0d0d0d01010105c6c1010daea10a8b82020104858104a5a101010d0000000000000000000040251515151515104000000000000000000000000000000000000000000000004515132425251510400000000000000000000d01212121212d0121210d0d0d010101010d01010d012d0d0d0d0d0d0d0d0000000040f2e041717171717171704515151515104041717175117040000d0b0c012121010e0b1c16171b1c120101010e01012121212121210b1c1d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 026:d010101010d0d010105d6d1010dbebfea9b92010104959fe4b5b101010d0000000000000000000040351515151512104000000000000000000000000000000000000000000000004515151515151510400000000000000000000d03040404050d0101212d010d0d0121210d01010d01212121212121212d0000000040f2e045151515151515104515151515117170e3d3d3d4c040000d0b1c112121210e010fe6272312020101010e010121212121212106060d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 027:d01008181010d01010b0c0101010101010101010101010101010101012d0000000000000000000045151515151512204000000000000000000000000000000000000000000000004515151515151510400000000000000000000d01010101010d0d01212d0121212121212d01012d01212101012121010d0000000040f2e045151045151040404040404040404040fdedede2e040000d0b0c012121212e010101010101010102020e01010121212121010b0c0d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 028:d0100919fe10101010b1c1103040404040405010100a1a101010101212d0000000000000000000040404040404040404000000000000000000000000000000000000000000000004040404350404040400000000000000000000d01010101010d0101212d01212d0d0d0d0d0d012d030404040404050d0d0000000040f2e045151045151171717171717171717040fde2cde2e040000d0b1c11212121207e010b0c0b0c0b0c020e0071010101212101010b1c1d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 029:d03110101010d0d0d0d0d0d01010251010102020100b1b101010101212d0000000000000000000575757575757575757000000000000000000000000000000000000000000000057575704040457575700000000000000000000d01210101010d0121212d01212d0121212d01212d01010102510101010d0000000040f2e045151045151515151045151515151040fdedede2e040000d0b0c0121212121207e0b1c1b1c1b1c1e0b0c01010101010251010b0c0d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 030:d010101010101212121212d0d010102531101020201010101010121212d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000057575700000000000000000000000000d0121210101012121210d01212d012d012d01212d01020101025311010d0000000041f1d175151045151515151045151512351041f3f3f3f1d040000d0b1c112121212121207e0e0e0e0e0e007b1c11010101025101010b1c1d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 031:d01010101212121012121212d01025251010101020201010121212b0c0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0121212101012121212d01212d012d012121212d01020102525101010d0000000040404040404040404040404040404040404040404040404040000d0b0c0b0c0b0c0b0c0b0c0b0c0b0c0b0c0b0c0b0c0b0c02525b0c0b0c0d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 032:d01010121212121212121212d01025252510101010201012121212b1c1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0121212121010121210d012121212d010121212d01010102525251010d0000000575757575757575757575757575757575757575757575757570000d0b1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c12525b1c1b1c1d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 033:d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0838383838383838383838383838383838383838383838383838383838383000000000000000000000000000000000000000000000000000000000000
-- 034:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0aeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeae000000000000000000000000000000000000000000000000000000000000
-- 035:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d025252525d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d01010101025252525d0d0d0d0d0d0aeaeaeaeaee2e2e2e2e2aeaeae51e2e2e2aeaeaee2e2aeaeaeaeaeaeaeae000000000000000000000000000000000000000000000000000000000000
-- 036:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e000000000000000000000000000d0252525251061711010d0411060121212121212121212121212121012d0000404040404040404040404040404040404000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d010101010102010252525d0d0d0d0d0d0aeaeaeaeae5151e2e2e2aeaeaeaee2e251aeaee2e2d8d8d8aeaeaeaeaeae000000000000000000000000000000000000000000000000000000000000
-- 037:0000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e00000000000000000000000000000e0e0e03737373737378737e0e0e00000000000000000000000d0251025251062721010d01010d0d01212121212121212121212121212d0000465171717045427272727272727272704000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d092a210101020202010252525d0d0d0d0d0aeaee2e2aeaeae515151aeaeaeae5151aeaeae51d8d8d8d8d8aeaeaeaeae000000000000000000000000000000000000000000000000000000000000
-- 038:00000000000000040404040404040404040404040404000000000000000000000000000000e0e0e0e0e03737373737373737e0e000000000000000000000000000e03737838383f0f0f087f03737e0e0e0e00000000000000000d010102510fe10103110d010d0d012121212121212d0d0d0d0d0121212d0000451515151041414141414141414141404000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d093a310102020202020252525d0d0d0d0d0ae51e2e2aeaeaeaeaeaeaeaeaeaeaeaeaeaeaed8eed8eed8eed8aeaeaeae000000000000000000000000000000000000000000000000000000000000
-- 039:0000040404040404c404d404173343531704c504e50404040404040000000000000000e0e0e037373737f0f0f0f0f0f0838337e0e00000000000000000000000e0e08383838383f0f0f087f08383373737e0e0e0e0e000000000d0101010251020101010d0d0d01212121212121212d0d0d0d0d0121212d0000451515114041414040414040414141404000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d012121010102020201010252525d0d0d0d0aeae5151aeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaefbeefbeefbaeaeaeaeae000000000000000000000000000000000000000000000000000000000000
-- 040:00000417171717045104510451515151510451045104171717170400000000000000e0e0373783f0f0f0f0f0f0f0e0e0f0838337e0e000000000000000000000e03783838383f0f0e0e0e0e0838383f0f037373737e0e0000000d0102010101020201010d012121212121212121212d0d0d0d0d0121212d0000451511414271414042714270414141404040404040404040000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0121212101020101010101012d0d0d0d0aeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaefbeefbeefbaeaeaeaeae000000000000000000000000000000000000000000000000000000000000
-- 041:000004162636460451045104516b6b6b51045104510451f5b65104000000000000e0e0378383f0e0e0f0f0f083e0e0e0f0f0838387e0e0000000000000000000e0e0838383f0e0e0e00000e0e08383f0f0f0f0f0f037e0e0e000d0d012d0d0d0d0d0d0d0d012121212121212121212d0d0d0d0d0121212d0000404040404041414041414140404040404442727272727040000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d01212121010101010121212d0d0d0d045454545454545454545454545454545454545c81010101010e845454545000000000000000000000000000000000000000000000000000000000000
-- 042:000004515151515151e451f45151515151b551d551515151515104000000e0e0e0e03783f0f0e0e0e0f0838383e0e0e0e0f0f0f08737e0e0000000000000000000e08383e0e0e00000000000e0e08383f0f0f0f0f0f0e082e000d01212121212121012121212121212121212101212d0d0d0d0d0121212d0005757575757041414041414140427272704141414141414040000000000d0d0d0d0d0d0d0d0d0d0d0d0d012121212121212121212121212d0d0d0d070707070707070707070707070707070707070c81010101010e870707070000000000000000000000000000000000000000000000000000000000000
-- 043:0000040404045151515151515132425251515151515151c6d65104000000e0378237f0f0f0e0e000e0e0e08383e0e0e0e0e0f0f087f037e0e0e0e0e0e0e0000000e0f0f0e00000000000000000e0e08383f0f0f0f0f037f0e000d012121212121212121212121212d0d0d0d01212121212121212121212d0000000000000041414040404040414141404141414141414040000000000d0d0d0d0d0101010d0d0d0d012121212d0d012121212121212d0d0d0d0d0707070707070707070707090a0707070707070c9d9d9d9d9d9e970707070000000000000000000000000000000000000000000000000000000000000
-- 044:000004515651510404040404115151511104040404045151515104000000e0f0f0f0f0f083e0000000e0e0838337e0e0e0e0e0e0e0e0f037373737e0e0e0e00000e0e0f0e0e0e000000000000000e0e08383f0f0f0f0f0f0e000d012121212121212121212121212d0d0d0d01212121212121212121212d0000000000000041414272704272714141404141414141414040000000000d0d0d0d010101010101012121212d0d0d0d0d0d0121212d0d0d0d0d0d0d0707070707070707070707091a17070707070707070707070707070707070000000000000000000000000000000000000000000000000000000000000
-- 045:00000451515151046a6a6a04515151515104e604f6045132425204000000e0e0f0f0f08383e000000000e0e0838337e0e000000000e0e0e0f0f0f0373737e0e0e0e0e0f03737e0e0e0000000000000e0e0e0e0e0e0e0e0e0e000d01212d0d0d01212121212121212d0d0d0d01212121212121212121212d0000000000000041414141427141414141404141414141414040000000000d0d0d0d01010101010101012d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0707070707070707070707070707070707070707070707070707070707070000000000000000000000000000000000000000000000000000000000000
-- 046:00000404040404045151515151515151515151515104040404040400000000e0e0e0e0e0e0e00000000000e0e0838365e0e00000000000e0e0e0e0e0e0f03737e0e0e0f0f0f0373737e000000000000000000000000000000000d01212d0d0d01212121212121212d0d0d0d01212121212121212121010d0000000000000041414141404141414141427141414141414040000000000d0d9d9d910101010101010d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0707070707070707070707070707070707070707070707070707070707070000000000000000000000000000000000000000000000000000000000000
-- 047:0000575757575704040404040404350404040404040457575757570000000000000000000000000000000000e0e08383e0e000000000000000000000e0e0f0f0373737f08383838383e000000000000000000000000000000000d01212d0d0d01212121212121212121212121212121212121212101010d0000000000000040404040404040404040404040404040404040000000000a0707070a2101010101010d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d7d7d7d7d7d7d7e7707070707070707070707070707070707090a0707070000000000000000000000000000000000000000000000000000000000000
-- 048:000000000000005757575757570404045757575757570000000000000000000000000000000000000000000000e0e0e0e0000000000000000000000000e0e0e0f0f0f08383838383e0e000000000000000000000000000000000d012121210121212121212121212121212121212121212121210101025d0000000000000575757575757575757575757575757575757570000000000a170707070a2d8d0101010d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d010101010101010e8707070707070707070707070707070707091a1707070000000000000000000000000000000000000000000000000000000000000
-- 049:000000000000000000000000005757570000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e00000000000000000000000000000000000d012121212121212121210121212121212121212121012121210102525d0000000000000000000000000000000000000000000000000000000000000a07070707070c8d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d010101010101010e870707070707070707070707070707070707070707070000000000000000000000000000000000000000000000000000000000000
-- 050:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0000000000000000000000000000000000000000000000000000000000000a190a090a045d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d010101010101010e870707070707070707070707070707070707070707070000000000000000000000000000000000000000000000000000000000000
-- 051:d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0e0e0e0e0e0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 052:d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0e0e0e0e0e0e0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 053:d020201010101010101010101010252510d0601560d0d0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0101010101010d04110d010101212121212121212d0d0102510101010101010101010121210b0c01010101010101010101010d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 054:d020101010101010102010101010102510d0102010d0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e01010101010d01010d010101012121212121212d0d0251010101010101010101010121212b1c11010101010e0e0e0e0e010d0000000000000000000000000000000000000000000000000000000000000000000000000000004040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 055:d010121012101010102020101010251010d0102510e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e01010101010d01010d010101010121212121212d0d0101010101010101010101012121212121010101010e0e0070707e010d0000000000000000000000404040404040404040404000000000000000000000000000000040404171717041717040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 056:d012121212101010101010101010101010d0102525d0d0d08110101010d0e0e0e081e0e0e0e0e0e0e0e0101010d01010d0d0d0d0d0101212121212d0d01010101010101010101212121212121212101010100607101010e0e0d0000000000000000000000417171717171717041704000000000000000000000000000000041317515151175151171704000000000000000000000000000000000000000000000000000000000000000000000000000000000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 057:d0121212d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d02525d0d01010101010d0d0b0c0101010101010101006101010d01010d0d0d0d0d0101010121212d0e0e0e0e0e0101010101212121212e0e0e0e0e0e0e0e0e01010101007e0e0000000000000000000040451163626363646045604000000000000000000000000000000045151515151040e3d3d4c04040404040404000000000000000000000000000000000000000000000000000000000000000000000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 058:d01212121212121212121212d0d0d0d0d0b0c0d0d025d0d01010101010d0d0b1c11010101010101010e0101010d01010d0d0d0d0d0101010101012d0d0070707e0e0e0e0e0e0e0e0e0e0e00707070707070707101010101007d00000000000000000000417518494949494a4175104000000000000000000000000000000045151515151040fdede2e0417171717170400000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0000000040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000
-- 059:d01212d01212121212121212d0d0d0d0d0b1c1d0d01212121012d0d0d0d0d0b0c010101010101010e007101010d01010d0d0d0d0d0102010101010d0d0101020070707b0c00707070707071010202010101010101010101012d00000000000000000000451518595959595a5515104000000000000000000000000000000040404040404040f2c2c2e175151515151040000000000000000000000000000e0e0e0e0e0e03737373737378237e0e0e0e0e0000000242424242424242424242424242424242424242424242424242424242424000000000000000000000000000000000000000000000000000000000000
-- 060:d0d0d0d0d0d0d0d0d0d01212d0d0d01212101212d01212121212121212d0d0b1c1101010101010e007102010d0d01010d0d0d0d0d0102020101010d0d0101020201010b1c11010101010101010202020201010101010101012d00000000000000000000451518696969696a6515104000000000000000000000000000000041717171717170f2c2c2e0451515151510400000000000000000000000000e03737373737378383f0f0f0f0f9f037e082e0e0000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 061:d01212121212121012121212d0d0d01212121212d0d0d0d01212121212d0d0b0c01010101010e00710102010d010101010d0d0d0d0101010102531d0d010102020201010101010101010101010102020202010101010121212d0000000000000000000043242525151515151515104000000000000000000000000000000045151515151510fdede2e04515151515104000000000000000000000000e0e0838383838383838383f0f0f0f9f07737f037e0000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 062:d01212121212121212121212d0d0d01212121212d010121212d01212d0d0d0b1c110101010e0071010101010d0101212121010101010d010252510d0d010101020202010101010101010101010101010101010101012121212d0000000000000000000040404040435040404040404000000000000000000000000000000045151515151511f3f3f1d04515151515104000000000000000000000000e037838383e0e0e0e0838383f0f0f9f077f0f0f0e0000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 063:d01212d0d0d0d0d0d0d0d0d0d0d0d01212d0d012d0121212d0d0121210d0d0e0e0e0e0e0e007101010201010d0121212121212101010d010252510d0d0d9d9d9d9d9d9d8d8d8d8d8d9d9d9d9d9d9d9d9d9d9d9d9d9d8d8d8d8d00000000000000000005757575704040457575757570000000000000000000000000000000404040404040404040404040404043504040000000000000000000000e037f083838337e0e0e0e0838383f0f9f077f0f0e0e0000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 064:d012121212d0121012d01212d0d0d01212d0d012d01212d0d0d012d0d0d0d00707070707071010102020101060121212121212121010d025252510d045707070707070c9d9d9d9e97090a070707070707070707070c9d9d9d9d00000000000000000000000000057575700000000000000000000000000000000000000005757575757575757575757575757040404570000000000000000000000e0f0f0f083838337e0e0e0e0838383f9f077f0f0e067000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 065:d01212d012d0121212121212d0d0d01212d0d012121212d0d0d01241d0d0d012121212121210101010101010d0121212121212121210d025252525d04570707070707070707070707091a170707070707070707070707070704500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005757570000000000000000000000e0e0f0f0f0f083838337378237838383f98377f0e0e000000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 066:d01212d01212121212d012121212121212d0d0d0d0d0d0d0d0d01212d0d0d012121212121212121210101010d0121212121212121212d025252525d045707070707070707070707070707070707070707070707070707070704500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e0f0f0f0f0f083838383f797979797a7837783e06700000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 067:d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d045454545454545454545454545454545704545454545454545454545454500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e077e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00000000000515151515151515151515151515151515151515151515151515151515151000000000000000000000000000000000000000000000000000000000000
-- 068:454545454545454545454545704545454545454545454545454545454545454545454545d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0454545454545454545454545457045454545454545454545454545454545d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0d0d0d0d0d0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0000000e0e0e077e0e0e0000000000000000000000000000000000000000000000000000000e0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 069:457070707070707070707070707070707070707070707070707070707045457070707070d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d02525d0457070707070707070707070707070707070707070707070707070707045d0d0d02525d0d0d0d0121212121212121212121212d010101010101010d0d041101212121212e0101010b0c0e01010101010101010101010b0c020d0000000e08237f037e0e0000000000000000000000000000000000000000000e0e0e0e0e0e0e0cee0e0e0e0e0e0e0e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 070:457070707070707070707070707070707070707070707070707070707045457070707070c81010101010101010101010e012121212121006101025d0457070707070707070707070707070707070e0e0e0e0e0e0e0e0e0e0e045d0d0d02525d0d0d01010121212121212121210121260101010101010d0d0d010101212121212e0e01010b1c1e0e010101010b0c010101010b1c120d00000e0e0f983f0e0e067000000000000000000000000000000000000000000e03737823737e0704747474747474747e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 071:457070707070707070707070707070707070707070707070707070707045457070707070c81010101010101010101010e0121212121212e0101010d045707070707070707070707070707070e0e0e0b0c0b0c0b0c041b0c0e0e0d0d0d02525d0d01010101012121212121210101012e0e0e0e0e0101041d0d01212121212121210e0e010101007e010101010b1c110102020102020d00000e037f983e0e0670000000000000000e0e0e0e0e0000000000000000000e0e0f0f9f0e04770707070707090a07047e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 072:45707070707070707070707070707070707070d1e1e1e1e1f170707070454590a0707070c81010101010201010101010e01012d0d0d0d0e0101010d0d0d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7e01010b1c1b1c1b1c110b1c1d0e0d0b0c02525b0c010101010101212121292a21010e0e0e0e0e0e0e01010d0d0121212121212121210e0e0101010e01010e0e0e0e010102020202020d00000e083f983e06700000000000000e0e0e0376537e0e0000000000000000067e0e02a70477070707070707091a1707047e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 073:4570707070c7d7d7e770707070707070707070d2e2e2e2e2f270707070454591a1707070c81012101010102020101010e0121212121212e0e0e0e0d0d0b0c010b0c0b0c0b0c0b0c0b0c0b0c0e0e010b0c012b0c01010b0c0d0d0d0b1c12510b1c110101010101010101093a310e0e0e0e0e0e0e0e0e010d0d012121212121212121210e0b0c010e0101006070707e0101020202020d00000e083f983e000000000000000e0e03737f0f0f037e0e00000000000000000e04770707070707070707070707070707047e0e00000000000000000000000000000000000000000000000000000000000000000000000000000
-- 074:4570707070c8d041e870707070707070707070d2e2e2e2e2f27070707045457070707070c81012121210102020201010e0121212121210060707e0d0d0b1c110b1c1b1c1b1c1b1c1b1c1b1c1e0e0e0b1c112b1c11010b1c112d0d0101010251010e0e0e0e010101010101010e0e0e0e0e0e0e0e0e0e0e0d0d012121212121212121210e0b1c110e01010e010101007e010102020d0d00000e083f983e0e0000000e0e0e08237837777f0f0f037e00000000000000000e0707070707070707070707070e0e0e0707047e0e000000000000000000000000000000000000000000000000000000000000000000000000000
-- 075:4570707070c81212e870707090a07070707070d2e2e2e2e2f27070707070707070707070c81212121212102020201010e0e0e0e0e0e0e0e01010e0d0d0b0c010b0c06171b0c0b0c01212b0c00707e0e0121212b0c060601212d0d01010101010e0d01212e0101010101010e0e0e0e0e0e0e0e0e0e0e0e0d0d012121212121212121010e0e0e01007e0e0e010101010e0606060d0d0d00000e083f98337e0e0e0e0e03737f983f0f07777f0f0f0e00000000000000000e0e0707090a070707070e0e0e03737e070707047e000000000000000000000000000000000000000000000000000000000000000000000000000
-- 076:4570707070c9d9d9e970707091a17070707070d2e2e2e2e2f27070707045457070707070c8101212121210101010101007070706070707071012e0d0d0b1c110b1c16272b1c1b1c11212b1c1101207e0e01212b1c110121212d0d010121010e0d0121210e010101010b0c0e0e0e0e0e0e0e081e0e0e0e0d0d0121212121212121010101010061010d00707101010e0e010101010d0d00000e083f9838337373737378383f983f0f0f0777777f0e0000000000000000067e0e00c91a170707070e03737f0f0e0707070e0e000000000000000000000000000000000000000000000000000000000000000000000000000
-- 077:45707070707070707070707070707070807070d3e3e3e3e3f37070707045457070707070c81010121212101010101010101010e0101010121212e0d0d010101010311010fe1060121212121012101007061012121010101212d0d012121212e0d01210100610101010b1c1e0e041106010101010101010d0d0d0d0d0d0d0d0101010101010e01010d010101010e0e0101010101010d00000e083f98383f0f0f0838383833af0f0f0f0f0f07777e000000000000000000067e0f9e0e0e0e0e07047e0f0f0f0477070e0e06700000000000000000000000000000000000000000000000000000000000000000000000000
-- 078:457070707070707070707070707070707070707070707070707070707045457070707070c81010101010101010101010e0e0e0e0101012121212e0d0d0b0c010101010101010b0c01212b0c012121212e01210101010101012d0d012121212e0d0d01210e0101010101010e0e010106010101010252525252525252525102510101010e0e0e02010d01010e0e0e010101010101010d00000e083f98383f0f0f0f0f0f0f03bf0f0f0f0f0f083e0e000000000000000000000e0f7f8e06767e0e07047e0e0e0e070e0e0670000000000000000000000000000000000000000000000000000000000000000000000000000
-- 079:457070707070707070707070707070707070707070707070707070707045457070707070c81010101010101010101010e0101006101012121212e0d0d0b1c112101010101010b1c11212b1c1121212e0e03040404040404050d0d01212121207e0d0d012e010101010101007e010106010101010251025d0d025252525251010101010e007072010d01010e0101010101010101010d00000e083f98383f0f0f0f0f0f0f0f9f0f0f0f0f08383e00000000000000000000000e0e0f9e0e0e0e0e0e07047477547e0e067000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 080:457070707070707070708070707070707070707070707070707070707045457070707070c81010102010101010101010e01010e0e0e0e0e0e0e0e0d0d0101012101212121212126012121210121212e0072020101010251010d0d0121212121207e0e0e0e010101010101010e0e0e06010101010101010d0d0d0d0d0d0d0d010101010e020201010d01010e0201010101010101010d00000e0e0f7979797fa9797979797a7f0f08383838383e0e0000000000000000000e0e037f937474747474770707070e0e06700000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 081:457070707070707070707070707070707070707070707070707070707045457070707070c81010102020101010101010e01010e007070707074107d0d0b0c012b0c012b0c012b0c01212b0c0101210e0122020101025101010d0d012121212121207070707101010101010100707e0e0e010101010b0c0d0d012121212121220201010e020202010101010e0202020102510101010d0000067e0e0e070702a7070f0f0f0f0f0f0838383838383e0000000000000000000e037f0f9707070707070e0e070e0e0670000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 082:457070707070707070707070707070707070707070707080707070707045457070707070c81010102020202010101010e06060e010102020101010d0d0b1c112b1c112b1c112b1c16060b1c11010e0e0121210b0c02525b0c0d0d0121212121212121212121010101010102525250707e0e0e01010b1c1d0d012121212121212202010e0e0b0c010d01010e0b0c020101025101010d00000006767e0707070707070f0f0f08383838383838383e0000000000000000000e0f0f0f7f870707070e0e0e0e0e067000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 083:457070707070707070707070707070707070707070707070707070707045457070707070c81010102020202010101010e010101010101010101010d0d0d01212121212121212101010101010e0e0e007121212b1c12525b1c1d0d01212121212121212121212101010102510252525100707e0e0e0e0e0e0d01212121212121212202020e0b1c110d01010e0b1c120202525101010d000000000e047707070707070e0e0e08383838383838383e0000000000000000000e0e0e0f0f9f07070e0e06767676700000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 084:454545454545454545454545454545454570454545454545454545454545454545454545d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d025d0d0d0d0d0d0d0d0d0e0d0d0d0d0d0d0d0d0d0d0d0d0d0e0e0e0e0e0e0e0d0d0d0d025d0d0d0d0d0000000e0e0457045e0e0e0e0e067e0e0e0e0e0e083e0e0e00000000000000000006767e0e0e0e0e0e067670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
-- 098:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d010101010101010100610121212121212d0101010d012121212121212d0d0121212121212d0d0d012121212d0d0d0d0d0d01212121212316272fed0d01212121212d0121212121212101010e0b0c0b0c0b0c0b0c0b0c0b0c0d0000000006767e0e0e0e0e0e0e0e0e0e0e0e0e0e067670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 099:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d010101010101010e0e0d012121212d0d0b0c010d0d0121212121212121212121212121212d0d0d0d0d01212d0d0d0121212121212121210101012d0d01212121212d0121212121212121210e0b1c1b1c1b1c1b1c1b1c1b1c1d0000000000000676767676767676767676767676700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 100:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d060b1c110d01212121212121212d0d01212121212d0d0d0d0d0d012121212121212d0121212121010101212d0d0121212121212121212121212121212e0b0c0b0c0b0c0b0c0b0c0b0c0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 101:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0b1c1b1c1b1c1b1c1b1c1b1c1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP2>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000000009
-- 018:04000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040000a000000000
-- 063:00f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000402000000000
-- </SFX>

-- <FLAGS>
-- 000:00000040404080018010101010101000101010101000101010101010100000000020101010001010101010010000000000000010101010102010101000000000100000000000101000000010101010100010000010001010000000101010101000101010101000000000001010101010000000000100008080000000000000001010101010101010101000000000000010101010101010101000000000000000202011001010101000000000001010000000000000001010000000000010100011000000000000000000000000000000000000000000000000000000000000000000000000001010000000000100001000000000000010100000000000000000
-- </FLAGS>

-- <FLAGS2>
-- 000:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000
-- </FLAGS2>

-- <FLAGS3>
-- 000:00000040404080218010101010101000101010100000101010101010100000000020101010001010100000000000000000000000000010102000000000000000000000000000101000000010101010100010000010000000000000101010101000101010101000000000001010101010000000000100008080000000000000001010101010101010101010100000000010101010101010101010101000000000101010001010000000000000001010001010000010100000000000000010100010000000001010000000000000000000000000000010100000000000000000000000000010101010000000000100000000000000101010100000000000000000
-- </FLAGS3>

-- <PALETTE>
-- 000:0000001d2b537e255383769cab5236008751ff004d5f574fff77a8ffa300c2c3c700e436ffccaa29adffffec27ffffff
-- </PALETTE>

-- <PALETTE1>
-- 000:0000001d2b537e255383769cab5236008751ff004d5f574fff77a8ffa300c2c3c700e436ffccaa29adffffec27fff1e8
-- </PALETTE1>

-- <PALETTE2>
-- 000:0000000d1b436e154373668c9b4226007741ef003d4f473fef6798ef9300b2b3b700d426efbc9a199defefdc17efefef
-- </PALETTE2>

-- <PALETTE3>
-- 000:0000001d2b537e255383769cab5236008751ff004d5f574fff77a8ffa300c2c3c700e436ffccaa29adffffec27fff1e8
-- </PALETTE3>

