-- local Class = require "class"
local pickup = require 'pickup'
local monster = require 'monster'
local door = require "door"

require "lutf8"
require "game"
require "sprites"
require "text"
require "input"
require "screen"
require "choice"
require "sound"
require "cycle"
require "clock"
require "turn"
require "player"
require "map"
require "fog"
require "path"
require "color"
require "font"
require "terminal"

-- require "sight"
-- require "pickup"
-- require "enemy"

MAPNAME = "DarkrootIsland";

-- На вход ненулевой vector = {x, y}
function normalize(x, y)

    length = math.sqrt(x * x + y * y)

    return x / length, y / length
end
-- KEYS

function love.keypressed(pressed_key)

    input.keypressed(pressed_key)    
end

-- TEXT

function love.textinput(text)
    
    input.textinput(text)
end

-- LOAD

function love.load()

    time = 0

    game.load()
    screen.load()
    choice.load()
    sound.load()
    cycle.load()
    clock.load()
    font.load()
    terminal.load()

    player.load()

    map.load(MAPNAME)
    fog.load()
    path.load()

    pickups = {
        [1] = pickup:new(95, 98, 2, 2, false, "Лаборатория 9", "As you neared the laboratory, it was suspiciously quiet around. Once inside, you see documents and equipment scattered all over the place.\n\nLooks like nobody's here. Try to find out what happened.", {{"Обыскать", function() game.file() end}}),
        [2] = pickup:new(96, 94, 1, 1, false, "Habitat LC9", "You've come across barracs you lived in with other service stuff.\n\nIt's a mess here. All your things are gone.\n\nGood that you picked up a gun yesterday."),
        [3] = pickup:new(107, 93, 1, 1, false, "Habitat LS9", "You have never get inside other structures, even in this close ones.\n\nStill a mess. Scattered belongings of scientists everywhere. They worked in your laboratory."),
        [4] = pickup:new(90, 27, 1, 1, false, "Secret Lab X", "You are going down the stairs, entering the bunker. After opening meter thick doors, coming inside. You notice a person sitting in front of the monitor."),
        [5] = pickup:new(92, 26, 1, 2, false, "", ""),
        --[] = pickup:create(),
    }

    monsters = {
        [1] = monster:new(40, 48, 1, 2, 16, true, color.red),
        [2] = monster:new(116, 48, 1, 2, 16, true, color.red),
        [3] = monster:new(64, 80, 1, 1, 24, false, color.purple),
        [4] = monster:new(32, 66, 1, 1, 24, false, color.purple),
    }

    doors = {
        [1] = door:new(93, 97, true),
        [2] = door:new(94, 98, true),
        [3] = door:new(96, 95, false),
        [4] = door:new(106, 93, false),
        [5] = door:new(77, 85, false),
    }
    
    -- sight.load()
    -- game.map()
    -- game.ending()
    -- game.font()
    -- game.terminal()
end



function love.draw()

    love.graphics.setCanvas(screen.canvas)

    love.graphics.clear({21/255, 21/255, 21/255, 1})

    screen.draw()

    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(screen.canvas, 0, 0, 0, screen.scale, screen.scale)
end


function love.update(dt)

    time = time + dt

    if screen.state == "map" then
        player.update(dt)
        for i = 1, #monsters do
            monsters[i]:update(dt)
        end
        for i = 1, #pickups do
            pickups[i]:update(dt)
        end
    end

    input.update(dt)
    screen.update(dt)
    turn.update(dt)
    -- sight.update()

end