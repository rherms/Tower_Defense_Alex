Worm = {}

function Worm:new(params)

	local worm = display.newImage( "img/worm.png", 800, 1100 )
	worm.destroyed = false
	
	local randScale = math.random(10, 30) / 10
	worm.xScale = randScale
	worm.yScale = randScale
	
	local randAngle = math.random(0, 359);
	worm.x =  math.cos( math.rad( randAngle ) ) * (_W / 2 + 100) + _W / 2
	worm.y = -math.sin( math.rad( randAngle ) ) * (_H / 2 + 100) + _H / 2
	
	worm.targetX = params.targetX
	worm.targetY = params.targetY
	
	--real angle (movement angle)
	worm.angle = utils.getAngle( worm.x, worm.y, worm.targetX, worm.targetY )

	--rotation image object
	--worm.rotation = worm.angle - 180
	--worm.speed = math.random(2, 5) + 0
	worm.speed = 3

	function worm:enterFrame(e)
		if (self.destroyed ) then
			self:destroy()
			return true
		end
		if ( self:isOut() ) then
			self:kill()
		end
		
		--calculate offset
		self.dx = math.cos( math.rad( self.angle) ) * self.speed
		self.dy = math.sin( math.rad( self.angle) ) * self.speed
		
		--moving
		self.x = self.x + self.dx
		self.y = self.y + self.dy
		
	end
	
	function worm:kill()
		self.destroyed = true
	end
	
	function worm:destroy()
		Runtime:removeEventListener("enterFrame", self)	
		self:removeSelf();

		for i=#enemies,1,-1 do
    		if enemies[i] == self then
        		table.remove(enemies, i)
        		return
   			end
		end

	end
	
	function worm:isOut()
		local offset = 200
		return ( (self.x < -offset) or (self.x > _W + offset) or (self.y < -offset) or (self.y > _H + offset) )
	end
	
	Runtime:addEventListener('enterFrame', worm)
	
	return worm
end

return Worm