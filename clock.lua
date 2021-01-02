clock = {}

function clock.load()

    clock.sprite = love.graphics.newImage("sprites/clock.png")
    clock.size = 6
    clock.quads = {}
    for x = 0, clock.sprite:getWidth() - clock.size, clock.size do
        table.insert(clock.quads, love.graphics.newQuad(x, 0, clock.size, clock.size, clock.sprite:getDimensions()))
    end
    clock.posx = 121
    clock.posy = 121
end


function clock.draw()

    if cycle.state == "day" then
        love.graphics.setColor(color.black)
    else
        love.graphics.setColor(color.light)
    end
    local n = math.floor(cycle.time / cycle.len * #clock.quads) + 1
    love.graphics.draw(clock.sprite, clock.quads[n], clock.posx, clock.posy)
end