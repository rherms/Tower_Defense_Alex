--local composer = require( "composer" )
local scene = composer.newScene()

local function playGame()
	composer.gotoScene("levelselect", "fade", 400)
end

local function showInstructions()
	composer.gotoScene("instructions", "fade", 400)
end

local function goToTutorial()
	levelSelected = -1
	composer.gotoScene("tutorial", "fade", 400)
end

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )
    local sceneGroup = self.view
    local text = display.newText("Tower Defense: Eras", center_x, 100, native.systemFont, 90)
    text.anchorY = 0
	local playButton = widget.newButton( {shape = "roundedRect", fillColor = {default = {0, 1, 0, 0.8}, over = {0, 1, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = center_x, y = center_y, onRelease = playGame, label = "Play Game!", fontSize = 32} )
	local instructionsButton = widget.newButton( {shape = "roundedRect", fillColor = {default = {0, 1, 0, 0.8}, over = {0, 1, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = center_x, y = center_y + 100, onRelease = showInstructions, label = "Instructions", fontSize = 32} )
	local tutorialButton = widget.newButton( {shape = "roundedRect", fillColor = {default = {0, 1, 0, 0.8}, over = {0, 1, 0.5, 0.2}}, labelColor = {default={ 1, 1, 1, 1}, over={ 1, 1, 1, 1}}, x = center_x, y = center_y + 200, onRelease = goToTutorial, label = "Tutorial", fontSize = 32} )
	sceneGroup:insert(playButton)
	sceneGroup:insert(instructionsButton)
    sceneGroup:insert(text)
    sceneGroup:insert(tutorialButton)
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