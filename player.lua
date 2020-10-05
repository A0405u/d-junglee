PLAYER_SIZE = 2
PLAYER_SPEED = 4

MIN_POS = 1
MAX_POS = 126

player = {}

-- Конструктор
function player.load()

	player.posx = 94
	player.posy = 113

	player.velx = 0
	player.vely = 0

	player.dirx = 1
	player.diry = 0

	player.size = PLAYER_SIZE
	player.speed = PLAYER_SPEED

	player.sprite = love.graphics.newImage("Sprites/Player.png")
	player.portrait = love.graphics.newImage("Sprites/portrait.png")

	player.moving = false
	player.nextstep = 0

	player.sound = {
		step = sound.player.step.ground
	}
end


-- Update
function player.update(dt)
	player.physics(dt)
	if player.moving then
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


-- Обработка управления
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


-- Предотвращение выхода за границы
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

	return border
end


function player.checkwall()
	--Случай когда движимся наискось
	if player.velx ~= 0 and player.vely ~= 0 then
		-- Если клетка наискось достижима
		if player.detect(player.posx + player.velx, player.posy + player.vely) ~= "unreachable" then
			return
		end
		-- Иначе смотрим клетку по х
		if player.detect(player.posx + player.velx, player.posy) ~= "unreachable" then
			player.vely = 0
			return
		end
		-- Иначе смотрим клетку по y
		if player.detect(player.posx, player.posy + player.vely) ~= "unreachable" then
			player.velx = 0
			return
		end
		-- Иначе никуда не идем
		player.velx = 0
		player.vely = 0
		return
	end
	--Случай когда мы движимся вертикально или горизонтально
	if player.detect(player.posx + player.velx, player.posy + player.vely) == "unreachable" then
		player.velx = 0
		player.vely = 0
		return
	end
	return
end
			



-- Обновление вектора скорости
function player.setvel(dirx, diry)

	player.velx = dirx
	player.vely = diry

	if time >= player.nextstep then
		player.nextstep = time + 1 / player.speed
	end
end


-- Перемещение в пространстве
function player.physics(dt)

	if player.velx ~= 0 or player.vely ~= 0 then

		if time >= player.nextstep then

			player.checkborder()
			player.checkwall() -- Обнулит скорость если туда идти нельзя

			if player.velx ~= 0 or player.vely ~= 0 then
				player.sound.step:seek(0)
				player.sound.step:play()
			end

			player.posx = player.posx + player.velx -- отдельно x от y
			player.posy = player.posy + player.vely -- независимое движение

			player.moving = true

			player.velx = 0
			player.vely = 0
		end
	end
end

-- Перемещение персонажа
function player.move(dt)

	if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
		player.setvel(1, player.vely)

	elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") then
		player.setvel(-1, player.vely)
	
	else
		player.setvel(0, player.vely)
	end

	if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
		player.setvel(player.velx, 1)

	elseif love.keyboard.isDown("w") or love.keyboard.isDown("up") then
		player.setvel(player.velx, -1)

	else
		player.setvel(player.velx, 0)
	end

	if player.velx ~= 0 or player.vely ~= 0 then
		player.dirx = player.velx
		player.diry = player.vely
	else
		player.moving = false
	end
end


-- Обнаружение поверхности
function player.detect(posx, posy)
	r, g, b, a = map.mask:getPixel(posx, posy)

	if r > 0 and g == 0 and b == 0 then
		return player.wall()

	elseif r > 0 and g > 0 and b == 0 then
		return player.door()

	elseif r == 0 and g > 0 and b > 0 then
		return player.building()

	elseif r == 0 and g > 0 and b == 0 then
		return player.forest()
	
	elseif r == 0 and g == 0 and b > 0 then
		return player.water()

	else
		return player.ground()
	end
end


-- Отталкивание от стены
function player.wall()
	return "unreachable"
end


-- Поведение в здании
function player.building()
	player.speed = PLAYER_SPEED / 2
	player.sound.step = sound.player.step.building
	return "building"
end


function player.door()
	player.speed = PLAYER_SPEED / 2
	return "door"
end


-- Поведение в лесу
function player.forest()
	player.speed = PLAYER_SPEED / 2
	player.sound.step = sound.player.step.forest
	return "forest"
end


-- Поведение на земле
function player.ground()
	player.speed = PLAYER_SPEED
	player.sound.step = sound.player.step.ground
	return "ground"
end


-- Поведение в воде
function player.water()
	player.speed = PLAYER_SPEED / 4
	player.sound.step = sound.player.step.water
	return "water"
end


function player.attack()


end

function player.death()

	game.setState("death")
end