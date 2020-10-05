clock = {}

function clock.load()

    clock.sprite = {
        [0] = love.graphics.newImage("Sprites/clock000.png"),
        [1] = love.graphics.newImage("Sprites/clock001.png"),
        [2] = love.graphics.newImage("Sprites/clock002.png"),
        [3] = love.graphics.newImage("Sprites/clock003.png"),
        [4] = love.graphics.newImage("Sprites/clock004.png"),
        [5] = love.graphics.newImage("Sprites/clock005.png"),
        [6] = love.graphics.newImage("Sprites/clock006.png"),
        [7] = love.graphics.newImage("Sprites/clock007.png"),
        [8] = love.graphics.newImage("Sprites/clock008.png")
    }
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
    love.graphics.draw(clock.sprite[math.floor(cycle.time / cycle.len * #clock.sprite)], clock.posx, clock.posy)
--    love.graphics.draw(clock.sprite[math.floor(cycle.time / cycle.length * #clock.sprite)], clock.posx, clock.posy)
end