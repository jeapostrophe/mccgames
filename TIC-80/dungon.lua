-- title:  fast textured raycaster
-- author: DevEd
-- desc:   fast textured raycaster using textri()
-- script: lua

t = 0

posX = 9.5
posY = 10.5
dirX = -1
dirY = 0
planeX = 0
planeY = 0.66

currenttime=time()
oldtime=0
fps=0
minfps=1000
maxfps=0

w = 240
h = 136

texOffset=0
texScale=4/3

keyboardControls = true
debugmode = false

playStepSound=0

function TIC()
	cls(0)
	
	for x = 0,w do
		-- calc ray position and direction
		cameraX = 2*x/w-1
		rayDirX = dirX+planeX*cameraX
		rayDirY = dirY+planeY*cameraX
		-- where we are in the map
		mapX = math.floor(posX)
		mapY = math.floor(posY)
		-- length of ray from current pos to next x or y side
		sideDistX = 0
		sideDistY = 0
		-- length of ray from one x or y side to next x or y side
		deltaDistX = math.abs(1/rayDirX)
		deltaDistY = math.abs(1/rayDirY)
		perpWallDist = 0
		-- what direction to step in X or Y (+ or - 1)
		stepX = 0
		stepY = 0
		hit = false -- have we hit a wall?
		side = 0 -- was a NS or EW wall hit?
		-- calculate step and initial sideDist
		if rayDirX < 0 then
			stepX = -1
			sideDistX = (posX-mapX)*deltaDistX
		else
			stepX = 1
			sideDistX = (mapX+1-posX)*deltaDistX
		end
		if rayDirY < 0 then
			stepY = -1
			sideDistY = (posY-mapY)*deltaDistY
		else
			stepY = 1
			sideDistY = (mapY+1-posY)*deltaDistY
		end
		-- perform DDA
		for drawdist=0,50 do
			if hit==false then
				-- jump to next map square
				if sideDistX < sideDistY then
					sideDistX = sideDistX+deltaDistX
					mapX = mapX+stepX
					if mapX>posX then side=2 else side=0 end
				else
					sideDistY = sideDistY+deltaDistY
					mapY = mapY+stepY
					if mapY>posY then side=1 else side=3 end
				end
				-- check if ray has hit wall
				if mget(mapX%240,mapY%136) > 0 then hit=true end
			end
		end

		-- calculate distance projected on camera direction
		if side == 0 or side==2 then
			perpWallDist = (mapX-posX+(1-stepX)/2)/rayDirX
		else
			perpWallDist = (mapY-posY+(1-stepY)/2)/rayDirY
		end
		-- calculate height of line
		lineHeight = h/perpWallDist
		
		-- calculate lowest and highest pixel to fill
		wallHeight=175
		drawStart = 68-((lineHeight/(2+h)/2)*wallHeight)
		--if drawStart < 0 then drawStart = 0 end
		drawEnd = 68+((lineHeight/(2+h)/2)*wallHeight)
		--if drawEnd >= h then drawEnd = h-1 end
		
		-- get texture
		textureSize=6
		texNum = mget(mapX%240,mapY%136)
		-- calculate wallX
		if side == 0 or side==2 then
			wallX = posY+perpWallDist*rayDirY
		end
		if side == 1 or side==3 then
			wallX = posX+perpWallDist*rayDirX
		end
		-- get X coordinate of texture
		texX = wallX*textureSize
		if (side==0 or side==2) and rayDirX > 0 then texX = textureSize-texX-1 end
		if (side==1 or side==3) and rayDirY < 0 then texX = textureSize-texX-1 end
		if side>1 then texOffset=-4/3 else texOffset=0 end
		texpos=(-texX*(texScale)+texOffset)%8+(texNum*8)
		if hit then textri(240-x,drawStart,241-x,drawStart,241-x,drawEnd,texpos,texNum//16*8,texpos,texNum//16*8,texpos,texNum//16*8+8,false,0) end
	end
	
	-- get FPS (TODO)
	oldtime=currenttime
	currenttime=time()
	fps=(1/(currenttime-oldtime))*1000
	if fps < minfps then minfps=fps end
	if fps > maxfps then maxfps=fps end
	if maxfps > 100 then maxfps=0 end
	
	-- speed modifiers
	moveSpeed = 0.05
	strafeSpeed = 0.04
	rotSpeed = 0.0375
	-- move forward/backward
	isMoving=0
	if keyboardControls then btnOn = key(23) else btnOn = btn(0) end
	if btnOn then
		if mget(math.floor(posX+dirX*moveSpeed)%240,math.floor(posY)%136) == 0 then posX = posX+(dirX*moveSpeed) end
		if mget(math.floor(posX)%240,math.floor(posY+dirY*moveSpeed)%136) == 0 then posY = posY+(dirY*moveSpeed) end
		isMoving=1
	end
	if keyboardControls then btnOn = key(19) else btnOn = btn(1) end
	if btnOn then
		if mget(math.floor(posX-dirX*moveSpeed)%240,math.floor(posY)%136) == 0 then posX = posX-(dirX*moveSpeed) end
		if mget(math.floor(posX)%240,math.floor(posY-dirY*moveSpeed)%136) == 0 then posY = posY-(dirY*moveSpeed) end
		isMoving=1
	end
	-- rotation
	if keyboardControls then btnOn = key(60) else btnOn = btn(2) end
	if btnOn then
		oldDirX = dirX
		dirX = dirX*math.cos(-rotSpeed)-dirY*math.sin(-rotSpeed)
		dirY = oldDirX*math.sin(-rotSpeed)+dirY*math.cos(-rotSpeed)
		oldPlaneX = planeX
		planeX = planeX*math.cos(-rotSpeed)-planeY*math.sin(-rotSpeed)
		planeY = oldPlaneX*math.sin(-rotSpeed)+planeY*math.cos(-rotSpeed)
	end
	if keyboardControls then btnOn = key(61) else btnOn = btn(3) end
	if btnOn then
		oldDirX = dirX
		dirX = dirX*math.cos(rotSpeed)-dirY*math.sin(rotSpeed)
		dirY = oldDirX*math.sin(rotSpeed)+dirY*math.cos(rotSpeed)
		oldPlaneX = planeX
		planeX = planeX*math.cos(rotSpeed)-planeY*math.sin(rotSpeed)
		planeY = oldPlaneX*math.sin(rotSpeed)+planeY*math.cos(rotSpeed)
	end
	-- strafe
	if keyboardControls then btnOn = key(1) else btnOn = btn(6) end
	if btnOn then
		oldDirX = dirX
		oldDirY = dirY
		dirX = dirX*math.cos(-math.pi/2)-dirY*math.sin(-math.pi/2)
		dirY = oldDirX*math.sin(-math.pi/2)+dirY*math.cos(-math.pi/2)
		if mget(math.floor(posX+dirX*moveSpeed)%240,math.floor(posY)%136) == 0 then posX = posX+(dirX*moveSpeed) end
		if mget(math.floor(posX)%240,math.floor(posY+dirY*moveSpeed)%136) == 0 then posY = posY+(dirY*moveSpeed) end
		dirX=oldDirX
		dirY=oldDirY
		isMoving=1
	end
	if keyboardControls then btnOn = key(4) else btnOn = btn(7) end
	if btnOn then
		oldDirX = dirX
		oldDirY = dirY
		dirX = dirX*math.cos(math.pi/2)-dirY*math.sin(math.pi/2)
		dirY = oldDirX*math.sin(math.pi/2)+dirY*math.cos(math.pi/2)
		if mget(math.floor(posX+dirX*moveSpeed)%240,math.floor(posY)%136) == 0 then posX = posX+(dirX*moveSpeed) end
		if mget(math.floor(posX)%240,math.floor(posY+dirY*moveSpeed)%136) == 0 then posY = posY+(dirY*moveSpeed) end
		dirX=oldDirX
		dirY=oldDirY
		isMoving=1
	end
	if isMoving==1 then
		if playStepSound==0 then
			playStepSound=1
			sfx(1)
		end
	else
		playStepSound=0
		sfx(0,0,0)
	end
	-- end of frame
	t=t+1
end

function OVR()
	poke(0x3fc0,0)
	poke(0x3fc1,0)
	poke(0x3fc2,0)
	if debugmode then
		printoutline("xpos: "..posX,1,1,15)
		printoutline("ypos: "..posY,1,9,15)
	end
end

function SCN(x)
	-- sky
	if x<68 then
		poke(0x3fc0,0)
		poke(0x3fc1,x*3.75)
		poke(0x3fc2,255)
	-- floor
	else
		poke(0x3fc0,151)
		poke(0x3fc1,86)
		poke(0x3fc2,29)
	end
end

function printoutline(a,b,c,d)
	print(a,b-1,c-1,0)
	print(a,b,c-1,0)
	print(a,b+1,c-1,0)
	print(a,b-1,c,0)
	print(a,b+1,c,0)
	print(a,b-1,c+1,0)
	print(a,b,c+1,0)
	print(a,b+1,c+1,0)
	print(a,b,c,d)
end

function getpix(t,x,y)
    local addr=0x4000+(32*t) -- get sprite address
    return peek4(addr*2+x%8+y%8*8) -- get sprite pixel
end

-- <TILES>
-- 001:faafffafa4666644f6664664f4444444affffafa664a6666664a6466444a4444
-- 002:faafffafa9eeee99feee9ee9f9999999affffafaee9aeeeeee9ae9ee999a9999
-- 003:faafffafa5bbbb55fbbb5bb5f5555555affffafabb5abbbbbb5ab5bb555a5555
-- 004:faafffafa2888822f8882882f2222222affffafa882a8888882a8288222a2222
-- 005:ffdfdd8dfdfdd8d8dfdd8d88fdd8d888dd8d8882d8d888288d888282d8882822
-- 006:7777777737a77a777777777a77777777a77a77777777737777a777773777777a
-- 007:77767777379e9a7776efe67a77999777a77417777771137777a777773777777a
-- 255:faeeefafaeeeee44e11111e4e11e11e4eeeeeeea6e1e1e6666e1e466444a4444
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- 001:d000e0f0f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f0000000000f0f00
-- </SFX>

-- <PALETTE>
-- 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cff85c26dc2cadad45edeeed6
-- </PALETTE>

