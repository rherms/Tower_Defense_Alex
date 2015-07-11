require("inc.newPanel")
score = 0
money = 10000
lives = 10
shopDisplayed = false
text = nil
button = nil
rect = {}
grassHighlight = nil
function resumeGame(event)
	rect:removeSelf()
	text:removeSelf()
	button:removeSelf()
	displayingMessage = false
	if paused then --just in case
		pauseOrPlayGame()
	end
	if event == "info" or event.target.type == "info" then
		sellButton:removeSelf()
		sellPrice:removeSelf()
		upgradeButton:removeSelf()
		upgradedStat:removeSelf()
	elseif event.target.type == "unlock" then
		spawnNextWave()
	end
end

function updateShopButtons(param)
	for key, val in pairs(towerButtons) do
		val.isVisible = param
		val.infoButton.isVisible = param
	end
end

function displayUnlockMessage(towersUnlocked)
	if shopDisplayed then
		shop:hide()
	end
	if not paused then
		pauseOrPlayGame()
	end
	displayingMessage = true
	local message = ""
	if towersUnlocked == 2 then
		message = "Congratulations on making it through the first time period! Your cavemen have been fighting hard\n"
		message = message .. "and have unlocked the power of fire! This new tower will be a handy asset that shoots\n"
		message = message .. "fireballs in a circle around it. However, with this new tower comes a new enemy as well.\n"
		message = message .. "Saber-toothed tigers have been spotted roaming around, and they are quick. Good luck!"
	elseif towersUnlocked == 3 then
		message = "Time is progressing fast and the medieval era is upon you! You will find your arsenal equipped \n"
		message = message .. "with a powerful cannon. You will also find some derpy knights.\n"
	elseif towersUnlocked == 4 then
		message = "Modern tower currently under construction...please standby ( ͡° ͜ʖ ͡°)\n"
	end
	rect = display.newRect(center_x, center_y, _W - 100, _H - 100)
	rect:setFillColor(0, 0.5, 0)
	text = display.newText(message, center_x, center_y, native.systemFont, 20)
	--text:setFillColor( 0.5, 1, 0.2 )
	button = widget.newButton( {shape = "roundedRect", labelColor = {default = {0, 0, 0, 1}, over = {0, 0, 0, 1}}, fillColor = {default = {1, 0, 0, 1}, over = {1, 0, 0, 0.5}}, x = center_x, y = _H - 100, onRelease = resumeGame, label = "Dismiss", width = 150, height = 75, fontSize = 26} )
	button.type = "unlock"
	updateShopButtons(false)
end


function sendShopToFront()
	shop:toFront() --ensure enemies don't go over the shop
	shopButton:toFront() --ensure the button remains on top of the shop
	for key, val in pairs(towerButtons) do 
		val:toFront()
		val.infoButton:toFront()
	end
	if activeImage ~= nil then
		activeImage:toFront()
	end
end

function updateShop()
	--[[if towersUnlocked < 5 then
		modernTowerButton.isVisible = false
	end
	if towersUnlocked < 4 then
		towerButton.isVisible = false
	end
	if towersUnlocked < 3 then
		totemTowerButton.isVisible = false
		moneyTowerButton.isVisible = false
	end
	if towersUnlocked < 2 then
		fireTowerButton.isVisible = false
	end--]]
end

function updateBoolAndMap() --modify this for each tower added. this is called by onComplete for the sliding widget
	if shopDisplayed then 
		updateShopButtons(false)
	else
		updateShopButtons(true)
	end
	shopDisplayed = not shopDisplayed
	updateShop()
end

function updateScore(change)
	score = score+change
	--scoreDisplay.text = score
end

function updateLives(change)
	lives = lives+change
	livesDisplay.text = lives
end

function updateMoney(change)
	money = money+change
	moneyDisplay.text = "$" .. money
end

function resetVariables()
	score = 0
	money = 10000
	lives = 10
	shopDisplayed = false
	paused = false
	displayingMessage = false
	text = nil
	button = nil
end

function goToLevelSelect()
	--timer.cancel( timerID )
	rect:removeSelf()
	text:removeSelf()
	button:removeSelf()
	resetVariables()
	if paused then --just in case
		pauseOrPlayGame()
	end
	composer.gotoScene("levelselect", "fade", 400)
end

function displayMessage(message)
	if shopDisplayed then
		shop:hide()
	end
	if not paused then
		pauseOrPlayGame()
	end
	displayingMessage = true
	rect = display.newRect(center_x, center_y, _W - 100, _H - 100)
	rect:setFillColor(0, 0.5, 0)
	text = display.newText(message, center_x, center_y, native.systemFont, 20)
	--text:setFillColor( 0.5, 1, 0.2 )
	button = widget.newButton( {shape = "roundedRect", labelColor = {default = {0, 0, 0, 1}, over = {0, 0, 0, 1}}, fillColor = {default = {1, 0, 0, 1}, over = {1, 0, 0, 0.5}}, x = center_x, y = _H - 100, onRelease = goToLevelSelect, label = "Dismiss", width = 150, height = 75, fontSize = 26} )
	updateShopButtons(false)
end

function nextStep()
	step = step + 1
	if(text ~= nil) then
		text:removeSelf()
	end
	if(button ~= nil) then
	    button:removeSelf()
	end
	if step == 1 then
		local message = "Welcome to the tutorial! Here you will learn the basics of this game.\n To get started, press the Next button under this message."
		displayTutorialMessage(message, center_x, center_y, 30, "Next")
	elseif step == 2 then
		local message = "On the left is where you can see how many lives you have\n"
		message = message.. "and how much score and money you have accumulated.\n"
		message = message .. "From top to bottom, they are Lives and Money.\n <---------------------------------------------------------------------"
		displayTutorialMessage(message, center_x, center_y + 150, 22, "Next")
	elseif step == 3 then
		local message = "On the right is the pause button. With this you can pause the game\n anytime unless you are not currently in a wave.\nYou can still purchase, place, upgrade, and sell towers when paused."
		message = message .. "\nNow let's go purchase your first tower!"
		displayTutorialMessage(message, center_x, center_y + 150, 22, "Next")
	elseif step == 4 then
		local message = "Click on this button in the upper right corner to open the shop."
		displayTutorialMessage(message, center_x, center_y - 250, 30, nil)
	elseif step == 5 then
		local message = "This is the shop. As you unlock new towers, they will\n"
		message = message .. "appear near the left edge of the shop. To place \n"
		message = message .. "a tower, just touch and drag a picture of a tower.\n"
		message = message .. "You cannot place them on roads, boulders, or \n"
		message = message .. "existing towers. You also cannot place them if you \n"
		message = message .. "have insufficient funds. Try placing a caveman tower now.\n"
		message = message .. "on the highlighted square."
		grassHighlight = display.newImage( "img/map/grassHighlight.png", 64*3 - 32, 64 * 4 -32 )
		globalSceneGroup:insert(grassHighlight)
		displayTutorialMessage(message, center_x - 120, center_y + 50, 22, nil)
	elseif step == 6 then
		grassHighlight:removeSelf()
		local message = "Nice job! Instead of buying new towers, you can also\n"
		message = message .. "upgrade existing towers. Upgrades will vary for \n"
		message = message .. "each type of tower, but will always make the tower\n"
		message = message .. "better. You can also sell a tower to get some money\n"
		message = message .. "back. To access the upgrading and selling feature, \n"
		message = message .. "tap an existing tower. Try upgrading your caveman tower now"
		displayTutorialMessage(message, center_x - 120, center_y + 50, 22, nil)
	elseif step == 7 then
		nextWaveButton.isVisible = true
		local message = "We have now enabled the Start Wave button. This button will\n"
		message = message .. "appear once all the enemies in a wave have spawned. \n"
		message = message .. "Make sure your towers are ready for a new wave of \n"
		message = message .. "enemies before clicking it. Try clicking it now\n"
		message = message .. "to see how your caveman fares against a couple of dinosaurs."
		displayTutorialMessage(message, center_x - 120, center_y + 50, 22, nil)
	elseif step == 8 then
		local message = "Excellent work! After beating many waves of a certain enemy,\n"
		message = message .. "you will advance to the next time period, unlocking \n"
		message = message .. "a new tower as well as new enemies. For this tutorial, \n"
		message = message .. "we will advance you to the next era now. You will find \n"
		message = message .. "a fire tower in the shop and saber-toothed tigers in the\n"
		message = message .. "next wave. Let's sell your caveman, and buy a fire tower.\n"
		message = message .. "Sell your caveman tower now."
		displayTutorialMessage(message, center_x - 120, center_y + 50, 22, nil)
	elseif step == 9 then
		local message = "As you can see, selling a tower refunds you some money, but\n"
		message = message .. "only a fraction of what you paid for it initially. \n"
		message = message .. "Each time you upgrade a tower, its sell price will increase.\n"
		message = message .. "Now, let's buy a fire tower. These will shoot fireballs in all\n"
		message = message .. "directions around it!"
		displayTutorialMessage(message, center_x - 120, center_y + 50, 22, nil)
	elseif step == 10 then
		local message = "Great work! This concludes the tutorial. You can continue\n"
		message = message .. "to play to see new enemies and towers or you can quit \n"
		message = message .. "and try your luck at some of the levels. Happy playing!\n"
		displayTutorialMessage(message, center_x - 120, center_y + 50, 22, nil)
		nextWaveButton.isVisible = true
		quitButton.isVisible = true
		if levelsUnlocked == 0 then
			levelsUnlocked = 1
		end
	--[[elseif step == 11 then
			text = nil
			button = nil
	elseif step == 12 then
		local message = "Congratulations you beat the tutorial!"
		displayTutorialMessage(message, center_x - 120, center_y + 50, 22, "Dismiss")
	elseif step == 13 then
		text = nil
		button = nil
		step = 0
		composer.gotoScene("title")--]]
	end

	--if we are at step about spawn wave button, nextWaveButton.isVisible = true
end

function displayTutorialMessage(message, x, y, fontSize, buttonText) 
	if shopDisplayed then
		shop:hide()
	end
	--displayingMessage = true
	--rect = display.newRect(center_x, center_y, _W - 100, _H - 100)
	--rect:setFillColor(0, 0.5, 0)
	text = display.newText({text = message, x = x, y = y, font = native.systemFont, fontSize = fontSize, align = "center"})
	--text:setFillColor( 0.5, 1, 0.2 )
	if(buttonText ~= nil) then
		button = widget.newButton( {shape = "roundedRect", labelColor = {default = {0, 0, 0, 1}, over = {0, 0, 0, 1}}, fillColor = {default = {1, 0, 0, 1}, over = {1, 0, 0, 0.5}}, x = x, y = y + text.height, onRelease = nextStep, label = buttonText, width = 150, height = 25, fontSize = 26} )
	end
	updateShopButtons(false)
end

function loseLife()
	lives = lives-1
	livesDisplay.text = "Lives: " .. lives
	if(lives <= 0) then
		displayMessage("You lost :( What a scrub...")
	end
end


function displayTowerMenu()
	if not(levelSelected == -1 and ((step ~= 4 and step ~= 5)and step < 9)) then --if we're in tutorial, don't enable shop until appropriate time
		if not displayingMessage then 
			shopButton:setEnabled( false )	
			if not shopDisplayed then
				shop:show()
				shop:toFront()
				shopButton:toFront()
			else
				shop:hide()
			end
			shopButton:setEnabled( true )
		end
		if step == 4 then 
			nextStep()
		end
	end
end