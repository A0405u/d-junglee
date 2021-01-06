fog = {}

fog.canvas = love.graphics.newCanvas(SCREENSIZEX, SCREENSIZEY)
fog.enabled = true
fog.updated = false

function fog.load()

end


-- Отрисовка тумана в каждый кадр
function fog.draw()

    if not fog.updated then
        fog.update(player.posx, player.posy, player.range)
    end

    if fog.enabled then
        color.reset()
        love.graphics.draw(fog.canvas)
    end
end


-- Обновление тумана
function fog.update(posx, posy, range)

    love.graphics.setCanvas(fog.canvas) -- Установка дополнительного холста в качестве основного
    love.graphics.clear({0, 0, 0, 1}) -- Очистка холста

    color.reset()
    love.graphics.setColor(color.null) -- 
    -- love.graphics.setColor(color.red)

    if cycle.state == "day" then
        love.graphics.draw(map.sprite.bgday)
    else
        love.graphics.draw(map.sprite.bgnight)
    end

    love.graphics.setColor(color.transparent)
    love.graphics.setBlendMode("replace")

    local n = 512 -- Количество линий для проверки дальности обзора
    local a, p, x, y

    for i = 1, n do

        a = math.rad(360 / n) * i -- Угол между линиями
        x = posx + 0.5
        y = posy + 0.5
        p = 1

        love.graphics.circle("fill", x, y, 1.5) -- Заполнение точки, в которой находится игрок

        while p < range do

            x = x + math.cos(a)
            y = y + math.sin(a)

            s = map.get(x, y)

            love.graphics.points(x, y)

            if s == "wall" or s == "door" then
                break
            end

            if s == "forest" then
                p = p + (range - p) / 2
            end

            --love.graphics.circle("fill", x, y, 1.5)
            p = p + 1
        end
    end

    fog.updated = true

    color.reset()
    love.graphics.setBlendMode("alpha")
    love.graphics.setCanvas(screen.canvas)
end

function fog.switch()

    if fog.enabled then
        fog.enabled = false
    else
        fog.enabled = true
    end
end

function fog.new()

    fog.updated = false
end