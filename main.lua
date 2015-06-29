widget = require("widget")
math.randomseed( os.time() )
_W, _H = display.contentWidth, display.contentHeight
center_x = _W / 2
center_y = _H / 2

levelsUnlocked = 9
levelSelected = 0
paused = false
difficulty = 0 --0 is easy, 1 is normal, 2 is hard

composer = require "composer"
composer.recycleOnSceneChange = true
display.setStatusBar( display.HiddenStatusBar )
composer.gotoScene("title", "fade", 400)