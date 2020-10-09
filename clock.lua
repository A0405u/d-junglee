clock = {}

function clock.load()

    clock.sprite = love.graphics.newImage("Sprites/clock.png")
    clock.size = 6
    clock.quads = {}
    for x = 0, clock.sprite:getWidth() - clock.size, clock.size do
        table.insert(clock.quads, love.graphics.newQuad(x, 0, clock.size, clock.size, clock.sprite:getDimensions()))
    end
    clock.color = {
        day = {0/255, 57/255, 89/255},
        night = {140/255, 195/255, 115/255}
    }
    clock.posx = 121
    clock.posy = 121
end


function clock.draw()

    if cycle.state == "day" then
        love.graphics.setColor(clock.color.day)
    else
        love.graphics.setColor(clock.color.night)
    end
    local n = math.floor(cycle.time / cycle.len * #clock.quads) + 1
    love.graphics.draw(clock.sprite, clock.quads[n], clock.posx, clock.posy)
end