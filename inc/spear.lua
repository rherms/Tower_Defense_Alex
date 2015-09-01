Spear = {}

function Spear:new(params)
    local spear = {}
	
	spear = display.newImage("img/spear.png")
	spear.width = 24
	spear.height = 24
	spear.destroyed = false
	
	spear.damage = params.damage
	spear.x = params.x
	spear.y = params.y
	spear.piercingLevel = params.piercingLevel
	spear.rotation = params.angle;
	spear.speed = 50;
	spear.enemiesHit = 0
	
	function spear:enterFrame(e)
		if not paused then 
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
			
			--moving
			self.x = self.x + self.dx
			self.y = self.y + self.dy
			
			self:checkCollision()
		end
	end
	
	
	function spear:destroy()
		Runtime:removeEventListener("enterFrame", self)
		self:removeSelf();
		self = nil
	end
	
	function spear:isOut()
		return ( (self.x < -100) or (self.x > _W + 100) or (self.y < -100) or (self.y > _H + 100) )
	end
	
	function spear:checkCollision()
		if (#enemies > 0) then
			for key, enemy in pairs( enemies ) do
				--if (enemy.x) then --if enemy was deleted
					local distance = utils.getDistance( self.x, self.y, enemy.x + enemy.width, enemy.y + enemy.height)
					if ( distance < (24 * enemy.xScale / 2 + self.width) ) then
						if self.enemiesHit >= self.piercingLevel + 1 then
							self.destroyed = true
						else
							enemy:hit(self)
						end
					end
				--end
			end
		end
	end
	
	Runtime:addEventListener('enterFrame', spear)
	
	return spear
end

return Spear