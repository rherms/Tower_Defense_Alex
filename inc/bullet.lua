Bullet = {}

function Bullet:new(params)
    local bullet = {}
	
	--create a shape
	bullet = display.newCircle( 500, 500, 5 )
	globalSceneGroup:insert(bullet)
	bullet:setFillColor( black )
	--bullet = display.newImage("img/rock.png")
	--bullet.width = 24
	--bullet.height = 24
	bullet.destroyed = false
	
	bullet.damage = params.damage
	bullet.x = params.x
	bullet.y = params.y
	bullet.rotation = params.angle;
	bullet.speed = 50;
	bullet.enemiesHit = 0

	function bullet:enterFrame(e)
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
	
	
	function bullet:destroy()
		Runtime:removeEventListener("enterFrame", self)
		self:removeSelf();
		self = nil
	end
	
	function bullet:isOut()
		return ( (self.x < -100) or (self.x > _W + 100) or (self.y < -100) or (self.y > _H + 100) )
	end
	
	function bullet:checkCollision()
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
			end
		end
	end
	
	Runtime:addEventListener('enterFrame', bullet)
	
	return bullet
end

return Bullet