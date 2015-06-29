newTower = {}

local function sellTower(event)
	local t = towers[event.target.index]
	t.sold = true
	--table.remove(towers, t.index)
	updateMoney(t.cost / 2 + (t.level - 1) * 25)
	t.shootRangeObject:removeSelf()
	t.sellButton.isVisible = false
	t.sellPrice.isVisible = false
	t.upgradeButton.isVisible = false
	t.upgradedStat.isVisible = false
	t.infoButton.isVisible = false
	local tile_x = math.floor(t.x/64) 
	local tile_y = math.floor(t.y/64)
	map[tile_y + 1][tile_x + 1] = 0
	t:removeSelf()
	Runtime:removeEventListener('enterFrame', t)
end

local function upgradeTower(event)
	local t = towers[event.target.index]
	local cost = 25 + 25 * t.level
	if t.level < 5 then 
		if money >= cost then 
			t.level = t.level + 1
			updateMoney(-cost)
			cost = cost + 25
			if t.level == 2 then
				t.shootRange = t.shootRange + 50
				t.shootRangeObject:removeSelf()
				t.shootRangeObject = display.newCircle( t.x, t.y, t.shootRange )
				t.shootRangeObject:setFillColor(1, 0, 0, 20/255)
				globalSceneGroup:insert(t.shootRangeObject)
				t.upgradedStat.text = "$".. cost .. " for Level " .. t.level + 1 .. ": " .. t.upgrades[t.level]
				t.sellPrice.text = "$".. t.cost / 2 + (t.level - 1) * 25
			elseif t.level == 3 then
				t.damage = t.damage + 20
				t.upgradedStat.text = "$".. cost .. " for Level " .. t.level + 1 .. ": " .. t.upgrades[t.level]
				t.sellPrice.text = "$".. t.cost / 2 + (t.level - 1) * 25
			elseif t.level == 4 then
				t.shootRate = t.shootRate + 0.5
				t.upgradedStat.text = "$".. cost .. " for Level " .. t.level + 1 .. ": " .. t.upgrades[t.level]
				t.sellPrice.text = "$".. t.cost / 2 + (t.level - 1) * 25
			elseif t.level == 5 then
				t.damage = t.damage + 30
				t.upgradedStat.text = "Fully Upgraded"
				t.sellPrice.text = "$".. t.cost / 2 + (t.level - 1) * 25
			end
			t.sellButton.isVisible = false
			t.sellPrice.isVisible = false
			t.upgradeButton.isVisible = false
			t.upgradedStat.isVisible = false
			t.infoButton.isVisible = false
			t.pressed = not t.pressed
			t.shootRangeObject.isVisible = not t.shootRangeObject.isVisible
		end
	end
end

local function showTowerInfo(event)
	if not displayingMessage then 
		local t = towers[event.target.index]
		if shopDisplayed then
			shop:hide()
		end
		if not paused then
			pauseOrPlayGame()
		end
		displayingMessage = true
		local message = ""
		message = message .. "Type: Cannon Tower"
		message = message .. "\nTile: " .. t.x/64+.5 .. ", " .. t.y/64+.5
		message = message .. "\nLevel: " .. t.level
		message = message .. "\nDamage: " .. t.damage
		message = message .. "\nRange: " .. t.shootRange
		message = message .. "\nFire Rate: " .. t.shootRate .. " shots per second"
		if t.buffed then
			message = message .. "\nBuffed by Nearby Totem"
		end
		message = message .. "\nShoot Style: Single Shot"
		message = message .. "\nWeapon: Cannonballs"
		message = message .. "\nEra: Medieval"
		rect = display.newRect(center_x, center_y, _W - 480, _H - 320)
		rect:setFillColor(0, 0, 1)
		text = display.newText(message, center_x, center_y, native.systemFont, 20)
		--text:setFillColor( 0.5, 1, 0.2 )
		button = widget.newButton( {shape = "roundedRect", labelColor = {default = {0, 0, 0, 1}, over = {0, 0, 0, 1}}, fillColor = {default = {1, 0, 0, 1}, over = {1, 0, 0, 0.5}}, x = center_x, y = _H - 100, onRelease = resumeGame, label = "Close", width = 150, height = 75, fontSize = 26} )
		button.type = "info"
		updateShopButtons(false)
	end
end

local function showTowerOptions(event)
	--toFront, add to scene group
	local t = event.target
	t.pressed = not t.pressed
	t.shootRangeObject.isVisible = not t.shootRangeObject.isVisible
	if t.first then
		t.sellButton = widget.newButton({defaultFile = "img/sellButton.png", overFile = "img/sellButtonOver.png", x = t.x, y = t.y + 64, onRelease = sellTower})
		t.sellButton.index = t.index
		t.sellPrice = display.newText("$" .. t.cost / 2 + (t.level - 1) * 25, t.sellButton.x, t.y + 32, native.systemFontBold, 24)
		t.upgradeButton = widget.newButton({defaultFile = "img/upgradeButton.png", overFile = "img/upgradeButtonOver.png", x = t.x, y = t.y - 64, onRelease = upgradeTower })
		t.upgradeButton.index = t.index
		t.upgradedStat = display.newText("$".. 25 + 25 * t.level .. " for Level " .. t.level + 1 .. ": " .. t.upgrades[t.level], t.upgradeButton.x, t.upgradeButton.y + 32, native.systemFontBold, 24)
		t.infoButton = widget.newButton({defaultFile = "img/infoButton.png", overFile = "img/infoButton.png", x = t.x + 32, y = t.y, onRelease = showTowerInfo})
		t.infoButton.index = t.index
		globalSceneGroup:insert(t.infoButton)
		globalSceneGroup:insert(t.sellButton)
		globalSceneGroup:insert(t.sellPrice)
		globalSceneGroup:insert(t.upgradeButton)
		globalSceneGroup:insert(t.upgradedStat)
		t.first = false
	end
	if t.pressed then
		t.sellButton.isVisible = true
		t.sellPrice.isVisible = true
		t.upgradeButton.isVisible = true
		t.upgradedStat.isVisible = true
		t.infoButton.isVisible = true
	elseif not t.pressed then
		t.sellButton.isVisible = false
		t.sellPrice.isVisible = false
		t.upgradeButton.isVisible = false
		t.upgradedStat.isVisible = false
		t.infoButton.isVisible = false
	end
end

function newTower:new(params)
    local tower = {}
	
	--create a shape
	--tower = display.newImage("img/tower.png", params.x, params.y)
	tower = widget.newButton( {x = params.x, y = params.y, defaultFile = "img/tower.png", onRelease = showTowerOptions} )
	tower.first = true
	tower.pressed = false
	globalSceneGroup:insert(tower)

	tower.x = params.x
	tower.y = params.y
	tower.damage = 50
	
	tower.shootRate = 1.5 -- shots per second
	tower.shootSleep = 100
	tower.shootSleepMax = 30 / tower.shootRate; 
	
	tower.shootRange = 150
	tower.shootRangeObject = display.newCircle( tower.x, tower.y, tower.shootRange )
	globalSceneGroup:insert(tower.shootRangeObject)
	tower.shootRangeObject:setFillColor(1, 0, 0, 20/255)
	tower.shootRangeObject.isVisible = false
	
	tower.target = nil
	tower.cost = 100
	tower.level = 1
	tower.index = params.index
	tower.buffed = false
	table.insert(towers, tower)
	
	tower.upgrades = {"Range + 50", "Damage + 20", "Shoot Rate + 0.5", "Damage + 30"}

	function tower:enterFrame(e)
		if not paused then 
			if not self.first then
				self.sellButton:toFront()
				self.sellPrice:toFront()
				self.upgradeButton:toFront()
				self.upgradedStat:toFront()
				--still want shop to go over this stuff
				sendShopToFront()
			end
			self:enterFrameAI();
			self.shootSleep = self.shootSleep + 1;
		end
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
			--local enemyDistance = 9999999999; --min distance to enemy
			local maxFrames = 0
			for key, enemy in pairs( enemies ) do
				if (enemy.x) then --if enemy was deleted
					--local distance = utils.getDistance( self.x, self.y, enemy.x + enemy.width, enemy.y + enemy.height)
					local frames = enemy.frames
					if ( self:enemyInRange( enemy ) and frames > maxFrames ) then --found out enemy with less distance
						enemyKey = key
						--enemyDistance = distance;
						maxFrames = frames --get the enemy that's been on the screen the longest
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
				return true
			end
		end
		
		self.target = nil
		return false
	end

	--check enemy is range or not
	function tower:enemyInRange( enemy )
		local distance = utils.getDistance( self.x, self.y, enemy.x + enemy.width, enemy.y + enemy.height)
		return distance <= self.shootRange
	end
	
	--check available of shooting
	function tower:canIShoot()
		return ( self.shootSleep > self.shootSleepMax )
	end
	
	--make a shot (create a bullet)
	function tower:shoot( target )
		if ( self:canIShoot() ) then
			Bullet:new( { 
				damage = self.damage,
				x = self.x,
				y = self.y,
				angle = utils.getAngle( self.x, self.y, target.x + target.width, target.y + target.height)
			});
			
			self.shootSleep = 0
		end
	end
	
	Runtime:addEventListener('enterFrame', tower)
	
	return tower
end

return newTower