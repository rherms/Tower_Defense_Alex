Enemy = {}

function Enemy:new()

	local enemy = display.newImage( "img/bullet.png", 0, 222 )
	enemy.destroyed = false
	
	enemy.xScale = 2
	enemy.yScale = 2
	enemy.money = 50
	enemy.speed = 4

	enemy.hitpoints = 2

	function enemy:enterFrame(e)
		if ( self:isOut() ) then
			self.destroyed = true
			--WILL ALSO WANT TO LOSE POINTS / DO DAMAGE
			loseLife()
		end
		if (self.destroyed ) then
			self:destroy()
			return true
		end
		
		--calculate move
		if (self.x < 735) then
			self.dx = self.speed 
			self.dy = 0
		else
			self.dx = 0
			self.dy = self.speed
		end
		
		--moving
		self.x = self.x + self.dx
		self.y = self.y + self.dy
		
	end
	
	function enemy:hit()
		self.hitpoints = self.hitpoints - 1
		if self.hitpoints <= 0 then
			self.destroyed = true
			updateScore(100)
			updateMoney(20)
		end
	end
	
	function enemy:destroy()
		Runtime:removeEventListener("enterFrame", self)	
		self:removeSelf();

		for i=#enemies,1,-1 do
    		if enemies[i] == self then
        		table.remove(enemies, i)
        		return
   			end
		end

	end
	
	function enemy:isOut()
		local offsetX = self.width / 2
		local offsetY = self.height / 2
		return ( (self.x < -offsetX) or (self.x > _W + offsetX) or (self.y < -offsetY) or (self.y > _H + offsetY) )
	end
	
	Runtime:addEventListener('enterFrame', enemy)
	
	return enemy
end

return Enemy