map = {}

function map.load(map_name)
    love.graphics.setColor(1, 1, 1)
    map.sprite = {
        day = love.graphics.newImage("Sprites/"..map_name.."Day.png"),
        night = love.graphics.newImage("Sprites/"..map_name.."Night.png"),
        -- [0] = love.graphics.newImage("Sprites/"..map_name.."000.png"),
        -- [1] = love.graphics.newImage("Sprites/"..map_name.."001.png"),
        -- [2] = love.graphics.newImage("Sprites/"..map_name.."002.png"),
        -- [3] = love.graphics.newImage("Sprites/"..map_name.."003.png")
    }
    -- map.frame = love.graphics.newImage("Sprites/"..map_name.."Frame.png")
    -- map.grid = love.graphics.newImage("Sprites/"..map_name.."Grid.png")
    map.mask = love.image.newImageData("Sprites/"..map_name.."Mask.png")
--    map.gradient = love.image.newImageData("Sprites/"..map_name.."Gradient.png")
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

function map.get(posx, posy)
	r, g, b, a = map.mask:getPixel(posx, posy)

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