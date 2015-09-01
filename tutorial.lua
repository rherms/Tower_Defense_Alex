--@see http://lua-users.org/wiki/MathLibraryTutorial
--require "sprite"
--widget = require("widget")
local scene = composer.newScene()

function scene:create(event)
	globalSceneGroup = self.view

	require ("inc.utils")
	require ("inc.player")
	require ("inc.tower")
	require ("inc.bullet")
	require ("inc.gamemap")
	require ("inc.enemy")
	require ("inc.newPanel")
	require ("inc.cavemantower")
	require ("inc.rock")
	require ("inc.tribalEnemy")
	require ("inc.knightEnemy")
	require ("inc.tankEnemy")
	require ("inc.fireTower")
	require ("inc.fireball")
	require("inc.modernTower")
	require("inc.rocket")
	require("inc.totemTower")
	require("inc.dart")
	math.randomseed( os.time() )

	fps = 30
	secondsElapsed = 0

	--background
	bg = display.newRect(center_x, center_y, 960, 640)
	globalSceneGroup:insert(bg)
	GameMap:drawMap()

	spawnTimer = nil
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
	scoreDisplay = display.newText(score, 0, _H-60, native.systemFontBold, 48)
	globalSceneGroup:insert(scoreDisplay)
	scoreDisplay.anchorX = 0
	scoreDisplay.anchorY = 0
	moneyDisplay = display.newText("$" .. money, 0, _H-120, native.systemFontBold, 48)
	globalSceneGroup:insert(moneyDisplay)
	moneyDisplay.anchorX = 0
	moneyDisplay.anchorY = 0
	livesDisplay = display.newText("Lives: " .. lives, 0, _H-180, native.systemFontBold, 48)
	globalSceneGroup:insert(livesDisplay)
	livesDisplay.anchorX = 0
	livesDisplay.anchorY = 0
	--utils.showFps()

	displayingMessage = false

	function pauseOrPlayGame()
		if not displayingMessage then 
			if spawnTimer ~= nil then 
				paused = not paused
				pausedBackground.isVisible = not pausedBackground.isVisible
				if paused and not spawnTimer.finished then --to avoid the annoying warning messages
					timer.pause(spawnTimer)
				elseif not spawnTimer.finished then
					timer.resume(spawnTimer)
				end
			end
		end
	end
	--create pause button
	pauseButton = widget.newButton( {x = _W - 32, y = _H - 32, width = 64, height = 64, defaultFile = "img/pauseButton.png", overFile = "img/pauseButtonOver.png", onRelease = pauseOrPlayGame})
	globalSceneGroup:insert(pauseButton)

	--create turelss
	towersUnlocked = 1
	towers = {}
	towerIndex = 1
	enemies = {}
	totalEnemies = 0
	currentWave = 1
	local timerID = nil --for stopping the timer that checks if enemies is empty
	local button = {}

	step = 0 --for tutorial

	local totalWaves = 3
	updateMoney(10000)
	updateLives(100)
	enemiesInWave = {2, 5, 10} --how many enemies 
	enemyType = {1, 2, 3}
	enemySpawnRate = {1000, 1000, 1000} --in ms
	towersUnlockedPerWave = {1, 2, 3}
	--[[local file = assert(io.open("C:/Users/rlher_000/Documents/Breakout Mentors/Tower_Defense_Alex/waveConfig.txt", "r"))
	local totalWaves = file:read("*number")

	local function populateArray(num, file, array)
		for i = 1, num do
			local next = file:read("*number")
			table.insert(array, next)
		end
	end
	populateArray(totalWaves, file, enemiesInWave)
	populateArray(totalWaves, file, enemyType)
	populateArray(totalWaves, file, enemySpawnRate)
	populateArray(totalWaves, file, towersUnlockedPerWave)
	file:close()--]]

	local function completeLevel(event)
		if lives <= 0 then
			timer.cancel(timerID) 
		elseif next(enemies) == nil then
			--print("Level complete!")
			timer.cancel( timerID )
			step = 0
			displayMessage("Congratulations you beat the tutorial!")
		end
	end


	local function waveEnemiesDead() 
		if next(enemies) == nil then
			timer.cancel(timerID)
			towersUnlocked = towersUnlocked + 1
			nextStep()
		end
	end
	--nextWaveButton and button are the same

	local function increaseEnemies()
		totalEnemies = totalEnemies + 1
		if totalEnemies == enemiesInWave[currentWave] then
			spawnTimer.finished = true
			if currentWave == totalWaves then 
				timerID = timer.performWithDelay( 500, completeLevel, 0 ) -- 0 means loop forever
				--composer.gotoScene("levelselect")
			else
				currentWave = currentWave + 1
				if step ~= 7 then
				 	button.isVisible = true
				else
					timerID = timer.performWithDelay(500, waveEnemiesDead, 0)
				end
				totalEnemies = 0
			end
		end
	end

	local function createNewEnemy()
		local enemy = Enemy:new()
		table.insert(enemies, enemy)
		increaseEnemies()
	end

	local function createNewTribalEnemy()
		local tribalEnemy = TribalEnemy:new()
		table.insert( enemies, tribalEnemy )
		increaseEnemies()
	end

	local function createNewKnightEnemy()
		local knightEnemy = KnightEnemy:new()
		table.insert( enemies, knightEnemy )
		increaseEnemies()
	end

	local function createNewTankEnemy()
		local tankEnemy = TankEnemy:new()
		table.insert( enemies, tankEnemy )
		increaseEnemies()
	end

	local function startEnemyTimer(params)
		if enemyType[params.wave] == 1 then
			return timer.performWithDelay(enemySpawnRate[params.wave], createNewEnemy, enemiesInWave[params.wave])
		elseif enemyType[params.wave] == 2 then
			return timer.performWithDelay(enemySpawnRate[params.wave], createNewTribalEnemy, enemiesInWave[params.wave])
		elseif enemyType[params.wave] == 3 then
			return timer.performWithDelay(enemySpawnRate[params.wave], createNewKnightEnemy, enemiesInWave[params.wave])
		elseif enemyType[params.wave] == 4 then
			return timer.performWithDelay(enemySpawnRate[params.wave], createNewTankEnemy, enemiesInWave[params.wave])
		end
	end

	function spawnNextWave(event)
		-- so spawn next wave button won't work after losing
		if step == 10 then
			nextStep()
		end
		if lives > 0 and not displayingMessage then
			if towersUnlockedPerWave[currentWave] > towersUnlocked then
				towersUnlocked = towersUnlockedPerWave[currentWave]
				event.target.isVisible = false
				button = event.target
				displayUnlockMessage(towersUnlocked)
			else 
				spawnTimer = startEnemyTimer({wave = currentWave})
				spawnTimer.finished = false	
				if event ~= nil then 
					event.target.isVisible = false
					button = event.target
				end
			end
		end
	end

	local function quit() 
		if step == 10 then
			nextStep() --all this does is remove the message from the screen
		end
		--[[resetVariables()
		step = 0
		composer.gotoScene("title", "fade", 400)--]]
		if timerID ~= nil then
			timer.cancel( timerID )
		end
		step = 0
		displayMessage("Good luck on future levels!")
	end


	quitButton = widget.newButton( {shape = "roundedRect", fillColor = {default = {1, 0, 0, 0.8}, over = {1, 0.5, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = 0, y = 0, onRelease = quit, label = "Quit", fontSize = 32, width = 64 * 2, height = 64})
	quitButton.anchorX, quitButton.anchorY = 0, 0
	globalSceneGroup:insert(quitButton)
	quitButton.isVisible = false
	--Create next wave button
	nextWaveButton = widget.newButton( {shape = "roundedRect", fillColor = {default = {1, 0, 0, 0.8}, over = {1, 0.5, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = center_x, y = 0, onRelease = spawnNextWave, label = "Start Wave", fontSize = 32, width = 64 * 3, height = 64})
	nextWaveButton.anchorY = 0
	globalSceneGroup:insert(nextWaveButton)
	nextWaveButton.isVisible = false --starts invisible in tutorial

	local function addCavemanTower(event)
		--tile size is 64x64, so divide by 64 and round down (0 indexed)
		local tile_x = math.floor(event.x/64) 
		local tile_y = math.floor(event.y/64)

		--in tutorial step 5, they have to place a caveman tower on tile_x = 2 and tile_y = 3
		if step == 5 then
			if tile_x ~= 2 or tile_y ~= 3 then
				return
			end
		end

		--print("X tile: " .. tile_x)
		--print("Y tile: " .. tile_y)
		if money >= 50 and map[tile_y + 1][tile_x + 1] == 0 then
			tower = newCavemanTower:new({x = tile_x*64+32, y = tile_y*64+32, index = towerIndex})
			updateMoney(-tower.cost)
			map[tile_y + 1][tile_x + 1] = 100 --100 means there is a turret there
			towerIndex = towerIndex + 1
			if step == 5 then
				nextStep()
			end
		end
	end

	local function addFireTower(event)
		--tile size is 64x64, so divide by 64 and round down (0 indexed)
		local tile_x = math.floor(event.x/64) 
		local tile_y = math.floor(event.y/64) 
		--print("X tile: " .. tile_x)
		--print("Y tile: " .. tile_y)
		if money >= 80 and map[tile_y + 1][tile_x + 1] == 0 then
			tower = newFireTower:new({x = tile_x*64+32, y = tile_y*64+32, index = towerIndex})
			updateMoney(-tower.cost)
			map[tile_y + 1][tile_x + 1] = 100 --100 means there is a turret there
			towerIndex = towerIndex + 1
			if step == 9 then
				nextStep()
			end
		end
	end

	local function addTower(params)
		--tile size is 64x64, so divide by 64 and round down (0 indexed)
		local tile_x = math.floor(params.x/64) 
		local tile_y = math.floor(params.y/64) 
		--print("X tile: " .. tile_x)
		--print("Y tile: " .. tile_y)
		if money >= 100 and map[tile_y + 1][tile_x + 1] == 0 then
			tower = newTower:new({x = tile_x*64+32, y = tile_y*64+32, index = towerIndex})
			updateMoney(-tower.cost)
			map[tile_y + 1][tile_x + 1] = 100 --100 means there is a turret there
			towerIndex = towerIndex + 1
		end
	end

	local function addModernTower(params)
		--tile size is 64x64, so divide by 64 and round down (0 indexed)
		local tile_x = math.floor(params.x/64) 
		local tile_y = math.floor(params.y/64)
		if money >= 1000 and map[tile_y + 1][tile_x + 1] == 0 then
			tower = newModernTower:new({x = tile_x*64+32, y = tile_y*64+32, index = towerIndex})
			updateMoney(-tower.cost)
			map[tile_y + 1][tile_x + 1] = 100 --100 means there is a turret there
			towerIndex = towerIndex + 1
		end
	end

	local function addTotemTower(event)
		--tile size is 64x64, so divide by 64 and round down (0 indexed)
		local tile_x = math.floor(event.x/64) 
		local tile_y = math.floor(event.y/64) 
		--print("X tile: " .. tile_x)
		--print("Y tile: " .. tile_y)
		if money >= 300 and map[tile_y + 1][tile_x + 1] == 0 then
			tower = newTotemTower:new({x = tile_x*64+32, y = tile_y*64+32, index = towerIndex})
			updateMoney(-tower.cost)
			map[tile_y + 1][tile_x + 1] = 100 --100 means there is a turret there
			towerIndex = towerIndex + 1
		end
	end


	local currentlyDragging = false

	function dragImage(event)
		currentlyDragging = true
		if event.phase == "moved" then
			if event.x <= _W - activeImage.width / 2 and event.x >= 0 + activeImage.width / 2 then
				activeImage.x = event.x
				dragImageRange.x = event.x 
			end
			if event.y <= _H - activeImage.height / 2 and event.y >= 0 + activeImage.height / 2 then
				activeImage.y = event.y
				dragImageRange.y = event.y
			end
		elseif event.phase == "ended" then
			if activeImage.type == "caveman" then 
				addCavemanTower({x = activeImage.x, y = activeImage.y})
				activeImage.x, activeImage.y = cavemanButton.x, cavemanButton.y
			elseif activeImage.type == "tower" then
				addTower({x = activeImage.x, y = activeImage.y})
				activeImage.x, activeImage.y = towerButton.x, towerButton.y
			elseif activeImage.type == "fire" then
				addFireTower({x = activeImage.x, y = activeImage.y})
				activeImage.x, activeImage.y = fireTowerButton.x, fireTowerButton.y
			elseif activeImage.type == "modern" then
				addModernTower({x = activeImage.x, y = activeImage.y})
				activeImage.x, activeImage.y = modernTowerButton.x, modernTowerButton.y
			elseif activeImage.type == "totem" then
				addTotemTower({x = activeImage.x, y = activeImage.y})
				activeImage.x, activeImage.y = totemTowerButton.x, totemTowerButton.y
			end
			activeImage.isVisible = false
			dragImageRange.isVisible = false
			currentlyDragging = false
			activeImage = nil
			--self.x, self.y = towerButton.x, towerButton.y
			--dragImage.x, dragImage.y = self.x, self.y
		end
	end

	--Create Shop Buttons
	cavemanButton = display.newImage( "img/caveman.png", _W - 256, 128)
	globalSceneGroup:insert(cavemanButton)
	towerButton = display.newImage("img/tower.png", _W - 256, 384)
	globalSceneGroup:insert(towerButton)
	cavemanButton:addEventListener( "touch", cavemanButton )
	towerButton:addEventListener( "touch", towerButton )
	cavemanButton.isVisible = false
	towerButton.isVisible = false

	totemTowerButton = display.newImage("img/totemFinal.png", _W - 256, 64 + 128 * 2)
	globalSceneGroup:insert(totemTowerButton)
	totemTowerButton.isVisible = false
	totemTowerButton:addEventListener( "touch", totemTowerButton )

	fireTowerButton = display.newImage("img/fireTowerButton.png", _W - 256, 256)
	globalSceneGroup:insert(fireTowerButton)
	fireTowerButton.isVisible = false
	fireTowerButton:addEventListener( "touch", fireTowerButton )

	modernTowerButton = display.newImage("img/modernTower.png", _W - 256, 256 + 256)
	globalSceneGroup:insert(fireTowerButton)
	modernTowerButton.isVisible = false
	modernTowerButton:addEventListener( "touch", modernTowerButton )

	--Create Drag Images
	activeImage = nil
	dragCaveman = display.newImage("img/caveman.png", cavemanButton.x, cavemanButton.y)
	globalSceneGroup:insert(dragCaveman)
	dragCaveman.isVisible = false
	dragCaveman.type = "caveman"
	dragCaveman:addEventListener( "touch", dragImage )
	dragTower = display.newImage("img/tower.png", towerButton.x, towerButton.y)
	globalSceneGroup:insert(dragTower)
	dragTower.isVisible = false
	dragTower.type = "tower"
	dragTower:addEventListener( "touch", dragImage )

	dragFire = display.newImage("img/fireTowerButton.png", fireTowerButton.x, fireTowerButton.y)
	globalSceneGroup:insert(dragFire)
	dragFire.isVisible = false
	dragFire.type = "fire"
	dragFire:addEventListener( "touch", dragImage )

	dragModern = display.newImage("img/modernTower.png", modernTowerButton.x, modernTowerButton.y)
	globalSceneGroup:insert(dragModern)
	dragModern.isVisible = false
	dragModern.type = "modern"
	dragModern:addEventListener( "touch", dragImage )

	dragTotem = display.newImage("img/totemFinal.png", totemTowerButton.x, totemTowerButton.y)
	globalSceneGroup:insert(dragTotem)
	dragTotem.isVisible = false
	dragTotem.type = "totem"
	dragTotem:addEventListener( "touch", dragImage )


	--dragImage = nil
	--dragImage = display.newImage("img/tower.png", _W - 64, _H - 64)
	--dragImage.isVisible = false
	--dragImage:addEventListener( "touch", dragImage )
	dragImageRange = display.newCircle( 0, 0, 200)
	globalSceneGroup:insert(dragImageRange)
	dragImageRange:setFillColor(1, 0, 0, 20/255)
	dragImageRange.isVisible = false

	function towerButton:touch(event) 
		if(event.phase == "began") then
			shop:hide()
		end
		if money >= 100 and not currentlyDragging then
			dragTower.isVisible = true
			dragImageRange:removeSelf( )
			dragImageRange = display.newCircle( self.x, self.y, 150 )
			globalSceneGroup:insert(dragImageRange)
			dragImageRange:setFillColor(1, 0, 0, 20/255)
			activeImage = dragTower
			activeImage:toFront()
		end
	end

	function cavemanButton:touch(event)
		if(event.phase == "began") then 
			shop:hide()
		end
		if money >= 50 and not currentlyDragging then
			dragCaveman.isVisible = true
			dragImageRange:removeSelf()
			dragImageRange = display.newCircle( self.x, self.y, 100 )
			dragImageRange:setFillColor(1, 0, 0, 20/255)
			activeImage = dragCaveman
			activeImage:toFront()
		end
	end


	function totemTowerButton:touch(event)
		if(event.phase == "began") then 
			shop:hide()
		end
		if money >= 300 and not currentlyDragging then --tower's cost
			dragTotem.isVisible = true
			dragImageRange:removeSelf()
			dragImageRange = display.newRect( self.x, self.y, 96 * 2, 96 * 2 ) --tower's shoot range
			dragImageRange:setFillColor(1, 0, 0, 20/255)
			activeImage = dragTotem
		end
	end

	function fireTowerButton:touch(event)
		if(event.phase == "began") then 
			shop:hide()
		end
		if money >= 80 and not currentlyDragging then --tower's cost
			dragFire.isVisible = true
			dragImageRange:removeSelf()
			dragImageRange = display.newCircle( self.x, self.y, 120 ) --tower's shoot range
			dragImageRange:setFillColor(1, 0, 0, 20/255)
			activeImage = dragFire
		end
	end

	function modernTowerButton:touch(event)
		if(event.phase == "began") then 
			shop:hide()
		end
		if money >= 1000 and not currentlyDragging then --tower's cost
			dragModern.isVisible = true
			dragImageRange:removeSelf()
			dragImageRange = display.newCircle( self.x, self.y, 200 ) --tower's shoot range
			dragImageRange:setFillColor(1, 0, 0, 20/255)
			activeImage = dragModern
		end
	end

	--this way you can drag shop images over already placed towers
	function onEveryFrame(event)
		if activeImage ~= nil then
			activeImage:toFront()
		end
	end
	Runtime:addEventListener("enterFrame", onEveryFrame)

	nextStep()
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
--piercing tower
--levels will just differ in maps and get progressively harder
--have less turns and enemies spawn from multiple places