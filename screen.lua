
screen = {}

function screen.load()

    screen.size = { x = SCREENSIZEX, y = SCREENSIZEY }
    screen.scale = SCREENSCALE

    love.window.setTitle("d-junglee")
--    love.window.setMode(screen.size.x * screen.scale, screen.size.y * screen.scale, {borderless = false, display = 2})
    love.window.setMode(screen.size.x * screen.scale, screen.size.y * screen.scale, {borderless = true})

    love.graphics.setDefaultFilter(FILTERMODE, FILTERMODE)

    love.graphics.setLineStyle('rough')

    love.mouse.setVisible(false)

    screen.canvas = love.graphics.newCanvas(SCREENSIZEX, SCREENSIZEY)

    screen.logo = love.graphics.newImage("Sprites/logo.png")
    screen.title = love.graphics.newImage("Sprites/title.png")
    screen.file = love.graphics.newImage("Sprites/file.png")

    screen.blood = love.graphics.newImage("Sprites/blood.png")
    screen.blooddot = love.graphics.newImage("Sprites/blooddot.png")
    screen.tip = {
        show = true,
        help = true,
        helpsprite = love.graphics.newImage("Sprites/tiphelp.png"),
        text = "Return to lab at sector F5"
    }

    screen.state = "intro"
    screen.time = time

    screen.key = 0
end

function screen.draw()

    if screen.time <= 0.1 then
        return
    end

    if screen.state == "logo" then
        screen.drawlogo()

    elseif screen.state == "intro" then
        screen.drawintro()

    elseif screen.state == "title" then
        screen.drawtitle()

    elseif screen.state == "file" then
        screen.drawfile()

    elseif screen.state == "map" then
        screen.drawmap()

    elseif screen.state == "info" then
        screen.drawinfo()

    elseif screen.state == "death" then
        screen.drawdeath()

    elseif screen.state == "end" then
        screen.drawend()
    end
end


-- Update
function screen.update(dt)
    screen.time = screen.time + dt

    if screen.state == "intro" and screen.time > 8 then
        game.setState("logo")
    end

    if screen.state == "logo" and screen.time > 3 then
        game.setState("title")
    end
end


-- Logo
function screen.drawlogo()
    love.graphics.draw(screen.logo)
end


-- Intro
function screen.drawintro()

    s = {
        {1, 0, 0},
        "  ATTENTION!\n\n",
        {231/255, 251/255, 214/255},
        "Do not expect anything beautiful.\n\nYour monitor not able to display even 50% of real colors."
    }

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(s, 12, 12, 112, "left")
    love.graphics.printf({{255/255, 171/255, 0/255}, "@a0405u"}, 8, 108, 112, "right")

    -- love.graphics.setColor(49/255, 105/255, 82/255)
    -- love.graphics.setLineWidth(2)
    -- love.graphics.rectangle("line", 1, 1, 126, 126)
    -- love.graphics.setColor(1, 1, 1)
end

-- Title
function screen.drawtitle()

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(screen.title)
    if screen.time % 2 > 1 then
        love.graphics.setColor(231/255, 251/255, 214/255)
        love.graphics.printf("Press START", 0, 89, 128, "center")
    end
end


function screen.drawtip()

    love.graphics.setColor(1, 1, 1)
    if cycle.state == "day" then
        love.graphics.setColor(0, 62/255, 97/255)
    else
        love.graphics.setColor(8/255, 24/255, 33/255)
    end
    love.graphics.rectangle("fill", 23, 39, 81, 33)

    love.graphics.setColor(1, 1, 1)
    if screen.tip.help == true then
        love.graphics.draw(screen.tip.helpsprite)
    end
    love.graphics.setColor(231/255, 251/255, 214/255)
    love.graphics.setFont(fontsmall)
    love.graphics.printf(screen.tip.text, 26, 42, 75, "center")
    love.graphics.setFont(font)
end

-- Map
function screen.drawmap()

    -- map.draw()
    -- map.drawgrid()
    -- map.drawframe()

    map.draw()
    clock.draw()
    player.draw()
    enemy.draw()
    for i = 0, #pickups do
        pickups[i]:draw(dt)
    end

    if screen.tip.show == true then
        screen.drawtip()
    end
    -- sight.draw();
end


function screen.drawfile()

    strtop = {
        {231/255, 251/255, 214/255},
        "Antony\nSpiritov\n\n",
        {140/255, 195/255, 115/255},
        "Janitor"
    }

    love.graphics.draw(screen.file)
    love.graphics.draw(player.portrait, 8, 8)
    love.graphics.printf(strtop, 48, 8, 72)

    love.graphics.setFont(fontsmall)
    love.graphics.setColor(231/255, 251/255, 214/255)
    love.graphics.printf("19 April, 1976.", 8, 49, 112)
    love.graphics.setColor(140/255, 195/255, 115/255)
    love.graphics.printf("Private person. Honest,", 8, 59, 128)
    love.graphics.printf("responsible worker.", 8, 69, 112)
    love.graphics.printf("Discipline violation.", 8, 79, 112)
    love.graphics.printf("Not married.", 8, 89, 112)
    love.graphics.setColor(231/255, 251/255, 214/255)
    love.graphics.printf("Security level:", 8, 99, 112)
    love.graphics.setColor(140/255, 195/255, 115/255)
    love.graphics.printf("- Omega-8", 8, 109, 112)
    love.graphics.setFont(font)
end


-- Info
function screen.drawinfo()

    love.graphics.setFont(font)
    love.graphics.setColor(231/255, 251/255, 214/255)
    love.graphics.printf(screen.header, 8, 12, 112, "left")
    love.graphics.setFont(fontsmall)
    love.graphics.printf(screen.text, 8, 28, 112, "left")
    love.graphics.setFont(font)
end

-- Death
function screen.drawdeath()

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf({{1, 0, 0}, "TRY AGAIN\n\n"}, 0, 60, 128, "center")
end


function screen.drawend()

    screen.drawmap()

    if screen.key < 1 then
        sound.shot:seek(0)
        sound.shot:play()
        screen.key = 1
    end

    if screen.time >= 0.6 and screen.key < 2 then
        sound.shot:seek(0)
        sound.shot:play()
        screen.key = 2
    end
        
    if screen.time >= 1.2 and screen.key < 3 then
        sound.shot:seek(0)
        sound.shot:play()
        screen.key = 3
    end

    if screen.time >= 1.4 and screen.key < 4 then
        sound.last:seek(0)
        sound.last:play()
        screen.key = 4
    end

    if screen.key > 1 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(screen.blooddot)
    end

    if screen.key > 2 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(screen.blood)
    end
end

function screen.setState(state)

    screen.state = state
    screen.time = 0

    sound.screen:seek(0)
    sound.screen:play()
end