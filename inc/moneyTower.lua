newMoneyTower = {}

local function sellTower(event)
	local t = towers[event.target.index]
	--table.remove(towers, t.index)
	t.sold = true
	updateMoney(t.cost / 2 + (t.level - 1) * 25)
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
	local cost = 200 + 100 * t.level
	if t.level < 5 then 
		if money >= cost then 
			t.level = t.level + 1
			updateMoney(-cost)
			cost = cost + 100
			if t.level == 2 then
				t.income = t.income + 30
			elseif t.level == 3 then
				t.income = t.income + 40
			elseif t.level == 4 then
				t.income = t.income + 50
			elseif t.level == 5 then
				t.income = t.income + 60
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
		message = message .. "Type: Gold Mine"
		message = message .. "\nTile: " .. t.x/64+.5 .. ", " .. t.y/64+.5
		message = message .. "\nLevel: " .. t.level
		message = message .. "\nIncome: $" .. t.income
		message = message .. "\nIncome Rate: " .. t.incomeRate .. " seconds"
		message = message .. "\nEra: Medieval"
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

function newMoneyTower:new(params)
    local moneyTower = {}
	
	--create a shape
	--moneyTower = display.newImage("img/moneyTower.png", params.x, params.y)
	moneyTower = widget.newButton( {x = params.x, y = params.y, defaultFile = "img/moneyTower.png", onRelease = showTowerOptions} )
	moneyTower.first = true
	moneyTower.pressed = false
	globalSceneGroup:insert(moneyTower)

	moneyTower.x = params.x
	moneyTower.y = params.y

	moneyTower.damage = 0 --this is so it doesn't crash with totem tower buffing
	moneyTower.shootRate = 0-- shots per second
	
	moneyTower.frames = 0
	moneyTower.income = 20
	moneyTower.incomeRate = 300 / fps --fps ~ 30
	moneyTower.cost = 300
	moneyTower.level = 1
	moneyTower.index = params.index
	moneyTower.buffed = false
	table.insert(towers, moneyTower)
	
	moneyTower.upgrades = {"Income + 30", "Income + 40", "Income + 50", "Income + 60"}
	function moneyTower:enterFrame(e)
		if not paused then 
			if not self.first then
				--still want shop to go over this stuff
				sendShopToFront()
			end
			if next(enemies) ~= nil then
				self.frames = self.frames + 1
				if self.frames >= self.incomeRate * fps then
					updateMoney(self.income)
					self.frames = 0
				end
			end
		end
	end
	
	Runtime:addEventListener('enterFrame', moneyTower)
	
	return moneyTower
end

return newMoneyTower