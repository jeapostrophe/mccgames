pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
 t=0
 shake=0
 
 dpal=explodeval("0,1,1,2,1,13,6,4,4,9,3,13,1,13,14")
 
 dirx=explodeval("-1,1,0,0,1,1,-1,-1")
 diry=explodeval("0,0,-1,1,-1,1,1,-1")
 
 itm_name=explode("lazer cleaver,dimention blade,light dagger,dark steel blade,the ultblade,steel armor,dimention armor,bone armor,bland armor,dark steel armor,ultra armor,food 1,food 2,food 3,food 4,food 5,food 6,zap,mega zap,teslar,floom")
	itm_type=explode("wep,wep,wep,wep,wep,wep,arm,arm,arm,arm,arm,arm,fud,fud,fud,fud,fud,fud,thr,thr,thr,thr")
	itm_stat1=explodeval("1,2,3,4,5,6,0,0,0,1,2,3,1,2,3,4,5,6,1,2,4,6")
	itm_stat2=explodeval("0,0,0,0,0,0,1,2,3,4,5,6,0,0,0,0,0,0,0,0,0,0")
	itm_minf=explodeval("1,2,3,4,5,6,1,2,3,4,5,6,1,1,1,1,1,1,1,2,4,6")
	itm_maxf=explodeval("3,4,5,6,7,8,3,4,5,6,7,8,8,8,8,8,8,8,3,4,6,8")
	itm_desc=explode(",,,,,,,,,,,,heals,heals alot,increases hp,is blessed,is cursed,stuns,,,,")

	mob_name=explode("player,blorgling,znorgling,phorgling,plexling,shredling,watchling,jelleye,larveye")
	mob_ani=explodeval("240,192,196,200,204,208,212,216,220")
	mob_atk=explodeval("1,1,1,2,4,5,4,5,5")
	mob_hp=explodeval("5,1,2,3,4,5,6,7,8")
	mob_los=explodeval("4,4,4,4,4,4,4,4,4")
	mob_minf=explodeval("0,1,2,3,4,5,6,7,8")
	mob_maxf=explodeval("0,3,4,5,6,7,8,8,8")
	mob_spec=explode(",,,,,,,,")

 crv_sig=explodeval("255,214,124,179,233")
 crv_msk=explodeval("0,9,3,12,6")

	free_sig=explodeval("0,0,0,0,16,64,32,128,161,104,84,146")
 free_msk=explodeval("8,4,2,1,6,12,9,3,10,5,10,5")

 wall_sig=explodeval("251,233,253,84,146,80,16,144,112,208,241,248,210,177,225,120,179,0,124,104,161,64,240,128,224,176,242,244,116,232,178,212,247,214,254,192,48,96,32,160,245,250,243,249,246,252")
 wall_msk=explodeval("0,6,0,11,13,11,15,13,3,9,0,0,9,12,6,3,12,15,3,7,14,15,0,15,6,12,0,0,3,6,12,9,0,9,0,15,15,7,15,14,0,0,0,0,0,0")

 debug={}
 startgame()
end

function _update60()
 t+=1
 _upd()
 dofloats()
 dohpwind()
end

function _draw()
	doshake()
 _drw()
 drawind()
 drawlogo()
 --fadeperc=0
 checkfade()
 
 --★
 cursor(4,4)
 color(8)
 for txt in all(debug) do
  print(txt)
 end
end

function startgame()
	--music(63)

	tani=0
 fadeperc=1
 buttbuff=-1
 
 logo_t=240
 logo_y=35
 
 skipai=false
 win=false
 winfloor=9
 --★
 mob={}
 dmob={}
 p_mob=addmob(1,1,1)
 
 p_t=0
 
 inv,eqp={},{}
	makeipool()
	foodnames()
 --[[takeitem(17)
 takeitem(16)
 takeitem(18)]]
  
 wind={}
 float={}

 talkwind=nil
 
 hpwind=addwind(5,5,28,13,{})
 
 thrdx,thrdy=0,-1
 
 _upd=update_game
 _drw=draw_game
 
 st_steps,st_kills,st_meals,st_killer=0,0,0,""
 
 genfloor(0)
 
end
-->8
--updates
function update_game()
 if talkwind then
  if getbutt()==5 then
   sfx(53)
   talkwind.dur=0
   talkwind=nil
  end
 else
  dobuttbuff()
  dobutt(buttbuff)
  buttbuff=-1
  advan()
 end
end

function update_inv()
 --inventory
 if move_mnu(curwind) and curwind==invwind then
  showhint()
 end
 if btnp(4) then
  sfx(53)
  if curwind==invwind then
   _upd=update_game
   invwind.dur=0
   statwind.dur=0
   if hintwind then
    hintwind.dur=0
   end
  --★
  elseif curwind==usewind then
   usewind.dur=0
   curwind=invwind
  end
 elseif btnp(5) then
  sfx(54)
  if curwind==invwind and invwind.cur!=3 then
   showuse()
   --★
  elseif curwind==usewind then
   -- use window confirm 
   triguse() 
  end
 end
end

function update_throw()
 local b=getbutt()
 if b>=0 and  b<=3 then
  thrdx=dirx[b+1]
  thrdy=diry[b+1]
 end
 if b==4 then
  _upd=update_game
 elseif b==5 then
  throw()
 end
end

function move_mnu(wnd)
 local moved=false
 if btnp(2) then
  sfx(56)
  wnd.cur-=1
  moved=true
 elseif btnp(3) then
  sfx(56)
  wnd.cur+=1
  moved=true
 end
 wnd.cur=(wnd.cur-1)%#wnd.txt+1
 return moved
end


function update_pturn()
 dobuttbuff()
 p_t=min(p_t+0.125,1)
 
 if p_mob.mov then
  p_mob:mov()
 end
 
 if p_t==1 then
  _upd=update_game
  if trig_step() then return end

  if checkend() and not skipai then
   doai()
  end
  skipai=false
 end
end

function update_aiturn()
 dobuttbuff()
 p_t=min(p_t+0.125,1)
 for m in all(mob) do
  if m!=p_mob and m.mov then
   m:mov()
  end
 end
 if p_t==1 then
  _upd=update_game
  if checkend() then
   if p_mob.stun then
    p_mob.stun=false
    doai()
   end
  end
 end
end

function update_gover()
 if btnp(❎) then
  sfx(54)
  fadeout()
  startgame()
 end
end

function dobuttbuff()
 if buttbuff==-1 then
  buttbuff=getbutt()
 end
end

function getbutt()
 for i=0,5 do
  if btnp(i) then
   return i
  end
 end
 return -1
end

function dobutt(butt)
 if butt<0 then return end
 if logo_t>0 then logo_t=0 end
 if butt<4 then
  moveplayer(dirx[butt+1],diry[butt+1])
 elseif butt==5 then
  showinv()
  sfx(54)
	elseif butt==4 then
--	win=true
--  p_mob.hp=0
--  st_killer="slime"
-- genfloor(floor+1)
--  prettywalls()
 end
end
-->8
--draws
function draw_game()
 cls(0)
 if fadeperc==1 then return end
 animap()
 map()
 for m in all(dmob) do
  if sin(time()*8)>0 or m==p_mob then
   drawmob(m)
  end
  m.dur-=1
  if m.dur<=0 and m!=p_mob then
   del(dmob,m)
  end
 end
 
 for i=#mob,1,-1 do
  drawmob(mob[i])
 end
 
 if _upd==update_throw then
  --★
  local tx,ty=throwtile()
  local lx1,ly1=p_mob.x*8+3+thrdx*4,p_mob.y*8+3+thrdy*4
  local lx2,ly2=mid(0,tx*8+3,127),mid(0,ty*8+3,127)
  rectfill(lx1+thrdy,ly1+thrdx,lx2-thrdy,ly2-thrdx,0)
  
  local thrani,mb=flr(t/7)%2==0,getmob(tx,ty)
  if thrani then
   fillp(0b1010010110100101)
  else
   fillp(0b0101101001011010)
  end
  line(lx1,ly1,lx2,ly2,7)
  fillp()
  oprint8("+",lx2-1,ly2-2,7,0)
  
  if mb and thrani then
   mb.flash=1
  end
 end 
 
 for x=0,15 do
  for y=0,15 do
   if fog[x][y]==1 then
    rectfill2(x*8,y*8,8,8,0)
   end
  end
 end
  
 for f in all(float) do
  oprint8(f.txt,f.x,f.y,f.c,0)
 end

end

function drawlogo()
 if logo_y>-24 then
  logo_t-=1
  if logo_t<=0 then
   logo_y+=logo_t/20
  end
  palt(12,true)
  palt(0,false)
  spr(144,7,logo_y,14,3)
  palt()
  oprint8("the quest for no reason",19,logo_y+20,7,0)
 end
end

function drawmob(m)
 local col=6
 if m.flash>0 then
  m.flash-=1
  col=7
 end
 drawspr(getframe(m.ani),m.x*8+m.ox,m.y*8+m.oy,col,m.flp)
end

--[[function draw_gover()
 cls(2)
 print("y ded",50,50,7)
end

function draw_win()
 cls(2)
 print("u win",50,50,7)
end]]--

function draw_gover()
 cls()
 palt(12,true)
 spr(gover_spr,gover_x,30,gover_w,2)
 if not win then
  print("killed by a "..st_killer,28,43,6)
 end
 palt()
 color(5)
 cursor(40,56)
 if not win then
  print("floor: "..floor)
 end
 print("steps: "..st_steps)
 print("kills: "..st_kills)
 print("meals: "..st_meals)

 print("press ❎",46,90,5+abs(sin(time()/3)*2))
end

function animap()
 tani+=1
 if (tani<15) return
 tani=0
 for x=0,15 do
  for y=0,15 do
   local tle=mget(x,y)
   if tle==64 or tle==66 then
    tle+=1
   elseif tle==65 or tle==67 then
    tle-=1
   end
   mset(x,y,tle)
  end
 end
end

-->8
--tools

function getframe(ani)
 return ani[flr(t/15)%#ani+1]
end

function drawspr(_spr,_x,_y,_c,_flip)
 palt(0,false)
 pal(6,_c)
 spr(_spr,_x,_y,1,1,_flip)
 pal()
end

function rectfill2(_x,_y,_w,_h,_c)
 --★
 rectfill(_x,_y,_x+max(_w-1,0),_y+max(_h-1,0),_c)
end

function oprint8(_t,_x,_y,_c,_c2)
 for i=1,8 do
  print(_t,_x+dirx[i],_y+diry[i],_c2)
 end 
 print(_t,_x,_y,_c)
end

function dist(fx,fy,tx,ty)
 local dx,dy=fx-tx,fy-ty
 return sqrt(dx*dx+dy*dy)
end

function dofade()
 local p,kmax,col,k=flr(mid(0,fadeperc,1)*100)
 for j=1,15 do
  col = j
  kmax=flr((p+j*1.46)/22)
  for k=1,kmax do
   col=dpal[col]
  end
  pal(j,col,1)
 end
end

function checkfade()
 if fadeperc>0 then
  fadeperc=max(fadeperc-0.04,0)
  dofade()
 end
end

function wait(_wait)
 repeat
  _wait-=1
  flip()
 until _wait<0
end

function fadeout(spd,_wait)
 if (spd==nil) spd=0.04
 if (_wait==nil) _wait=0
 repeat
  fadeperc=min(fadeperc+spd,1)
  dofade()
  flip()
 until fadeperc==1
 wait(_wait)
end

function blankmap(_dflt)
 local ret={} 
 if (_dflt==nil) _dflt=0
 
 for x=0,15 do
  ret[x]={}
  for y=0,15 do
   ret[x][y]=_dflt
  end
 end
 return ret
end

function getrnd(arr)
 return arr[1+flr(rnd(#arr))]
end

function copymap(x,y)
 local tle
 for _x=0,15 do
  for _y=0,15 do
   tle=mget(_x+x,_y+y)
   mset(_x,_y,tle)
   if tle==15 then
    p_mob.x,p_mob.y=_x,_y
   end
  end
 end
end

function explode(s)
 local retval,lastpos={},1
 for i=1,#s do
  if sub(s,i,i)=="," then
   add(retval,sub(s, lastpos, i-1))
   i+=1
   lastpos=i
  end
 end
 add(retval,sub(s,lastpos,#s))
 return retval
end

function explodeval(_arr)
 return toval(explode(_arr))
end

function toval(_arr)
 local _retarr={}
 for _i in all(_arr) do
  add(_retarr,flr(tonum(_i)))
 end
 return _retarr
end

function doshake()
 local shakex,shakey=16-rnd(32),16-rnd(32)
 camera(shakex*shake,shakey*shake)
 shake*=0.95
 if (shake<0.05) shake=0
end
-->8
--gameplay

function moveplayer(dx,dy)
 local destx,desty=p_mob.x+dx,p_mob.y+dy
 local tle=mget(destx,desty)
  
 if iswalkable(destx,desty,"checkmobs") then
  --sfx(63)
  mobwalk(p_mob,dx,dy)
  st_steps+=1
  p_t=0
  _upd=update_pturn
 else
  --not walkable
  mobbump(p_mob,dx,dy)
  p_t=0
  _upd=update_pturn
  
  local mob=getmob(destx,desty)
  if mob then
   --sfx(58)
   hitmob(p_mob,mob)
  else
   if fget(tle,1) then
    trig_bump(tle,destx,desty)
   else
    skipai=true
    --mset(destx,desty,1)
   end
  end
 end
 unfog()
end

function trig_bump(tle,destx,desty)
 if tle==7 or tle==8 then
  --vase
 -- sfx(59)
  mset(destx,desty,76)
  if rnd(3)<1 and floor>0 then
   if rnd(5)<1 then
    addmob(getrnd(mobpool),destx,desty)
   else
    if freeinvslot()==0 then
     showmsg("inventory full",120)
    else
     local itm=getrnd(fipool_com)
     takeitem(itm)
     showmsg(itm_name[itm].."!",60)
    end
   end
  end
 elseif tle==10 or tle==12 then
  --chest
  if freeinvslot()==0 then
   showmsg("inventory full",120)
   skipai=true
  else
   local itm=getrnd(fipool_com)
   if tle==12 then
    itm=getitm_rar()  
   end
   --sfx(61)
   mset(destx,desty,tle-1)
   takeitem(itm)
   showmsg(itm_name[itm].."!",60)
  end
 elseif tle==13 then
  --door
  --sfx(62)
  mset(destx,desty,1)
 elseif tle==6 then
  --stone tablet
  if floor==0 then
  	--sfx(54)
   showtalk({"welcome ", "pilot!","","are you ready", "to leave the ship?","good luck","-computer",""})
		end
 elseif tle==94 then
 --sword of light
  win=true
 end
end

function trig_step()
 local tle=mget(p_mob.x,p_mob.y)

 
 if tle==14 then
 	--sfx(55)
  p_mob.bless=0
  fadeout()
  genfloor(floor+1)
  floormsg()
  return true
 end
 return false
end

function getmob(x,y)
 for m in all(mob) do
  if m.x==x and m.y==y then
   return m
  end
 end
 return false
end

function iswalkable(x,y,mode)
 local mode = mode or "test"
 
 --sight
 if inbounds(x,y) then
  local tle=mget(x,y)
  if mode=="sight" then
   return not fget(tle,2)
  else
   if not fget(tle,0) then
    if mode=="checkmobs" then
     return not getmob(x,y)
    end
    return true
   end
  end
 end
 return false
end

function inbounds(x,y)
 return not (x<0 or y<0 or x>15 or y>15)
end

function hitmob(atkm,defm,rawdmg)
 local dmg= atkm and atkm.atk or rawdmg
 
 --add curse/bless
 if defm.bless<0 then
  dmg*=2
 elseif defm.bless>0 then
  dmg=flr(dmg/2)
 end
 defm.bless=0
 
 local def=defm.defmin+flr(rnd(defm.defmax-defm.defmin+1))
 dmg-=min(def,dmg)
 --dmg=max(0,dmg)
 
 defm.hp-=dmg
 defm.flash=10
 
 addfloat("-"..dmg,defm.x*8,defm.y*8,9)
 
 shake=defm==p_mob and 0.08 or 0.04
 
 if defm.hp<=0 then
 	if defm!=p_mob then 
 		st_kills+=1 
 	else
 		st_killer=atkm.name
 	end
  
  add(dmob,defm)
  del(mob,defm)
  defm.dur=10
 end
end

function healmob(mb,hp)
 hp=min(mb.hpmax-mb.hp,hp)
 mb.hp+=hp
 mb.flash=10
 addfloat("+"..hp,mb.x*8,mb.y*8,7)
	--sfx(51)
end

function stunmob(mb)
 mb.stun=true
 mb.flash=10
 addfloat("stun",mb.x*8-3,mb.y*8,7)
	--sfx(51)
end

function blessmob(mb,val)
 mb.bless=mid(-1,1,mb.bless+val)
 mb.flash=10
 
 local txt="bless"
 if val<0 then txt="curse" end
 
 addfloat(txt,mb.x*8-6,mb.y*8,7)
 
 if mb.spec=="ghost" and val>0 then
  add(dmob,mb)
  del(mob,mb)
  mb.dur=10 
 end
 --sfx(51)
end

function checkend()
 --★
 if win then
 	--music(23)  
  gover_spr=112
  gover_x=28
  gover_w=13
  showgover()
  return false
 elseif p_mob.hp<=0 then
 	--music(21)
  
  gover_spr=80
  gover_x=28
  gover_w=9
		showgover()
  return false
 end
 return true
end

function showgover()
	wind={}
 _upd=update_gover
 _drw=draw_gover
 fadeout(0.02)
end

function los(x1,y1,x2,y2)
 local frst,sx,sy,dx,dy=true
 --★
 if dist(x1,y1,x2,y2)==1 then return true end
 if x1<x2 then
  sx,dx=1,x2-x1
 else
  sx,dx=-1,x1-x2
 end
 if y1<y2 then
  sy,dy=1,y2-y1
 else
  sy,dy=-1,y1-y2
 end
 local err,e2=dx-dy
 
 while not(x1==x2 and y1==y2) do
  if not frst and iswalkable(x1,y1,"sight")==false then return false end
  e2,frst=err+err,false
  if e2>-dy then
   err-=dy
   x1+=sx
  end
  if e2<dx then 
   err+=dx
   y1+=sy
  end
 end
 return true 
end

function unfog()
 local px,py=p_mob.x,p_mob.y
 for x=0,15 do
  for y=0,15 do 
   --★
   if fog[x][y]==1 and dist(px,py,x,y)<=p_mob.los and los(px,py,x,y) then
    unfogtile(x,y)
   end
  end
 end
end

function unfogtile(x,y)
 fog[x][y]=0
 if iswalkable(x,y,"sight") then
  for i=1,4 do
   local tx,ty=x+dirx[i],y+diry[i]
   if inbounds(tx,ty) and not iswalkable(tx,ty,"sight") then
    fog[tx][ty]=0
   end
  end  
 end
end

function calcdist(tx,ty)
 local cand,step,candnew={},0
 distmap=blankmap(-1)
 add(cand,{x=tx,y=ty})
 distmap[tx][ty]=0
 repeat
  step+=1
  candnew={} 
  for c in all(cand) do
   for d=1,4 do
    local dx=c.x+dirx[d]
    local dy=c.y+diry[d]
    if inbounds(dx,dy) and distmap[dx][dy]==-1 then
     distmap[dx][dy]=step
     if iswalkable(dx,dy) then
      add(candnew,{x=dx,y=dy})
     end
    end
   end
  end
  cand=candnew
 until #cand==0
end

function updatestats()
 local atk,dmin,dmax=1,0,0
 
 if eqp[1] then
  atk+=itm_stat1[eqp[1]]
 end
 
 if eqp[2] then
  dmin+=itm_stat1[eqp[2]]
  dmax+=itm_stat2[eqp[2]]
 end

 p_mob.atk=atk
 p_mob.defmin=dmin
 p_mob.defmax=dmax 
end

function eat(itm,mb)
 local effect=itm_stat1[itm]
 
 if not itm_known[itm] then
 	showmsg(itm_name[itm]..itm_desc[itm],120)
 	itm_known[itm]=true
 end
 
 if mb==p_mob then st_meals+=1 end
 
 if effect==1 then
  --heal
  healmob(mb,1)
 elseif effect==2 then
  --heal a lot
  healmob(mb,3)
 elseif effect==3 then
  --plus maxhp
  mb.hpmax+=1
  healmob(mb,1)
 elseif effect==4 then
  --bless
  blessmob(mb,1)
 elseif effect==5 then
  --curse
  blessmob(mb,-1)
 elseif effect==6 then  
  --stun
  stunmob(mb)
 end
end

function throw()
 local itm,tx,ty=inv[thrslt],throwtile()
	--sfx(52)
 if inbounds(tx,ty) then
  local mb=getmob(tx,ty)
  if mb then
   if itm_type[itm]=="fud" then
    eat(itm,mb)
   else
    hitmob(nil,mb,itm_stat1[itm])
    --sfx(58)
   end
  end
 end
 mobbump(p_mob,thrdx,thrdy)
 
 inv[thrslt]=nil
 p_t=0
 _upd=update_pturn
 
end

function throwtile()
 local tx,ty=p_mob.x,p_mob.y
 repeat
  tx+=thrdx
  ty+=thrdy
 until not iswalkable(tx,ty,"checkmobs")
 return tx,ty
end
-->8
--ui

function addwind(_x,_y,_w,_h,_txt)
 local w={x=_x,
          y=_y,
          w=_w,
          h=_h,
          txt=_txt}
 add(wind,w)
 return w
end

function drawind()
 for w in all(wind) do
  local wx,wy,ww,wh=w.x,w.y,w.w,w.h
  rectfill2(wx,wy,ww,wh,0)
  rect(wx+1,wy+1,wx+ww-2,wy+wh-2,6)
  wx+=4
  wy+=4
  clip(wx,wy,ww-8,wh-8)
  if w.cur then
   wx+=6
  end
  for i=1,#w.txt do
   local txt,c=w.txt[i],6
   if w.col and w.col[i] then
    c=w.col[i]
   end
   print(txt,wx,wy,c)
   if i==w.cur then
    spr(92,wx-5+sin(time()),wy)
   end
   wy+=6
  end
  clip()
 
  if w.dur then
   w.dur-=1
   if w.dur<=0 then
    local dif=w.h/4
    w.y+=dif/2
    w.h-=dif
    if w.h<3 then
     del(wind,w)
    end
   end
  else
   if w.butt then
    oprint8("❎",wx+ww-15,wy-1+sin(time()),6,0)
   end
  end
 end
end

function showmsg(txt,dur)
 local wid=(#txt+2)*4+7
 local w=addwind(63-wid/2,50,wid,13,{" "..txt})
 w.dur=dur
end

function showtalk(txt)
 talkwind=addwind(16,50,94,#txt*6+7,txt)
 talkwind.butt=true
end

function addfloat(_txt,_x,_y,_c)
 add(float,{txt=_txt,x=_x,y=_y,c=_c,ty=_y-10,t=0})
end

function dofloats()
 for f in all(float) do
  f.y+=(f.ty-f.y)/10
  f.t+=1
  if f.t>70 then
   del(float,f)
  end
 end
end

function dohpwind()
 hpwind.txt[1]="♥"..p_mob.hp.."/"..p_mob.hpmax
 local hpy=5
 if p_mob.y<8 then
  hpy=110
 end
 hpwind.y+=(hpy-hpwind.y)/5
end

function showinv()
 local txt,col,itm,eqt={},{}
 _upd=update_inv
 for i=1,2 do
  itm=eqp[i]
  if itm then
   eqt=itm_name[itm]
   add(col,6)
  else
   eqt= i==1 and "[weapon]" or "[armor]"
   add(col,5)
  end
  add(txt,eqt)
 end
 add(txt,"……………………")
 add(col,6)
 for i=1,6 do
  itm=inv[i]
  if itm then
   add(txt,itm_name[itm])
   add(col,6)
  else
   add(txt,"...")
   add(col,5)
  end
 end
 

 invwind=addwind(5,17,84,62,txt)
 invwind.cur=3
 invwind.col=col

 txt="ok    "
 if p_mob.bless<0 then
  txt="curse "
 elseif p_mob.bless>0 then
  txt="bless "
 end
   
 statwind=addwind(5,5,84,13,{txt.."atk:"..p_mob.atk.." def:"..p_mob.defmin.."-"..p_mob.defmax})
 
 curwind=invwind
end

function showuse()
 local itm=invwind.cur<3 and eqp[invwind.cur] or inv[invwind.cur-3]
 if itm==nil then return end
 local typ,txt=itm_type[itm],{}
 
 if (typ=="wep" or typ=="arm") and invwind.cur>3 then
  add(txt,"equip")
 end
 if typ=="fud" then
  add(txt,"eat")
 end
 if typ=="thr" or typ=="fud" then
  add(txt,"throw")
 end
 add(txt,"trash")

 usewind=addwind(84,invwind.cur*6+11,36,7+#txt*6,txt)
 usewind.cur=1
 curwind=usewind 
end

function triguse()
 local verb,i,back=usewind.txt[usewind.cur],invwind.cur,true
 local itm=i<3 and eqp[i] or inv[i-3]
 
 if verb=="trash" then
  if i<3 then
   eqp[i]=nil
  else
   inv[i-3]=nil
  end
 elseif verb=="equip" then
  local slot=2
  if itm_type[itm]=="wep" then
   slot=1
  end
  inv[i-3]=eqp[slot]
  eqp[slot]=itm
 elseif verb=="eat" then
  eat(itm,p_mob)
  _upd,inv[i-3],p_mob.mov,p_t,back=update_pturn,nil,nil,0,false
 elseif verb=="throw" then
  _upd,thrslt,back=update_throw,i-3,false
 end
 
 updatestats()
 usewind.dur=0
 
 if back then
  del(wind,invwind)
  del(wind,statwind)
  showinv()
  invwind.cur=i
  showhint()
 else
  invwind.dur=0
  statwind.dur=0
  if hintwind then
   hintwind.dur=0
  end
 end
end

function floormsg()
 showmsg("floor "..floor,120)
end

function showhint()
 if hintwind then
  hintwind.dur=0
  hintwind=nil
 end
 
 if invwind.cur>3 then
  local itm=inv[invwind.cur-3]
  
  if itm and itm_type[itm]=="fud" then
   local txt=itm_known[itm] and itm_name[itm]..itm_desc[itm] or "???"
   hintwind=addwind(5,78,#txt*4+7,13,{txt})
  end
 
 end
 
end


--advancements?
a_kill = false
a_meal = false
a_hp = false
a_flr = false
a_crs = false
function advan()
	if st_kills==4 and not a_kill then
	 a_kill = true
		showmsg("advancement:monster hunter",120)
	elseif st_meals==3 and not a_meal then
		a_meal = true
		showmsg("advancement:medic",120)	
	elseif p_mob.hp<=3 and not a_hp then
		a_hp = true
		showmsg("advancement:i can take it!",120)
	elseif floor==3 and not a_flr then
		a_flr = true
		showmsg("advancement:explorer!",120)
	end
end


-->8
--mobs and items

function addmob(typ,mx,my)
 local m={
  x=mx,
  y=my,
  ox=0,
  oy=0,
  flp=false,
  ani={},
  flash=0,
  stun=false,
  bless=0,
  charge=1,
  lastmoved=false,
  spec=mob_spec[typ],
  hp=mob_hp[typ],
  hpmax=mob_hp[typ],
  atk=mob_atk[typ],
  defmin=0,
  defmax=0,
  los=mob_los[typ],
  task=ai_wait,
  name=mob_name[typ]
 }
 for i=0,3 do
  add(m.ani,mob_ani[typ]+i)
 end
 add(mob,m)
 return m
end

function mobwalk(mb,dx,dy)
 mb.x+=dx --?
 mb.y+=dy

 mobflip(mb,dx)
 mb.sox,mb.soy=-dx*8,-dy*8
 mb.ox,mb.oy=mb.sox,mb.soy
 mb.mov=mov_walk
end

function mobbump(mb,dx,dy)
 mobflip(mb,dx)
 mb.sox,mb.soy=dx*8,dy*8
 mb.ox,mb.oy=0,0
 mb.mov=mov_bump
end

function mobflip(mb,dx)
 mb.flp = dx==0 and mb.flp or dx<0

end


function mov_walk(self)
 local tme=1-p_t 
 self.ox=self.sox*tme
 self.oy=self.soy*tme
end

function mov_bump(self)
 --★ 
 local tme= p_t>0.5 and 1-p_t or p_t
 self.ox=self.sox*tme
 self.oy=self.soy*tme
end

function doai()
 local moving=false
 for m in all(mob) do
  if m!=p_mob then
   m.mov=nil
   if m.stun then
    m.stun=false
   else
    m.lastmoved=m.task(m)
    moving=m.lastmoved or moving
   end
  end
 end
 if moving then
  _upd=update_aiturn
  p_t=0
 else
  p_mob.stun=false
 end
end

function ai_wait(m)
 if cansee(m,p_mob) then
  --aggro
  m.task=ai_attac
  m.tx,m.ty=p_mob.x,p_mob.y
  addfloat("!",m.x*8+2,m.y*8,10)
 end
 return false
end

function ai_attac(m)  
 if dist(m.x,m.y,p_mob.x,p_mob.y)==1 then
  --attack player
  local dx,dy=p_mob.x-m.x,p_mob.y-m.y
  mobbump(m,dx,dy)
  if m.spec=="stun" and m.charge>0 then
   stunmob(p_mob)
   m.charge-=1
  elseif m.spec=="ghost" and m.charge>0 then
   hitmob(m,p_mob)
   blessmob(p_mob,-1)
   m.charge-=1   
  else
   hitmob(m,p_mob)
  end
  --sfx(57)
  return true
 else
  --move to player
  if cansee(m,p_mob) then
   m.tx,m.ty=p_mob.x,p_mob.y
  end
  
  if m.x==m.tx and m.y==m.ty then
   --de aggro
   m.task=ai_wait
   addfloat("?",m.x*8+2,m.y*8,10)
  else
   if m.spec=="slow" and m.lastmoved then
    return false
   end
   local bdst,cand=999,{}
   calcdist(m.tx,m.ty)
   for i=1,4 do
    local dx,dy=dirx[i],diry[i]
    local tx,ty=m.x+dx,m.y+dy
    if iswalkable(tx,ty,"checkmobs") then
     local dst=distmap[tx][ty]
     if dst<bdst then
      cand={}
      bdst=dst
     end
     if dst==bdst then
      add(cand,i)
     end
    end
   end
   if #cand>0 then
    local c=getrnd(cand)
    mobwalk(m,dirx[c],diry[c])
    return true
   end 
   --todo: re-aquire target?
  end
 end
 return false
end

function cansee(m1,m2)
 return dist(m1.x,m1.y,m2.x,m2.y)<=m1.los and los(m1.x,m1.y,m2.x,m2.y)
end

function spawnmobs()
 
 mobpool={}
 for i=2,#mob_name do
  if mob_minf[i]<=floor and mob_maxf[i]>=floor then
   add(mobpool,i)
  end
 end
 
 if #mobpool==0 then return end
 
 local minmons=explodeval("3,5,7,9,10,11,12,13")
 local maxmons=explodeval("6,10,14,18,20,22,24,26")
 
 local placed,rpot=0,{}
 
 for r in all(rooms) do
  add(rpot,r)
 end
 
 repeat
  local r=getrnd(rpot)
  placed+=infestroom(r)
  del(rpot,r)
 until #rpot==0 or placed>maxmons[floor]
 
 if placed<minmons[floor] then
  repeat
   local x,y
   repeat
    x,y=flr(rnd(16)),flr(rnd(16))
   until iswalkable(x,y,"checkmobs") and (mget(x,y)==1 or mget(x,y)==4)
   addmob(getrnd(mobpool),x,y)
   placed+=1
  until placed>=minmons[floor]
 end
end

function infestroom(r)
 if r.nospawn then return 0 end
 local target,x,y=2+flr(rnd((r.w*r.h)/6-1))
 target=min(5,target)
 for i=1,target do
  repeat
   x=r.x+flr(rnd(r.w))
   y=r.y+flr(rnd(r.h))
  until iswalkable(x,y,"checkmobs") and (mget(x,y)==1 or mget(x,y)==4)
  addmob(getrnd(mobpool),x,y)
 end
 return target
end

-------------------------
-- items
-------------------------

function takeitem(itm)
 local i=freeinvslot()
 if i==0 then return false end
 inv[i]=itm
 return true
end

function freeinvslot()
 for i=1,6 do
  if not inv[i] then
   return i
  end
 end
 return 0
end

function makeipool()
 ipool_rar={}
 ipool_com={}
 
 for i=1,#itm_name do
  local t=itm_type[i]
  if t=="wep" or t=="arm" then
   add(ipool_rar,i)
  else
   add(ipool_com,i)  
  end
 end
end

function makefipool()
 fipool_rar={}
 fipool_com={}
 
 for i in all(ipool_rar) do
  if itm_minf[i]<=floor 
   and itm_maxf[i]>=floor then
   add(fipool_rar,i)
  end
 end
 for i in all(ipool_com) do
  if itm_minf[i]<=floor 
   and itm_maxf[i]>=floor then
   add(fipool_com,i)
  end
 end
end

function getitm_rar()
 if #fipool_rar>0 then
  local itm=getrnd(fipool_rar)
  del(fipool_rar,itm)
  del(ipool_rar,itm)
  return itm
 else
  return getrnd(fipool_com)
 end
end

function foodnames()
 local fud,fu=explode("cog,gear,lever,pully,bolt,nut,generator,power cell")
 local adj,ad=explode("oily,atomic,grimy,smudged,dangerous,fission,destructive") 

 itm_known={}
 for i=1,#itm_name do
  if itm_type[i]=="fud" then
   fu,ad=getrnd(fud),getrnd(adj)
   del(fud,fu)
   del(adj,ad)
   itm_name[i]=ad.." "..fu
   itm_known[i]=false
  end
 end
end
-->8
--gen

function genfloor(f)
 floor=f
 makefipool()
 mob={}
 add(mob,p_mob)
 fog=blankmap(0)
 if floor==1 then 
  st_steps=0
  --music(0)
 end
 if floor==0 then  
  copymap(16,0)
 elseif floor==winfloor then
  copymap(32,0)
 else
  fog=blankmap(1)
  mapgen()
  unfog()
 end
end


function mapgen()
 
 --todo
 --entry not in an alcove? 

 repeat
  copymap(52,0)
  rooms={}
  roomap=blankmap(0)
  doors={}
  genrooms()
  mazeworm() 
  placeflags()
  carvedoors()
 until #flaglib==1
 
 carvescuts()
 startend()
 fillends()
 prettywalls()

 installdoors()
 
 spawnchests()
 spawnmobs()
 decorooms()
end

----------------
-- rooms
----------------

function genrooms()
 -- tweak dis
 local fmax,rmax=5,4 --5,4?
 local mw,mh=10,10 --5,5?
 
 repeat
  local r=rndroom(mw,mh)
  if placeroom(r) then
   if #rooms==1 then
    mw/=2
    mh/=2
   end
   rmax-=1
  else
   fmax-=1
   --★
   if r.w>r.h then
    mw=max(mw-1,3)
   else
    mh=max(mh-1,3)
   end
  end
 until fmax<=0 or rmax<=0
end

function rndroom(mw,mh)
 --clamp max area
 local _w=3+flr(rnd(mw-2))
 mh=mid(35/_w,3,mh)
 local _h=3+flr(rnd(mh-2))
 return {
  x=0,
  y=0,
  w=_w,
  h=_h
 }
end

function placeroom(r)
 local cand,c={}
 
 for _x=0,16-r.w do
  for _y=0,16-r.h do
   if doesroomfit(r,_x,_y) then
    add(cand,{x=_x,y=_y})
   end
  end
 end
 
 if #cand==0 then return false end
 
 c=getrnd(cand)
 r.x=c.x
 r.y=c.y
 add(rooms,r) 
 for _x=0,r.w-1 do
  for _y=0,r.h-1 do
   mset(_x+r.x,_y+r.y,1)
   roomap[_x+r.x][_y+r.y]=#rooms
  end
 end
 return true
end

function doesroomfit(r,x,y)
 for _x=-1,r.w do
  for _y=-1,r.h do
   if iswalkable(_x+x,_y+y) then
    return false
   end
  end
 end
 
 return true
end

----------------
-- maze
----------------

function mazeworm()
 repeat
  local cand={}
  for _x=0,15 do
   for _y=0,15 do
    if cancarve(_x,_y,false) and not nexttoroom(_x,_y) then
     add(cand,{x=_x,y=_y})
    end
   end
  end
 
  if #cand>0 then
   local c=getrnd(cand)
   digworm(c.x,c.y)
  end
 until #cand<=1
end

function digworm(x,y)
 local dr,stp=1+flr(rnd(4)),0
 
 repeat
  mset(x,y,1)
  if not cancarve(x+dirx[dr],y+diry[dr],false) or (rnd()<0.5 and stp>2) then
   stp=0
   local cand={}
   for i=1,4 do
    if cancarve(x+dirx[i],y+diry[i],false) then
     add(cand,i)
    end
   end
   if #cand==0 then
    dr=8
   else
    dr=getrnd(cand)
   end
  end
  x+=dirx[dr]
  y+=diry[dr]
  stp+=1
 until dr==8 
end

function cancarve(x,y,walk)
 if not inbounds(x,y) then return false end
 local walk= walk==nil and iswalkable(x,y) or walk
 
 if iswalkable(x,y)==walk then
  return sigarray(getsig(x,y),crv_sig,crv_msk)!=0
 end
 return false
end

function bcomp(sig,match,mask)
 local mask=mask and mask or 0
 return bor(sig,mask)==bor(match,mask)
end

function getsig(x,y)
 local sig,digit=0
 for i=1,8 do
  local dx,dy=x+dirx[i],y+diry[i]
  --★
  if iswalkable(dx,dy) then
   digit=0
  else
   digit=1
  end
  sig=bor(sig,shl(digit,8-i))
 end
 return sig
end

function sigarray(sig,arr,marr)
 for i=1,#arr do
  if bcomp(sig,arr[i],marr[i]) then 
   return i
  end
 end
 return 0
end


----------------
-- doorways
----------------

function placeflags()
 local curf=1
 flags,flaglib=blankmap(0),{}
 for _x=0,15 do
  for _y=0,15 do
   if iswalkable(_x,_y) and flags[_x][_y]==0 then
    growflag(_x,_y,curf)
    add(flaglib,curf)
    curf+=1
   end
  end
 end
end

function growflag(_x,_y,flg)
 local cand,candnew={{x=_x,y=_y}}
 flags[_x][_y]=flg
 repeat
  candnew={}
  for c in all(cand) do
   for d=1,4 do
    local dx,dy=c.x+dirx[d],c.y+diry[d]
    if iswalkable(dx,dy) and flags[dx][dy]!=flg then
     flags[dx][dy]=flg
     add(candnew,{x=dx,y=dy})
    end
   end
  end
  cand=candnew
 until #cand==0
end

function carvedoors()
 local x1,y1,x2,y2,found,_f1,_f2,drs=1,1,1,1
 repeat
  drs={}
  for _x=0,15 do
   for _y=0,15 do
    if not iswalkable(_x,_y) then
     local sig=getsig(_x,_y)
     found=false
     if bcomp(sig,0b11000000,0b00001111) then
      x1,y1,x2,y2,found=_x,_y-1,_x,_y+1,true
     elseif bcomp(sig,0b00110000,0b00001111) then
      x1,y1,x2,y2,found=_x+1,_y,_x-1,_y,true
     end
     _f1=flags[x1][y1]
     _f2=flags[x2][y2]
     if found and _f1!=_f2 then
      add(drs,{x=_x,y=_y,f1=_f1,f2=_f2})
     end
    end
   end
  end
  
  if #drs>0 then
   local d=getrnd(drs)
   --★
   add(doors,d)
   mset(d.x,d.y,1)
   growflag(d.x,d.y,d.f1)
   del(flaglib,d.f2)
  end
 until #drs==0
end

function carvescuts()
 local x1,y1,x2,y2,cut,found,drs=1,1,1,1,0
 repeat
  drs={}
  for _x=0,15 do
   for _y=0,15 do
    if not iswalkable(_x,_y) then
     local sig=getsig(_x,_y)
     found=false
     if bcomp(sig,0b11000000,0b00001111) then
      x1,y1,x2,y2,found=_x,_y-1,_x,_y+1,true
     elseif bcomp(sig,0b00110000,0b00001111) then
      x1,y1,x2,y2,found=_x+1,_y,_x-1,_y,true
     end
     if found then
      calcdist(x1,y1)
      if distmap[x2][y2]>20 then
       add(drs,{x=_x,y=_y})
      end
     end
    end
   end
  end
  
  if #drs>0 then
   local d=getrnd(drs)
   add(doors,d)
   mset(d.x,d.y,1)
   cut+=1
  end
 until #drs==0 or cut>=3
end

function fillends()
 local filled,tle
 repeat
  filled=false
  for _x=0,15 do
   for _y=0,15 do
    tle=mget(_x,_y)
    --★
    if cancarve(_x,_y,true) and tle!=14 and tle!=15 then
     filled=true
     mset(_x,_y,2)
    end
   end
  end
 until not filled
end

function isdoor(x,y)
 local sig=getsig(x,y)
 if bcomp(sig,0b11000000,0b00001111) or bcomp(sig,0b00110000,0b00001111) then
  return nexttoroom(x,y)
 end
 return false
end

function nexttoroom(x,y,dirs)
 local dirs = dirs or 4
 for i=1,dirs do
  if inbounds(x+dirx[i],y+diry[i]) and 
     roomap[x+dirx[i]][y+diry[i]]!=0 then
   return true
  end
 end
 return false
end

function installdoors()
 for d in all(doors) do
  local dx,dy=d.x,d.y
  if (mget(dx,dy)==1 
   or mget(dx,dy)==4)
   and isdoor(dx,dy) 
   and not next2tile(dx,dy,13) then
   
   mset(dx,dy,13)
  end
 end
end

----------------
-- decoration
----------------

function startend()
 local high,low,px,py,ex,ey=0,9999
 repeat
  px,py=flr(rnd(16)),flr(rnd(16))
 until iswalkable(px,py)
 calcdist(px,py)
 --★
 for x=0,15 do
  for y=0,15 do
   local tmp=distmap[x][y]
   if iswalkable(x,y) and tmp>high then
    px,py,high=x,y,tmp
   end
  end
 end 
 calcdist(px,py)
 high=0
 for x=0,15 do
  for y=0,15 do
   local tmp=distmap[x][y]
   if tmp>high and cancarve(x,y) then
    ex,ey,high=x,y,tmp
   end
  end
 end
 mset(ex,ey,14)
 
 for x=0,15 do
  for y=0,15 do
   local tmp=distmap[x][y]
   if tmp>=0 then
    local score=starscore(x,y)
    tmp=tmp-score
    if tmp<low and score>=0 then
     px,py,low=x,y,tmp
    end
   end
  end
 end
 
 if roomap[px][py]>0 then
  rooms[roomap[px][py]].nospawn=true
 end
 mset(px,py,15)
 p_mob.x,p_mob.y=px,py
end

function starscore(x,y)
 if roomap[x][y]==0 then
  if nexttoroom(x,y,8) then return -1 end
  if freestanding(x,y)>0 then
   return 5
  else
   if (cancarve(x,y)) return 0
  end
 else
  local scr=freestanding(x,y)
  if scr>0 then
   return scr<=8 and 3 or 0
  end
 end
 return -1
end

function next2tile(_x,_y,tle)
 for i=1,4 do
  if inbounds(_x+dirx[i],_y+diry[i]) and mget(_x+dirx[i],_y+diry[i])==tle then
   return true
  end
 end
 return false
end

function prettywalls()
 for x=0,15 do
  for y=0,15 do
   local tle=mget(x,y)
   if tle==2 then
    local ntle=sigarray(getsig(x,y),wall_sig,wall_msk)
    tle = ntle==0 and 3 or 15+ntle
    mset(x,y,tle)
   elseif tle==1 then
    if not iswalkable(x,y-1) then
     mset(x,y,4)
    end
   end
  end
 end
end

function decorooms()
 tarr_dirt=explodeval("1,74,75,76")
 tarr_farn=explodeval("1,70,70,70,71,71,71,72,73,74")
 tarr_vase=explodeval("1,1,7,8")
 local funcs,func,rpot={
  deco_dirt,
  deco_torch,
  deco_carpet,
  deco_farn,
  deco_vase
 },deco_vase,{}

 for r in all(rooms) do
  add(rpot,r)
 end

 repeat
  local r=getrnd(rpot)
  del(rpot,r)
  for x=0,r.w-1 do
   for y=r.h-1,1,-1 do
    if mget(r.x+x,r.y+y)==1 then
     func(r,r.x+x,r.y+y,x,y)
    end
   end
  end
  func=getrnd(funcs)
 until #rpot==0
end

function deco_torch(r,tx,ty,x,y)
 if rnd(3)>1 and y%2==1 and not next2tile(tx,ty,13) then
  if x==0 then
   mset(tx,ty,64)
  elseif x==r.w-1 then
   mset(tx,ty,66)
  end
 end
end

function deco_carpet(r,tx,ty,x,y)
 deco_torch(r,tx,ty,x,y)
 if x>0 and y>0 and x<r.w-1 and y<r.h-1 then
  mset(tx,ty,68)
 end
end

function deco_dirt(r,tx,ty,x,y)
 mset(tx,ty,getrnd(tarr_dirt))
end

function deco_farn(r,tx,ty,x,y)
 mset(tx,ty,getrnd(tarr_farn))
end

function deco_vase(r,tx,ty,x,y)
 if iswalkable(tx,ty,"checkmobs") and 
    not next2tile(tx,ty,13) and
    not bcomp(getsig(tx,ty),0,0b00001111) then
   
  mset(tx,ty,getrnd(tarr_vase))
 end
end

function spawnchests()
 local chestdice,rpot,rare,place=explodeval("0,1,1,1,2,3"),{},true
 place=getrnd(chestdice)
 
 for r in all(rooms) do
  add(rpot,r)
 end
 
 while place>0 and #rpot>0 do
  local r=getrnd(rpot)
  placechest(r,rare)
  rare=false
  place-=1
  del(rpot,r)
 end
end

function placechest(r,rare)
 local x,y
 repeat
  x=r.x+flr(rnd(r.w-2))+1
  y=r.y+flr(rnd(r.h-2))+1
 until mget(x,y)==1
 mset(x,y,rare and 12 or 10)
end

function freestanding(x,y)
 return sigarray(getsig(x,y),free_sig,free_msk)
end
__gfx__
000000000000000055555550000000005555555055555550000cc00000777000007770000000000000000000000000000077700050505050d000000066666660
0000000000000000bbbbbbb000000000bbbbbbb05000005000cc0c0007000700070007000777777007777770777777707677767006666600d0dd000000000000
007007000000000055555550000000005555555050000050000cc00007000700070007000700007007555570700000707666667056666650d0dd0dd066000000
00077000000000005bbbbb5000000000000000005000005055566555007770006b777b60070000700755557070000070766766700566650000dd0dd066066000
0007700000000000555555500000000000000000500000505000000506bbb60066bbb6600777777007766770777777707770777056555650d0000dd066066060
0070070000060000bbbbbbb00000000000060000500000500089ab00066b6600066666000000000000000000000000000000000006666600d0dd000066066060
0000000000000000555555500000000000000000555555505000000500666000006660000555555005555550555555505555555056666650d0dd0dd066066060
00000000000000000000000000000000000000000000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000055555550555555505555555055555550555555505550555055555550000055505550000055555550000055500000555055500000
00000000000000000000000055555550555555505555555055555550555555505550555055555550000055505550000055555550000055500000555055500000
00000000000000000000000055555550555555505555555055555550555555505550555055555550000055505550000055555550000055500000555055500000
00000000000000000000000055500000000055505550000055505550000055505550000000000000000000000000000000000000000055500000000055500000
00005550555555505550000055500000000055505550555055505550555055505550555055505550555055505550555000005550555055505555555055505550
00005550555555505550000055500000000055505550555055505550555055505550555055505550555055505550555000005550555055505555555055505550
00005550555555505550000055500000000055505550555055505550555055505550555055505550555055505550555000005550555055505555555055505550
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005550055555005550000055500000000055505555555055505550555555505550555055505550555055505550555055505550555000005550555055555550
00005550555555505550000055500000000055505555555055505550555555505550555055505550555055505550555055505550555000005550555055555550
00005550555555505550000055500000000055505555555055505550555555505550555055505550555055505550555055505550555000005550555055555550
00005550555055505550000055500000000055505550000000000000000055500000000000005550000000000000000055500000000000000000555000000000
00005550555555505550000055555550555555505555555055505550555555505555555055505550000055505550000055500000555555500000555055500000
00005550555555505550000055555550555555505555555055505550555555505555555055505550000055505550000055500000555555500000555055500000
00005550055555005550000055555550555555505555555055505550555555505555555055505550000055505550000055500000555555500000555055500000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000555055555550555000005555555055505550555055505550555055505550000055505550000000005550000000005550555055500000a000000088000088
0000555055555550555000005555555055505550555055505550555055505550000055505550000000005550000000005550555055500000a0aa000080000008
0000555055555550555000005555555055505550555055505550555055505550000055505550000000005550000000005550555055500000a0aa0aa000000000
000000000000000000000000000000005550555055500000555055500000555000000000000000000000000000000000000000000000000000aa0aa000000000
0000000000000000000000005555555055505550555555505555555055555550555000000000555000005550555055500000000055500000a0000aa000000000
0000000000000000000000005555555055505550555555505555555055555550555000000000555000005550555055500000000055500000a0aa000000000000
0000000000000000000000005555555055505550555555505555555055555550555000000000555000005550555055500000000055500000a0aa0aa080000008
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088000088
0a0000000000000000000a0000000000101010105555555000000000000bb00000000000c0c000c0050000000000000000000000000000000000000000000000
a00000000a000000000000a000000a0000000000bbbbbbb000500b00000000500c0000c0c00000005b5005000500060000600000000000000000000000000000
aa000000aa00000000000aa000000aa0101010105555555000050000066005000c0000c0000c000005005b505b50660000000b00000000000000000000000000
0000000000000000000000000000000000000000000000000b05000066605000000c0000000c00c0000005000500000006000000000000000000000000000000
550000005500000000000550000005501010101010101010000050b0000050b0000c0c00000000c0000500000000050000066000000000000000000000000000
00060000000600000006000000060000000000000000000000b05000000500000c0c0c00c00000c0005b500006605b5000600600000000000000000000000000
50000000500000000000005000000050101010101010101000005000000500000c000000c0c000c0000500006660050000666000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000
cc7777cc7777ccccccccccccccccccccc77777777ccccccccccccccccccccccc77cccc0000000000000000000000000000500000000000000000000000000000
ccc77cccc77ccccccccccccccccccccccc77cccc77cccccccccccccccccccccc77cccc00000000000000000000000000055222e0000000000000000000000000
cccc77cc77cc77777cc7777cc7777ccccc77ccccc77cc7777777c7777777cccc77cccc00000000000000000000000000056eee00000000000000000000000000
ccccc7777cc77ccc77cc77cccc77cccccc77cccccc77cc77ccc7cc77ccc77ccc77cccc0000000000000000000000000000600000000000000000000000000000
ccccc7777c77ccccc77c77cccc77cccccc77cccccc77cc77cccccc77cccc77cc77cccc0000000000000000000000000000000000000000000000000000000000
cccccc77cc77ccccc77c77cccc77cccccc77cccccc77cc77777ccc77cccc77cc77cccc0000000000000000000000000000000000000000000000000000000000
cccccc77cc77ccccc77c77cccc77cccccc77cccccc77cc77cccccc77cccc77cc77cccc0000000000000000000000000000000000000000000000000000000000
cccccc77cc77ccccc77c77cccc77cccccc77ccccc77ccc77cccccc77cccc77cc77cccc0000000000000000000000000000000000000000000000000000000000
cccccc77ccc77ccc77ccc77cc77ccccccc77cccc77cccc77ccc7cc77ccc77ccccccccc0000000000000000000000000000000000000000000000000000000000
ccccc7777ccc77777ccccc7777ccccccc77777777cccc7777777c7777777cccc77cccc0000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000
cc7777cc7777cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000
ccc77cccc77cccccccccccccccccccccc77cccccccccc77ccccccccccccccccc77cccc0000000000000000000000000000000000000000000000000000000000
cccc77cc77cc77777cc7777cc7777ccccc77cccccccc77cccccccccccccccccc77cccc0000000000000000000000000000000000000000000000000000000000
ccccc7777cc77ccc77cc77cccc77cccccc77cccccccc77cc7777cc77ccc77ccc77cccc0000000000000000000000000000000000000000000000000000000000
ccccc7777c77ccccc77c77cccc77cccccc77cc7777cc77ccc77ccc77ccc77ccc77cccc0000000000000000000000000000000000000000000000000000000000
cccccc77cc77ccccc77c77cccc77cccccc77ccc77ccc77ccc77ccc777cc77ccc77cccc0000000000000000000000000000000000000000000000000000000000
cccccc77cc77ccccc77c77cccc77cccccc77ccc77ccc77ccc77ccc77c7c77ccc77cccc0000000000000000000000000000000000000000000000000000000000
cccccc77cc77ccccc77c77cccc77ccccccc77c7777c77cccc77ccc77cc777ccc77cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccc77ccc77ccc77ccc77cc77ccccccccc777cc777cccc7777cc77ccc77ccc77cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccc7777ccc77777ccccc7777cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc77cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccc000000000000000ccc000000ccc0000000000000cccc000000ccc00000000000000000cccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccc066666606666660ccc066660ccc0666606666660cccc066660ccc06666666606666660cccccccccccccccccccccccccccccccccccccccc
cccccccccccccccc000666666066666600000666600000666606666660cc0006666000006666666606666660cccccccccccccccccccccccccccccccccccccccc
cccccccccccccccc066000000066000066066000066066000006600000cc0660000660660000000006600000cccccccccccccccccccccccccccccccccccccccc
cccccccccccccccc06600000c0660000660660000660660ccc066000cccc0660000660660ccccccc066000cccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccc00066660c0666666000666666660660ccc066660cccc0666666660660ccccccc066660cccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccc066660006666660c0666666660660ccc066660cccc0666666660660cccc000066660cccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccc000006606600000c0660000660660ccc066000cccc0660000660660cccc066066000cccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccc0000000660660ccccc0660cc066066000006600000cc0660cc0660660000006606600000cccccccccccccccccccccccccccccccccccccccc
cccccccccccccccc0666666000660ccccc0660cc066000666606666660cc0660cc0660006666660006666660cccccccccccccccccccccccccccccccccccccccc
cccccccccccccccc06666660c0660ccccc0660cc0660c0666606666660cc0660cc0660c06666660c06666660cccccccccccccccccccccccccccccccccccccccc
cccccccccccccccc00000000c0000ccccc0000cc0000c0000000000000cc0000cc0000c00000000c00000000cccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03cbbc0003cbbc0003cbbc0003cbbc000002222000000000000222200000000070cccc0770cccc0770cccc0770cccc0700999000000000000099900000000000
3cccccc03cccccc03cccccc03cccccc000227b720002222000227b72000222207cccddd77cccddd77cccddd77cccddd709999900009990000999990000999000
3bc333303bc333303bc333303bc3333002227b7200227b7202227b7200227b720ccd7b700ccd7b700ccd7b700ccd7b70097d790009999900097d790009999900
03c67d7003c67d7003c67d7003c67d7002b2636202227b7202b2636202227b720ccc7b700ccc7b700ccc7b700ccc7b70097d7900097d7900097d7900097d7900
00c36d6000c36d6000c36d6000c36d6022b0222002b2636222b0222002b2636200cd7b7000cd7b7000cd7b7000cd7b7009999900097d790009999900097d7900
03cc333003cc333003cc333003cc333002bb000022b0222002bb000022b0222000ccddd000ccddd000ccddd000ccddd0f99999f0f99999f0f99999f0f99999f0
033ccccc033ccccc033ccccc033ccccc022b200002bb0000022b200002bb000000dcccc000dcccc000dcccc000dcccc0ff999ff0ff999ff0ff999ff0ff999ff0
030c030c0030c03c030c030c0030c03c2222200022222000222220002222200000d000d0000ddd0000d000d0000ddd0000fff00000fff00000fff00000fff000
00cccc0000cccc0000cccc0000cccc0000000000000000000000000000000000027d7200027d7200027d7200027d7200ee000000ee000000ee000000ee000000
0cccccc00cccccc00cccccc00cccccc0007a70000007a700007a70000007a70027c0772027c0772027c0772027c077200ee222000ee222000ee222000ee22200
cccc4c40cccc4c40cccc4c40cccc4c400790770000790770079077000079077026d0c62026d0c62026d0c62026d0c6200e2227700e2227700e2227700e222770
ccc7ccc7ccc7ccc7ccc7ccc7ccc7ccc707a0a700007a0a7007a0a700007a0a70026c6200026c6200026c6200026c620002227c0c02227c0c02227c0c02227c0c
0cc711170cc711170cc711170cc711170f797f0000f797f00f797f0000f797f00e0e0e000e0e0e000e0e0e000e0e0e0002226c0c02226c0c02226c0c02226c0c
00cc717000cc717000cc717000cc717000fff000000fff0000fff000000fff00e00e00e0e00e00e0e00e00e0e00e00e000222670002226700022267000222670
00dcccc000dcccc000dcccc000dcccc000082000000082000008200000008200e000e0e0e0e000e0e000e0e0e000e0e002e222e0022e22ee02e222e0022e22ee
00d000d0000ddd0000d000d0000ddd00000082000008200000008200000820000e0e0e00e00e000e0e0e0e000e0e00e02ee220ee22ee200e2ee220ee22ee200e
00000000000000000000000000000000006666000066660000666600006666000677000006770000067700000677000000000000000000000000000000000000
00677600006776000067760000677600069779600697796006977960069779606000c0006000c0006000c0006000c00000000000000000000000000000000000
067aa760067aa760067aa760067aa760067777600677776006777760067777606000000060000000600000006000000000000000000000000000000000000000
07a88a7007a88a7007a88a7007a88a70669779666697796666977966669779666000500560005005600050056000500500000000000000000000000000000000
007aa700007aa700007aa700007aa700766666077666660776666607766666076600577766005777660057776600577700000000000000000000000000000000
706776070767760770677607706776707006660770666007700666077066600766777c6c66777c6c66777c6c66777c6c00000000000000000000000000000000
76700767076707677670076776707670700660077006600770066007700660070667777706677777066777770667777700000000000000000000000000000000
a0a00a0a0a0a0a0aa0a00a0aa0a0a0a0070600700700607007060070070060700505050500505050050505050050505000000000000000000000000000000000
00222000002220000022200000222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02e7720002e7720002e7720002e77200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02eee20002eee20002eee20002eee200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02eee20002eee20002eee20002eee200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d2ee20d0d2ee2d00d2ee20d0d2ee2d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5dd22d505dd225005dd22d505dd22500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05ddd50d05ddd5d005ddd50d05ddd5d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d000d0000ddd0000d000d0000ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000050500050303070103010307020005050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505000000000000000004040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000001011111111111200000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000002002020202022200000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000101112000000000000001011111111111d02050205022200000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000101111240e23111112000000002002020202023404040404042200000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002002050244020502220000000020020502050234014d4e4f012200000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000200404454445040422000000002004455b450434405d5e5f432200000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000204a01444444010122000000002021446b6c2134016d6e6f012200000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002040014406440143220000000020404444444334407d7e7f422200000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002001014444444b012200000000205a010101013401010101012200000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000020010101010101012200000000206959014b010d01010101012200000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000200701010101010722000000003031313131312e01010101012200000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000200807010101080822000000000000000000003014010f01133200000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000303131140f13313132000000000000000000000030313131320000000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000303132000000000000000000000000000000000000000000000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
001600000217502705021150200002135000000210402104021250000002105000000215500000000000211401175017050111500105011350010500105001050112500105001050010501135001000000000000
00160000215101d510195251a535215351d520195151a5152151221515215252252521525215150e51511515205141c510195251c535205351c520195151c5152051220515205252152520525205150d51510515
0016000000000215101d510195151a515215151d510195151a5152151221515215152251521515215150e51511515205141c510195151c515205151c510195151c5152051220515205152151520515205150d515
00160000150051d00515015150151a0251a0151d0151d015220252201521025210151d0251d0151502515015140201402214025140151400514004140050d000100140c0100d0201003014030150201401210015
001600000217502705021150200002135000000000000000021250000000000000000215500000000000211405175001050511500105051350010500105001050512500105001050010505135000000000000000
00160000215141d510195251a525215251d520195151a5152151221515215202252021525215150e52511515205141d5101852519525205251d520185151951520512205151c5201d52020525205151052511515
0016000000000215141d510195151a515215151d510195151a5152151221515215102251021515215150e51511515205141d5101851519515205151d510185151951520512205151c5101d510205152051510515
00160000000002000015015150151a0251a0151d0251d015220252201521015210151d0251d01526015260152502025012250152501518000000000000000000100000d02011030140401505014040190301d010
001600000717502005071150200007135000000000000000071250000000000000000715500000000000711403175001050311500105031350010500105001050312500105001050010503155000000000000000
00160000091750200509115020000913500000000000000009125000000000000000091550000000000091140a175001050a115001050a1250010504105001050a125001050910500105041350c1000912500100
00160000225121f5201a5251f515225251f5201a5151f515215122151222525215251f5251f5150e52513515225141f5101b5251f525225251f5201b5151f515215122151222525215251f5251f5150f52513515
00160000215141c510195251d515215251c520195151d5152151222510215201f51021512215150d52510515205141d5101a52516515205151d5201a5151651520522205151d515205251f5251d5151c52519515
0016000000000225121f5101a5151f515225151f5101a5151f515215122151222515215151f5151f5150e51513515225141f5101b5151f515225151f5101b5151f515215122151222515215151f5151f5150f515
0016000000000215141c510195151d515215151c510195151d5152151222510215101f51021510215150d51510515205141d5101a51516515205151d5101a5152051520510205151d515205151f5151d5151c515
00160000000000000022015220151f0251f0151a0151a01522025220151f0151f01519020190221a0251a0151f0201f0221f0151f01518000000000000000000000000f010130201603015030160321502013015
001600001902519015220252201521015210151c0251c015220252201521025210151c0221c0151d0251d01520020200222001520015110051a0151d015220152601226012280102601625010250122501025015
001600000217509035110150203502135090351101502104021250000002105000000212511035110150211401175080351001501035011350803510015001050112500105001050010501135100351001500000
0016000002175090351101502035021350903511015021040212500000021050000002155110351101502114051750c0351401505035051350c03514015001050512500105001050010505135140351401500000
00160000071750e0351601507035071350e0351601502104071250000002105000000715516035160150711403175160351301503035031351603513015001050312500105001050010503135160351601500000
0016000009175100351101509035091351003511015021040912500000021050000009155100350d015091140a17510035110150a0350a1351003511015001050a12500105001050010509135150350d01509020
0016000002215020451a7051a7050e70511705117050e7050e71511725117250e7250e53511535115450e12501215010451a6001a70001205012051a3001a2001071514725147251072510535155351554514515
0016000002215020451a7051a7050e70511705117050e7050e71511725117250e7250e53511535115450e12505215050451a6001a70001205012051a3001a2001171514725147251172511535195351954518515
0016000007215070451a7051a7050e70511705117050e705137151672516725137251353516535165451312503215030451a6001a70001205012051a3001a2001371516725167250d7250f535165351654513515
0016000009215090451a7051a7050e70511705117050e7050d715157251572510725115351653516545157250a2150a0451a6001a70001205012051a3001a2000e71510725117250e7250d5350e5351154510515
0016000021005210051d00515015150151a0151a0151d0151d015220152201521015210151d0151d01515015150151401014012140151401518000000000000000000100100c0100d01010010140101501014010
0016000000000000002000015015150151a0151a0151d0151d015220152201521015210151d0151a01526015260152501019015190151900518000000000000000000000000d0101101014010150101401019010
0016000000000000000000022015220151f0151f0151a0151a01522015220151f0151f01519010190121a0151a0151f0101f012130151300518000000000000000000000000f0101301016010150101601215010
00160000190051901519015220152201521015210151c0151c015220152201521015210151c0121c0151d0151d015200102001220015200051d0051a015220152901029012260102801628010280122801528005
00160000097140e720117300e730097250e7251173502735057240e725117350e735097450e7401174002740087400d740107200d720087350d7351072501725047240d725107250d725087350d7301074001740
00160000097240e720117300e730097450e745117350e735117240e725117350e735097450e740117400e740087400d740117200d720087350d735117250d725117240d725117250d725087350d730117400d740
001600000a7240e720137300e7300a7450e745137350e735137240e725137350e7350a7450e740137400e7400a7400f740137200f7200a7350f735137250f725137240f725137250f7250a7350f730137400f740
0016000010724097201073009730107450974510735097351072409725107350973510745097401074009740117400e740117200e720117350e735117250e725117240e725117250e725097350d730107400d740
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0013000029700297002670026700257002570022700227000000026700217000e7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001300000255011555165501555016555115550d5500a5500e5500e5520e5520e5521400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001300001170015700197001a700117001670019700197001a7001a70025700257002570025700257002570025700197021970219702000000000000000000000000000000000000000000000000000000000000
001300000d2200c2200b220154000000000000000000000029720287302672626745287402173029720217322673026732267350210526702267020e705021050000000000000000000000000000000000000000
0013000000000000000000000000000000000000000000000e1100d1200a1300e1350d135091000a120091300e1220e1200e1200e1000e1020e10200000000000000000000000000000000000000000000000000
0013000000000000000000000000000000000000000000000a14300000000000a060090600a000090000900002072020720207202005020020200500000000000000000000000000000000000000000000000000
001200001b0001f0002200023000220001f0002000022000230002700023000200001f000200001f0001b0001f00022000200002200023000270001d000200001f0001f0001f0001f00000000000000000000000
001200001f5001f5001b5001b50022500225002350023500225002250020500205001f5001f500205002050022500225002350023500255002550023500235002250022500225002250000000000000000000000
00120000030000300003000130000700007000080000800008000170000b0000b0000a0000a0000a0000f00003000030000800008000080001100005000050000300003000030000300003000030000300000000
001200001e0201e0201e032210401a0401e0401f0301f0321f0301f0301e0201e0201f0201f020210302103022030220322902029020290222902228020280202602026020260222602200000000000000000000
001200001a7041a70415534155301a5321a5301c5401c5401c5451a540155401554516532165301a5301a5351f5401f54522544225402254222545215341f5301e5441e5401e5421e54500000000000000000000
00120000110250e000120351500015045150000e0550e00512045150051503515005130251500516035260051a0452100513045210051604526005100251f0050e0500e0520e0520e0500c000000000000000000
0002000031530315302d500315003b5303b5302e5000050031530315302e5002d50039530395302d5000050031530315303153031530315203152000500005000050000500005000050000500005000050000500
000100003101031010300102f0102d0202c0202a02028030270302503023050210501e0501d0501b05018050160501405012050120301103011010110100e0100b01007010000000000000000000000000000000
00010000240102e0202b0202602021010210101a01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000024010337203372033720277103a7103a71000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030000096201163005620056150160000600006001160011600116001160001620006200a6100a6050a6000a6000f6000f6000f6000f6000060000600026100261002615016000160005600056000160001600
00010000145201a520015000150001500015000150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000211102114015140271300f6300f6101c610196001761016600156100f6000c61009600076000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001b61006540065401963018630116100e6100c610096100861000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001f5302b5302e5302e5303250032500395002751027510285102a510005000050000500275102951029510005000050000500005002451024510245102751029510005000050000500005000050000500
0001000024030240301c0301c0302a2302823025210212101e2101b2101b21016210112100d2100a2100a2100a2100a2100a2100a2100a2100a2100a2100a2100a2100a2100a2100a2100a2100a2100020000200
0001000024030240301c0301c03039010390103a0103001030010300102d010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000210302703025040230301a030190100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000d720137200d7100c40031200312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 00031844
00 04071943
00 080e1a47
00 090f1b4e
00 1001024f
00 11050643
00 120a0c47
00 130b0d4e
00 001c034f
00 041e0744
00 081e0e44
00 091f0f44
00 00144f44
00 04155c44
00 08165d44
02 13175e44
02 53575f44
00 41424344
00 41424344
00 41424344
00 41424344
00 2a2b2c44
04 6a6b6c44
00 30313244
04 70717244
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
03 00424344

