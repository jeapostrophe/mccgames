pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- mai-chan's sweet buns
-- by lazy devs

function _init()
 ver="v2"
 fadeperc,debug,mytime,dpal,seloffset,selani,seloffset2,beep,boxflash,coinani,edges,ox4,oy4,hat,bani,mait,mait2,maib,maic,incr,mbani,mouseb=1,"",0,explodeval("0,1,1,2,1,13,6,4,4,9,3,13,1,13,14"),0,0,0,0,0,explodeval("133,213,229,245"),explodeval("5,6,7,8,5,10,15,20,1,1,1,1,0,0,0,0"),explodeval("0,0,-1,1,-1,1,1,-1"),explodeval("-1,1,0,0,-1,1,-1,1"),explodeval("3,36,30,20,-6,-10,-8,-4,10,10,12,12"),explodeval("0,1,1,1,2,2,2,2,1,1,1,0"),0,-0.5,0,120,explodeval("-1,1,-5,5"),explodeval("0,206,206,206,0,0,0,207,207,207,207,0"),0,0
 price,powerreq,names,ppower,powername,powertext1,powertext2=explodeval("0,0,0,0,1,4,4,4,8,8,8,16,16,16,20,20"),explodeval("1,1,2,0,1,1,1,1,1,1,1,1,1,2"),explode("sweet bun,croissant,cinnamon roll,pretsel,brownie,eclair,donut,cupcake,cream puff,rum baba,nussecke,scone,punsch-roll,taiyaki,cannoli,pastel de nata"),explodeval("1,4,2,3,11,4,7,6,12,13,5,4,8,10,9,14"),explode("nom,table flip,diet,stellar,swap,flip,spin,roll,order,sakasa,snatch,divination,seduce,rapture"),explode("remove a pastry,shuffle back your,lower an order,games start with,swap two pastries,swap two pastries,swap two adjacent,swap two adjacent,duplicate pastry,flip the entire,snatch a pastry,redraw the 4 next,change the pastry,clear a pastry"),explode("from the board,orders and redraw,to x1,one additional ★,horizontally,vertically,columns,rows,into 4 next slots,board on its head,from a next slot,slots,of an order,type from board")
 coins,bestscore,loadout,bloadout,unlock=0,0,explodeval("1,2,3,4"),explodeval("1,2,3,4"),explodeval("1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0")
 cartdata("sweetbuns1")
 loaddata()
 showintro,introtext,wlist,pirate,url=200,explode("a balistic goul production, ,made by,jack mccarthy, ,music by,sebastian hassler, ,based on a design by,krystian majewski"),explode("www.lexaloffle.com,v6p9d9t4.ssl.hwcdn.net,game.itch,www.playpico.com,uploads.ungrounded.net,game298709.konggames.com,b-cdn.gamejolt.net"),true,stat(102)
 add(wlist,0)
 for _i in all(wlist) do
  if (url==_i) pirate=false
 end
 if pirate then
  introtext=explode("visit krystman.itch.io,to play this game,,current server:")
  add(introtext,url)
 end
 mainmenu()
end

function _update60()
 curani()
 mytime+=1/60
 
 maic-=1
 if maic<0 then
  maib=bani[-maic]
  mouseb=mbani[-maic]
  if -maic==#bani then
   maic=120+flr(rnd(180))
   if (rnd(3)<1) maic=0
  end
 end
 _upd()
end

function _draw()
 _drw()
 checkfade()
end

function mainmenu()
 --music(-1)
 menuitem(1)
 menuitem(2)
 _upd,_drw,mnusel,mmnu=update_main,draw_main,1,{}
 add(mmnu,{t="play game",cb=starttut,new=false})
 
 if unlock[18]>0 then
  mmnu[1].t="normal mode"
  add(mmnu,{t="hard mode",cb=starthardmode,new=unlock[18]==1}) 
 end 
 if unlock[19]>0 then
  add(mmnu,{t="infinite mode",cb=startinfmode,new=unlock[19]==1}) 
 end 
 if unlock[17]>0 then
  add(mmnu,{t="shop",cb=showshop,new=unlock[17]==1})
 end 
 if unlock[20]==1 then
  add(mmnu,{t="how to play",cb=starttut,new=false})
  mmnu[1].cb=startgame
 end
 --music(20)
end

function startgame()
 _upd,_drw=update_game,draw_game
 --music(0)
 menuitem(1,"retry",startgame)
 menuitem(2,"main menu",mainmenu)
 rndbuns()
end

function starttut()
 tuttext,tuty,tutmode,tuttme,tutarr1,tutarry="",-45,true,140,explode("hello! i'm mai.\nwelcome to my\nbakery.,today we will be\nserving delicious\npastries to our\ncustomers.,the cards at the\nbottom of the\nscreen show what\nour customers want.,we have to find a\nline of pastries on\nthe board that\nmatches one of the\ncards.,we can select\nvertical or\nhorizontal lines.,but it needs to be\nan uninterrupted\nline of the same\npastry.,we can only serve\nlines of pastries\nthat perfectly\nmatch the cards.,sometimes it will\nbe easy - like with\nthe x1 cards.,sometimes it can\nget really hard -\nlike with the\ntroublesome x3\norders.,but if we get stuck\nwe can look into my\nmagical ★-box to\nactivate special\npowers.,the powers cost ★.\nwe can gain more ★\nby aligning 4 of\nthe same pastry in\na row.,if we get stuck and\nrun out of ★ we\nlose.,but if we manage to\nserve all of our\ncustomers we win!,let's do our best!\n\n♥,"),explodeval("1,1,1,83,83,83,1,1,1,83,83,83,83,83,-45")
 startgame()
 _upd=update_tut
end

function starthardmode()
 mult,hardmode,decklist,unlock[18]=4,true,explodeval("2,2,2"),2
 startgame()
end

function startinfmode()
 infmode,unlock[19]=true,2
 startgame()
end

function showshop()
 _upd,_drw,loadoutbuns,shpcard,unlock[17],uimode,curx,shpsel,shpx,shptx=update_shop,draw_shop,{},makebunspr(17,13,87),2,"",0,1,0,0
 shpcard.power=true
 for _i=1,4 do
  add(loadoutbuns,makebunspr(loadout[_i],24+_i*18,9))
 end
 
 shpsetscroll()
 --music(30) 
 menuitem(1)
 menuitem(2)
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
  add(_retarr,flr(_i+0))
 end
 return _retarr
end
-->8
--updates

function update_main()
 if (pirate or showintro>0) return
 
 keymove(mnusel,true,1,#mmnu,function(_v)
  mnusel=_v
  --sfx(63) 
 end)
 
 if btnp(❎) then  
  --sfx(57)
  music(-1,1000) 
  fadeout(0.02,40)
  decklist,hardmode,infmode,mult=explodeval("3,2,1"),false,false,1
  mmnu[mnusel].cb()
  savedata()
 end
end

function update_game()
 boxflash,moved=max(boxflash-1,0),false
 if autorowt>0 then
  autorowt-=1
  if autorowt==0 then
   --sfx(59)
   --sfx(61)
   clearbuns(nil,4,4,nstars)
  end
 end
 
 if btnp(❎) then
  if curx==-1 then
   if stars==nstars and autorowt==0 then
    showpowers()
    --sfx(57)
   end
  else
   if uimode=="" then
    checkorder()
   elseif uimode=="selbun" then
    power_dosel(selcard.s-16)
   end
  end
 end
 if btnp(🅾️) then
  if uimode=="" then
   curdir=curdir==0 and 1 or 0
   --sfx(62)
   redoselbuns()
  else
   showpowers()
   --sfx(61)
  end
 end
 keymove(curx,false,-1,3,function(_v)
  curx,moved=_v,true
 end)
 keymove(cury,true,0,3,function(_v)
  cury,moved=_v,true
 end)
 if moved then
  if uimode=="" then
   redoselbuns()
  elseif uimode=="selbun" then
   redoselbuns_selbun()
  end
  --sfx(63)
 end
 
 update_anims()
end

function update_seldir()
 for _i=0,3 do
  if btnp(_i) then
   if dirallow[_i+1] and isdirok(coordtoindex(curx,cury),_i) then
    seldir=_i
    power_dosel(selcard.s-16)
    return
   else
    --sfx(56)
    beep=8     
   end
  end
 end
 if btnp(🅾️) then
  showpowers()
  --sfx(61)
 end
 update_anims()
end

function update_selorder()
 keymove(curx,false,-1,#orders-1,function(_v)
  curx,selorder=_v,nil
  if (curx>=0) selorder=orders[curx+1]
  --sfx(63)
  redoordhovers()
 end)

 if btnp(❎) then
  if curx==-1 then
   showpowers()
   --sfx(61)   
  else
   power_dosel(selcard.s-16)
  end
 end
 if btnp(🅾️) then
  showpowers()
  --sfx(61) 
 end
 update_anims()
end

function update_anims()
 animatebuns(prebunspr)
 animatebuns(bunspr)
 animatebuns(flyspr)
 animatebuns(ordspr)
 animatebuns(ordflyspr)
 clearflyspr()
 clearordflyspr()
 mouset=max(mouset-1,0)
 if mousenum<st_buns and mouset<40 then
  mousenum+=1
  mouset=50
 end
end

function update_powers()
 local _pwr
 
 keymove(powcur,false,1,#powercards,function(_v)
  powcur=_v
  --sfx(63)
 end)
 
 if btnp(❎) then
  _pwr=powercards[powcur].s-16
  if power_cando(_pwr) then
   selcard.s=powercards[powcur].s
   backtogame()
   power_do(_pwr)
   --sfx(57)       
  else
   --sfx(56)
   beep=8   
  end
 end
 if btnp(🅾️) then
  --sfx(61)
  backtogame()
 end
 for _i,_pwr in pairs(powercards) do
  _pwr.h=_i==powcur and 2 or 0
 end
 update_anims()
 animatebuns(powercards)
end

function update_endscreen()
 if eswait>0 then
  eswait-=1
  update_anims()
  if (eswait==60) music(esmusic)
 else
  est_t,boxflash=min(est_t+0.01,1),0
  est=flr(inelastic(-80,esdt,est_t))
  
  if #esgrad>0 then
   esgradt-=1
   if esgradt<=0 then
	   del(esgrad,esgrad[1])
 	  esgradt=45
 	  --sfx(61)
 	 end
  elseif addcoins>0 then
   esgradt-=1
   if esgradt<=0 then
    addcoins-=1
	   --sfx(60)
	   esgradt=8   
	  end
  end

  keymove(escur,false,1,#esmenu,function(_v)
   escur=_v
   --sfx(63)
  end)
  if btn(⬆️) then
   est,est_t=-128,0
  end
  if btnp(❎) then
   --confirm
   --sfx(57)
   --music(-1,1000)
   fadeout(0.02,40)
   esmenu[escur][2]()
  end
 end
end

function update_shop()
 if uimode!="" then
  keymove(curx,false,1,4,function(_v)
   curx=_v
   --sfx(63)
   if uimode=="loadout" then
    shpsel,mytime=loadout[curx],-0.25
    shpsetscroll()
   end
  end)

  if btnp(⬇️) and uimode=="loadout" then
   uimode=""
   --sfx(63)    
   return
  end

  if btnp(🅾️) then
   if uimode=="pickmode" then
    uimode=""
    --sfx(62)
    return
   else
--    sfx(62)
--    music(-1,1000)
    fadeout()
    mainmenu()
    return   
   end
  end
  if btnp(❎) and uimode=="pickmode" then
   --sfx(61)
   loadout[curx],loadoutbuns[curx].s,uimode=shpsel,shpsel,""
   savedata()
  end
 else
  if btnp(🅾️) then
--   sfx(62)
--   music(-1,1000)
   fadeout()
   mainmenu()
  end
  
  keymove(shpsel,false,-100,100,function(_v)
   shpsel,mytime=_v,-0.25
   shpsetscroll()
   --sfx(63)
  end)

  if btnp(⬆️) then
   uimode,curx="loadout",1
   --sfx(63)
  end   
  if btnp(❎) then
   if unlock[shpsel]==0 then
    if coins<price[shpsel] then
     --sfx(56)
     beep=8    
    else
     coins-=price[shpsel]
     unlock[shpsel]=1
     --sfx(57)
     savedata()
    end
   else
    if picked(shpsel)==nil then
     uimode,curx="pickmode",1
     --sfx(61)
    end
   end
  end
 end
 shpx+=(shptx-shpx)/10
end

function keymove(_v,_vert,_min,_max,_callback) 
 local _nv,btn1,btn2=_v,⬅️,➡️
 
 if _vert then
  btn1,btn2=⬆️,⬇️
 end
 if btnp(btn1) then
  _nv-=1
 end 
 if btnp(btn2) then
  _nv+=1
 end
 _nv=mid(_min,_nv,_max)
 if (_nv!=_v) _callback(_nv)
end

function update_tut()
 update_anims()
 if tuttme>0 then
  tuttme-=1
  return
 end
 local _txt,_ty=tutarr1[1],tutarry[1]
 tuty+=(_ty-tuty)/((#tutarr1==15 or #tutarr1==1) and 9 or 18)
 if #tuttext!=#_txt and abs(_ty-tuty)<2 then
  tuttext=sub(_txt,1,#tuttext+1)
  --sfx(63)
 end
 
 if btnp(❎) or (_txt=="" and abs(_ty-tuty)<2) then
  if tuttext!=_txt then
   tuttext=_txt
   --sfx(63)
  elseif _txt=="" then
   unlock[20]=1
   savedata()
   backtogame()   
  else
   tuttext=""
   del(tutarr1,_txt)
   del(tutarry,_ty)
   --sfx(61)
  end
 end
 
end
-->8
--draws

function draw_main()
 if showintro>0 or pirate then
  showintro-=1
  if showintro==0 and pirate==false then
   fadeout(0.04,60)
  else
   draw_intro()
   return
  end
 end
 local _c,_c2
 cls(7)
 
 _c2=-24+(time()*5)%24
 for _i=0,12 do
  _c=14+_i%2
  rectfill2(_i*12+_c2,0,11,16,_c)
  circfill(5+_i*12+_c2,16,5,_c)
 end
 line(0,64,128,64,6)
 line(0,66,128,66,6)
 rectfill2(0,68,128,60,6)
 mait,mait2=min(mait+0.006,1),min(mait2+0.01,1)

 drawmai(inelastic(-64,12,mait,0.1),inelastic(-9,30,mait-0.1,0.2)+sin(time()/5)*1)
 
 _c2=inelastic(-64,30,mait2,0.03)
 sspr(49,99,55,29,67,_c2) 
 _c2-=7
 oprint8("★",66,_c2,8,7)
 oprint8("★",116,_c2,8,7)
 oprint8("mai-chan's",75,_c2,7,2)

 for _i,_mnu in pairs(mmnu) do
  _c,_c2=2,7
  if _i==mnusel then
   _c,_c2=7,2
  end
  rrectfill2(35,63+_i*10,60,9,_c2)
  print(_mnu.t,39,65+_i*10,_c)
  if _mnu.new then
   oprint8("new!",97,65+_i*10+sin(time())*1.5,8,7)
  end
 end
 print(ver,1,122,7)
 draw_spat(90,67+mnusel*10)
end

function draw_intro()
 cls(12)
 for _i,_t in pairs(introtext) do
  coprint(_t,63,20+_i*6,7,1)  
 end
end

function draw_game()
 local _selcnt,_x,_y,_i,_tx,_ty,_c=0
 cls(7)
 for _x=0,3 do
  _tx=boardx+_x*18
  drawplate(_tx,prevy,6)
  for _y=0,3 do
   _ty,_c,_i=boardy+_y*16,6,coordtoindex(_x,_y)
   if selbuns[_i] then
    _c=14
    if selbuns[_i+1] then
     rectfill2(_tx+15,_ty,4,14,_c)
    end
    if selbuns[_i+5] then
     rectfill2(_tx,_ty+13,16,5,_c)
    end
   end
   drawplate(_tx,_ty,_c)
  end
 end
 
 if (boxflash>0) allcolor(7) 
 _i=(shakebox and uimode=="") and sin(time()*6)*0.55*sin(time()/8) or 0
 sspr(0,102,26,22,2.5+_i,2)
 pal()
 coprint("★"..stars,14.5+_i,7,7,2)

 drawbunarr(prebunspr,0)
 
 for _i=0,29 do
  _x=bunspr[_i]
  if _x!=nil then
   _x.sel,_x.h=false,1
   if selbuns[_i] then
    _x.sel,_x.h=true,2-sin((mytime)+_selcnt/6)
    _selcnt+=1
   end
   drawbun(_x)
  end
 end
 
 drawcardarr(ordspr,true)
 drawcardarr(ordflyspr,true) 
 _y=95
 if #deck>0 then
  pal(13,6)
  draw_cardspr(103,_y+1)
  pal()
  pal(7,6)
  for _i=1,flr(#deck/5) do
   draw_cardspr(103,_y)
   _y-=2
  end
  pal()
  draw_cardspr(103,_y)
 end
 
 drawcardarr(ordspr)
 drawcardarr(ordflyspr) 
 
 if #deck>0 then
  numberbox(infmode and "??" or #deck.."",116,115,11)
  line(111,124,119,124,6)
 end
 
 if infmode then
  spr(221,101,41,3,3)
  numberbox(mousenum.."",116,32,17)
  if mouset>0 then
   spr(205,109,49)
  end
  if (mouseb>0) spr(mouseb,101,57)
 end
 
 drawbunarr(flyspr,1)

 beep=max(beep-0.5,0)
 _tx,_ty=boardx+curx*18,boardy+cury*16    
 
 if uimode=="" or uimode=="selbun" then
  if curx>=0 then   
   if uimode=="" then
    if curdir==0 then
     drawcurarr(_tx,_ty,0)
     drawcurarr(_tx,_ty,1)
    else
     drawcurarr(_tx,_ty,2)
     drawcurarr(_tx,_ty,3)
    end
   end
   draw_spat(_tx+12,_ty+10)
  else
   draw_spat(19,12)
  end
 elseif uimode=="selorder" then
  if curx>=0 then
   _spr=selorder.ospr
   draw_spat(_spr.x+20,_spr.y+20)
  else
   draw_spat(19,12)
  end
 elseif uimode=="seldir" then
  _i=coordtoindex(curx,cury)
  for _c=0,3 do
   if (isdirok(_i,_c) and dirallow[_c+1]) drawcurarr(_tx,_ty,_c)
  end 
  draw_spat(_tx+12,_ty+10)
 elseif uimode=="endscreen" then
  draw_endscreen()
 elseif uimode=="powers" then
  draw_powers()
 end
 if selcard.visible then
  drawcardarr({selcard})
  cprint(powername[selcard.s-16],15,66,6)
 end
 
 if (tutmode and tuttme<=0) drawtutbox(tuty+0.5)
 
 if debug!="" then
  print(debug,0,0,1)
 end
end

function draw_endscreen()
 local _y,_x,_c1,_c2=est+19
 rrectfill2(9,est,110,esh,14)
 rectfill2(11,est+2,106,5,7)
 rect(11,est+2,116,est+esh-3,7)
 
 for _i,_line in pairs(estext1) do
  cprint(_line,64,est+7+6*_i,2)
 end
 
 for _line in all(estext2) do
  _y+=_line[1]
  _x=111-#_line[3]*4
  print(_line[2],18,_y,2)
  if _line[5] then
   oprint(_line[3],_x-2,_y,7,2)
  else
   print(_line[3],_x,_y,2)
  end
  if _line[4] then
   drawcoin(_x-9,_y-2)
  end
 end
 
 if estype==1 then
  line(15,est+55,112,est+55,2)
  rrectfill2(50,est+64,28,10,15)
  drawwallet(64,est+65,coins-addcoins)
 elseif estype==2 then
  rrectfill2(18,est+41,92,29,15)
  _x,_y=29,est+45.5
  for _i in all(bloadout) do
   drawplate(_x,_y,6)
   allcolor(13)
   drawjustbun(_i,_x,_y-2)
   pal()
   drawjustbun(_i,_x,_y-3)
   _x+=18
  end
  coprint(esbest and "best score!" or "best score:"..bestscore,65,est+62,7,2)
 end
 
 if #esgrad>0 then
  rectfill(12,est+esgrad[1],115,est+esh-4,14)
 end
 
 if estype==0 then
  sspr(0,88,48,14,41,est-4) 
 else
  sspr(0,74,55,14,39,est-4) 
 end

 _y,_x=est+esh-11,flr(64-(#esmenu*23+(#esmenu-1)*2)/2)
 line(_x-2,est+esh-3,129-_x,est+esh-3,14)
 
 for _i,_line in pairs(esmenu) do
  _c1,_c2=7,2
  if (_i==escur) _c1,_c2=2,7
  rrectfill2(_x,_y,23,9,_c1)
  cprint(_line[1],_x+12,_y+2,_c2)
  if (_i==escur) draw_spat(_x+20,_y+7)
  _x+=25
 end
end

function draw_powers()
 local _selp
 for _i=-1,10 do
  sspr(26,102,12,25,(time()*16)%12+_i*12,57)
 end
 if #powercards>0 then
  _selp=powercards[powcur]
  drawcardarr(powercards)
  drawtbox(25,83,_selp.s-16)
  draw_spat(_selp.x+19,_selp.y+22)
 end
end

function draw_shop()
 local _pckd,_j,_x,_c1,_c2,_h,_name=picked(shpsel)
 beep=max(beep-0.5,0)
 cls(13)
 rectfill(0,0,127,35,7)
 rectfill(0,38,127,39,7)
 circfill(20,17,11,15)
 drawwallet(20+beep%2,13,coins)
 line(42,25,111,25,6)
 line(53,25,101,25,7)
 cprint("your counter",78,25,6)
 for _i,_spr in pairs(loadoutbuns) do
  _c1,_spr.sel,_spr.h=6,false,1
  if (uimode=="" and _i==_pckd) or (uimode!="" and curx==_i) then
   _c1,_spr.sel,_spr.h=14,true,2
  end
  drawplate(24+_i*18,10,_c1)
 end
 drawbunarr(loadoutbuns,1)

 for _i=-4,20 do
  _c1,_c2,_h,_j,_x=6,13,1,_i,shpx+_i*22
  if (_j<1) _j=_i+16
  if (_j>16) _j=_i-16
  
  if _j==shpsel then
   _c1,_c2,_h=15,9,2-sin(mytime)
  end
  drawplate(_x+0.5,53,_c1)
  allcolor(_c2)
  drawjustbun(_j,_x,52)
  pal()
  if unlock[_j]==0 then
   allcolor(2)
  end
  drawjustbun(_j,_x,52-_h)
  pal()
 end
 
 if uimode!="" then
  draw_spat(37+curx*18,19)
 else
  drawcurarr(56,54,0)
  drawcurarr(56,54,1)
 end
 
 if uimode!="pickmode" then
  if unlock[shpsel]==0 then
   rrectfill2(37,71,54,10,7)
   _y=price[shpsel]
   _x=_y>9 and 41 or 43
   drawcoin(_x,72)
   print(_y.." unlock",_x+10,73,2)
  else
   if picked(shpsel)==nil then
    rrectfill2(43,71,41,10,7)
    cprint("pick",64,73,2)
   else
    cprint("picked",64,73,6)
   end
  end
 end
 _name="???"
 if unlock[shpsel]==1 then
  _name=names[shpsel]
  if uimode=="pickmode" then
   shoppower(ppower[loadout[curx]])
  else
   shoppower(ppower[shpsel])
  end
 end
 cprint("#"..shpsel.." ".._name,64,43,6)
 line(0,118,127,118,6)
 cprint("🅾️ back to main menu",62,121,6)
end

function shoppower(_p)
 drawtbox(40,85,_p)
 shpcard.s=_p+16
 drawcardarr({shpcard})
end


-->8
-- ui stuff

function cprint(_t,_x,_y,_c)
 print(_t,_x-#_t*2,_y,_c,13)
end

function coprint(_t,_x,_y,_c,_c2)
 oprint(_t,_x-#_t*2,_y,_c,_c2)
end

function oprint(_t,_x,_y,_c,_c2)
 oprint8(_t,_x,_y+1,_c,_c2)
 oprint8(_t,_x,_y,_c,_c2)
end

function oprint8(_t,_x,_y,_c,_c2)
 for i=1,8 do
  print(_t,_x+ox4[i],_y+oy4[i],_c2)
 end 
 print(_t,_x,_y,_c)
end

function rectfill2(_x,_y,_w,_h,_c)
 rectfill(_x,_y,_x+_w-1,_y+_h-1,_c)
end

function rrectfill2(_x,_y,_w,_h,_c)
 rectfill2(_x,  _y+1,_w,_h-2,_c)
 rectfill2(_x+1,_y  ,_w-2,_h,_c)
end

function fadeout(spd,_wait)

 if (spd==nil) spd=0.04
 if (_wait==nil) _wait=0
 repeat
  fadeperc=min(fadeperc+spd,1)
  dofade()
  flip()
 until fadeperc==1
 repeat
  _wait-=1
  flip()
 until _wait<0
end

function checkfade()
 if fadeperc>0 then
  fadeperc=max(fadeperc-0.04,0)
  dofade()
 end
end

function dofade()
 -- 1 = black
 local p,kmax,col,k=flr(mid(0,fadeperc,1)*100)
 for j=1,15 do
  col = j
  kmax=(p+(j*1.46))/22
  for k=1,kmax do
   col=dpal[col]
  end
  pal(j,col,1)
 end
end


function curani()
 selani+=1
 if selani>38 then
  selani,seloffset=0,1
 elseif selani>28 then
  seloffset=0
 end
 seloffset2=((flr(selani/10))%2==1) and 1 or 0
end

function allcolor(_c)
 for _i=1,15 do
  pal(_i,_c) 
 end
end

function resetpresprite(_i)
 prebunspr[_i]=makebunspr(loadout[prebuns[_i]],boardx+_i*18,prevy-1)
end

function placespr(_spr,_x,_y,_h)
 if (_h==nil) _h=1
 _spr.x,_spr.y,_spr.tx,_spr.ty,_spr.sx,_spr.sy,_spr.wait,_spr.t,_spr.h,_spr.th,_spr.sh=_x,_y,_x,_y,_x,_y,0,1,_h,1,1
end

function movespr(_spr,_x,_y,_s,_curve,_h,_hcurve)
 _spr.sx,_spr.sy,_spr.tx,_spr.ty,_spr.t,_spr.spd,_spr.curve,_spr.wait,_spr.sh,_spr.hcurve=_spr.x,_spr.y,_x,_y,0,_s,_curve,0,_spr.h,_curve
 if _h!=nil then
  _spr.th=_h
  _spr.hcurve=_hcurve
  if _hcurve==nil then
   _spr.hcurve=_curve
  end
 end
end

function sprcspeed(_spr,_spd)
 _spr.spd=_spd*dist(_spr.sx,_spr.sy,_spr.tx,_spr.ty)/64
end

function dist(x1, y1, x2, y2)
 return sqrt((x2-x1)^2+(y2-y1)^2)
end

function makebunspr(_bun,_x,_y)
 local _newspr={
  s=_bun,
  h=0,
  sel=false,
  t=1,
  x=_x,
  y=_y,
  visible=true
 }
 placespr(_newspr,_x,_y)
 return _newspr
end

function lerp(_a,_b,_t)
	return _a+(_b-_a)*_t
end

function inoutquad(_a,_b,_t) 
 local _t2=2*_t*_t
 if _t>0.5 then
  _t2=-1+(4-2*_t)*_t  
 end
 return lerp(_a,_b,_t2)
end

function inelastic(_a,_b,_t,_amp)
 local _os,_trs,_t2,_t3=_amp,0.3 
 --_trs=threshold 
 --_os =overshoot
 if (_os==nil) _os=0.1
 if _t<_trs then
  _t2=((_t/_trs-1)^3+1)*(1+_os)
 else
  _t3=(_t-_trs)/(1-_trs)
  _t2=1+cos(_t3*2)*_os*(1-_t3)
 end
 return lerp(_a,_b,_t2)
end

function inquad(_a,_b,_t)
 return lerp(_a,_b,_t*_t)
end

function outquad(_a,_b,_t)
 return lerp(_a,_b,_t*(2-_t))
end

function cardarc(_a,_b,_t)
 return lerp(_a,_b,_t)-sin(_t/2)*8
end

function draw_spat(_x,_y)
 sspr(0,64,13,10,_x+seloffset+beep%2,_y+seloffset)
end

function draw_cardspr(_x,_y)
 sspr(104,48,24,28,_x,_y)
end

function showpowers()
 local _cx=flr((128-#powercards*25)/2)
 uimode,_upd,powcur="powers",update_powers,1
 for _i,_crd in pairs(powercards) do
  placespr(_crd,-25,51,0) 
  movespr(_crd,_cx+(_i-1)*25,51,0.3,outquad,0)
  _crd.wait=5*(#powercards-_i)
 end
 selcard.visible=false
end

function backtogame()
 tutmode,uimode,_upd,selcard.visible,seldir=false,"",update_game,false,-1
end

function drawtbox(_x,_y,_pi)
 local _ts
 rrectfill2(_x,_y,77,30,14)
 rect(_x+1,_y+1,_x+75,_y+28,7)
 oprint(powername[_pi],_x+5,_y+5,7,2)
 _ts={powertext1[_pi],powertext2[_pi]}
 for _i=1,2 do
  print(_ts[_i],_x+5,_y+8+_i*6,15)
 end
end

function selmode_bun(_highlight)
 uimode,selcard.visible,_upd,curx,cury,curdir,selhlight="selbun",true,update_game,0,0,0,_highlight
 redoselbuns_selbun()
end

function selmode_order()
 uimode,selcard.visible,_upd,curx,cury,curdir,selorder="selorder",true,update_selorder,0,0,0,orders[1]
 redoordhovers()
end

function selmode_dir(_v,_h)
 uimode,dirallow,_upd="seldir",{_v,_v,_h,_h},update_seldir
 seldir=-1
end

function redoselbuns_selbun()
 selbuns=clearselbuns()
 if (curx==-1) return
 if selhlight=="column" then
  for _i=0,3 do
   selbuns[coordtoindex(curx,_i)]=true
  end
 elseif selhlight=="row" then
  for _i=0,3 do
   selbuns[coordtoindex(_i,cury)]=true
  end 
 else
  selbuns[coordtoindex(curx,cury)]=true
 end
end

function redoordhovers()
 for _ord in all(orders) do
  _ord.ospr.h=selorder==_ord and 3 or 1
 end
end

function showendscreen(_type)
 esbest,estype,escur,esmusic,eswait,esgrad,esgradt,addcoins,esmenu=false,_type,2,17,160,{},0,0,{{"menu",mainmenu},{"again",startgame}}
 if estype==0 then
  estext1,estext2,esh,esdt={"you got stuck!","please try again ♥"},{{12,"orders fulfilled:",st_served.."/"..st_deck}},55,32
 elseif estype==1 then
  if hardmode==false and unlock[18]==0 then
   unlock[18]=1
   unlock[17]=1
  elseif hardmode and unlock[19]==0 then
   unlock[19]=1
  end
  addcoins=calcscore()
  coins+=addcoins
  savedata()
  estext1,estext2,esgrad,esgradt,esh,esdt,escur,esmusic={"everybody is loving","your sweet buns!"},{{11,"level complete","1",true},{9,"stars collected",nstars.."",true},{9,"multiplier",mult.."x"},{11,"",addcoins.."",true}},{27,36,46,54},50,90,18,3,18
  add(esmenu,{"shop",showshop})
 elseif estype==2 then
  estext1,estext2,esh,esdt={"you got stuck","but you did great!"},{{11,"pastries served:",st_buns.."",false,true}},85,24
  if st_buns>bestscore then
   esbest,bestscore=true,st_buns
   for _i=1,4 do
    bloadout[_i]=loadout[_i]
   end
  end
 end
 uimode,_upd,est_t="endscreen",update_endscreen,0
 est=-esh-16
 savedata()
end

function drawplate(_x,_y,_c)
 rrectfill2(_x,_y,16,14,_c)
end

function shpsetscroll()
 shptx=78-(shpsel+1)*22
 if shpsel<1 then
  shpsel+=16
  shptx-=352
  shpx-=352
 end
 if shpsel>16 then
  shpsel-=16
  shptx+=352
  shpx+=352
 end
end

function picked(_i)
 for _j=1,4 do
  if (loadout[_j]==_i) return _j
 end
 return nil
end

function drawcoin(_x,_y)
 spr(coinani[flr(1+(time()*3.5)%4)],_x,_y)
end

function drawwallet(_x,_y,_num)
 local _nx=flr(_x-(10+(#(_num..""))*4)/2)
 drawcoin(_nx,_y)
 oprint(_num,_nx+10,_y+1,7,2)
end

function drawcurarr(_tx,_ty,_dir)
 if _dir==0 then
  sspr(13,64,6,8,_tx-7-seloffset2,_ty+2)
 elseif _dir==1 then
  sspr(13,64,6,8,_tx+17+seloffset2,_ty+2,6,8,true)
 elseif _dir==2 then
  sspr(19,64,8,6,_tx+4,_ty-8-seloffset2)
 elseif _dir==3 then
  sspr(27,64,8,6,_tx+4,_ty+12+seloffset2)  
 end
end

function isdirok(_pos,_dir)
 return buns[_pos+incr[_dir+1]]!=-1
end

function numberbox(_n,_x,_y,_min)
 local _w=max(#_n*4+3,_min)
 local _rx=flr(_x-_w/2)
 rrectfill2(_rx,_y,_w,9,13)
 rectfill2(_rx+1,_y+1,_w-2,7,7)
 cprint(_n,_x,_y+2,13)
end

function drawmai(_x,_y)
 palt(11,true)
 palt(0,false)
 for _i=1,4 do
  drawhat(_x+ox4[_i],_y+oy4[_i],2)
 end
 drawhat(_x,_y,7)
 sspr(55,64,49,35,_x,_y)
 if (maib>0) sspr(104,67+9*maib,23,9,_x+12,_y+14)
 --line(_x+11,_y,_x+15,_y-4,6)
 --line(_x+39,_y,_x+37,_y-2,6)
 --line(_x+37,_y-2,_x+31,_y-3,6)
 palt()
end

function drawhat(_x,_y,_c)
 for _i=1,4 do
  circfill(_x+hat[_i],_y+hat[_i+4],hat[_i+8],_c)
 end
end

function drawtutbox(_y)
 rrectfill2(1,_y,126,42,13)
 rectfill2(2,_y+1,124,40,7)
 rectfill2(3,_y+2,122,38,15)
 rectfill2(5,_y+4,34,34,7)
 rectfill2(6,_y+5,32,32,13)
 clip(6,_y+5,32,32)
 drawmai(-3,_y+4)
 clip()
 oprint8(tuttext,43,_y+6,13,7)
 oprint("❎",114,_y+39+sin(time()),13,7)
end
-->8
--gameplay

function rndbuns()
 uimode,curx,cury,curdir,ordbun,ordnum,boardx,boardy,prevy,buns,selbuns,tselbuns,prebuns,orders,ordspr,ordflyspr,autorowt,eswait,seldir,selorder,stars,nstars,shakebox,st_round,st_buns,st_rows,st_served,mousenum,mouset,deck="",0,0,0,0,0,30,20,-4,{},clearselbuns(),{},{},{},{},{},0,0,-1,nil,0,0,false,0,0,0,0,0,0,{}
 for _x=1,3 do
  for _y=1,decklist[_x] do
   for _i=1,4 do
    add(deck,{bun=_i,num=_x})
   end
  end
 end 
 deck=shuffle(deck)
 st_deck=#deck
 
 buns=explodeval("-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1")
 buns[0]=-1
 
 for _x=1,4 do
  neworder()
 end
 
 repeat
  for _x=0,3 do
   for _y=0,3 do  
    buns[coordtoindex(_x,_y)]=randombun()
   end
  end
 until not(isstuck()) and checkautorow()==0
 
 for _i=0,3 do
  prebuns[_i]=randombun()
 end
 
 redobunspr() 
 flyinbuns()

 shiftordspr(40)
 makepowercards()
 redoselbuns()
end

function shuffle(_dck)
 local _ndck,_crd={}
 repeat
  _crd=_dck[1+flr(rnd(#_dck))]
  add(_ndck,_crd)
  del(_dck,_crd)
 until #_dck==0
 return _ndck
end

function clearselbuns()
 local _bns={}
 for _i=0,29 do
  _bns[_i]=false
 end
 return _bns
end
 
function redoselbuns()
 if (autorowt>0) return
 selbuns=clearselbuns()

 if (curx<0) return

 local _i,_lst=coordtoindex(curx,cury)
 _lst=getchain(_i,curdir)
 ordbun,ordnum=buns[_i],#_lst
 for _j in all(_lst) do
  selbuns[_j]=true
 end
 mytime=-0.25
end

function clearbuns(_tspr,_tx,_ty,_nstars,_rapture)
 local _c,_colcnt,_coldel,_topbun,_spr=0,{},{},0
 for _i=0,4 do
  _colcnt[_i],_coldel[_i]=0,-1
 end
 
 for _i=29,0,-1 do
  if selbuns[_i] then
   buns[_i],_spr=0,bunspr[_i]
   _spr.y-=_spr.h
   _spr.h=0
   if _tspr!=nil then
				_tx,_ty=_tspr.tx+4,_tspr.ty-_tspr.th+3
				if _tspr.waitbuns==nil then
				 _tspr.waitbuns={}
				end
				add(_tspr.waitbuns,_spr)
   elseif _rapture then
    _tx,_ty=_spr.x,_spr.y-128
   end
   movespr(_spr,_tx,_ty,1,inquad,0)
   sprcspeed(_spr,0.4)
   _spr.sel=false
   if _rapture then
    _spr.wait=_c*2
   else
    _spr.endsfx,_spr.wait=60,_c*7
   end
   add(flyspr,_spr)
   bunspr[_i],_spr.nstars=nil,_nstars
   _c+=1
  end
 end
 
 for _i=29,0,-1 do
  if buns[_i]==0 then
   local _j,_x,_y=_i,getcoord(_i)
   _coldel[_x]+=1
   repeat  
    _j-=5
    _topbun=buns[_j]
   until _topbun!=0
   
   if _topbun>0 then
    buns[_i],buns[_j],bunspr[_i],bunspr[_j]=_topbun,0,bunspr[_j],nil
   elseif _topbun==-1 then
    _j=_x
    if prebuns[_j]>0 then 
     buns[_i],prebuns[_j],bunspr[_i],prebunspr[_j],_colcnt[_j]=prebuns[_j],0,prebunspr[_j],nil,0
    else
     _colcnt[_j]+=1 
     buns[_i]=randombun()
     bunspr[_i]=makebunspr(loadout[buns[_i]],boardx+_j*18,prevy-16*_colcnt[_j])
    end
   end
   _spr=bunspr[_i]
   movespr(_spr,boardx+_x*18,boardy+_y*16-1,0.9,inelastic)
   scaleamp(_spr,0.1)
   _spr.wait=5+_coldel[_x]*3
  end
 end
 
 for _i=0,3 do
  _colcnt[_i]+=1
  if prebuns[_i]==0 then   
   _coldel[_i]+=1
   prebuns[_i]=randombun()
   _spr=makebunspr(loadout[prebuns[_i]],boardx+_i*18,prevy-16*_colcnt[_i])
   movespr(_spr,_spr.x,prevy-1,0.9,inelastic) _spr.wait=5+_coldel[_i]*3
   scaleamp(_spr,0.1)
   prebunspr[_i]=_spr
  end
 end
 cleanupchecks()
end

function cleanupchecks()
 if (autorowt>0) return
 local _i=checkautorow()
 if _i>0 then
  selbuns,autorowt=tselbuns,60
  nstars+=_i
  st_rows+=_i
 else
  redoselbuns()
  checkgover()
 end
end

function randombun()
 return 1+flr(rnd(4))
end

function coordtoindex(_x,_y)
 return 5+_x+_y*5
end

function getcoord(_i)
 local _y=flr(_i/5)-1
 return _i-((_y+1)*5),_y
end

function checkorder()
 if (autorowt>0) return
 local _ord,_ospr
 for _ord in all(orders) do
  if _ord.bun==ordbun and _ord.num==ordnum then
   --sfx(61)
   st_buns+=ordnum
   st_round+=1
   st_served+=1
   _ospr=_ord.ospr
   
   add(ordflyspr,_ospr)
   del(ordspr,_ospr)
   del(orders,_ord)
   _ord.ospr=nil
   movespr(_ospr,_ospr.x,_ospr.y,0.4,inoutquad,16,outquad)
   
   neworder()
   shiftordspr()
   clearbuns(_ospr)
   return
  end
 end
 --sfx(56)
 beep=8
end

function neworder()
 local _ord
 if (#orders>=4) return
 if infmode then
  add(orders,{bun=randombun(),num=1+flr(rnd(3))})
 else
  if #deck>0 then
   _ord=deck[1]
   add(orders,_ord)
   del(deck,_ord)
  end
 end
end

function checkautorow()
 local _found,_i,_l,_lst=0
 tselbuns=clearselbuns()
 
 for _j=1,8 do
  _i=edges[_j]
  _lst=getchain(_i,edges[_j+8])
  if #_lst==4 then
   _found+=1
   for _l in all(_lst) do
    tselbuns[_l]=true
   end
  end
 end

 return _found
end

function isstuck()
 local _lst
 for _i=0,29 do
  for _d=0,1 do
   _lst=getchain(_i,_d)
   if (#_lst==4) return false
   for _ord in all(orders) do
    if (_ord.bun==buns[_i] and _ord.num==#_lst) return false
   end
  end
 end
 return true
end

function getchain(_i,_dir)
 local _j,_ret,_b,_inc=_i,{_i},buns[_i],1
 
 if (_dir==1) _inc=5
 _j+=_inc
 while buns[_j]==_b do
  add(_ret,_j)
  _j+=_inc
 end 
 _j=_i-_inc
 while buns[_j]==_b do
  add(_ret,_j)
  _j-=_inc
 end
 return _ret
end

function checkgover()
 shakebox=false
 if (autorowt>0) return
 if #orders==0 and #deck==0 then
  showendscreen(1)
 elseif isstuck() then 
  shakebox=true
  if cantdopowers() then
   if infmode then
    showendscreen(2)
   else
    showendscreen(0)
   end
  end
 end
end

function makepowercards()
 local _newspr,_pwr
 powercards={}
 for _i=1,4 do
  _pwr=ppower[loadout[_i]]
  if _pwr==4 then
   stars+=1
   nstars=stars
  else
   _newspr=makebunspr(16+_pwr,_i*25,51)
   _newspr.num,_newspr.power=1,true
   add(powercards,_newspr)
  end
 end
 selcard=makebunspr(17,3,38)
 selcard.num,selcard.power,selcard.visible=1,true,false
end

function calcscore()
 return (1+nstars)*mult
end

function swapbuns(_from,_to)
 local _b
 _b,buns[_from]=buns[_from],buns[_to]
 buns[_to],_b=_b,bunspr[_from]
 bunspr[_from],bunspr[_to]=bunspr[_to],_b
 swapsprites(_b,bunspr[_from])
end
-->8
--powers
function star_shuffle()
 for _i=1,4 do
  shuffleback(_i)
  if (orders[_i]!=nil and infmode==false) add(deck,orders[_i])
  orders[_i]=nil
 end
 deck=shuffle(deck)
 for _i=1,4 do
  neworder(_i)
 end
 shiftordspr(20,true)
end

function star_shortage()
 local _b=buns[coordtoindex(curx,cury)]
 for _i=0,29 do
  selbuns[_i]=buns[_i]==_b
 end
 clearbuns(nil,nil,nil,nil,true)
 --sfx(61)
end

function star_180()
 local _from,_to,_i
 for _y=0,1 do
  for _x=0,3 do
   _from,_to,_i=coordtoindex(_x,_y),coordtoindex(_x,3-_y),10+_x*8
   swapbuns(_from,_to)
   bunspr[_from].wait,bunspr[_to].wait=_i,_i
   _i=bunspr[_from].spd*3
   bunspr[_from].spd,bunspr[_to].spd=_i,_i
  end
 end
 --sfx(61)
end

function star_div()
 selbuns=clearselbuns()
 clearprebuns()
 clearbuns()
 --sfx(61)
end

function clearprebuns()
 local _spr
 for _i=0,3 do
  prebuns[_i],_spr,prebunspr[_i]=0,prebunspr[_i],nil
  add(flyspr,_spr)
  movespr(_spr,_spr.x,_spr.y-20,0.6,inelastic)
 end
end

function star_snatch()
 local _i,_b
 _i=coordtoindex(curx,cury)
 _b,buns[_i]=buns[_i],prebuns[curx]
 prebuns[curx],_b=_b,bunspr[_i]
 bunspr[_i],prebunspr[curx]=prebunspr[curx],_b
 _b.sel=false
 swapsprites(bunspr[_i],_b)
 
 --sfx(61)
end

function star_eat()
 clearbuns(nil,boardx+curx*18,0)
 --sfx(61)
end

function star_diet()
 selorder.num,selorder.ospr.num=1,1
 selorder=nil
 redoordhovers()
 --sfx(61)
end

function star_seduce()
 local _bun=selorder.bun
 repeat
  selorder.bun=flr(1+rnd(4))
 until selorder.bun!=_bun
 selorder.ospr.s=loadout[selorder.bun]
 selorder=nil
 redoordhovers()
 --sfx(61)
end

function star_swap()
 local _to
 for _i=0,29 do
  if selbuns[_i] then
   _to=_i+incr[seldir+1]
   swapbuns(_i,_to)
  end
 end
 --sfx(61)
end

function star_order()
 local _b=buns[coordtoindex(curx,cury)]
 selbuns=clearselbuns()
 clearprebuns()
 clearbuns()
 for _i=0,3 do
  prebuns[_i],prebunspr[_i].s=_b,loadout[_b]
 end
 --sfx(61)
end

function cantdopowers()
 for _pwr in all(powercards) do
  if (power_cando(_pwr.s-16)) return false
 end
 return true
end

function power_cando(_p)
 if (powerreq[_p]>nstars) return false
 if _p==2 then
  if (#deck==0) return false
 end
 return true
end

function power_do(_p)
 if _p==1 then
  --eat
  selmode_bun()
 elseif _p==2 then
  --redraw
  spendstars(_p)
  star_shuffle()
  cleanupchecks()
 elseif _p==3 or _p==13 then
  --diet/seduce
  selmode_order()
 elseif _p==5 or _p==6 or _p==9 or _p==11 or _p==14 then
  --swap/flip
  selmode_bun()
 elseif _p==7 then
  --spin
  selmode_bun("column")
 elseif _p==8 then
  --roll
  selmode_bun("row")
 elseif _p==10 then
  --180
  spendstars(_p)
  star_180()
  cleanupchecks()
 elseif _p==12 then
  --divination
  spendstars(_p)
  star_div()
  cleanupchecks()
 else
  spendstars(_p)
  checkgover()
 end
end

function spendstars(_p)
 stars-=powerreq[_p]
 nstars=stars
end

function power_dosel(_p)
 if _p==1 then
  spendstars(_p)
  star_eat()
 elseif _p==3 then
  spendstars(_p)
  star_diet()
 elseif _p==5 or _p==6 or _p==7 or _p==8 then
  --swap (bejewled h)
  if seldir==-1 then
   if _p==5 or _p==7 then
    selmode_dir(true,false)
   else
    selmode_dir(false,true)
   end
   return
  else
   spendstars(_p)
   star_swap()
  end
 elseif _p==9 then
  --order
  spendstars(_p)
  star_order()
 elseif _p==11 then
  spendstars(_p)
  star_snatch()
 elseif _p==13 then
  spendstars(_p)
  star_seduce() 
 elseif _p==14 then
  spendstars(_p)
  star_shortage()
 end
 backtogame()
 cleanupchecks()
end

-->8
--shop and data

function loaddata()
 if dget(0)!=3 then
  savedata()
  return
 end
 coins=dget(1)
 bestscore=dget(2)
 for _i=1,4 do
  loadout[_i]=dget(2+_i)
  bloadout[_i]=dget(6+_i)
 end
 for _i=1,20 do
  unlock[_i]=dget(_i+10)
 end
end

function savedata()
 dset(0,3)
 dset(1,coins)
 dset(2,bestscore)
 for _i=1,4 do
  dset(2+_i,loadout[_i])
  dset(6+_i,bloadout[_i])
 end
 for _i=1,20 do
  dset(_i+10,unlock[_i])
 end

end
-->8
--sprite management

function clearflyspr()
 local _spr
 for _i=#flyspr,1,-1 do
  _spr=flyspr[_i]
  if _spr.t==1 then
   del(flyspr,_spr)
  end
 end
end

function clearordflyspr()
 local _spr,_del,_wb
 for _i=#ordflyspr,1,-1 do
  _spr=ordflyspr[_i]
  _wb,_del=_spr.waitbuns,false
  if _wb==nil then
   _del=true
  elseif #_wb==0 then
   _spr.flyaway=true
  else
   for _j=#_wb,1,-1 do
    if _wb[_j].t==1 then
     del(_wb,_wb[_j])
     _spr.flash=4
    end
   end
  end
  if _spr.t==1 then 
   if _spr.flyaway then
    movespr(_spr,_spr.x,130,0.3,inoutquad,8,outquad)
    _spr.flyaway,_spr.waitbuns=false,nil
   elseif _del then
    del(ordflyspr,_spr)
   end
  end
 end
end

function animatebuns(_arr)
 local _spr
 
 for _i=0,#_arr do
  _spr=_arr[_i]
  if _spr!=nil then
   if _spr.wait==0 then
    _spr.visible=true
    if _spr.t<1 then
     _spr.t+=1/_spr.spd/60
     _spr.t=min(_spr.t,1)
     _spr.x,_spr.y,_spr.h=_spr.curve(_spr.sx,_spr.tx,_spr.t,_spr.amp),_spr.curve(_spr.sy,_spr.ty,_spr.t,_spr.amp),_spr.hcurve(_spr.sh,_spr.th,_spr.t,_spr.amp)
     if _spr.t==1 then
      _spr.whide=false
      if _spr.endsfx!=nil then
       sfx(_spr.endsfx)
       _spr.endsfx=nil
      end
      if _spr.nstars then
       boxflash+=2
       stars=_spr.nstars
      end
     end
    end
   else
    _spr.wait-=1
    _spr.visible= not _spr.whide
   end
  end
 end
end

function drawbunarr(_arr,_j)
 for _i=_j,#_arr do
  drawbun(_arr[_i])
 end
end

function drawcardarr(_arr,_shadow)
 local _x,_y,_req
 
 for _spr in all(_arr) do
  if _spr.visible then
   _x,_y=_spr.x+0.5,_spr.y+0.5
   if _shadow then
    allcolor(6)
    draw_cardspr(_x,_y)
   else
    _y-=_spr.h
    pal()
    if _spr.flash!=nil and _spr.flash>0 then
     allcolor(7)
     _spr.flash-=1
    end
    draw_cardspr(_x,_y)
    rrectfill2(_x+2,_y+2,20,24,_spr.power and 14 or 15)
    if _spr.power then
     _req=powerreq[_spr.s-16]
     if _req>0 then
      rrectfill2(_x+2,_y+19,20,7,2)
      print("★".._req,_x+6,_y+20,7)
     end
    else
     print("x".._spr.num,_x+9,_y+19,2)
    end
    drawjustbun(_spr.s,_x+4-0.5,_y+3-0.5)
   end
  end
 end
 pal()
end

function drawbun(_spr)
 if (_spr==nil) return
 local _shadowcol=_spr.sel and 8 or 13
 allcolor(_shadowcol)

 drawjustbun(_spr.s,_spr.x,_spr.y)

 pal()
 drawjustbun(_spr.s,_spr.x,_spr.y-_spr.h)
end

function drawjustbun(_b,_x,_y)
 local _bs=_b-1
 spr(flr(_bs/8)*16+_bs*2,_x+0.5,_y+0.5,2,2)
end

function swapsprites(_s1,_s2)
 movespr(_s1,_s2.x,_s2.y,0.6,inelastic)
 scaleamp(_s1,0.1)

 movespr(_s2,_s1.x,_s1.y,0.6,inelastic)
 scaleamp(_s2,0.1)
end

function redobunspr()
 bunspr,flyspr,prebunspr={},{},{}
 for _i=0,29 do
  resetsprite(_i)
 end
 for _i=0,3 do
  resetpresprite(_i)
 end
end

function flyinbuns()
 local _c,_spr=0
 for _i=29,0,-1 do
  if buns [_i]>0 then
   flyinbun(bunspr[_i],20+getcoord(_i)*6+_c)
   _c+=1
  end
 end 
 for _i=0,3 do
  flyinbun(prebunspr[_i],20+_i*6+_c)
 end
end

function flyinbun(_spr,_wait)
 local _x,_y=_spr.x,_spr.y
 placespr(_spr,_spr.x,_spr.y-80,1)
 movespr(_spr,_x,_y,1,inelastic)
 scaleamp(_spr,0.1)
 _spr.wait=_wait
end

function scaleamp(_spr,_amp)
 _spr.amp=_amp/(dist(_spr.sx,_spr.sy,_spr.tx,_spr.ty)/16)
end

function resetsprite(_i)
 local _x,_y=getcoord(_i)
 if buns[_i]>0 then
  bunspr[_i]=makebunspr(loadout[buns[_i]],boardx+_x*18,boardy+_y*16-1)
 else
  bunspr[_i]=nil
 end
end

function resetordspr(_i)
 local _ord,_newspr=orders[_i]

 if _ord!=nil then
  _newspr=makebunspr(loadout[_ord.bun],ordpos(_i),96)
  ordspr=ins(ordspr,_newspr)
  _newspr.num,_ord.ospr=_ord.num,_newspr
 end
end

function ins(_arr,_itm)
 local _ret={_itm}
 for _i,_a in pairs(_arr) do
  _ret[_i+1]=_a
 end
 return _ret
end

function ordpos(_i)
 return 25*(_i-1)+2
end

function shiftordspr(_w,_whide)
 local _new,_spr,_tx=0
 
 if (_w==nil) _w=0
 for _i,_ord in pairs(orders) do
  _spr,_tx=_ord.ospr,ordpos(_i)
  if _spr==nil then
   resetordspr(_i)
   flyincard(_i)
   _ord.ospr.wait,_ord.ospr.whide=_w+30+(_new*15),_whide
   _new+=1
  elseif _spr.tx!=_tx then
   movespr(_spr,_tx,96,0.4,inoutquad)
   _spr.wait=_w+15
  end
 end
end

function flyincard(_i)
 local _spr,_h=orders[_i].ospr,flr((#deck+1)/5)*2+1
 placespr(_spr,103,96,_h)
 movespr(_spr,ordpos(_i),96,0.4,inoutquad,1,cardarc)
 _spr.endsfx=58
end

function shuffleback(_i)
 local _spr,_h=orders[_i].ospr,flr((#deck+1)/5)*2+1
 add(ordflyspr,_spr)
 del(ordspr,_spr)
 orders[_i].ospr=nil
 movespr(_spr,103,96,0.4,inoutquad,_h,cardarc)
 _spr.endsfx=58
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002220000000
00000222222000000000022222200000000022222222000000022220002220000000002200000000002220000000000000002222222200000000002ff2200000
0002244444422000000224494442200000224444444422000024444222444200000002442200000002fff220000000000022ffffffff2200000022efffe20000
0024444444444200002444944444420002ff44ffffff44200244444244444420000024444422000024222ff22000000002ffeeeeeeeeee200002feeeeffe2000
0244777444444220029444944444442002f44ff4444ff442244424244422444200024422444422002f222222f220000002feeeeeeeeeee20002effeeffeef200
024477444444422024494944444999202ff44fff4444f442244202444220244200244444422444202f44222222f220002feee2eeee2eeee202eeeffffeeefe20
244444444444222224494944449444922ff444ffff44f4922442244424422442024442444444422029ff4422222222202feeee2222feeee202feeeeeeeeffe20
24444444444422222444fff9494444422fff44444444f492244424442442444202224442422422200299ff442222222228eeeeffffeeee8202ffeeeeefffee20
29444444444422422fff222f9444444229fff444444ff49224442992299244420222224444422220002299ff442222f229eeeeeeeeeeee92002fffffffeee200
299944444442444202220002f49994422999ffffffff44920244422222244420024422224422222000002299ff444ff22988eeeeeeee889200244eeeeee44200
029999999994442000000000244449200299999999994422029444444444492002224422222222000000002299ffff92029988888888992000027444444f2000
02ff9999999444200000000024444f200299999999944200002994444449920000222244222220000000000022999920029999999999992000027f7f7f7f2000
0022ffffff44220000000002444ff2000022999999942000000229999992200000002222422200000000000000222200002299999999220000002f7f7f720000
000022222222000000000002fff22000000022222222000000000222222000000000002222200000000000000000000000002222222200000000022222200000
00000000000000000000000022200000000000000000000000000000000000000000000022000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000022000000000000000000000000000000002222000000000000000000000000000000000000022220000000000000000000000000000022222200000
00000222299220000000000022000000000000002222ff22000002222220000000000000000000000022ffff2222200000222000000000000002299999922000
000229944999420000000222fe20000000000222999922220002244444422000002222200000000002ff99999ff942000277f220000000000029944444499200
002999994999420000022778e88220000022299994449222002444994444220002ff2222200000002f999f49999f942027ff9992200000000294494222444920
0029949999944200002427f788f22200022299449949994200244999999422202f222aabb2200000249994499499f220274499999220000029949a94229a4992
02999449944444200242777ffff724202f2999944999994202944444994422202222bbbaabb220002f449999494942002499499999922000294444a944aa9492
02449944444444200242f777777f2420222944999444944202944444444224202222bbbbbaab222029ff9994949942002499994999fff2002942224aa9442492
002444444444f2000242ff7777ff2420222944499994944202f99444444244202223bbbbbb22ff222499944449494422244999944f7777202994224942224992
002ff444444ff200024422ffff224420022499994499442002ff99999f944420022333bbb22f22220249999444944442024449994f77777229944a9422244992
02977ffffff7742002944422224449200024499449922420029ffffff994442000022333b2f2222202449944994449920022444994f777722999944444499992
0299777777774420029994444449992000024449922f22000299ff9999444220000002233222222200244499444499420000224494f777720299999999999920
00299999994442000029999999999200000024422ff22200002999ff994422000000000222222222000224444449942000000022444fff420024999999994200
00022994444220000002299999922000000002422222200000022999442220000000000002222220000002222994420000000000224444200024444444444200
00000222222000000000022222200000000000222222200000000222222000000000000000022200000000002444200000000000002222000002244444422000
00000000000000000000000000000000000000002222000000000000000000000000000000000000000000000222000000000000000000000000022222200000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeeeeee22eee222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeee22eee22eeeeeee2ffffffffff2eeeeeeeeeeeeeeeeeeeeeee222222eeeeeeeeeeeee222222eeeeeee222222eeeeeeeeeeeee222222ee
eeeeeeeeeeeeeeeeeee2eeee2eee22eeee2ffffffffff2eeeeeeeeeeeeeeeeeeeeee2ffffff2eeeeee222eee2ffff2eeeeee2ffffff2eeeeeeeeeeee2ffff2ee
e2222eeeeee2222eeeeeeeeeeeeeee2eee2ffffffffff2eeeeeeeeeeeeeeeeee22e2ffffffff2e22e27ff2ee2fff2eee22e2ffffffff2e22ee2222222fff2eee
22ee22eeee22ee22e22222222222eee2ee2ffffffffff2eeeeeeeee77eeeeeee2f2fff2222fff2f227ffff2e2ffff2ee2f2fff2222fff2f2e27ff2f22ffff2ee
2eeee2eeee2eeee222ffffffffff2ee2eee2ffffffff2eeeeeeeee7227eeeeee2ffff2eeee2ffff22fffff2e2f2fff2e2ffff2eeee2ffff227ffff2f2f2fff2e
eeeeeeeeeeeeeeee222ffffffffff2eeeee2ffffffff2eeeeeeee727727eeeee2fff2eeeeee2fff2e22222ee22e2fff22fff22eeee22fff22fffff2f2222fff2
ffeeeeeeeeeeeeffe222ffffffffff2eeee2ffffffff2eeeee777727727777ee2ffff2eeee2ffff2eeeeeeeeeeee2ff22ffff22ee22ffff2e2222222222e2ff2
ffe22eeeeee22effe2222ffffffffff2eee2ffffffff2eeeee722277772227ee222222eeee222222eeeeeeeeeeee2ff22222222ee2222222eeeeeeeeeeee2ff2
eeee22eeee22eeee22e222fffffff222eee2fff22fff2eeeee727777777727eeeeeeeeeeeeeeeeeeee222eee22e2fff2227ff22ee227ff22eeeeeeee22e2fff2
eeeee2eeee2eeeee2eee222ffff2222eee2ffffffffff2eeeee7277777727eeeee222eeeeee222eee27ff2ee2f2fff2e27222f2ee27222f2ee2222222f2fff2e
eeeee222222eeeeeeeeee222f22222eeee2ffffffffff2eeeeee72777727eeeee27ff2eeee27ff2e27ffff2e2ffff2ee227ff22ee227ff22e27ff2f22ffff2ee
eeee22eeee22eeeeeeeee22222222eeee27ffffffffff72eeee7277777727eee27ffff2ee27ffff22fffff2e2fff2eee27ffff2ee27ffff227ffff2f2fff2eee
eee22eeeeee22eeeeeee22e22ee2eeeee27777777777772eeee7277227727eee2fffff2ee2fffff2e22222ee2ffff2ee2fffff2ee2fffff22fffff2f2ffff2ee
eeeeeeeeeeeeeeeeeeee2eeeeeeeeeeee2ff77777777ff2eeee7222772227eeee22222eeee22222eeeeeeeee222222eee22222eeee22222ee2222222222222ee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7777ee7777eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeee222222eeeeeeeeeeeeeeeeeeeeeeeeeeee22222eeeeeeeeeee2ee2eeeeeee2222eeeeeeeeeefef7f777777f7fefbbbbbbbb00dddddddddddddddddddd00
eeee2ff2fff2eeeeeeeee222222eeeeeeeeeee2fffff2eeeeee2eee2eeeeeeeee22ee22eeeeeeeeefef7f777777f7fefbbbbbbbb0d77777777777777777777d0
eeee2ff2fff222eeeeeee27722222eeeeeee222222fff2eeeee2ee2eee2eeeeee2eeee2eee2222eefef7f777777f7fefbbbbbbbbd77dddddddddddddddddd77d
eee22ff2ff2fff2eeeeeee27722222eeeee2ffffffffff22eeeeeeeeeeeeeeeeeeee2eeeee22222efef7f777777f7fefbbbbbbbbd7dd666d66666666d666dd7d
ee2f2ff2ff2fff2eeee2eee2772222eeeee222222fffffffee2222222222eeeeeee2e2eeeee2ee2efef7f222222f7fefbbbbbbbbd7dddd6dddddddddd6dddd7d
ee2f2ff2ff2fff2eeeee2eee2772222ee22fffffffffffffe2f77777777f2eeeeee222eeee2e2eeefef22ffffff22fefbbbbbbbbd7d666d666d66d666d666d7d
ee2f2ff2ff2fff2eeeee22eee277222e2fffffffffffffff2f7222222227f222eee222eeee222eeefe2ffffffffff2efbbbbbbbbd7dd6d6d6d6dd6d6d6d6dd7d
ee2f2fffffffff2eee2222eeee27722e2fff2222ffffffff2f2277272222f2f2eeee2eeeee222eeefe2ffeeeeeeff2efbbbbbbbbd7d6666dddd66dddd6666d7d
ee2ffff22222ff2eeeeeeeeeeee2772ee222eeee2fffffff27f22222222ff2f2eeeeeeeeeee2eeeefe2eeeeeeeeee2efbbbbbbbbd7ddd6d66dd66dd66d6ddd7d
ee2fff2fffff2f2eeeeeeeeeeeee272eeeeeeeeee2ffff22277ffffffffff2f2eeeeeeeeeeeeeeeefe2eee2222eee2efbbbbbbbbd7dddd6d6dddddd6d6dddd7d
ee2fff2fffffff2eeeeeeeeeeeeee22eeeeeeeeee2fff2eee277777777ff2f2eeeeeeeeeeeeeeeeefef22eeeeee22fefbbbbbbbbd7d6ddd6dd6dd6dd6ddd6d7d
ee2ffff222ffff2eeeeeeeee22eeeeeeeeeeeeee2fff2eeee27777777fff22eeeeeee222eeeeeeeefef7f222222f7fefbbbbbbbbd7dd66d6ddd66ddd6d66dd7d
eee2fffff2ffff2eeeeeeeee222eeeeeeeeeeee2fff2eeeeee277777fff2eeeeeee2eeeee22eeeeefef7f777777f7fefbbbbbbbbd7dd6ddd6d6dd6d6ddd6dd7d
eee2ffff2ffff2eeeeeeeeee2ee2eeeeeeeeeee2ff2eeeeeeee22222222eeeeeee2f2ee22ff2eeeefef7f777777f7fefbbbbbbbbd7dd66ddd6dddd6ddd66dd7d
eeee2fff2ffff2eeeeeeeeee2eeeeeeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeeeee2ff22fff2eeeeefef7f777777f7fefbbbbbbbbd7dd66ddd6dddd6ddd66dd7d
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee2ffffff2eeeeeeeeeeeeeeeeeeeeeebbbbbbbbd7dd6ddd6d6dd6d6ddd6dd7d
02200000000000002220002200022222222bbbbb00222200bbbbbbb777777777767777777722222222222222227777772bbbbbbbd7dd66d6ddd66ddd6d66dd7d
27722000000000027720027720027777772bbbbb02aaa920bbbbbbb7777777766777777222eeeeee2eeeeeee22222222bbbbbbbbd7d6ddd6dd6dd6dd6ddd6d7d
27777220000000277720277772026777762bbbbb2a799992bbbbbbb7777776677777722eeeee2eee22eeeeeeeee2ee2bbbbbbbbbd7dddd6d6dddddd6d6dddd7d
26777772000002777722777777202677620bbbbb2a999992bbbbbbb77776677777222eeeeeee2eee222eeeeeeeeee2e22bbbbbbbd7ddd6d66dd66dd66d6ddd7d
02777777200002677722666666200266200bbbbb2a999a92bbbbbbb26667777722eeee2eeeee2eee2222eeeeeeeeee2ee2bbbbbbd7d6666dddd66dddd6666d7d
02677772000000267722222222200022000bbbbb2999aa92bbbbbbbb27777722eeeeee2eeee292ee29222eeeeeeeeee2ee2bbbbbd7dd6d6d6d6dd6d6d6d6dd7d
0027772222200002662bbbbbbbbbbbbbbbbbbbbb02999920bbbbbbbbb27722eeeeeee2eeee2992ee299922eeeeeeeeff2ff2bbbbd7d666d666d66d666d666d7d
0026622226720000222bbbbbbbbbbbbbbbbbbbbb00222200bbbbbbbbb222eeeeeeee22222e29992e2ff992e222eefffff2ff2bbbd7dddd6dddddddddd6dddd7d
0002200002672bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb2eeeeeeeee2e2eee299f92ee2ff992eee2ffffff2ffe2bbd7dd666d66666666d666dd7d
0000000000220bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb2eeeeeee2eee2eee292fff92e2fff292eef2fffeee2ee2bbd77dddddddddddddddddd77d
00022222222000000000000000000000000000000000222200000002eeeeeeee2eee2ee299fffff92e2ffff92ffffeeeff2fff2b0d77777777777777777777d0
00227777772000000000000000000000000000000000277200022222eeeeeeee2ee2ee299fffffff922fffff92ffeefffff2ee2b00dddddddddddddddddddd00
00277722272000000000000000000000000000000000277200027722eeeeeeee2ee2e29ffffffffff922fffff92eefffeee2eee229fffff9ffffffff99fffffb
00272220222022220000000022200222200002222002277222227722eeeeeee2eee229ffffffffffff99fffff992ffeeeee22ee229ffffff9ffffff9fffffffb
00277222000027720000000227222277220222772222777777227722eeeeeee2eee29fffff9ffffffff99fffff922eeeeee22ee29ff000fffffffffff0000ffb
0022777722202272222222027722777772227777727777777222772b2ee2eee2eee29f000ff9ffffff9f0000fff22eeeeee2b2e29f000000ffffffff01c000fb
0002227777720277227772227727722772277227722227722202772b2ee2eee2ee29f011100ffffffff011100ff222eeeee2b2e2001ccc17ffffffff1cc1700b
2222022227772277277777277277777772777777720027720002772bb2ee2ee2ee29011c110ffffffff11c170f2222eeeee2b2e200cc7cc7ffffffffc7cc700b
2772200022277277277227277277777222777772222027720002772bb2eee2ee2e2001ccc17ffffffff1cc170022222eeee22ee2ffcc77c7ffffffff777c7ffb
2272220002277227772227772277222227772222272027720002772bbb2eeee2f2200cc7cc7ffffffffc7cc70022222eeee22e2bff7ccc7ffffffffffcc7fffb
0277722222772227772027772277222277772222772022720002222bbbb2ee2fff2ffcc77c7ffffffff777c7ff22222eeee2ee2bffffffffffffff4fffffff2b
0227777777722027722027722227777772277777722002720002720bbb222e2feffff7ccc7ffffffffffcc7fff2222eeee2ee2bb29fffff9ffffffff99fffffb
0022277777220027720022720022777722227777220002720002720bb2ddd22ffefffffffffffffff4fffffff22222eee2e22bbb29ffffff9ffffff9fffffffb
0000222222200022220002220002222220022222200002220002220bb2ddd2d2fefffffefefffffffeffefeff2222eee222bbbbb9ffffffffffffffffffffffb
000022222000022200000000000000000000000000000000bbbbbbbbb2ddd2d2ffeffffffffffffffffffffff222eee2bbbbbbbb9ffffffffffffffffffffffb
000227772220227200000000000000000000000000002222bbbbbbbbbb22222222ff2ffffffffffffffffffff2eee22bbbbbbbbb00fffffffffffffffffff00b
002277777722277200000000000000000000000000002772bbbbbbbbbbbb2e2e2b2222ffffff44444fffffff22222bbbbbbbbbbb00000000ffffffff0000000b
022772227777227222222000002222222200022222202772bbbbbbbbbbbb2e2ee2bbb2fffff4777774ffffff2bbbbbbbbbbbbbbbff000000ffffffff00000ffb
027720002277227227772200002722777220227777222772bbbbbbbbbbb2ee2ee2bbbb2ffffeeeeeeefffff2bbbbbbbbbbbbbbbbf0f0fffffffffffffff0f0fb
227200000027727277777200002727777722277777722772bbbbbbbbbbb2e2eeee2bbbb2ffffeeeeefffff2bbbbbbbbbbbbbbbbbffffffffffffff4fffffff2b
277200000027727772277200002777227722772227772772bbbbbbbbbb2eeeeeee2bbbbb22ffffffffff22bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
277200000027727722227220002772222772720002772772bbbbbbbbb2eeeeeee2bbbbbbbb22ffffff22bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
277200000027727720027720002772002772720002772772bbbbbbbb2eeeeeeee2bbbbbbbbbb222222bbbbbbbbbbbbbbbbbbbbbb66266626777dd77777777dd7
227200000277227720027720002772002772720002772772bbbbbbb2eeeeeee22bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb6262626277d77d777777d77d
027722222777227720027720002772002772772227772222bbbbbbbb2222222bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb666666667d777d77777d777d
022777777772227220027220002722002722277777722720b0022222222222222222222222222222222222222222222222222220666666667d777777777d77d7
002277777222027200027200002720002720227777222720b0277eeee2227722227e2222ee2227eeeeee227eeeeee2777eeeeee2666666667d777777777d7777
000222222200022200022200002220002220022222202220b27eeeeeee227ee227eee227ee227eeeeeee27eeeeeee27eeeeeeee2ddddddd677d7777d7777d77d
02222222222222222222222220ddddddddddddbbbbbbbbbbb27ee222eee27ee227eee227ee227ee2222227ee222222222eee2220000000d6777dddd677777dd6
29eefffeeefffeeefffeeefff2777777999999bbbbbbbbbbb02eee222e227ee22eeee227ee227ee2222227ee222222222eee20000000dd66777777dd777777dd
29eefffeeefffeeefffeeefff2ffffffeeeeeebb00222200b002eeee222227ee2eeee27eee22eeeeeeee2eeeeeeee2222eee20000000000d666d00000d666d00
29eefffeeefffeeefffeeefff2ffffffeeeeeebb029aa920b0022eeeee2227eeeeeeeeeee222eeeeeeee2eeeeeeee2222eee200000000000d6d0000000d6d000
29eefffeeefffeeefffeeefff2ffffffeeeeeebb02999920b02e222eeee22eeeeeeeeeeee222eee222222eee222222222eee200000000000ddd0000dddd6d000
29eefffeeefffeeefffeeefff2ffffffeeeeeebb02999920b2eee222eee222eeee22eeeee222eee222222eee222222222eee20000000000d666d00d666d6d000
29eefffeeefffeeefffeeefff2ffffffeeeeeebb0299a920b2eeeeeeeee222eeee22eeee2222eeeeeeee2eeeeeeee2222eee20000000000d666d00d666d6d000
29eefffeeefffeeefffeeefff2ffffffeeeeeebb029a7920b022eeeeee22222ee2222ee222222eeeeeee22eeeeeee2222eee20000000000d666d00d666d6d000
29eefffeeefffeeefffeeefff2ffffffeeeeeebb02999920b00222222222222222222222222222222222222222222222222200000000d00dd66ddddd6dd6d000
29eefffeeefffeeefffeeefff2ffffffeeeeeebb00222200b02eeeeeeee22222ee222222ee2222eee2222222ee2222eeeeee200000d00dd666666666666dd000
29eefffeeefffeeefffeeefff2ffffffeeeeeebb00222200b2ee7eeeeeeee22ee7e2222e7ee22ee7ee22222e7ee22e7eeeeee200777dd6d666266626666d0000
29eefffeeefffeeefffeeefff2ffffffeeeeeebb00277200b2e7eeeeeeeee22e7ee2222e7ee22e7eeee2222e7ee2e7eeeeeeee20eee6d66666266626666d0000
29eefffeeefffeeefffeeefff2ffffffeeeeeebb002aa200b2e7ee222eeeee2e7ee2222eeee22e7eeee2222eeee2e7ee22eeee20eee6666666666666666d0000
29eefffeeefffeeefffeeefff2ffffffeeeeeebb00299200b2e7ee2222eeee2e7ee2222eeee22eeeeeee222eeee2eeee222ee200eee66666666666666666d000
29997779997779997779997772ffffffeeeeeebb002aa200b2eeee222eeeee2eeee2222eeee22e7eeeeee22eeee2eeeeee222000777dddd6666666666666d000
29997779997779997779997772ffffffeeeeeebb00299200b2e7eeeeeeeee22eeee2222eeee22eeeeeeee22eeee22eeeeee200007777777dddddddd66666d000
02222222222222222222222220ffffffeeeeeebb00299200b2eeeeeeeeeee22eeee2222eeee22eeee2eeee2eeee222eeeeee200077777777000000d66666d000
02449994449994449994449920ffffffeeeeeebb00222200b2eeeeeeeeeee22eeee2222eeee22eeee22eeeeeeee2222eeeeee200777777770000dd666666d000
029efffeeefffeeefffeeeff20ffffffeeeeeebb00222200b2eeee222eeeee2eeee2222eeee22eeee22eeeeeeee222222eeeee207777dd7700dd66666666d000
029efffeeefffeeefffeeeff20ffffffeeeeeebb027aa920b2eeee2222eeee2eeee2222eeee22eeee222eeeeeee22ee222eeee20777d77d70d6666666666d000
029efffeeefffeeefffeeeff20ffffffeeeeeebb02a99920b2eeee222eeeee2eeeee22eeeee22eeee2222eeeeee2eeee22eeee2077d777d7d66666776666d000
00222222222222222222222200ffffffeeeeeebb02a99920b2eeeeeeeeeeee22eeeeeeeeee222eeee22222eeeee2eeeeeeeeee2077d77d77d66667777666d000
bbbbbbbbbbbbbbbbbbbbbbbbbbffffffeeeeeebb02a99920b2eeeeeeeeeee222eeeeeeeeee222eeee222222eeee22eeeeeeeee2077d77777d66677777666d000
bbbbbbbbbbbbbbbbbbbbbbbbbbeeeeeeeeeeeebb02a99920b2eeeeeeeeee22002eeeeeeee2002eeee220022eeee222eeeeeee200777d777ddd667777766ddd00
bbbbbbbbbbbbbbbbbbbbbbbbbbddddddddddddbb02999920b022eeeeee220000022eeee2200002ee20000002ee200022eee220007777ddd666ddddddddd666d0
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00222200b0002222220000000002222000000022000000002200000022200000777777ddddd6666666ddddd0
__label__
7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7fffffffffff7ee2222222222222ffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7fffffffffff722777777777777722ffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7ffffffffff22777777777777777772fffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff7eeeeeeeeeee7fffffffff2777777777777777777772ffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffffff2222222eeeee7ffff2222277777777777777777777772fff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffffff22777777722eee7ff2277777777777777777777777777772ff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7ffffffff2777777777772ee72277777777777777777777777777777772f7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffffff277777777777772e27777777777777777777777777777777772f7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7ffffff277777777777777727777777777777777777777777777777777727eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7fffff2777777777777777777777777777777777777777777777777777727eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7ffff27777777777777777777777777777777777777777777777777777727eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
7ffff27777777777777777777777777777777777777777777777777777727eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffffffff7eeeeeeeeeee7fffffff
77ff2777777777777777777777777777777777777777777777777777777277eeeeeeeee777fffffffff777eeeeeeeee777fffffffff777eeeeeeeee777ffffff
777f27777777777777777777777777777777777777777777777777777772777eeeeeee77777fffffff77777eeeeeee77777fffffff77777eeeeeee77777fffff
7777277777777777777777777777777777777777777777777777777777727777eeeee7777777fffff7777777eeeee7777777fffff7777777eeeee7777777ffff
77772777777777777777777777777777777777777777777777777777772777777777777777222222222222277772222222222222227222722227777777777777
77772777777777777777777777777777777777777777777777777777772777777777787777277727772777277722772727277727722272227727777877777777
77772777777777777777777777777777777777777777777777777777727777777777888777277727272272222227222727272727272722272227778887777777
77772777777777777777777777777777777777777777777777777777277777777788888887272727772272277727272777277727272227277727888888877777
77777277777777777777777777777777777777777777777777777772777777777778888877272727272272222227222727272727272777222727788888777777
77777277777777777777777777777777777777777777777777777727777777777778777877272727272777277722772727272727272777277227787778777777
77777727777777777777776777777772222222222222222777777277777777777777777777222222222222277772222222222222222777222277777777777777
7777777277777777777766777777222eeeeee2eeeeeee22222222777777777777777777777777777777777777777777777777777777777777777777777777777
7777777727777777776677777722eeeee2eee22eeeeeeeee2ee27777777777777777722222222222222222222222222222222222222222222222222227777777
77777777727777776677777222eeeeeee2eee222eeeeeeeeee2e2277777777777777277eeee2227722227e2222ee2227eeeeee227eeeeee2777eeeeee2777777
77777777772226667777722eeee2eeeee2eee2222eeeeeeeeee2ee277777777777727eeeeeee227ee227eee227ee227eeeeeee27eeeeeee27eeeeeeee2777777
777777777777227777722eeeeee2eeee292ee29222eeeeeeeeee2ee27777777777727ee222eee27ee227eee227ee227ee2222227ee222222222eee2227777777
7777777777777727722eeeeeee2eeee2992ee299922eeeeeeeeff2ff2777777777772eee222e227ee22eeee227ee227ee2222227ee222222222eee2777777777
77777777777777222eeeeeeee22222e29992e2ff992e222eefffff2ff2777777777772eeee222227ee2eeee27eee22eeeeeeee2eeeeeeee2222eee2777777777
777777777777772eeeeeeeee2e2eee299f92ee2ff992eee2ffffff2ffe2777777777722eeeee2227eeeeeeeeeee222eeeeeeee2eeeeeeee2222eee2777777777
77777777777772eeeeeee2eee2eee292fff92e2fff292eef2fffeee2ee27777777772e222eeee22eeeeeeeeeeee222eee222222eee222222222eee2777777777
7777777777772eeeeeeee2eee2ee299fffff92e2ffff92ffffeeeff2fff277777772eee222eee222eeee22eeeee222eee222222eee222222222eee2777777777
7777777777772eeeeeeee2ee2ee299fffffff922fffff92ffeefffff2ee277777772eeeeeeeee222eeee22eeee2222eeeeeeee2eeeeeeee2222eee2777777777
7777777777772eeeeeeee2ee2e29ffffffffff922fffff92eefffeee2eee2777777722eeeeee22222ee2222ee222222eeeeeee22eeeeeee2222eee2777777777
7777777777772eeeeeee2eee229ffffffffffff99fffff992ffeeeee22ee27777777722222222222222222222222222222222222222222222222227777777777
7777777777772eeeeeee2eee29fffff9ffffffff99fffff922eeeeee22ee277777772eeeeeeee22222ee222222ee2222eee2222222ee2222eeeeee2777777777
77777777777772ee2eee2eee29f000ff9ffffff9f0000fff22eeeeee272e27777772ee7eeeeeeee22ee7e2222e7ee22ee7ee22222e7ee22e7eeeeee277777777
77777777777772ee2eee2ee29f011100ffffffff011100ff222eeeee272e27777772e7eeeeeeeee22e7ee2222e7ee22e7eeee2222e7ee2e7eeeeeeee27777777
777777777777772ee2ee2ee29011c110ffffffff11c170f2222eeeee272e27777772e7ee222eeeee2e7ee2222eeee22e7eeee2222eeee2e7ee22eeee27777777
777777777777772eee2ee2e2001ccc17ffffffff1cc170022222eeee22ee27777772e7ee2222eeee2e7ee2222eeee22eeeeeee222eeee2eeee222ee277777777
7777777777777772eeee2f2200cc7cc7ffffffffc7cc70022222eeee22e277777772eeee222eeeee2eeee2222eeee22e7eeeeee22eeee2eeeeee222777777777
77777777777777772ee2fff2ffcc77c7ffffffff777c7ff22222eeee2ee277777772e7eeeeeeeee22eeee2222eeee22eeeeeeee22eeee22eeeeee27777777777
777777777777777222e2feffff7ccc7ffffffffffcc7fff2222eeee2ee2777777772eeeeeeeeeee22eeee2222eeee22eeee2eeee2eeee222eeeeee2777777777
777777777777772ddd22ffefffffffffffffff4fffffff22222eee2e227777777772eeeeeeeeeee22eeee2222eeee22eeee22eeeeeeee2222eeeeee277777777
777777777777772ddd2d2fefffffefefffffffeffefeff2222eee222777777777772eeee222eeeee2eeee2222eeee22eeee22eeeeeeee222222eeeee27777777
777777777777772ddd2d2ffeffffffffffffffffffffff222eee2777777777777772eeee2222eeee2eeee2222eeee22eeee222eeeeeee22ee222eeee27777777
77777777777777722222222ff2ffffffffffffffffffff2eee227777777777777772eeee222eeeee2eeeee22eeeee22eeee2222eeeeee2eeee22eeee27777777
777777777777777772e2e272222ffffff44444fffffff22222777777777777777772eeeeeeeeeeee22eeeeeeeeee222eeee22222eeeee2eeeeeeeeee27777777
777777777777777772e2ee27772fffff4777774ffffff27777777777777777777772eeeeeeeeeee222eeeeeeeeee222eeee222222eeee22eeeeeeeee27777777
77777777777777772ee2ee277772ffffeeeeeeefffff277777777777777777777772eeeeeeeeee22772eeeeeeee2772eeee227722eeee222eeeeeee277777777
77777777777777772e2eeee277772ffffeeeeefffff277777777777777777777777722eeeeee227777722eeee2277772ee27777772ee277722eee22777777777
7777777777777772eeeeeee27777722ffffffffff227777777777777777777777777772222227777777772222777777722777777772277777722277777777777
777777777777772eeeeeee27777777722ffffff22777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777772eeeeeeee2777777777722222277777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7777777777772eeeeeee22777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777ddd7777dddd6d
777777777777722222227777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777d666d77d666d6d
777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777d666d77d666d6d
666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666d666d66d666d6d
777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777d77dd66ddddd6dd6d
6666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666d66dd666666666666dd
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777dd6d666626626666d7
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666eee6d66666626626666d6
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666eee6666666666666666d6
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666eee66666666666666666d
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666dddd6666666666666d
666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666dddddddd66666d
6666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666d66666d
6666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666d666666
666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666dddd6666666d66666
666666666666666666666666666666666222222226666666662222666222666666666622222266666666666622222266666666666666666d666dddddddd66666
6666666666666666666666666666666224444444422666666244442224442666666622449444226666666622444444226666666666666666dd666666666d6666
6666666666666666666666666666662ff44ffffff4426666244444244444426666624449444444266666624444444444266666666666666666d6dddddddd6666
6666666666666666666666666666662f44ff4444ff442662444242444224442666294449444444426666244777444444226666666666666666d6d66666dd6666
666666666666666666666666666662ff44fff4444f442662442d244422d2442662449494444499926666244774444444226666666666666666dd66666666d666
666666666666666666666666666662ff444ffff44f4926624422444244224426624494944449444926624444444444422226666666666666666666666666d666
666666666666666666666666666662fff44444444f492662444244424424442662444fff94944444266244444444444222266666666666666666666666666d66
6666666666666666666666666666629fff444444ff492662444299229924442662fff222f94444442662944444444442242666666666666666666666666666d6
666666666666666666666666666662999ffffffff449266d24442222224442d66d222ddd2f49994426629994444444244426666666666666666666666666666d
66666666666666666666666666666d299999999994422666294444444444926666ddd666d2444492d66d29999999994442d66666666666666666666666666666
6666666666666666666666666666662999999999442dd666d299444444992d6666666666624444f266662ff99999994442666666666666666666666666666666
666666666666666666666666666666d22999999942d666666d2299999922d666666666662444ff2d6666d22ffffff4422d666666666666666666666666666666
6666666666666666666666666666666dd22222222d66666666dd222222dd6666666666662fff22d666666dd22222222dd6666666666666666666666666666666
666666666666666666666666666666666dddddddd66666666666dddddd66666666666666d222dd666666666dddddddd666666666666666666666666666666666
6666666666666666666666666666666666666666666666666666666666666666666666666ddd6666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666662222226666666666222266622266666666662222226666666666622222222666666666666666666666666666666666
66666666666666666666666666666666224494442266666662444422244426666666224494442266666662244444444226666666666666666666666666666666
6666666666666666666666666666666244494444442666662444442444444266666244494444442666662ff44ffffff442666666666666666666666666666666
6666666666666666666666666666662944494444444266624442424442244426662944494444444266662f44ff4444ff44266666666666666666666666666666
666666666666666666666666666662449494444499926662442d244422d2442662449494444499926662ff44fff4444f44266666666666666666666666666666
666666666666666666666666666662449494444944492662442244424422442662449494444944492662ff444ffff44f49266666666666666666666666666666
666666666666666666666666666662444fff949444442662444244424424442662444fff949444442662fff44444444f49266666666666666666666666666666
666666666666666666666666666662fff222f94444442662444299229924442662fff222f944444426629fff444444ff49266666666666666666666666666666
66666666666666666666666666666d222ddd2f499944266d24442222224442d66d222ddd2f4999442662999ffffffff449266666666666666666666666666666
666666666666666666666666666666ddd666d2444492d666294444444444926666ddd666d2444492d66d29999999999442266666666666666666666666666666
666666666666666666666666666666666666624444f26666d299444444992d6666666666624444f266662999999999442dd66666666666666666666666666666
6666666666666666666666666666666666662444ff2d66666d2299999922d666666666662444ff2d6666d22999999942d6666666666666666666666666666666
6666666666666666666666666666666666662fff22d6666666dd222222dd6666666666662fff22d666666dd22222222d66666666666666666666666666666666
666666666666666666666666666666666666d222dd6666666666dddddd66666666666666d222dd666666666dddddddd666666666666666666666666666666666
6666666666666666666666666666666666666ddd666666666666666666666666666666666ddd6666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666222266622266666666222266622266666666662222226666666666662222226666666666666666666666666666666666
66666666666666666666666666666662444422244426666662444422244426666666224444442266666666224444442266666666666666666666666666666666
66666666666666666666666666666624444424444442666624444424444442666662444444444426666662444444444426666666666666666666666666666666
66666666666666666666666666666244424244422444266244424244422444266624477744444422666624477744444422666666666666666666666666666666
666666666666666666666666666662442d244422d2442662442d244422d244266624477444444422666624477444444422666666666666666666666666666666
66666666666666666666666666666244224442442244266244224442442244266244444444444222266244444444444222266666666666666666666666666666
66666666666666666666666666666244424442442444266244424442442444266244444444444222266244444444444222266666666666666666666666666666
66666666666666666666666666666244429922992444266244429922992444266294444444444224266294444444444224266666666666666666666666666666
66666666666666666666666666666d24442222224442d66d24442222224442d66299944444442444266299944444442444266666666666666666666666666666
66666666666666666666666666666629444444444492666629444444444492666d29999999994442d66d29999999994442d66666666666666666666666666666
666666666666666666666666666666d299444444992d6666d299444444992d66662ff9999999444266662ff99999994442666666666666666666666666666666
6666666666666666666666666666666d2299999922d666666d2299999922d66666d22ffffff4422d6666d22ffffff4422d666666666666666666666666666666
66666666666666666666666666666666dd222222dd66666666dd222222dd6666666dd22222222dd666666dd22222222dd6666666666666666666666666666666
6666666666666666666666666666666666dddddd666666666666dddddd66666666666dddddddd6666666666dddddddd666666666666666666666666666666666

__map__
0000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0011000028730287322873528730287351f720297302b7302973029735287302873026730267302473024721267312673026730217302173021732217302173529000290002900028000290002b0002900028000
00110000297202973029735297302973524720297302b73029730297252873028732267302673024720247312873128730287321f7301f7301f7301f7301f7250000000000000000000000000000000000000000
0011000028730287322873528730287351f7202873029730287302873526720267302473024730217302173126731267302673021730217322173221725000000000000000000000000000000000000000000000
0011000029722297302973529730297252472029732287302b7312b7212973229730287302872024720247201f7301f7321f7321f7301f7301f7251f005000000000000000000000000000000000000000000000
0111000000520135201a5201c5301c500185201d5301f530245222452218500185001f5201f5251f5050c50000520155201c5201e5201e5051a5201e520215202652026522185001850021520215250050000500
011100000052014520185201d53018500185201d530205302452024532185001850020530205350c5000c50000520135201a5201c5300c500135201a5301c5301f5201f53218500185001a5311c5301a53000000
011100000c520135201a5201c53018500185201d5301f5301c5321353013535135351f5301f5250c5000c5000c520155201c5201e520185001a5201e520215201e53215520155251553521530215250050000000
011100001372013720137251372013725137201872018720187221872018700187201c7201c7251c7201c7251572015720157251572015725157201a7201a7201a7251a720187051a7201e7221f7211e7201e725
0111000014720147201472514720147251472018720187201872218720187051872020720207251d7201d72513720137201372513720137251372018720187201872518720187251d7201c7201c7201372113725
011100000c0730007000075005702a6150000000000000000c07300070000750c0602a615000700c075000000c0730207002075025702a6150000000000000000c07302070020750e0752a615020700e07500000
011100000c0730507511065140652a6150000000000000000c0730507005075110752a615000000e075000000c073000750c075075752a6150000000000000000c073000750c000130712a615000001307500000
010900001d5201d5201c5201c5201d5201d5201f5201f5251f5221d5351c5201c52518520185201f5201f5201a5301a535290002900028000280000753007530135361f5461f5452b0052b0062b0052b0052b000
010900000c07300000000003470512604126050c1230c003296150000000150001651d3051d30500000000000c073071000000000000071300714513045000002b0350000000000046140f614216143461436604
011100001852014520185201d53018500185201d530205302453024532185001850020530205350c5000c5000752017520185201c5300c500185201c5301f530235302353218500245301f5301f5301853018535
011100000052014520185201d53018500185201d530205202453224522185001850020520205250c5000c50000520135201a5201c5300c500135201a5301c5301f5401f53218500185001a5411c5301a53000540
011100000c073000750c0750c0752a6150000000000000000c0730c075000000c0752a6150000000075000000c073000750c0750c0752a6150000000000000000c0730007500000130552a615000000707500000
011100000c0730007000075005702a6150000000000000000c073000700c055005752a6150000000075000000c0730207002075025702a6150000000000000000c0730205002055025702a615000000207500000
011100000c0730506505065055702a6150000000000000000c0730505005075050702a6150000002005000000c0730007000075005702a6150000000000000000c073005700c000070712a615000000757500000
01110000005001152014520185301850014520185301d53020530205322c7252c7151d5301d5350c5000c500005000c52013520185300c500185201f530245301a5301a5322b7252b71513530185301f53000000
011100000052014520185201d53018500185201d530205302453024532185001850020530205350c5000c5000e52013520175201f5300c5001a52021530235301f5301f532185001f50021531245302353012634
01110000005001152014520185301850014520185301d53020530205322c7252c7151d5301d5350c5000c500135100e520175201a5300c500175201d5301f5301a5301a5322b7252b7151a5301f5311f5301d500
011100000c0730507500000000002a6150000000000000000c0730507005075050752a6150000005075000000c0730707500000000002a6150000000000000000c0730707500000070712a615000000707500000
0111000022705207052c71522705000002c7152c7252270500000000002c72500000000002c715000000000000000000002b71500000000002b7152b7250000000000000002b72500000000002b7150000000000
011400001f5501f5521f5502354023540265502655224551245512455024555235502455523545215451f5502055024550205501b5501b5521a550185501f5501f5501f542215001f550215501f5651d5551a550
011100001105511050110551105011055130601405014052140521405018030180301d0321d03520020200251702517020170251703017025180201a0301a0321a0321a0301a0351a0351f0211f0251d0201d025
0111000000520135200e52010530185000c52011530135301853018532185001850013530135350c5000c50000520135200e52010530185000c52011530135301853018532185001651015530155301353013530
0111000000520135200e52010530185000c52011530135301853018532185001850013530135350c5000c50000520135200e52010530185000c52011530135301653516535155301650013530135351153013500
0111000022700207052b71522705000002b7152b7152270500000000002b71500000000002b7242b7050000000000000002b71500000000002b7152b7150000000000000002b715000001f7002b7242b7002b700
0111000022700207052b71522705000002b7152b7152270500000000002b715000002b7042b7152b7050000000000000002b71500000000002b7152b7150000000000000002b715000002b7052b7152b7002b700
011100000c073000750c0750c0752a6150000000000000000c07300070000750c0652a6150000000075000750c07300075000750c0752a6150000000075000000c0730007500075075752a61500000070752a615
011100000c073000750c0750c0752a6150000000000000000c073000750c0730c0652a61500000000750c0750c07300070000750c0752a6150000000075000000c0730007500075130552a61507055130742a615
01140000187461c7161f7161a7461f7161c7461a71613716187461a7161f7461c7161a7461f716187461a716187461c7161f7161a7461f7161c7461a71613716187461a7161f7461c7161a7501f7301c7601a750
010a00001f0351f0351e0351e0351d0301d0301c0301c0301b0301b0300000000000131300f1300b1300b130131400f1410f1410f1400f1500c151091610315203152031520310203102031000a0050000000000
010a000023530235302253022530215402154020540205401f5401f5421f500000001f0401b04017040230401f0421f0421f0401f042170410f0410f0400f0400f0400f0400f0000f0050f0050f0020f0020f000
011100001c0301f030240301e0301e0302103026030210352003023030280302a0312a0302a0322a0322a0302a032160000d00006000060022a0002a0002a000043000330003300033000c000000000000000000
011100001f0351f0351f035210302103521035210302103522035230352303025031250302503025030250322503536000250002a0002a7020c10009100031001700017000170001700017000170000000000000
0111000000000000000000002000020000200002000107351a7351c73520730227302273022732227322273222735167001c7001e7000f0000f0000f0000f00003102031000310003100031000a0050000000000
0111000000000000000000000000280002700026002240000413501135041300513006130061320613206132061320f4000f40007400074000640005400044000f0000f0000f0000f0050f0020f0020f00000000
01140000130700c0700000000000280002700026000240001307000070041000510010070070700610006100070700c0700f4000740007400064000540004400130700c0703c6150c0700e070130703c6153c614
01140000187501c7101f7101a7501f7101c7501a71013710187501a7101f7501c7101a7501f710187501a7101a7501d7101871021750157101d75018710217101a7501d71018750217101d75021710247501a710
011400000c070000703c6150000000000000003c615000000c070000703c615000000c070000703c615000000e070020703c6150000000000000003c615000000e070020703c615000000e070020703c61500000
011400001f3201f3221f3221f320003001c3101d3201f32024320243221f3221f3201d3201d3201c3201c3201a3201a322003001a3301a3201c3201d310213202132021322213222131000000000000000000000
011400001c7501f710237101f750177101f7501c7101f7101a7501d7102175018710157501d71018750217101b7501e71024710187501b7101e7502175024710237501f7101d7501a71023720287302774026730
0114000010070040703c6150000000000000003c615000000e070020703c615000000e070020703c6150000008070080703c6150c0700c070080703c6150f0700e070130703c61511070100710e0703c61500000
01140000233202332223312233200030024320233201f3101d3201d322003001c3101d3201c3201a310183101b3201b3221a3201a32018320183201b3201b3201a3201a322003001f310213201f3201e3201d310
011400001c7351f725231151f135177251f7551c7251f7151a7351d7252113518735151351d12518135217251b7351e725187251b7451a7351f1151d1351a1351814524135181350c14513105075600b5610f560
011400001f5501f5521f55023540235402655023551245402455024552245551c5501d5551f545215452455027550265502455027550265501d5641f540235502456024505005000050023320223222132020320
0114000028310293222b3222b3120030028310293202b32030320303222b3222b31029320293202832028310293202832229320263202631028320293202d3102132021322213120000000000000000000000000
011400002f3202f3222f3122f32000300303202f3202b32029320293220030028320293202832026310243202732026320243102732026320003001f320233312432000000000000000000000000000000000000
011400001c7601f710237101f760177101f7601c7101f7101a7601d7102176018710157601d71018760217101b7601e710187101b7601a7601f7101d7601a710187601f740267502872024760000000000000000
0114000010070040703c6150000000000000003c615000000e070020703c615000000e070020703c615000000c070080703c6151407013070070703c615070700c0700c0703c61500000000003c614000003c615
01140000187351c7251f1151a1251f7151c7551a72513725187351a7251f7551c7151a1451f115181351a7151a735187251d11521125157151d75518735217251a7251d71518125211151d13521115247551a715
011400000c075000703c6150007000060000603c615000000c070000703c615000700c070000703c615000700e075020703c6150207002060020603c615000000e070020703c615020700e070020703c61502070
011400001c5701c5721c5651d5601d5501f5701f560185501d5701d5621c5601c5501a5751a56518560155601a5611a5601a56015560155621556215550000000000000000000000000000000000001c5501d560
011400001c7351f725231151f135177251f7551c7251f7151a7351d7252113518735151351d12518135217251b7351e72524115181351b7251e7452171524725237351f7151d1251a115171351f1251d7651a755
0114000010070040703c6150407004060040603c6150e0000e070020703c615020700e070020703c6150207008070080703c6150c0700c070080703c6150f0700e070070703c61511070100700e0703c61500000
0002000012420124200b4100b4200b4100b4200b4100b4200b4100b41000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103000010550165301651024510295101d5202953035535355052950035500355003550501500355003550001500000000000000000000000000000000000000000000000000000000000000000000000000000
000100000f120106100b620056303a7003a7003a70000000397003970039700397000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102000018544185441a5441a5541c550185501e5501a5501f5501c550215501e550225501f5502455021550265502255028550245502b5502b5502e5502e556305623c5752f50030500305003c5000050000500
0003000036010390102d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000012550125501455015550175501b5502154000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200001d73019541185200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300001604509700167001670018700187001870013700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 0b0c4944
01 00071044
00 01081144
00 02070944
00 03080a43
00 05160a44
00 0d160a44
00 05120a44
00 13141544
00 00040944
00 010e0a44
00 02060944
00 03131844
00 0f194344
00 0f1a1c44
00 1d191b44
02 1e1a1b44
04 20214344
04 22232425
00 41424344
00 1f264344
01 27282944
00 2a2b2c44
00 27282f44
00 31323044
00 33343544
00 36371744
00 33343544
02 2d322e44
00 41424344
00 33674344
01 33354344
00 36174344
00 33354344
02 36174344

