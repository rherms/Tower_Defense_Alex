--@see http://lua-users.org/wiki/MathLibraryTutorial
--require "sprite"
--widget = require("widget")
local scene = composer.newScene()

function scene:create(event)
	globalSceneGroup = self.view

	require("inc.utils")
	require("inc.player")
	require("inc.tower")
	require("inc.bullet")
	require("inc.laserTower")
	require("inc.gamemap")
	require("inc.enemy")
	require("inc.newPanel")
	require("inc.cavemanTower")
	require("inc.spearTower")
	require("inc.totemTower")
	require("inc.rock")
	require("inc.robotEnemy")
	require("inc.tribalEnemy")
	require("inc.knightEnemy")
	require("inc.tankEnemy")
	require("inc.fireTower")
	require("inc.fireball")
	require("inc.modernTower")
	require("inc.rocket")
	require("inc.dart")
	require("inc.spear")
	require("inc.moneyTower")
	require("inc.gunTower")
	require("inc.freezeTower")
	require("inc.iceShot")
	require("inc.mothership")
	math.randomseed(os.time())

	step = -1 --this is used for tutorial, but want to avoid null pointers so need to declare

	fps = 30
	secondsElapsed = 0

	--background
	bg = display.newRect(center_x, center_y, 960, 640)
	globalSceneGroup:insert(bg)
	GameMap:drawMap()

	--spawnTimer = nil
	pausedBackground = display.newImage("img/pausedBackground.png", center_x, center_y)
	pausedBackground.isVisible = false
	globalSceneGroup:insert(pausedBackground)

	shop = widget.newPanel({location = "right", width = 64 * 5, height = _H, onComplete = updateBoolAndMap, speed = 100})
	shop.background = display.newRect(0, 0, shop.width, shop.height)
	shop.background:setFillColor(0, 1, 0)
	shop:insert(shop.background)
	globalSceneGroup:insert(shop)
	function shop:enterFrame(e)
		sendShopToFront()	
	end
	Runtime:addEventListener('enterFrame', shop)
	
	--Create tower button
	shopButton = widget.newButton( {x = _W - 32, y = 32, width = 80, height = 80, defaultFile = "img/towerbutton.png", onRelease = displayTowerMenu})
	globalSceneGroup:insert(shopButton)
	-- = display.newText(score, 0, _H-60, native.systemFontBold, 48)
	--globalSceneGroup:insert(scoreDisplay)
	--scoreDisplay.anchorX = 0
	--scoreDisplay.anchorY = 0
	moneyDisplay = display.newText("$" .. money, 0, _H-70, native.systemFontBold, 30)
	globalSceneGroup:insert(moneyDisplay)
	moneyDisplay.anchorX = 0
	moneyDisplay.anchorY = 0
	livesDisplay = display.newText("Lives: " .. lives, 0, _H-40, native.systemFontBold, 30)
	globalSceneGroup:insert(livesDisplay)
	livesDisplay.anchorX = 0
	livesDisplay.anchorY = 0
	--utils.showFps()

	displayingMessage = false


	--create turelss
	towersUnlocked = 10 --should be 1 for real
	towers = {}
	towerIndex = 1
	enemies = {}
	--totalEnemies = 0
	currentWave = 1
	local timerID = nil --for stopping the timer that checks if enemies is empty. this is only a timer for the last wave of enemies
	local tempButton = {}

	--these are all 2D arrays now
	enemyAmount = {} --how many enemies 
	enemyType = {}
	enemySpawnRate = {} --in ms
	enemySet = {}
	towersUnlockedPerWave = {} --this is only non 2D array
	local diffText = ""
	if difficulty == 0 then
		diffText = "Easy"
	elseif difficulty == 1 then
		diffText = "Normal"
	elseif difficulty == 2 then
		diffText = "Hard"
	end
	print(diffText)
	local path = system.pathForFile( "waveConfig" .. diffText .. ".txt", system.ResourceDirectory )
	local file = io.open( path, "r" )
	local totalWaves = file:read("*number")
	timers = {} --2D array of spawn timers
	timers.index = 0 --starts at 0 since they have to press the button to start the wave

	local function print2Darray(array)
		for i =1, #array do
			for j = 1, #array[i] do
				print(array[i][j])
			end
			print("------------------------")
		end
	end

	function pauseOrPlayGame()
		if not displayingMessage and #timers ~= 0 and not shopDisplayed then 
			paused = not paused
			pausedBackground.isVisible = not pausedBackground.isVisible
			if paused and timers.index ~= 0 then 
				for i = 1, #timers[timers.index] do
					--to avoid the annoying warning messages
					if not timers[timers.index][i].finished then
						timer.pause(timers[timers.index][i])
					end
				end
			elseif timers.index ~= 0 then
				for i = 1, #timers[timers.index] do
					if not timers[timers.index][i].finished then
						timer.resume(timers[timers.index][i])
					end
				end
			end
		end
	end
	--create pause button
	pauseButton = widget.newButton( {x = _W - 32, y = _H - 32, width = 64, height = 64, defaultFile = "img/pauseButton.png", overFile = "img/pauseButtonOver.png", onRelease = pauseOrPlayGame})
	globalSceneGroup:insert(pauseButton)

	--inserts an array if it doesn't exist into the 2D array, and then inserts elem into that new array
	--also appends an smartIndex field to the elem
	local function smartInsert(array2d, index, elem)
		while not array2d[index] do
			table.insert(array2d, {})
		end
		table.insert(array2d[index], elem)
		elem.smartIndex = #array2d[index]
	end

	local function populateArray(num, file, array)
		for i = 1, num do
			local next = file:read("*number")
			table.insert(array, next)
		end
	end

	for i = 1, totalWaves do
		local columns = file:read("*number")
		--append to towersUnlocked array
		table.insert(towersUnlockedPerWave, file:read("*number"))
		local types, amounts, rates, sets = {}, {}, {}, {}
		populateArray(columns, file, types)
		populateArray(columns, file, amounts)
		populateArray(columns, file, rates)
		populateArray(columns, file, sets)
		table.insert(enemyAmount, amounts)
		table.insert(enemyType, types)
		table.insert(enemySpawnRate, rates)
		table.insert(enemySet, sets)
	end
	
	file:close()

	local function completeLevel(event)
		if lives <= 0 then
			timer.cancel(timerID) 
		elseif next(enemies) == nil then
			--print("Level complete!")
			timer.cancel( timerID )
			resetVariables()
			local message = "Congratulations you beat level " .. levelSelected .. "!"
			if levelSelected == levelsUnlocked then
				levelsUnlocked = levelsUnlocked + 1
				if levelSelected == 9 then 
					message = message .. "\n\nYOU BEAT THE GAME WOOOOO!!!! :D"
				else
					message = message .. "\n\nYou have unlocked level " .. levelsUnlocked
				end
			end
			displayMessage(message)
			--composer.gotoScene("levelselect", "fade", 400)
		end
	end

	--[[local function increaseEnemies()
		totalEnemies = totalEnemies + 1
		if totalEnemies == enemyAmount[currentWave] then
			spawnTimer.finished = true
			if currentWave == totalWaves then 
				timerID = timer.performWithDelay( 500, completeLevel, 0 ) -- 0 means loop forever
				--composer.gotoScene("levelselect")
			else
				currentWave = currentWave + 1
				button.isVisible = true
				totalEnemies = 0
			end
		end
	end--]]

	function timersDone(array)
		for i = 1, #array do 
			if not array[i].finished then
				return false
			end
		end
		return true
	end	

	function createNewEnemy(event)
		if not paused then
			local enemy = {}
			if event.source.params.eType == 1 then
				enemy = Enemy:new()
			elseif event.source.params.eType == 2 then
				enemy = TribalEnemy:new()
			elseif event.source.params.eType == 3 then
				enemy = KnightEnemy:new()
			elseif event.source.params.eType == 4 then
				enemy = TankEnemy:new()
			elseif event.source.params.eType == 5 then
				enemy = RobotEnemy:new()
			elseif event.source.params.eType == 6 then
				enemy = Mothership:new()
			end
			table.insert(enemies, enemy)
			--increaseEnemies()
			local sourceTimer = event.source.params.srcTimer
			sourceTimer.spawnedEnemies = sourceTimer.spawnedEnemies + 1
			if sourceTimer.spawnedEnemies >= sourceTimer.targetEnemies then
				local timerArr = timers[sourceTimer.index]
				sourceTimer.finished = true
				if timersDone(timerArr) then
					if sourceTimer.index >= #timers then
						--end wave
						timers.index = 0
						if currentWave == totalWaves then 
							timerID = timer.performWithDelay( 500, completeLevel, 0 ) -- 0 means loop forever
							--composer.gotoScene("levelselect")
						else
							currentWave = currentWave + 1
							tempButton.isVisible = true
							--totalEnemies = 0
						end
					else
						--start next set of timers
						local nextTimers = timers[sourceTimer.index + 1]
						for i = 1, #nextTimers do
							timer.resume(nextTimers[i])
						end 
						timers.index = sourceTimer.index + 1
					end
				end			
			end
		end
	end

	local function startEnemyTimers()
		local nextTimer = {}
		for i = 1, #enemySet[currentWave] do 
			nextTimer = timer.performWithDelay(enemySpawnRate[currentWave][i], createNewEnemy, enemyAmount[currentWave][i])		
			--for knowing when timer is finished
			nextTimer.spawnedEnemies = 0
			nextTimer.finished = false
			nextTimer.index = enemySet[currentWave][i]
			nextTimer.targetEnemies = enemyAmount[currentWave][i]
			--eType since enemyType is already used
			nextTimer.params = {srcTimer = nextTimer, eType = enemyType[currentWave][i]}
			timer.pause(nextTimer)
			--our own function that will create an empty array if one does not exist
			smartInsert(timers, enemySet[currentWave][i], nextTimer)
		end
		for i = 1, #timers[1] do
			timer.resume(timers[1][i])
		end
		timers.index = 1
	end

	function spawnNextWave(event)
		-- so spawn next wave button won't work after losing
		if lives > 0 and not displayingMessage and not paused then
			if towersUnlockedPerWave[currentWave] > towersUnlocked then
				towersUnlocked = towersUnlockedPerWave[currentWave]
				event.target.isVisible = false
				tempButton = event.target
				displayUnlockMessage(towersUnlocked)
			else
				timers = {} 
				startEnemyTimers()
				if event ~= nil then 
					event.target.isVisible = false
					tempButton = event.target
				end
				if next(enemies) ~= nil then
					updateScore(1000) --why do we have this?
				end
			end
			if #arrows > 0 then
				for i = 1, #arrows do
					arrows[i]:removeSelf()
				end
				arrows = {}
			end
		end
	end

	local function quit() 
		if not displayingMessage then 
			if timerID ~= nil then
				timer.cancel( timerID )
			end
			displayMessage("Try again soon!")
		end
	end


	quitButton = widget.newButton( {shape = "roundedRect", fillColor = {default = {1, 0, 0, 0.8}, over = {1, 0.5, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = 0, y = 0, onRelease = quit, label = "Quit", fontSize = 32, width = 64 * 2, height = 64})
	quitButton.anchorX, quitButton.anchorY = 0, 0
	globalSceneGroup:insert(quitButton)

	--Create next wave button
	nextWaveButton = widget.newButton( {shape = "roundedRect", fillColor = {default = {1, 0, 0, 0.8}, over = {1, 0.5, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = center_x, y = 0, onRelease = spawnNextWave, label = "Start Wave", fontSize = 32, width = 64 * 3, height = 64})
	nextWaveButton.anchorY = 0
	globalSceneGroup:insert(nextWaveButton)


	local function addTower(params)
		--tile size is 64x64, so divide by 64 and round down (0 indexed)
		local tile_x = math.floor(params.x/64) 
		local tile_y = math.floor(params.y/64) 
		if map[tile_y + 1][tile_x + 1] == 0 then
			if params.type == "caveman" then
				tower = newCavemanTower:new({x = tile_x*64+32, y = tile_y*64+32, index = towerIndex})
			elseif params.type == "tower" then
				tower = newTower:new({x = tile_x*64+32, y = tile_y*64+32, index = towerIndex})
			elseif params.type == "fire" then
				tower = newFireTower:new({x = tile_x*64+32, y = tile_y*64+32, index = towerIndex})
			elseif params.type == "modern" then
				tower = newModernTower:new({x = tile_x*64+32, y = tile_y*64+32, index = towerIndex})
			elseif params.type == "money" then
				tower = newMoneyTower:new({x = tile_x*64+32, y = tile_y*64+32, index = towerIndex})
			elseif params.type == "totem" then
				tower = newTotemTower:new({x = tile_x*64+32, y = tile_y*64+32, index = towerIndex})
			elseif params.type == "gun" then
				tower = newGunTower:new({x = tile_x*64+32, y = tile_y*64+32, index = towerIndex})
			elseif params.type == "freeze" then
				tower = newFreezeTower:new({x = tile_x*64+32, y = tile_y*64+32, index = towerIndex})
			elseif params.type == "laser" then
				tower = newLaserTower:new({x = tile_x*64+32, y = tile_y*64+32, index = towerIndex})
			elseif params.type == "spear" then
				tower = newSpearTower:new({x = tile_x*64+32, y = tile_y*64+32, index = towerIndex})
			end
			updateMoney(-tower.cost)
			map[tile_y + 1][tile_x + 1] = 100 --100 means there is a turret there
			towerIndex = towerIndex + 1
		end
	end

	currentlyDragging = false
	highlighted = false
	highlight = {} --will be a yellow square
	function clearHighlights()
		if highlighted then
			highlight:removeSelf()
		end
	end

	function highlightSquare(x, y) 
		--highlight the square it would be dropped on
		clearHighlights()
		local tile_x = math.floor(x/64) 
		local tile_y = math.floor(y/64) 
		highlight = display.newRect(tile_x * 64 + 32, tile_y * 64 + 32, 64, 64)
		if(map[tile_y + 1][tile_x + 1] == 0) then
			highlight:setFillColor(255, 255, 0)
		else
			highlight:setFillColor(255, 0, 0)
		end
		highlighted = true
		globalSceneGroup:insert(highlight)
	end

	function dragImage(event)
		if event.phase == "moved" then
			if event.x <= _W - activeImage.width / 2 and event.x >= 0 + activeImage.width / 2 then
				activeImage.x = event.x
				dragImageRange.x = event.x 
				highlightSquare(event.x, event.y)
			end
			if event.y <= _H - activeImage.height / 2 and event.y >= 0 + activeImage.height / 2 then
				activeImage.y = event.y
				dragImageRange.y = event.y
				highlightSquare(event.x, event.y)
			end
		elseif event.phase == "ended" then
			clearHighlights()
			highlighted = false
			addTower({x = activeImage.x, y = activeImage.y, type = activeImage.type})
			activeImage.x, activeImage.y = towerButtons[activeImage.type].x, towerButtons[activeImage.type].y
			activeImage.isVisible = false
			dragImageRange.isVisible = false
			currentlyDragging = false
			activeImage = nil
			changeTowerButtons(true)
		end
	end

	function towerButtonTouched(event)
		if not displayingMessage then
			local button = event.target
			if(event.phase == "began") then 
				shop:hide()
			end
			if money >= button.cost and not currentlyDragging then
				currentlyDragging = true
				changeTowerButtons(false)
				dragImageRange:removeSelf()
				if button.type == "totem" then
					dragImageRange = display.newRect( button.x, button.y, 96 * 2, 96 * 2 ) --totem tower's shoot range
				else
					dragImageRange = display.newCircle( button.x, button.y, button.shootRange )
				end
				dragImageRange:setFillColor(1, 0, 0, 20/255)
				activeImage = dragImages[button.type]
				activeImage.isVisible = true
				highlightSquare(event.x, event.y)
			end
		end
	end

	--Create Shop Buttons
	towerButtons = {}

	function displayShopInfo(event) 
		if not displayingMessage then 
			local towerType = event.target.type
			--populate text
			local message = ""
		  	if towerType == "caveman" then
			   message = message .. "Type: Caveman Tower"
			   message = message .. "\nDamage: "
			   message = message .. "\nRange: "
			   message = message .. "\nFire Rate: shots per second"
			   message = message .. "\nShoot Style: Single Shot, Level 5: Piercing"
			   message = message .. "\nWeapon: Rock"
			   message = message .. "\nEra: Fictional Prehistoric"
			elseif towerType == "fire" then
			   message = message .. "Type: Fire Tower"
			   message = message .. "\nDamage: "
			   message = message .. "\nRange: "
			   message = message .. "\nFire Rate: shots per second"
			   message = message .. "\nShoot Style: Radial"
			   message = message .. "\nWeapon: Fireball"
			   message = message .. "\nEra: Fictional Prehistoric"
			elseif towerType == "spear" then
			   message = message .. "Type: Spear Tower"
			   message = message .. "\nDamage: "
			   message = message .. "\nRange: "
			   message = message .. "\nFire Rate: shots per second"
			   message = message .. "\nShoot Style: Single Shot, Piercing"
			   message = message .. "\nWeapon: Spear"
			   message = message .. "\nPiercing Level: "
			   message = message .. "\nEra: Tribal"
			elseif towerType == "totem" then
			   message = message .. "Type: Totem Tower"
			   message = message .. "\nBuff Range: "
			   message = message .. "\nDamage Buff: "
			   message = message .. "\nRange Buff: "
			   message = message .. "\nShoot Rate Buff: "
			   message = message .. "\nShoot Style: Area Buff"
			   message = message .. "\nWeapon: Area Buff, Gains Dart at Level 4"
			   message = message .. "\nEra: Tribal"
			elseif towerType == "money" then
			   message = message .. "Type: Gold Mine"
			   message = message .. "\nIncome: "
			   message = message .. "\nIncome Rate: seconds"
			   message = message .. "\nEra: Medieval"
			elseif towerType == "tower" then
			   message = message .. "Type: Cannon Tower"
			   message = message .. "\nDamage: "
			   message = message .. "\nRange: "
			   message = message .. "\nFire Rate: shots per second"
			   message = message .. "\nShoot Style: Single Shot"
			   message = message .. "\nWeapon: Cannon"
			   message = message .. "\nEra: Medieval"
			elseif towerType == "modern" then
			   message = message .. "Type: Rocket Tower"
			   message = message .. "\nDamage: "
			   message = message .. "\nRange: "
			   message = message .. "\nFire Rate: shots per second"
			   message = message .. "\nShoot Style: Single Shot, Explosive"
			   message = message .. "\nWeapon: Rocket"
			   message = message .. "\nEra: Modern"
			elseif towerType == "gun" then
			   message = message .. "Type: Machine Gun Tower"
			   message = message .. "\nDamage: "
			   message = message .. "\nRange: "
			   message = message .. "\nFire Rate: shots per second"
			   message = message .. "\nShoot Style: Single Shot, Rapid Fire"
			   message = message .. "\nWeapon: Bullet"
			   message = message .. "\nEra: Modern"
			elseif towerType == "freeze" then
			   message = message .. "Type: Freeze Tower"
			   message = message .. "\nDamage: "
			   message = message .. "\nRange: "
			   message = message .. "\nFire Rate: shots per second"
			   message = message .. "\nShoot Style: Single Shot"
			   message = message .. "\nWeapon: Ice Shot"
			   message = message .. "\nEra: Future"
			elseif towerType == "laser" then
			   message = message .. "Type: Laser Tower"
			   message = message .. "\nDamage: "
			   message = message .. "\nRange: Infinite"
			   message = message .. "\nFire Rate: lasers per second"
			   message = message .. "\nShoot Style: Straight Line, Infinite Piercing"
			   message = message .. "\nWeapon: Laser"
			   message = message .. "\nEra: Future"
			end


			if not paused then
				pauseOrPlayGame()
			end
			displayingMessage = true
			rect = display.newRect(center_x, center_y, _W - 480, _H - 320)
			rect:setFillColor(0, 0, 1)
			text = display.newText(message, center_x, center_y, native.systemFont, 20)
			--text:setFillColor( 0.5, 1, 0.2 )
			button = widget.newButton( {shape = "roundedRect", labelColor = {default = {0, 0, 0, 1}, over = {0, 0, 0, 1}}, fillColor = {default = {1, 0, 0, 1}, over = {1, 0, 0, 0.5}}, x = center_x, y = _H - 100, onRelease = resumeGame, label = "Close", width = 150, height = 75, fontSize = 26} )
			button.type = "shop"
		end
	end

	shopTitle = display.newText("Shop", 800, 30, native.systemFontBold, 36)
	shopTitle:setFillColor(0, 0, 0)
	shopTitle.isVisible = false

	function createShopButton(fileName, col, order, cost, type, shootRange)
		local newButton = display.newImage(fileName, _W - (320 - col * 64), 64 + order * 56)
		globalSceneGroup:insert(newButton)
		newButton.isVisible = false
		newButton:addEventListener( "touch", towerButtonTouched )
		newButton.type = type
		newButton.infoButton = widget.newButton({defaultFile = "img/infoButton.png", overFile = "img/infoButton.png", x = _W - (320 - (col + 1) * 64) - 20, y = order * 56 + 64, onRelease = displayShopInfo})
		newButton.infoButton.isVisible = false
		newButton.infoButton.type = type
		globalSceneGroup:insert(newButton.infoButton)
		newButton.cost = cost
		newButton.costLabel = display.newText("$" .. cost, newButton.x, newButton.y - 48, native.systemFont, 20)
		newButton.costLabel:setFillColor(0, 0, 0)
		newButton.costLabel.isVisible = false
		newButton.shootRange = shootRange
		towerButtons[type] = newButton
	end

	--file name, x, y, type, cost, shoot range
	createShopButton("img/caveman.png", 1, 1, 50, "caveman", 100)
	createShopButton("img/fireTowerButton.png", 1, 3, 250, "fire", 150)
	createShopButton("img/spearTower.png", 1, 5, 50, "spear", 100)
	createShopButton("img/totemFinal.png", 1, 7, 300, "totem", 192)
	createShopButton("img/moneyTower.png",1, 9, 500, "money", 0)
	createShopButton("img/tower.png", 3, 1, 100, "tower", 150)
	createShopButton("img/modernTower.png", 3, 3, 1000, "modern", 200)
	createShopButton("img/gunTower.png", 3, 5, 500, "gun", 200)
	createShopButton("img/freezeTower.png", 3, 7, 1000, "freeze", 150)
	createShopButton("img/laserTower.png", 3, 9, 1500, "laser", 0)

	--Create Drag Images
	activeImage = nil
	dragImages = {}

	function createDragImage(fileName, x, y, type)
		local newImage = display.newImage(fileName, x, y)
		globalSceneGroup:insert(newImage)
		newImage.isVisible = false
		newImage.type = type
		newImage:addEventListener( "touch", dragImage )
		dragImages[type] = newImage
	end

	createDragImage("img/caveman.png", towerButtons["caveman"].x, towerButtons["caveman"].y, "caveman")
	createDragImage("img/tower.png", towerButtons["tower"].x, towerButtons["tower"].y, "tower")
	createDragImage("img/fireTowerButton.png", towerButtons["fire"].x, towerButtons["fire"].y, "fire")
	createDragImage("img/totemFinal.png", towerButtons["totem"].x, towerButtons["totem"].y, "totem")
	createDragImage("img/modernTower.png", towerButtons["modern"].x, towerButtons["modern"].y, "modern")
	createDragImage("img/moneyTower.png", towerButtons["money"].x, towerButtons["money"].y, "money")
	createDragImage("img/gunTower.png", towerButtons["gun"].x, towerButtons["gun"].y, "gun")
	createDragImage("img/freezeTower.png", towerButtons["freeze"].x, towerButtons["freeze"].y, "freeze")
	createDragImage("img/laserTower.png", towerButtons["laser"].x, towerButtons["laser"].y, "laser")
	createDragImage("img/spearTower.png", towerButtons["spear"].x, towerButtons["spear"].y, "spear")


	--will be immediately removed so size doesn't matter
	dragImageRange = display.newCircle( 0, 0, 0)
	globalSceneGroup:insert(dragImageRange)

	--bugfix
	function changeTowerButtons(bool)
		for i = 1, table.getn(towers) do
			towers[i]:setEnabled(bool)
		end
	end


	--this way you can drag shop images over already placed towers
	function onEveryFrame(event)
		if activeImage ~= nil then
			activeImage:toFront()
		end
	end
	Runtime:addEventListener("enterFrame", onEveryFrame)

end

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
--scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
--[[ 	
5 eras:       Tower ------- Enemies
-Prehistoric: cavemen and dinosaurs
-Tribal:      totems  and animal spirits
-Medieval:    two towers   and catapults and roman/spartan warriors
-Modern:      sentry turret/SAM turret and tanks/robots
-Future:      laser turret/orbital cannon and 
--]]

--Spikes, slowing stuff, etc.

--all towers unlocked at beginning, but later ones can't be afforded until later
--fix sell prices

--June
--arrows
--difficulties