--@see http://lua-users.org/wiki/MathLibraryTutorial
--require "sprite"
widget = require("widget")
require ("inc.utils")
require ("inc.player")
require ("inc.tower")
require ("inc.bullet")
require ("inc.enemy")
require ("inc.gamemap")
require ("inc.newPanel")
math.randomseed( os.time() )

local map = {}
map[1] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}
map[2] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
map[3] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
map[4] = {1,1,1,1,1,1,1,1,1,1,1,2,0,0,0}
map[5] = {0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}
map[6] = {0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}
map[7] = {0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}
map[8] = {0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}
map[9] = {0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}
map[10] ={0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}

_W, _H = display.contentWidth, display.contentHeight
display.setStatusBar( display.HiddenStatusBar )
local center_x = _W / 2
local center_y = _H / 2
fps = 30

--background
local bg = display.newRect(center_x, center_y, 960, 640)
GameMap:drawMap()

--Create tower button
local towerButton = widget.newButton( {x = _W - 32, y = 32, width = 80, height = 80, defaultFile = "img/towerbutton.png", onEvent = displayTowerMenu})

scoreDisplay = display.newText(score, 0, _H-60, native.systemFontBold, 48)
scoreDisplay.anchorX = 0
scoreDisplay.anchorY = 0
moneyDisplay = display.newText("$" .. money, 0, _H-120, native.systemFontBold, 48)
moneyDisplay.anchorX = 0
moneyDisplay.anchorY = 0
livesDisplay = display.newText("Lives: " .. lives, 0, _H-180, native.systemFontBold, 48)
livesDisplay.anchorX = 0
livesDisplay.anchorY = 0
--utils.showFps()

--create turelss
enemies = {}

local function createNewEnemy()

	local enemy = Enemy:new()

	table.insert(enemies, enemy)

end

local function addTower(event)
		--tile size is 64x64, so divide by 64 and round down (0 indexed)
		local tile_x = math.floor(event.x/64) 
		local tile_y = math.floor(event.y/64) 
		print("X tile: " .. tile_x)
		print("Y tile: " .. tile_y)
	if money >= 100 and map[tile_y + 1][tile_x + 1] == 0 then
		tower = newTower:new({x = tile_x*64+32, y = tile_y*64+32, shootRange = 150})
		updateMoney(-100)
		map[tile_y + 1][tile_x + 1] = 4 --4 means there is a turret there
	end
end

timer.performWithDelay( 800, createNewEnemy, 30 )

bg:addEventListener( "tap", addTower )