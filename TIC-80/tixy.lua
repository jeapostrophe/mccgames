-- title:  tixy for tic-80
-- author: @jeapostrophe
-- desc:   tixy.zone for tic-80
-- script: lua

-- INPUT:
-- t is the time (in seconds)
-- i is the cell of the grid
-- x is the col
-- y is the row

-- OUTPUT:
-- positive is white
-- negative is red
-- size is the absolute value
function TIXY(t,i,x,y)
	return math.sin(t)
	-- return x/16.0

	-- return y/16.0

	-- return y-7.5

	-- return y - t

	-- local a={1, 0, -1}
	-- return a[1+i%3]
	
	-- return math.sin(t-math.sqrt((x-15)^2+(y-8.5)^2))
	
	-- return math.sin(y/8.5 + t)
	
	-- return y - x
	
	-- return (i & x & y)
	
	-- return math.sin(i^2)
	
	-- return math.cos(t+i+x*y)
	
	-- return math.sin(x/2) - math.sin(x-t) - y+6
	
	-- return (x-8)*(y-8) - math.sin(t)*64
	
	-- return -.4/hypot(x-t%10, y-t%8)-t%2*9
	
	-- return math.sin(t-hypot(x,y))
	
	-- return (((x-8)/y+t*5)/y*8)*y/5
	
	-- return y-t*3+9+3*math.cos(x*3-t)-5*math.sin(x*7)
	
	-- return 1/32*math.tan(t/64*x*math.tan(i-x))
	
	-- return 8*t%13 - hypot(x-7.5, y-7.5)
	
	-- return math.sin(2*math.atan((y-7.5)/(x-7.5))+5*t)
end

-- Don't change after this

function hypot(x, y)
 return math.sqrt(x^2+y^2)
end

f=0
function TIC()
 -- Draw
	cls()
	local t=f/60
	for x=0,15 do
		for y=0,15 do
			local i=y*8+x
			local r=TIXY(t,i,x,y)
			local c=12
			if r < 0 then
				c=2
				r=-r
			end
			if r > 1 then
				r=1
			end
			local xp=(7+x)*8+4
			local yp=(0.5+y)*8+4
			local rx=r*3.5
			circ(xp, yp, rx, c)
		end
	end
	-- Update
	f=f+1
end
-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

