

--game is 960 by 640
--with tile sizes of 64x64, this is a grid of 15x10

GameMap = {}

map = {}
map[1] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
map[2] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
map[3] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
map[4] = {1,1,1,1,1,1,1,1,1,1,1,2,0,0,0}
map[5] = {0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}
map[6] = {0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}
map[7] = {0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}
map[8] = {0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}
map[9] = {0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}
map[10] ={0,0,0,0,0,0,0,0,0,0,0,3,0,0,0}

function GameMap:drawMap()

	for i = 1, #map do
    	for j = 1, #map[1] do
        	--print(map[i][j])
        	
        	if map[i][j] == 0 then
        		local grass = display.newImage( "img/grass.png", 64*j - 32, 64 * i -32 )
        	elseif map[i][j] == 1 then
        		local path = display.newImage( "img/path.png", 64*j - 32, 64 * i -32 )
        	elseif map[i][j] == 2 then
        		local corner = display.newImage( "img/corner1.png", 64*j - 32, 64 * i -32 )
        	elseif map[i][j] == 3 then
        		local corner = display.newImage( "img/path2.png", 64*j - 32, 64 * i -32 )
        	end
    	end
	end
	
end