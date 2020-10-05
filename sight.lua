SIGHT_SIZE = 2


sight = {}


function sight.load()

    sight.x = 0
    sight.y = 0
    sight.rotation = 0
    sight.size = SIGHT_SIZE
end


function sight.draw()

    love.graphics.setColor(255,255,255)
    love.graphics.circle("fill", sight.x, sight.y, sight.size / 2)
end


function sight.update()

    sight.x, sight.y = love.mouse.getPosition()
    sight.x = sight.x / screen.scale
    sight.y = sight.y / screen.scale
end