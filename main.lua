-- local Class = require "class"
local pickup = require 'pickup'
local monster = require 'monster'

require "game"
require "screen"
require "sound"
require "cycle"
require "clock"
require "player"
require "map"
require "path"

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

    if screen.state == "info" then
        if pressed_key == "return" or pressed_key == "escape" or pressed_key == "space" then
            screen.setState("map")
            return
        end
    end

    if pressed_key == 'escape' then
        love.event.quit()
        return
      end


    if screen.state == "title" then
        game.setState("file")
        return
    end

    if screen.state == "file" then
        game.setState("info")
        return
    end

    if screen.state == "intro" then
        game.setState("logo")
        return
    end

    if screen.state == "logo" then
        game.setState("title")
        return
    end

    if screen.state == "death" then
        love.load()
        game.setState("title")
        return
    end

    if screen.state == "map" then
        if pressed_key == "tab" then
            --screen.tip.help = false
            if screen.tip.show == true then
                sound.tip.hide:seek(0)
                sound.tip.hide:play()
                screen.tip.show = false
            else
                sound.tip.show:seek(0)
                sound.tip.show:play()
                screen.tip.show = true
            end
        end
    end


    player.keypressed(pressed_key)
  end

-- LOAD

function love.load()

    time = 0

    printstr = ""

    game.load()
    screen.load()
    sound.load()
    cycle.load()
    clock.load()

    font = love.graphics.newFont("Fonts/IBM_BIOS.ttf", 8)
    love.graphics.setFont(font)
    fontsmall = love.graphics.newFont("Fonts/EverexME.ttf", 8)

    player.load()

    map.load(MAPNAME)
    path.load()

    pickups = {
        [0] = pickup:new(94, 97, 4, 4, true, "Laboratory 9", "As you neared the laboratory, it was suspiciously quiet around. Once inside, you see documents and equipment scattered all over the place.\n\nLooks like nobody's here. Try to find out what happened."),
        [1] = pickup:new(95, 93, 3, 3, false, "Habitat LC9", "You've come across barracs you lived in with other service stuff.\n\nIt's a mess here. All your things are gone.\n\nGood that you picked up a gun yesterday."),
        [2] = pickup:new(106, 92, 3, 3, false, "Habitat LS9", "You have never get inside other structures, even in this close ones.\n\nStill a mess. Scattered belongings of scientists everywhere. They worked in your laboratory."),
        [3] = pickup:new(89, 26, 3, 4, false, "Secret Lab X", "You are going down the stairs, entering the bunker. After opening meter thick doors, coming inside. You notice a person sitting in front of the monitor."),
        [4] = pickup:new(91, 25, 3, 3, false, "", ""),
        --[] = pickup:create(),
    }

    monsters = {
        [0] = monster:new(40, 48, 1, 10),
        [1] = monster:new(116, 48, 1, 10),
    }
    -- enemy.load()
    -- pickup.load()
    -- sight.load()
    game.setState("map")
end


function love.draw()

    love.graphics.setCanvas(screen.canvas)

    love.graphics.clear(8/255, 24/255, 33/255)

    screen.draw()

    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(screen.canvas, 0, 0, 0, screen.scale, screen.scale)
end


function love.update(dt)

    time = time + dt

    if screen.state == "map" then
        player.update(dt)
        for i = 0, #monsters do
            monsters[i]:update(dt)
        end
        for i = 0, #pickups do
            pickups[i]:update(dt)
        end
        cycle.update(dt)
    end
    screen.update(dt)
    -- sight.update()

end