MIN_POS = 1
MAX_POS = 126

player = {}

-- Конструктор
function player.load()

	player.posx = 94
	player.posy = 113

	player.velx = 0
	player.vely = 0

	player.speed = 4
	player.smult = 1

	player.sprite = love.graphics.newImage("Sprites/Player.png")
	player.portrait = love.graphics.newImage("Sprites/portrait.png")

	player.movx = false
	player.movy = false

	player.nextstep = 0

	player.sound = {
		step = sound.player.step.ground
	}
end


-- Update
function player.update(dt)
	player.physics(dt)
	if player.movx or player.movy then
		player.move(dt)
	end
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

	if pressed_key == 'w' or pressed_key == "up" then
		player.setvel(player.velx, -1)
	end

	if pressed_key == 'a' or pressed_key == "left" then
		player.setvel(-1, player.vely)
	end

	if pressed_key == 's' or pressed_key == "down" then
		player.setvel(player.velx, 1)
	end

	if pressed_key == 'd' or pressed_key == "right" then
		player.setvel(1, player.vely)
	end

	if pressed_key == 'j' then
		player.attack()
	end
end


-- Предотвращение выхода за границы, возвращает true в случае если дальнейшее движение возможно
function player.checkborder()

	border = false

	if player.posx < MIN_POS then
		player.posx = MIN_POS
		border = true
	elseif player.posx > MAX_POS then
		player.posx = MAX_POS
		border = true
	end

	if player.posy < MIN_POS then
		player.posy = MIN_POS
		border = true
	elseif player.posy > MAX_POS then
		player.posy = MAX_POS
		border = true
	end

	return not border
end


-- Проверка на достижимость клетки, возвращает true если возможно дальнейшее движение
function player.checkwall()
	--Случай когда движимся наискось
	if player.velx ~= 0 and player.vely ~= 0 then
		-- Если клетка наискось достижима
		if player.check(player.posx + player.velx, player.posy + player.vely) ~= "unreachable" then
			return true
		end
		-- Иначе смотрим клетку по х
		if player.check(player.posx + player.velx, player.posy) ~= "unreachable" then
			player.vely = 0
			return true
		end
		-- Иначе смотрим клетку по y
		if player.check(player.posx, player.posy + player.vely) ~= "unreachable" then
			player.velx = 0
			return true
		end
		-- Иначе никуда не идем
		player.velx = 0
		player.vely = 0
		return false
	end
	--Случай когда мы движимся вертикально или горизонтально
	if player.check(player.posx + player.velx, player.posy + player.vely) == "unreachable" then
		player.velx = 0
		player.vely = 0
		return false
	end
	return true
end


-- Обновление вектора скорости и таймера, начало движения
function player.setvel(dirx, diry)

	player.velx = dirx
	player.vely = diry

	if time >= player.nextstep then
		player.nextstep = time + 1 / (player.speed * player.smult)
	end
end


-- Перемещение в пространстве
function player.physics(dt)

	if player.velx ~= 0 or player.vely ~= 0 then -- Первичная проверка скорости

		if time >= player.nextstep then -- Пришло ли время переместиться на клетку

			if player.checkborder() and player.checkwall() then -- Возможно ли дальнейшее перемещение после проверки

				player.posx = player.posx + player.velx
				player.posy = player.posy + player.vely

				player.apply(player.check(player.posx, player.posy)) -- после перемещения на клетку применяем модификаторы поверхности

				sound.play(player.sound.step)

				if velx ~= 0 then
					player.movx = true
				end
				if vely ~= 0 then
					player.movy = true
				end

				player.velx = 0
				player.vely = 0
			end
		end
	end
end

-- Обработка перемещения зажатой клавишей
function player.move(dt)

	if player.movy then
		if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
			player.setvel(1, player.vely)

		elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			player.setvel(-1, player.vely)
		
		else
			player.setvel(0, player.vely)
			player.movy = false
		end
	end

	if player.movx then
		if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
			player.setvel(player.velx, 1)

		elseif love.keyboard.isDown("w") or love.keyboard.isDown("up") then
			player.setvel(player.velx, -1)

		else
			player.setvel(player.velx, 0)
			player.movx = false
		end
	end
end


-- Проверка поверхности, проверка достижимости
function player.check(posx, posy)
	local p = map.get(posx, posy)
	if p == "wall" then
		return "unreachable"
	end
	return p
end


-- Применение свойств поверхности
function player.apply(surface)

	if surface == "building" then
		return player.building()
	end

	if surface == "door" then
		return player.door()
	end

	if surface == "forest" then
		return player.forest()
	end

	if surface == "ground" then
		return player.ground()
	end

	if surface == "water" then
		return player.water()
	end
end


-- Поведение в здании
function player.building()
	player.smult = 0.5
	player.sound.step = sound.player.step.building
	return "building"
end


function player.door()
	player.smult = 0.5
	player.sound.step = sound.player.step.building
	return "door"
end


-- Поведение в лесу
function player.forest()
	player.smult = 0.5
	player.sound.step = sound.player.step.forest
	return "forest"
end


-- Поведение на земле
function player.ground()
	player.smult = 1
	player.sound.step = sound.player.step.ground
	return "ground"
end


-- Поведение в воде
function player.water()
	player.smult = 0.25
	player.sound.step = sound.player.step.water
	return "water"
end


function player.attack()


end

function player.death()

	game.setState("death")
end