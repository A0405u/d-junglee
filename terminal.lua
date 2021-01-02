local LEN = 20
local MAX_LINES = 14
local MAX_INPUT = 20

terminal = {}
cursor = {}

-- ОЧИСТКА ТЕРМИНАЛА КАК ИГРОВОЙ ЭЛЕМЕНТ: потеря памяти, потеря дневника и т.д.


-- Инициализация модуля
function terminal.load()

    terminal.lines = {} -- строки терминала

    terminal.text = "" -- видимый текст
    terminal.input = "" -- вводимый текст

    terminal.current = 1 -- верхняя строка терминала

    terminal.border = 4 -- размер границ теминала

    terminal.icon = {}
    terminal.icon.more = love.graphics.newImage("sprites/more.png")

    cursor.pos = 1 -- позиция курсора в строке ввода
end


-- Отображение терминала
function terminal.draw()

    love.graphics.clear(color.black)
    love.graphics.setColor(color.white)

    love.graphics.print(utf8.upper(terminal.text), font.mono, terminal.border, terminal.border)

    if terminal.current > 1 then
        love.graphics.draw(terminal.icon.more, 0, 0)
    end

    if (terminal.current + MAX_LINES) <= #terminal.lines then
        love.graphics.draw(terminal.icon.more, 0, 124)
    end

    love.graphics.rectangle("fill", 4, 116, 120, 8)

    love.graphics.setColor(color.black) 

    love.graphics.print(utf8.upper(terminal.input), font.mono, terminal.border, 116)

    if screen.time % 1 > 0.5 then
        cursor.draw()
    end
end


-- Обновление видимого текста
function terminal.update()

    terminal.text = ""

    local i = terminal.current

    while i <= (terminal.current + MAX_LINES) and i <= #terminal.lines do
        terminal.text = terminal.text .. terminal.lines[i] .. '\n'
        i = i + 1
    end
end


-- Добавление строки s в конец терминала
function terminal.insert(s)

    local lines = terminal.split(s, LEN)

    if #lines > MAX_LINES then
        terminal.move("end")
    end

    for i = 1, #lines do
        table.insert(terminal.lines, lines[i])
    end

    if #lines < MAX_LINES then
        terminal.move("last")
    end

    terminal.update()
end


-- Подтверждение ввода
function terminal.enter()

    table.insert(terminal.lines, terminal.input)

    terminal.move("last")

    if terminal.input == "помощь" then
        terminal.insert("Здесь нет никакой помощи, ты совершенно один.")
    end

    terminal.input = ""
    cursor.pos = 1
end


-- Удаление символа перед курсором
function terminal.erase()

    local s = terminal.input
    local len = utf8.len(s)

    if cursor.pos == 1 then
        return

    elseif cursor.pos == len + 1 then
        s = utf8.sub(s, 1, len - 1)

    else
        s = utf8.sub(s, 1, cursor.pos - 2) .. utf8.sub(s, cursor.pos, len)
    end
    
    cursor.move("left")
    terminal.input = s
end


-- Вставка символа в место курсора
function terminal.write(c)

    local s = terminal.input
    local len = utf8.len(s)

    if len < MAX_INPUT then

        if string.find(" !\"#$%&`()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_'abcdefghijklmnopqrstuvwxyz{|}АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя█▒~", c) then
        
            if cursor.pos == 1 then

                s = c .. s

            elseif cursor.pos == len + 1 then

                s = s .. c
                
            else
                s = utf8.sub(s, 1, cursor.pos) .. c .. utf8.sub(s, cursor.pos + 1, len)
            end

            terminal.input = s
            cursor.move("right")
        end
    end
end


-- Вывод курсора на экран
function cursor.draw()

    love.graphics.setColor(color.black)

    love.graphics.print('█', font.mono, terminal.border + (cursor.pos - 1) * 6, screen.size.y - terminal.border - 8)
end


-- Пролистывание терминала
function terminal.move(dir)

    if dir == "up" then
        if terminal.current > 1 then
            terminal.current = terminal.current - 1
        end

    elseif dir == "down" then
        if terminal.current + MAX_LINES <= #terminal.lines then
            terminal.current = terminal.current + 1
        end

    elseif dir == "end" then
        terminal.current = #terminal.lines + 1

    elseif dir == "last" then
        if terminal.current + MAX_LINES <= #terminal.lines then
            terminal.current = #terminal.lines + 1 - MAX_LINES
        end
    end

    terminal.update()
end


-- Проверка на недоступность клетки для курсора
function cursor.empty(line, pos)

    if utf8.len(terminal.lines[line]) < pos then
        return true
    end

    return false
end


-- Возвращает последнюю клетку в строке
function cursor.last(line)

    print("last:", utf8.len(terminal.line[line]))
    return utf8.len(terminal.line[line])
end


-- Перемещение курсора
function cursor.move(dir)

    if dir == "left" then
        if cursor.pos > 1 then
            cursor.pos = cursor.pos - 1
        end
    end

    if dir == "right" then
        if cursor.pos <= utf8.len(terminal.input) then
            cursor.pos = cursor.pos + 1
        end
    end
end


-- Делит строку на строки длинны i
-- стоит обработать случай с несколькими пробелами в начале строки, а так же изменить условие цикла
function terminal.split(text, len)

    local lines = {}

    local l = utf8.len(text) -- количество символов в utf8 кодировке
    local n = math.ceil(l / len) -- количество получившихся строк

    local s = 1 -- начало текущей строки
    local e = s + len - 1 -- конец текущей строки

    for i = 1, n do -- проход по всем строкам

        lines[i] = utf8.sub(text, s, e) -- отделение строки из текста

        if utf8.trim(lines[i]) then -- если в начале текущей строки пробел

            s = s + 1 -- изменяем начало текущей строки

            if e < l then
                e = e + 1 -- изменяем конец текущей строки
            end

            lines[i] = utf8.sub(text, s, e) -- производим отделение строки заново
        end

        s = e + 1
        e = s + len - 1
    end

    return lines
end