
screen = {}

SCREENSIZEX = 128;
SCREENSIZEY = 128;
SCREENSCALE = 4;

FILTERMODE = "nearest";

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

    screen.tip = {
        show = true,
        help = true,
        text = "Вернитесь в лабо-\nраторию, сектор F5"
    }

    screen.header = "Рассвет"
    screen.text = "Вы проснулись в открытой пещере. Невдалеке виднеется песчаный пляж и слышно гул чаек.\n\nВы набрели на эту пещеру ещё вчера, и уснули здесь наблюдая за прекрасным видом.\n\nПора возвращаться обратно."

    screen.state = game.state
    screen.time = time

    screen.key = 0
end

function screen.draw()

    -- ПЕРЕХОД МЕЖДУ ЭКРАНАМИ В ВИДЕ ЧЕРНОГО КАДРА
    -- if screen.time <= 0.1 then
    --     return
    -- end

    screen[screen.state]() -- Запуск функции соответствующей состоянию экрана
end


-- Update
function screen.update(dt)
    screen.time = screen.time + dt

    if screen.state == "intro" and screen.time > 8 then
        game.logo()
    end

    if screen.state == "logo" and screen.time > 3 then
        game.title()
    end
end


function screen.font()

    love.graphics.setColor(hsv(screen.time % 2 * 127.5, 255, 255))
    love.graphics.setFont(font.monobold)
--    color.reset()
    love.graphics.printf("!\"#$%&`()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_'abcdefghijklmnopqrstuvwxyz{|}АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя█▒~", 0, 0, 128)
end


-- Intro
function screen.intro()

    color.reset()
    love.graphics.printf({{1, 0, 0}, "ВНИМАНИЕ!"}, 8, 12, 112, "center")

    s = {
        rgba(244, 244, 244, 1),
        "Не ожидайте прекрасного.\n\nВаш монитор\nне способен отобразить даже половины цветов нашего мира."
    }
    love.graphics.printf(s, 12, 28, 112, "left")

    love.graphics.printf({{255/255, 171/255, 0/255}, "@a0405u"}, 8, 108, 112, "right")

    -- love.graphics.setColor(49/255, 105/255, 82/255)
    -- love.graphics.setLineWidth(2)
    -- love.graphics.rectangle("line", 1, 1, 126, 126)
    -- color.reset()
end


-- Logo
function screen.logo()

    love.graphics.draw(sprite.screen.logo)
end


-- Title
function screen.title()

    color.reset()
    love.graphics.draw(sprite.screen.title)
    if screen.time % 2 > 1 then
        love.graphics.setColor(color.white)
        love.graphics.printf("Нажми START", 0, 89, 128, "center")
    end
end


function screen.drawtip()

    love.graphics.setColor(color.black)
    love.graphics.rectangle("fill", 23, 39, 81, 33)

    color.reset()
    if screen.tip.help == true then
        love.graphics.printf({color.light, "Скрыть - TAB"}, font.small, 26, 62, 75, "center")
    end
    love.graphics.printf({color.white, screen.tip.text}, font.small, 26, 42, 75, "center")
end

-- Map
function screen.map()

    -- map.draw()
    -- map.drawgrid()
    -- map.drawframe()

    map.draw()
    player.draw()
    for i = 1, #monsters do
        monsters[i]:draw(dt)
    end
    for i = 1, #pickups do
        pickups[i]:draw(dt)
    end

    fog.draw()
    clock.draw()

    if screen.tip.show == true then
        screen.drawtip()
    end

    -- sight.draw();
end


function screen.file()

    love.graphics.draw(sprite.screen.file)
    love.graphics.draw(player.portrait, 8, 8)
    
    love.graphics.printf({color.white, "Антон\nЛисицин"}, 48, 8, 72)
    love.graphics.printf({color.light, "Уборщик"}, 48, 32, 72)

    love.graphics.setFont(font.small)
    love.graphics.printf({color.white, "Дальнегорск. 19 Апреля, 1976. \n", color.light, "Необщительный, закрытый че-\nловек. Честный, ответственный работник. Замечено нарушение режима содержания.\n\n", color.white, "Уровень доступа:\n", color.light, "- Омега-8"}, 8, 49, 112)
    love.graphics.setFont(font.default)
end


-- Info
function screen.info()

    if cycle.state == "day" then
        love.graphics.clear(color.black)
        love.graphics.setColor(color.white)
    else
        love.graphics.clear(color.black)
        love.graphics.setColor(color.white)
    end

    love.graphics.printf(screen.header, font.default, 8, 8, 112, "left")

    love.graphics.printf(screen.text, font.small, 8, 24, 112, "left")

    choice.draw()
end


-- Terminal
function screen.terminal()

    terminal.draw()
end



-- Death
function screen.death()

    color.reset()
    love.graphics.printf({{1, 0, 0}, "ПОПРОБУЙ ЕЩЁ\n\n"}, 0, 60, 128, "center")
end


function screen.ending()

    if screen.key < 4 then
        screen.map()
    else
        love.graphics.draw(sprite.screen.ghost)
        if screen.time <=1.45 then
            love.graphics.draw(sprite.screen.off[1])
        elseif screen.time <=1.6 then
            love.graphics.draw(sprite.screen.off[2])
        end
    end


    if screen.key < 1 then
        sound.play(sound.shot)
        screen.key = 1
    end

    if screen.time <= 0.1 and screen.key < 2 then
        love.graphics.setColor(color.white)
        love.graphics.draw(sprite.screen.noise)
    end

    if screen.time >= 0.6 and screen.key < 2 then
        sound.play(sound.shot)
        screen.key = 2
    end

    if screen.time <= 0.7 and screen.key > 1 then
        love.graphics.setColor(color.white)
        love.graphics.draw(sprite.screen.noise)
    end

    if screen.time >= 1.2 and screen.key < 3 then
        sound.play(sound.shot)
        screen.key = 3
    end

    if screen.time <= 1.3 and screen.key > 2 then
        love.graphics.setColor(color.white)
        love.graphics.draw(sprite.screen.noise)
    end

    if screen.time >= 1.4 and screen.key < 4 then
        sound.play(sound.last)
        screen.key = 4
    end

    if screen.time <= 1.5 and screen.key > 3 then
        love.graphics.setColor(color.white)
        love.graphics.draw(sprite.screen.noise)
    end

    if screen.key > 1 then
        color.reset()
        love.graphics.draw(sprite.screen.blood[1])
    end

    if screen.key > 2 then
        color.reset()
        love.graphics.draw(sprite.screen.blood[2])
    end
end

function screen.show(state)

    screen.state = state
    screen.time = 0

    sound.screen:seek(0)
    sound.screen:play()
end