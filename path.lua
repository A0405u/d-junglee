local Grid = require("jumper.grid")
local Pathfinder = require ("jumper.pathfinder")

path = {}

function path.load()

    path.mapgrid = map.getgrid()

    path.walkable = 0
    
    path.grid = Grid(path.mapgrid)

    path.finder = Pathfinder(path.grid, 'ASTAR', path.walkable) 
end

function path.get(startx, starty, destx, desty)

    local path = path.finder:getPath(startx, starty, destx, desty)

    if path then
        return path
    end

    return false
end