require("inc.gamemap")
Mothership = {}

function Mothership:new()
	--vals is spawnX, spawnY, DX, DY
	--get a random start point out of possible ones
	local vals = map.startValues[math.random(table.getn(map.startValues))]
	local mothership = display.newImage( "img/mothership.png", vals[1], vals[2] )
	globalSceneGroup:insert(mothership)
	mothership.destroyed = false
	
	mothership.xScale = 2
	mothership.yScale = 2
	mothership.speed = 1

	mothership.dx = vals[3] * mothership.speed
	mothership.dy = vals[4] * mothership.speed
	mothership.anchorX, mothership.anchorY = 0, 0

	mothership.hitBy = {} --keeps track of which bullets have hit it so far

	mothership.score = 1500
	mothership.money = 700
	mothership.hitpoints = 20000
	mothership.frames = 0 --number of frames it has been present for
	mothership.spawnFrames = 0
	mothership.spawnFramesMax = 60

	function mothership:enterFrame(e)
		if not paused then
			if (self.destroyed ) then
					self:destroy()
					return true 
			else 
				if ( self:isOut() ) then
					self:destroy()
					--WILL ALSO WANT TO LOSE POINTS / DO DAMAGE
					loseLife()
					--lose game!
				end
				
				self.frames = self.frames + 1
				self.spawnFrames = self.spawnFrames + 1
				if self.spawnFrames >= self.spawnFramesMax then
					self.spawnFrames = 0
					enemyType = math.random(5)
					local newEnemy = {}
					if enemyType == 1 then
						newEnemy = Enemy:new()
					elseif enemyType == 2 then
						newEnemy = TribalEnemy:new()
					elseif enemyType == 3 then
						newEnemy = KnightEnemy:new()
					elseif enemyType == 4 then
						newEnemy = TankEnemy:new()
					elseif enemyType == 5 then
						newEnemy = RobotEnemy:new()
					end
					table.insert(enemies, newEnemy)
					newEnemy.x = self.x
					newEnemy.y = self.y
					newEnemy.dx = self.dx * newEnemy.speed / self.speed
					newEnemy.dy = self.dy * newEnemy.speed / self.speed
				end
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
	
	function mothership:hit(bullet)
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
				updateScore(self.score)
				updateMoney(self.money)
			end
			table.insert(self.hitBy, bullet)
		end
	end
	
	function mothership:destroy()
		Runtime:removeEventListener("enterFrame", self)	
		self:removeSelf();

		for i=#enemies,1,-1 do
    		if enemies[i] == self then
        		table.remove(enemies, i)
        		return
   			end
		end

	end
	
	function mothership:isOut()
		return ( (self.x < -self.width) or (self.x > _W ) or (self.y < -self.height) or (self.y > _H) )
	end
	
	Runtime:addEventListener('enterFrame', mothership)
	
	return mothership
end

return Mothership