Rocket = {}

function Rocket:new(params)
    local rocket = {}
	
	--create a shape
	rocket = display.newImage("img/rocket.png")
	globalSceneGroup:insert(rocket)
	--rocket = display.newImage("img/rock.png")
	--rocket.width = 24
	--rocket.height = 24
	rocket.destroyed = false
	
	rocket.damage = params.damage
	rocket.x = params.x
	rocket.y = params.y
	rocket.rotation = params.angle;
	rocket.speed = 20;
	rocket.enemiesHit = 0

	function rocket:enterFrame(e)
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
	
	
	function rocket:destroy()
		Runtime:removeEventListener("enterFrame", self)
		self:removeSelf();
		self = nil
	end
	
	function rocket:isOut()
		return ( (self.x < -100) or (self.x > _W + 100) or (self.y < -100) or (self.y > _H + 100) )
	end
	
	function rocket:checkCollision()
		if (#enemies > 0) then
			for key, enemy in pairs( enemies ) do
				--if (enemy.x) then --if enemy was deleted
					local distance = utils.getDistance( self.x, self.y, enemy.x + enemy.width / 2, enemy.y + enemy.height / 2)
					if ( distance < (enemy.width + self.width) ) then
						self.destroyed = true;
						if self.enemiesHit == 0 then --prevents it from colliding with multiple enemies at once
							enemy:hit(self)
							--animate explosion
							local sheet = graphics.newImageSheet("img/explosionSheet.png", {width = 64, height = 64, numFrames = 7})
							local explosion = display.newSprite( sheet, { name="explosion", start=1, count = 7, time=400, loopCount = 1} )
							explosion.x = enemy.x + enemy.width
							explosion.y = enemy.y + enemy.height
							explosion:play()
							local function spriteListener(event)
								if event.phase == "ended" then
									event.target:removeSelf()
								end
							end
							explosion:addEventListener( "sprite", spriteListener )
							--check for nearby enemies to do damage to
							for k, v in pairs(enemies) do 
								local dist = utils.getDistance(explosion.x, explosion.y, v.x + v.width / 2, v.y + v.height / 2 ) --v is each enemy
								if dist < explosion.width then
									v:hit(self)
								end
							end
						end
					end
				--end
			end
		end
	end
	
	Runtime:addEventListener('enterFrame', rocket)
	
	return rocket
end

return Rocket