newModernTower = {}

local function sellTower(event)
	local t = towers[event.target.index]
	--table.remove(towers, t.index)
	t.sold = true
	updateMoney(t.cost / 2 + (t.level - 1) * 25)
	t.shootRangeObject:removeSelf()
	local tile_x = math.floor(t.x/64) 
	local tile_y = math.floor(t.y/64)
	map[tile_y + 1][tile_x + 1] = 0
	t.infoButton:removeSelf()
	t:removeSelf()
	Runtime:removeEventListener('enterFrame', t)
	resumeGame("info")
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
			elseif t.level == 3 then
				t.damage = t.damage + 20
			elseif t.level == 4 then
				t.shootRate = t.shootRate + 0.5
				t.shootSleepMax = 30 / t.shootRate
			elseif t.level == 5 then
				t.damage = t.damage + 30
			end
			t.infoButton.isVisible = false
			t.pressed = not t.pressed
			t.shootRangeObject.isVisible = not t.shootRangeObject.isVisible
			resumeGame("info")
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
		message = message .. "Type: RPG Tower"
		message = message .. "\nTile: " .. t.x/64+.5 .. ", " .. t.y/64+.5
		message = message .. "\nLevel: " .. t.level
		message = message .. "\nDamage: " .. t.damage
		message = message .. "\nRange: " .. t.shootRange
		message = message .. "\nFire Rate: " .. t.shootRate .. " shots per second"
		if t.buffed then
			message = message .. "\nBuffed by Nearby Totem"
		end
		message = message .. "\nShoot Style: Single Shot"
		message = message .. "\nWeapon: Rockets (Explosive)"
		message = message .. "\nEra: Modern"
		rect = display.newRoundedRect(center_x, center_y, _W - 360, _H - 240, 24)
		rect:setFillColor(0, 0, 1)
		text = display.newText(message, center_x, center_y - 40, native.systemFont, 24)
		--text:setFillColor( 0.5, 1, 0.2 )
		button = widget.newButton( {shape = "roundedRect", labelColor = {default = {0, 0, 0, 1}, over = {0, 0, 0, 1}}, fillColor = {default = {1, 0, 0, 1}, over = {1, 0, 0, 0.5}}, x = center_x, y = _H - 60, onRelease = resumeGame, label = "Close", width = 150, height = 75, fontSize = 26} )
		button.type = "info"
		sellButton = widget.newButton({defaultFile = "img/sellButton.png", overFile = "img/sellButtonOver.png", width = 48, height = 48, x = rect.x + rect.width / 2 - 24, y = rect.y - rect.height / 2 + 24, onRelease = sellTower})
		sellButton.index = event.target.index
		sellLength = string.len(tostring(t.cost / 2 + (t.level - 1) * 25)) + 1 --so we can scale the x position of the sell price (+1 for $)		
		sellPrice = display.newText("$" .. t.cost / 2 + (t.level - 1) * 25, sellButton.x - 24 - sellLength * 8, sellButton.y, native.systemFontBold, 24)
		upgradeButton = widget.newButton({defaultFile = "img/upgradeButton.png", overFile = "img/upgradeButtonOver.png", width = 48, height = 48, x = rect.x - rect.width / 2 + 24, y = rect.y + rect.height / 2 - 24, onRelease = upgradeTower })
		upgradeButton.index = event.target.index
		if t.level < 5 then
			upgradedStat = display.newText("$".. 25 + 25 * t.level .. " for Level " .. t.level + 1 .. ": " .. t.upgrades[t.level], upgradeButton.x + 24, upgradeButton.y, native.systemFontBold, 24)
			upgradedStat.anchorX = 0
		else
			upgradedStat = display.newText("Fully Upgraded", upgradeButton.x + 24, upgradeButton.y, native.systemFontBold, 24)
			upgradedStat.anchorX = 0
		end
		updateShopButtons(false)
	end
end

local function showTowerOptions(event)
	--toFront, add to scene group
	if not displayingMessage then
		local t = event.target
		t.pressed = not t.pressed
		t.shootRangeObject.isVisible = not t.shootRangeObject.isVisible
		if t.first then
			t.infoButton = widget.newButton({defaultFile = "img/infoButton.png", overFile = "img/infoButton.png", x = t.x + 24, y = t.y, onRelease = showTowerInfo})
			t.infoButton.index = t.index
			globalSceneGroup:insert(t.infoButton)
			t.first = false
		end
		if t.pressed then
			t.infoButton.isVisible = true
		elseif not t.pressed then
			t.infoButton.isVisible = false
		end
	end
end

function newModernTower:new(params)
    local modernTower = {}
	
	--create a shape
	--modernTower = display.newImage("img/modernTower.png", params.x, params.y)
	modernTower = widget.newButton( {x = params.x, y = params.y, defaultFile = "img/modernTower.png", onRelease = showTowerOptions} )
	modernTower.first = true
	modernTower.pressed = false
	globalSceneGroup:insert(modernTower)

	modernTower.x = params.x
	modernTower.y = params.y
	modernTower.damage = 200
	
	modernTower.shootRate = 1.5 -- shots per second
	modernTower.shootSleep = 100
	modernTower.shootSleepMax = 30 / modernTower.shootRate; 
	
	modernTower.shootRange = 200
	modernTower.shootRangeObject = display.newCircle( modernTower.x, modernTower.y, modernTower.shootRange )
	globalSceneGroup:insert(modernTower.shootRangeObject)
	modernTower.shootRangeObject:setFillColor(1, 0, 0, 20/255)
	modernTower.shootRangeObject.isVisible = false
	
	modernTower.target = nil
	modernTower.cost = 1000
	modernTower.level = 1
	modernTower.index = params.index
	modernTower.buffed = false
	table.insert(towers, modernTower)
	
	modernTower.upgrades = {"Range + 50", "Damage + 20", "Shoot Rate + 0.5", "Damage + 30"}

	function modernTower:enterFrame(e)
		if not paused then 
			if not self.first then
				--still want shop to go over this stuff
				sendShopToFront()
			end
			self:enterFrameAI();
			self.shootSleep = self.shootSleep + 1;
		end
	end

	function modernTower:enterFrameAI()
		if ( self:canIShoot() ) then
			self:aiShoot()
		end
	end
	
	--make a shoot by AI
	--select target, point directly at target and shoot finally
	function modernTower:aiShoot()
		if (not self:checkTarget() ) then
			self:selectTarget()
			
		end
		
		--possible there are no suitable targets and we have to check it
		if ( self.target ) then
			self:shoot( self.target )
		end
	end

	
	function modernTower:selectTarget()
		if ( #enemies ) then
		
			--try to find enemy, who is nearest to self
			local enemyKey = nil; --key of enemy who has a minimal distance to current modernTower
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
	function modernTower:checkTarget()
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
	function modernTower:enemyInRange( enemy )
		local distance = utils.getDistance( self.x, self.y, enemy.x + enemy.width, enemy.y + enemy.height)
		return distance <= self.shootRange
	end
	
	--check available of shooting
	function modernTower:canIShoot()
		return ( self.shootSleep > self.shootSleepMax )
	end
	
	--make a shot (create a bullet)
	function modernTower:shoot( target )
		if ( self:canIShoot() ) then
			Rocket:new( { 
				damage = self.damage,
				x = self.x,
				y = self.y,
				angle = utils.getAngle( self.x, self.y, target.x + target.width, target.y + target.height)
			});
			
			self.shootSleep = 0
		end
	end
	
	Runtime:addEventListener('enterFrame', modernTower)
	
	return modernTower
end

return newModernTower