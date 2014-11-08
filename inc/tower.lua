newTower = {}

function newTower:new(params)
    local tower = {}
	
	--create a shape
	tower = display.newImage("img/tower.png", params.x, params.y)
	--tower.xScale = 0.5
	--tower.yScale = 0.5
	tower.xReference = -78

	print("newTower x: " .. params.x)
	
	tower.x = params.x
	tower.y = params.y
	
	tower.shootRate = 1.5 -- shots per second
	tower.shootSleep = 100
	tower.shootSleepMax = fps / tower.shootRate; 
	
	tower.shootRange = params.shootRange
	tower.shootRangeObject = display.newCircle( tower.x, tower.y, tower.shootRange )
	tower.shootRangeObject:setFillColor(1, 0, 0, 20/255)
	
	tower.target = nil
	
	
	function tower:enterFrame(e)
		self:enterFrameAI();
		
		self.shootSleep = self.shootSleep + 1;
	end

	function tower:enterFrameAI()
		if ( self:canIShoot() ) then
			self:aiShoot()
		end
	end
	
	--make a shoot by AI
	--select target, point directly at target and shoot finally
	function tower:aiShoot()
		if (not self:checkTarget() ) then
			self:selectTarget()
			
		end
		
		--possible there are no suitable targets and we have to check it
		if ( self.target ) then
			self:shoot( self.target )
		end
	end

	
	function tower:selectTarget()
		if ( #enemies ) then
		
			--try to find enemy, who is nearest to self
			local enemyKey = nil; --key of enemy who has a minimal distance to current tower
			local enemyDistance = 9999999999; --min distance to enemy
			
			for key, enemy in pairs( enemies ) do
				if (enemy.x) then --if enemy was deleted
					local distance = utils.getDistance( self.x, self.y, enemy.x, enemy.y )
					if ( self:enemyInRange( enemy ) and distance < enemyDistance ) then --found out enemy with less distance
						enemyKey = key;
						enemyDistance = distance;
					end
				end
			end

			if ( enemyKey ) then
				self.target = enemies[ enemyKey ];
				return true;
			end			
		end		
		
		self.target = nil;
		
		return false;
	end
	
	--check current target
	--the target can be out of range or already dead
	function tower:checkTarget()
		if ( self.target and self.target.x ~= nil) then			
			--check range
			if ( self:enemyInRange( self.target ) ) then
				return true;
			end
		end
		
		self.target = nil
		return false;
	end

	--check enemy is range or not
	function tower:enemyInRange( enemy )
		local distance = utils.getDistance( self.x, self.y, enemy.x, enemy.y );
		return distance <= self.shootRange;
	end
	
	--check available of shooting
	function tower:canIShoot()
		return ( self.shootSleep > self.shootSleepMax );
	end
	
	--make a shoot (create a bullet)
	function tower:shoot( target )
		if ( self:canIShoot() ) then
			Bullet:new( { 
				x = self.x,
				y = self.y,
				angle = utils.getAngle( self.x, self.y, target.x, target.y )
			});
			
			self.shootSleep = 0
		end
	end
	
	Runtime:addEventListener('enterFrame', tower)
	
	return tower
end

return newTower