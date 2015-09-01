newLaserTower = {}

function laserTowerHandler(event)
	if not currentlyDragging and event.phase ~= "ended" then
		for key, tower in pairs(towers) do
			if(tower.type == "laser" and not tower.sold) then
				angle = utils.getAngle( tower.x, tower.y, event.x, event.y)
				delta = angle - tower.laser.angle
				tower.laser.angle = angle
				tower.laser:rotate(delta)
			end
		end
		
	end
end

local function sellTower(event)
	local t = towers[event.target.index]
	--table.remove(towers, t.index)
	t.sold = true
	updateMoney(t.cost / 2 + (t.level - 1) * 25)
	local tile_x = math.floor(t.x/64) 
	local tile_y = math.floor(t.y/64)
	map[tile_y + 1][tile_x + 1] = 0
	t.laser:removeSelf()
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
				t.damage = t.damage + 10
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
		message = message .. "Type: Laser Tower"
		message = message .. "\nTile: " .. t.x/64+.5 .. ", " .. t.y/64+.5
		message = message .. "\nLevel: " .. t.level
		message = message .. "\nDamage: " .. t.damage
		message = message .. "\nRange: Infinite"
		message = message .. "\nFire Rate: " .. t.shootRate .. " lasers per second"
		if t.buffed then
			message = message .. "\nBuffed by Nearby Totem"
		end
		message = message .. "\nShoot Style: Straight Line, Infinite Piercing"
		message = message .. "\nWeapon: Plasma"
		message = message .. "\nEra: Future"
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


function newLaserTower:new(params)
    local laserTower = {}
	
	
	--create a shape
	--laserTower = display.newImage("img/laserTower.png", params.x, params.y)
	laserTower = widget.newButton( {x = params.x, y = params.y, defaultFile = "img/laserTower.png", onRelease = showTowerOptions} )
	laserTower.first = true
	laserTower.pressed = false
	globalSceneGroup:insert(laserTower)

	laserTower.x = params.x
	laserTower.y = params.y
	laserTower.damage = 200
	
	laserTower.shootRate = 1 -- shots per second
	laserTower.shootSleep = 100
	laserTower.shootSleepMax = 30 / laserTower.shootRate; 
	
	--laserTower.shootRange = 0
	--laserTower.shootRangeObject = display.newCircle( laserTower.x, laserTower.y, laserTower.shootRange )
	--globalSceneGroup:insert(laserTower.shootRangeObject)
	--laserTower.shootRangeObject:setFillColor(1, 0, 0, 20/255)
	--laserTower.shootRangeObject.isVisible = false
	
	--laserTower.target = nil
	laserTower.cost = 1000
	laserTower.level = 1
	laserTower.index = params.index
	laserTower.buffed = false
	laserTower.type = "laser"
	--laserTower.angle = 270 --initially start shooting up
	table.insert(towers, laserTower)

	laserTower.laser = display.newRoundedRect(params.x, params.y, 64, _W * 2, 12) --so it will always go out of screen
	laserTower.laser.anchorX, laserTower.laser.anchorY = 0.5, 0
	laserTower.laser:setFillColor(0, 255, 255)
	globalSceneGroup:insert(laserTower.laser)
	laserTower.laser.angle = 90 --initially down

	laserTower.upgrades = {"Range + 50", "Damage + 20", "Shoot Rate + 0.5", "Damage + 30"}

	function laserTower:enterFrame(e)
		if not paused then 
			if not self.first then
				--still want shop to go over this stuff
				sendShopToFront()
			end
			self.shootSleep = self.shootSleep + 1;
			if self.shootSleep >= self.shootSleepMax then
				self:shoot()
				self.shootSleep = 0
			end
		end
	end
	
	function laserTower:inRange(enemy)
		local angle = self.laser.angle
		local xDiff = enemy.x + enemy.width / 2- self.x
		local yDiff = enemy.y + enemy.height / 2 - self.y
		if angle >= 88 and angle <= 92 then
			if math.abs(xDiff) <= 32 and yDiff > 0 then
				return true
			else
				return false
			end	
		elseif angle >= 178 and angle <= 182 then
			if math.abs(yDiff) <= 32 and xDiff < 0 then
				return true
			else
				return false
			end	
		elseif angle >= 268 and angle <= 272 then
			if math.abs(xDiff) <= 32 and yDiff < 0 then
				return true
			else
				return false
			end	
		elseif angle >= 358 or angle <= 2 then
			if math.abs(yDiff) <= 32 and xDiff > 0 then
				return true
			else
				return false
			end	
		end
		local angleToEnemy = math.deg(math.atan(yDiff / xDiff))
		if xDiff < 0 then
			angleToEnemy = angleToEnemy + 180
		elseif angleToEnemy < 0 then
			angleToEnemy = angleToEnemy + 360
		end
		local dist = math.sqrt(xDiff * xDiff + yDiff * yDiff)
		local delta = 3000 / dist --3000 is magical for some reason
		if math.abs(angleToEnemy - angle) <= delta then
			return true
		else
			return false
		end
		--my original failed attempt before Alex's genius enlightened us
		--[[local yTarget = xDiff * math.tan(math.rad(angle)) + self.y
		local difference = yTarget - enemy.y
		if math.abs(difference) <= 100 then
			return true
		else
			return false
		end--]]
	end

	function laserTower:shoot()
		--make the laser flash
		transition.fadeIn(self.laser, {time = 0})
		transition.fadeOut(self.laser, {time = 1000})
		for key, enemy in pairs(enemies) do
			if(self:inRange(enemy)) then
				enemy.hitpoints = enemy.hitpoints - self.damage
				if enemy.hitpoints <= 0 then
					enemy.destroyed = true
				end
			end
		end
	end
	
	Runtime:addEventListener('enterFrame', laserTower)
	
	return laserTower
end

return newLaserTower