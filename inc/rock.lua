Rock = {}

function Rock:new(params)
    local rock = {}
	
	rock = display.newImage("img/rock.png")
	rock.width = 24
	rock.height = 24
	rock.destroyed = false
	
	rock.damage = params.damage
	rock.x = params.x
	rock.y = params.y
	rock.piercing = params.piercing
	rock.rotation = params.angle;
	rock.speed = 30;
	rock.enemiesHit = 0
	
	function rock:enterFrame(e)
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
	
	
	function rock:destroy()
		Runtime:removeEventListener("enterFrame", self)
		self:removeSelf();
		self = nil
	end
	
	function rock:isOut()
		return ( (self.x < -100) or (self.x > _W + 100) or (self.y < -100) or (self.y > _H + 100) )
	end
	
	function rock:checkCollision()
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
	
	Runtime:addEventListener('enterFrame', rock)
	
	return rock
end

return Rock