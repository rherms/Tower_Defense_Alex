local scene = composer.newScene()

local function goToLevelSelect() 
	composer.gotoScene("levelselect", "fade", 400)
end

local function goToLevel(event)
    difficulty = event.target.level
    composer.gotoScene("playGame", "fade", 400)
end

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local function makeButton(i, sceneGroup)
   	local x = center_x
   	local y = center_y - 128 + (i * 128)
    local buttonText = ""
    if(i == 0) then
        buttonText = "Easy"
    elseif(i == 1) then
        buttonText = "Normal"
    elseif(i == 2) then
        buttonText = "Hard"
    end
    local button = widget.newButton({shape = "roundedRect", labelColor = {default = {0, 0, 0, 1}, over = {0, 0, 0, 1}}, fillColor = {default = {1, 0, 0, 1}, over = {1, 0, 0, 0.5}}, x = center_x, y = y, onRelease = goToLevel, label = buttonText, width = 128, height = 64, fontSize = 26})   	
    button.level = i
   	sceneGroup:insert(button)
end


-- "scene:create()"
function scene:create( event )
    --display.setDefault("background", 0.5, 1, 1)
    local sceneGroup = self.view
	local text = display.newText("Choose Difficulty", center_x, 0, native.systemFont, 40)
    text.anchorY = 0
	local backButton = widget.newButton( {shape = "roundedRect", labelColor = {default = {0, 0, 0, 1}, over = {0, 0, 0, 1}}, fillColor = {default = {1, 0, 0, 1}, over = {1, 0, 0, 0.5}}, x = 0, y = 0, onRelease = goToLevelSelect, label = "Back", fontSize = 32})
    backButton.anchorX, backButton.anchorY = 0, 0
	sceneGroup:insert(text)
	sceneGroup:insert(backButton)
	
   	for i = 0, 2 do
   		makeButton(i, sceneGroup)
   	end
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