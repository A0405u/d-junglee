map = {}
map.nodes = {}

function map.load(map_name)
    map.sprite = {
        day = love.graphics.newImage("Sprites/"..map_name.."Day.png"),
        night = love.graphics.newImage("Sprites/"..map_name.."Night.png"),
    }
    map.mask = love.image.newImageData("Sprites/"..map_name.."Mask.png")
    map.x = 127
    map.y = 127
    map.loadnodes()
end

function map.draw()

    if cycle.state == "day" then
        love.graphics.draw(map.sprite.day)
    else
        love.graphics.draw(map.sprite.night)
    end

    -- quadstart = 0
    -- mappos = 0
    -- line = screen.size.y

    -- if cycle.time > cycle.daylen then

    --     if cycle.time < (cycle.daylen + cycle.transition) then
    --         quadstart = (cycle.time - cycle.daylen) * screen.size.y
    --         mappos = quadstart

    --     elseif cycle.time > (cycle.length - cycle.transition) then
    --         line = (cycle.time - cycle.length - cycle.transition) * screen.size.y

    --     else
    --         mappos = screen.size.y
    --     end
    -- end

    -- quad = love.graphics.newQuad(0, quadstart, screen.size.x, line, map.sprite.day:getDimensions())

    -- love.graphics.draw(map.sprite.night)
    -- love.graphics.draw(map.sprite.day, quad, 0, mappos)



    -- love.graphics.setColor(map.gradient:getPixel(0, line))
    -- love.graphics.draw(map.sprite[0])

    -- love.graphics.setColor(map.gradient:getPixel(1, line))
    -- love.graphics.draw(map.sprite[1])

    -- love.graphics.setColor(map.gradient:getPixel(2, line))
    -- love.graphics.draw(map.sprite[2])

    -- love.graphics.setColor(map.gradient:getPixel(3, line))
    -- love.graphics.draw(map.sprite[3])
end

-- function map.drawframe()
--     love.graphics.draw(map.frame)
-- end

-- function map.drawgrid()
--     if time % 2 < 1 then
--         love.graphics.draw(map.grid)
--     end
-- end

function map.get(x, y)
	r, g, b, a = map.mask:getPixel(x, y)

	if r > 0 and g == 0 and b == 0 then
		return "wall"

	elseif r > 0 and g > 0 and b == 0 then
		return "door"

	elseif r == 0 and g > 0 and b > 0 then
		return "building"

	elseif r == 0 and g > 0 and b == 0 then
		return "forest"
	
	elseif r == 0 and g == 0 and b > 0 then
		return "water"

	else
		return "ground"
	end
end


-- Создать массив ячеек
function map.loadnodes()

    local surface

    for y = 0, map.y do
        for x = 0, map.x do
            table.insert(map.nodes, {x = x, y = y})
        end
    end
end


-- Получить ссылку на ячейку
function map.getnode(x, y)

    for i, node in map.nodes do
        if node.x == x and node.y == y then
            return node
        end
    end
end


-- Принадлежит ли клетка с координатами x, y сетке
function map.inbounds(x, y)

    if x < 0 or x > map.x then
        return false
    end

    if y < 0 or y > map.y then
        return false
    end

    return true
end


-- Проверка клетки с координатами x, y на пригодность для прохода
function map.reachable(x, y)

    local surface = map.get(x, y)
    
	if surface == "wall" or surface == "building" or surface == "door" or surface == "water" then
		return false
    end
    
	return true
end


-- Сетка проходимых и непроходимых клеток
function map.getgrid()

    local grid = {}

    for y = 0, map.y do

        grid[y] = {}

        for x = 0, map.x do

            if map.reachable(x, y) then
                grid[y][x] = 0
            else
                grid[y][x] = 1
            end
        end
    end
    return grid
end