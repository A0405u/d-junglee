-- local Class = require "class"
local pickup = require 'pickup'
local monster = require 'monster'

require "lutf8"
require "game"
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
require "path"
require "color"
require "font"
require "terminal"

-- require "sight"
-- require "pickup"
-- require "enemy"

MAPNAME = "DarkrootIsland";

SCREENSIZEX = 128;
SCREENSIZEY = 128;
SCREENSCALE = 4;

FILTERMODE = "nearest";

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

    printstr = ""

    game.load()
    input.load()
    screen.load()
    choice.load()
    sound.load()
    cycle.load()
    clock.load()
    font.load()
    terminal.load()

    player.load()

    map.load(MAPNAME)
    path.load()

    pickups = {
        [1] = pickup:new(94, 97, 4, 4, true, "Лаборатория 9", "As you neared the laboratory, it was suspiciously quiet around. Once inside, you see documents and equipment scattered all over the place.\n\nLooks like nobody's here. Try to find out what happened.", {{"Обыскать", function() game.file() end}}),
        [2] = pickup:new(95, 93, 3, 3, true, "Habitat LC9", "You've come across barracs you lived in with other service stuff.\n\nIt's a mess here. All your things are gone.\n\nGood that you picked up a gun yesterday."),
        [3] = pickup:new(106, 92, 3, 3, true, "Habitat LS9", "You have never get inside other structures, even in this close ones.\n\nStill a mess. Scattered belongings of scientists everywhere. They worked in your laboratory."),
        [4] = pickup:new(89, 26, 3, 3, true, "Secret Lab X", "You are going down the stairs, entering the bunker. After opening meter thick doors, coming inside. You notice a person sitting in front of the monitor."),
        [5] = pickup:new(91, 25, 3, 4, true, "", ""),
        --[] = pickup:create(),
    }

    monsters = {
        [1] = monster:new(40, 48, 1, 2, true, color.red),
        [2] = monster:new(116, 48, 1, 2, true, color.red),
        [3] = monster:new(64, 80, 1, 1, false, color.blue),
        [4] = monster:new(32, 66, 1, 1, false, color.blue),
    }
    -- enemy.load()
    -- pickup.load()
    -- sight.load()
    game.map()
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