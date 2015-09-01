Fireball = {}

function Fireball:new(params)
    local fireball = {}
	
	--create a shape
	
	fireball = display.newImage("img/fireball.png")
	globalSceneGroup:insert(fireball)
	--fireball.width = 24
	--fireball.height = 24
	fireball.destroyed = false
	
	fireball.damage = params.damage
	fireball.x = params.x
	fireball.y = params.y
	fireball.rotation = params.angle;
	fireball.speed = 10;
	fireball.range = params.range
	fireball.distanceTraveled = 0
	fireball.enemiesHit = 0
	
	function fireball:enterFrame(e)
		if not paused then 
			--check to see if the fireball is out of range
			if self.distanceTraveled >= self.range then
				self:destroy()
				return true
			end
			if (self.destroyed ) then
				self:destroy()
				return true
			end
			
			--check object coordinates
			if ( self:isOut() ) then
				self.destroyed = true
			end
		
			--calculate offset
			self.dx = math.cos( math.rad( self.rotation) ) * self.speed
			self.dy = math.sin( math.rad( self.rotation) ) * self.speed
			
			origX = self.x
			origY = self.y
			--moving
			self.x = self.x + self.dx
			self.y = self.y + self.dy
			
			self.distanceTraveled = self.distanceTraveled + utils.getDistance(origX, origY, self.x, self.y)

			self:checkCollision()
		end
	end
	
	
	function fireball:destroy()
		Runtime:removeEventListener("enterFrame", self)
		self:removeSelf();
		self = nil
	end
	
	function fireball:isOut()
		return ( (self.x < -100) or (self.x > _W + 100) or (self.y < -100) or (self.y > _H + 100) )
	end
	
	function fireball:checkCollision()
		if (#enemies > 0) then
			for key, enemy in pairs( enemies ) do
				--if (enemy.x) then --if enemy was deleted
					local distance = utils.getDistance( self.x, self.y, enemy.x + enemy.width, enemy.y + enemy.height)
					if ( distance < (24 * enemy.xScale / 2 + self.width) ) then
						self.destroyed = true;
						if self.enemiesHit == 0 then
							enemy:hit(self)
						end
					end
				--end
			end
		end
	end
	
	Runtime:addEventListener('enterFrame', fireball)
	
	return fireball
end

return Fireball