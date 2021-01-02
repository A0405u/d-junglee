local MIN_POS = 1
local MAX_POS = 126
local TURN_TIME = turn.delay

player = {}

-- Конструктор
function player.load()

	player.posx = 94
	player.posy = 113

	player.moving = false

	player.queue = {}

	player.sprite = love.graphics.newImage("sprites/Player.png")
	player.portrait = love.graphics.newImage("sprites/portrait.png")

	player.nextturn = 0

	player.sound = {
		step = sound.player.step.ground
	}
end


-- Update
function player.update(dt)

	if time >= player.nextturn then

		if player.turn() then
			turn.next()
			player.nextturn = time + TURN_TIME
		else
			player.keydown()
		end
	end
end


-- Добавление хода в очередь ходов
function player.addturn(turn, n)

	if not n then n = 1 end

	if turn[1] == "wait" then
		for i = 1, n do
			table.insert(player.queue, 1, turn) -- Вставка ожидания в начало очереди
		end
		return
	end

	if turn[1] == "move" then

		if not player.moving then -- Если игрок только начинает движение
			if time >= player.nextturn then -- Исключения повторной задержки
				player.nextturn = time + TURN_TIME -- Добавить задержку для обработки диагонального перемещения
			end
		end

		local temp = player.queue[#player.queue] -- Берем последний ход из очереди

		if temp and temp[1] == "move" then -- Если это ход движения

			if (turn[2] == 0 and temp[3] == 0) or (turn[3] == 0 and temp[2] == 0) then -- если добавляемый и последний ходы лежат в разных осях
				temp[2] = temp[2] + turn[2] -- объединяем ходы
				temp[3] = temp[3] + turn[3]
				return
			end
		end
		table.insert(player.queue, turn)
	end
end


-- Выполнение первого в очереди хода
function player.turn()

	local i, turn = next(player.queue)

	if turn then -- проверка на пустоту очереди

		table.remove(player.queue, i) -- удаление обработанного хода из очереди

		if turn[1] == "move" then

			player.move(turn[2], turn[3])
		end

		if turn[1] == "wait" then
			
			-- ОЖИДАНИЕ
		end

		return true
	end
	return false
end


-- Отрисовка персонажа
function player.draw()

	if time % 0.5 > 0.25 then
		love.graphics.setColor(116/255, 78/255, 0)
	else
		love.graphics.setColor(255/255, 171/255, 0)
	end
	love.graphics.points(player.posx + 0.5, player.posy + 0.5)

end


-- Обработка нажатия клавиш
function player.keypressed(pressed_key)

	if not player.moving then
		
		if pressed_key == 'w' or pressed_key == "up" then
			player.addturn({"move", 0, -1})
		end

		if pressed_key == 'a' or pressed_key == "left" then
			player.addturn({"move", -1, 0})
		end

		if pressed_key == 's' or pressed_key == "down" then
			player.addturn({"move", 0, 1})
		end

		if pressed_key == 'd' or pressed_key == "right" then
			player.addturn({"move", 1, 0})
		end
	end

	if pressed_key == 'j' then
		player.attack()
	end
end


-- Обработка зажатых клавиш
function player.keydown()

	if love.keyboard.isDown("w", "a", "s", "d", "up", "left", "down", "right") then

		player.moving = true

		if love.keyboard.isDown("w", "up") then
			player.addturn({"move", 0, -1})
		end

		if love.keyboard.isDown("a", "left") then
			player.addturn({"move", -1, 0})
		end

		if love.keyboard.isDown("s", "down") then
			player.addturn({"move", 0, 1})
		end

		if love.keyboard.isDown("d", "right") then
			player.addturn({"move", 1, 0})
		end
	else
		player.moving = false
	end
end


-- Перемещение игрока относительно его позиции на dirx, diry
function player.move(dirx, diry)

	local surface = player.check(player.posx + dirx, player.posy + diry)

	if surface then -- если поверхность достижима

		player.posx = player.posx + dirx
		player.posy = player.posy + diry

		player[surface]()

		sound.play(player.sound.step)
	end
end


-- Проверка поверхности, проверка достижимости клетки
function player.check(posx, posy)

	local p = map.get(posx, posy)

	if p == "wall" then
		return nil
	end

	return p
end


-- Поведение в здании
function player.building()
	player.sound.step = sound.player.step.building
	return "building"
end



function player.door()
	player.sound.step = sound.player.step.building
	return "door"
end


-- Поведение в лесу
function player.forest()
	player.addturn({"wait"})
	player.sound.step = sound.player.step.forest
	return "forest"
end


-- Поведение на земле
function player.ground()
	player.sound.step = sound.player.step.ground
	return "ground"
end


-- Поведение в воде
function player.water()
	player.addturn({"wait"}, 2)
	player.sound.step = sound.player.step.water
	return "water"
end


function player.attack()


end

function player.death()

	game.death()
end