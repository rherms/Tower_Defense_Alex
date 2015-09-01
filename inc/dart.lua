Dart = {}

function Dart:new(params)
    local dart = {}
	
	dart = display.newImage("img/dart.png")
	dart.width = 24
	dart.height = 24
	dart.destroyed = false
	
	dart.damage = params.damage
	dart.x = params.x
	dart.y = params.y
	dart.piercing = params.piercing
	dart.rotation = params.angle
	dart.speed = 20
	dart.enemiesHit = 0
	
	function dart:enterFrame(e)
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
	
	
	function dart:destroy()
		Runtime:removeEventListener("enterFrame", self)
		self:removeSelf();
		self = nil
	end
	
	function dart:isOut()
		return ( (self.x < -100) or (self.x > _W + 100) or (self.y < -100) or (self.y > _H + 100) )
	end
	
	function dart:checkCollision()
		if (#enemies > 0) then
			for key, enemy in pairs( enemies ) do
				--if (enemy.x) then --if enemy was deleted
					local distance = utils.getDistance( self.x, self.y, enemy.x + enemy.width, enemy.y + enemy.height)
					if ( distance < (24 * enemy.xScale / 2 + self.width) ) then
						self.destroyed = true
						if self.enemiesHit == 0 then
							enemy:hit(self)
						end
					end
				--end
			end
		end
	end
	
	Runtime:addEventListener('enterFrame', dart)
	
	return dart
end

return Dart