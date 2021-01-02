
choice = {}


function choice.load()

    choice.set()
end


function choice.set(choices)

    if choices and choices[1] then -- Проверяем присутствует ли хотя бы один выбор

        for i = 1, #choice do -- Очищаем предыдущие выборы
            choice[i] = nil
        end

        for i = 1, #choices do
            choice[i] = choices[i] -- Вставляем новые
        end

        choice.select(1)
        return
    end

    choice.set({{"Закрыть", function() game.map() end}})
end


function choice.draw()

    if choice[1] then -- Проверяем присутсвуют ли варианты выбора
        
        local sx = screen.size.x / #choice -- размер блока выбора

        for i = 1, #choice do

            if choice[i] == choice.selected then
                love.graphics.printf(" "..choice[i][1], font.smallinverted, sx * (i - 1), 112, sx, "center")
            else
                love.graphics.printf(" "..choice[i][1], font.small, sx * (i - 1), 112, sx, "center")
            end
        end
    end
end


function choice.select(i)
    choice.selected = choice[i]
    choice.selected.i = i
end


function choice.next()
    if choice.selected.i < #choice then
        choice.select(choice.selected.i+1)
        return true
    end
    return false
end


function choice.prev()
    if choice.selected.i > 1 then
        choice.select(choice.selected.i-1)
        return true
    end
    return false
end


function choice.choose()
    choice.selected[2]()
end


function choice.update(key)

    if choice[1] then

        if key == "return" or key == "space" then
            choice.choose()
            sound.play(sound.menu.select)
        end

        if key == "d" or key == "right" then
            if choice.next() then
                sound.play(sound.menu.pick)
            end
        end

        if key == "a" or key == "left" then
            if choice.prev() then
                sound.play(sound.menu.pick)
            end
        end
    end
end