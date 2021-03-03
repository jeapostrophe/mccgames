pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--dank tomb
cartdata("dank")function hd(x)
return flr(x+0.5)end
function je(r1,r2)if not r2 then
return ke(je,r1)end
return r1+(r2-r1)*rnd()end
function gl(ob,mf,t,x)ob[mf]=
t+(ob[mf]-t)*(x or 0.8)end
function nq(qz,er)qz=qz or {}
for k,v in pairs(er)do
qz[k]=v
end
return qz
end
function kq(ob,mj,bp,be)local cb=ob[mj]
if type(cb)=="function" then
cb=cb(ob,bp,mj,be)end
return cb or false
end
function ex(iy,ix,e)iy[ix]=iy[ix]or {}
add(iy[ix],e)end
function hu(n,d)d=d or 0
if n and n>=stat(16+d)+d then
sfx(n,d)end
end
rx=0
function qm(n)
n+=rx
sfx(-1)if ee~=n then
ee=n
music(n,300)end
end
function kt(jb)local iu,s={},1
im(jb,function(c,i)if c=="\n" then
add(iu,ob(sub(jb,s,i)))s=i
end
end)
return iu
end
function ke(fn,a)
return fn
and fn(a[1],a[2],a[3],a[4],a[5])or a
end
function ob(jb,er)local iu,s,n,rc=
{},1,1,0
im(jb,function(c,i)local sc,nr=sub(jb,s,s),i+1
if c=="(" then
rc+=1
elseif c==")" then
rc-=1
elseif rc==0 then
if c=="=" then
n,s=sub(jb,s,i-1),nr
elseif c=="," and s<i then
iu[n]=sc=='"'and sub(jb,s+1,i-2)or sub(jb,s+1,s+1)=="("and ke(is[sc],ob(sub(jb,s+2,i-2)..","))or sc!="f"and band(sub(jb,s,i-1)+0,0xffff.fffe)s=nr
if (type(n)=="number")n+=1
elseif sc!='"'and c==" " or c=="\n" then
s=nr
end
end
end)
return nq(er,iu)end
function im(jb,fn)for i=1,#jb do
fn(sub(jb,i,i),i)end
end
bh,ha={},{}
function bh:ej(lg)lg=ob(lg or "",{lr=self})for s in all(lg.lz)do
ha[s]=lg
end
return setmetatable(lg,{__index=self,__call=function(self,ob)ob=setmetatable(ob or {},{__index=lg})local ko,nv=lg
while ko do
if ko.oi and ko.oi~=nv then
nv=ko.oi
nv(ob)end
ko=ko.lr
end
return ob
end
})end
kb={}
function kb:__add(v2)
return v(self.x+v2.x,self.y+v2.y)end
function kb:__sub(v2)
return v(self.x-v2.x,self.y-v2.y)end
function kb:__mul(a)
return v(self.x*a,self.y*a)end
function kb:__pow(v2)
return self.x*v2.x+self.y*v2.y
end
function kb:__unm()
return v(-self.x,-self.y)end
function kb:__len()
return self.x*self.x+self.y*self.y
end
function kb:sk()
return self*(1/sqrt(#self))end
function kb:pq()
return v(-self.y,self.x)end
function kb:sf()
return v(flr(self.x),flr(self.y))end
function kb:__call()
return self.x..","..self.y
end
kb.__index=kb
function v(x,y)
return setmetatable({x=x,y=y},kb
)end
function ld(a,d)
return v(cos(a),sin(a))*d
end
bt=bh:ej()function bt:ir(v)
return ks(self.xl+v.x,self.yt+v.y,self.xr+v.x,self.yb+v.y
)end
function bt:cy(qj,c)rectfill(self.xl+qj.x,self.yt+qj.y,self.xr+qj.x,self.yb+qj.y,c)end
function bt:ek(b)
return
self.xr>b.xl and
b.xr>self.xl and
self.yb>b.yt and
b.yb>self.yt
end
function bt:rf(b,oq)local jc={v(b.xl-self.xr,0),v(b.xr-self.xl,0),v(0,b.yt-self.yb),v(0,b.yb-self.yt)}
if type(oq)~="table" then
oq=ob([[1,1,1,1,]])
end
local ml,mv=32767
for d,v in pairs(jc)do
if oq[d]and #v<ml then
ml,mv=#v,v
end
end
return mv
end
function ks(xl,yt,xr,yb)
return bt({
xl=min(xl,xr),xr=max(xl,xr),
yt=min(yt,yb),yb=max(yt,yb)
})
end
function o_(v1,v2)
return ks(
v1.x,v1.y,
v2.x,v2.y
)
end
function bd(sp,sz,qn,dp)
return {
sp=sp,sz=sz,qn=qn,dp=dp
}
end
function bm(self,c,dp)
if (self.z>=7)return
if self.py then
ll(self,self.py)
else
bn(self.fc or 8+max(self.z*0.5,0))
end
c=c or self.bd
local p,s,sp=
self.qj+(c.qn or v0),
c.sz or v(1,1),
(c.sp or self.gj)+flr(self.mz)
spr(sp,p.x,p.y+self.z,
s.x,s.y,dp or c.dp)
end
function br(ls,dj,mc)
local bv=1
return function(os,qw)
local rv=0
for i=0,os-1 do
local rd=peek(ls)
local kj=band(rd,bv)
if (kj>0)rv+=2^i
if mc then
poke(ls,
rd-kj+
band(1,shr(qw,i))*bv
)
end
bv*=2
if bv==256 then
bv=1
ls+=(ls%128==dj and 128-dj or 1)
end
end
return mc and qw or rv
end
end
function bo()
gd={}
for i=1,peek(0x2000)do
add(gd,ob([[
p=v(r(4),r(4)),
rs=v(r(7),r(6)),
rp=v(r(4),r(4)),
e=e(r(4),r(4),r(4),r(4)),
hx=r(3),s=r(2),
stat=r(8),co=r(3),
]]))end
end
is={v=v,b=ks,c=bd,r=br(8193,15)}
v0,nt,qc,ol=
v(0,0),ob([[
v(-1,0),v(1,0),v(0,-1),v(0,1),
]]),ob([[2,1,4,3,]]),
ks(512,512,512)
jy=kt([[
0,-1,0,
0,1,0,
-1,0,0,
1,0,0,
0,0,1,
]])function hy(s,x,y,c,a)
x-=a*4*#(s.."")
for d in all(jy)do
print(s,x+d[1],y+d[2],c*d[3])end
end
bl=bh:ej([[
t=0,mq="nn",z=0,tm=0,
qo=1,
]])oj=ob([[
"q_","io",
"eq","gm","ft","id",
"pu","fo","qy",
"bk","eo",
"jm","pb","bi",
]])function lk(e,fn)for mf in all(oj)do
if (e[mf])fn(fw,mf,e)
end
end
function g_(l,mf,e)del(l[mf],e)end
function bl:oi()
if (self.kw)jw(self,self)
ju+=1
gz[ju]=self
lk(self,ex)end
function bl:ij(mq)self.mq,self.t=mq,0
end
function fl()for n,e in pairs(gz)do
local bu=e[e.mq]
if bu and bu(e,e.t)or e.rh then
gz[n]=nil
lk(e,g_)else
e.t+=1
end
end
end
function le(fk)for e in all(fw[fk])do
e[fk](e)end
end
dk=bl:ej()function dk:q_()bm(self)end
function ho()local ky,ib={},kv(5)for e in all(fw.q_)do
ex(ky,e.cu or flr(e.qj.y),e)end
for y=-2,130 do
if y%8==0 then
map(0,y*0.125,0,y,16,1)elseif y==129 then
bn(hf.l_)map(0,0,0,0,16,16,128)end
for e in all(ky[y])do
if e.jv and e.z<=0 then
local sd=e.qj+e.jv-e.gf
ma(ib,sd.x,sd.y,e.gf.x*2+1,e.gf.y*2+1,2)end
e:q_(e.qj+v(0,e.z),e.z,e.t)bn()end
end
end
es=bh:ej([[
kf=b(0,0,8,8),
ft=1,z=0,
]])jz=es:ej()function jz:ft(e)local op=id[self.mp.y-1][self.mp.x]
return op and kq(op,"ft",e,true)end
nl=es:ej()function nl:oi()for d in all(nt)do
local p=self.mp+d
local tt=hi(p.x,p.y)ex(self,"gm",band(tt,6)==0)end
end
sb={c1=es,c2=nl,c4=nl,c16=jz,}
function gx()id={}
for y=-1,16 do
ex(id,y)for x=-1,16 do
local c,mp=
sb["c"..hi(x,y)],v(x,y)if c then
id[y][x]=
c({mp=mp,qj=mp*8})end
end
end
for ge in all(fw.id)do
local mp=ge.qj*0.125
id[mp.y][mp.x]=ge
g_(fw,"ft",ge)end
end
function la(self)self.ie=false
if abs(self.z)<=self.sa then
hs(self,"ft",function(e,o)self.ie=self.ie or kq(o,"ft",e)and o
end,true,self.iw)elseif self.z>0 then
hs(self,"ft",dm,true)end
end
function dm(me,qa,e)
return kq(qa,e,me)end
function hz()hu(62)
og+=1
ia.kf=ol
ia:ij("i_")end
function dl(e,bx)
if (e.z>7)return ol
return (bx or e.kf):ir(e.qj or v0)end
fe={}
function hs(cn,mf,cb,g,bx)add(fe,{e=cn,p=mf,cb=cb,g=g,bx=bx})end
function nj()for c in all(fe)do
local e=c.e
local eb=dl(e,c.bx)if c.g then
for x=flr(eb.xl*0.125),flr((eb.xr-0.001)*0.125)do
for y=flr(eb.yt*0.125),flr((eb.yb-0.001)*0.125)do
local o=id[y]and id[y][x]
if o and o[c.p]then
eb=fu(c,e,o,eb)end
end
end
end
for o in all(fw[c.p])do
if o~=e and
#(o.qj-e.qj)<576 and
eb:ek(dl(o))then
eb=fu(c,e,o,eb)end
end
end
fe={}
end
function fu(c,e,o,eb)local ez=c.cb(e,o,c.p)if ez then
local rf=eb:rf(dl(o),ez)if rf then
e.qj+=rf
eb=eb:ir(rf)end
end
return eb
end
jn=ob("yt=16000,")function cq(r_,db,ln)local pm,fg,ov={},{},#r_
for i=1,ov do
fb(r_[i],r_[i%ov+1],pm,fg
)end
db=db or jn
local om,gw,hl,hr=
db.yt,db.yb,db.xl,db.xr
for y,xl in pairs(pm)do
local xr=fg[y]
if y<om or y>gw then
ln(xl,xr,y)else
local cl,cr=
min(hl,xr),max(hr,xl)if xl<=cl then
ln(xl,cl,y)end
if cr<=xr then
ln(cr,xr,y)end
end
end
end
function fb(a,b,pm,fg)local ax,ay=a.x,hd(a.y)local bx,by=b.x,hd(b.y)
if (ay==by)return
local x,dx,eg=
ax,(bx-ax)/abs(by-ay),1
if by<ay then
fg,eg=pm,-1
end
for y=ay,by,eg do
fg[y]=x
x+=dx
end
end
function qd(sg)
return mid(hd(sg),0,127)end
function ma(ln,xs,ys,w,h,bg)local x1,x2,r=
qd(xs),qd(xs+w-1),0
for y=qd(ys),qd(ys+h-1)do
if bg then
r=max(0,bg-min(y-ys,ys+h-1-y))end
ln(x1+r,x2-r,y)end
end
function c_(c)
return function(x1,x2,y)rectfill(x1,y,x2,y,c)end
end
function di(f_)_sqrt={}
for i=0,4096 do
_sqrt[i]=sqrt(i)end
for lv=1,f_ do
local ls=0x4300+lv*0x100
local sx=lv-1
for c1=0,15 do
local nc=sget(sx,c1)local ew=shl(nc,4)for c2=0,15 do
poke(ls,ew+sget(sx,c2))
ls+=1
end
end
end
end
function kv(l)local eh=0x4300+shl(l,8)
return function(x1,x2,y)local bs=eh
local mr=0x6000+shl(y,6)local gi,gb=
mr+band(shr(x1+1,1),0xffff),mr+band(shr(x2-1,1),0xffff)if band(x1,1.99995)>=1 then
local a=gi-1
local v=peek(a)poke(a,band(v,0xf)+
band(peek(bor(bs,v)),0xf0))end
for ls=gi,gb do
poke(ls,peek(bor(bs,peek(ls))))end
if band(x2,1.99995)<1 then
local a=gb+1
local v=peek(a)poke(a,band(peek(bor(bs,v)),0xf)+
band(v,0xf0))end
end
end
dq=ob([[
420,756,1092,1428,1764,
]],{[0]=-10000})ch={function()end,kv(2),kv(3),kv(4),kv(5),c_(0)}
function lb(lx,ly,co)local hk,ev,ru=
co*co,ch,{}
return function(x1,x2,y)local ox,oy,oe=x1-lx,y-ly,x2-lx
local jg,km=
hk*je(0.92,1.08),oy*oy
local d_,lp,b_,p_=
km+ox*ox,km+oe*oe
for lv=5,0,-1 do
local r=band(dq[lv]*jg,0xffff)if not b_ and d_>=r then
b_=lv+1
if (p_)break
end
if not p_ and lp>=r then
p_=lv+1
if (b_)break
end
end
local lq,dv=1,max(b_,p_)local od=max(x1-lx,lx-x2)for lv=dv-1,1,-1 do
local hq=band(dq[lv]*jg,0xffff)local hp=_sqrt[hq-km]
if not hp or hp<od then
lq=lv+1
break
end
ru[lv]=hp
end
local xs,xe=x1
for l=b_,lq+1,-1 do
xe=lx-ru[l-1]
ev[l](xs,xe-1,y)xs=xe
end
for l=lq,p_-1 do
xe=lx+ru[l]
ev[l](xs,xe-1,y)xs=xe
end
ev[p_](xs,x2,y)end
end
function fv(n)local a=0x5000
for p=0,n do
local pj,iz=p,8
if p>=24 then
pj=13+p/8
iz+=p%8
end
for c=0,15 do
local v=sget(iz,sget(pj,c))
if (c==3)v+=0x80
poke(a,v)
a+=1
end
end
end
function bn(no)memcpy(0x5f00,0x5000+shl(flr(no or 8),4),16)end
function ll(o,mx)bn(hf.l_+
mid((o.qj.y-jr.qj.y)*0.4+o.z*0.5,0,mx))end
function qt()local qf=
sh()for e in all(fw.pu)do
foreach(e.pu,qf)end
end
ne=ob([[
v(-1,1),v(-1,-1),v(1,-1),v(1,1),
]])function sh()local p,kz=jr.qj,jr.kz+1
local fx,nh=
kz*kz,c_(0)
return function(kx)local s,e,pp=kx.s,kx.e,p-kx.d*3
if (kx.d^(pp-s)<=0)return
local ds,de=s-pp,e-pp
if (#ds>fx and #de>fx)return
local cs,ce=
kz/max(abs(ds.x),abs(ds.y)),kz/max(abs(de.x),abs(de.y))local ps,pe=
ds*cs,de*ce
local qs,qe=mo(ps),mo(pe)
if (qs<qe)qs+=4
local r_={s,e,pp+pe}
for q=qe,qs-1 do
add(r_,p+ne[q%4+1]*kz)end
add(r_,pp+ps)cq(r_,kx.h,nh)end
end
function mo(v)
return abs(v.x)>abs(v.y)and 2+sgn(v.x)or 3+sgn(v.y)end
oh=bl:ej([[
oc=0,bk=1,z=0,vz=0,
kf=b(-2,-3,2,2),iw=b(-1,-2,1,1),
gf=v(5,2),
bb=e(v(3,-3.5),v(-4,-3.5),v(-1,-1),v(-1,-3.5)),
eq=1,ie=e(),
sa=1,
cm=c(62,v(2,1),v(-8,-15)),
cf=c(10,v(2,1),v(-8,-7)),
gs=e(0,0,0,26,28,26,30,26,28,26,30,42,44,42,46,10,12,10,14),
]])function oh:nn()self.cv=v0
self:dc(1)if #self.cv>0 then
self.cv=self.cv:sk()*0.6
self.qj+=self.cv
self.oc+=0.1667
if self.oc%3<0.1 then
hu(39)end
else
self.oc=0
end
self.jv=self.bb[self.mg]
if btnp(4)or not self.ie then
self:ij("kn")end
self:gy()end
function oh:kn(t)self.oc=1
self:dc(0.1)if btn(4)then
if self.vz>=0 and t<3 then
hu(53)self.vz=-0.5
elseif t<10 then
self.vz-=0.1
end
end
self.cv*=0.857
self.qj+=self.cv
self.z+=self.vz
self.vz+=(self.ie and 0.06 or 0.125)
if self.z>=0 and self.ie then
self.z=0
hu(44)
return self:ij("nn")elseif self.z>5 and not self.ok then
hu(58)
og+=1
self.ok=true
elseif self.z>14 then
self:ij("ca")end
self:gy()end
function oh:i_(t)
if (t>=24)jr.dh=0
self.gf*=0.92
self:gy()end
function oh:gy()hs(self,"gm",dm,true)la(self)if jr.co<0.05 then
jp=function()dy(self.et)end
end
end
function oh:dc(ns)for i=1,4 do
if btn(i-1)then
self.mg=i
self.cv+=nt[i]*ns
end
end
end
function oh:ca()self:gy()jr.dh=0
end
function oh:q_(p,z,t)if self.mq=="i_" then
local jj=
mid(0,16,60-t*2)bn(20+min(t/3,3))
p-=v(jj,jj)*0.5
sspr(64,0,16,16,p.x+je(-0.15,0.15)*t,p.y-5,jj,jj)else
local gg=self.mg==1
self.cf.sp=
self.gs[self.mg*4+flr(self.oc%4)]
bm(self,self.cm,gg)bm(self,self.cf,gg)end
end
ef=bl:ej([[
kf=b(-1,-1,1,1),
d=e(0,1),sp=e(0.03,0.07),c=14,
qj=v(0,0),lo=v(0,-4),
]])function ef:nn()local dr=nt[ia.mg]
if self.n_ then
self.qj=self.n_.qj+self.mu
end
local jt=self.qj-ia.qj
local rq,fp,kg=
(rr:hg(94,true)and 28 or 4)+(n_ and 7 or 0),dr^jt,dr:pq()^jt
if self.mg~=ia.mg or
ia.mq~="nn" or
fp>rq or
fp<0 or
abs(kg)>7
then
self:h_()end
local n_=self.n_
if n_ then
local eu=fp>9
if n_.z>2 or
n_.qp and eu or
n_.ic and not rr:hg(n_.ic)then
return
end
if btnp(5)then
if eu then
for i=7,fp,2 do
pg:add(1,ia.qj+self.lo+
dr*i,ef)end
end
n_:lf()self:h_()end
rr:hg(94,not eu)self.kp=n_
else
self.qj+=dr*3
hs(self,"eo",function(e,t)e.n_,e.mu=t,e.qj-t.qj
end)hs(self,"gm",dm,true)self.n_=nil
end
end
function ef:h_()self.mg,self.qj,self.n_=
ia.mg,ia.qj+nt[ia.mg],nil
end
function ef:fo()local kp=self.kp
if kp then
local p=kp.qj+kp.ka
p.y+=sin(dg)*2
spr(255,p.x-#kp.eo*2,p.y-1)hy(kp.eo,p.x,p.y,7,0.5)self.kp=nil
end
end
iv=bl:ej()function iv:fo()bn()rectfill(0,122,8*#self.fi-1,124,1)for x,it in pairs(self.fi)do
spr(it.bq,x*8-8,118+sin(dg)*it.a
)if it.dw>1 then
print(it.dw,x*8-4,123,7)end
it.a*=0.5
end
end
function iv:hg(bq,qv)for i,it in pairs(self.fi)do
if it.bq==bq then
if (not qv)it.a=2
return it,i,it.dw
end
end
return nil,#self.fi+1,0
end
function iv:js(bq,d)cn,ix,dw=self:hg(bq)
dw+=d
if dw==0 then
del(self.fi,cn)else
self.fi[ix]={bq=bq,dw=dw,a=0}
end
end
lh=bl:ej([[
co=0.02,dh=1,
]])function lh:nn()gl(self,"co",self.dh*(1-hf.co*0.05),0.91)self.qj,self.kz=
(self.qk or ia).qj:sf(),flr(42*self.co)end
function lh:gp()local r=self.kz
return
self.qj.x-r,self.qj.y-r,r*2+1,r*2+1
end
function lh:lt()ma(lb(self.qj.x,self.qj.y,self.co
),self:gp())end
pi=dk:ej([[
lz=e(5),rg=220,qn=v(-4,8),
kf=b(-1,-8,8,0),py=6,
bd=c(5,f,v(0,-16)),
ry=45,il=3,eo=f,
cj=e("=2,.=2),
eo="  read",ic=111,qp=1,
ey=e(),
ka=v(4,-22),
t=1000,
]])ig=ob([[
""past shadows so dark_",
"beyond sands windswept_",
"in the desert's cold heart",
"a strange portal slept."",
""seven kings went through_",
"one madman returned_",
"his eyes struck blind",
"by secrets he learned."",
""beyond limestone walls_",
"past traps beyond count_",
"he banished the stories",
"he dared not recount."",
"- progress saved -",
]])function pi:lf()pi.ey[self.c1],self.t=
ig[self.c1],-110
sfx(59,0)end
function pi:fo()local st,t=
flr(self.c1/4-0.01)*4+1,self.t*2
rectfill(t-200,10,t+200,self.ry,0)for ln=0,self.il do
local s=pi.ey[st+ln]or "..."if t<380 then
local x=64-#s*2
im(s,function(c,i)
if (c=="_")c=","
local pt=
max(abs(i-t/4)-37,8)if pt<15 then
bn(pt)print(c,x,12+ln*8+sin(dg+i*0.05)*1.5,self.cj[c]or 15)end
x+=4
end)end
end
end
hb=pi:ej([[
lz=e(89,90,95),qn=v(0,4),rg=f,
jv=v(4,0),
gf=v(5,2),
eo=f,c1=17,il=0,ry=18,
bd=c(f,f,v(0,-7)),py=f,
ka=v(4,0),
kf=b(1,-3,7,3),
qy=0,qo=0,mz=0,
d=e(4,7),gn=0.8,
a=0.25,sp=e(0.2,1.5),
r=1,c=10,
]])ro=hb:ej([[
lz=e(77,94,78,79),qn=v(-4,8),
ro=1,
]])function hb:nn()self.z=sin(dg)*2-3+self.mz*15
end
function hb:io()ga(self.z<=7,3)end
function hb:gm(e)if e.bk then
rr:js(self.gj,1)self.mz=1
pg:add(20,self.qj+self.ka,hb)if self.ro then
qm(30)else
if self.gj==90 then
local _,__,gq=rr:hg(90)ig[17]="idols found: "..gq.."/7"self:lf()end
hu(60)end
end
return true
end
j_=kt([[
en=e(192),hc=216,l_=8,wd=6,jx=0,rg=192,gv=0,
en=e(205,206),hc=221,l_=32,wd=4,jx=0,rg=205,gv=0,
en=e(209),hc=52,l_=24,wd=6,jx=-1,rg=209,gv=0,
en=e(209),hc=52,l_=8,wd=6,jx=0,rg=209,gv=0,
en=e(205,206),hc=221,l_=32,wd=4,jx=0,rg=246,gv=0,
en=e(209),hc=52,l_=24,wd=6,jx=-1,rg=246,gv=0,
]])function fz()k_,kr={},v(4,10)for rd in all(gd)do
rd.hf=
jk(nq(nil,nq(rd,j_[rd.hx])))k_[rd.p()]=rd.hf
end
fm()dy(3)end
ot=bl:ej([[
lz=e(32),d=16,pf=1,jx=0,
]])fs=ot:ej([[
pf=2,jx=28,
ci=e(90,88,93,1,1,s=1,go=-1),
]])mb={kt([[
32,45,25,5,1,go=1,s=1,
"arrows        ",37,46,13,0,go=-1.3,
"       … walk",37,46,1,0,go=-1,
"@itsmerobertk",60,8,1,1,go=-0.5,
"@grubermusic",68,8,1,0,go=-0.5,
" c           x       ",22,53,13,0,go=1.3,
"@krajzeg",64,2,1,0.5,go=0.5,
"   … jump     … use",22,53,1,0,go=1,
]]),kt([[
32,43,21,5,1,go=1,s=1,fc=15,
32,43,23,5,1,go=1,s=1,fc=15,
32,43,22,5,1,go=1,s=1,
"well done!",64,72,7,0.5,go=-1,
"time:",28,86,10,0,go=1,
"",98,86,9,1,go=-1,
"deaths:",28,104,10,0,go=1,
"",98,104,9,1,go=-1,
"idols:",28,95,10,0,go=1,
]])}
function fs:oi()sfx(38,0)local tx=mb[2]
local a,b,gq=rr:hg(90)tx[8][1]=og
for i=1,7 do
tx[17-i]=nq(nq(nil,self.ci),{nil,64+i*4,fc=i<=gq and 8 or 13})end
tx[6][1]=flr(dg/60).."\77"..
flr(dg%60).."\83"fw.fo={self}
end
function ot:nn(t)local p=ia.qj
p.y=min(p.y,122)self:fd("d",0,16,0.6,p.y>100)if t==50 then
qm(self.jx)end
end
function ot:fo()for tt in all(mb[self.pf])do
bn(tt.fc)camera(tt.go*self.d*self.d,0)ke(tt.s and spr or hy,tt)end
camera()end
nk=bl:ej([[
qj=v(0,128),z=0,
jo=e(f=0.2,d=e(0,0),gn=1,ck=0,l=0,rd=0),
]])function nk:add(n,qj,lj)lj=nq(nq({},nk.jo),lj)for i=1,n do
local a=rnd()local d=ld(a,je(lj.d))
d.y*=lj.gn
self.ps[rnd()]=nq({p=qj+d,v=ld(lj.a or a+lj.ck,je(lj.sp)),ba=0x5080+lj.c
},lj)end
end
function nk:q_()for k,p in pairs(self.ps)do
p.p+=p.v
p.l+=p.f
if p.l>=7 then
self.ps[k]=nil
end
circ(p.p.x,p.p.y,p.rd,peek(p.ba+shl(max(0,flr(p.l)),4)))end
end
bw=bl:ej([[
ka=v(64,67),
]])function bw:nn()
if (ia.qj-self.ka)^nt[self.dr]>63 then
ia.et=self.dr
ia:ij("ca")
return true
end
end
oz=pi:ej([[
lz=e(60),rg=225,qn=v(0,0),
qo=0,c1=13,
oa=v(34,23),
ni=v(64,56),rj=1,
ry=18,il=0,
nm=e(b(2,2,7,3),f,b(2,3,3,7)),
pd=e(b(2,1,7,2),f,b(2,3,2,7)),
d=e(8,32),gn=0.8,
a=0.25,sp=e(0.2,1.2),
r=1,c=12,
]])function oz:nn()if #(ia.qj-self.ni)<400
and self.rj then
fm(true)self:lf()hu(60)self.rj,jr.co=false,1
pg:add(40,self.ni,oz)end
end
function oz:q_()map(20,12,32,32,8,8)for y=2,9 do
for x=0,9 do
local xy=v(x,y)local hf=ou(xy)if hf then
local p,pc=
self.oa+xy*6,hf.gv>0
for d=1,3,2 do
local qa=ou(xy-nt[d])if hf.md[d]and qa then
local dh=pc and qa.gv>0 and 9 or 13
self.nm[d]:cy(p,dh)self.pd[d]:cy(p,0)end
end
spr(pc and 59+hf.s or 58,p.x,p.y)end
end
end
end
function ou(v)local hf=k_[v()]
return hf and (hf.gv>0 or hf.s~=1)and hf
end
gk=dk:ej([[
bd=c(123,f,v(-4,-8)),
kf=b(-3,-3,3,3),
d=e(1,2),sp=e(0.25,0.5),f=0.3,c=11,
e_=e(d=e(0,1),sp=e(0.1,0.2),f=0.4,c=11),
]])function gk:nn(t)
self.qj+=self.v
if (self.v.y>0 and t<9)return
hs(self,"gm",self.jq,true)hs(self,"bk",self.jq)pg:add(rnd(1.5),self.qj-v(0,4),gk.e_)end
function gk:jq(o)
if (self.rh)return
if (o.bk)hz()
hu(56)self.rh,li=true,1
pg:add(7,self.qj,gk)end
jd=dk:ej([[
lz=e(124),qn=v(4,8),qo=2,rg=220,
bd=c(124,f,v(-4,-12)),
dr=v(0,2),oo=v(0,-16),py=4,
]])qh=jd:ej([[
lz=e(93),qn=v(-8,0),rg=220,
bd=c(93,f,v(0,-3)),py=f,
dr=v(-2,0),oo=v(4,5),
]])function jd:nn()local _,ql=ra(self,self.c2==255 and 15 or 20,not on(self))if ql then
hu(55)gk({qj=self.qj+self.oo,v=self.dr
})end
end
function on(e)local rs=band(lm,e.c1)==e.c1
if e.rl~=nil and rs~=e.rl then
hu(rs and e.cz or e.bj)end
e.rl=rs
return rs
end
function bl:fd(mf,mn,mx,m,up)
if (up==nil)up=on(self)
local gr=self[mf]
self[mf]=mid(mn,mx,up and gr-m or gr+m)
return self[mf]~=gr
end
function ra(e,qx,qg)
if (not qg)e.tm+=1
local qu=shl(1,e.tm/qx%8)local on=band(e.c2 or e.c1,qu)>0
return on,on and not qg and e.tm%qx==0
end
function ga(mt,qw)if mt then
lm=bxor(lm,qw)end
end
bc=bl:ej([[
lz=e(128),rg=1,qo=2,
]])function bc:io()ga(ra(self,30),self.c1)end
qi=bl:ej([[
lz=e(199),rg=199,qn=v(0,8),
kl=0,
kf=b(1,-7,7,-1),
fr=e(v(2,-6),v(5,-6),v(1,-3),v(4,-3)),
]])dn=qi:ej([[
lz=e(200),qo=2,qy=0,
]])function qi:nn()local ej=
ra(self,21,self.qo==2 and not on(self))if ej and self.kl==0 then
hu(51)end
self:fd("kl",0,6,-1,ej)if self.kl>4 then
hs(self,"bk",hz)end
end
function qi:q_(p)for so in all(self.fr)do
local sp=p+so
sspr(64,96,2,self.kl,sp.x,sp.y-self.kl)end
end
cx=dk:ej([[
lz=e(104),rg=219,
z=0,
kf=b(0,0,8,8),
bd=c(104,v(1,2)),
id=1,
lstsnd=0,cz=47,bj=47,
]])function cx:nn()local nz
if self.qo==2 then
nz=ra(self,23,not on(self))end
self:fd("z",0,12,1.5,nz)end
function cx:ft(e)if e.eq then
self.z,self.mm=
max(self.z,1),true
end
return self.z<5
end
ii=cx:ej([[
lz=e(120),qo=2,qy=0,
]])nd=cx:ej([[
lz=e(105),dz=30,qo=0,
bd=c(105,v(1,2)),
]])function nd:nn()if self.mm then
self.dz-=1
if self.dz<=0 then
if not self.mz then
self.mz=1
hu(48)end
self.z+=0.5
end
end
end
qq=cx:ej([[
lz=e(3),qo=0,
bd=c(3,v(1,2)),
z=7,fc=15,
d=e(0,3),a=0.25,sp=e(0,0.05),c=9,
]])function qq:nn()local cp=self.qj+v(4,4)local d=#(cp-ia.qj)<225
and not (ia.ie and ia.ie.pb)and rr:hg(78)and self.pw
if (d and self.fc==15)hu(50)
self:fd("fc",8,15,0.6,d)self:fd("z",0,7,0.7,d)if rnd()<0.02 then
pg:add(1,cp,qq)end
self.pw=true
hs(self,"pb",function()self.pw=false
end)end
pb=dk:ej([[
lz=e(91),rg=219,qn=v(0,-8),
qy=0,qo=2,
pb=1,
kf=b(0,0,16,16),
delay=0,
gr=v(0,0),
bd=c(75,v(2,3)),
z=1,
]])gc=pb:ej([[
lz=e(37),kf=b(0,0,8,8),qn=v(0,0),
bd=c(37,v(1,2)),
]])function pb:oi()self.sw,self.cv=
self.c2%16,self.cv or
nt[flr(self.c2/16)]*0.5
end
function pb:nn()local d=self.qj-self.gr
for h in all(self.nz)do
h.qj+=d
end
self.nz,self.gr=
{},self.qj
if on(self)then
self.qj+=self.cv
self.fc=8
hs(self,"ft",function(e,o)if kq(o,"ft",self)then
self:ij("np")hu(46)
return true
end
end,true)else
self.fc=6
end
end
function pb:np(t)if t==16 then
for i=1,self.sw do
self.cv=self.cv:pq()end
self:ij("nn")end
end
function pb:ft(e)if not e.pb then
add(self.nz,e)end
return true
end
ms=pb:ej([[
lz=e(22),
bd=c(6,v(2,2)),
kf=b(0,0,16,15),qn=v(0,-7),
]])function ms:io()ga(self==ia.ie,self.c1)end
pv=bl:ej([[
lz=e(201),qn=v(0,8),
kf=b(0,-32,8,0),
cboxn=b(0,2,-1,3),
gm=1,ht=32,
pu=1,qy=0,
kw=e(
e(s=v(0,-31),e=v(0,0)),
e(s=v(7,0),e=v(7,-31))),
cz=61,bj=61,
si=e(kf=b(0,-32,8,0),dd=0),
ea=e(kf=b(0,2,0,2),dd=16,pu=e()),
]])function pv:oi()self.si=nq({},self.si)jw(self.si,self)end
function pv:nn(t)if self:fd("ht",16,32,2)and
abs(self.ht-24)==8 then
li=2
end
nq(self,self.ht>23
and self.si or self.ea)self.cu=
self.qj.y-self.dd
end
function pv:q_(p,z)bn(hf.l_+8-self.ht/4)sspr(80,96,8,z>0 and z or self.ht,p.x,p.y-self.ht)end
function pv:bi()if self.ht>=32 then
self:q_(self.qj,24)end
end
cc=bl:ej([[
lz=e(102),qn=v(0,8),
gu=6,
kf=b(0,-12,16,-1),
py=4,
bd1=c(70,v(1,3),v(0,-24)),
bd2=c(70,v(1,3),v(8,-24),1),
db=b(-1,-2,16,-24),
gm=1,
ki=b(0,-80,15,-23),
cz=61,bj=61,
]])function cc:nn()if self:fd("gu",0,6,1)and
abs(self.gu-3)==3 then
li=1.5
end
self.gm=self.gu>3
end
function cc:fo()if self.gm then
self.ki:cy(self.qj,0)end
end
function cc:q_(p)local gu=self.gu
bm(self,self.bd1)bm(self,self.bd2)sspr(62-gu,32,gu,16,p.x+2,p.y-18)sspr(66,32,gu,16,p.x+14-gu,p.y-18)end
df=bl:ej([[
lz=e(195),qo=0,
gm=1,qy=0,
eo="  ???",ic=111,qp=1,
ka=v(4,-20),
kf=b(0,-16,8,0),
ki=b(0,-40,-48,8),
qn=v(0,16),
cu=130,
mp=v(0,-40),mx=127,my=1,mw=1,mh=6,
]])bf=df:ej([[
lz=e(211),rg=1,
mx=127,my=7,mw=1,mh=5,
ki=b(8,-40,48,8),
]])nf=df:ej([[
lz=e(243),
kf=b(0,0,16,8),
ki=b(-8,0,30,48),
qn=v(0,0),
mp=v(-8,-8),mx=124,my=0,mw=4,mh=1,
]])function df:lf()hu(61)self.z,li=10,3
end
function df:q_(p)
if (self.z>0)return
self.ki:cy(p)
p+=self.mp
map(self.mx,self.my,p.x,p.y,self.mw,self.mh
)end
jl=bl:ej([[
lz=e(34),qn=v(12,70),rg=219,
kf=b(-8,-8,8,8),
ka=v(64,54),m_=v(64,54),
ct=v(64,120),
jj=0,dr=3,
d=e(8,11),f=0.4,rd=1,
sp=e(0.2,0.4),ck=0.23,
l=-4,c=10,
]])function jl:nn()local cg=0.3
if on(self)then
cg=0
ia.fc=max(20,24-#(ia.qj-self.qj)/256)hs(self,"bk",function()if ia.z<5 then
fs()ia.qj=self.ct
ia:ij("s_stuck")end
end)end
if ia.mq~="s_stuck" then
hu(cg==0 and 54 or 40,1)end
gl(self,"qj",self.ka+(ia.qj-self.m_)*cg,0.9
)jr.qk=self
end
function jl:q_(p)
p-=v(0,4)
self:fd("jj",3,11,-1)circfill(p.x,p.y,self.jj,10)pg:add(self.jj-7,p,jl)
p+=ld(rnd(),1.5)
circfill(p.x,p.y,0.68*self.jj,7)end
pa=dk:ej([[
mz=0,kd=0,qy=0,
]])function pa:io()if self.mz~=self.kd then
hu(57)end
self.kd=self.mz
ga(self.mz==1,self.c1)end
dt=pa:ej([[
lz=e(117),id=1,
kf=b(0,0,7,7),
bd=c(117),
]])function dt:nn()self.mz=0
end
function dt:ft(o,n,px)
if (abs(o.z)<0.5 and not px)self.mz=1
return true
end
mk=pa:ej([[
qy=f,id=f,
lz=e(160),qo=2,rg=219,
kf=b(0,-31,7,0),
bd=c(127,v(0,0)),mz=0,
]])function mk:nn()hs(self,"bk",function()if band(lm,self.c2)==self.c2 then
self.mz=1
end
end)end
jm=pa:ej([[
lz=e(109),bd=c(109,f,v(0,-8)),qn=v(0,8),
eo=" ",gm=1,
ka=v(3,-16),
kf=b(0,-7,8,0),jm=1,
]])fy=jm:ej("lz=e(110),qn=v(4,7),kf=b(0,-6,8,1),")function jm:lf()self.mz=1-self.mz
end
cw=pa:ej([[
lz=e(73),qn=v(-4,8),rg=1,
kf=b(-1,-8,8,0),
bd=c(73,f,v(0,-14)),
py=6,eo="  insert",qp=1,ip=-1,
ka=v(4,-20),
c2=89,
jf=e(
e(eo="  insert",mz=0,ip=-1),
e(eo="  take",mz=1,ip=1)),
]])hv=cw:ej([[
lz=e(74),mz=1,
]])function cw:nn()self.ic=self.mz==0 and self.c2
nq(self,self.jf[self.mz+1])end
function cw:lf()rr:js(self.c2,self.ip)self.mz,self.z=
1-self.mz,band(self.c1,128)end
gh=cw:ej([[
lz=e(56),qn=v(0,8),qo=2,
rg=f,kf=b(0,0,8,-8),
gm=1,py=2,
bd=c(40,v(1,2),v(0,-16)),
]])function gh:q_(p)bm(self)bn(15-self.mz*7)palt(0,true)spr(self.c2,p.x,p.y-13)end
function jw(t,e)t.pu={}
for wd in all(e.kw)do
local p1,p2=
e.qj+wd.s,e.qj+wd.e
add(t.pu,{s=p1,e=p2,d=(p1-p2):pq():sk(),h=e.wh and e.wh:ir(e.qj)})end
end
nw=dk:ej([[
lz=e(67),qn=v(0,8),qo=0,
gm=1,py=6,
bd=c(67,v(2,4),v(0,-32)),
kf=b(0,-14,16,0),
kw=e(
e(e=v(0,0),s=v(0,-16)),
e(e=v(0,-16),s=v(16,-16)),
e(e=v(16,-16),s=v(16,0)),
e(e=v(16,0),s=v(0,0))),
wh=b(3,-32,12,-15),
]])lu=dk:ej([[
lz=e(119),qn=v(0,7),qo=0,
qy=15,
bd=c(103,v(1,2),v(0,-15)),
py=2,
jv=v(4,0),gf=v(6,2),
kf=b(1,-7,7,1),iw=b(3,-5,5,-3),
eq=1,eo=" ",ic=79,
sa=3,
ka=v(3,-17),
d=v(0,0),gr=v(0,0),
ie=e(),
]])function lu:nn()if self.ie then
self.z=0
else
self.z+=1.5
end
la(self)local d=self.d
if (#d>0.25)d*=0.1875
self.qj+=d
self.d-=d
if #(self.qj-self.gr)>0 then
hs(self,"gm",self.rm,true)end
self.gr=self.qj
end
function lu:gm(e)
return e.z<=0
end
function lu:rm(o)if kq(o,"gm",self)then
self:ow(v0)hu(46)end
end
function lu:ow(d)
d+=self.qj+v(4,4)
self.d=
(d*0.125):sf()*8+nt[3]-self.qj
end
function lu:lf()hu(49)self:ow(nt[kk.mg]*8)end
da=lu:ej([[
lz=e(4),jv=v(4,-2),py=3,
kf=b(1,-7,7,0),
bd=c(f,f,v(0,-9)),
cv=v(0,0),
pk=e(4,4,4,20,20,20),
]])function da:rm(o)self.cv,li=v0,1
lu.rm(self,o)end
function da:nn(t)lu.nn(self)if #self.cv>0 then
self.qj+=self.cv
self.gj=da.pk[t%6+1]
end
end
function da:lf()hu(45)self.cv=nt[kk.mg]*0.5
end
fj=kt([[
v(0,1),v(1,0),4,4,
v(0,1),v(1,0),8,3,
v(1,0),v(0,1),1,2,
v(1,0),v(0,1),2,1,
]])function nx()for a in all(fj)do
ke(hn,a)end
end
function hn(el,hw,mi,ec)for ik=0,15 do
local l,c,bv,gr=
el*ik-hw*2,-2,0
repeat
repeat
l+=hw
c+=1
gr,bv=
bv,lw(mi,l.x,l.y)until c==16 or bv~=gr
if gr~=0 then
ku(sl*8,l*8,ec)if ec==3 then
hh({mx=sl.x,my=sl.y,mw=(l-sl).x,qj=sl*8+v(0,15)})end
end
sl=l
until c==16
end
end
iq=kt([[
f=v(7,8),t=v(7,7),wi=1,
f=v(0,8),t=v(0,7),
f=v(0,15),t=v(-1,15),h=v(-1,14),
f=v(0,8),t=v(-1,8),h=v(-1,1),wi=1,
]])function ku(ng,to,dr)
if (#(to-ng)<100)return
local d,ps=nt[dr],iq[dr]
local cs,ce=
ng+ps.f,to+ps.t
local ja=
ps.h and o_(cs,to+ps.h)
if (ps.wi)cs,ce=ce,cs
bl({pu={{s=cs,e=ce,d=d,h=ja}
}
})end
hh=bl:ej()function hh:q_(p)ll(self,hf.wd)map(self.mx,self.my,p.x,p.y-15,self.mw,2)end
bo()function _init()di(6)fv(39)hf,fi=nil,kt([[
bq=111,dw=1,a=0,
]])fz()menuitem(1,"toggle music",function()rx=64-rx
qm(ee%64)end)menuitem(2,"delete progress",function()dset(0,0)_init()end)end
function dy(dr)if dr and hf then
hf:kh()fi=rr.fi
kr+=nt[dr]
end
gz,fw,ju,t=
{},{},1,0
kk=ef()hf=k_[kr()]
hf:h_()ia,jr,rr,pg=
oh(),lh(ob([[co=0.07,]])),
iv({fi=nq({},fi)}),
nk(ob("ps=e(),"))
hf:hm(dr)
qm(hf.jx)
end
rn=ob([[
v(16,16),v(0,0),
v(0,16),v(16,0),
]])jk=bh:ej([[rt=255,]])
function jk:oi()
for dr=1,4 do
local ep=self.e[dr]
ex(self,"md",
ep>0 and
rn[dr]+
nt[dr]:pq()*ep
)
end
end
function jk:kh()
local gr,m=self.qy or {},1
self.qy,self.rt={},0
for e in all(fw.qy)do
self.qy[e.na]=
lm%128<e.qy and
(gr[e.na]or {})or
e
if e.qy and e.mz then
self.rt+=e.mz*m
m*=2
end
end
end
function jk:hm(dr)
dr=dr or self.gv
self.gv=dr
local gt=nt[dr]
ia.qj,ia.mg=
(self.md[dr]+gt*0.6+gt:pq())*8,
dr
end
function jk:h_()
po(v0,v(16,16),{220})
local r=em(self.rs)
r:lc(
self.rp,
self.qy,
self.rt~=255 and self.rt
)
for ei,se in pairs(self.md)do
local re=r.md[ei]
if re and se then
fh(re+self.rp,se,nt[ei])
bw({dr=qc[ei]})
end
end
jh(ih)
jh(nb)
nx()
gx()
end
pn=bh:ej()
function pn:lc(p,qy,rt)
local rz,qr,na=
self.rz,1,1
for y=rz.yt,rz.yb-1 do
local d=p+v(0,y-rz.yt)
for x=rz.xl,rz.xr-1 do
local t=mget(x,y)
local s=ha[t]
if s then
local pl={
qj=d*8+(s.qn or v0),
na=na,gj=t
}
for i=1,s.qo do
pl["c"..i]=self.qo[qr]
qr+=1
end
if qy and s.qy then
nq(pl,qy[na])
elseif rt and s.qy and s.mz then
pl.mz=band(rt,1)
rt*=0.5
end
s(pl)
na+=1
t=s.rg or hf.rg
if t==1 then
t=mget(d.x-1,d.y)
end
if t==219 and hi(d.x,d.y-1)==1 then
t=hf.hc
end
end
mset(d.x,d.y,t)
d.x+=1
end
end
end
hj=kt([[
c1="xr",c2="yt",sz="y",d=2,
c1="xl",c2="yb",sz="y",d=1,
c1="xr",c2="yb",sz="x",d=4,
c1="xl",c2="yt",sz="x",d=3,
]])function em(p)local nu=v(ff(p,nt[2]),ff(p,nt[4]))local rb,qo,e=
o_(p,p+nu),{},{}
for i=0,30 do
add(qo,mget(p.x+nu.x+i/nu.y,p.y+i%nu.y
))end
for d,a in pairs(hj)do
e[d]=pz(p,rb[a.c1],rb[a.c2],nt[a.d],nu[a.sz]
)end
return pn({rz=rb,md=e,qo=qo
})end
function ff(p,d)local m=1
while mget(p.x,p.y)~=48 do
m+=1
p+=d
end
return m
end
function pz(ed,ox,oy,dr,mx)local p,d=
v(ox,oy),dr:pq()local rk=(d-dr)*0.5
for i=1,mx do
local tp=(p+rk):sf()if fget(mget(tp.x,tp.y))==0 then
return p-ed
end
p+=d
end
end
function fh(pr,ps,d)local fa=(pr-ps)^d
if (fa<=0)return
local ri=flr(fa*0.7)+1
local kc,du=
fa-ri+2,d:pq()*2
local of,ph=
pr-d*ri-du,ps+d*kc+du
po(pr,of)po(ps,ph)po(of,ph)end
function po(p1,p2,ji)local bt=o_(p1,p2)ji=ji or hf.en
for x=bt.xl,bt.xr-1 do
for y=bt.yt,bt.yb-1 do
mset(x,y,ji[x%#ji+1])end
end
end
ih,nb=kt([[
4,0,1,249,1,0,249,254,
4,0,1,249,-1,0,249,253,
4,0,1,4,0,2,249,1,1,249,238,
4,0,1,4,0,2,249,-1,1,249,237,
4,0,1,249,251,
4,0,2,249,235,
]]),kt([[
4,1,0,4,0,1,4,1,1,2,196,
4,-1,0,4,0,1,4,-1,1,2,198,
4,1,0,249,0,1,4,1,1,4,228,
4,-1,0,249,0,1,4,-1,1,4,230,
4,0,1,2,1,0,251,249,
4,0,1,2,-1,0,251,248,
251,0,1,4,-1,1,251,232,
251,0,1,4,1,1,251,233,
4,0,1,2,197,
4,1,0,251,212,
4,-1,0,251,214,
251,0,1,4,229,
]])qb=ob([[
r192=e(192,208,224,240),
r251=e(251,251,251),
r235=e(235,235,236),
r209=e(209,209,209,227,244),
r48=e(220),r49=e(220),
r21=e(127),
]])function lw(mi,x,y)
return band(mi,fget(mget(mid(x,0,15),mid(y,0,15))))end
function hi(x,y)
return shl(1,lw(0x70,x,y)/16)end
function jh(ny)for x=0,15 do
for y=0,15 do
for p in all(ny)do
for n=1,#p,3 do
if band(hi(x+(p[n-2]or 0),y+(p[n-1]or 0)),p[n])==0 then
goto sj
end
end
mset(x,y,p[#p])break
::sj::
end
if ny==nb then
local r=qb["r"..mget(x,y)]
if r then
mset(x,y,r[flr(rnd(#r)+1)])end
end
end
end
end
function fm(mc)local rw=br(0x5e00,127,mc)dg,og=
rw(16,dg),rw(16,og)
if (dg<=1)return
local bz=rw(4,#fi)for i=1,bz do
local it=fi[i]or {}
fi[i]={bq=rw(8,it.bq),dw=rw(4,it.dw),a=0
}
end
for s in all(gd)do
s.hf.gv,s.hf.rt=
rw(3,s.hf.gv),rw(8,s.hf.rt)end
kr=v(5,4)end
function _update60()if jp then
jp()jp=nil
end
lm=hf.stat
le("io")fl()nj()
t+=1
dg+=0.01667
end
function _draw()cls()bn()li=max(t>60 and li-0.2,0)local fq=ld(t*0.36,li)camera(hd(fq.x),hd(fq.y))clip(jr:gp())ho()qt()le("bi")camera()jr:lt()clip()bn()le("fo")end

__gfx__
00000000000000000000005777a9a994330000333333333301111110011111103333333333333333333080124108033333308012410803333330801241080333
1110001111000000101015d770000004304992033993399312aaa221122aa9213333300000333333333080eef7000333333080eef7000333333080eef7000333
221100252110000051212497a2222224049ff920310011131a92200220022991333301244203333333330200000f003333330200000f003333330200000f0033
333110333311000033333bf79000000409f9f4203124a2a31a220a944aa0229133330124440333333333305670d010333333305670d010333333305670d01033
4221102d44221000d14149a7a0000004049f44203aa99aa31a20a2244229029133001112222003333333300000a790333333300000a790333333300000a79033
551110555511000055555d67900000040244221031110013120a24000042902133300000000033333333301240a790333333301240a790333333301240a79033
66d5106666dd5100666667779000000430222103312a24a3120920000002902133330014410003333333300000dd10333333300040dd10333333301200dd1033
776d1077776dd5507f79777744444444330000333a939a330944444044044490333020eeff080333333333333000003333333333000000333333300030000033
882210188882210088888ee7200000023300003311115110120a244004429021330000e00f000333333080124700003333308012470000333330801247000033
9422104c9994210062949a77222222223049920310011115120a22404422a021330e0000000f03333330882eff0d10333330882eff0d10333330282eff0d1033
a9421047aa99421074a9a77700000000049f9420115110111a209224422a02913300005677000333333002000007903333300200000790333330020000079033
bb3310bbbbb331001929bf770000000009fff220111100511a22099119a022913333300000033333330820567607903333021056760790333302805676079033
ccd510ccccdd5110ccccc7770000000004f9442011111511199220022002299133330111244033333330000000dd103333300000240d103333300120000d1033
d55110dddd511000ddddd67700000000024442100111111012999221122999213333000330003333333330124000003333330120000000333333000024000033
ee82101eee882210eeeeef7700000000302221035111111100000000000000003333333333333333333330000033333333330000333333333333333000033333
f94210f7fff9421079f9f77700000000330000331110011101222101101222103333333333333333333333333333333333333333333333333333333333333333
0aaaaa0333333333333333333333333330aaaa302222222144444444444444423333333333333333333020124100d033333020124100d033333020124100d033
0990990aa90aa90a0a00aaa0aa90a000a09909902aa44aa14a9a9aaa999424223333333333333333333022000080a033333022000080a033333022000020a033
099088090909090909000910909099499088099029411491a44222a9942211123000003330000033333302228280a033333302828210a033333302288280a033
098088080808080880010810808080908088880022414421a49111aa92111422006dd000006dd000333301288205d033333301282005d033333330228205d033
088088088808080808010810808080008088088021200211991100a79200129266555dd16d555dd1333330000000003333333000000000333333300000000033
08808808080808080800081080808000808808802a1221a1a99200a79200299265555551d5111551333330224033333333333012403333333333302220333333
088882020202020202000210221020002088882029a11a91a77aa97a924aa9426ddddd51d1111151333330000033333333333000203333333333302000333333
022220333333333333333333333333333322223011111111999aa97a924922226ddddd51d1111151333333333333333333333330003333333333300033333333
000000000000000000001110111100000011110000000000aaaaa999424499226ddddd51d1111151333333333333333333003333333333333333333333333333
000000000aaaaa0000100000000001000000000001021010a999114441114222dddddd51dd111d51333333333333333330000333337a43333333333333333333
0077aa000a999900000010010100000000101000000000009a911000000119426ddddd5165ddd55133053333337a23330011d333370090333333330003333333
0077aa000a9000000000000000000000000000000000000049912a7aa24214421155511111555111335d333333a40333001163333a0890333333301220333333
00aa99000a9000000000000000000000000000003333333344477977a2994422611111d1611111d1333333333320033330d63333349940333330012244003333
00aa99000a9000000000000000000000000000003333333392aa997a92499229657761d1657661d1333333333333333333333333330003333301012444040333
00000000000000000000000000000000000000003333333300444999924442000066d0010066d001333333333333333333333333333333333330102440403333
00000000000000000000000000000000000000003333333330000444420000033000003330000033333333333333333333333333333333333333010004000333
00002100210002229411122a333300000000333301202210300000002444423333944442323f9323323f93231111111aa1111111333333333300033300305033
20022002000020114411242433301dddd55103330122211001111106441242333394224414f9994114f999411aaaa2a0092aa99100000003307a90330d00d003
20220f00fff40200a91242a933305ddd55510333012022101000000d4492943333f949443f9229933f9009931a2222a0092222910a907a0330a2903330d0d0d0
000040000f00401099144a993330511111110333012212100551550d4929943333f99994f9200099f90780991a2000299200029100400a030099400300d5d5d0
00f00000f2f420104412424433305dddddd10333012122105dd5dd054944943333f92494992000f9990820f91a2044444444029107a9090309a7940350dddd50
40f00440ff420200a9a12aa93330561dd5d1033301222110dd00000049ff943333f92f9439900f9339900f9312204400040402210a000403000a000315ddd503
220f4220420010f099991a993330565115d1033301200210d033333349f2943333f944942499f9422499f9421aa2400000442aa1099944033309033300d55033
22100fff00000f0244441444333057d55dd1033301211210503333334924943333f9ff943139931331399313a00944000004a009000000033304033330a94033
2200f00040000400a44aa9993330576dddd1033301212210d033333349ff943333f922943333333333300333a00924000204a0093333330f3333333333333333
22100ff4002000049949444933301ddddd50033301222110d03333334924943333f94494333003333307a0331992220022222991333330080000333333000333
2210f00040000002441422243330577dddd103330120021060333333494f943333f9ff9433078033307bc0331220200022220221333300ff07850333307a9033
21100f4000020f01aa9224423330576655d1033301202210603333334944943333f92f943077880330aa99031a20222222220291333304000826033307211403
110f601420000f4099224442333057555dd10333012112106033333349ff943333f9f294077e8880309a42031a20002aa200029133330000056703330a1c7203
000000000000f0004421111433305765ddd1033301222110d03333334924943333f94f940888221030994033192222a009222291333333003000603309774203
40020000004400000000000033301ddddd50033301202210603333334999943333f999943088210333092033199992a009299991333330993333060330422033
200220000000044100000000333057766dd10333012212106033333344444233334444443308103330a994031111111991111111333333043333305033000333
424424240000000020000002330057565dd1003300000000d0333333333333334444242124444142000000000000000110000000003333333333330033000033
99999999055555501444442100065765d5d1d0000100001070333333333333334000002142222024022002200101101221011010790000333300009730422203
9aaaaaa90111111024fff922075657666dd1d15001100110603333333311113340111121421001240000022002022020020220200795660330665970042cc220
4a942aa401517d1024ff492206571ddddd50d15001212210d033333311577010401001214201012401100000000000033000000005f9056006509f5002c76c20
9aa494a901d7d11014f4f9210d5757766dd1d1500122121070000000175760602010112110110024000001103333333333333333060000600600006002c6cc20
4a42aaa40117d510249999220757575565d1d11001222210600000001656d0d040110121421101010442000033333333333333330577665005776650022cc200
499999940111111024ff4f220657575665d1d1500120021060000000160000d0222222214222022402220240333333333333333306dddd6006dddd6030222020
422222240000000014f449210d57576655d1d15001211210003333330000000011111111244441420000012033333333333333330d1111d00d1111d033000002
0000000099999999249999220756576666d1d150300000330000000007776660000000000000000001110000333003339f4229f4f03333330000000033333333
055555509a7777a924f44f22065611111111d11001777100ddddddd11011000101011010110100110110011033000033282ff282800333330555555033333333
01d771104a94a9a414ff49210d566666ddddd150d16661d1d00000d110551101000110000110001000000000300bb00334f22923ff0033330111111033333333
0115d7109aa494a9249999220611111111111150d16661d1d01111d10055110000000000000000000000000000b77b004f2002920040333301d1d71033333333
0117d1104a24a2a424f44f22066656d5ddd55550d1111151d05556510615105033333333333333333333333300b77b004f000042000033330171171033333333
017d15104999999414ff992101111111111111105000005150777751071100d0333333333333333333333333300bb0033410012300333333017d1d1033333333
0111111044444444022222200d551d5515515110555555515555555107766dd033333333333333333333333333000033334f4233990333330111111033333333
00000000000000000000000000000000000000000000000000000000000000003333333333333333333333333330033333322333403333330000000033333333
cdfebd86feddddfdcd20bdbdbdbdb5bdbdbd1f1dcd00cdcdedbdbdbdbdddcdcd1d1dcdcdcdcdcdcd1d771d771dcdf0cdcd56bdbdbdbdbdbd56cdcdd4cd7f7f7f
6f6f7f7f7fcd200000000000cd43bdbdbdbd40bdbdcdcd00cd1d1d1d1e2333bdbd8686cd3000001d1d1ebd52bd1f1d1dcd20ed3030bd303030bdbdbdbd30cd00
cd95fcfcdcfcfcecd51003cdcdcdcdcdcdcdcdcdcd0003cdcdcdcdcdcdcdcd031d1dcdcdcdcdcdcdcdcdcdcdcdcd00cdcd54bdbd22bdbdbd54cdcd10cd6f7d7d
07167d7d6fcd880000000000cd1d1ebdbd401ebdbdcdcd00cd1d1d1d1ebdbdbdbd8686cd6000001d1d1ebdbd52231f1dcd24edbdbdbdbdbdbdbdbdbdbdbdcd00
cdecdcecdcecdceccd5500000013cdcdcd661dcdcd0301000013cd25cdcdcdcdcd03109920661dcdcdcdcdcd030187cd1d5483bdbdbdbd83541dcdd46f6fbd16
e61d07bd6f6f880000000000cd1e33bdbd4323bdbdcdcd0003cdcdcdcdcdcdcdcd1f1ecdc00000cd1d1ebdbdbdbd2323cd40cdbd30bdbd30bdbdbd30bdbdcd00
cdecdcecdcecdceccd00000000cdd61ebd1f1d1d1d1d100000ecdceccdcdcdecdcec3310331d1ecdcd1f1d1d1d0110cd1d5416bd0716bd07541dcd309c6fbd7d
23337dbd6f9c440000000000031ebdbdbdbdbdbdbdcdcd00000000000000000000000000000000cd401d5757571ebdbdcd24cdbdbdbdbdbdbdbdbdbdbdbdcd00
03cdcdcdcdcdcdcdcd00000000cd2343bd233333771d0100009c7c7ccdcd507c7c9c66cc301d1ebdbd1f771d1d10c3cd1d54076f6f6f6f16551dcd00cd6f6f6f
7c7c6f6f6fcd4400000000000000000000000000000000000000cdcd627226661d266272cd03f0cd1d1d1d1d1d1d1ebdcd70cdbd30bdbd303030bdbdbd30cd00
cdcd1d1dcdcd17cd2503032002cdbd5fbdbdbdbd231f100000cddc7cdcecdc7cdccd5066331d1ebdbd23431f1d1e10cd1d551d7e7e7e7e1d541dcd00cd6f6f6f
7c7c6f6f6fcd22000000000000000000cd1d1dcdcdcdcd03c700cdcd6373271d1d276373cdcd10031d1d1dbdbdbdbdbdcd60cdbdbdbdbdbdbdbdbdbdbdbdcd00
bd1f1e33bdbd1f1d1dcd10f0c3cdbd5fbd57bdbdd61d02000003dc7cdc9cdc7c08cdcc99005787878787871f1d10e1cd1d541d1d1d1d1d1d551dcd00cdcdcdcd
7c7ccdcdcdcd22000000000000000000cd2333bdbdbdbdcde3001d573030571d1d573030571d2013cdc7cdcd03000000000003cdcdcdcdcdcdcdcdcdcdcdcd00
1d1d1d1ebdbdd61d1dcdf030021dbd57bd5fbdbd231f020000cd13cd50cdcdcdcdcdcd03801d1d1ebd1f571d1d0f1003cdcdcdcd1d1dcdcdcdcdcd0003cdcdcd
7c7ccdcdcdcd11000000000000000000cdbd7cbd7cbd7ccdf1001d1ebdbd23233333bd1f771d40cdcdbdcdcdcd1113cdcdcdcdcdcd50cdcdcdcdcd03b0663310
1e8c8c33bdbd1f1d1dcd20010f9cbd1f1d1ebdbdbd1f100000cdcd0d0d0d2fbd30bdbdcd00031d1ebd1f1d1dcd1013cd1d1d1ebd6f6f6f868657cd03201324cd
1d1dcdcd030000131d1dcdcdcdcd0380cdbd7dbd7dbd7dcd8f00235fbdbdbdbd1f56bd23771d80bdbdbdbdbdcd00cd571ebdbdbd8787bdbdbd1f1dcd01202020
338c8cbdbdbd431f1dcd0f0f00cdbd232333bd521f1d330000cdcd9d8d8d9dbdbdbd30fd34000000000000000000cd1d1d1e33bd6f7d6fbdbd1f1dcd20cdc7cd
2333cdcdcd5511cd1d401d1d5757cd40cdbd7cbdbdbd7ccdf800bd43bdbd56e61d54bdbd1f1d08bdbdb5bdbdd5241d1d1d1d1e878787871f1d401d1d10cc9900
bd8c8cbdbdbdbd1f1dcd100100cd52bdbdbdbdbd1f1d100000cdcdbdbdbdbdbdbdbdbdfd00000000000000000000cd1d1d1e86867e6f7ebdbd1f1dcd01cd52bd
bdbd52bdcd0000cd1e6f6f6f6f57cd30cdbd7dbdbdbd7dcd1f00bdbdbdbdbc1d1d55bdbd2323081d1ebdbdbd1f009c1d1d1e33878787872333231f1d66101000
d61d1d8c8c8c1d1d1d1dc3c300cd1d1d1d1d1ebd2333320000edbdbdbd2c2eb5bdbd30cd000000000000000000003c1d1d1ebdbd7d6f7dbdbd1f1dcd10cdbd6f
bdbd6fbdcd1211cd1e6f7d7d6f1fcdf0cdbd7cbd7cbd7ccd3e00cdcdbdbd56401d5452bdcdcd14a51ebdbdbd1fffcd332333bdbd8787bdbdbdbd23cd1099cc00
23331f8c8c8c1d1d1d1d200100cd1d1d1d1d1d1d1ebd000000edbdbdbd2d2fbdbdbdbdcd000000000000000000001d1d1d1e7e6f6f57776fbd1f1d1d10cdbd6f
bdbd6fbd1f0000cd1e6fbdbd6f1fcd00cdbd7dbd7dbd7dcd7c00cdcdbd1f551d1e9dbdbdcdcd002333b5bdbdd500cdbdbdbdbdbdbdbdbdbdbdbdbdcd33011000
bdbd43333333331f1dcdc3f00003cdcdcdcdcd1d1dcd000000cdcdbdbd8d9dbdbdbd30cd00000000000000000000cd1d401e7d6f6f6f6f6fbd1f1d9c30cdbd7d
bdbd7d521f12111d1e7e7e7e7e1fcd00cdbdbdbdbd1fa5cd0000cdcdbd239d401e56bdbdcdcd00bdbdbdbdbdcd23cdbdbdbd1f571d1d571ebdbdbdcd10103300
bdbdbdbdbd1f1d1d1dcd100200000000000000000000000000cdcdbdbdbdbdbdbdbdbdcd00000000000000000000cd1d1e1ebd6f6f6f6f6fbd1f1dcd01cdbdbd
52bdbdbdcd00009c1d401d401d1dcd00cdbdbdbdbd1d1dcd0000cdcdbdbdbd23339dbdbdcdcd00cdcdcdcdcdcd00cdbdbdbd231f1d1d1e33bdbdbdcdcc991000
03cdcdcdcd3f1dcdcdcd0ff00000000000000000000000000003cdcdcdcd3ffccdcdcdcd0000000000000000000003cd1d1dcdcdcdcdcdcdcdcdcdcd0003cdbd
bdbdbdcdcd1400031d1d1d1d1d1dcd0003cdcdcdcdcdcdcd000003cdcdcdbd1f1ebdcdcdcdcd0003cdcdcdcdcdff03cdcdbdbd231f1e33bdbdcdcdcd20206600
00004100000000003300410000001240000000000000000000000000144444410333333309a9944030000003001110000220212099999f9f99494499fff0000f
2009210400044410300221040001129000000000000000000000000042112112503333330494444000a9aa0000000000011011104249f9fff999944244fffff4
2042210200142210001221020000122000000000000000000000000042002002603333330a9444200a2222900100001000000000444499f9f9994944494fff44
00221001001211100012100100011200000000000000000000000000422222226033333309aaa9400a21129000111000000000009499499f9ff9949494f9ff9f
00210000001100000011000001112000000000000101011000000000411211227033333304aa94200920024000000000111111119999999999fff9f99ff99f49
410004410100041101000441000114a00000001111111111110000004002002270333333014942100a2102900000000094449444f99494424249f9fff9999999
221042220110421101104222000112a00000011224442444211000001222222170333333000000000a200290000000009ff94949f9f9494444449999f99ff9f9
221001210110011101100121000012900000012400000000421000000000000033333333200000020a2102900000000099ff949999ff94949494499999999999
220000000100001101000000092100000000124000000000092100000111011000001011101100000920024033333333000000001999922199fff92112999999
2210094410dd5501011009440a21100000011290000000000a2110000000000001000000000001100a2102903333333300000000022220004249942112449442
221042220d511110011042220921000000001290000000000a2100000000000000001000000100000a2102903333333300000000000000009444442112424944
2110222105111010011022210041100000011290000000000a2110000000000000000111111000000a2002903333333300000000111000019494421001249494
11000110501101050100011000021110000012400000000009210000000000000000000000000000092102403333333300000000000011009944421001249f9f
00044000110110d1000240000a91100000011290000000000a2110000000000000000000000000000a21029033333333000000000000000099994410012499ff
4042220411100d11001222040921100000011290000000000a2110000000000000000000000000000a200290333333330000000000000000f9994421124299ff
2002210210100511000221020921000000001290000000000a2100000000000000000000000000000a2102903333333300000000000000009ff994211249499f
210002220100000000002103010000010000012900000000a2100000d5105d1030000000000000030a2102904244242442442424042424244244421033333333
2109401110d51000200921001051000100000112aaa9aaa9211000005110111000aa9aaaaaa9aa000a2102904414444444144444044144444414444033333333
210421000d511100204221000d110000000000112222222211000000100010000a222222222222900a20029099499999a94aaa9904949999a94aa94033333333
1011100005111110002210000111000000000000111111110000000005100d100a211111111112900921024099499999944aa999029499999449942033333333
00000420501101000021000050100001000000000110101000000000d110511009210010010012400a2102904414144444141444044114444414414033333333
00042210110110004100021011000010000000000000000000000000111011100a211000000112900a200290a9a94aa9aaa94aa9049a4aa9aaa9944033333333
40011100111001102210211011100101000000000000000000000000000000000a210000000012900422224099994999aa99499902994999aa99442033000033
21000004101051002210011010100511000000000000000000000000000000000a21100000011290004444004444144444441444094414444444414000ffff00
000041000000001122000000000000000100001105000100d5105d10000000000a2110000001129004244210aa99aaaa9944aaa909a9aaaaaa4a944030eee033
21092104000d550122100210a9400a9910000501510d501051101110110011000a21000000001290044144409994aa999442aa990494aa99a94944400e888803
1100110200d111102210211022120a220000d1105051110011101110111011100a211000000112900494a94049444449442244490a94944944144420e8787820
004200010d111010211021101121a2110000d110005110000000000000000000092100000000124002949420aaaaa9aaaaaaa9aa09aaa9aaaaaaa940e8878820
002104200111010511000110010111001015110500010101d1101d101d10d1100a2100000000129004414140aaa999aaaaa999aa04aa99aaaaaa9420e8787820
41000210000010d10004200000001000100110d10d01105151105110511051100a21111111111290049a94409999999999999999014999999999421008888200
2210000000d50d11404222000000100010000d110d10051111101110111011100044244444424400029944200000000000000000000000000000000030222003
22100441001105112002110000001000100005110111011000000000000000000100000000000010094441400000000000000000300000000000000333000033
__label__
000000000000000000000000000000000000000000000000000000000f0000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000110000000000000000000000000000000000000000000
00000000000000000000000000000f000000000000000000000000000000000000000000000000001010000000000000000000000000f0000000000000000000
0000000f00000ff00000000000000000000000000000000000000000000000000000000000000110000000000100000000000000000000000000000000000000
00000000000000000000000000000000000000000f00000000000000000000000000000000001000000010000100000000000000000f00000000000000000000
00000000000000000000000000000000000000000000000000000000111111111111110000010001000100010000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000001000100000000000000100000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000012000100000001000000100000000000000000000000000000000000000
00000000000000000000000000000000000000000000000f00000000000000000000011000100000001001000100000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000012010000110100001000100000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000012011001111110000000210000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000012011000010110001100210000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000012000001000000010000100000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000012010021001100210010210000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000001112011001101100000010210000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000112000210001001100000210000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000010101100000112000110210001001100210000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000011111111111111112021000110210001000210000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000111122212222221220011100000110000000210000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000011200000000000000101110f221111002210210000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000001120212212122122211011000000000021000211000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000011120221222222212222011100222110211020410000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000001120222222224224422011102111110011010411000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000011120222222222222221011101111002100010411100000000000000000000000000000000000
00000000000000000000000000000000000000000000000000001220221212222212212011000110001102100211000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000011240949429949994422000022000210002100411100000000000000000000000000000000000
00000000000000000000000000000000000000000000000000011240444424449944222020222202221000000411100000000f0000000000000000000f000000
00000000000000000000000000000000000000000000000000001240222212222222212020022102221002210411000000000000000000000000000000000000
0000000000000000000000000000000000000f000000000000001220994499999929422000002100000021000211000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000011240444299449424222021042102210421020921100000000000000000000000000000000000
00000000000000000000000000000000000000000000000000001240242222242212222011001102110011020921000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000011240999994999999942000220001002200010921100000000000000000000000000000000000
00000000000000000000000000000000000000000000000000001220999444999999422000210220002102200421000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000011240499999999999421041000210210002100921100000000000000000000000000000000000
00000000000000000000000000000000000000000000000000011240000000000000000022100000221000000921100000000000000000000f00000000000000
00000000000000000000000000000000000000000000000000001240000000000000f00022100221221002210921000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000f001240244441422444414201000000210002220421000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000011290422220244222202401100944210420110921100000000000000000000000000000000000
00000000000000000000000000000000000000000000000000001290421001244210012401104222210221000921000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000011290420101244201012401102221101110000921100000000000000000000000000000000000
00000000000000000000000000000000000000000000000000001240101100241011002401000110000004200421000000000000010100000000000000000000
00000000000000000000000000000000000000000000000000011290421101014211010100024000000422100921100000000011111100000000000000000000
00000000000000000000000000000000000000000000000000011290422202244222022400122204400111000a21100000000111120000000000000000000000
00000000000000000000000000000000000000000000000000001290244441422444414200022102210000040921000000000112000000000000000000000000
00000000000000000000000000000000000000000000000000001240000000000000000000001011101100000921000000001220000000000000000000000000
00000000000000000000000000000000000000000000000000011290110100111101001101000000000001100a21100000011240000000000000000000000000
00000000000000000000000000000000000000000000000000001290011000100110001000001000000100000a21000000001240000000000000000000000000
00000000000000000000000000000000000000000000000000011290000000000000000000000111111000000a21100000011240000000000000000000000000
00000000000000000000000000000000000000000000000000001240000000000000000000000000000000000921000000001220000000000000000000000000
00000000000000000000000000000000000000000000000000011290000000000000000000000000000000000a21100000011240000000000000000000000000
00000000000000000000000000000000000000000000000000011290000000000000000000000000000000000a21100000011240000000000000000000000000
00000000000000000000000000000000000000000000000000001290000000000122000000000000000000000a21000000001240000000000000000000000000
00000000000000000000000000000000000000000000000000001240000000001224400000000000244441420921000000001220000000000000000000000000
00000000000000000000000000000000000000000000000000011290000000101244404000000000422220240a21100000011240000000000000000000000000
00000000000000000000000000000000000000000000000000001290000000010244040000000000421001240a21000000001240000000000000000000000000
00000000000000000000000000000000000000000000000000011290000000001000400000000000420101240a21100000011240000000000000000000000000
00000000000000000000000000000000000000000000000000001240000000020124100d00000000101100240921000000001220000000000000000000000000
00000000000000000000000000000000000000000000000000011290000000022000080a00000000421101010a21100000011240000000000000000000000000
00000000000000000000000000000000000000000000000000011290000000002228280a00000000422202240a21100000011240000000000000000000000000
00000000000000000000000000000000000000000000000000001290000000001288205d00000000244441420a21000000001240000000000000000000000000
00000000000000000000000000000000000000000000000000011290000000000000000000000000244441420a21100000011240000000000000000000000000
00000000000000000000000000000000000000000000000000001290000000000224001200000000422220240a21000000001240000000000000000000000000
00000000000000000000000000000000000000000000000000011290000000000000000100000000421001240a21100000011240000000000000000000000000
00000000000000000000000000000000000000000000000000001240000000001000000100000000420101240921000000001220000000000000000000000000
00000000000000000101011001010110010101100101011000001290000000001000000400000000101100240a21000000001240000000000000000000000000
00000000000000011111111111111111111111111111111111111290000000000000002400000000421101010a2111111111124000f000000000000000000000
00000011011111111112122212222222222224442444244444424400000000004211010100000000422202240044244422222200000000000000000000000000
00000000000000000000000000000000000000000000000000000010000000004222022400000000244441420100000000000010000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000002444414200000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000110100110000000000000000000000000000000000000000
00000000000000000001110000000000000000000000000010011000000000001101001100000000011000100000000010011000000000000000000000000000
0000000000000000000110000000000000000000000000000000000000000000011000100000000000000000000000000000000000000000000f000000000f00
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000100110101001101010011010100110111000000000000000000f0000000000000000000001011011100000000000000000000000000000
00000000000000000100000000000000000000000000000011000000000000000000000000000000000000000000000011000000000000000000000000000000
00f000000000000000000000f000000000000000000000000000f000000f00000f00000000000000000000000000000000000000000000000000000000000000
00000000000000f001001111110011111100111111001111110100002444414200000000000000000000000000101111110100000000000000f000000f000000
0000000000000000000011000000110000001100000011001000000042222024f00000f000f00000000000000000110010000f0000f000000000000000000000
000000000000000000000000000000000000000000000000000000004210012400000f0000000000000000000100000000000000000000000000000000000000
00000000000000000000101111111011111110111111101111111000420101240000000000000000000000000016600011111000000000000000000000f00000
0f0000000000000000100011111000111110001111100011111100001f11002400000f0000000000000000000616d05011110000000000000000000000f00000
00000000000000000000000000000000000000000000000000000000421101010000000000000000000000000d1d50500000000000f000000000000000000000
00000000000000000000000000000000000000000000000000000000422202240000000000000000000000000d00005000000000000000000000000000000000
00000000000000000000000000f0f0f0000000000000000000000000244441420000000000000000000000000000000000000000000000000000000000000000
f0000000000000000000000000000000000000000000000000000000000021f00000000024444142000041000000000000000000000000000000000000000000
00000f00000000000000000000000000000000000000000000000004200921000f00000042222024000221020000000000000000000000000000000000000000
00000000000000000000000000000000000000000000f00000000102204221000000000042100124001221020000000000000000000000000000000000000000
0000000000000000000f0000000f000000000000f000000000000001002210000000000042010124001210010016000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000042000210000000ff00010110024001100000616500000000000000000000000000000000000
000000000000000f00000000000000000000000000000000000002104100021000000000421101010100022105155050000000000000000000000000000f0000
0000000000000000000000000000000000000000000000000f000000221021100000000042220224011022200500005000000000000000000000000000000000
000000000000000f000f000f0000000000000000000000000010024122100110000f000024444142011001000000000000000000000000000000000000000000
000000000f00000000000000000000000000000000000000000000002200000f2200000022000f00220000000000000000000000000000000000000000000000
00000000000000000000000000000000f0000000000000f099949900221004222210042222100422221004220099494444420000000000000000000000000000
00000000000000000000000000000000000000000000000022222240221022222210222222102222221022220922211111111000000000000000000000000000
0000000000000000000000000000f0000000000000000001111112402110222121102221211022212110222109211111111111000000000f0000000000000000
000000000000000000000000000000000000000000000010010012201100011011000110110001101100011002110010011010000000f0000000000000000000
0000000000000000000000000000f000000000000000000000011240000220000002200000022000000220000921100000000000000000000000000000000000
00000000000000000000000000000000000000f000000000000012402022220220222202202222f22022220104110000000000000000f0000000000000000000
000000000000000000000000f0000000000000f000000000000112402f0221f22002210220022102200221000911100000000000000000000000000000000000
00000000000000000000000000000000000000000000000000001220000021002100022200000000000000f04110000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000011240210421022104201100994999444244421110000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000f01240110011022102210009222222221111111100000000000000000000000000000000000000
0000000000000000000000000f000000000000000000000000011120002200011011100009211111111111110000000000000000000000000000000000000000
0000000000000000000000f00000000000000000000000000000112000110210000002100211001001101010000000000000f000000000000000000000000000
0000000000000000000f0000000000000000000000000000000111202100011000f2211004111000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000011120111000002001110004110000000000000000000000000000000000000000000f0f000000
00422200000000000000000000000000000000000000000000001120111002211100000204111000000000000000000000000000000000000000000000000000
042cc22f00000000000000000000000000000000000000000000112000002100000021000211000000000000000000000000000000f000000000000000000000
02c76c200000000000000000000f000000000000000000000000112011021102110211020411100f000000000000000000000000000000000000000000000000
02c6cc2000000000f000000000000000000000000000000000001120110011011100110104110000000000000000000000f000f000000000f000000000000000
022cc200000000000000000000000000000000000000000000000120001100010021000002100000000000000000000000000000000000000000000000000000
1022202000000000000000000000000000000000000000000f0f1120001102100011021002110000000000000000000000000000000000000000000000000000
000000020000000000000000000000000000000000000000000001201000011021000110041000000000000000000000000000000000000000000000f0000000
00000000000000000000000000000000000000000000000000000120110000001100000002100000000000000000000000000000000000000f00000000000000
00000000000000000000000000000000000000f00000000000000120110001101100011002100000000000000000000000000000000000000000000000000000

__gff__
0000000000200000202000000000000000000000000000000000000000000000000000000000181800000000000000002020303030001010000000000000202000001800000000000020000000000000000010000000000000000000002000001800180000000020000000000000000000101000000000000000000020200000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a2a0a100000000300000000000000000a200a13030300030a030000000000000a4c4a400c5c6001818191a300000000000000000a1a2001010101000
__map__
30052f4f06e0600088740d8000dc058031dc42dcdcdcdcdcdcdcdc30040031dcdcdcdcdcdcdcdcdcdcdc3031dcdcc0c0dcdcdc300231dcc0c0dcdc30fc31dcdc05dcc0c0dcdcdcdc300331dcdcdcdcdc49dcdcdcdcdcdc300c31dcdcdcdcdcdcdcdcdcdcdcdcdcdc300f0031dc2627dc71dcc0c0dc60dc2627dc3000e5f3e5e5
5086143280bb0000c21560057c171e30dcdcdc49dcdcdcdc05dcdcdc0400dc696969db6969dbdbdbdbdbdcdc6969d2c0dcdcdcdc00dcc0c0c0c0c0dcf9dcdcd8d9d9d8d9d8d9d9dcdc01dcdce2dbdbc2e2dbd2c0c0c0c0dc04dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc0700dcdc3637dcc0c0c0c0c0c0dc3637dcdc31dc3010d4
68436205400300e87a80c8dd5d000019dc65686865c0c077c0c0c0dc0800dc696969db6969dbdb6969dbd2dcdbdbd8d9dcdcdcdc00dcc0c7c7c7c0dcf3dcdcdbdb5bdbdbdbdbdbdcdc13dcdcf2dbdbd8d9dbd8d8c2c0c0dc08dcdcc04041c0f2dbdbdcdcdcdcdcdcdc8300dcc0c0c065c0c0c0c0c0c065c0c0c0dcdc5adc10d4
04103a3808002a03494370700100754adc55686845c0c07777c0c0c00800dc6969dbdb6969dbdb6969dbd2dcdbdbdb69dcdcdc0500dcc0c75ac7c0dc7edcdcdbdbdbdbdbdbdbdbdcdc01c0c0f2dbdbdbdbdbdbdbd8d9c2dc42c0c35051c0c0c7dbdbc2c7c7c7c0c0c0c100dcccccd255c0c07e70c0c055f2ccccdcdc68dc20d4
4006ac2010a0b0065401402600cc6501dc45c0c055c0c077c0c0c0c90800dcdbdbdbdb6969dbdb6969dbdcdcdb69db69dcdcc0c000dcc0c7c7c7c0dce7dcdcdbdbc2dcdce2dbdbdcdc43c0c9f2dbdbdbdbdbdbdbdbdbd2dc00c0c0c04fc0c0c7dbc2c0c7c7c7c0c0c00f00dccecdc24543c0c0c043c055f2cecddcdc68dc20c3
1834820000390f208400900050c5f366dc5575c045c0c0dcdcdcdcdc0800dc5ae2dbdbdbdbdbdb6969dbdcdcdbdbdbdbdcdcc0c000dcc0c0c0c0c0dc3fe2dbdbdbd2dcdcf2dbdbdbc201dcdce25bdb69dbdb59dbc1dbc2dc00dcdcc0c0c0f2d9dbd8d8d9d8d9d9d8dc0e00dccecdd25570c020c0c06145e2cecddcdc68dc10d4
eeee46408a200ac8dddd04508d9211b9dc55c0c045c0c0dcdcdcdcdc0400dcc0f2dbdb696969db6969dbdcdc6969dbdbdcdcc0c000dcc0c0c0c0c0dc9ff2db5bdbd2dc49e2dbdbdbd201dcdcd9dbdb69dbdbcbdbcbdbc2dc00dcdcc0c0c0d9dbdbdbdbdbdbdbdbdbdc1c00dccecdc24561c0c0c0c07e55f2cecddcdc68dc10d4
bb1b54a8582d43007763003680ac060e30dcdcdcdcc0c0dcdcdcdcdc0b00dcd8d9dbdb696969db6969dbdcc0e26969c277c0c0c00030dcdcdcdcdcdccfdcdcdbdbc2c0c0f2dbdbdcdc00dcdcdbdbdb69dbdbdbdbdbdbd2dc0030dcc0c0dcdcdcdcdcdcdcdcdcdcdcdc3800dccecdd245c0c0c0c0c0c045e2cecddcdc68dc30d6
4004840afb8c14021000586111a13b000000000000000000000000000000dcdbdbdbdbdbdbdbdbdbdbdbdcc0c0c0c0c077c0c0c0000031dc05c7c73001dcdcdbdbd8d9d9d9dbdbdcdc00dcdcdbdbdb69c2c0e2dbc2c0c0dc31dcdc7cdc7cdcdcdcdcdc30001131d16d3001dccecdc25543c0707e43c055f2cecddcdc68dc55d6
01a0ab8c486607200484656b6608ad04000000000000000000000000000030dcdcdcdcdcdcdcdcdcdcdcdcdcc0c0c0c0dcdcdcdc0000dcc04041c0772bdcdcdbdbdbdbdbdbdbdbdcdc00dcdcdbdbdbdbd2c0e2dbd2c0c0dcdc7cdcce5fdedc7cdcdcdcdc1108dc6833dc01dccecdccccccd2c0c0e2cccccccecddccecfdc00d6
00b2f6c108288082009aa59a8283130031dc62262762dcf6f6dc62262762dc300031c0c0dcdcdcdc4a300230c0c0dcdcdcdcdcdc0000dcc05051c0772bdcdc75c0c0c0c0c0c0c0dcdc00dcdcdbdbdbdbd2c0e2dbd2c0c0dcefdddfcededddfcddc4949dc0010dcdb68dc01dccecdcecdcec2c0c0f2cdcecdcecddcce80dc00d3
38b370660700020048c3a6e4e0ae0020dcdc72363772dc6170dc72363772dcdc5fdc6649dcdcdcc0c0dc01dcdcdcdcd1d1dcdcdc3001dcc0c0c0c0dc00dcdcc0c0c0c0c0c0c0c0dcdc0030dcdcf3e0dcdcdcdcdcdcdcdcdcdeefdfdedddbdfcdcecdcecd4418dc68dbdc01dccecdcecdcecccccccccdcecdcecddc30dcdc00d6
a7ee50803108001ca92a2940280100a2dcdcf73c1515151515151515f1f7dcdc00dcc0c0dcdcdcc0c0dc8162dc6265d1d16562dc620230dcdcdcdcdc0030dcdcdcdcc0c0dcdcdcdcdc0031dcdcdcdcf1e1dcdcdcdc301330cdcecddedbdbdddfcecdcec90000dcdb68dc01dccecdcecdcecdcecdcecdcecdcecddc00000000d6
da25740760386254bb84ee000c4b6814dcf7e7e11515151515151515f1e7f7dc5fdcc0c0dc71dc6868dc0272dc7232f1e13372dc720131dcdcdcdcdccdcedcdcdcdc3031dcf65adc30ffdcdbdbdb65d1d165dbdbdbdc13c0dccecddedbdbdbdfcecdcedc4400dc68dbdc0130dccdcecdcecdcecdcecdcecdcedcdc0000000000
58cc0100810010a08c39b0252180294bf6f6d170151515151515151570d1f6f600dcc0c0c0e268c2c0dc02dbdbdbdb3233dbdbdbdbffdcdcdcdcdb03dddfdedddbdcdcdcdcc7c7dcdcffdcdbdbdb34030333dbdbdbdc072330dcdcdcdcdcdcdcdcdcdcdc0000dcd1d1dc31dcdbdbdbdbdcdc30010031dcdcdcdcdcdcdcdc3001
330004240041ee33eaee800040a82186e7e7d161151515151515151561d1e7e700dcc0c0c0e268c2c0dc02e1dbdbdbf5db65dbdbf102dcf1e133db03dbdddddb03dcdcdcdcf6f6dcdc10dcdbdbdbdbdbdbdbdbdbdbdc830131dcdcdcdcdc05dcdcdcdc30092045d1d155d1e1dbdbdbdbdfcddc1100dcdcdccdcededbdbdfcd23
c05d1200489db718c039028019ec0605dcd1d1e11515151515151515f1d1d1dc00dcc0c0c0f268d2c0dc02e143db6534f55543dbf1ffdc32f5dbdb03dbdbdbdbdbdcdcdcdbd7d7f6f632dcdbdbdbdb6868dbdbdbdbdc835fdcdcdcdcdcd15fdcdcdcdcdc080045d1d155e134dbdbdbdbdddfcd0200dcdcdc6969dddb6969df00
97400030f5e9e20c080840c78ea80c20dcd1d1e11515151515151515f1d1d1dc0030dcdcc0c0dcdcdcdc02f1d1d145d1e145e133f100dcef34dbdbdbdbdbdbdb03dcdcdcdbdbdbf6f610e1db68db6868dbdbdb68dbf14302dcdcdcdc493233dc49dcdcdc100030dcdcdce1dbdbdbdbdbdbdddf3200dedbdb6969dbdbdb69df00
2c0140540fa539802300c2c99c529707dcdcd1d1e1151515151515f1d1d1dcdc31dcdc6266c062dc30100032323255f5333233db3200cededbf1e103dbdbdbdbdbdcdcdcdbdbdbd7dcffe1db68dbdb6868db6868dbf1075fdcdbdbdbdbdbdbdbdbdbdbdc1831dcdc3001e1dbdbdbdbdbdbefdf0000dedbdb6969dbdbdb69df00
020049724e060e440040ac24ce19c012dcdcd1d1d1d1e17061f1d1d1d1d1dcdcdcdcdc72c0c072dcdc1000dcdcdb3234dbdbdbdcdc00dedddbf1e1dbdbdbdbdb03d3dfdcdbdbdbdbdc10dcdbdbdbdbdb68dbdbdbdbdc0323dcdbdbdbdbdbdbdbdbdbdbdc8065d1d16501e1dbdbdbdb16efdfce0000dcdcdcdbdbdbdbdbdbdd00
000c31b3990328020019171a7356400230dcdcdcdcdcdcd1d1dcdcdcdcdcdcdcdcdc75c0c0c0c0c0dc000030dcdbdbf1e1dbdbdcdc00dcdbf1e133dbdbdbdbdbdbdbdfdcdb5bdbdbdc00dcdbdb6d6d6d683838dbdbdc0300dcdbdbdbdbdbdbdbdbdbdbdc4045d15e5501e1dbdbdbdbdbdfcdce0000dcdcdcdbdbdbdbdbdb6900
70a376a60e14040062ce66090200031000000000000031dcdcdccdce300600c3dcdcc0f2d9d8d2c0dc4431dcdcdcdcdcdccecd308022dcdb3233dbdbdbdbdbdbdbdcdcdcdbdbdbdbdc00dcdbf1d1d1e168f1d1e1dbdc0b00dcdbdbdbdbdbdbdbdbdbdbdc8055d1d15501e116dbdbdbdbdddddd0000dcdcdcdbdbdbdbdbdb6900
14b49c0200640028d192220077030000000000000000dcdc05dc78dfdc003c007cdcd8d9dbdbd8d9dc01dc6d7575dc7cdcdfcd6d080030dcdccfcfdcdcdcdcdcdcdcdcdcefdbdbefdc00dcdb32f1d1d1d1d1e133dbdc4300d1d1e1dbdbdbdbdbdbf1d1d1323268683301e1dbdbdbdbdbdbdbdb0000dcdcdcdbdb16dbdbdbdb00
00000000000000000000000000000000000000000000de7878db78dddc0f003cc0e2dbdbdbdbdbdbdc32dccecddedbdbdbdfcdce0731dc627c622627627c62dc300424dccecfcfcd5d00dcdbdb32f1d1d1e133dbdbdc2300c975e1dbdbdbdbdbdbf175d120dbdbdbdb01e1dbdbdbdbdbdbdbdb000030dcdcdcdccfcfdcdcdc00
00000000000000000000dc59e1dbdbdbf1d15adc3010dedb78db7878dc00f000c0c077e2dbdbc2c0dc00cddedddddbdbdbdddddf80dcdc72db72363772db72dcdcff08dcce7577cddc0030dcdcdcdcd1d1dcdcdcdcdc0c00dcd1e15bdb5bdb5bdbf1d1dc32d17775d10130dcdcdcdcdcdccfcfdcdcdcdcdc7cdc7cdcdc300008
317171dc71717c7c3001dc3233dbdbdbc9d1d1dcdc08dcdb78dbdbdbdc0f0000dcdcc0e216dbd2c0dc00c9dedbef5bdbdbefefdfffdcdbdbdb65f7f765dbdbdbdc0818dccecdcecddc00000031dcdcdcdcdcd1d1dcdc3008dcd1d1d1d175d1d1d1d1d1dc40d1d1d1d100000000000000000000dc5ae1dbdbdbdbdbdbdbf11112
cdcecdcecdcecdcedc55dcdbdb5bdbdbdcdcdcdcdc22dcdbdbdbdbdbdc00f000dcdcc0c0c0c0c0c0dc00dccecfdedbdbdbdf77ce807ee1db7055f64d557edbf161ff0830dccdcedcdc000000dc75d1d1d1d1d1d175dcdc0730d1d1d1d1d1d1d1d1d1d1dc3230d1d1dc00000000000000000000dcd1e1dbdbdbdbdb16dbf10000
cdcecdcecdcecdcedc01dcdbdbdbdbdbdcdcdcdcdc0830dcdcdcdcdcdcc3000030dcc0c0c0c0c0c0dc00dccecddedbdbdbdf77ce0f7033db6145e7f65570db327e0428000000000000000000dc3332f1d1e1323333dcdc0cdcdcdbdbdbdbdbdbdbdbdb3010100031dcdcdcdcdc66d1dc30100430dcdcdcdcdcdcdcdcdcdc2200
dcdcdc77dcdcdddfdcaadcdbdbdbdbdbdcdcdcdcdc1231dccededb69dbdf30000000000000000000000030cecddedbdbdbdfcdce80dcdbdbd755f6e745d7dbdbdc1400000000000000000000dce1db32f1d1e1dbdbdc050fdcd1d1d177d1d1e1dbf1d175011000dcdcdc05dcdcd1d1dcdc0adcdc05dcdc7cdcdcdcdccdce3007
dcdcdc68dcdccfcedc02dcdbdb5bdbdbdcdcdcdcdc18dccd4ededbdbdbdfdc31dcdcdc757575dcdcd1d177d177300200000000000030a0dbdb45a0a055dbdba0dc0400000000000000000000dcd1e1dbf1d1d1e1dbd1d100d1d1d1d1d1e168686868f1d1021000dcdcdbdbdbdb3234dcdc01dc0303db03dbdbdbdbdbdddddc00
dcdcdc68dcdcdedddc0233dbdbdbdbdb33326dd1d108dccdcede030303dfcddcd1d1d1d1d1d1d1d1d177d177d1d10431dcdcdcdbdbdbdbdcdcdc3003dc262762d1d162262730031100000000dcd1e1db34323233dbc9d143d1d1d1d1d1d1e1dbdbf1d1d1041000dcdcdb25dbdbdbdbdcdc42dcdbdbdbdbdb03dbdbdb03dbdc11
dcdbdb68dbdfdeefdc02dbdbdbdbdbdbdbdbf1d1d122dccededddbdbdbdfcddcd1d1c9d1d1d1d1d1d177d17777d109dcdcdcdcdbdbdbdbdcdcdcdc02dc363772f6f6723637dc010000000000dce1335bdbdbdbdbdbdcdc00dcd104d1757575dbdbf1d1d1081000dcdce1dbdbdbdbf175dc10dcdbdbdbdbdbdbdbdbdbdbdbdc00
__sfx__
010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010e00201e5201e5001e5201e5001e5001e5001f5221f5221f5221f5221f5221f5221f5221f5221f5221f5221e530005001e5300050000500005002152221522215222152221522215201f530005001c52600500
010e00201611012000161100c1000c1000c10017112171121711217112171121711217112171121711217112161100c100161100c1000010000100191121911219112191121911219110171101f1001311600100
010e0021120200c000120430c0000c0000c00013020130201302013020130201302013020130201302013020120300c000120330c0000c0000c000150201502015020150201502015020130300c0001002600000
000e00003665530605366553060530605306053765537605376053060530605306053060530605306053060536655306053665530605306053060539655306053060530605306053060537655306053465530605
000e00201e0301e0301e0201e03119000190001e0221e0221e0221e0321e0321e0321e0321e03200002000000000000000000001c0001c020000001e0301c0001f04000000230522305223052230522204022040
010e000022020220202202222015194050d1052202022020220202202222012220122201222012220151b7051c7051f7051e7021e7051f0201f01521020210152302023015260202602026022260222502025015
010e00001201012010120101201006000061051201012010061050c000120101201012010120100d1050610510010100101001010010041050c0001001010010041050b105100101001010010100100b10504105
010e00202a610257052a705257052a613257051e625257052a705257052a613246032e7052a70525705246032a6102850428505285042a6131c5051e6251c5052a603347052a6133470528704287052870428705
010e000022020220202201222015194050d1052202022020220202202222012220122201222012197151b7151c7151f7151e7121e7151f0201f01521020210152302023015260202602026022260222502025015
010e000022020220202201222012200202001522020220222202222022220222201222012220122201222015000000000000000000001f0201f01521020210151e0201e0151f0201f0221f0221f015000000c003
010e0000220202202022022220122201500000195051b7051c5051f7051e7001e7001e7001e7021e7021e705225051e505197050000025705000002550525505220212202222012220121e0201e0201e0121e012
010e0000220202201022012220122201500000195251b7251c5251f7251e7201e7201e7201e7221e7221e725225251e525197250000025725000002552525525220202201222712227121e0221e0121e7121e712
011000001f7001f7001f7001f7001f7211f7201f7201f722237212372023722237221f7211f7201f7201f71221721217202172021720217202172221722217222172221722217202171021710217122171221712
001000001c034230341c034230341c024230241c024230241c024230241c024230241c024230241c024230241d034240341d034240341d024240241d024240241d024240241d024240241d024240241d02424024
001000001002110020100201002010010100101001010010100101001010010100101001010010100101001011021110201102011020110101101011010110101101011010110101101011010110101101011010
011000001c524235241c524235241c514235141c514235141c514235141c514235141c514235141c514235141d524245241d524245241d514245141d514245141d514245141d514245141d514245141d51424514
01100000000000000000000000001f0211f0201f0201f022230212302023020230121f0211f0201f0221f0122d0212d0202d0102d012280212802028012280122602126020260122601224021240202401024012
010c00002e0202e0202e0222e0222c010240002e0202e0202e0222e0222e0002e0002f0222400031013240002e0302f0202e0122e0001e5152a515365151e5152a515365151e5152a5152a0302a0202c0302c020
010c000006120061200612006120041102271306120061200612006120257152571506120257151302325715061200611006120167132e7142e71504120041200611006110257052570525705257050212002120
010c00000c043000052a0102a6152a615000050c0430000536505365150c043000052a6153d5050c0030c0232a615365152a6152a6152a6151e6052a6253d5150c043365153d505000052a6251e0052a6150c023
010c00002e0222e0222e0222e0222c022240002e0222e0222e0222e02224000240002f0220000025013000002a0202b0122a0212a0102a0102a0122a0122a012240002400024000240002a0122b0122c0222d032
011000001b0001e000220001b0201e010220101c0201f010230102202222022220222202222012220130000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001e00022000270001e02022010270101f02023010280102a0322a0222a0222a0222a0122a0130000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000002a6052a6052a6052a6152a6152a6152a6152a6152a6152a6142a6142a6142a6142a6142a6130060000600006000060000000000000000000000000000000000000000000000000000000000000000000
010e0021061200c100120430c1000c1000c10007120071200712007120071200712007120071200712007120061300c000120330c0000c0000c000091200912009120091200912009120071300c0001002600000
010e000006120061100611006110105201011012520121101051510115061200611006110061101001012110041200411004110041101c0251c115045200411504520041151652512115105250f1150d5250f115
011000000c0430412010520040200412004510100100411010510040101011004510040200411010510040100c043051201152005020051200551011010051101151005010111100551005020051101151005010
010e000006120061100611006110105201011012520121101051510115061200611006110061101051012110041200411004110041101c5151c11504020041101652116110125201211010520101100d5200d110
010e00200c043257152a715257152a6150c0031e615257152a705257152a6130c0002e7152a715257150c0030c0432851428515285142a6131c5150c033126152a613347052a6133470528714287152a6152a615
011000001c524235241c524235241c514235141c514235141c514235141c514235141c514235141c5142351429511295102951229512245112451024512245122351123510235122351221511215102151221512
010e000022020220102201222015194051910522020220102201022012220122201222012220122571527715287152b7152a7122a7151f0201f71521020217152302023715260202601026712267122501025715
010e00002202022010220122201220020207152202022010220122201222012220122201222012220150c023000000000000000000001f0201f71521020217151e0201e7151f0201f0121f7121f715000000c023
011000001f7001f7001f7001f7001f7211f7201f7201f722237212372023722237221f7211f7201f7201f71221721217202172021720217202172221722217222172221722217202171021710217122171221712
01100000000000000000000000001f0211f0201f0201f022230212302023020230121f0211f0201f0221f0122d0212d0202d0102d012280212802028012280122602126020260122601224021240202401024012
010d000026505275052b5053050526005270052b005300051a7051b7051f705247051a7051b7051f705247051a7041b7041f704247040e7040f70413704187041a7041b7041f704247040e7040f7041370418704
010200000a20409505082040750506204055050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100020010400604296051d6051f60516605126050f6050c60516605126050f6050c6050a605066050360500005000050000500005000050000500005000050000500005000050000500005000050000500005
010600003967035665326610f2612c655296530a241226431e631052311b6251762302211116110d61501211016100161001615040111f22107521230210b2211c53128031142312c5313004118241365411e041
010100000c16515003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01010004005140051500014000151f60516605126050f6050c60516605126050f6050c6050a605066050360500005000050000500005000050000500005000050000500005000050000500005000050000500005
010400001d64513605136350d6050762516605126050f6050c60516605126050f6050c6050a605066050360500005000050000500005000050000500005000050000500005000050000500005000050000500005
010300200073403735040340073503044040350074403035047440003403744040340074703037047470003703745040350074503035047450003503745040350073503034047350003403736040360073603036
010100000c15515003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103000010645150030c625000000c605000000c60500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01020000026340861412634186141f63424614031140161407124016340a1140161410154016140b1140163407114016140312401614011140161501615016150000500005000050000500005000050000500005
01030000180530c04302622001300002516605126050f6050c60516605126050f6050c6050a605066050360500005000050000500005000050000500005000050000500005000050000500005000050000500005
01030000081200a5300c1450010200100001050e7000c705000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400001d64513605136350d6050762516605126050f6050c60516605126050f6050c6050a605066050360500005000050000500005000050000500005000050000500005000050000500005000050000500005
010100000e1600e1600862508625132611326108625086251006110061096250862507615066150561504615036100261501611086051d2001d60500600006000060000600006000060000600006000060000600
01030000006240062000624265342b734270342c534287242d024295242e7242a0142f5142b714300142c514317142d0143251400605006050060500005000050000500005000050000500005000050000500005
010200000c6240c6150f6211b2252721111621116253f514335050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01020000026040860412604186041f60424604031040160407104016040a1040160410104016040b1040160407104016040310401604011040160501605016050000500005000050000500005000050000500005
010300000c6541c640106350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010118200111403614061140a6140d114126141111413614190241b62421024246241f024236241c02418624280342a634140340f634186441c6341c6241c614030240161607124016140b524016141212401614
010200000a23409761085510774106531057210351100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200000c0330002100011000110f211152110321500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01040000246250c215356150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011200000f7640a751077410373101711007000070018600007000070000700007000070000700007000070000700007000070000700017000070000700007000070000700007000070000700007000070000700
010d000026565275652b5653056526055270552b055300551a7451b7451f745247451a7351b7351f735247350e7240f72413724187241a7041b7041f704247040e7040f70413704187040e7040f7041370418704
0108000031555365453a53531025367153a01531705367053a7053b5043c5043b5043c5043b5043c5043b50400005000050000500005000050000500005000050000500005000050000500005000050000500005
011000001061004675006350061500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01050000113600b351113410b2310f041092310f021092110e5210b2110e0110b2110c511060110c51106011113000b200113000b200113000b200113000b200117000b200117000b200117000b200117000b200
00100000120501205012050120500c0000c0001205012050120000c000120501205012050120500c0000c000100501005010050100500c0000c00010050100500c000100501005010050100500c0001005000000
__music__
01 41020301
00 41020301
00 45060708
00 490a0708
00 45060708
00 4b0b0708
00 45060708
00 490a0708
00 45060708
00 4b0b0708
00 4d0d0f10
00 51110f10
00 4d0d0f10
00 50110f10
00 42021901
00 42021901
00 461c1d1f
00 4a1a1d20
00 461c1d1f
00 4c1a1d0c
00 461c1d1f
00 4a1a1d20
00 461c1d1f
00 4c1a1d0c
00 4d1b1021
00 511b1e22
00 4d1b1021
02 511b1e22
01 41121314
02 41151314
04 41161718
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
04 41424344

