IceShot = {}

function IceShot:new(params)
    local iceShot = {}
	
	--create a shape
	iceShot = display.newCircle( 500, 500, 5 )
	globalSceneGroup:insert(iceShot)
	iceShot:setFillColor( 0, 255, 255 )
	--iceShot = display.newImage("img/rock.png")
	--iceShot.width = 24
	--iceShot.height = 24
	iceShot.destroyed = false
	
	iceShot.damage = params.damage
	iceShot.x = params.x
	iceShot.y = params.y
	iceShot.rotation = params.angle;
	iceShot.speed = 50;
	iceShot.enemiesHit = 0
	iceShot.freezeTime = params.freezeTime

	function iceShot:enterFrame(e)
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
	
	
	function iceShot:destroy()
		Runtime:removeEventListener("enterFrame", self)
		self:removeSelf();
		self = nil
	end
	
	function iceShot:isOut()
		return ( (self.x < -100) or (self.x > _W + 100) or (self.y < -100) or (self.y > _H + 100) )
	end
	
	function iceShot:checkCollision()
		if (#enemies > 0) then
			for key, enemy in pairs( enemies ) do
				--if (enemy.x) then --if enemy was deleted
				local distance = utils.getDistance( self.x, self.y, enemy.x + enemy.width, enemy.y + enemy.height)
				if ( distance < (24 * enemy.xScale / 2 + self.width) ) then
					self.destroyed = true;
					if self.enemiesHit == 0 then
						enemy.frozenFramesLeft = self.freezeTime
						enemy.frozen = true
						enemy:setFillColor(0, 255, 255) --tint them blue
						enemy:hit(self)
					end
				end
			end
		end
	end
	
	Runtime:addEventListener('enterFrame', iceShot)
	
	return iceShot
end

return IceShot