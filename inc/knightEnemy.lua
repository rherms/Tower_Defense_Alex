require("inc.gamemap")
KnightEnemy = {}

function KnightEnemy:new()
	--vals is spawnX, spawnY, DX, DY
	--get a random start point out of possible ones
	local vals = map.startValues[math.random(table.getn(map.startValues))]
	local knightEnemy = display.newImage( "img/knight.gif", vals[1], vals[2] )
	globalSceneGroup:insert(knightEnemy)
	knightEnemy.destroyed = false
	
	knightEnemy.xScale = 2
	knightEnemy.yScale = 2
	knightEnemy.speed = 6

	knightEnemy.dx = vals[3] * knightEnemy.speed
	knightEnemy.dy = vals[4] * knightEnemy.speed
	knightEnemy.anchorX, knightEnemy.anchorY = 0, 0

	knightEnemy.hitBy = {}
	knightEnemy.score = 200
	knightEnemy.money = 50
	knightEnemy.hitpoints = 250
	knightEnemy.frames = 0 --number of frames it has been present for

	knightEnemy.frozen = false
	knightEnemy.frozenFramesLeft = 0

	function knightEnemy:enterFrame(e)
		if not paused then
			if (self.destroyed) then
					updateScore(self.score)
					updateMoney(self.money)
					self:destroy()
					return true 
			elseif self.frozen then
				self.frozenFramesLeft = self.frozenFramesLeft - 1
				if self.frozenFramesLeft <= 0 then
					self.frozen = false
					self:setFillColor(255, 255, 255) --restore original color
				end
			else 
				if ( self:isOut() ) then
					self:destroy()
					--WILL ALSO WANT TO LOSE POINTS / DO DAMAGE
					loseLife()
				end
				
				self.frames = self.frames + 1
				--calculate move
				local xIndex = math.floor(self.x/64) + 1 
				local yIndex = math.floor(self.y/64) + 1
				if xIndex == 0 then xIndex = 1 end
				if yIndex == 0 then yIndex = 1 end
				if not (xIndex < 0 or yIndex < 0 or yIndex > table.getn(map) or xIndex > table.getn(map[1])) then
					if(map[yIndex][xIndex] == 2 or (map[yIndex][xIndex] == 12 and self.dx > 0)) then --for T piece
						self.dx = 0
						self.dy = self.speed
					elseif (map[yIndex][xIndex] == 7 or (map[yIndex][xIndex] == 12 and self.dx < 0)) then --for T piece
						if self.x - (xIndex - 1) * 64 <= self.speed then --otherwise it will turn early
							self.dx = 0
							self.dy = self.speed
						end
					elseif(map[yIndex][xIndex] == 5) then
						self.dx = -self.speed
						self.dy = 0
					elseif map[yIndex][xIndex] == 10 then
						if self.y - (yIndex - 1) * 64 <= self.speed then
							self.dx = -self.speed
							self.dy = 0
						end
					elseif map[yIndex][xIndex] == 11 then
						if self.y - (yIndex - 1) * 64 <= self.speed then
							self.dx = self.speed
							self.dy = 0
						end
					elseif(map[yIndex][xIndex] == 6) then
						self.dx = self.speed
						self.dy = 0
					elseif(map[yIndex][xIndex] == 9) then
						self.dx = 0
						self.dy = -self.speed
					elseif(map[yIndex][xIndex] == 8) then
						if self.x - (xIndex - 1) * 64 <= self.speed then
							self.dx = 0
							self.dy = -self.speed
						end
					end

				end
				
				--moving
				self.x = self.x + self.dx
				self.y = self.y + self.dy
			end
		end
	end
	
	function knightEnemy:hit(bullet)
		local alreadyHit = false
		for key, val in pairs(self.hitBy) do
			if val == bullet then 
				alreadyHit = true
			end
		end
		if not alreadyHit then 
			bullet.enemiesHit = bullet.enemiesHit + 1
			self.hitpoints = self.hitpoints - bullet.damage
			if self.hitpoints <= 0 then
				self.destroyed = true
			end
			table.insert(self.hitBy, bullet)
		end
	end
	
	function knightEnemy:destroy()
		Runtime:removeEventListener("enterFrame", self)	
		self:removeSelf();

		for i=#enemies,1,-1 do
    		if enemies[i] == self then
        		table.remove(enemies, i)
        		return
   			end
		end

	end
	
	function knightEnemy:isOut()
		return ( (self.x < -self.width) or (self.x > _W ) or (self.y < -self.height) or (self.y > _H) )
	end
	
	Runtime:addEventListener('enterFrame', knightEnemy)
	
	return knightEnemy
end

return KnightEnemy