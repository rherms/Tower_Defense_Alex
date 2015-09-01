local scene = composer.newScene()

local function displayTitle() 
	composer.gotoScene("title", "fade", 400)
end

local function goToLevel(event)
    levelSelected = event.target.level
    if levelsUnlocked >= event.target.level then 
        composer.gotoScene("chooseDifficulty", "fade", 400)
    end
end

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local function makeButton(i, sceneGroup, levelButtons)
   	local fileName = "img/levels/level" .. i .. ".png"
   	local x = _W/4 * (((i - 1) % 3) + 1)
   	local y = _H/4 * (math.floor((i - 1) / 3) + 1)
   	local levelButton = widget.newButton( {defaultFile = fileName, width = 213, height = 120, x = x, y = y, onRelease = goToLevel, label = i, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, fontSize = 32})
   	levelButton.level = i
   	sceneGroup:insert(levelButton)
end


-- "scene:create()"
function scene:create( event )
    --display.setDefault("background", 0.5, 1, 1)
    local sceneGroup = self.view
	local text = display.newText("Level Select", center_x, 0, native.systemFont, 40)
    text.anchorY = 0
	local backButton = widget.newButton( {shape = "roundedRect", labelColor = {default = {0, 0, 0, 1}, over = {0, 0, 0, 1}}, fillColor = {default = {1, 0, 0, 1}, over = {1, 0, 0, 0.5}}, x = 0, y = 0, onRelease = displayTitle, label = "Back", fontSize = 32})
    backButton.anchorX, backButton.anchorY = 0, 0
	sceneGroup:insert(text)
	sceneGroup:insert(backButton)
	if levelsUnlocked == 0 then
		local msg = display.newText("You must play the tutorial to unlock level 1.", center_x, 70, native.systemFont, 20)
		sceneGroup:insert(msg)
	end
    --add lock symbols later
    --get rid of onEvent, fix onRelease
    --[[local levelOneButton = widget.newButton( {shape = "circle", fillColor = {default = {0, 1, 0, 0.8}, over = {0, 1, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = _W/4, y = _H/4, onRelease = playGame, label = "1", fontSize = 32, onEvent = goToLevel})
    local levelTwoButton = widget.newButton( {shape = "circle", fillColor = {default = {0, 1, 0, 0.8}, over = {0, 1, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = _W/2, y = _H/4, onRelease = playGame, label = "2", fontSize = 32, onEvent = goToLevel})
    local levelThreeButton = widget.newButton( {shape = "circle", fillColor = {default = {0, 1, 0, 0.8}, over = {0, 1, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = _W*3/4, y = _H/4, onRelease = playGame, label = "3", fontSize = 32, onEvent = goToLevel})
    local levelFourButton = widget.newButton( {shape = "circle", fillColor = {default = {0, 1, 0, 0.8}, over = {0, 1, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = _W/4, y = _H/2, onRelease = playGame, label = "4", fontSize = 32, onEvent = goToLevel})
    local levelFiveButton = widget.newButton( {shape = "circle", fillColor = {default = {0, 1, 0, 0.8}, over = {0, 1, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = _W/2, y = _H/2, onRelease = playGame, label = "5", fontSize = 32, onEvent = goToLevel})
    local levelSixButton = widget.newButton( {shape = "circle", fillColor = {default = {0, 1, 0, 0.8}, over = {0, 1, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = _W*3/4, y = _H/2, onRelease = playGame, label = "6", fontSize = 32, onEvent = goToLevel})
    local levelSevenButton = widget.newButton( {shape = "circle", fillColor = {default = {0, 1, 0, 0.8}, over = {0, 1, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = _W/4, y = _H*3/4, onRelease = playGame, label = "7", fontSize = 32, onEvent = goToLevel})
    local levelEightButton = widget.newButton( {shape = "circle", fillColor = {default = {0, 1, 0, 0.8}, over = {0, 1, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = _W/2, y = _H*3/4, onRelease = playGame, label = "8", fontSize = 32, onEvent = goToLevel})
    local levelNineButton = widget.newButton( {shape = "circle", fillColor = {default = {0, 1, 0, 0.8}, over = {0, 1, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = _W*3/4, y = _H*3/4, onRelease = playGame, label = "9", fontSize = 32, onEvent = goToLevel})--]]
   	local levelButtons = {}
   	for i = 1, 9 do
   		makeButton(i, sceneGroup)
   	end
   	for i = levelsUnlocked + 1, 9 do
   		local x = _W/4 * (((i - 1) % 3) + 1)
   		local y = _H/4 * (math.floor((i - 1) / 3) + 1)
   		local lock = display.newImage("img/lock.png")
   		lock.x = x
   		lock.y = y
   		lock.width = 64
   		lock.height = 64
   		sceneGroup:insert(lock)
   	end
    --[[local levelOneButton = widget.newButton( {defaultFile = "img/levels/level1.png", width = 213, height = 120, x = _W/4, y = _H/4, onRelease = goToLevel, label = "1", labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, fontSize = 32})
    local levelTwoButton = widget.newButton( {defaultFile = "img/levels/level2.png", width = 213, height = 120, x = _W/2, y = _H/4, onRelease = goToLevel, label = "2", labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, fontSize = 32})
    local levelThreeButton = widget.newButton( {defaultFile = "img/levels/level3.png", width = 213, height = 120, x = _W*3/4, y = _H/4, onRelease = goToLevel, label = "3", labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, fontSize = 32})
    local levelFourButton = widget.newButton( {defaultFile = "img/levels/level4.png", width = 213, height = 120, x = _W/4, y = _H/2, onRelease = goToLevel, label = "4", labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, fontSize = 32})
    local levelFiveButton = widget.newButton( {defaultFile = "img/levels/level5.png", width = 213, height = 120, x = _W/2, y = _H/2, onRelease = goToLevel, label = "5", labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, fontSize = 32})
    local levelSixButton = widget.newButton( {defaultFile = "img/levels/level6.png", width = 213, height = 120, x = _W*3/4, y = _H/2, onRelease = goToLevel, label = "6", labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, fontSize = 32})
    local levelSevenButton = widget.newButton( {defaultFile = "img/levels/level7.png", width = 213, height = 120, x = _W/4, y = _H*3/4, onRelease = goToLevel, label = "7", labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, fontSize = 32})
    local levelEightButton = widget.newButton( {defaultFile = "img/levels/level8.png", width = 213, height = 120, x = _W/2, y = _H*3/4, onRelease = goToLevel, label = "8", labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, fontSize = 32})
    local levelNineButton = widget.newButton( {defaultFile = "img/levels/level9.png", width = 213, height = 120, x = _W*3/4, y = _H*3/4, onRelease = goToLevel, label = "9", labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, fontSize = 32})
    levelOneButton.level = 1
    levelTwoButton.level = 2
    levelThreeButton.level = 3
    levelFourButton.level = 4
    levelFiveButton.level = 5
    levelSixButton.level = 6
    levelSevenButton.level = 7
    levelEightButton.level = 8
    levelNineButton.level = 9
    local levelButtons = {}
    table.insert(levelButtons, levelOneButton)
    table.insert(levelButtons, levelTwoButton)
    table.insert(levelButtons, levelThreeButton)
    table.insert(levelButtons, levelFourButton)
    table.insert(levelButtons, levelFiveButton)
    table.insert(levelButtons, levelSixButton)
    table.insert(levelButtons, levelSevenButton)
    table.insert(levelButtons, levelEightButton)
    table.insert(levelButtons, levelNineButton)
    --add locks
    for i = levelsUnlocked, 9 do
    	--local lock = display.newImage("img/lock.png", {x = , })
    end
    sceneGroup:insert(levelOneButton)
    sceneGroup:insert(levelTwoButton)
    sceneGroup:insert(levelThreeButton)
    sceneGroup:insert(levelFourButton)
    sceneGroup:insert(levelFiveButton)
    sceneGroup:insert(levelSixButton)
    sceneGroup:insert(levelSevenButton)
    sceneGroup:insert(levelEightButton)
    sceneGroup:insert(levelNineButton)--]]
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    --[[for key,value in pairs(sceneGroup) do
    	sceneGroup[key]:removeSelf()
    end--]]

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene