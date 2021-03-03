pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
 t=0
 
 dpal=explodeval("0,1,1,2,1,13,6,4,4,9,3,13,1,13,14")
 
 dirx=explodeval("-1,1,0,0,1,1,-1,-1")
 diry=explodeval("0,0,-1,1,-1,1,1,-1")
 
 itm_name=explode("classic barrel,shot gun,ak-47,homeing missile,the big one,final barrel,holed steel,copper,steel,iron,iron plates,final plates,food 1,food 2,food 3,food 4,food 5,food 6,amo,missile,grenade,crusher")
	itm_type=explode("wep,wep,wep,wep,wep,wep,arm,arm,arm,arm,arm,arm,fud,fud,fud,fud,fud,fud,thr,thr,thr,thr")
	itm_stat1=explodeval("1,2,3,4,5,6,0,0,0,1,2,3,1,2,3,4,5,6,1,2,4,6")
	itm_stat2=explodeval("0,0,0,0,0,0,1,2,3,4,5,6,0,0,0,0,0,0,0,0,0,0")
	itm_minf=explodeval("1,2,3,4,5,6,1,2,3,4,5,6,1,1,1,1,1,1,1,2,4,6")
	itm_minf=explodeval("3,4,5,6,7,8,3,4,5,6,7,8,8,8,8,8,8,8,3,4,6,8")
	itm_desc=explode(",,,,,,,,,,,,heals,heals alot,increases hp,is blessed,is cursed,stuns,,,,")

	mob_name=explode("player,soldier,riot,scout,drone,jet-pack,beetle,sniper,heavy")
	mob_ani=explodeval("240,192,196,200,204,208,212,216,220")
	mob_atk=explodeval("1,1,1,2,4,5,4,5,5")
	mob_hp=explodeval("5,1,2,3,4,10,6,7,8")
	mob_los=explodeval("4,4,4,4,4,4,4,4,4")
	mob_minf=explodeval("0,1,2,3,4,5,6,7,8")
	mob_maxf=explodeval("0,3,4,5,6,7,8,8,8")
	mob_spec=explode(",,,,,,stun,,slow") 
 
	crv_sig=explodeval("255,214,124,179,233")
 crv_msk=explodeval("0,9,3,12,6")

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
	poke(0x3101,194)
	music(5)
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
   talkwind.dur=0
   talkwind=nil
  end
 else
  dobuttbuff()
  dobutt(buttbuff)
  buttbuff=-1
 end
end

function update_inv()
 --inventory
 move_mnu(curwind)
 if btnp(4) then
  if curwind==invwind then
   _upd=update_game
   invwind.dur=0
   statwind.dur=0
  --★
  elseif curwind==usewind then
   usewind.dur=0
   curwind=invwind
  end
 elseif btnp(5) then
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
 if btnp(2) then
  wnd.cur-=1
 elseif btnp(3) then
  wnd.cur+=1
 end
 wnd.cur=(wnd.cur-1)%#wnd.txt+1
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
 elseif butt==4 then
 	win=true
 	--p_mob.hp=0
  --genfloor(floor+1)
  --prettywalls()
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
  if sin(time()*8)>0 then
   drawmob(m)
  end
  m.dur-=1
  if m.dur<=0 then
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
		spr(144,0,logo_y,14,3)
		palt()
		oprint8("the quest of light",19,logo_y+20,7,0)
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
 print("you died",50,50,7)
end

function draw_win()
 cls(2)
 print("you win",50,50,7)
end]]--

function draw_gover()
	cls()
	palt(12,true)
	spr(gover_spr,gover_x,30,gover_w,2)
	palt()
	color(5)
	cursor(44,50)
	if not win then
		--sfx(42)
		print("killed by a "..st_killer,44,40,6)
	end
	print("floor: "..floor)
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
-->8
--gameplay

function moveplayer(dx,dy)
 local destx,desty=p_mob.x+dx,p_mob.y+dy
 local tle=mget(destx,desty)
  
 if iswalkable(destx,desty,"checkmobs") then
  sfx(63)
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
   sfx(58)
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
  sfx(59)
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
   sfx(61)
   mset(destx,desty,tle-1)
   takeitem(itm)
   showmsg(itm_name[itm].."!",60)
  end
 elseif tle==13 then
  --door
  sfx(62)
  mset(destx,desty,1)
 elseif tle==6 then
  --stone tablet
  if floor==0 then
   showtalk({"welcome to", "knightcrawler!","","climb this tower", "to obtain the ultimate","power of", "the sword of light!",""})
		end
 elseif tle==94 then
 --sword of light
  win=true
 elseif tle==107 then
 --lost
 showtalk({"hello traveler","i see you have","climbed this tower,","and you are the first,","many have tried","but none have","gotten here","","-the gaurdian",""})
 end
end

function trig_step()
 local tle=mget(p_mob.x,p_mob.y)

 
 if tle==14 then
 	sfx(55)
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
end

function stunmob(mb)
 mb.stun=true
 mb.flash=10
 
 addfloat("stun",mb.x*8-3,mb.y*8,7)
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
end

function checkend()
 --★
 if win then
  wind={}  
  gover_spr=112
  gover_x=28
  gover_w=13
  _upd=update_gover
  _drw=draw_gover
  fadeout(0.02) 
  return false
 elseif p_mob.hp<=0 then
  wind={}
  gover_spr=80
  gover_x=28
  gover_w=9
  _upd=update_gover
  _drw=draw_gover
  fadeout(0.02)
  return false
 end
 return true
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
 
 showmsg(itm_name[itm]..itm_desc[itm],120)
 
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

 if inbounds(tx,ty) then
  local mb=getmob(tx,ty)
  if mb then
   if itm_type[itm]=="fud" then
    eat(itm,mb)
   else
    hitmob(nil,mb,itm_stat1[itm])
    sfx(58)
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
 else
  invwind.dur=0
  statwind.dur=0
 end
end

function floormsg()
 showmsg("floor "..floor,120)
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
  sfx(57)
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
 local target,x,y=2+flr(rnd((r.w*r.h)/6-1))
 target=min(5,target)
 for i=1,target do
  repeat
   x=r.x+flr(rnd(r.w))
   y=r.y+flr(rnd(r.h))
  until iswalkable(x,y,"checkmobs")
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
 local fud,fu=explode("med-pack,oil,gears,photon engine,atomic captsle,radio,amo case,lunchbox")

 for i=1,#itm_name do
  if itm_type[i]=="fud" then
   fu=getrnd(fud)
   del(ful,fu)
   itm_name[i]=fu
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
 if	floor==1 then st_steps=0 end
 if floor==0 then  
  copymap(16,0)
 elseif floor==winfloor then
  copymap(32,0)
 else
  fog=blankmap(0)
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
	 if #flaglib>1 then
	 	debug[1]="reconnected area"
	 end
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

--★
function snapshot()
 return
 --[[cls()
 map()
 for i=0,1 do
  flip()
 end]]
end

----------------
-- rooms
----------------

function genrooms()
 -- tweak dis
 local fmax,rmax=5,4 --5,4?
 local mw,mh=6,6     --5,5?
 
 repeat
  --todo: 1st room bigger?
  local r=rndroom(mw,mh)
  if placeroom(r) then
   rmax-=1
   snapshot()
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
 --debug[1]="fails: "..fmax
 --debug[2]="rooms: "..rmax
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
  snapshot()
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
  local sig=getsig(x,y)
  for i=1,#crv_sig do
   if bcomp(sig,crv_sig[i],crv_msk[i]) then 
    return true 
   end
  end
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
      add(drs,{x=_x,y=_y,f=_f1,f2=_f2})
     end
    end
   end
  end
  
  if #drs>0 then
   local d=getrnd(drs)
   --★
   add(doors,d)
   mset(d.x,d.y,1)
   snapshot()
   growflag(d.x,d.y,d.f) 
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
   snapshot()
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
     snapshot()
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

function nexttoroom(x,y)
 for i=1,4 do
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
   if tmp>=0 and tmp<low and cancarve(x,y) then
    px,py,low=x,y,tmp
   end
  end
 end  
 --★
 mset(px,py,15)
 p_mob.x=px
 p_mob.y=py
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
    local sig,tle=getsig(x,y),3
    for i=1,#wall_sig do
     if bcomp(sig,wall_sig[i],wall_msk[i]) then
      tle=i+15
      break
     end
    end
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
 local funcs,func={
  deco_dirt,
  deco_torch,
  deco_carpet,
  deco_farn,
  deco_vase
 },deco_vase

 for r in all(rooms) do  
  for x=0,r.w-1 do
   for y=r.h-1,1,-1 do
    if mget(r.x+x,r.y+y)==1 then
     func(r,r.x+x,r.y+y,x,y)
    end
   end
  end
  func=getrnd(funcs)
 end
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
 local x,y=10
 repeat
  x=r.x+flr(rnd(r.w-2))+1
  y=r.y+flr(rnd(r.h-2))+1
 until mget(x,y)==1
 --6168
 local tle=rare and 12 or 10
 mset(x,y,tle)
end
__gfx__
0000000000000000fffffff000000000f4f4f4f0f4f4f4f005000000444990006666777000000000000000000000000000aaa00066b68660050a0500aa55aa50
00000000000000004f4f4f40000000009f9f9f90455555400600050066666000666767700666660006666600333333303baaab306555556040505040aa55aa50
0070070000000000f4f4f4f00000000099999990f55555f00600060044949000666677700612360006787600359667303bbbbb3065555560455a5540aaaaaa50
00077000000000004f4f4f40000000000000000045550040555555504449900055676550069ab60006888600399596303bb6bb306d555d60455a5540aaaaaa50
0007700000000000f4f4f4f00000000000000000f55000f05dd585504494900066555770068ce60006787600333333303336333065ddd56045555540aa55aa50
00700700000400009f9f9f900000000000040000950000905dd55b5066666000666767700000000000000000000000000000000065555560455a5540aa55aa50
0000000000000000999999900000000000000000999999905555555044949000666677700777770007777700555555505555555065555560455a554055555550
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000009999990999999000999999009999900999999009ff0ff90999999900000ff909ff000009ff000000000ff900000ff909ff00000
00000000000000000000000099f9f9f0f9f9f99099f9f9f099f9f990f9f9f99099f0fff0f9f9f9f00000fff0fff0000099f000000000f9900000fff099f00000
0000000000000000000000009ffffff0ffffff909ffffff09fffff90ffffff909ff00ff0fffffff000000ff0ff0000009ff000000000ff9000000ff09ff00000
00000000000000000000000099f000000000f99099f0000099f0f9900000f99099f0000000000000000000000000000099f000000000f9900000000099f00000
00000ff0fffffff0ff0000009ff000000000ff909ff00ff09ff0ff90ff00ff909ff00ff0ff000ff0ff000ff0ff000ff09ff00ff0ff00ff90fffffff09ff00ff0
0000fff0f9f9f9f0fff0000099f000000000f99099f0fff099f0f990fff0f99099f0fff0fff0fff0fff0fff0fff0fff099f0fff0fff0f990f9f9f9f099f0fff0
0000ff90999999909ff000009ff000000000ff909ff0ff909ff0ff909ff0ff909ff0ff909ff0ff909ff0ff909ff0ff909ff0ff909ff0ff90999999909ff0ff90
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ff90099999009ff000009ff000000000ff90099999909ff0ff90999999009ff0ff909ff0ff909ff0ff909ff0ff909ff0ff909ff000000000ff9099999990
0000f99099f9f99099f0000099f000000000f99099f9f9f0fff0fff0f9f9f990fff0fff0fff0f990fff0fff0fff0fff099f0fff0fff000000000f990f9f9f9f0
0000ff909fffff909ff000009ff000000000ff909ffffff0ff000ff0ffffff90ff000ff0ff00ff90ff000ff0ff000ff09ff00ff0ff0000000000ff90fffffff0
0000f99099f0f99099f0000099f000000000f99099f00000000000000000f990000000000000f990000000000000000099f00000000000000000f99000000000
0000ff909fffff909ff000009ffffff0ffffff909ffffff0ff000ff0ffffff90fffffff0ff00ff9000000ff0ff0000009ff00000fffffff0ff00ff90ff000000
0000f99099f9f99099f0000099f9f9f0f9f9f99099f9f9f0fff0fff0f9f9f990f9f9f9f0fff0f9900000fff0fff0000099f00000f9f9f9f0fff0f990fff00000
0000ff90099999009ff000000999999099999900099999909ff0ff9099999900999999909ff0ff900000ff909ff000009ff00000999999909ff0ff909ff00000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ff90999999909ff00000999999909ff0ff909ff0ff909ff0ff909ff0ff900000ff909ff000000000ff90000000009ff0ff909ff000000000000000000000
0000fff0f9f9f9f0fff00000f9f9f9f099f0f99099f0fff099f0f990fff0f9900000fff0fff000000000fff000000000fff0fff0fff000000000000000000000
00000ff0fffffff0ff000000fffffff09ff0ff909ff00ff09ff0ff90ff00ff9000000ff0ff00000000000ff000000000ff000ff0ff0000000000000000000000
0000000000000000000000000000000099f0f99099f0000099f0f9900000f9900000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000fffffff09ff0ff909ffffff09fffff90ffffff90ff00000000000ff000000ff0ff000ff000000000ff0000000000000000000000
000000000000000000000000f9f9f9f099f0f99099f9f9f099f9f990f9f9f990fff000000000fff00000fff0fff0fff000000000fff000000000000000000000
000000000000000000000000999999909ff0ff900999999009999900999999009ff000000000ff900000ff909ff0ff90000000009ff000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000040404040f4f4f4f0500056505000000000000000b0b000b0000000000000000000000000666677700000000000000000
55000000550000000000005500000055000000009f9f9f9066000660660000000b0000b0b000000004000000000005004009000062b8e9700000000000000000
a75000007a5000000000057a000005a7404040409999999055000550555600000b0000b0000b00000000040004005500400490006fadd8700000000000000000
aa500000aa500000000005aa000005aa00000000000000006660666066666000000b0000000b00b000000000000000004409900055fbd5500000000000000000
7a500000a7500000000005a70000057a40404040404040405655565056555000000b0b00000000b0000000000000000044949000665557700000000000000000
55040000550400000004005500040055000000000000000066666660666666000b0b0b00b00000b0000400000550040066666000666767700000000000000000
00000000000000000000000000000000404040404040404055565550555655000b000000b0b000b0000000005555000044949000666677700000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d21d21d21d21d210
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008218218218218210
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d21d21d21d21d210
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d21d21d21d21d210
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002212212212212210
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101101101101100
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d00d0010010000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666505d676d50
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000655556005555500
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600006070000070
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0000d060000060
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005d66d50d00000d0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000060
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006dd55d0d05550d0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050666050
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00333000003330000033300000333000603330006033300000333000003330000333300000000000033330000000000000000000000000000000000000000000
00fff40000fff40000fff40000fff40060fff00060fff00060fff00060fff0000ff30000033330000ff300000333300000055500000555000005550000055500
66033440660334400003344000033440660333306603333060033330600333300fff40000ff300000fff40000ff3000005555500005555000005550000555500
0633344006333440663334406633344006630330066303306603033066030330003344000fff4400003344000fff440000006000000060000000600000006000
0030330000330330603033006033033006603300066303300660330006630330f333340000334400f33334000033440005666650066566600566665006656660
000005500005505500000550000550550000055000055055066005500665505500030350f303035000030350f303035005050050050500500505005005050050
00005500005505500000550000550550000055000055055000005500005505500055005000550050005500500055005005050050050500500505005005050050
03330000033300000333000003330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0fff00000fff00000fff00000fff0000000000000000000000000000000000000000000000000000000000000000000000333000000000000033300000000000
00335550003355500033555000335550110110001111000011100000111100000003330000033300000333000003330000fff3300033300000fff33000333000
0333555003335550033355500333555010001000100110001111000010011000060ff440060ff440060ff440060ff4400003333000fff3300003333000fff330
00330890003309800033098000330980011155000111550001115500011155000060344000603440006034400060344066640300003333306664030000333330
000559a000055a900005589000055a9008185550081855500818555008185550000f3400000f3400000f3400000f340000344330666433300034433066643330
00550a00005500a0005509a0005500a0011115500111155001111550011115500000335000005500000033500000550000550550005445500055055000544550
000000000000000000000a0000000000001010100011001000110100001011000005505000000500000550500000050000050050000500500005005000050050
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00333300003333000033330000333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000
33333300033333000033330003333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007700000
00033000000330000003300000033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007770000
33333330333333303333333033333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007700000
55555550555555505555555055555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000
50505050550505505050505055050550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05555500055555000555550005555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000050500050303070103010307020005050505050505050505050505050505050505050505050505050505050505050505050505050505050505050500000000000000000005040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
