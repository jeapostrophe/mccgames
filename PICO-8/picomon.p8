pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- pico monsters

-- by headchant 2016

-- credits
-- fade to black effect innomin http://www.lexaloffle.com/bbs/?tid=2467

local montypes = {
	"swooty",
	"piggy",
	"groldo",
	"feuxdino",
	"watawamp",
	"rowpim",
	"buzzcor",
	"purbirb",
	"tinkerelle",
	"boberl",
	"plaradi",
	"hatcell",
	"mogmine",
	"crub",
	"flipa",
	"sneg",
	"pilo",
	"limegoo",
	"dogshade",
	"pukesun",
	"huevo"
}

local elementalsprites = {
	air = 121,
	fire = 122,
	earth = 123,
	water = 124
}

local intypes = {}
local k = 0
for v in all(montypes) do
	k+=1
	intypes[v] = k
end

local newMonster = function(element, hp, attack, defense, speed, spr)
	return {
		element = element,
		hp = hp,
		attack = attack,
		defense = defense,
		speed = speed,
		spr = spr
	}
end

-- base stats
local monstats = {
	swooty = newMonster(
		"air", 65, 63, 75, 45, 74),
	piggy = newMonster(
		"earth",
		25,
		55,
		50,
		20,
		73
	),
	groldo = newMonster(
		"earth",
		60,
		55,
		50,
		20,
		75
	),
	feuxdino = newMonster(
		"fire",
		35,
		55,
		50,
		20,
		76
	),
	watawamp = newMonster(
		"air",
		30,
		40,
		70,
		20,
		77
	),
	rowpim = newMonster(
		"earth",
		45,
		5,
		60,
		20,
		78
	),
	buzzcor = newMonster(
		"air",
		45,
		55,
		50,
		20,
		79
	),
	purbirb = newMonster(
		"air",
		45,
		55,
		50,
		20,
		89
	),
	tinkerelle = newMonster(
		"earth",
		45,
		55,
		50,
		20,
		90
	),
	boberl = newMonster(
		"earth",
		100,
		5,
		15,
		20,
		91
	),
	plaradi = newMonster(
		"earth",
		75,
		55,
		50,
		20,
		92
	),
	hatcell = newMonster(
		"earth",
		95,
		55,
		50,
		20,
		93
	),
	mogmine = newMonster(
		"fire",
		110,
		25,
		50,
		20,
		94
	),
	crub = newMonster(
		"water",
		62,
		55,
		50,
		20,
		95
	),
	flipa = newMonster(
		"earth",
		88,
		55,
		50,
		20,
		105
	),
	sneg = newMonster(
		"earth",
		25,
		55,
		50,
		20,
		106
	),
	pilo = newMonster(
		"earth",
		15,
		25,
		80,
		20,
		107
	),
	limegoo = newMonster(
		"water",
		78,
		22,
		25,
		40,
		108
	),
	dogshade = newMonster(
		"air",
		45,
		55,
		50,
		60,
		109
	),
	pukesun = newMonster(
		"fire",
		25,
		95,
		5,
		100,
		110
	),
	huevo = newMonster(
		"air",
		99,
		25,
		55,
		5,
		111
	),
}

local items = {
	"potion",
	"picoball",
	"smokeball",
	"garden key",
	"swim suit",
	"apple",
	"hammer",
	"running shoes",
	"candy",
	"resurrect"
}


local effe = 1
effectness = {
	["water:fire"] = 2,
	-- ["water:earth"] = 1,
	-- ["water:air"] = 1,
	["fire:earth"] = 2,
	["fire:air"] = 2,
	-- ["fire:water"] = 1,
	-- ["earth:air"] = 1,
	-- ["earth:water"] = 1,
	-- ["earth:fire"] = 1,
	["air:water"] = 2,
	-- ["air:earth"] = 1,
	-- ["air:fire"] = 1,
}

local starter = "swooty"
local lvl = 2
local startermon = {
	name = starter,
	type = starter,
	level = lvl,
	maxhp = flr((monstats[starter].hp*2*lvl/100)+lvl+10),
	curhp = flr((monstats[starter].hp*2*lvl/100)+lvl+10),
	speed = flr((monstats[starter].speed*2*lvl/100)+lvl+10),
	defense = flr((monstats[starter].defense*2*lvl/100)+lvl+10),
	attack = flr((monstats[starter].attack*2*lvl/100)+lvl+10),
	xp = 0,
	move1 = "tackle",
	move2 = "leer",
	move3 = nil,
	move4 = nil,
}

local attack = function(target, from, done, base, name)
	if rnd() > movesstats[name].acc then
		text(from.name.." missed!", done)
		return
	end
	local base = base or 15
	local dmg = ((2*from.level+10)/250) * (from.attack/target.defense)*base + 2
	local eff = (effectness[monstats[from.name].element..":"..monstats[target.name].element] or 1)
	dmg = dmg * eff
	-- crit
	local crit
	if rnd() < from.speed/512 then
		dmg = dmg * 2
		crit = true
	end
	dmg = dmg * (0.85 + rnd(0.15))

	target.curhp -= dmg
	target.curhp = max(0, flr(target.curhp+0.5))
	sfx(38,0)
	if from == dialog.battle.monsters[1] then
		add(funcs, {
			t = 4,
			update = function(self)
				self.t-=1
				dialog.battle.p.x = rnd()*4
				dialog.battle.p.y = rnd()*4
				if self.t<= 0 then
					del(funcs, self)
				end
			end,
			draw = function() end
		})
	else
		add(funcs, {
			t = 4,
			update = function(self)
				self.t-=1
				dialog.battle.e.x = rnd()*4
				dialog.battle.e.y = rnd()*4
				if self.t<= 0 then
					del(funcs, self)
				end
			end,
			draw = function() end
		})
	end
	if eff > 1 then
		text(from.name.." used "..name.."!", function()
			text("it's very effective!", done)
		end)
	elseif crit then
		text(from.name.." used "..name.."!", function()
			text("a critical hit!", done)
		end)
	else
		text(from.name.." used "..name.."!", done)
	end
end

moves = {
	scratch = function(target, from, done, base)
		attack(target, from, done, base,"scratch")
	end,
	tackle = function(target, from, done, base)
		attack(target, from, done, base,"tackle")
	end,
	rage = function(target, from, done, base)
		attack(target, from, done, 40,"rage")
	end,
	burn = function(target, from, done, base)
		attack(target, from, done, 50,"burn")
	end,
	leer = function(target, from, done)
		local name = "leer"
		text(from.name.." used "..name.."!", function()
			target.defense-=1
			target.defense=max(1,target.defense)
			text("lowered "..target.name.."s def.", done)
		end)
	end,
	counter = function(target, from, done, base)
		attack(target, from, done, base, "counter")
	end,
	punch = function(target, from, done, base)
		attack(target, from, done, base, "punch")
	end,
	bash = function(target, from, done, base)
		attack(target, from, done, base, "bash")
	end,
	takedown = function(target, from, done, base)
		attack(target, from, done, base, "takedown")
	end,
	bubble = function(target, from, done, base)
		attack(target, from, done, base, "bubble")
	end,

}
movenames = {
	"scratch", "tackle", "rage", "burn", "leer", "counter", "punch", "bash", "takedown", "bubble"
}

movesstats = {}
local i = 1
for k in all(movenames) do
	movesstats[k] = {
		id = i,
		acc = 0.95
	}
	i+=1
end
-- from:
-- http://www.lexaloffle.com/bbs/?tid=2477
function sort(a)
	for i=1,#a do
		local j = i
		while j > 1 and a[j-1] > a[j] do
			a[j],a[j-1] = a[j-1],a[j]
			j = j - 1
		end
	end
end


function savegame()
	print("saving")
	for k = 1,4 do
		local mon = p.monsters[k]
		if mon then
			local n = (k-1)*12
			dset(n+0, intypes[mon.name])
			dset(n+1, flr(mon.maxhp))
			dset(n+2, flr(mon.curhp))
			dset(n+3, mon.level)
			dset(n+4, mon.speed)
			dset(n+5, mon.defense)
			dset(n+6, mon.attack)
			dset(n+7, mon.xp)
			if mon.move1 then
				dset(n+8, movesstats[mon.move1].id)
			end
			if mon.move2 then
				dset(n+9, movesstats[mon.move2].id)
			end
			if mon.move3 then
				dset(n+10, movesstats[mon.move3].id)
			end
			if mon.move4 then
				dset(n+11, movesstats[mon.move4].id)
			end
		end

	end
	for i=1,14 do
		dset(48+i-1, p.items[i] or 0)
	end
	-- printh("saved")
	dset(62, p.x)
	dset(63, p.y)
end

cartdata("headchant_picomon")

function gameintro()
	p.kills = 2
	p.blackscreen = true
	text("*ringring*", function()
		text("*ringring", function()
			text("was that the phone?")
			p.blackscreen = false
			music(9)
		end)
	end)
end

function loadgame()
	if not dget(0) or dget(0) == 0 then
		gameintro()
	return end
	music(1,1,6)
	
	-- printh("loading game")
	local ids = {}
	for k,v in pairs(movesstats) do
		ids[v.id] = k
	end

	for i=1,4 do
		local n = (i-1)*12
		-- printh("n:"..n)
		-- printh("data:"..dget(n))
		if dget(n) and dget(n) ~= 0 then
			p.monsters[i] = {
				name = montypes[dget(n+0)],
				type = montypes[dget(n+0)],
				maxhp = dget(n+1),
				curhp = dget(n+2),
				level = dget(n+3),
				speed = dget(n+4),
				defense = dget(n+5),
				attack = dget(n+6),
				xp = dget(n+7),
				move1 = ids[dget(n+8)],
				move2 = ids[dget(n+9)],
				move3 = ids[dget(n+10)],
				move4 = ids[dget(n+11)],
			}
			-- p.monsters[i].curhp = p.monsters[i].maxhp
		end
	end
	p.items = {}
	for i=1,14 do
		if dget(48+i-1) and dget(48+i-1) ~= 0 then
			add(p.items, dget(48+i-1))
		end
	end
	if dget(62) ~= 0 then
		p.x = dget(62)
		p.y = dget(63)
		p.inside = nil
	end
	if p.monsters[1] then
		mset(47,5,11)
	else
		mset(47,5,97)
	end
end

empty = function() end

function _init()
	music(6)
	palt(0,false)
	palt(7,true)
end

function initvars()
	

	
	p = {
		escapetries = 0,
		kills = 0,
		x=36,
		y=7,
		dir = 33,
		inside = {
			x = 28,
			y = 0
		},
		items = {
			1, 2,
		},
		monsters = {
			
		}
	}
	palt(0,false)
	palt(7,true)
	funcs = {}
	time = 0
	dialog = {
		menusel = 1,
		t = 0,
		text = nil,
	}
	menus = {

	}
	loadgame()
end

-- from
-- http://pico-8.wikia.com/wiki/draw_zoomed_sprite_(zspr)
function zspr(n,w,h,dx,dy,dz)
  sx = 8 * (n % 16)
  sy = 8 * flr(n / 16)
  sw = 8 * w
  sh = 8 * h
  dw = sw * dz
  dh = sh * dz
  sspr(sx,sy,sw,sh, dx,dy,dw,dh)
end

function testteleport(x,y, fx, fy, tx, ty, inside, dir,success)
	local x,y = x - 1, y - 1
	if x == fx and y == fy then
		fade(0,-100,4)
		p.transition = true
		sfx(5)
		if not inside then
			music(1,1,6)
		else
			music(10,0,6)
		end
		if tx > 68 and ty < 22 then
			music(4,0,6)
		end
		add(funcs, {
			t = 8,
			update = function(self)
				self.t-=1
				if self.t==0 then
					
					if success then success() end
					p.transition = false
					p.x = tx+1
					p.y = ty+1
					p.inside = inside
					if dir then p.dir = dir end

					fade(-100,0,4)
				end
			end,
			draw = empty
		})
		
	end
end

function after(t, f)
	add(funcs, {
		t=t,
		update = function(self)
			self.t-=1
			if self.t == 0 then
				f()
			end
		end,
		draw = empty
		})
end



drawborder = function(x,y,w,h)
	local x, y,w,h = x, y, w or 7, h or 14
	rectfill(x,y,x+(w+1)*8,y+(h+2)*8,7)
	spr(100,x,y)
	spr(100,x+w*8,y,1,1,true)
	spr(116,x+w*8,y+(h+1)*8,1,1, true)
	spr(116,x,y+(h+1)*8,1,1)
	for i=1,w-1 do
		spr(101,x+i*8,y)
		spr(117,x+i*8,y+(h+1)*8)
	end
	for i=1,h do
		spr(102, x, y+i*8, 1,1, true)
		spr(102, x+w*8, y+i*8, 1,1)
	end
end
function lowerwindow()
	drawborder(0,96,15,2)
end

function leftmenu(w, h)
	drawborder(0,0,w,h)
end

function itemsmenu(donemenu)
	if #p.items > 10 then
		text("you have too many items. only the first 10 items will be saved...")
	end

	add(menus, {
		sel = 1,
		draw = function(self)
			leftmenu(nil, #p.items+2)
			local n = 0
			for item in all(p.items) do
				if item > 0 then
					n+=1
					if self.sel == n then
						spr(67,8, 8+n*8)
					end
					print(items[item], 16, 8+n*8,0)
				end
			end
		end,
		update = function(self)
			self.sel = handlemenu(#p.items, self.sel)
			if btnp(5) then
				del(menus, self)
			end
			if btnp(4) then
				if not p.items[self.sel] then return end
				local drop = function()
					del(p.items, p.items[self.sel])
				end
				local use = function()
					-- smokeball
					if p.items[self.sel] == 3 then
						if dialog.battle then
							text("you use the smokeball!", function()
								text("you ran away!")
								del(p.items, 3)
								menus = {}
								dialog.battle = nil
								p.transition = nil
							end)
						else
							text("this can only be used in battle!")
						end
						return
					end
					-- picoball
					if p.items[self.sel] == 2 then
						if #p.monsters == 4 then
							text("you already have 4 monsters.", function()
								text("release some monsters to catch new ones.")
							end)
						elseif dialog.battle then
							if rnd() < 0.2+((dialog.battle.monsters[1].curhp/dialog.battle.monsters[1].maxhp))*0.2 then
								text("clonk! oh no, you missed the "..dialog.battle.monsters[1].name.."!", function()
									del(p.items, 2)
									-- del(menus, self)
									donemenu()
								end)
								return
							else
								music(-1)
								sfx(37,0)
								text("you caught the "..dialog.battle.monsters[1].name.."!", function()
									dialog.battle = nil
									p.transition = nil
									if p.x > 68 and p.y < 22 then
										music(4,0,6)
									else
										music(1,1,6)
									end

								end)
								add(p.monsters, dialog.battle.monsters[1])
								
								del(p.items, 2)
							end
						else
							text("this can only be used in battle!")
						end
						return
					end
					-- potion
					if p.items[self.sel] == 1 and p.monsters[1] then
						-- select monster to heal
						add(menus, {
							sel = 1,
							draw = drawmonstermenu,
							update = function(self)
								self.sel = handlemenu(#p.monsters, self.sel)
								if btnp(5) then
									del(menus, self)
								end
								if btnp(4) then
									local mon = p.monsters[self.sel]
									if mon.curhp == 0 then
										text(mon.name.." can't be healed. he is defeated.")
										sfx(61,0)
									elseif mon.curhp < mon.maxhp then
										
										mon.curhp = flr(min(mon.maxhp, mon.curhp + 20))
										local done = function()
											del(p.items, 1)
											del(menus, self)
											if donemenu then donemenu() end
										end
										sfx(62,0)
										if flr(mon.curhp) == flr(mon.maxhp) then
											text("healing "..mon.name.." back to full hp!", done)
										else
											text("healing "..mon.name.." for 20 hp!", done)
										end
									else
										text(mon.name.." is already at fully healed!")
									end
								end
							end
						})
						return
					end
					if p.items[self.sel] == 6 then
						text("hmmm...a delicious apple!")
						return
					end
					if p.items[self.sel] == 9 then
						add(menus, {
							sel = 1,
							draw = drawmonstermenu,
							update = function(self)
								self.sel = handlemenu(#p.monsters, self.sel)
								if btnp(4) then
									del(menus, self)
									if rnd() < 0.5 then
										text(p.monsters[self.sel].name.." loves candy!", function()
											p.monsters[self.sel].doublexp = true
											del(p.items, 9)
											del(menus, self)
										end)
									else
										text(p.monsters[self.sel].name.." hates candy!", function()
											p.monsters[self.sel].doublexp = false
											del(p.items, 9)
											del(menus, self)
										end)
									end
								end
								if btnp(5) then
									del(menus, self)
								end
							end
							})
						return
					end
					text("can't use that here")
				end
				add(menus, {
					sel = 1,
					update = function(self)
						self.sel = handlemenu(2, self.sel)
						if btnp(4) and self.sel == 1 then
							use()
							del(menus,self)
						end
						if btnp(4) and self.sel == 2 then
							drop()
							del(menus,self)
						end
						if btnp(5) then
							del(menus,self)
						end
					end,
					draw = function(self)
						drawborder(32,32,5,5)
						spr(67,32+8, 32+16	+self.sel*8)
						print("use",32+16,32+24,0)
						print("drop",32+16,32+32,0)
					end
				})
			end
		end
	})
end

drawmonstermenu = function(self)
	drawborder(64,0,7,5)
	
	for i=1, #p.monsters do
		if self.sel==i then
			spr(67,64+8, 8+(i-1)*9)
		end
		spr(monstats[p.monsters[i].name].spr, 64+16-1, 8+(i-1)*9-2)
		-- print(p.monsters[i].name, 64+16+8, 8+(i-1)*9,0)
		local hp = p.monsters[i].curhp/p.monsters[i].maxhp
		local x,y,w,h = 64+16+8,8+(i-1)*9+1,28,3
		rectfill(x,y,x+flr(w*hp),y+h,8)
		rect(x,y,x+w,y+h,0)
	end

	drawborder(0,0,7,10)

	local i = self.sel
	if p.monsters[i] then

		local mon = p.monsters[i]
		print(i.." "..mon.name,8,8,0)
		print("  ("..monstats[mon.name].element..")",8,16,0)
		local n = 1
		local stats = {
			"level",
			"xp",
			"curhp",
			"speed",
			"defense",
			"attack"
		}
		local abbr = {
			level = "lvl",
			xp = "exp",
			curhp = "hp",
			speed = "spd",
			defense = "def",
			attack = "atk"
		}
		for v in all(stats) do
			local str = abbr[v].." "..mon[v]
			if v == "xp" then
				str = str.."/"..flr((mon.level*10)^1.2)
			end
			if v == "curhp" then
				str = str.."/"..mon.maxhp
			end
			print(str, 8, 16+n*8, 0)
			n+=1
		end
		print("z: options", 8, 64+16) 
		
		spr(elementalsprites[monstats[mon.name].element], 8, 14)
		drawborder(64,64,7,5)
		local ids = {}
		for k,v in pairs(movesstats) do
			ids[v.id] = k
		end
		if mon.move1 then
			print(mon.move1,64+8,64+8,0)
		end
		if mon.move2 then
			print(mon.move2,64+8,64+16,0)
		end
		if mon.move3 then
			print(mon.move3,64+8,64+24,0)
		end
		if mon.move3 then
			print(mon.move3,64+8,64+32,0)
		end
	end


end

function swapinmenu(forced, endround)
	add(menus, {
		sel = 1,
		draw = drawmonstermenu,
		update = function(self)
			self.sel = handlemenu(#p.monsters, self.sel)
			if btnp(4) then
				if p.monsters[self.sel].curhp > 0 then
					local o = p.monsters[1]
					local m = p.monsters[self.sel]
					if o == m then
						return
					end
					del(menus, self)
					text("swapping "..o.name.." for "..m.name, function()
						if not forced then endround() end
					end)

					p.monsters[1] = m
					p.monsters[self.sel] = o
					self.sel = 1
				else
					text("you can't choose him, he's down.")
				end
			end
			if btnp(5) and not forced then
				del(menus, self)
			end
		end
	})
end

function handlemenu(n, sel)
	local selector = sel or dialog.menusel
	local n = n or 4
	if btnp(0) then
		sfx(63,0)
		selector-=2
	end
	if btnp(1) then
		sfx(63,0)
		selector+=2
	end
	if btnp(2) then
		sfx(63,0)
		selector-=1
	end
	if btnp(3) then
		sfx(63,0)
		selector+=1
	end
	if selector <= 0 then selector += n end
	if selector > n then selector -= n end
	return selector
end

function enter(x, y)
	if dialog.battle then return end
	if mget(x-1,y-1) == 3 or mget(x-1,y-1) == 48 or mget(x-1,y-1) == 112 then
		if rnd() < 0.2 then
			music(-1)
			sfx(41)
			p.escapetries = 0
			menus = {}
			p.transition = true
			local n = 0
			local flash
			flash = function()
				n+=1
				if n > 4 then
					add(menus, {
						update = function()
							dialog.menusel = handlemenu()
							if btnp(4) then
								local endround = function()
									local ms = {}
									for i=1,4 do
										if p.monsters[1]["move"..i] then
											add(ms, dialog.battle.monsters[1]["move"..i])
										end
									end
									local m = ms[1+flr(rnd()*#ms)]
									moves[m](p.monsters[1], dialog.battle.monsters[1], function()
										if p.monsters[1].curhp <= 0 then
											p.monsters[1].curhp = 0
											local left
											for i=1,4 do
												if p.monsters[i] and p.monsters[i].curhp > 0 then
													left = true
												end
											end
											if left then
												swapinmenu(true)
											else
												music(-1)
												text("you were defeated!", function()
													menus = {}
													text("...you awake at your last save point.", function()
														initvars()
													end)
												end)
												
											end
											return
										else
											del(menus, self)
											dialog.menusel = 1
										end
									end)
								end
								if dialog.menusel == 3 then
									swapinmenu(nil, endround)
								end
								if dialog.menusel == 4 then
									if rnd(255) < p.monsters[1].speed*32/((dialog.battle.monsters[1].speed/4)%256) + p.escapetries*30 then
										menus = {}
										dialog.battle = nil
										p.transition = nil
										music(-1)
										text("you ran away!", function()
											music(1,1,6)
											end)
									else
										p.escapetries+=1
										text("you try to run away...but fail", function()
											endround()
										end)
										
									end
									return
								end
								if dialog.menusel == 2 then
									itemsmenu(function()
										del(menus, menus[#menus])
										endround()
									end)
								end
								if dialog.menusel == 1 then
									add(menus, {
										draw = function()
											lowerwindow()
											
											for i=1,4 do
												local m = p.monsters[1]["move"..i]
												if m then
													if dialog.menusel == i then
														spr(67, 16, 96+i*8)
													end
													--"("..(p.monsters[1][m.."pp"] or movesstats[m].pp)..")"
													print(m, 16+8, 96+i*8, 0)
												else

												end
											end
										end,
										update = function(self)
											local n = 0
											for i=1,4 do
												local m = p.monsters[1]["move"..i]
												if m then n+=1 end
											end
											dialog.menusel = handlemenu(n)
											if btnp(5) then
												del(menus, self)
											end
											if btnp(4) then
												local m = p.monsters[1]["move"..dialog.menusel]
												if m then
													moves[m](dialog.battle.monsters[1], p.monsters[1], function()
														if dialog.battle.monsters[1].curhp <= 0 then
															dialog.battle.monsters[1].curhp = 0
															menus = {}
															music(-1)
															sfx(37,0)
															text("you defeated the "..dialog.battle.monsters[1].name.."!", function()
																p.kills+=1
																local xp = flr(5*dialog.battle.monsters[1].level + rnd(5*dialog.battle.monsters[1].level))
																if p.monsters[1].doublexp then
																	xp=xp*2
																end
																p.monsters[1].xp+=xp

																text("your "..p.monsters[1].name.." earned "..xp.." xp!", function()
																	if p.monsters[1].xp >= (p.monsters[1].level*10)^1.2 then
																		-- level up
																		local mon = p.monsters[1]
																		mon.xp=0
																		mon.level+=1
																		mon.maxhp = flr((monstats[mon.name].hp*2*mon.level/100)+mon.level+10)
																		mon.curhp = mon.maxhp
																		mon.attack = flr((monstats[mon.name].attack*2*mon.level/100)+mon.level+10)
																		mon.defense = flr((monstats[mon.name].defense*2*mon.level/100)+mon.level+10)
																		mon.speed = flr((monstats[mon.name].speed*2*mon.level/100)+mon.level+10)

																		text("your "..p.monsters[1].name.." is now level "..p.monsters[1].level.."!", function()
																			dialog.battle = nil
																			p.transition = nil
																			music(1,1,6)
																		end)
																	else
																		dialog.battle = nil
																		p.transition = nil
																		music(1,1,6)
																	end
																	
																end)
															end)
														else
															endround()
															
														end
													end)
													
												end
											end
										end
									})
								end
							end
						end,
						draw = function()
							lowerwindow()							

							local x,y,w,h = 4,8,48,32-8
							rectfill(x,y,x+w,y+h,0)
							rectfill(x+1,y-1,x+w,y+h-1,7)
							print(dialog.battle.monsters[1].name, 8, 8,0)
							print(":l"..dialog.battle.monsters[1].level, 16, 16,0)
							print("hp:", 8, 23)
							local x,y,w,h = 20, 24, 24,3
							local hp = dialog.battle.monsters[1].curhp/dialog.battle.monsters[1].maxhp
							rectfill(x,y,x+flr(w*hp),y+h,8)
							rect(x,y,x+w,y+h,0)
							zspr(monstats[dialog.battle.monsters[1].name].spr,1,1, 74+dialog.battle.e.x, 4+dialog.battle.e.y,4)

							local x,y,w,h = 64+11,64,48,32-8
							rectfill(x,y,x+w,y+h,0)
							rectfill(x-1,y-1,x+w-1,y+h-1,7)
							local x = x+4
							print(p.monsters[1].name, x, y,0)
							print(":l"..p.monsters[1].level, x+8, y+8,0)
							print("hp:", x, y+15)
							local x,y,w,h = x+12, y+16, 24,3
							local hp = p.monsters[1].curhp/p.monsters[1].maxhp
							rectfill(x,y,x+flr(w*hp),y+h,8)
							rect(x,y,x+w,y+h,0)
							zspr(monstats[p.monsters[1].name].spr,1,1, 16+dialog.battle.p.x, 64+dialog.battle.p.y,4)

							if dialog.menusel == 1 then
								spr(67, 48, 96+8)
							elseif dialog.menusel == 3 then
								spr(67, 32+48, 96+8)
							elseif dialog.menusel == 2 then
								spr(67, 48, 96+8+8)
							elseif dialog.menusel == 4	 then
								spr(67, 32+48, 96+8+8)
							end

							print("fight", 48+8, 96+8, 0)
							print("monster", 32+48+8, 96+8, 0)
							print("item", 48+8, 96+8+8, 0)
							print("run", 32+48+8, 96+8+8, 0)
						end
						})
					
					dialog.menusel = 1
					local lvl = max(1, p.monsters[1].level + flr(-3+rnd(4)))
					local name = "piggy"
					local spawnmonsters = {}

					if mget(x-1,y-1) == 48 then
						-- in cave
						add(spawnmonsters, "watawamp")
						add(spawnmonsters, "pilo")
					elseif mget(x-1,y-1) == 112 then
						-- in water
						add(spawnmonsters, "flipa")
						add(spawnmonsters, "crub")
					else
						if x < 19 and y < 31 then
							add(spawnmonsters, "rowpim")
							add(spawnmonsters, "piggy")
							add(spawnmonsters, "purbirb")
						elseif x < 35 and y < 56 then
							add(spawnmonsters, "groldo")
							add(spawnmonsters, "feuxdino")
							add(spawnmonsters, "tinkerelle")
						elseif x < 35 then
							add(spawnmonsters, "limegoo")
						elseif x > 108 and y > 38 then
							add(spawnmonsters, "mogmine")
							add(spawnmonsters, "hatcell")
							add(spawnmonsters, "plaradi")
						elseif x > 60 and y > 40 then
							add(spawnmonsters, "dogshade")
							add(spawnmonsters, "buzzcor")
							add(spawnmonsters, "sneg")
						else
							spawnmonsters = montypes
						end
					end

					local a,b = flr(rnd()*#spawnmonsters), flr(rnd()*#spawnmonsters)
					local value = max(a,b)
					name = spawnmonsters[#spawnmonsters - value]
					if not name then name = "piggy" end

					local movesidx = {}
					for k,v in pairs(moves) do
						add(movesidx, k)
					end
					
					local move1, move2, move3, move4
					move1 = movesidx[flr(1+rnd()*#movesidx)]
					del(movesidx, move1)
					if rnd() < 0.5 then
						move2 = movesidx[flr(1+rnd()*#movesidx)]
						del(movesidx, move2)
						if rnd() < 0.5 and lvl > 5 then
							move3 = movesidx[flr(1+rnd()*#movesidx)]
							del(movesidx, move3)
							if rnd() < 0.5 and lvl > 10 then
								move4 = movesidx[flr(1+rnd()*#movesidx)]
								del(movesidx, move4)
							end
						end
					end
					printh(name)
					music(6,0,6)
					dialog.battle = {
						p = { x = 0, y = 0},
						e = { x = 0, y = 0},
						monsters = {
							{
								name = name,
								type = name,
								maxhp = flr((monstats[name].hp*2*lvl/100)+lvl+10),
								curhp = flr((monstats[name].hp*2*lvl/100)+lvl+10),
								level = lvl,
								speed = flr((monstats[name].speed*2*lvl/100)+lvl+10),
								defense = flr((monstats[name].defense*2*lvl/100)+lvl+10),
								attack = flr((monstats[name].attack*2*lvl/100)+lvl+10),
								xp = 0,
								move1 = move1,
								move2 = move2,
								move3 = move3,
								move4 = move4,
							}
						}
					}
					text("a wild "..dialog.battle.monsters[1].name .." appears!")
					return 
				end
				-- flashing effect
				fade(0,-100,4)
				after(4, function() 
					fade(-100,0,4) 
					after(4, flash)
				end)
			end
			flash()
		end
	else
		-- home
		testteleport(x, y, 39, 2, 54, 2, {x=28+15, y=0})
		testteleport(x, y, 54, 2, 39, 2, {x=28, y=0})
		
		-- picotown
		if not p.monsters[1] then
			if (x == 50 and y == 9) or (x==51 and y==9) then
				text("i should probably look around first.")
			end
		else
			testteleport(x, y, 49, 8, 12, 6)
			testteleport(x, y, 50, 8, 12, 6)
		end

		-- cave
		-- to picotown 
		testteleport(x, y, 124, 2, 5, 52)
		testteleport(x, y, 5,52, 124, 2)
		-- to vertebrae city
		--music(4)
		testteleport(x, y, 121,21, 87, 48)
		testteleport(x, y, 87,48, 121,21)
		-- after egg fight
		testteleport(x, y, 72,3, 74, 33)
		testteleport(x, y, 74,33, 72,3)
		
		testteleport(x, y, 12, 6, 50, 7, {x=28+15, y=0})
	end
end

function text(txt, after)
	local k = ""
	local g = false
	for i=1, #txt do
		k = k..sub(txt, i,i)
		if i%22 == 0 or g then
			g = true
			if sub(txt, i,i) == " " then
				k = k .. "\n"
				g = false
			end
		end
	end
	txt = k.."❎"
	dialog.text = txt
	dialog.t = 0
	dialog.after = after
end

function walkagainst(x, y)
	if mget(x,y) == 19 and p.dir == 33 then
		p.jumping = true
		return false
	end
	return true
end

function updatemenu()
	if btnp(4) or btnp(5) then
		music(-1)
		initvars()
		_update = updategame
		_draw = drawgame
	end
end
_update = updatemenu

function updategame()
	time+=1
	sort(p.items)
	for v in all(funcs) do
		v:update()
	end
	local x,y = 0, 0
	if not p.transition and not dialog.text then
		if btn(0) then
			x-=1
		end
		if btn(1) then
			x+=1
		end
		if btn(2) then
			y-=1
		end
		if btn(3) then
			y+=1
		end
	end
	if x ~= 0 then y = 0 end

	if not p.moving and (x~=0 or y~=0) then
		if x > 0 then
			p.dir = 37
		elseif x < 0 then
			p.dir = 35	
		end
		if y > 0 then
			p.dir = 33
		elseif y < 0 then
			p.dir = 36
		else

		end
		if fget(mget(flr(p.x+x-1), flr(p.y+y-1)),1) and walkagainst(p.x+x-1, p.y+y-1) then
			
			return
		end
		p.swimming = false
		if fget(mget(flr(p.x+x-1), flr(p.y+y-1)),2) then
			local found
			for i in all(p.items) do
				if i == 5 then
					found = true
					break
				end
			end
			if not found then

				return
			else
				p.swimming = true
			end
		end
		y+=(p.jumping and y or 0)
		p.moving = true
		local movespeed = 8
		local tx, ty = p.x+x, p.y+y
		local a = add(funcs, {
			t = movespeed,
			update = function(self)
				p.x+=x/movespeed
				p.y+=y/movespeed
				self.t-=1
				if self.t == 0 then
					p.jumping = false
					p.moving = false
					del(funcs, self)
					p.x = flr(tx)
					p.y = flr(ty)
					enter(p.x, p.y)
				end
			end,
			draw = empty
		})
	end
	if(_pf>0) then --pal fade
	    if(_pf==1) then _pi=_pe
	    else _pi+=((_pe-_pi)/_pf) end
	    _pf-=1
	end
	if dialog.text then
		dialog.t+=2

		if dialog.t >= #dialog.text then
			if btnp(4) then
				dialog.text = nil
				if dialog.after then dialog.after() end
			end
		else
			sfx(24)
		end
	elseif dialog.battle then
		if menus[#menus] then
			menus[#menus]:update()
		end
	elseif dialog.menu then
		if menus[#menus] then
			menus[#menus]:update()
		end
	elseif btnp(4) then
		local right, left, up, down = 37, 35, 36, 33
		local x, y = p.x-1, p.y-1
		if p.dir == right then
			x+=1
		elseif p.dir == left then
			x-=1
		elseif p.dir == up then
			y-=1
		elseif p.dir == down then
			y+=1
		end

		-- telephone
		if mget(x, y) == 103 then
			if not p.monsters[1] then
				text("there is a message:", function()
					text("hey could you take the swooty outside for a walk?", function()
						text("it's in the picoball on the left wall.")
						end)
					end)
			else
				text(" - no new messages - ")
			end
		end

		-- book shelves
		if mget(x,y) == 85 then
			text("a buncha books")
		end

		-- picoball
		if mget(x, y) == 97 then
			
			sfx(40)
			text("you find a swooty!", function()
				savegame()
				end)
			
			mset(x,y,11)
			add(p.monsters, startermon)
		end

		-- picotown sign
		if mget(x, y) == 5 and x == 6 and y == 43 then
			text("welcome to picotown. don't throw shade at it, fam.")
		end
		if mget(x, y) == 5 and x == 10 and y == 6 then
			text("hint: press x to open the menu. save often.")
		end
		if mget(x, y) == 5 and x == 13 and y == 48 then
			text("prof corks lab")
		end
		if mget(x, y) == 5 and x == 6 and y == 52 then
			text("cave to vertebrae city")
		end
		-- postman
		if mget(x, y) == 47 and x == 11 and y == 38 then
			text("i'm kevin the postman.", function()
					text("i tried to deliver mail to prof cork.", function()
						text("but it seems he's out.", function()
							text("if you see him tell him i have something for him!")
						end)
					end)
				end)
		end
		--groldo
		if mget(x, y) == 75 and x == 13 and y == 43 then
			text("it gives you a weird look")
		end
		--groldo owner
		if mget(x, y) == 13 and x == 14 and y == 43 then
			text("my groldo is nice but a feuxdino would be lit!")
		end
		if mget(x, y) == 13 and x == 108 and y == 56 then
			if rnd() < 0.8 then
				text("don't you get lost in the city?")
			elseif rnd() < 0.5 then
				text("every street looks the same")
			else
				text("i heard that prof cork was last seen on the western lake.")
			end
		end
		-- sporty 
		if mget(x, y) == 31 and x == 121 and y == 49 then
			text("if the picostops don't pay out with new running shoes soon", function()
				text("i might have to run bare feet.")
			end)
		end
		-- obvious dude
		if mget(x, y) == 14 and x == 6 and y == 39 then
			text("where are the doors on these houses?")
		end
		-- apple dude
		if mget(x, y) == 14 and x == 106 and y == 42 then
			local foundapple, foundswimsuit
			for i in all(p.items) do
				if i == 6 then
					foundapple = true
				end
				if i == 5 then
					foundswimsuit = true
				end
			end
			if not foundapple and not foundswimsuit then
				text("i went swimming in the lake and now i'm hungry.", function()
					del(p.items, 6)
					text("man, i would really like an apple. could you get me one from the garden?")
				end)
			elseif foundapple and not foundswimsuit then
				text("thanks for the apple! here, have my swim suit!", function()
					add(p.items, 5)
				end)
			elseif foundswimsuit then
				text("there are some nice monsters to catch in the lake!")
			end
			return
		end

		-- rock
		if mget(x,y) == 83 then
			local foundhammer
			for i in all(p.items) do
				if i == 7 then
					foundhammer = true
				end
			end
			if foundhammer then
				mset(x,y,63)
			end
		end

		-- candy
		if mget(x,y) == 98 then
			add(p.items, 9)
			text("you found a candy!")
			mset(x,y,63)
		end

		-- prof cork
		if mget(x,y) == 12 and x == 49 and y == 56 then
			local foundhammer
			for i in all(p.items) do
				if i == 7 then
					foundhammer = true
				end
			end
			if not foundhammer then
				text("are you looking for me? i'm prof cork.", function()
					text("how are your monsters doing?", function()
						text("i will rate your monsters and give out prizes.", function()
							text("let me see... ..hmmm.. ....", function()
								text("your rating is...", function()
									local rating = 0
									for i=1,4 do
										if p.monsters[i] then
											rating+=p.monsters[i].level
										end
									end
									text(rating.."!", function()
										if rating > 1 then
											add(p.items, 7)
											text("that is great. here take this hammer!", function()
												text("*you get a hammer*")
											end)
										else
											text("you should come back when your monsters are stronger!")
										end
									end)
								end)
							end)
						end)	
					end)
				end)
			else
				text("you can now check out the cave!")
			end
		end
		-- garden gates
		if mget(x, y) == 21 then
			local haskey
			for i in all(p.items) do
				if i == 4 then
					haskey = true
					break
				end
			end
			if not haskey then
				text("it's locked")
			else
				text("you use the garden key to unlock the gate")
				mset(x,y,32)
			end
		end

		-- apple trees
		if mget(x,y) == 125 or mget(x,y) == 126 then
			local apples = 0
			for i in all(p.items) do
				if i == 6 then
					apples+=1
				end
			end
			if apples < 3 then
				add(p.items, 6)
				text("*you pick an apple*")
			else
				text("i should probably leave some for the others")
			end
		end
		
		-- ancap
		if mget(x, y) == 15 and x == 32 and y == 34 then
			text("we abolished capitalism for a picostop based economy.", function()
				text("works fine but i wonder where the items come from?")
			end)
		end

		-- prof corks assistant
		if mget(x, y) == 12 and x == 121 and y == 19 then
			local found
			for i in all(p.items) do
				if i == 4 then
					found = true
					break
				end
			end
			if not found then
				text("hey! i'm prof corks assistent.", function()
					text("what? there is mail for me?", function()
						text("i can't leave here yet", function()
							add(p.items, 4)
							text("but you can have this key to the garden.", function()
								text("*received garden key*")
							end)
						end)
					end)
				end)
			else
				text("i'm trying to catch a watawamp.")
			end
		end

		-- the sega
		if mget(x, y) == 30 and x == 35 and y == 5 then
			if rnd() < 0.5 then
				text("the cartridge is stuck...")
			else
				text("...")
			end
		end
		-- the tv at home
		if mget(x, y) == 29 and x == 50 and y == 2 then
			text("*...and finn the human, the fun will never end...*")
		end
		-- computer
		if mget(x, y) == 84 and x == 32 and y == 2 then
			text("it's my dusty and broken computer.")
		end
		if mget(x, y) == 115 or mget(x,y) == 99 then
			sfx(60,2)
			for i=1,4 do
				if p.monsters[i] then
					p.monsters[i].curhp = p.monsters[i].maxhp
				end
			end
			local after = function()
				savegame()
				text("your game has automatically been saved!")
			end
			text("the all your monsters are healed...", function()
				if p.kills < 1 then
					text("defeat a couple of wild monsters to get a prize from this picostop!", after)
				else
					if #p.items < 10 then
						p.kills-=1
						local item = (1+flr(rnd(2)))
						if rnd() < 0.05 then item = 3 end
						add(p.items, item)
						text("you press the button. the picostop drops a...", function()
							sfx(37,0)
							text("..."..items[item].."!", after)
							end)
					else
						text("your inventory is full!", after)
					end
				end
			end)
		end
	elseif not p.transition and btnp(5) and not p.moving then
		p.transition = true
		dialog.menu = true
		menus = {}
		-- menu
		add(menus, {
			draw = function()
				drawborder(64+8,0,6,6)
				for i=1,4 do
					if dialog.menusel == i then
						spr(67,64+16, 8+i*8)
					end
				end
				print("monster", 64+16+8, 16,0)
				print("item", 64+16+8, 24,0)
				print("save", 64+16+8, 32,0)
				print("reset", 64+16+8, 40,0)
			end,
			update = function(self)
				dialog.menusel = handlemenu(4)
				if btnp(4) then
					if dialog.menusel == 4 then
						text("caution: this will delete all your progress and reset the game!", function()
							add(menus, {
								sel = 1,
								update = function(self)
									self.sel = handlemenu(2, self.sel)
									if (btnp(4) and self.sel == 1) or btnp(5) then
										del(menus, self)
									end
									if btnp(4) and self.sel == 2 then
										del(menus, self)
										for i=0,63 do
											dset(i, nil)
										end
										music(-1)
										_init()
										_update = updatemenu
										_draw = drawmenu
									end
								end,
								draw = function(self)
									drawborder(32,32,9,5)
									spr(67,32+8, 32+16	+self.sel*8)
									print("are you sure?",32+16,32+8,0)
									print("no",32+16,32+24,0)
									print("yes",32+16,32+32,0)
								end
							})
							end)
						return
					end
					if dialog.menusel == 3 then
						savegame()
						if #p.items > 10 then
							text("you have too many items. only the first 10 items will be saved...", function()
								text("saved successfully!", function()
									p.transition = nil
									del(menus, self)
									dialog.menu = false
								end)
							end)
						else
							text("saved successfully!", function()
								p.transition = nil
								del(menus, self)
								dialog.menu = false
							end)
						end
						
						return
					end
					if dialog.menusel == 2 then
						itemsmenu()
					end
					if dialog.menusel == 1 then
						-- monster menu
						add(menus, {
							sel = 1,
							draw = drawmonstermenu,
							update = function(self)
								self.sel = handlemenu(#p.monsters, self.sel)
								if btnp(5) then
									del(menus, self)
								end
								if btnp(4) and p.monsters[1] then
									local swap = function()
										local o = p.monsters[1]
										local m = p.monsters[self.sel]
										p.monsters[1] = m
										p.monsters[self.sel] = o
										self.sel = 1
									end
									local which = self.sel
									add(menus, {
										sel = 1,
										update = function(self)
											self.sel = handlemenu(2, self.sel)
											if btnp(5) then
												del(menus, self)
											end
											if btnp(4) and self.sel == 1 then
												swap()
											end
											if btnp(4) and self.sel == 2 then
												local release = function()
													if #p.monsters > 1 then
														del(p.monsters, p.monsters[which])
														menus[#menus].sel = 1
													else
														text("you can't release your last monster.")
													end
													del(menus, self)
													
												end
												add(menus, {
													sel = 1,
													update = function(self)
														self.sel = handlemenu(2, self.sel)
														if (btnp(4) and self.sel == 1) or btnp(5) then
															del(menus, self)
														end
														if btnp(4) and self.sel == 2 then
															del(menus, self)
															release()
														end

													end,
													draw = function(self)
														drawborder(32,32,9,5)
														spr(67,32+8, 32+16	+self.sel*8)
														print("are you sure?",32+16,32+8,0)
														print("no",32+16,32+24,0)
														print("yes",32+16,32+32,0)
													end
												})
												
											end
										end,
										draw = function(self)
											drawborder(32,32,6,5)
											spr(67,32+8, 32+self.sel*8)
											print("first",32+16,32+8,0)
											print("release",32+16,32+16,0)
										end
										})
									
								end
							end
							})
					end
				end
				if btnp(5) then
					menus = {}
					p.transition = false
					dialog.menu = false
				end
			end
			})
	end
end

_shex={["0"]=0,["1"]=1,
["2"]=2,["3"]=3,["4"]=4,["5"]=5,
["6"]=6,["7"]=7,["8"]=8,["9"]=9,
["a"]=10,["b"]=11,["c"]=12,
["d"]=13,["e"]=14,["f"]=15}
_pl={[0]="00000015d67",
     [1]="0000015d677",
     [2]="0000024ef77",
     [3]="000013b7777",
     [4]="0000249a777",
     [5]="000015d6777",
     [6]="0015d677777",
     [7]="015d6777777",
     [8]="000028ef777",
     [9]="000249a7777",
    [10]="00249a77777",
    [11]="00013b77777",
    [12]="00013c77777",
    [13]="00015d67777",
    [14]="00024ef7777",
    [15]="0024ef77777"}
_pi=0-- -100=>100, remaps spal
_pe=0-- end pi val of pal fade
_pf=0-- frames of fade left
function fade(from,to,f)
    _pi=from _pe=to _pf=f
end

local td = 0
function drawmenu()
	td+=1
	cls()
	rectfill(0,0,128,128,7)
	for rmon=0,6 do
		zspr(73+rmon, 1,1,60-cos(rmon/7+(rmon+td)/300)*24,64+sin(rmon/7+(rmon+td)/300)*24,1)
	end
	for rmon=0,3 do
		zspr(121+rmon, 1,1,60+cos(rmon/4+(rmon+td)/100)*8,64+sin(rmon/4+(rmon+td)/100)*8,1)
	end
	rectfill(0,16-8,128,16+12,0)
	
	print("2016 by headchant ", 30,128-5,0)
	print("pico\nmonsters", 46,12,7)
	rectfill(0,110-8,128,110+12,0)
	local str = "z to begin"
	if dget(0) ~= 0 then
		str = "z to continue"
	end
	print(str, 64-#str*2,110,7)

end
_draw = drawmenu

function drawgame()
	camera()
	cls()
	rectfill(0,0,128,128,7)
	
	local camx, camy = flr(p.x*8)-64, flr(p.y*8)-64
	camx = max(0, camx)
	camy = max(0, camy)
	camx = min(128*8-128, camx)
	camy = min(64*8-128, camy)
	if p.inside then
		camx = p.inside.x*8
		camy = p.inside.y*8
	end
	camera(camx, camy)
	map(0,0,0,0,128,128)
	
	if p.swimming then
		spr(50, (p.x-1)*8, (p.y-1)*8 - (p.jumping and 2 or 0))
	else
	    spr(p.dir+(p.moving and flr(time/2)%2 or 0)*16, (p.x-1)*8, (p.y-1)*8 - (p.jumping and 2 or 0))
	end
	if mget(flr(p.x-1), flr(p.y-1)) == 3 then
		if p.y <= flr(p.y)+0.5 then
			spr(3, flr(p.x-1)*8, flr(p.y-1)*8)
		end
	end
	if mget(flr(p.x), flr(p.y-1)) == 3 then
		spr(3, flr(p.x)*8, flr(p.y-1)*8)
	end
	
	for v in all(funcs) do
		v:draw()
	end

	
	camera()
	if p.blackscreen then
		rectfill(0,0,128,128,0)
	end
	if dialog.battle then
		rectfill(0,0,128,128,7)
		for v in all(menus) do
			v:draw()
		end
	end
	if dialog.menu then
		for v in all(menus) do
			v:draw()
		end
	end
	
	if dialog.text then
		lowerwindow()
		if dialog.t >= #dialog.text then
			-- blink the last char
			print(sub(dialog.text,1,#dialog.text-flr(time/4)%2), 8,96+8,32)
		else
			print(sub(dialog.text,1,dialog.t), 8,96+8,32)
		end
	end
	local pix=6+flr(_pi/20+0.5)
	if(pix!=6) then
	    for x=0,15 do
	        pal(x,_shex[sub(_pl[x],pix,pix)],1)
	    end
	else 
		pal()
		palt(0,false)
		palt(7,true)
	end
end
__gfx__
77777777770000777b777b7b7777777777767777011111077777000000000000000000000000777777777777776767777766ff7777eeee7777bbbb7777888887
7777777770666607b7b7b7bb77777777777677777000007077707d66666666666666666666d70777777777777676777776666ff77eeeeee77bbbbbb778888888
77777777700660077b7b7b7b777777377677676707777701770d7dddddddddddddddddddddd7d07777777777677767777fff66677ffeeee77bbbfff77fff8888
7777777770d00d07bbb77bb7737773b3767767670dd7d701707d7d66666666666666666666d7d70777777777777776767f0fff677f0feee77bfff0f77f0ff888
777777777067760777b7b7b73b373b3777767776077777010d7d7d00000000000000000000d7d7d077777777677777677ffffff77ffeeff77ffffff77ffff888
7777777770d77d077b7bbb7b3b7333377776767607dd7d010d7d706666666666666666666607d7d07777777776777776776fff7777ffff7777fff67777ffff88
7777777770d77d0db7bbb7b7337373bb76777677700000d10d7d066000077777d0000dd00000d7d0777777777767776777555577775555777755557777555577
77777777760000d6777b7b7bb3373bb776777777777777d00d7066077670777707767007767007d0777777777776767777377377773773777737737777377377
7b777b7b77077707767776767777777777777777777777700006670767d077770767d00767d06000000000007000000000000007770000777777777779999977
b7b7b7bb7000700067777766660006667777777770000000770677067dd07777067dd0067dd06077000000000777777777777770701111077000777775555557
7b7b7b7b70007000777dd776606dd000777777d707070700770677d0000d7777d0000dd0000d60770000000007ddddddddddddd000000000011107777999fff7
bbb77bb770d070d067dd7d7606d67d6d7d777d6d00000000770661111111111111111111111660770000000007ddddddddddddd00d7dddd007770777799ff0f7
77b7b7b77060706067d76d77dd600dd7d6d7d6d7070707007707dddddddddddddddddddddddd70770000000007ddddddddddddd007ddddd00d760707799ffff7
7b7bbb7b70607060767dd7760007d000d67dddd7000000007707dddddddddddddddddddddddd70770000000007ddddddddddddd00dddddd0700070d077ffff77
b7bbb7b7707070706767dd67dd666ddddd7d7d6607070700600000000000000000000000000000070000000007ddddddddddddd00dddddd077770d6077555577
777b7b7b76067606766d7676677777666dd7d66770000000660666660666666066666666666660770000000007ddddddddddddd0000000007777700777377377
767776767788887777888877788887777788887777788887660777770dddddd0d0000dd0000d70770000000007ddddddddddddd0777777776666666677000007
676767667888888778888887888888777888888777888888660776660d6767d007767007767070660dddddd007ddddddddddddd0770000772222222270000007
76767676f886688ff886688f6688f888f888888f888f8866660777770ddddd000767d00767d070660000000007ddddddddddddd07066660722dd22dd7ff33337
66677667ffffffffffffffffffffff77ff8888ff77ffffff660777770dddd070067dd0067dd070660066660007ddddddddddddd070666607dd22dd227f0f3337
776767677f0ff0f77f0ff0f7f0ffff277ff22ff772ffff0f660666660d666600d0000dd0000d706606777760000000000000000070666607222222227ffff337
7676667675ffff5e75ffff5eeffffdd7752dd25f7ddffffe660776660dddddd066666666666770660777777000dddddddddddd007000000722dd22dd77ffff77
67666767e7555577e755557775555577f7522577775555576660000000000000000000000000066607777770000000000000000070077007dd22dd2277555577
77767676777733777755337777337777777733777777337766666660066666600666666666666666077777700077777777777700707777076666666677377377
747774777788887777888877788887777788887777788887660777770dddddd0d0000dd07777777707777770666666660d7777d0111111067777770777777777
477747747888888778888887888888777888888777888888660776660d6767d0077670077777777707777770666666660000000011111066777770d677777777
77777777f886688ff886688f6688f888f888888f888f8866660777770ddddd000767d0077777777707777770dddddddd0d7777d011110066777707d677777777
47477747ffffffffffffffffffffff77ff8888ff77ffffff660777770dddd070067dd00677777777077777706666666600000000111060667770d6d077777777
777777777f0ff0f77f0ff0f7f0ffff277ff22ff772ffff0f660666660d666600d0000dd07777777706777760666666660d7777d0110660667707d60677777777
77744774e5ffff5777777777effffdd7f52dd2577ddffffe660776660dddddd066666666777777770000000066666666000000001006606670d6d06677777777
777777777755557e77777777355555777752257f775555536660000000000000000000007777777701111110dddddddd0d7777d00606606607d6066677777777
777477747733777777777777337733777733777777337733666666660666666066666666777777770666666066666666000000006606606670d0666677777777
4444444466666666666666667700777777000077000000000000000077777777cccc7dd17777777777777977777777777888877a77ccc7777777777779977997
4444444466666666666666667700077770111107077777700d7777d077777777c7c7cdd17eee77777777797777737377780787a97ddcdd7777bbb77798988989
66666666dddddddddddddddd770000770000000007ddddd000000000707770777c7ccdd1eeeee7777700099977733377888887a97c8d8c77b3bbb77790055009
444444446000000000000006770007770d7dddd007ddddd00d7777d006077007cccccdd10eee077e7007007737303037668899787ccccc77b3bbb37790088009
4444444407777777777777707700777707ddddd0000000000000000070600060ccc7cdd1e8e8eee770707077373333378888997857cdc757bb373bb359955995
4444444407ddddddddddddd0777777770dddddd0066666600d7777d000060607ddddddd1efffeee7700700773363336778889978d55c55d7bbbb7b3b77588577
6666666607ddddddddddddd0777777770dddddd0066666600000000006006060ddddddd17eeeeee78000088733366677788888875dcccd5770b077bb55955955
4444444407ddddddddddddd07777777700000000000000000d7777d070600607111111117e77e7e7887778873737377778878877dcccccd777b7777759988995
cccc7dd107ddddddddddddd077777777045632d00666666000000000006070771ddc7ccc772277770ff77ff07eeeeee77373373777888877d777777d05077050
c7c7cdd107ddddddddddddd077666667006166000666666066666666770707771dd7c7c772627777ffffffffee7ee7ee37377373787888877d7117d759577595
7c7ccdd107ddddddddddddd0766666660d0000d000000000dddddddd777007771ddccc7c99222777ff1ff1ffe17ee17e77733777788887877711117775777757
cccccdd107ddddddddddddd0766666660dddddd00dddddd066666666700000071ddccccc772222777ffffff7feeeeeef77d33d77887888887181181777577577
ccc7cdd1000000000000000066666ddd000000000d0000d066666666000000001dd7ccc7777222277ff88ff7eeeeeeee7d9dd9d7766dd6677111111777755777
7c7c7dd100dddddddddddd00d666dddd0dd00dd00dd00dd0666666660d0000d01ddddddd77772222ffffffffee5eeeee77dddd77706dd6077711117737555573
c7cccdd10000000000000000ddddddd70dd00dd00dd00dd0dddddddd70dddd071ddddddd7777757777ffffe77eeeeee777dddd7777dddd777d7117d775555557
cccccdd100777777777777007ddddd7700000000000000006666666677000077111111117777b57777f77f777ee77ee7777dd77777d77d77d777777d77577577
1ddc7ccc770000777777777777dddd7770077777777777777760700777777777111111117777777777cccc9777777777bb7777bb0007777797797779777ff777
1dd7c7c770888807777007777dccccd7088070000000000077607007777777771ddddddd777997777cc69c5c77777777bbb7bbbb000000779999999977ffff77
1ddccc7c0878888007078070dca77acd077000000000000077607007770000771ddddddd778888767cc675cc777777777bbbbbb700000007707997077ffffef7
1ddccccc0888888080788808777cc777700007777777777777607007707777071ddccccc880888867ccc67c877755577771b1b777000000077799777fffeefff
1dd7ccc70788887080888808dca77acd770077000000000077607007777007771dd7ccc776688886777cc67777555557773b3b777000000099999999ffeffeff
1ddc7c7c07777770070880707dccccd7700770666666666677607007770000771ddc7c7c7766667677ccc677755555557bbbbbb77000000079111197fefffeff
1ddcc7cc707777077770077777dccd777007066777777777776070077dddddd71ddcc7cc777887777cc6677755055055bbb7bbbb7077077099199199ffffefef
1ddccccc7700007777777777771cc177700706777777777777607007707777071ddccccc77777777cc67777755555555bb777bbb70770770977997797ffffff7
cccc7ccccccc7ccc11111111716cc617770706777777777746444644c00c00cc1111111177c77cc77aa77aa77777777777777777773333337344433777777777
c7c7c7c7c7c7c7c7dddddddd166cc661700706677777777746444644c00700c7ddddddd1c77cc77c7aa77aa77764477777777777333333883324443377777777
7c7ccc7c7c7ccc7cdddddddd116666117007706666666666464446447c7ccc7cddddddd17cc77c7ca99aa99a766444777777c777388333883732443377777777
cccccccccccccccccccccccc161111d1700077000000000046444644cccccccccccccdd1777c7c779999999966644447777cc777388333337337443777777777
ccc7ccc7ccc7ccc7ccc7ccc71666ddd1700007777777777746444644ccc7ccc7ccc7cdd1cc7c77c798899889666d555777cccc77343883337334427777777777
7c7c7c7cdddddddd7c7c7c7c1666ddd10880000000000000464446447c7c7c7c7c7c7dd177c7c77c88888888444555577cccccc7333883437774427777777777
c7ccc7ccddddddddc7ccc7cc7166dd17077070000000000046444644c7ccc7ccc7cccdd177c77c7788888888744555777cccccc7734344337744222777777777
cccccccc11111111cccccccc77111177700777777777777746444644cccccccccccccdd1777c77c7788778877745577777cccc77334447334442222277777777
301002f3f3f3f3f3f3f3f3f3f3f3f3f3f30210f3f3f33030303030303010f3f31030303030303030303030301086272727272727272727272727272727272787
10f3f3f3f3f3f3f3f3f3f3f3f3103030303030303030303030303030101010101010101010101010101010101010101010101010101010101010101010101010
301002f3f3f3f340f3f3f3f3f3f3f3f3f302103131311010101010101010f3401010101030303030303030301006070707070707070707070707070707070705
10f3f3f3f3f3f3f3f3f3d3f3f310303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030f310
301002f3f3f3f3f3f3f3f3f360708090f302020202020202020202020202f3f3f002021030303030303030301006070707070707070707070707070707070705
10f3f3f3f3f3f3f3f3f3f3f3f3103030303030303030303030303030303030303030303030303030303030303030303030303060708090607080906070809010
301002f3f3f3f3f3f340f3f361718191f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f31030303030303030108607070707070707070707070707070717171784
10f3f3f3f3f3f3f3f3f3f3f3f3103030303030303030303030303030303030303030303030303030303030303030303030303061718191617181916171819110
301002f360708090f3f3f3f363838392f3f3f3f3f3f3f3f3f340f3f3f3f3f3f3f3f3f31030303030303030100607070707070707070707070707070510101010
10313131313110101010101010101010101010101010101010101010101010101010101010101010101010101010101010101062738292627382926273829210
301002f361718191f3f3f340f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f31030303030303030100607070707070707070707070707070510303030
303030303030103030303030303030303030303030303030301030303030303030303030303030301021212121212110b0b0b0b0b0b0b0202120202020202110
301002f363838392f3f3f3f2f3f340f3f3f340f3f3f3f3f3f3f3f3f3f3f3f3f340f3f310303030303030301006070707070707070707070767676767f3f3f3f3
f3f3f3f3f3f3103030303030303030303030303030303030303030303030303030303030303030300221210202212110b0b0b0b0b0b0b0202020202020202010
30100240f3f3e0f3f3f340f3f3f340f3f3f3f3f3f3f3f340f3f340f3f3f3f3f3f3f3f31030303030303030100607070707070707070707077707770510f3f3f3
f3f3f3f3f3f31030607080906070809060708090607080903010607080906070809060708090303010f360708090f310b0b0b0b0b0b0b0202020202120202010
301002f3f3f3f3f3f3f3f3f360708090f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f31030303030101010100607070707070707070707070707070510f3f3f3
f3f3f3f3f3f31030617181916171819161718191617181913010617181916171819161718191303010f361718191f310b0b0b0b0b0b0b0111111111111111110
301002f3f3f3f3f3f340f3f361718191f3f3f3f30210101010101010101010101010101010101010862727270707070707070707070707070707070510313131
313131313131101062738292627382926273829262738292101062738292627382926273829210101010627382921010b0b0b0b0b0b0b0f34141414141414110
301002f3f3f3f3f3f3f3f3f363838392f3f3f3f3021030303030103030f3f3f33030303030303010060707070707070707070707070707070707070510303030
30303030303010b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b02020e02020202020b0b0f336f3b0b0114141414141414110
301002f3f3f350111111f3f3f3b4d0f3f3f3f3f3021030303030103030f336f33030303030303067676767676767070707070707070707070707070510303030
303030303030b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b02020202020202020b0b0f337f3b0b0114141414141414110
301002f3f3f301010101f3f3f3f3f3f3023602f3021030303030103030f337f33030303030303010067707770777070707070707070707070707070510303030
30303030303010b0b020202020202020202020202020b0b0b020202020202020202020202020b0b02020202020202020b0b0f3f3f3b0b0111111111111111110
301002f3f3f301010101f3f3f3f3f3f3023702f30210303030301030300202020202020202020210060707070707070707070707070707070707070510303030
30303030303010b0b060708090607080906070809020b0b0b020607080906070809060708090b0b06070809060708090b0b0b0b0b0b0b0607080906070809010
301002f3f3f3f3f3f3f3f3f3f3f3f3f3020202f30210303030301030300202020202020202020210060707070707070707070707070707070707070510303030
30303030303010b0b06171819161718191617181911010b01010617181916171819161718191b0b06171819161718191b0b0b0b0b0b0b0617181916171819110
301002f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f30210303030301030300202103131313131313110060707070707070707070707070707070707070510101010
10101010101010b0b062738292627382926273829210b0b0b010627382926273829262738292b0b06273829262738292b0b0b0b0b0b0b0627382926273829210
1010111111f3f311111111f3f3501111111111110210303030301030300202100101010101010110060707070707070707070707070707070707070510b0b0b0
b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0d3b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b010
1010020202020202021101f3f3f3f3f3f3f30111021030303030103030020210f3f3f3f3f3f3f3100607070707070707f3f30707070707070707070510b0b0b0
b0b0b0b0b0b0b0b0b060708090607080906070809010b0b0b010607080906070809060708090b0b060708090607080906070809060708090b0f1b0b0b0b0b010
3010022121212121021101f3f3f3607080900111021030303030103030020210f3f3f3f3f3f3f31006070707070707f30101f307070707070707070510101010
10101010101010b0b06171819161718191617181911010b01010617181916171819161718191b0b061718191617181916171819161718191b0b0404040b0b010
3010022121212121021101f3f3f3617181910111021010202010103030020210f3f3f3f3f3f3f31006070707070707f30121f307070707070707070510303030
30303030303010b0b060708090607080906070809020b0b0b020607080906070809060708090b0b060708090607080906070809060708090b0b0111111b0b010
3010022121d35021021101f3f3f36273829201110210202020201030300202103131313131313110060707070707f3010101f307070707070707070510303030
30303030303010b0b061718191617181916171819120b0b0b020617181916171819161718191b0b061718191617181916171819161718191b0b0303030b0b010
3010022121212121021101f3f3f3f3f3f3f3011102102020202010303002021001010101010101100607070707f30101013601f3070707070707070510303030
30303030303010b0b062728292627282926272829220b0b0b020607080906070809060708090b0b060708090607080906070809060708090b0b0303030b0b010
301002212121212102110116f3f3f3f3f3f30111021020202020103030020210f3f3f3f3f3f3f3100607070707f3012101372167676707070707070510111111
11111111111110b0b010101010101010101010101020b0b0b020617181916171819161718191b0b061718191617181916171819161718191b0b0111111b0b010
3010020202020202021111111111111111111111021020202020103030020210f3f3f3f3f3f3f3100607070707f3f301010101f3777707070707070510b0b0b0
b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b01020b0b0b020627382926273829262738292b0b062738292627382926273829262738292b0b0404040b0b010
3010101010101010101010101010101010101010511010511010103030020210f3f3f3f3f3f3f31006070707070707f3f3c0f3f3070707070707070510b0b0b0
b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b01020b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0d0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b010
3010d730d730d730d730d730d730d730d730d7300230d730d7301030300202103131311031313110060707070707070707070707070707070707070510111111
f3f31111111110b0b0b0b036b0b0b0b0b010b0b01020b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b010
3010e730e730e730e730e730e730e730e730e7300230e730e7301030300202100101012001010110060707070707070707070707070707070707070510f3f3f3
f3f330303030102020202037202020202010b0b0102020202020202020202020202020202020b0b0202020202020202020202020202020202020202020202010
3010020202020202020202020202020202020202020202020202510202020210f3f3f310f3f3f310851717171717171717171717171717171717178410f3f3f3
f3f330303030101010101010101010101010b0b01010101010101010101010f3f31010202020b0b0202020607080906070809060708090607080906070809010
3010160202020202020202020202020202020202020202020202510202020210f3f3f310f3f3f310101010101010101010101010101010101010101010f3f3f3
f3f330303030b0b0b0b0b0b0b0b0b0b0b0b0b0b0101030303030303030303030303010202020b0b0202020617181916171819161718191617181916171819110
3010d730d730d730d730d730d730d730d730d730d730d730d7301030300202f3f3f3f310f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3
f3f330303030b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b030303030303030303030303010202020b0b0202020627382926273829262738292627382926273829210
3010e730e730e730e730e730e730e730e730e730e730e730e7301030300202f3f3f3f310f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3
f3f3303030301010101010101010101010101010101030303030303030303030303010202020b0b0202020202020202020202020202020202020202020202010
30101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
__label__
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
fffffffffffffffffff00000000000000000000000000fffffffff00000000000000000000000000000000000f0000f00000000000000000000ffffff0ff0000
00000000000000000000000000000000000000000000000000000000000000000000000f00000000000fffffffff0000ffff000000000fff0000000000000000
0000000000000000000000000000000000f0f00000000000000fff0000fff00fffff000000000f0f000000000000000000000000000000000000000000000000
00f0f00000000000000fff0000ffffff000f000000000f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000
000f000000000000000000000000000000000000000000777077700770077000000000000000000000000000000000000000000000000000000fffffffffffff
00000000000000000000000000000000000000000000007070070070007070000000000000000000000fffffffffffffffff0000000000000000000000000000
00000000000000000000000000000000000000000000007770070f70007f70000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000fffffff00000000000070fff7ff7000707000ff00000000000000000000000000000000000000000000000000000000000000
0000000000000000fffffff00000000f00f0000000000070007770077077000000000000000000000000000000000000000000000000000000000000000fff00
00f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fff00000000000000000000000000000000f0
0000000000000000000000000000000000000000000000777007707700077f777f777077700770000000000000000f00000f0000000000000000000000000000
000000000000000000000000000fffffff000000000000777f7f7f7070700f070070007070700000000000000000000000000000000000000000000000000000
0000000000000000fffffff000000ff0000f00000000007070707070707770070077007700777000000000000000000000000000000000000000000000000000
f0ff0000000000000000000000000000000000000000007070707070700070070070007070007000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000707077007070770007007770707077000000000000000000000000000000000fffff00000000000000
000000000000000000000000000000000000000000000000fff0fff0000000000000000000000fffff00000000000000000000000000000ff000000000000000
0000000000000000fff0fff0000000000000000000000fffff000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffff0ffffffffffff
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fff00000000000000000000000000000000000000
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777779777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777779777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777770009997777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777700700777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777707070777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777700700777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777800008877777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777887778877777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777737377777777777777777777777777777777777777777777
77777777777777777777777777777777777777777eee777777777777777777777777777777777777733377777777777777777777777777777777777777777777
7777777777777777777777777777777777777777eeeee77777777777777777777777777777777737303f37777777777777777777777777777777777777777777
77777777777777777777777777777777777777770eee077e77777777777777777777777777777737333337777777777777777777777777777777777777777777
7777777777777777777777777777777777777777e8e8eee777777777777777777777777777777733633367777777777777777777777777777777777777777777
7777777777777777777777777777777777777777efffeee777777777777777777777777777777733366677777777777777777777777777777777777777777777
77777777777777777777777777777777777777777eeeeee777777777777777777777777777777737373777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777e77e7e777777777777c77cc7777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777777777c77cc77c777777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777777777777cc77c7c777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777777777777c7c77777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777777777cc7c77c7777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777c7c77c777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777c77c77777777c77777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777777777777c77c777777cc77777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777777777777777777777cccc7777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777cccccc777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777aa77aa777777777cccccc777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777779977997777777777aa77aa7777777777cccc7777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777779898898977777777a99aa99a77777777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777900550097777777799999999777777777777777777777777888877a7777777777777777777777777777777777777
77777777777777777777777777777777777790088009777777779889988977777777777777777777777780787a97777777777777777777777777777777777777
77777777777777777777777777777777777759955995777777778888888877777777777777777777777888887a97777777777777777777777777777777777777
77777777777777777777777777777777777777588577777777778888888877777644777777777777777668899787777777777777777777777777777777777777
77777777777777777777777777777777777755955955777777777887788777776644477777777777777888899787777777777777777777777777777777777777
77777777777777777777777777777777777759988995777777777777777777766644447777777777777788899787777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777777777777777666d5557777777777777788888877777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777744455557777777777777788788777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777774455577777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777455777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777bbb777777777777777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777b3bbb777777777777777777ccc777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777b3bbb37777777777777777ddcdd77777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777bb373bb377777777777777c8d8c77777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777bbbb7b3b77777777777777ccccc77777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777770b077bb777777777777757cdc757777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777b777777777777777777d55c55d7777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777777777777777777777775dcccd57777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777777777777777777777dcccccd7777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
0000000000000000000000000000000000000000000000000000000000000000000000000000000000f000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000f00f0000000000000000000000000000000000000000000000
000000000f000000000000000000000000000000000000000000000000f00000000000000000000000000000000000000000000000000f000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f00000000000000000000
00000000000000000000000000000000000000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000f00000000000f00000000000000000000000000000000000000000000000000000f0000000000000000000000000
000000000000000000000000000000000000000000000000000000000f0000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000f0000000000000000000000000000000000000f0000000000000000000000000000000000
00000000000000000000000000000000000000777000007770077000f007700770770077707770770070707770000f0000000000000000000000000000000000
0000f0f000000000000000000000000000000000700000f700707000007000707070700700070070707070700000000000000000000000000000000000000000
0000000f000f00000000000000000000000000070000000700707000007000707070700700070070707070770000000000000000000000000000000000000000
0000000000000000000000000000000000000070f000000700707000f07000707070700700070070707070700000000000000000000000000000000000000000
00000000000000000000000000000000000000777000000700770000000770770070700700777070700770777000000000000000000f00000000000000000000
000000000000000000000000000f0000000000000000000000f0000000000000000ff00f00000000f000000000f0000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000f00000000000000000000000000000000000000000000000000f000000000000f00000000
0000000000000f000000000000000000000000000000000000000f0f000000000000000000000000000000000f00000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000f000f00f0000000000000000f0f0000000000000000000000000000000000000000000000
00f000f00000000000f000000000000000000000000000000000000000000000000000000f000000000000000000000000000000000000000000000000000000
0000000000000000000000000000f0f00f000000000000000f000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000f00000000000000000000000000000000f0000000000f0000000000000000000000000000000000000000f0f0000
00000000000000000000000000000000000000000f000000f0000f00000000000000000000000000000000000000000000000000000000000000000000000000
77777777777777777777777777777700070007007707777777000707077777070700070007007770070707000700770007777777777777777777777777777777
77777777777777777777777777777777070707707707777777070707077777070707770707070707770707070707077077777777777777777777777777777777
77777777777777777777777777777700070707707700077777007700077777000700770007070707770007000707077077777777777777777777777777777777
77777777777777777777777777777707770707707707077777070777077777070707770707070707770707070707077077777777777777777777777777777777
777777777777777777777777777777000700070f0700077777000700077777070700070707000770070707070707077077777777777777777777777777777777

__gff__
0002000000020202020200000202020200020002000202020002020202020202000000000000020002020202020000020000000000000202020002020000000000020200020200020400000200000000040202020202020204000200000000000402020200000002040000000000000204040402000000040400000000020200
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
020201020202020202020202020202010202020202020103030303031a1a1a1a3b3b3b3b3b463b461a1a1a1a1a1a1a3b3b3b463b463b461a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
020201020202020202020202020202010202020202020103030303031a1a1a1a4441423b3b563b561a1a1a1a1a1a1a45453b563b563b561a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a3030301a1a1a1a303030303030303030303030303030533f3f3f1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
010101010101010101010101010101010101010202020103030303031a1a1a1a5451520b0b0b0b3d1a1a1a1a1a1a1a55550b1d670b0b3e1a1a1a1a1a1a1a1a1a1a1a1a1a1a3f3f3f3f3f3f3f1a1a1a1a3030301a1a1a303030303030303030303030301a1a1a1a6840781a1a1a1a1a1a1a1a303f30301a1a1a303f3f3e1a1a1a
030301023f043f3f043f043f3f043f3f0402010202020103030303031a1a1a1a0b0b0b0b0b0b0b0b1a1a1a1a1a1a1a0b0b0b0b0b0b0b0b1a1a1a1a1a1a1a1a1a1a1a1a1a1a3f3f3f3e3f3f3f1a1a1a1a30301a1a1a1a303030301a1a1a1a1a1a1a1a1a1a1a1a1a5840481a1a1a1a1a1a1a1a3f30303f1a1a1a3f303f3f1a1a1a
030301023f04043f3f3f3f060708093f3f02010202020103030303031a1a1a1a0b0b0b1d0b0b0b0b1a1a1a1a1a1a1a0b0b2d1b1c2d0b0b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a3f3f3f3f3f1a1a1a1a1a303030305330303030301a1a1a1a1a1a1a1a1a1a1a1a1a3f3f3f1a1a1a3030303f3030303f301a1a1a3f3f3f301a1a1a
030301023f3f3f633f043f161718193f3f02010202020103030303031a1a1a1a0b0b0b1e0b0b0b0b1a1a1a1a1a1a1a610b2d2b2c2d0b0b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a3f3f3f001a1a1a1a1a30301a1a1a1a30303030533f3f3f1a1a1a1a1a303030533f3f3f303f3030303030303f303f301a1a1a3030303f1a1a1a
030301023f3f3f73043f05262728293f3f02010202020103030303031a1a1a1a2a0b0b0b0b0b470b1a1a1a1a1a1a1a0b0b0b0b0b0b0b0b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a3f00001a1a1a1a1a30301a1a1a1a1a303030533f633f1a1a1a1a303030301a1a1a1a1a1a1a3f3f301a1a1a1a30301a1a1a1a30301a1a1a1a
030301023f3f3f3f043f3f043f39393f3f02010202020103030303031a1a1a1a3a0b0b0b0b0b570b1a1a1a1a1a1a1a0b0b0b0b0b0b0b0b1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a3f1a1a1a1a1a303030301a1a1a1a1a303030533f733f1a1a1a30303030301a1a1a1a1a1a1a3030301a1a1a1a303f1a1a1a1a3f3f1a1a1a1a
03030102043f3f3f3f3f3f3f3f3f3f040402010202020103030303031a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a2e2e1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a53301a1a1a30303030301a1a1a1a1a303030533f3f3f1a1a1a30303030301a1a1a1a1a1a1a303f301a1a1a1a30301a1a1a1a30301a1a1a1a
030301023f3f3f3f043f3f3f043f04040402010202020103030303031a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a303030301a30303030301a1a1a1a1a3030301a1a1a1a1a1a1a30303030301a1a1a1a1a1a1a3f30301a1a1a1a303f30303030303f1a1a1a1a
010101010101030303010101010101010101010303030103030303031a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a303030303030303030301a1a1a1a1a3030301a1a1a1a1a1a3030303030301a307f306872727240727272781a3f30303f30303f301a1a1a1a
010202020201030303010202020202020202010303030103030303031a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a303030303030303030301a1a1a1a1a30301a1a1a1a1a1a3030303030301a7f627f6070717140717170501a1a1a1a1a1a1a1a1a1a1a1a1a
010202020201030303010202020202020202010303030103030303031a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a3030303030301a1a1a1a1a30301a1a1a1a1a1a3030301a1a1a1a307f3058481a30303f1a58481a1a1a1a1a1a1a1a1a1a1a1a1a
010202020201030303010202020202020202010303030103030303031a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a30305330303030303030301a1a1a1a1a1a1a1a1a1a3030301a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
010202020201030303010202020202020202010303030103030303031a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000001a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a303030303030301a1a1a1a1a1a1a1a1a1a1a303f301a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
010202020201030303010202020202020202010303030103030303031a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000001a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a3f3f301a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
01010101010103030301010101010101010101010101010303030303030303030303030303030303030303030303030303030303030303030303030303030303030000000003011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a3f30301a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
01120202021204040402020202020202020201020202010303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a303f303f30303f303f3030303f1a1a1a1a1a1a
01020202020204040402021212121212120201020202010303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a30303f303f303f30303f303f301a1a1a1a1a1a
0102020202020404040202126872727812020102020201030303030303030303030303030303010101010101010101010101010101010101010101010101010101010101010101010101010101011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a303f303f3f0c1a1a1a1a1a1a
0112020202120404040202126070705012020102020201010101010101010101010103030303010303030303030303030303030303030303030303030303030303030303030303030303030303011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a303f3f303f3f1a1a1a1a1a1a
010101010101040404020212607070501202010202023f3f3f3f3f3f3f3f3f3f3f0101010101010303030303030303030303030303030303030303030303030303030303030303030303030303010101010101010101010101010101011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a3f30303f303e1a1a1a1a1a1a
010303030301040404020212607070501202010202023f3f3f3f3f3f3f3f3f3f3f0303030303010303030303030303010101010101010101010303030303030303030303030303030303030303010303030303030303030303030301011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
01030303030104040402021258717148120201131313013f3f3f3f3f3f3f3f3f3f3f3f3f0303010303030303030303010303030303030303010303030303030303030303030303030303030303010303030303030303030303030301011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
01030303030104040402021212121212120202020202010101010101010101010103033f0303010303030303030303010303030303030303010303030303030303030303030303030303030303010303030303030303030303030301011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
01030303030104040402020202020202020202020202013f3f3f3f3f3f3f3f3f0103033f03030101010101010101010103033f3f3f030303010101010101010101010101010101010101010101010303030303030303030303030301011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
01010101010103030301010101010101010101010101010101010101010101010103033f03030303030303030303030303033f633f030303030303030303030303030303030303030303030303010303030303030303030303030303011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
03010202020103030301040412040412040401030303030303030303033f3f3f0103033f03030303030303030303030303033f733f030303030303030303030303030303030303030303030303010303030303030303030303030303011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
03010202020103030301041204121204120401030303030303030303033f3f04013f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f030303030303030303010303030303030303030303030303011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
030102020201030303011204041212040412013f3f3f03030303030303013f3f01030303030303030303030303030303030301130103030303030303030303030303033f030303030303030303010303030303030303030303030303011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
030101010101030303010101010101010101013f633f0303030303030301043f010303030303030303030303030303030303013f0103030303030303030303030303033f030301010101010101010303030303030303030303030303011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
0301203f3f3f043f043f3f3f3f3f3f3f6120013f733f03030303030303013f3f010303030303030303030303030101010101013f0101010101010101010101010101013f01013f3f3f3f3f3f3f010303030303030303030303030303011a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a
__sfx__
010100000e07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800103237529305293752f305323753030530375000002637500000283750000030375000002f37500000263752930528375000002d375000002b375000002637500000243750000024375000002337500000
012000000e3700e3700e3700e3700e3700e3700e3700e370103701037010370103701037010370103701037011370113701137011370113701137011370113701337013370133701337013370133701337013370
012000002907029070210702107023070230702407029070280702807023070230701f0701f07021070230702d0702d070260702607024070240702f0702b0702b0702b070290702807026070260702607029070
012000002642126421264212642129421294212942129421284212842128421284212b4212b4212b4212b421294212942129421294212d4212d4212d4212d4212b4212b4212b4212b4212f4212f4212f42130421
001000000b6150a625066350462502615016000360000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000100742107420074230742307423074230742307423074200742007422074200742007420074230742307655054000000000000000000000000000000000000000000000000000000000000000000000000
011000000732502305073250732507325023050732507325073250000507325073250732500005073250732507325000050732507325073250000507325073250732500005073250732507325003050732507325
011000000762502605076250762507625026050762507625076250060507625076250762500605076250762507625006050762507625076250060507625076250762500605076250762507625006050762507625
01100000133250e3051332513325133250e3051332513325133250c0051332513325133250c0051332513325133250c0051332513325133250c0051332513325133250c0051332513325133250c3051332513325
0110002026330263002d3002120021200293002933529335293302b0001d200243002b330243002430024300283302930029300283002d3002430024335243352433000000102002130021330112051a2051a205
0110002029330263002d3002120021200293002d3352d3352d3302b0001d20024300303302430024300243002b3302930029300283002d3002430028335283352833000000102002130024330112051a2051a205
011000002b33529305283052833524305263052433500000293352630523305263350000022305293350000028335000000000024335000001f3051f33500000263350000024305203351f305000001d33500000
011000003033500000000002b335000050000528335000052c33500005000052933500005000052c335000052b335000050000528335213050000524335000052933500005000052633500005223052233500005
011000000c075180051000510075000000000013075140050b0750b005000000e07500000000001107500000080750c005000000c07500000000000f075000000707500000000000b0750e005000000e07500000
011000080000000000000000000011675000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010700100265500000026050000002655026050260500000026550000000000000000265502605026550265500000000000000000000000000000000000000000000000000000000000000000000000000000000
010e00200c3750c37513372133020c3750c375143720c3050c3750c37513372133020c3750c3750b3720b3000c3750c37513372133020c3750c375143720c305183701837018370183000c3700c3700c3000c300
010e00201037510375183722430010375103751b37216302103751037518372243001037510375143720e3001037510375183722430010375103751b3721d302163001d300153002130021300213001330513300
010e00100437000000000000230004370043000000002300043700000000000000000437000000043750437000000000000000000000000000000000000000000000000000000000000019300000000000000000
010e00201337513375143001530013375133751b302183051337513375183021f30213375133751d302183051337513375183021f30213375133751d302183051b3401b3401b3401830013340133400c3000c300
010e00201337513375143001530013375133751b302183051337513375183021f30213375133751d302183051337513375183021f30213375133751d302183051f3401f3401f3401130013340133400c3000c300
010e00200c3750c37513372133020c3750c375143720c3050c3750c37513372133020c3750c3750b3720b3000c3750c37513372133020c3750c375143720c305183701837018370183000c3700c3700c3000c300
011000003037500000000002b375000050000528375000052c37500005000052937500005000052c375000052b37500005000052837521305000052437528305293752830527305293752b3052c3052237500005
000200001b5402a530000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011f00001c5721c5621c5521c5422657226562265522654228572285722856228562285522855228542285422357223562235522354226572265621f55226542285722b5622b5522b54226572265622857228562
010d00002b5752b5052b505295752950529505285752650526505265752d5052f505305752f5052b5052d5752f505285002f57529505245052b57526505000002857528502245050000026505000002650500000
010f00200e513000030e503000030e615000030e513000030e513000030e503000030e513000030e503000030e513005030e503005030e615005030e513005030e6150e5030e5130e5030e5130e5030e5130e513
010a00001a5351c5001a5001a5001a53500000000000000018535000001a5351a5051a5051a5051a535000051a5350000500005180051a5350000000000000001853524000000001a0051a535000000000000600
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011e0000215451c203185451a2051a54523000235451d2051f5451c5051a5451c505185451a2051a2051f5451d5451c200185451a20517545230001d5451d2051c5451c5052054511505215451a205175051f545
011e0000215451c203185451a2051a54523000235451d2051f5451c5051a5451c505185451a2051a2051f5451d5451c200185451a20517545230001d5451d2051c5451c505175451c105185451a205175051f545
011e000011010110101101011010070100701007010070100b0100b0100b0100b0100c0100c0100c0100c0100501005010050100501004010040100401004010070100701007010070100b0100b0100b0100b010
011e000011010110101101011010070100701007010070100b0100b0100b0100b0100c0100c0100c0100c01005010050100501005010130101301013010130101401014010140101401015010150101501015010
011e0000211112111121111211111a1111a1111a1111a1111f1111f1111f1111f111181111811118111181111d1111d1111d1111d111171111711117111171111c1111c1111b1101b1101c1101d1101f11018110
013c001011010110101101011010100101001010010100100e0100e0100e0100e0100c0100c0100c0100c0100b0000b0000b0000b000090000900009000090000b0000b0000b0000b0000c0000c0000c0000c000
013c0000215451c203185451a2051a54523000235451d2051f5451c5051a5451c505185451a2051a2051f5451d5451c200185451a20517545230001d5451d2051c5451c5052054511505215451a205175051f545
00030000125700c170135701657019570111701a5701b5701c1701b5701c5701a1701d5701f5702057022570245702e1702657028170285702b5702f1702e5703057033570335703357034570345703457034570
010400001c17328670286502864028630286200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c000c2807624000280762400028006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400000f3701137017570143701e5701a3701d3702457024370265702b370295702d3702a5702d570320702f57031570355703a570015000150002500025000250002500025000250002500025000250000000
00090000335702f5702c5702857025570225701d5701b5701757012570115700e5700b57008570055700457002570015700000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000c57013570185701c570175701c57022570265702757026570285702d5701f570315702b5002e500255002650027500295001f1002b5001f5002d5002e5001f500305001f5003350035500395003d500
000100000937008370063700437004370043700237001370013700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000190701c07021070260702d07032070360703c070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100002475007100021002960023600036000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
03 02030444
01 07480946
00 070b0a09
02 070a0b09
01 0c0d0e0f
02 0c170e0f
01 50111410
02 50161510
00 1b201f22
01 5b231e62
02 5b231e22
00 28424344
00 41424344
00 41424344
03 27424344
00 41424344
00 41424344
00 41424344
00 41424344
03 07080106
00 41424344
00 41424344
01 10111444
03 0c0d0e0f

