--game is 960 by 640
--with tile sizes of 64x64, this is a grid of 15x10

GameMap = {}
--0 is grass, 1 is horizontal, 2 is rightDownTurn, 3 is vertical, 4 is crossroad, 5 is downLeftTurn, 6 is downRightTurn, 7 is leftDownTurn, 8 is leftUpTurn
--9 is rightUpTurn, 10 is upLeftTurn, 11 is upRightTurn, 12 is tPiece, 13 is boulder

--[[
map[1] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
map[2] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
map[3] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
map[4] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
map[5] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
map[6] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
map[7] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
map[8] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
map[9] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
map[10] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
--]]

function GameMap:drawMap()

    map = {}
    imageMap = {}
    imageMap[1] = {0,0,0,3,0,0,0,3,0,0,0,0,0,0,0}
    imageMap[2] = {7,1,1,5,0,0,0,8,1,1,1,1,1,10,0}
    imageMap[3] = {3,0,0,0,0,0,0,0,0,0,0,0,0,3,0}
    imageMap[4] = {3,0,0,0,11,1,1,1,1,1,1,2,0,3,0}
    imageMap[5] = {3,0,0,0,3,0,0,0,0,0,0,3,0,3,0}
    imageMap[6] = {6,1,1,1,9,0,13,13,13,13,0,3,0,3,0}
    imageMap[7] = {0,0,0,0,0,0,0,0,0,0,0,3,0,3,0}
    imageMap[8] = {0,7,1,1,1,1,1,1,1,1,1,5,0,3,0}
    imageMap[9] = {0,3,0,0,0,0,0,0,0,0,0,0,0,3,0}
    imageMap[10] ={0,6,1,1,1,1,1,1,1,1,1,1,1,9,0}

    --For map.startValues, each array in it is spawnPointX, spawnPointY, startDX, startDY
    if levelSelected == -1 then --this is the tutorial 
        map[1] = {0,0,0,3,0,0,0,3,0,0,0,0,0,0,0}
        map[2] = {7,1,1,5,0,0,0,8,1,1,1,1,1,10,0}
        map[3] = {3,0,0,0,0,0,0,0,0,0,0,0,0,3,0}
        map[4] = {3,0,0,0,11,1,1,1,1,1,1,2,0,3,0}
        map[5] = {3,0,0,0,3,0,0,0,0,0,0,3,0,3,0}
        map[6] = {6,1,1,1,9,0,13,13,13,13,0,3,0,3,0}
        map[7] = {0,0,0,0,0,0,0,0,0,0,0,3,0,3,0}
        map[8] = {0,7,1,1,1,1,1,1,1,1,1,5,0,3,0}
        map[9] = {0,3,0,0,0,0,0,0,0,0,0,0,0,3,0}
        map[10] ={0,6,1,1,1,1,1,1,1,1,1,1,1,9,0}
        map.startValues = {{64 * 3, -32, 0, 1}}
    elseif levelSelected == 1 then 
        map[1] = {0,0,0,3,0,0,0,3,0,0,0,0,0,0,0}
        map[2] = {7,1,1,5,0,0,0,8,1,1,1,1,1,10,0}
        map[3] = {3,0,0,0,0,0,0,0,0,0,0,0,0,3,0}
        map[4] = {3,0,0,0,11,1,1,1,1,1,1,2,0,3,0}
        map[5] = {3,0,0,0,3,0,0,0,0,0,0,3,0,3,0}
        map[6] = {6,1,1,1,9,0,13,13,13,13,0,3,0,3,0}
        map[7] = {0,0,0,0,0,0,0,0,0,0,0,3,0,3,0}
        map[8] = {0,7,1,1,1,1,1,1,1,1,1,5,0,3,0}
        map[9] = {0,3,0,0,0,0,0,0,0,0,0,0,0,3,0}
        map[10] ={0,6,1,1,1,1,1,1,1,1,1,1,1,9,0}
        map.startValues = {{64 * 3, -32, 0, 1}}
    elseif levelSelected == 2 then
        map[1] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
        map[2] = {0,0,0,0,0,13,7,1,1,1,1,10,0,0,0}
        map[3] = {0,0,0,0,0,13,3,0,0,0,0,3,0,0,0}
        map[4] = {0,0,0,0,0,13,6,1,1,1,1,4,1,1,1}
        map[5] = {1,1,1,1,1,1,1,1,2,0,0,3,0,0,0}
        map[6] = {0,0,0,0,0,0,0,0,3,0,13,3,0,0,0}
        map[7] = {0,0,0,0,0,11,1,1,4,1,1,9,0,0,0}
        map[8] = {0,0,0,0,0,3,0,0,3,0,0,0,0,0,0}
        map[9] = {0,0,0,0,0,8,1,1,5,0,0,0,0,0,0}
        map[10] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
        map.startValues = {{-32, 64 * 4, 1, 0}}
    elseif levelSelected == 3 then
        map[1] = {13,13,13,13,13,13,13,13,13,13,13,13,13,13,13}
        map[2] = {13,7,1,1,1,1,1,1,1,1,1,1,1,10,13}
        map[3] = {13,3,0,0,0,0,0,0,0,0,0,0,0,3,13}
        map[4] = {13,3,0,7,1,1,1,1,1,1,1,10,0,3,13}
        map[5] = {13,3,0,3,0,0,0,0,0,0,0,3,0,3,13}
        map[6] = {13,3,0,6,1,1,1,1,1,1,1,4,1,4,1}
        map[7] = {13,3,0,0,0,0,0,0,0,0,0,3,0,3,13}
        map[8] = {13,6,1,1,1,1,1,1,1,1,1,9,0,3,13}
        map[9] = {13,0,0,0,0,0,0,0,0,0,0,0,0,3,13}
        map[10] ={1,1,1,1,1,1,1,1,1,1,1,1,1,9,13}
        map.startValues = {{-32, 64 * 9, 1, 0}}
    elseif levelSelected == 4 then
        map[1] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
        map[2] = {1,1,1,1,1,2,0,0,0,7,1,1,1,1,1}
        map[3] = {0,0,0,0,0,3,0,0,0,3,0,0,0,0,0}
        map[4] = {0,0,11,1,1,4,1,12,1,4,1,1,10,0,0}
        map[5] = {0,0,3,0,0,3,0,3,0,3,0,0,3,0,0}
        map[6] = {0,0,8,1,1,5,0,3,0,6,1,1,9,0,0}
        map[7] = {0,0,0,0,0,0,0,3,0,0,0,0,0,0,0}
        map[8] = {13,13,13,13,13,13,13,3,13,13,13,13,13,13,13}
        map[9] = {13,13,13,13,13,13,13,3,13,13,13,13,13,13,13}
        map[10] = {13,13,13,13,13,13,13,3,13,13,13,13,13,13,13}
        map.startValues = {{-32, 64, 1, 0}, {_W, 64, -1, 0}}
    elseif levelSelected == 5 then
        map[1] = {0,0,0,0,0,0,0,7,1,10,1,10,1,10,13}
        map[2] = {0,0,0,0,0,0,0,3,0,3,0,3,0,3,13}
        map[3] = {1,1,1,1,1,1,1,4,1,4,1,4,1,9,13}
        map[4] = {0,0,0,0,0,0,0,3,0,3,0,3,13,13,13}
        map[5] = {0,0,0,0,0,0,0,3,0,3,0,3,13,13,13}
        map[6] = {1,1,1,1,1,1,1,4,1,4,1,9,13,13,13}
        map[7] = {0,0,0,0,0,0,0,3,0,3,13,13,13,13,13}
        map[8] = {0,0,0,0,0,0,0,3,0,3,13,13,13,13,13}
        map[9] = {1,1,1,1,1,1,1,4,1,9,13,13,13,13,13}
        map[10] ={0,0,0,0,0,0,0,3,13,13,13,13,13,13,13}
        map.startValues = {{-32, 128, 1, 0}, {-32, 320, 2, 0}, {-32, 512, 3, 0}}
    elseif levelSelected == 6 then 
        map[1] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
        map[2] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
        map[3] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
        map[4] = {1,1,1,1,1,1,1,1,1,1,1,2,0,0,0}
        map[5] = {0,0,0,0,0,0,0,0,0,13,13,3,0,0,0}
        map[6] = {0,0,0,0,0,0,0,0,0,13,13,3,0,0,0}
        map[7] = {0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}
        map[8] = {0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}
        map[9] = {0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}
        map[10] ={0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}
        map.startValues = {{-32, 64 * 3, 1, 0}}
    elseif levelSelected == 7 then
        map[1] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
        map[2] = {1,1,1,2,0,0,11,1,1,2,0,0,11,1,1}
        map[3] = {0,0,0,3,0,0,3,0,0,3,0,0,3,0,0}
        map[4] = {0,0,0,6,1,1,9,0,0,6,1,1,9,0,0}
        map[5] = {13,13,13,13,13,13,13,13,13,13,13,13,13,13,13}
        map[6] = {13,13,13,13,13,13,13,13,13,13,13,13,13,13,13}
        map[7] = {0,0,0,11,1,1,2,0,0,11,1,1,2,0,0}
        map[8] = {0,0,0,3,0,0,3,0,0,3,0,0,3,0,0}
        map[9] = {1,1,1,9,0,0,6,1,1,9,0,0,6,1,1}
        map[10] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
        map.startValues = {{-32, 64, 1, 0}, {-32, 512, 1, 0}}
    elseif levelSelected == 8 then
        map[1] = {13,13,13,13,13,0,0,3,0,0,13,13,13,13,13}
        map[2] = {13,13,13,13,13,0,0,3,0,0,13,13,13,13,13}
        map[3] = {0,0,0,0,0,13,0,3,0,13,0,0,0,0,0}
        map[4] = {0,0,0,0,0,0,13,3,13,0,0,0,0,0,0}
        map[5] = {1,1,1,1,1,1,1,4,1,1,1,1,1,1,1}
        map[6] = {0,0,0,0,0,0,13,3,13,0,0,0,0,0,0}
        map[7] = {0,0,0,0,0,13,0,3,0,13,0,0,0,0,0}
        map[8] = {13,13,13,13,13,0,0,3,0,0,13,13,13,13,13}
        map[9] = {13,13,13,13,13,0,0,3,0,0,13,13,13,13,13}
        map[10] ={13,13,13,13,13,0,0,3,0,0,13,13,13,13,13}
        map.startValues = {{-32, 64 * 4, 1, 0}, {448, -32, 0, 1}}
    elseif levelSelected == 9 then
        map[1] = {13, 0, 0, 0, 0,13, 0, 0, 0, 0,13, 0, 0, 0, 0}
        map[2] = { 0,13, 0, 0,13, 0,13, 0, 0,13, 0,13, 0, 0,13}
        map[3] = { 0,13, 0, 0,13, 0,13, 0, 0,13, 0,13, 0, 0,13}
        map[4] = { 0, 0,13,13, 0, 0, 0,13,13, 0, 0, 0,13,13, 0}
        map[5] = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
        map[6] = { 0, 0,13,13, 0, 0, 0,13,13, 0, 0, 0,13,13, 0}
        map[7] = { 0, 0,13,13, 0, 0, 0,13,13, 0, 0, 0,13, 0,13}
        map[8] = { 0,13, 0, 0,13, 0,13, 0, 0,13, 0,13, 0, 0,13}
        map[9] = { 0,13, 0, 0,13, 0,13, 0, 0,13, 0,13, 0, 0, 0}
        map[10] ={13, 0, 0, 0, 0,13, 0, 0, 0, 0,13, 0, 0, 0, 0}
        map.startValues = {{-32, 64 * 4, 1, 0}, {_W, 64 * 4, -1, 0}}
    --bonus level
    elseif levelSelected == 9001 then
        map[1] = { 2, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1}
        map[2] = { 6, 2, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1}
        map[3] = { 0, 6, 2, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0}
        map[4] = { 0, 0, 6, 2, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0}
        map[5] = { 0, 0, 0, 6, 4, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0}
        map[6] = { 0, 0, 0,11, 4, 2, 0, 0, 0, 1, 1, 1, 0, 0, 0}
        map[7] = { 0, 0,11,8, 0, 6, 2, 0, 1, 1, 0, 1, 1, 0, 0}
        map[8] = { 0,11,8, 0, 0, 0, 6, 2, 1, 0, 0, 0, 1, 1, 0}
        map[9] = {11,8, 0, 0, 0, 0, 1, 6, 2, 0, 0, 0, 0, 1, 1}
        map[10] = {8, 0, 0, 0, 0, 0, 1, 0,3, 0, 0, 0, 0, 0, 1}
        map.startValues = {{-32, 64 * 4, 1, 0}, {_W, 64 * 4, -1, 0}}
    end
    
	for i = 1, #map do
    	for j = 1, #map[1] do
            local image = {}
        	--0 is grass, 1 is horizontal, 2 is rightDownTurn, 3 is vertical, 4 is crossroad, 5 is downLeftTurn, 6 is downRightTurn, 7 is leftDownTurn, 8 is leftUpTurn
            --9 is rightUpTurn, 10 is upLeftTurn, 11 is upRightTurn
        	if map[i][j] == 0 then
        		image = display.newImage( "img/map/grass.png", 64*j - 32, 64 * i -32 )
        	elseif map[i][j] == 1 then
        		image = display.newImage( "img/map/horizontalPath.png", 64*j - 32, 64 * i -32 )
        	elseif map[i][j] == 2 then
        		image = display.newImage( "img/map/rightDownCorner.png", 64*j - 32, 64 * i -32 )
        	elseif map[i][j] == 3 then
        		image = display.newImage( "img/map/verticalPath.png", 64*j - 32, 64 * i -32 )
            elseif map[i][j] == 4 then
                image = display.newImage( "img/map/crossroad.png", 64*j - 32, 64 * i -32 )
            elseif map[i][j] == 5 then
                image = display.newImage( "img/map/downLeftCorner.png", 64*j - 32, 64 * i -32 )
            elseif map[i][j] == 6 then
                image = display.newImage( "img/map/downRightCorner.png", 64*j - 32, 64 * i -32 )
            elseif map[i][j] == 7 then
                image = display.newImage( "img/map/leftDownCorner.png", 64*j - 32, 64 * i -32 )
            elseif map[i][j] == 8 then
                image = display.newImage( "img/map/leftUpCorner.png", 64*j - 32, 64 * i -32 )
            elseif map[i][j] == 9 then
                image = display.newImage( "img/map/rightUpCorner.png", 64*j - 32, 64 * i -32 )
            elseif map[i][j] == 10 then
                image = display.newImage( "img/map/upLeftCorner.png", 64*j - 32, 64 * i -32 )
            elseif map[i][j] == 11 then
                image = display.newImage( "img/map/upRightCorner.png", 64*j - 32, 64 * i -32 )    
            elseif map[i][j] == 12 then
                image = display.newImage( "img/map/tPiece.png", 64*j - 32, 64 * i -32 )    
            elseif map[i][j] == 13 then
                image = display.newImage( "img/map/boulderGrass.png", 64*j - 32, 64 * i -32 )    
        	end
            image:addEventListener( "touch", laserTowerHandler )
            globalSceneGroup:insert(image)
            imageMap[i][j] = image
    	end
	end

    --put boulders under the buttons so they can't place towers on the buttons
    map[10][15] = 13
    map[1][15] = 13
    map[1][1] = 13  
    map[1][2] = 13
    map[1][7] = 13
    map[1][8] = 13
    map[1][9] = 13

	arrows = {}
    for i = 1, #map.startValues do
        local arr = map.startValues[i]
        --arr[3] = dx, arr[4] = dy
        local moveX, moveY = 0, 0
        local img = ""
        if arr[3] == 0 and arr[4] > 0 then
            img = "img/arrowDown.png"
        elseif arr[3] == 0 and arr[4] < 0 then
            img = "img/arrowUp.png"
            moveY = -48
        elseif arr[3] > 0 and arr[4] == 0 then
            img = "img/arrowRight.png"
        elseif arr[3] < 0 and arr[4] == 0 then
            img = "img/arrowLeft.png"
            moveX = -48
        end
        local arrow = display.newImage(img, arr[1] + moveX, arr[2] + moveY)
        arrow.anchorX, arrow.anchorY = 0, 0
        globalSceneGroup:insert(arrow)
        table.insert(arrows, arrow)
    end
end