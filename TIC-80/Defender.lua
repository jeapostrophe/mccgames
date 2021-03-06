-- title:  Defender
-- author: Balistic Ghoul Studios
-- desc:   Defend your wall, and don't get shot!
-- script: lua


function TODO()
 
	-- --
	--Make enemy Invonerible time--
	--Make enemy change sprites when hurt--
	--Fix up score feature--
	--Make enemy disapear when it leaves the screen--
	--Fix should_reboot, sometimes it ends to early--
	--Show Hp, bar over enemy's heads, after losing one health, same for you--
	--Have enemys not overlap, exept for Airship and Helicopter, Make them allways go over any one.--
	--Make enemy's have a 50% chance of not compleatly blowing up, and leaving remains, and other enemys--
	-- --
	
end

function valueInRange(value, min, max)
 return ((value >= min) and (value <= max))
end
function rect_inter(A,B)
 local xOverlap = 
	 (valueInRange(A.x, B.x, B.x + B.w) or
   valueInRange(B.x, A.x, A.x + A.w))

 local yOverlap = 
	 (valueInRange(A.y, B.y, B.y + B.h) or
   valueInRange(B.y, A.y, A.y + A.h))

 return (xOverlap and yOverlap)
end

SCREEN={x=0,y=0,w=30*8,h=16*8}

function reboot()
 x=13.5*8
	y=14.5*8
	mapx=0
	mapy=0
	msgtim=120
--	if btnp(4) then
--  mapx=0
--  mapy=0
--	end
 p={
  x=13.5*8,
  y=14.5*8,
	 tothp=7,
	 curhp=7,
	 spr=256,
		firet=0
 }
	ents={}
 timers={
	 {st=0, it=180, c=7, f=add_Soldier},
		{st=280, it=280, c=4, f=add_NavySeal},
	 {st=0, it=300, c=5, f=add_Tank},
		{st=0, it=180, c=10, f=add_Scout},
		{st=360, it=360, c=3, f=add_SpecialForces},
		{st=420, it=420, c=2, f=add_HeavyTank},
		{st=480, it=480, c=2, f=add_Helicopter},
		{st=540, it=540, c=1, f=add_Truck},
		{st=600, it=600, c=1, f=add_Airship},
	}
end

function mhit_player(r)
 local pr={x=p.x,y=p.y,w=2*8,h=2*8}
 if p.curhp > 0 and rect_inter(r,pr) then
	 hurt()
		return true
	end
	return false
end
function hurt()
 p.curhp = math.max(0, p.curhp - 1)
	richexplo(p.x,p.y)
	mapx=mapx+30
	if p.curhp == 0 then
		richexplo(x,y)
		richexplo(x+24,y)
		richexplo(x-24,y)
		richexplo(x+40,y)
		richexplo(x-40,y)
	end
end

ents={}
function update_ents()
	for key,e in pairs(ents) do
	 local keep=e.update()
		if keep == false then
		 table.remove(ents,key)
		end
	end
end
function draw_ents()
	for key,e in pairs(ents) do
	 e.draw()
	end
end
function add_bullet(x, y, dy)
 function draw()
  spr(258, x, y, 0)
	end
	function update()
	 y = y+dy
		
		if (y < 0 or y > 15*8) then
		 return false
		end
		local br = { x=x+4, y=y+4, w=2, h=2 }
		if dy > 0 then
		 return not mhit_player(br)
		else
		 return not mhit_enemy(br)
		end
	end
	table.insert(ents, 
	 { draw = draw
	 , update = update })
end

function mhit_enemy(r)
	for key,e in pairs(ents) do
	 if e.collide then
		 e.collide(r)
		end
	end
end
function add_enemy(e)
 e.w=e.sprs*8
	e.h=e.sprs*8
 local alive=true
 function collide(r)
	 if rect_inter(r,e) then
	  richexplo(r.x, r.y)
		 e.hp=e.hp-1
			if e.hp == 0 then
			 alive=false
				score=score+10
			end
		end
	end
 function draw()
	 spr(e.spr, e.x, e.y, 0, 1, 0, 0, e.sprs, e.sprs)
	end
	local shotT = e.shotT
	function update()
	 if not alive then return false end
		should_reboot=false
	 e.x = e.x + e.dx
		e.y = e.y + e.dy
		if shotT then
		 if shotT == 0 then
		  shotT = e.shotT
		  add_bullet(e.x, e.y, 1)
		 else
		  shotT = shotT - 1
		end
		end
		if not rect_inter(e, SCREEN) then
		 return false
		end
	end
	table.insert(ents, 
	 { collide = collide
		, draw = draw
	 , update = update })
end

function add_Soldier()
 add_enemy(
	 { x=math.random(0,29*8)
		, y=0
		, dx=0
		, dy=0.05
 	, spr=10
		, hp=1
		, shotT=120
		, sprs=1 })
end

function add_SpecialForces()
 add_enemy(
	{x=math.random(0,29*8),
		y=0,
		dx=0,
		dy=0.05,
		spr=9,
		hp=1,
		shotT=120,
		sprs=1
	})
end

function add_NavySeal()
 add_enemy(
	{x=math.random(0,29*8),
		y=0,
		dx=0,
		dy=0.05,
		spr=41,
		hp=1,
		shotT=120,
		sprs=1
	})
end

function add_Tank()
 add_enemy(
	{ x=math.random(0,27*8),
		 y=0,
		 dx=0,
		 dy=0.05,
		 spr=1,
		 hp=3,
		 shotT=120,
		 sprs=2
	})
end

function add_HeavyTank()
 add_enemy(
	{x=math.random(0,27*8),
		y=0,
		dx=0,
		dy=0.05,
		spr=5,
		hp=3,
		shotT=180,
		sprs=2
	})
end

function add_Helicopter()
 add_enemy(
	{x=math.random(0,27*8),
		y=0,
		dx=0,
		dy=0.05,
		spr=97,
		hp=3,
		shotT=120,
		sprs=2
	})
end

function add_Truck()
 add_enemy(
	{y=math.random(0,11*8),
		x=28,
		dy=0,
		dx=0.25,
		spr=101,
		hp=3,
		shotT=nil,
		sprs=2
	})
end

function add_Airship()
 add_enemy(
	{x=math.random(0,25*8),
		y=0,
		dx=0,
		dy=0.02,
		spr=259,
		hp=4,
		shotT=180,
		sprs=4
	})
end

function add_Scout()
 add_enemy(
	{x=math.random(0,27*8),
		y=0,
		dx=0,
		dy=0.05,
		spr=73,
		hp=2,
		shotT=nil,
		sprs=2
	})
end


should_reboot=nil
score=0
function TIC()
 should_reboot=true
	
	update_psystems()
	update_ents()
	if p.firet > 0 then
 	p.firet = p.firet - 1
	end
	for key,t in pairs(timers) do
		if t.c > 0 then
			should_reboot=false
		end
	 if t.t then
		 if t.c > 0 then
		  if t.t==0 then
			  t.f()
				 t.t=t.it
				 t.c=t.c-1
			 else
				 t.t=t.t-1
			 end
			end
		elseif t.st == 0 then
			t.t=t.it
		else 
		 t.st=t.st-1
		end
	end
	if btn(2) then 
	 p.x=p.x-1
	end
	if btn(3) then 
	 p.x=p.x+1 
	end

	cls(0)

	map(mapx,mapy)
	
	print("Score:"..score,0,0,7,0,1,1)
	
	if msgtim > 0 then
	 print("Incoming Wave!",8*8,6*8,8,0,2,1)
  msgtim=msgtim-1
	end
	draw_psystems()
	draw_ents()

 if p.curhp > 0 then
 	if p.firet == 0 and btn(5) then
		 add_bullet(p.x + 4, p.y - 5, -1)
			p.firet = 30
  end
  p.spr=256+32*(4 - math.ceil((p.curhp / p.tothp)*4))
 	spr(p.spr,p.x,p.y,0,1,0,0,2,2)
	else
		print("GAME OVER",10*8,6*8,15,0,2,1)
		print("Press X",11*8,8*8,15,0,2,1)
		print("Score:"..score,10*8,10*8,15,0,1,1)
		print("1st, Balistic Ghoul: 473916",10*8,11*8,15,0,1,1)
		print("2nd, Spanky: 45383",10*8,12*8,15,0,1,1)
		print("3rd, Blitzen_Beary: 8261",10*8,13*8,15,0,1,1)
		if btnp(5) then
			reboot()
		end
	end
	
	if should_reboot then
		reboot()
--		mapy=mapy+17
 end
end

--==================================================================================--
-- PARTICLE SYSTEM LIBRARY =========================================================--
--==================================================================================--

particle_systems = {}

-- Call this, to create an empty particle system, and then fill the emittimers, emitters,
-- drawfuncs, and affectors tables with your parameters.
function make_psystem(minlife, maxlife, minstartsize, maxstartsize, minendsize, maxendsize)
	local ps = {
	-- global particle system params

	-- if true, automatically deletes the particle system if all of it's particles died
	autoremove = true,

	minlife = minlife,
	maxlife = maxlife,

	minstartsize = minstartsize,
	maxstartsize = maxstartsize,
	minendsize = minendsize,
	maxendsize = maxendsize,

	-- container for the particles
	particles = {},

	-- emittimers dictate when a particle should start
	-- they called every frame, and call emit_particle when they see fit
	-- they should return false if no longer need to be updated
	emittimers = {},

	-- emitters must initialize p.x, p.y, p.vx, p.vy
	emitters = {},

	-- every ps needs a drawfunc
	drawfuncs = {},

	-- affectors affect the movement of the particles
	affectors = {},
	}

	table.insert(particle_systems, ps)

	return ps
end

-- Call this to update all particle systems
function update_psystems()
	local timenow = time()
	for key,ps in pairs(particle_systems) do
		update_ps(ps, timenow)
	end
end

-- updates individual particle systems
-- most of the time, you don't have to deal with this, the above function is sufficient
-- but you can call this if you want (for example fast forwarding a particle system before first draw)
function update_ps(ps, timenow)
	for key,et in pairs(ps.emittimers) do
		local keep = et.timerfunc(ps, et.params)
		if (keep==false) then
			table.remove(ps.emittimers, key)
		end
	end

	for key,p in pairs(ps.particles) do
		p.phase = (timenow-p.starttime)/(p.deathtime-p.starttime)

		for key,a in pairs(ps.affectors) do
			a.affectfunc(p, a.params)
		end

		p.x = p.x + p.vx
		p.y = p.y + p.vy

		local dead = false
		if (p.x<0 or p.x>240 or p.y<0 or p.y>136) then
			dead = true
		end

		if (timenow>=p.deathtime) then
			dead = true
		end

		if (dead==true) then
			table.remove(ps.particles, key)
		end
	end

	if (ps.autoremove==true and #ps.particles<=0) then
		local psidx = -1
		for pskey,pps in pairs(particle_systems) do
			if pps==ps then
				table.remove(particle_systems, pskey)
				return
			end
		end
	end
end

-- draw a single particle system
function draw_ps(ps, params)
	for key,df in pairs(ps.drawfuncs) do
		df.drawfunc(ps, df.params)
	end
end

-- draws all particle system
-- This is just a convinience function, you probably want to draw the individual particles,
-- if you want to control the draw order in relation to the other game objects for example
function draw_psystems()
	for key,ps in pairs(particle_systems) do
		draw_ps(ps)
	end
end

-- This need to be called from emitttimers, when they decide it is time to emit a particle
function emit_particle(psystem)
	local p = {}

	local ecount = nil
	local e = psystem.emitters[math.random(#psystem.emitters)]
	e.emitfunc(p, e.params)

	p.phase = 0
	p.starttime = time()
	p.deathtime = time()+frnd(psystem.maxlife-psystem.minlife)+psystem.minlife

	p.startsize = frnd(psystem.maxstartsize-psystem.minstartsize)+psystem.minstartsize
	p.endsize = frnd(psystem.maxendsize-psystem.minendsize)+psystem.minendsize

	table.insert(psystem.particles, p)
end

function frnd(max)
	return math.random()*max
end


--================================================================--
-- MODULES =======================================================--
--================================================================--

-- You only need to copy the modules you actually use to your program


-- EMIT TIMERS ==================================================--

-- Spawns a bunch of particles at the same time, then removes itself
-- params:
-- num - the number of particle to spawn
function emittimer_burst(ps, params)
	for i=1,params.num do
		emit_particle(ps)
	end
	return false
end

-- Emits a particle every "speed" time
-- params:
-- speed - time between particle emits
function emittimer_constant(ps, params)
	if (params.nextemittime<=time()) then
		emit_particle(ps)
		params.nextemittime = params.nextemittime + params.speed
	end
	return true
end

-- EMITTERS =====================================================--

-- Emits particles from a single point
-- params:
-- x,y - the coordinates of the point
-- minstartvx, minstartvy and maxstartvx, maxstartvy - the start velocity is randomly chosen between these values
function emitter_point(p, params)
	p.x = params.x
	p.y = params.y

	p.vx = frnd(params.maxstartvx-params.minstartvx)+params.minstartvx
	p.vy = frnd(params.maxstartvy-params.minstartvy)+params.minstartvy
end

-- Emits particles from the surface of a rectangle
-- params:
-- minx,miny and maxx, maxy - the corners of the rectangle
-- minstartvx, minstartvy and maxstartvx, maxstartvy - the start velocity is randomly chosen between these values
function emitter_box(p, params)
	p.x = frnd(params.maxx-params.minx)+params.minx
	p.y = frnd(params.maxy-params.miny)+params.miny

	p.vx = frnd(params.maxstartvx-params.minstartvx)+params.minstartvx
	p.vy = frnd(params.maxstartvy-params.minstartvy)+params.minstartvy
end

-- AFFECTORS ====================================================--

-- Constant force applied to the particle troughout it's life
-- Think gravity, or wind
-- params: 
-- fx and fy - the force vector
function affect_force(p, params)
	p.vx = p.vx + params.fx
	p.vy = p.vy + params.fy
end

-- A rectangular region, if a particle happens to be in it, apply a constant force to it
-- params: 
-- zoneminx, zoneminy and zonemaxx, zonemaxy - the corners of the rectangular area
-- fx and fy - the force vector
function affect_forcezone(p, params)
	if (p.x>=params.zoneminx and p.x<=params.zonemaxx and p.y>=params.zoneminy and p.y<=params.zonemaxy) then
		p.vx = p.vx + params.fx
		p.vy = p.vy + params.fy
	end
end

-- A rectangular region, if a particle happens to be in it, the particle stops
-- params: 
-- zoneminx, zoneminy and zonemaxx, zonemaxy - the corners of the rectangular area
function affect_stopzone(p, params)
	if (p.x>=params.zoneminx and p.x<=params.zonemaxx and p.y>=params.zoneminy and p.y<=params.zonemaxy) then
		p.vx = 0
		p.vy = 0
	end
end

-- A rectangular region, if a particle cames in contact with it, it bounces back
-- params: 
-- zoneminx, zoneminy and zonemaxx, zonemaxy - the corners of the rectangular area
-- damping - the velocity loss on contact
function affect_bouncezone(p, params)
	if (p.x>=params.zoneminx and p.x<=params.zonemaxx and p.y>=params.zoneminy and p.y<=params.zonemaxy) then
		p.vx = -p.vx*params.damping
		p.vy = -p.vy*params.damping
	end
end

-- A point in space which pulls (or pushes) particles in a specified radius around it
-- params:
-- x,y - the coordinates of the affector
-- radius - the size of the affector
-- strength - push/pull force - proportional with the particle distance to the affector coordinates
function affect_attract(p, params)
	if (math.abs(p.x-params.x)+math.abs(p.y-params.y)<params.mradius) then
		p.vx = p.vx + (p.x-params.x)*params.strength
		p.vy = p.vy + (p.y-params.y)*params.strength
	end
end

-- Moves particles around in a sin/cos wave or circulary. Directly modifies the particle position
-- params:
-- speed - the effect speed
-- xstrength, ystrength - the amplituse around the x and y axes
function affect_orbit(p, params)
	params.phase = params.phase + params.speed
	p.x = p.x + math.sin(params.phase)*params.xstrength
	p.y = p.y + math.cos(params.phase)*params.ystrength
end

-- DRAW FUNCS ===================================================--

-- Filled circle particle drawer, the particle animates it's size and color trough it's life
-- params:
-- colors array - indexes to the palette, the particle goes trough these in order trough it's lifetime
-- startsize and endsize is coming from the particle system parameters, not the draw func params!
function draw_ps_fillcirc(ps, params)
	for key,p in pairs(ps.particles) do
		c = math.floor(p.phase*#params.colors)+1
		r = (1-p.phase)*p.startsize+p.phase*p.endsize
		circ(p.x,p.y,r,params.colors[c])
	end
end

-- Single pixel particle, which animates trough the given colors
-- params:
-- colors array - indexes to the palette, the particle goes trough these in order trough it's lifetime
function draw_ps_pixel(ps, params)
	for key,p in pairs(ps.particles) do
		c = math.floor(p.phase*#params.colors)+1
		pix(p.x,p.y,params.colors[c])
	end
end

-- Draws a line between the particle's previous and current position, kind of "motion blur" effect
-- params:
-- colors array - indexes to the palette, the particle goes trough these in order trough it's lifetime
function draw_ps_streak(ps, params)
	for key,p in pairs(ps.particles) do
		c = math.floor(p.phase*#params.colors)+1
		line(p.x,p.y,p.x-p.vx,p.y-p.vy,params.colors[c])
	end
end

-- Animates trough the given frames with the given speed
-- params:
-- frames array - indexes to sprite tiles
function draw_ps_animspr(ps, params)
	params.currframe = params.currframe + params.speed
	if (params.currframe>#params.frames) then
		params.currframe = 1
	end
	for key,p in pairs(ps.particles) do
		-- pal(7,params.colors[math.floor(p.endsize)])
		spr(params.frames[math.floor(params.currframe+p.startsize)%#params.frames],p.x,p.y,0)
	end
	-- pal()
end

-- Maps the given frames to the life of the particle
-- params:
-- frames array - indexes to sprite tiles
function draw_ps_agespr(ps, params)
	for key,p in pairs(ps.particles) do
		local f = math.floor(p.phase*#params.frames)+1
		spr(params.frames[f],p.x,p.y,0)
	end
end

-- Each particle is randomly chosen from the given frames
-- params:
-- frames array - indexes to sprite tiles
function draw_ps_rndspr(ps, params)
	for key,p in pairs(ps.particles) do
		-- pal(7,params.colors[math.floor(p.endsize)])
		spr(params.frames[math.floor(p.startsize)],p.x,p.y,0)
	end
	-- pal()
end


--==================================================================================--
-- SAMPLES PARTICLE SYSTEMS ========================================================--
--==================================================================================--

function make_explosparks_ps(ex,ey)
	local ps = make_psystem(300,700, 1,2,0.5,0.5)
	
	table.insert(ps.emittimers,
		{
			timerfunc = emittimer_burst,
			params = { num = 10}
		}
	)
	table.insert(ps.emitters, 
		{
			emitfunc = emitter_point,
			params = { x = ex, y = ey, minstartvx = -1.5, maxstartvx = 1.5, minstartvy = -1.5, maxstartvy=1.5 }
		}
	)
	table.insert(ps.drawfuncs,
		{
			drawfunc = draw_ps_pixel,
			params = { colors = {15,13,4,15,4,13} }
		}
	)
	table.insert(ps.affectors,
		{ 
			affectfunc = affect_force,
			params = { fx = 0, fy = 0.1 }
		}
	)
end

function make_explosion_ps(ex,ey)
	local ps = make_psystem(100,500, 9,14,1,3)
	
	table.insert(ps.emittimers,
		{
			timerfunc = emittimer_burst,
			params = { num = 4 }
		}
	)
	table.insert(ps.emitters, 
		{
			emitfunc = emitter_box,
			params = { minx = ex-4, maxx = ex+4, miny = ey-4, maxy= ey+4, minstartvx = 0, maxstartvx = 0, minstartvy = 0, maxstartvy=0 }
		}
	)
	table.insert(ps.drawfuncs,
		{
			drawfunc = draw_ps_fillcirc,
			params = { colors = {15,13,4,6,6,2} }
		}
	)
end

function make_smoke_ps(ex,ey)
	local ps = make_psystem(200,2000, 1,3, 6,9)
	
	ps.autoremove = true

	table.insert(ps.emittimers,
		{
			timerfunc = emittimer_burst,
			params = { num = 20 }
		}
	)
	table.insert(ps.emitters, 
		{
			emitfunc = emitter_box,
			params = { minx = ex-4, maxx = ex+4, miny = ey, maxy= ey+2, minstartvx = 0, maxstartvx = 0, minstartvy = 0, maxstartvy=0 }
		}
	)
	table.insert(ps.drawfuncs,
		{
			drawfunc = draw_ps_fillcirc,
			params = { colors = {3,2,1} }
		}
	)
	table.insert(ps.affectors,
		{ 
			affectfunc = affect_force,
			params = { fx = 0.003, fy = -0.009 }
		}
	)
end

function make_explosmoke_ps(ex,ey)
	local ps = make_psystem(1500,2000, 5,8, 17,18)

	table.insert(ps.emittimers,
		{
			timerfunc = emittimer_burst,
			params = { num = 1 }
		}
	)
	table.insert(ps.emitters, 
		{
			emitfunc = emitter_point,
			params = { x = ex, y = ey, minstartvx = 0, maxstartvx = 0, minstartvy = 0, maxstartvy=0 }
		}
	)
	table.insert(ps.drawfuncs,
		{
			drawfunc = draw_ps_fillcirc,
			params = { colors = {2} }
		}
	)
	table.insert(ps.affectors,
		{ 
			affectfunc = affect_force,
			params = { fx = 0.003, fy = -0.01 }
		}
	)
end

--==================================================================================--
-- DEMOS ===========================================================================--
--==================================================================================--

function explo()
	make_explosion_ps(frnd(220)+10,frnd(116)+10)
end

function richexplo(rx,ry)
--	make_explosmoke_ps(rx,ry)
 make_smoke_ps(rx,ry)
	make_explosparks_ps(rx,ry)
	make_explosion_ps(rx,ry)
	sfx(1)
end

function smoke()
	make_smoke_ps(frnd(220)+10,frnd(90)+10)
end

function deleteallps()
	for key,ps in pairs(particle_systems) do
		particle_systems[key] = nil
	end
end

reboot()
-- <TILES>
-- 000:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 001:666600006226000063368888622688886336aaaa6226aaaa6336a8886226a8aa
-- 002:00006666000062268888633688886226aaaa6336aaaa6226888a6336aa8a6226
-- 003:666600006336000062268888633688886226aaaa6336aaaa6226a8886336a8aa
-- 004:00006666000063368888622688886336aaaa6226aaaa6336888a6226aa8a6336
-- 005:0666600006336000062266660633666606226333063363330666633300006666
-- 006:0006666000063360666622606666336033362260333633603336666066660000
-- 007:0666600006226000063366660622666606336333062263330666633300006666
-- 008:0006666000062260666633606666226033363360333622603336666066660000
-- 009:0006600000633600063333600633336003633630004664000020400000230000
-- 010:00088000008aa80008aaaa8008aaaa800a8aa8a0004884000020400000230000
-- 011:000000000066000006360808622688886336a8aa06226aaa6336aa886226a8aa
-- 012:0000066600006226888863368a886260aaaa6360aaaa6260888a6336aa8a6226
-- 013:0606600006636000062266060633666600626333063663330660633300000636
-- 014:0000000000066000006626000636336063362600333363603336666066660000
-- 016:cccccccccccccccc333333333233323323232323333233326363636336363636
-- 017:6336a8aa6226a8886336a9886226aa986336aaa8622600086336000866660000
-- 018:aa8a6336888a6226889a633689aa62268aaa6336800062268000633600006666
-- 019:6226a8aa6336a8886226a9886336aa986226aaa8633600086226000866660000
-- 020:aa8a6226888a6336889a622689aa63368aaa6226800063368000622600006666
-- 021:0666663306336633062266660633676606226367063360600666606000000060
-- 022:3366666033663360666622606676336076362260060633600606666006000000
-- 023:0666663306226633063366660622676606336367062260600666606000000060
-- 024:3366666033662260666633606676226076363360060622600606666006000000
-- 025:0660066000766700006336000633336006333360006336000306603040000004
-- 026:0330033000988900008aa80008aaaa8008aaaa80008aa8000a0880a040000004
-- 027:6336a8aa6226a88a6336a9886226aa9806360aa8622600000636000800660000
-- 028:aa8a6366888aa600889a636089aa62268aaa6336800062268000063600006666
-- 029:0666663300636633062266660633676600626367063660600660600000000000
-- 030:3366660033363360666626006676336076362260060636600606606000000000
-- 032:ccccccccc666666c333333333233323323232323333233326363636336363636
-- 033:666600006226000063368808622688886336aaaa6226aaaa6336a8886226a8aa
-- 034:00006666000062268888633688886226aaaa6336aaaa6226888a6336aa8a6226
-- 035:666600006336000062268808633688886226aaaa6336aaaa6226a8886336a8aa
-- 036:00006666000063368888622688886336aaaa6226aaaa6336888a6226aa8a6336
-- 037:0606600006636000062266060633666606226333063363330666633300006666
-- 038:0006666000063360666622606666336033362260333333603336666066660000
-- 039:0606600006626000063366060622666606336333062263330666633300006666
-- 040:0006666000062260666633606666226033363360333322603336666066660000
-- 041:000ee00000ebbe000ebbbbe00ebbbbe00bebbeb0004ee4000020400000230000
-- 043:0002200000002200000022206000011666001111000111060010100000000006
-- 044:0001000000111000011100006112222011220200600000006000033060003213
-- 045:00000000000000000000000000000000000006a800006888000638aa00068aa6
-- 046:00000000000000000000000000660000a6360000a826000088600000a8260000
-- 048:363636366363636333323332232323233233323333333333cccccccccccccccc
-- 049:6336a8aa6226a8886336a9886226aa980636aaa8622600006336000866660000
-- 050:aa8a6336888a6226889a633689aa62268aaa6336800062268000633600006666
-- 051:6226a8aa6336a8886226a9886336aa980626aaa8633600006226000866660000
-- 052:aa8a6226888a6336889a622689aa63368aaa6226800063368000622600006666
-- 053:0666663300636633062266660633676606226367063360600666606000000000
-- 054:3366666033363360666622606676336076362260060636600606606006000000
-- 055:0666663300626633063366660622676606336367062260600666606000000000
-- 056:3366666033362260666633606676226076363360060626600606606006000000
-- 057:03300330007ee70000ebbe000ebbbbe00ebbbbe000ebbe000b0ee0b040000004
-- 059:000bb33300ebb366021be36301bb336333373363337673633337336603303333
-- 060:3333167266372761367671233637333076330300363000006600600030066000
-- 061:000638aa00002888000636a80000660800000000000000000000000000000000
-- 062:a836000088260000a63600000060000000000000000000000000000000000000
-- 064:363636366363636333323332232323233233323333333333c666666ccccccccc
-- 065:666600006226000063368808622688886336aaaa6226aaaa6336aa886226a8aa
-- 066:0000066600006226888863368a886226aaaa6336aaaa6226888a6336aa8a6226
-- 067:666600006336000062268808633688886226aaaa6336aaaa6226aa886336a8aa
-- 068:0000666600006336888862268a886336aaaa6226aaaa6336888a6226aa8a6336
-- 069:0606600006636000062266060633666600626333063363330666633300000666
-- 070:0006666000063360666622606636336033362260333363603336666066660000
-- 071:0606600006626000063366060622666600636333062263330666633300000666
-- 072:0006666000062260666633606636226033363360333362603336666066660000
-- 073:00000000000000000000000000066600000636aa00062888000638aa000628a6
-- 074:00000000000000000000000006660000a636000088260000a8360000a8260000
-- 075:00000000000000000000000000066600000626aa00063888000628aa000638a6
-- 076:00000000000000000000000006660000a626000088360000a8260000a8360000
-- 080:cccccccccc5ccccccccccccccccccccccccccc5cccccccccc5cccccccccccccc
-- 081:6336a8aa6226a8886336a9886226aa980636aaa8622600006336000866660000
-- 082:aa8a6336888a6226889a633689aa62268aaa6336800062268000063600006666
-- 083:6226a8aa6336a8886226a9886336aa980626aaa8633600006226000866660000
-- 084:aa8a6226888a6336889a622689aa63368aaa6226800063368000062600006666
-- 085:0666663300636633062266660633676606226367063660600660606000000000
-- 086:3366660033363360666622606676336076362260060636600606606006000000
-- 087:0666663300626633063366660622676606336367062660600660606000000000
-- 088:3366660033362260666633606676226076363360060626600606606006000000
-- 089:000638aa00062888000636a80006660800000008000000000000000000000000
-- 090:a836000088260000a63600000666000000000000000000000000000000000000
-- 091:000628aa00063888000626a80006660800000008000000000000000000000000
-- 092:a826000088360000a62600000666000000000000000000000000000000000000
-- 096:cccccccccaccccacc8cac8accccac8cccac8cccccac8caccc8ccc8cccccccccc
-- 097:0000000600000066000000060000000300000222000022220002222200222222
-- 098:6000000066000000600000003000000022200000222100002212100021212200
-- 099:0000000600000066000000060000000300000222000012220001212200221212
-- 100:6000000066000000600000003000000022200000222200002222200022222200
-- 101:0000000000000000066666000623260006a5454a004545480045454a0045454a
-- 102:00000000000000000666660006232600aaaaa60088b93000a8b92000a8b93000
-- 103:0000000000000000066666000632360006a5454a004545480045454a0045454a
-- 104:00000000000000000666660006323600aaaaa60088b93000a8b92000a8b93000
-- 105:00000000000000000000000000066600000636a800062888000638aa00068aa6
-- 106:00000000000000000000000000660000a636000088260000a8600000a8260000
-- 107:00000000000000000000000000066600000626a800063888000628aa00068aa6
-- 108:00000000000000000000000000660000a626000088360000a8600000a8360000
-- 112:ccccccccccccccccccc33333cc322322c3233333cccccccccccccccccccccccc
-- 113:0022222200222226002222160022212100221212000121220000122200000222
-- 114:1212220061222200622222002222220022222200222220002222000022200000
-- 115:0022212100222216002222260022222200222222000222220000222200000222
-- 116:2222220062222200612222001212220021212200221210002221000022200000
-- 117:0045454a0045454a0045454806a5454a06232600066666000000000000000000
-- 118:a8b93000a8b9200088b93000aaaaa60006232600066666000000000000000000
-- 119:0045454a0045454a0045454806a5454a06323600066666000000000000000000
-- 120:a8b93000a8b9200088b93000aaaaa60006323600066666000000000000000000
-- 121:000638aa00062888000636a80000660800000008000000000000000000000000
-- 122:a836000088260000a63600000060000000000000000000000000000000000000
-- 123:000628aa00063888000626a80000660800000008000000000000000000000000
-- 124:a826000088360000a62600000060000000000000000000000000000000000000
-- 128:cccccccccccccccc333333332322232233333333cccccccccccccccccccccccc
-- 129:0000000600000006000000060000000300000222000022220002222200222222
-- 130:6000000066000000600000003000000022200000222100002212100021212200
-- 131:0000000600000006000000060000000300000222000012220001212200222212
-- 132:6000000066000000600000003000000022200000222200002222200022222200
-- 133:0000000000000000066666000623260006a5654a004545480045454a0045454a
-- 134:00000000000000000666660006232600aaaaa60088b93000a8b92000a8b93000
-- 135:0000000000000000066666000632360006a5654a004545480045454a0045454a
-- 136:00000000000000000666660006323600aaaaa60088b93000a8b92000a8b93000
-- 144:cccccccccccccccc33333ccc223223cc3333323ccccccccccccccccccccccccc
-- 145:0022222200222220002222160022212100221212000122220000122200000222
-- 146:1212220061222200022222002222220022222200222220002222000022200000
-- 147:0022212100222216002222200022222200222222000222220000222200000222
-- 148:2222220002222200612222001212220021212200221210002221000022200000
-- 149:0045454a0045454a0045454806a5454a06232600066666000000000000000000
-- 150:a8b93000a8b92000a8b930000aaaa60006232600066660000000000000000000
-- 151:0045454a0045454a0045454806a5454a06323600066666000000000000000000
-- 152:a8b93000a8b92000a8b930000aaaa60006323600066660000000000000000000
-- 160:ccccccccccccccccccccccccc3cccccc323c2c3ccccccccccccccccccccccccc
-- 161:0000000600000006000000060000000300000222000022220002022200222022
-- 162:6000000066000000600000003000000022200000222100002212100022212200
-- 163:0000000600000006000000060000000300000222000012220001212200222212
-- 164:6000000066000000600000003000000022200000222200002220200022022200
-- 165:0000000000000000066666000623260006a5654a004545480045454a0045454a
-- 166:00000000000600000660660006232600aaaaa60088b93000a8e92000a8b93000
-- 167:0000000000000000066666000632360006a5654a004545480045454a0045454a
-- 168:00000000000600000660660006323600aaaaa60088b93000a8e92000a8b93000
-- 176:cccccccccccccccccccccccccccccc3cc3c2c323cccccccccccccccccccccccc
-- 177:0022222200222226002222160022212100221212000122220000122200000222
-- 178:1212220061222200022222002022220022222200222020002222000022200000
-- 179:0022212100222216002222200022220200222222000202220000222200000222
-- 180:2222220002222200612222001212220021222200221210002221000022200000
-- 181:0405454a0045454a0045454806a5454a06232600066666000000000000000000
-- 182:a8b93000a8b92000a8b930000aaaa60006232600066660000000000000000000
-- 183:0405454a0045454a0045454806a5454a06323600066666000000000000000000
-- 184:a8b93000a8b92000a8b930000aaaa60006323600066660000000000000000000
-- 192:cccccccccccccccc33c3333c3233323323232323333233326363636336363636
-- 193:ccccccccc66c6c6c33333c333233323323232323333233326363636336363636
-- 194:ccccccccccccccccccccccccccc33ccc2cc3cc2c3c323c32636363c336363636
-- 195:cccccccccc6c6ccccc3ccc3cc2c33c332c2323c3333cc33c6363c36336363636
-- 196:363636366363636333323332232323233233323333c3333ccccccccccccccccc
-- 197:363636366363636333323332232323233233323333333c33c66c6c6ccccccccc
-- 198:36363636636363c33c323c322cc3cc2cccc33ccccccccccccccccccccccccccc
-- 199:363636366363c363333cc33c2c2323c3c2c33c33cc3ccc3ccc6c6ccccccccccc
-- 200:ccccccccccccccccccccccccccccccccccccccccccccccccc2cc2ccc213c32c3
-- 201:cccccccccccccccccccccccccccccccccccccccccccccccccccccc3cc3c2c323
-- 202:7e777e77ebeeebebebebebebebebebebebebebebb2bbb2bb7e7e7e7e7e7e7e7e
-- 203:ddddffddfdffffddfdfffffdfffffffdffffffffffffffff76667677dddd6dd7
-- 204:8888aa88a8aaaa88a8aaaaa8aaaaaaa8aaaaaaaaaaaaaaaa9666969988886889
-- 205:6366636632333232323232323232323232323232212221226363636363636363
-- 208:cccccccccccccccc3cc3c3cc32c3323c23232323333233326363636336363636
-- 209:cccccccccc6c6c6cc3333c3c3233323323232323333233326363636336363636
-- 210:ccccccccccccccccccccccccccc3cccc2cc3cc2c3c3c3c326c6c63c3c6c63c36
-- 211:cccccccccccccccccc3ccc3cc2c3ccc32c2c23c3c3ccc33c6c63cc63363636c6
-- 212:3636363663636363333233322323232332c3323c3cc3c3cccccccccccccccccc
-- 213:3636363663636363333233322323232332333233c3333c3ccc6c6c6ccccccccc
-- 214:c6c63c366c6c63c33c3c3c322cc3cc2cccc3cccccccccccccccccccccccccccc
-- 215:363636c66c63cc63c3ccc33c2c2c23c3c2c3ccc3cc3ccc3ccccccccccccccccc
-- 216:3c23c312ccc2cc2ccccccccccccccccccccccccccccccccccccccccccccccccc
-- 217:c3c2c323cccccc3ccccccccccccccccccccccccccccccccccccccccccccccccc
-- 218:7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e777e777e77777777cc7777cccccccccc
-- 219:ddddddd6dddddddddddddddddddddd6dd6dddd6dd6dd6d6d777777777cc77cc7
-- 220:888888898888888888888888888888988988889877777777cc7777cccccccccc
-- 221:636363636363636363636363636363636663666366666666777777777cc77cc7
-- 224:ccccccccccccccccccc3cccc3cc332cc2c232c2c3c3233326363636336363636
-- 225:cccccccccc6c6cccc33c3c3c32c33c33232323c3333233326363636336363636
-- 226:ccccccccccccccccccccccccccccccccccc3cccc3ccc3c3c6c6c6cc3c6c63c36
-- 227:ccccccccccccccccccccccccccc3cccc2c2cc3c3c3cccc3c6c63cc63cc3c36c6
-- 228:36363636636363633c3233322c232c2c3cc332ccccc3cccccccccccccccccccc
-- 229:363636366363636333323332232323c332c33c33c33c3c3ccc6c6ccccccccccc
-- 230:c6c63c366c6c6cc33ccc3c3cccc3cccccccccccccccccccccccccccccccccccc
-- 231:cc3c36c66c63cc63c3cccc3c2c2cc3c3ccc3cccccccccccccccccccccccccccc
-- 232:323c2c3cc3cccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 233:ccccccccccccccccccccccccccccccccccccccccccccccccc3cccccc323c2c3c
-- 234:0000000003333300036666300300003003333360036666300333333006666660
-- 235:0000000003333330036666300333333003666630030000300300003006000060
-- 236:0000000003000000030000000300000003000000030000000333333006666660
-- 237:0000000000333330036666600300000003000000030000000633333000666660
-- 238:0000000000333330036666600300000003000330030006300633333000666660
-- 239:0000000003000030030000300333333003666630030000300300003006000060
-- 240:0000000000000000001111110010000000100000001111110000000000000000
-- 241:0000000000000000111111110000000000000000111111110000000000000000
-- 242:0000000000000000111111000000010000000100111111000000000000000000
-- 243:111111111066660116600661160f0f6116000061166666661666666116111111
-- 244:1111111111111111111111111111111111111111111111111111111111111111
-- 245:6666666666666666666666666666666666666666666666666666666666666666
-- 246:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 247:0000000000333330036666600300000006333300006666300333336006666600
-- 248:0000000003333330066336600003300000033000000330000003300000066000
-- 249:0000000003000030030000300300003003000030030000300633336000666600
-- 250:0000000003333300036666300300003003000030030000300333333006666660
-- 251:0000000003333330066336600003300000033000000330000333333006666660
-- 252:0000000000333300036666300300003003000030030000300633336000666600
-- 254:000300000022220002722b200777a24002722f20022002200220022000000000
-- </TILES>

-- <SPRITES>
-- 000:0000770000007700000066000000660000006600000066000000666600006666
-- 001:0077000000770000006600000066000000660000006600006666000066660000
-- 002:0000000000000000000000000004400000044000000000000000000000000000
-- 003:0000000000000000000000000000000000000000000000070000000700000007
-- 004:00060f060006f4f6006333360777777777777733777733377773377b77337bbb
-- 005:60f060006f4f600063333600777777703377777773337777b7733777bbb73377
-- 006:0000000000000000000000000000000000000000700000007000000070000000
-- 007:0000000000000000000000000000000000000000000000070000000700000007
-- 008:000604060006fff6006333360777777777777733777733377773377b77337bbb
-- 009:604060006fff600063333600777777703377777773337777b7733777bbb73377
-- 010:0000000000000000000000000000000000000000700000007000000070000000
-- 011:0000000000033300003333000333320003332000000000000000000000000007
-- 012:0006000000060006006333360777777777777733777733370073377b0033721b
-- 013:600000006000600763333607777777003377770073337700b7733770b1273370
-- 014:0000000077000000770000000000000000770000077770000770770000000000
-- 016:0066666600666666006633330066333300663333006633330066666600666666
-- 017:6666660066666600333366003333660033336600333366006666660066666600
-- 018:000000000000000000000000000dd000000dd000000000000000000000000000
-- 019:0000033700033337033333373666666736333367363333673666666703666637
-- 020:7737eeee7737bbbb7737bbbb7737eeee7737bbbb77377eee77337bbb7733777b
-- 021:eeee7377bbbb7377bbbb7377eeee7377bbbb7377eee77377bbb73377b7773377
-- 022:7330000073333000733333307666666376333363763333637666666373666630
-- 023:0000033700033337033333373666666736333367363333673666666703666637
-- 024:7737eeee7737bbbb7737bbbb7737eeee7737bbbb77377eee77337bbb7733777b
-- 025:eeee7377bbbb7377bbbb7377eeee7377bbbb7377eee77377bbb73377b7773377
-- 026:7330000073333000733333307666666376333363763333637666666373666630
-- 027:0000003700033337033333330666366736333367363333673666666703666637
-- 028:773731ee773721bb77371bb17737ee13773777b17737e77e7733bb7b77337bb7
-- 029:ee137000bbb17000bbbb73701ee17377bb127377e13773771227337717773377
-- 030:0000000030000000333000003333000030000000333000003300000033333000
-- 032:0000770000007700000066000000060000006600000066000000666600006666
-- 033:0077000000770000006600000066000000660000006600006660000066660000
-- 035:0363363700633637007337370003333700000337000000070000000700000007
-- 036:7733377777333337773333337736666677366666773663337736633377366666
-- 037:7773337773333377333333776666637766666377333663773336637766666377
-- 038:7363363073633600737337007333300073300000700000007000000070000000
-- 039:0363363700633637007337370003333700000337000000070000000700000007
-- 040:7733377777333337773333337736666677366666773663337736633377366666
-- 041:7773337773333377333333776666637766666377333663773336637766666377
-- 042:7363363073633600737337007333300073300000700000007000000070000000
-- 043:0363363700633637007337370000333700000333000000070000000700000000
-- 044:7733377777333337773333337336663677366666773663337736633377366666
-- 045:7773337773333377333333776666637766666377333663773336637066666370
-- 046:3333330033333000330000003300000030000000000000000000000000000000
-- 048:0066666600666636000633330066333300663333006633330066666600660666
-- 049:6666660066666600333366003333660033333600333366006666600066666600
-- 051:0000000700000007000000000000000000000000000000000000000000000000
-- 052:7736666677733663077736630777766700077667000776670000066000000660
-- 053:6666637736633777366377707667777076677000766770000660000006600000
-- 054:7000000070000000000000000000000000000000000000000000000000000000
-- 055:0000000700000007000000000000000000000000000000000000000000000000
-- 056:7736666677733663077736630777766700077667000776670000066000000660
-- 057:6666637736633777366377707667777076677000766770000660000006600000
-- 058:7000000070000000000000000000000000000000000000000000000000000000
-- 059:0000000000000007077000000777700000777000000777000007770000000000
-- 060:7736666677733663077736630077766700077667000776670000066000000060
-- 061:6666337736633777366377707667777077000000700000000066600000666600
-- 062:7000000000000000000000000000000000000000006600000006600000006000
-- 064:0000770000007700000066000000060000006600000066000000066600006666
-- 065:0077000000770000006600000060000000600000006600006660000066660000
-- 067:0000000000000000000000000000000000000000000000070000000000000007
-- 068:00060f060006f4f6006333360777777777777733777733377773377b77337bbb
-- 069:60f000006f4f600063333600777777703377777073337777b7733777bbb73377
-- 070:0000000000000000000000000000000000000000700000007000000070000000
-- 071:0000000000000000000000000000000000000000000000070000000000000007
-- 072:000604060006fff6006333360777777777777733777733377773377b77337bbb
-- 073:604000006fff600063333600777777703377777073337777b7733777bbb73377
-- 074:0000000000000000000000000000000000000000700000007000000070000000
-- 075:0066666600666666006633330066333300663333006633330066666600666666
-- 076:6666660066666600333366003333660033336600333366006666660066666600
-- 077:0066666000666366006633330066333300663333000633330066666600666666
-- 078:6666660066666600336366003333660033336600633366006666600066666600
-- 080:0066666600666636000633330066333300663333006633330066666600660666
-- 081:6666660066666600333366003333660033333600633366006666600066666600
-- 083:0000003700033337033333370666666736333367363333673666666703666637
-- 084:7737eeee7737bbbb7737bbbb7737eeee7737bbbb77377eee77337bbb7733777b
-- 085:eeee7377bbbb7377bbbb7377eeee7377bbbb7377eee77377bbb73377b7773377
-- 086:7330000073303000733333307666666376333363763333637666666373666630
-- 087:0000003700033337033333370666666736333367363333673666666703666637
-- 088:7737eeee7737bbbb7737bbbb7737eeee7737bbbb77377eee77337bbb7733777b
-- 089:eeee7377bbbb7377bbbb7377eeee7377bbbb7377eee77377bbb73377b7773377
-- 090:7330000073303000733333307666666376333363763333637666666373666630
-- 091:0000666600006666000000660000006600000066000000660000007700000077
-- 092:6666000066660000660000006600000066000000660000007700000077000000
-- 093:0000666600006666000000660000006600000006000000660000007700000077
-- 094:6666000066600000660000006600000066000000660000007700000077000000
-- 096:0000000000000000000006000000066000006600000066000000666000006666
-- 097:0007000000770000006600000060000000600000006600000660000066660000
-- 099:0363363700633637007337370000333700000337000000070000000700000000
-- 100:7733377777333337773333337736666677366666773663337736633377366666
-- 101:7773337773333377333333776666637766666377333663773336637766666377
-- 102:7363363073633600737337007333300073000000700000007000000070000000
-- 103:0363363700633637007337370000333700000337000000070000000700000000
-- 104:7733377777333337773333337736666677366666773663337736633377366666
-- 105:7773337773333377333333776666637766666377333663773336637766666377
-- 106:7363363073633600737337007333300073000000700000007000000070000000
-- 112:0066666600666636000033330006333300666333006633330066666600660600
-- 113:6636600063366600333366003333660033333600633366000066600006666600
-- 115:0000000700000007000000000000000000000000000000000000000000000000
-- 116:7736666677733663077736630777766700077667000776670000066000000060
-- 117:6666637736633777366377707667777076677000766770000660000006600000
-- 118:7000000000000000000000000000000000000000000000000000000000000000
-- 119:0000000700000007000000000000000000000000000000000000000000000000
-- 120:7736666677733663077736630777766700077667000776670000066000000060
-- 121:6666637736633777366377707667777076677000766770000660000006600000
-- 122:7000000000000000000000000000000000000000000000000000000000000000
-- 128:000000000f00000000f00000000f00000000f00000000f00000000ff000000ff
-- 129:00000000000000f000000f000000f000000f000000f00000ff000000ff000000
-- 131:0000000000000000000000000000000000000000000000070000000000000007
-- 132:00060f060006f4f6006333360777777777777733777733377773377b77337bbb
-- 133:60f000006f4f600063333600777777703377777073337777b7733777b1273377
-- 134:0000000000000000000000000000000000000000700000007000000070000000
-- 135:0000000000000000000000000000000000000000000000070000000000000007
-- 136:000604060006fff6006333360777777777777733777733377773377b77337bbb
-- 137:604000006fff600063333600777777703377777073337777b7733777b1273377
-- 138:0000000000000000000000000000000000000000700000007000000070000000
-- 144:000000ff000000ff00000f000000f000000f000000f000000f00000000000000
-- 145:ff000000ff00000000f00000000f00000000f00000000f00000000f000000000
-- 147:0000003700033337033333370666366736333367363333673666666703666637
-- 148:7737eeee7737bbbb7737bbb17737ee127737bbb177377eee77337bbb7733777b
-- 149:ee127377bbb17377bbbb73771eee7377bbbb7377eee77377bbb73377b7773377
-- 150:7330000073303000733333307666666376333363763333607666666373666630
-- 151:0000003700033337033333370666366736333367363333673666666703666637
-- 152:7737eeee7737bbbb7737bbb17737ee127737bbb177377eee77337bbb7733777b
-- 153:ee127377bbb17377bbbb73771eee7377bbbb7377eee77377bbb73377b7773377
-- 154:7330000073303000733333307666666376333363763333607666666373666630
-- 163:0363363700633637007337370000333700000337000000070000000700000000
-- 164:7733377777333337773333337736663677366666773663337736633377366666
-- 165:7773337773333377333333776666637766666377333663773336637066666370
-- 166:7363363073633300737333007333300073000000700000007000000000000000
-- 167:0363363700633637007337370000333700000337000000070000000700000000
-- 168:7733377777333337773333337736663677366666773663337736633377366666
-- 169:7773337773333377333333776666637766666377333663773336637066666370
-- 170:7363363073633300737333007333300073000000700000007000000000000000
-- 179:0000000700000007000000000000000000000000000000000000000000000000
-- 180:7736666677733663077736630777766700077667000776670000066000000060
-- 181:6666337736633777366377707667777076677000767770000660000006600000
-- 182:7000000000000000000000000000000000000000000000000000000000000000
-- 183:0000000700000007000000000000000000000000000000000000000000000000
-- 184:7736666677733663077736630777766700077667000776670000066000000060
-- 185:6666337736633777366377707667777076677000767770000660000006600000
-- 186:7000000000000000000000000000000000000000000000000000000000000000
-- 195:0000000000000000000000000000000000000000000000070000000000000007
-- 196:00060f000006f4f6006333360777777777777733777733377773377b7733721b
-- 197:60f000006f4f600063333600777777003377777073337777b7733777b1273377
-- 198:0000000000000000000000000000000000000000700000000000000070000000
-- 199:0000000000000000000000000000000000000000000000070000000000000007
-- 200:000604000006fff6006333360777777777777733777733377773377b7733721b
-- 201:604000006fff600063333600777777003377777073337777b7733777b1273377
-- 202:0000000000000000000000000000000000000000700000000000000070000000
-- 211:0000003700033337033333330666366736333367363333673666666703666637
-- 212:773731ee773721bb77371bb17737ee137737bbb177377eee77337bbb7733777b
-- 213:ee137377bbb17377bbbb73771ee17377bb127377e13773771227337717773377
-- 214:7330000073303000733333307666666337333363763333607663666073666630
-- 215:0000003700033337033333330666366736333367363333673666666703666637
-- 216:773731ee773721bb77371bb17737ee137737bbb177377eee77337bbb7733777b
-- 217:ee137377bbb17377bbbb73771ee17377bb127377e13773771227337717773377
-- 218:7330000073303000733333307666666337333363763333607663666073666630
-- 227:0363363700633637007337370000333700000333000000070000000700000000
-- 228:7733377777333337773333337336663677366666773663337736633377366666
-- 229:7773337773333377333333776666637766666377333663773336637066666370
-- 230:7363363073633300737333007333300073000000700000007000000000000000
-- 231:0363363700633637007337370000333700000333000000070000000700000000
-- 232:7733377777333337773333337336663677366666773663337736633377366666
-- 233:7773337773333377333333776666637766666377333663773336637066666370
-- 234:7363363073633300737333007333300073000000700000007000000000000000
-- 243:0000000000000007000000000000000000000000000000000000000000000000
-- 244:7736666677733663077736630077766700077667000776670000066000000060
-- 245:6666337736633777366377707667777076677000767770000660000006600000
-- 246:7000000000000000000000000000000000000000000000000000000000000000
-- 247:0000000000000007000000000000000000000000000000000000000000000000
-- 248:7736666677733663077736630077766700077667000776670000066000000060
-- 249:6666337736633777366377707667777076677000767770000660000006600000
-- 250:7000000000000000000000000000000000000000000000000000000000000000
-- </SPRITES>

-- <MAP>
-- 000:000000000000000606060600000000000000000000000000000000000000000000000000000606060600000000000000000000000000000000000000000000000000000606060600000000000000000000000000000000000000000000000000000606060600000000000000000000000000000000000000000000000000000606060600000000000000000000000000000000000000000000000000000606060600000000000000000000000000000000000000000000000000000606060600000000000000000000000000000000000000000000000000000606060600000000000000000000000000000000000000
-- 001:060000000000000606060000000000000005000000000000000000050000060000000000000606060000000000000005000000000000000000050000060000000000000606060000000000000005000000000000000000050000060000000000000606060000000000000005000000000000000000050000060000000000000606060000000000000005000000000000000000050000060000000000000606060000000000000005000000000000000000050000060000000000000606060000000000000005000000000000000000050000060000000000000606060000000000000005000000000000000000050000
-- 002:060600050000000006060500000000000000000000000000000000000000060600050000000006060500000000000000000000000000000000000000060600050000000006060500000000000000000000000000000000000000060600050000000006060500000000000000000000000000000000000000060600050000000006060500000000000000000000000000000000000000060600050000000006060500000000000000000000000000000000000000060600050000000006060500000000000000000000000000000000000000060600050000000006060500000000000000000000000000000000000000
-- 003:060606060000000006000000000000060000000000000000000000000000060606060000000006000000000000060000000000000000000000000000060606060000000006000000000000060000000000000000000000000000060606060000000006000000000000060000000000000000000000000000060606060000000006000000000000060000000000000000000000000000060606060000000006000000000000060000000000000000000000000000060606060000000006000000000000060000000000000000000000000000060606060000000006000000000000060000000000000000000000000000
-- 004:060606000000000000000000000000000000000000060000000500000000060606000000000000000000000000000000000000060000000500000000060606000000000000000000000000000000000000060000000500000000060606000000000000000000000000000000000000060000000500000000060606000000000000000000000000000000000000060000000500000000060606000000000000000000000000000000000000060000000500000000060606000000000000000000000000000000000000060000000500000000060606000000000000000000000000000000000000060000000500000000
-- 005:0606060000000600000b07080808090a00000000000000000000000000000606060000000600000b07080808090a00000000000000000000000000000606060000000600000b07080808090a00000000000000000000000000000606060000000600000b07080808090a00000000000000000000000000000606060000000600000b07080808090a00000000000000000000000000000606060000000600000b07080808090a00000000000000000000000000000606060000000600000b07080808090a00000000000000000000000000000606060000000600000b07080808090a0000000000000000000000000000
-- 006:060600000000000000000000000005000000000000000000000000000000060600000000000000000000000005000000000000000000000000000000060600000000000000000000000005000000000000000000000000000000060600000000000000000000000005000000000000000000000000000000060600000000000000000000000005000000000000000000000000000000060600000000000000000000000005000000000000000000000000000000060600000000000000000000000005000000000000000000000000000000060600000000000000000000000005000000000000000000000000000000
-- 007:060000000500000000000000000000000000000000000000000000000000060000000500000000000000000000000000000000000000000000000000060000000500000000000000000000000000000000000000000000000000060000000500000000000000000000000000000000000000000000000000060000000500000000000000000000000000000000000000000000000000060000000500000000000000000000000000000000000000000000000000060000000500000000000000000000000000000000000000000000000000060000000500000000000000000000000000000000000000000000000000
-- 008:000000000006060600050000000000000000000000000000000000000600000000000006060600050000000000000000000000000000000000000600000000000006060600050000000000000000000000000000000000000600000000000006060600050000000000000000000000000000000000000600000000000006060600050000000000000000000000000000000000000600000000000006060600050000000000000000000000000000000000000600000000000006060600050000000000000000000000000000000000000600000000000006060600050000000000000000000000000000000000000600
-- 009:00000000060606060000000000000000000b0708090a000000000000000000000000060606060000000000000000000b0708090a000000000000000000000000060606060000000000000000000b0708090a000000000000000000000000060606060000000000000000000b0708090a000000000000000000000000060606060000000000000000000b0708090a000000000000000000000000060606060000000000000000000b0708090a000000000000000000000000060606060000000000000000000b0708090a000000000000000000000000060606060000000000000000000b0708090a0000000000000000
-- 010:000000060606060000000000060000000005000000000500000000000000000000060606060000000000060000000005000000000500000000000000000000060606060000000000060000000005000000000500000000000000000000060606060000000000060000000005000000000500000000000000000000060606060000000000060000000005000000000500000000000000000000060606060000000000060000000005000000000500000000000000000000060606060000000000060000000005000000000500000000000000000000060606060000000000060000000005000000000500000000000000
-- 011:000600000606060000000000000000000000000000000000000000000000000600000606060000000000000000000000000000000000000000000000000600000606060000000000000000000000000000000000000000000000000600000606060000000000000000000000000000000000000000000000000600000606060000000000000000000000000000000000000000000000000600000606060000000000000000000000000000000000000000000000000600000606060000000000000000000000000000000000000000000000000600000606060000000000000000000000000000000000000000000000
-- 012:000000000006000500000000000000000000000000000606060000000500000000000006000500000000000000000000000000000606060000000500000000000006000500000000000000000000000000000606060000000500000000000006000500000000000000000000000000000606060000000500000000000006000500000000000000000000000000000606060000000500000000000006000500000000000000000000000000000606060000000500000000000006000500000000000000000000000000000606060000000500000000000006000500000000000000000000000000000606060000000500
-- 013:00000000000000000b0a000000050000000000000606060606000000000000000000000000000b0a000000050000000000000606060606000000000000000000000000000b0a000000050000000000000606060606000000000000000000000000000b0a000000050000000000000606060606000000000000000000000000000b0a000000050000000000000606060606000000000000000000000000000b0a000000050000000000000606060606000000000000000000000000000b0a000000050000000000000606060606000000000000000000000000000b0a0000000500000000000006060606060000000000
-- 014:000000000000000000000000000000000000000606060606060600000000000000000000000000000000000000000000000606060606060600000000000000000000000000000000000000000000000606060606060600000000000000000000000000000000000000000000000606060606060600000000000000000000000000000000000000000000000606060606060600000000000000000000000000000000000000000000000606060606060600000000000000000000000000000000000000000000000606060606060600000000000000000000000000000000000000000000000606060606060600000000
-- 015:0101020101020101020101020101020101020101020101020101020101020c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e8c8c9e00000000009c00000000009c0000009c0000000000000000008c8c
-- 016:0303040303040303040303040303040303040303040303040303040303044c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e8d8d000000000000009d00000000009d0000009d000000000000008e8d8d
-- 017:000000000000000005000000000600000000000000000000000000000000000000000000000005000000000600000000000000000000000000000000000000000000000005000000000600000000000000000000000000000000000000000000000005000000000600000000000000000000000000000000000000000000000005000000000600000000000000000000000000000000000000000000000005000000000600000000000000000000000000000000000000000000000005000000000600000000000000000000000000000000000000000000000005000000000600000000000000000000000000000000
-- 018:000000000000000000000000060606000000000000000000000000000000000000000000000000000000060606000000000000000000000000000000000000000000000000000000060606000000000000000000000000000000000000000000000000000000060606000000000000000000000000000000000000000000000000000000060606000000000000000000000000000000000000000000000000000000060606000000000000000000000000000000000000000000000000000000060606000000000000000000000000000000000000000000000000000000060606000000000000000000000000000000
-- 019:000000000000000000000000060606060600000000000000000500000000000000000000000000000000060606060600000000000000000500000000000000000000000000000000060606060600000000000000000500000000000000000000000000000000060606060600000000000000000500000000000000000000000000000000060606060600000000000000000500000000000000000000000000000000060606060600000000000000000500000000000000000000000000000000060606060600000000000000000500000000000000000000000000000000060606060600000000000000000500000000
-- 020:050000000000000000000000000606060606000000000000060606000000050000000000000000000000000606060606000000000000060606000000050000000000000000000000000606060606000000000000060606000000050000000000000000000000000606060606000000000000060606000000050000000000000000000000000606060606000000000000060606000000050000000000000000000000000606060606000000000000060606000000050000000000000000000000000606060606000000000000060606000000050000000000000000000000000606060606000000000000060606000000
-- 021:000000000000000000000000000006060606000000000606060606060000000000000000000000000000000006060606000000000606060606060000000000000000000000000000000006060606000000000606060606060000000000000000000000000000000006060606000000000606060606060000000000000000000000000000000006060606000000000606060606060000000000000000000000000000000006060606000000000606060606060000000000000000000000000000000006060606000000000606060606060000000000000000000000000000000006060606000000000606060606060000
-- 022:0000000b07080808080808090a00000606000000000000060606060606000000000b07080808080808090a00000606000000000000060606060606000000000b07080808080808090a00000606000000000000060606060606000000000b07080808080808090a00000606000000000000060606060606000000000b07080808080808090a00000606000000000000060606060606000000000b07080808080808090a00000606000000000000060606060606000000000b07080808080808090a00000606000000000000060606060606000000000b07080808080808090a0000060600000000000006060606060600
-- 023:000000000000000000000000000000000000000000000000060606060606000000000000000000000000000000000000000000000000060606060606000000000000000000000000000000000000000000000000060606060606000000000000000000000000000000000000000000000000060606060606000000000000000000000000000000000000000000000000060606060606000000000000000000000000000000000000000000000000060606060606000000000000000000000000000000000000000000000000060606060606000000000000000000000000000000000000000000000000060606060606
-- 024:000000000000000500000000000000000000000000000000000606000000000000000000000500000000000000000000000000000000000606000000000000000000000500000000000000000000000000000000000606000000000000000000000500000000000000000000000000000000000606000000000000000000000500000000000000000000000000000000000606000000000000000000000500000000000000000000000000000000000606000000000000000000000500000000000000000000000000000000000606000000000000000000000500000000000000000000000000000000000606000000
-- 025:0000acacac06000000000000bcbcbc00000000000000cccccc00000000000000acacac06000000000000bcbcbc00000000000000cccccc00000000000000acacac06000000000000bcbcbc00000000000000cccccc00000000000000acacac06000000000000bcbcbc00000000000000cccccc00000000000000acacac06000000000000bcbcbc00000000000000cccccc00000000000000acacac06000000000000bcbcbc00000000000000cccccc00000000000000acacac06000000000000bcbcbc00000000000000cccccc00000000000000acacac06000000000000bcbcbc00000000000000cccccc0000000000
-- 026:0000adadad06060000000000bdbdbd00000000000000cdcdcd00000000000000adadad06060000000000bdbdbd00000000000000cdcdcd00000000000000adadad06060000000000bdbdbd00000000000000cdcdcd00000000000000adadad06060000000000bdbdbd00000000000000cdcdcd00000000000000adadad06060000000000bdbdbd00000000000000cdcdcd00000000000000adadad06060000000000bdbdbd00000000000000cdcdcd00000000000000adadad06060000000000bdbdbd00000000000000cdcdcd00000000000000adadad06060000000000bdbdbd00000000000000cdcdcd0000000000
-- 027:000000060606060600000000000000000000000000000000000000000000000000060606060600000000000000000000000000000000000000000000000000060606060600000000000000000000000000000000000000000000000000060606060600000000000000000000000000000000000000000000000000060606060600000000000000000000000000000000000000000000000000060606060600000000000000000000000000000000000000000000000000060606060600000000000000000000000000000000000000000000000000060606060600000000000000000000000000000000000000000000
-- 028:000000060606060000000000050000000000000000000000000500000000000000060606060000000000050000000000000000000000000500000000000000060606060000000000050000000000000000000000000500000000000000060606060000000000050000000000000000000000000500000000000000060606060000000000050000000000000000000000000500000000000000060606060000000000050000000000000000000000000500000000000000060606060000000000050000000000000000000000000500000000000000060606060000000000050000000000000000000000000500000000
-- 029:000000000000000000000000000000000006060605000000000000000000000000000000000000000000000000000006060605000000000000000000000000000000000000000000000000000006060605000000000000000000000000000000000000000000000000000006060605000000000000000000000000000000000000000000000000000006060605000000000000000000000000000000000000000000000000000006060605000000000000000000000000000000000000000000000000000006060605000000000000000000000000000000000000000000000000000006060605000000000000000000
-- 030:000500000000000000000000000000000606060606000000000000000000000500000000000000000000000000000606060606000000000000000000000500000000000000000000000000000606060606000000000000000000000500000000000000000000000000000606060606000000000000000000000500000000000000000000000000000606060606000000000000000000000500000000000000000000000000000606060606000000000000000000000500000000000000000000000000000606060606000000000000000000000500000000000000000000000000000606060606000000000000000000
-- 031:000000000000000000000000000000060606060606000000000000000005000000000000000000000000000000060606060606000000000000000005000000000000000000000000000000060606060606000000000000000005000000000000000000000000000000060606060606000000000000000005000000000000000000000000000000060606060606000000000000000005000000000000000000000000000000060606060606000000000000000005000000000000000000000000000000060606060606000000000000000005000000000000000000000000000000060606060606000000000000000005
-- 032:0101020101020101020101020101020101020101020101020101020101020c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e8c8c9e00000000009c00000000009c0000009c0000000000000000008c8c
-- 033:0303040303040303040303040303040303040303040303040303040303044c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e8d8d000000000000009d00000000009d0000009d000000000000008e8d8d
-- 034:000000000500000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000
-- 035:000000000006060600000000000000000000000000000000050000000500000000000006060600000000000000000000000000000000050000000500000000000006060600000000000000000000000000000000050000000500000000000006060600000000000000000000000000000000050000000500000000000006060600000000000000000000000000000000050000000500000000000006060600000000000000000000000000000000050000000500000000000006060600000000000000000000000000000000050000000500000000000006060600000000000000000000000000000000050000000500
-- 036:000000000006060606000000dcdcdcdcdcdcdc0606000000000000000000000000000006060606000000dcdcdcdcdcdcdc0606000000000000000000000000000006060606000000dcdcdcdcdcdcdc0606000000000000000000000000000006060606000000dcdcdcdcdcdcdc0606000000000000000000000000000006060606000000dcdcdcdcdcdcdc0606000000000000000000000000000006060606000000dcdcdcdcdcdcdc0606000000000000000000000000000006060606000000dcdcdcdcdcdcdc0606000000000000000000000000000006060606000000dcdcdcdcdcdcdc0606000000000000000000
-- 037:000000000000060606060000dddddddddddddd0606060000000000000000000000000000060606060000dddddddddddddd0606060000000000000000000000000000060606060000dddddddddddddd0606060000000000000000000000000000060606060000dddddddddddddd0606060000000000000000000000000000060606060000dddddddddddddd0606060000000000000000000000000000060606060000dddddddddddddd0606060000000000000000000000000000060606060000dddddddddddddd0606060000000000000000000000000000060606060000dddddddddddddd0606060000000000000000
-- 038:000000050000000006060000000606060606060606000000000000000000000000050000000006060000000606060606060606000000000000000000000000050000000006060000000606060606060606000000000000000000000000050000000006060000000606060606060606000000000000000000000000050000000006060000000606060606060606000000000000000000000000050000000006060000000606060606060606000000000000000000000000050000000006060000000606060606060606000000000000000000000000050000000006060000000606060606060606000000000000000000
-- 039:000000000000000000000000000006060606060606000000000000000000000000000000000000000000000006060606060606000000000000000000000000000000000000000000000006060606060606000000000000000000000000000000000000000000000006060606060606000000000000000000000000000000000000000000000006060606060606000000000000000000000000000000000000000000000006060606060606000000000000000000000000000000000000000000000006060606060606000000000000000000000000000000000000000000000006060606060606000000000000000000
-- 040:000000bcbcbcbcbcbcbc0000000000060606060600cccccccccccc000000000000bcbcbcbcbcbcbc0000000000060606060600cccccccccccc000000000000bcbcbcbcbcbcbc0000000000060606060600cccccccccccc000000000000bcbcbcbcbcbcbc0000000000060606060600cccccccccccc000000000000bcbcbcbcbcbcbc0000000000060606060600cccccccccccc000000000000bcbcbcbcbcbcbc0000000000060606060600cccccccccccc000000000000bcbcbcbcbcbcbc0000000000060606060600cccccccccccc000000000000bcbcbcbcbcbcbc0000000000060606060600cccccccccccc000000
-- 041:050000bdbdbdbdbdbdbd0000000000000606060600cdcdcdcdcdcd000000050000bdbdbdbdbdbdbd0000000000000606060600cdcdcdcdcdcd000000050000bdbdbdbdbdbdbd0000000000000606060600cdcdcdcdcdcd000000050000bdbdbdbdbdbdbd0000000000000606060600cdcdcdcdcdcd000000050000bdbdbdbdbdbdbd0000000000000606060600cdcdcdcdcdcd000000050000bdbdbdbdbdbdbd0000000000000606060600cdcdcdcdcdcd000000050000bdbdbdbdbdbdbd0000000000000606060600cdcdcdcdcdcd000000050000bdbdbdbdbdbdbd0000000000000606060600cdcdcdcdcdcd000000
-- 042:000006000000000000000000050000000006060000000000000000000000000006000000000000000000050000000006060000000000000000000000000006000000000000000000050000000006060000000000000000000000000006000000000000000000050000000006060000000000000000000000000006000000000000000000050000000006060000000000000000000000000006000000000000000000050000000006060000000000000000000000000006000000000000000000050000000006060000000000000000000000000006000000000000000000050000000006060000000000000000000000
-- 043:000606060000000000000000000000000000000000000000000000000005000606060000000000000000000000000000000000000000000000000005000606060000000000000000000000000000000000000000000000000005000606060000000000000000000000000000000000000000000000000005000606060000000000000000000000000000000000000000000000000005000606060000000000000000000000000000000000000000000000000005000606060000000000000000000000000000000000000000000000000005000606060000000000000000000000000000000000000000000000000005
-- 044:060606060600000500000000acacacacacacac0000050000000000000000060606060600000500000000acacacacacacac0000050000000000000000060606060600000500000000acacacacacacac0000050000000000000000060606060600000500000000acacacacacacac0000050000000000000000060606060600000500000000acacacacacacac0000050000000000000000060606060600000500000000acacacacacacac0000050000000000000000060606060600000500000000acacacacacacac0000050000000000000000060606060600000500000000acacacacacacac0000050000000000000000
-- 045:060606060606000006060000adadadadadadad0000000000000600000000060606060606000006060000adadadadadadad0000000000000600000000060606060606000006060000adadadadadadad0000000000000600000000060606060606000006060000adadadadadadad0000000000000600000000060606060606000006060000adadadadadadad0000000000000600000000060606060606000006060000adadadadadadad0000000000000600000000060606060606000006060000adadadadadadad0000000000000600000000060606060606000006060000adadadadadadad0000000000000600000000
-- 046:000606060606060006060606000000000000000000000000060606060000000606060606060006060606000000000000000000000000060606060000000606060606060006060606000000000000000000000000060606060000000606060606060006060606000000000000000000000000060606060000000606060606060006060606000000000000000000000000060606060000000606060606060006060606000000000000000000000000060606060000000606060606060006060606000000000000000000000000060606060000000606060606060006060606000000000000000000000000060606060000
-- 047:000006060606000000060606060000000000000000000006060606060600000006060606000000060606060000000000000000000006060606060600000006060606000000060606060000000000000000000006060606060600000006060606000000060606060000000000000000000006060606060600000006060606000000060606060000000000000000000006060606060600000006060606000000060606060000000000000000000006060606060600000006060606000000060606060000000000000000000006060606060600000006060606000000060606060000000000000000000006060606060600
-- 048:000000060600000000000606060600000000050000000006060606060600000000060600000000000606060600000000050000000006060606060600000000060600000000000606060600000000050000000006060606060600000000060600000000000606060600000000050000000006060606060600000000060600000000000606060600000000050000000006060606060600000000060600000000000606060600000000050000000006060606060600000000060600000000000606060600000000050000000006060606060600000000060600000000000606060600000000050000000006060606060600
-- 049:0101020101020101020101020101020101020101020101020101020101020c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e8c8c9e00000000009c00000000009c0000009c0000000000000000008c8c
-- 050:0303040303040303040303040303040303040303040303040303040303044c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e8d8d000000000000009d00000000009d0000009d000000000000008e8d8d
-- 051:000000000000000000000606060600000000000000000000000006060606000000000000000000000606060600000000000000000000000006060606000000000000000000000606060600000000000000000000000006060606000000000000000000000606060600000000000000000000000006060606000000000000000000000606060600000000000000000000000006060606000000000000000000000606060600000000000000000000000006060606000000000000000000000606060600000000000000000000000006060606000000000000000000000606060600000000000000000000000006060606
-- 052:000000bcbcbcbcbc00000606060600000000000000000000000006060606000000bcbcbcbcbc00000606060600000000000000000000000006060606000000bcbcbcbcbc00000606060600000000000000000000000006060606000000bcbcbcbcbc00000606060600000000000000000000000006060606000000bcbcbcbcbc00000606060600000000000000000000000006060606000000bcbcbcbcbc00000606060600000000000000000000000006060606000000bcbcbcbcbc00000606060600000000000000000000000006060606000000bcbcbcbcbc00000606060600000000000000000000000006060606
-- 053:000000bdbdbdbdbd000000060606060000acacacac000000000006060606000000bdbdbdbdbd000000060606060000acacacac000000000006060606000000bdbdbdbdbd000000060606060000acacacac000000000006060606000000bdbdbdbdbd000000060606060000acacacac000000000006060606000000bdbdbdbdbd000000060606060000acacacac000000000006060606000000bdbdbdbdbd000000060606060000acacacac000000000006060606000000bdbdbdbdbd000000060606060000acacacac000000000006060606000000bdbdbdbdbd000000060606060000acacacac000000000006060606
-- 054:0606000000000000000000000006000000adadadad0000000000000006060606000000000000000000000006000000adadadad0000000000000006060606000000000000000000000006000000adadadad0000000000000006060606000000000000000000000006000000adadadad0000000000000006060606000000000000000000000006000000adadadad0000000000000006060606000000000000000000000006000000adadadad0000000000000006060606000000000000000000000006000000adadadad0000000000000006060606000000000000000000000006000000adadadad000000000000000606
-- 055:060606060000000000000000000000000000000000060600000000000000060606060000000000000000000000000000000000060600000000000000060606060000000000000000000000000000000000060600000000000000060606060000000000000000000000000000000000060600000000000000060606060000000000000000000000000000000000060600000000000000060606060000000000000000000000000000000000060600000000000000060606060000000000000000000000000000000000060600000000000000060606060000000000000000000000000000000000060600000000000000
-- 056:00060606060000cccccccccccc0000bcbcbc00000606060600000000000000060606060000cccccccccccc0000bcbcbc00000606060600000000000000060606060000cccccccccccc0000bcbcbc00000606060600000000000000060606060000cccccccccccc0000bcbcbc00000606060600000000000000060606060000cccccccccccc0000bcbcbc00000606060600000000000000060606060000cccccccccccc0000bcbcbc00000606060600000000000000060606060000cccccccccccc0000bcbcbc00000606060600000000000000060606060000cccccccccccc0000bcbcbc000006060606000000000000
-- 057:00060606060000cdcdcdcdcdcd0000bdbdbd00060606060606000000000000060606060000cdcdcdcdcdcd0000bdbdbd00060606060606000000000000060606060000cdcdcdcdcdcd0000bdbdbd00060606060606000000000000060606060000cdcdcdcdcdcd0000bdbdbd00060606060606000000000000060606060000cdcdcdcdcdcd0000bdbdbd00060606060606000000000000060606060000cdcdcdcdcdcd0000bdbdbd00060606060606000000000000060606060000cdcdcdcdcdcd0000bdbdbd00060606060606000000000000060606060000cdcdcdcdcdcd0000bdbdbd000606060606060000000000
-- 058:000606060600000000000000000000000000000606dcdcdcdcdc00000000000606060600000000000000000000000000000606dcdcdcdcdc00000000000606060600000000000000000000000000000606dcdcdcdcdc00000000000606060600000000000000000000000000000606dcdcdcdcdc00000000000606060600000000000000000000000000000606dcdcdcdcdc00000000000606060600000000000000000000000000000606dcdcdcdcdc00000000000606060600000000000000000000000000000606dcdcdcdcdc00000000000606060600000000000000000000000000000606dcdcdcdcdc00000000
-- 059:0000060600acacacacacac00000000000000000006dddddddddd000000000000060600acacacacacac00000000000000000006dddddddddd000000000000060600acacacacacac00000000000000000006dddddddddd000000000000060600acacacacacac00000000000000000006dddddddddd000000000000060600acacacacacac00000000000000000006dddddddddd000000000000060600acacacacacac00000000000000000006dddddddddd000000000000060600acacacacacac00000000000000000006dddddddddd000000000000060600acacacacacac00000000000000000006dddddddddd00000000
-- 060:0000000000adadadadadad000000000000000000000000000000000000000000000000adadadadadad000000000000000000000000000000000000000000000000adadadadadad000000000000000000000000000000000000000000000000adadadadadad000000000000000000000000000000000000000000000000adadadadadad000000000000000000000000000000000000000000000000adadadadadad000000000000000000000000000000000000000000000000adadadadadad000000000000000000000000000000000000000000000000adadadadadad00000000000000000000000000000000000000
-- 061:000000000000000000000000000000060606000000000000000000000000000000000000000000000000000000060606000000000000000000000000000000000000000000000000000000060606000000000000000000000000000000000000000000000000000000060606000000000000000000000000000000000000000000000000000000060606000000000000000000000000000000000000000000000000000000060606000000000000000000000000000000000000000000000000000000060606000000000000000000000000000000000000000000000000000000060606000000000000000000000000
-- 062:000606000000000000dcdcdcdcdc06060606060000cccccccccccc000000000606000000000000dcdcdcdcdc06060606060000cccccccccccc000000000606000000000000dcdcdcdcdc06060606060000cccccccccccc000000000606000000000000dcdcdcdcdc06060606060000cccccccccccc000000000606000000000000dcdcdcdcdc06060606060000cccccccccccc000000000606000000000000dcdcdcdcdc06060606060000cccccccccccc000000000606000000000000dcdcdcdcdc06060606060000cccccccccccc000000000606000000000000dcdcdcdcdc06060606060000cccccccccccc000000
-- 063:060606060000000000dddddddddd06060606060600cdcdcdcdcdcd000000060606060000000000dddddddddd06060606060600cdcdcdcdcdcd000000060606060000000000dddddddddd06060606060600cdcdcdcdcdcd000000060606060000000000dddddddddd06060606060600cdcdcdcdcdcd000000060606060000000000dddddddddd06060606060600cdcdcdcdcdcd000000060606060000000000dddddddddd06060606060600cdcdcdcdcdcd000000060606060000000000dddddddddd06060606060600cdcdcdcdcdcd000000060606060000000000dddddddddd06060606060600cdcdcdcdcdcd000000
-- 064:060606060000000000000006060606060606060606060000000000000000060606060000000000000006060606060606060606060000000000000000060606060000000000000006060606060606060606060000000000000000060606060000000000000006060606060606060606060000000000000000060606060000000000000006060606060606060606060000000000000000060606060000000000000006060606060606060606060000000000000000060606060000000000000006060606060606060606060000000000000000060606060000000000000006060606060606060606060000000000000000
-- 065:000606060600000000000606060606060606060606060606000000000000000606060600000000000606060606060606060606060606000000000000000606060600000000000606060606060606060606060606000000000000000606060600000000000606060606060606060606060606000000000000000606060600000000000606060606060606060606060606000000000000000606060600000000000606060606060606060606060606000000000000000606060600000000000606060606060606060606060606000000000000000606060600000000000606060606060606060606060606000000000000
-- 066:0101020101020101020101020101020101020101020101020101020101020c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e8c8c9e00000000009c00000000009c0000009c0000000000000000008c8c
-- 067:0303040303040303040303040303040303040303040303040303040303044c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e8d8d000000000000009d00000000009d0000009d000000000000008e8d8d
-- 083:0101020101020101020101020101020101020101020101020101020101020c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e8c8c9e00000000009c00000000009c0000009c0000000000000000008c8c
-- 084:0303040303040303040303040303040303040303040303040303040303044c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e8d8d000000000000009d00000000009d0000009d000000000000008e8d8d
-- 100:0101020101020101020101020101020101020101020101020101020101020c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e8c8c9e00000000009c00000000009c0000009c0000000000000000008c8c
-- 101:0303040303040303040303040303040303040303040303040303040303044c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e8d8d000000000000009d00000000009d0000009d000000000000008e8d8d
-- 117:0101020101020101020101020101020101020101020101020101020101020c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0c0c1c0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0d0d1d0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e0e0e1e2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2c2c3c2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2d2d3d2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e2e2e3e8c8c9e00000000009c00000000009c0000009c0000000000000000008c8c
-- 118:0303040303040303040303040303040303040303040303040303040303044c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4c4c5c4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4d4d5d4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e4e4e5e6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6c6c7c6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6d6d7d6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e6e6e7e8d8d000000000000009d00000000009d0000009d000000000000008e8d8d
-- 119:dfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 120:dfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 121:dfdfdfdfdfdfdfdfdfdfdfdfdfeefecf9fcedfdfdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 122:dfdfdfdfdfdfdfdfdfdfae4f4f4f4f4f4f4f4f7fdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 123:dfdfdfdfdfdfdfdfdfdfbe4fdf5f5f5f5fdf4f8fdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 124:dfdfdfdfdfdfdfdfdfdfce4f5f5fdfdf5f5f4f9fdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 125:dfdfdfdfdfdfdfdfdfdfbf4f5fdf6fdf6f5f4fafdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 126:dfdfdfdfdfdfdfdfdfdf7f4f5fdfdfdfdf5f4fbfdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 127:dfdfdfdfdfdfdfdfdfdf8f4f5f5f5f5f5f5f5fcfdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 128:dfdfdfdfdfdfdfdfdfdfbf4f5f5f5f5f5f5f4f7fdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 129:dfdfdfdfdfdfdfdfdfdfde4f5f4f4f4f4f4f4fefdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 130:dfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 131:dfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 132:dfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 133:dfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 134:dfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 135:dfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:012345543210cdeffedc012345543210
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000600030002000f000af009f009f009f008f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000c00000000000
-- 001:1307130523032301330f330d430b43095308530063006300730073008300830093009300a300a300b300b300c300c300d300d300e300e300f300f300c00000000009
-- 002:03000300f30003000300f30003000300f30003000300f30003000300f30003000300f30003000300f30003000300f30003000300f30003000300f300407000000000
-- 003:00f800f7f0e8f0e7f0d820d720c0f0c0f0b0f0b040a040a0f090f09060806080f070f07080608060f050f050a040a040f030f030c020c020f010f010b77000000006
-- </SFX>

-- <PALETTE>
-- 000:000000bcb19f847f7f5a5a63cead73a5845a3e3d4c21263f6b7b393a533984ad424063b26c4f40673347394071c0461f
-- </PALETTE>

