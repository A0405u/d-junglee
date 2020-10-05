ENEMY_SIZE = 16
ENEMY_SPEED = 10

enemy = {}

-- Конструктор
function enemy.load()

	enemy.posx = 40
	enemy.posy = 48

	enemy.velx = 0
	enemy.vely = 0

	enemy.dirx = 1
	enemy.diry = 0

	enemy.size = ENEMY_SIZE
	enemy.speed = ENEMY_SPEED

	enemy.nextstep = 0

	enemy.sprite = love.graphics.newImage("Sprites/Enemy.png")
	enemy.sound = {
		--move = love.audio.newSource("Sounds/enemymove.wav", "static")
	}
end

function enemy.update(dt)
	if cycle.state == "night" then
		enemy.physics(dt)
	end
	enemy.checkcollision(dt)
end


function enemy.draw()

	if cycle.state == "night" then
		if time % 0.5 > 0.25 then
			love.graphics.setColor(97/255, 0, 0)
		else
			love.graphics.setColor(1, 0, 0)
		end
		love.graphics.points(enemy.posx + 0.5, enemy.posy + 0.5)
	end
end


function enemy.checkwall()
	--Случай когда движимся наискось
	if enemy.velx ~= 0 and enemy.vely ~= 0 then
		-- Если клетка наискось достижима
		if enemy.detect(enemy.posx + enemy.velx, enemy.posy + enemy.vely) ~= "unreachable" then
			return
		end
		-- Иначе смотрим клетку по х
		if enemy.detect(enemy.posx + enemy.velx, enemy.posy) ~= "unreachable" then
			enemy.vely = 0
			return
		end
		-- Иначе смотрим клетку по y
		if enemy.detect(enemy.posx, enemy.posy + enemy.vely) ~= "unreachable" then
			enemy.velx = 0
			return
		end
		-- Иначе никуда не идем
		enemy.velx = 0
		enemy.vely = 0
		return
	end
	--Случай когда мы движимся вертикально или горизонтально
	if enemy.detect(enemy.posx + enemy.velx, enemy.posy + enemy.vely) == "unreachable" then
		enemy.velx = 0
		enemy.vely = 0
		return
	end
	return
end


function enemy.follow()

	if enemy.posx > player.posx then
		enemy.setvel(-1, enemy.vely)
	
	elseif enemy.posx < player.posx then
		enemy.setvel(1, enemy.vely)

	else
		enemy.setvel(0, enemy.vely)
	end

	if enemy.posy > player.posy then
		enemy.setvel(enemy.velx, -1)
	
	elseif enemy.posy < player.posy then
		enemy.setvel(enemy.velx, 1)

	else
		enemy.setvel(enemy.velx, 0)
	end
end


function enemy.physics(dt)

	if time >= enemy.nextstep then

		enemy.checkwall()

		if enemy.velx ~= 0 or enemy.vely ~= 0 then
			sound.enemy.step:seek(0)
			sound.enemy.step:play()
		end

		enemy.posx = enemy.posx + enemy.velx -- отдельно x от y
		enemy.posy = enemy.posy + enemy.vely -- независимое движение
		
		enemy.velx = 0
		enemy.vely = 0
	end
	enemy.follow()
end


function enemy.setvel(dirx, diry)

	enemy.velx = dirx
	enemy.vely = diry

	if time >= enemy.nextstep then
		enemy.nextstep = time + 1 / enemy.speed
	end
end


-- Обнаружение поверхности
function enemy.detect(posx, posy)
	r, g, b, a = map.mask:getPixel(posx, posy)

	if r > 0 and g == 0 and b == 0 then
		return enemy.wall()

	elseif r > 0 and g > 0 and b == 0 then
		return enemy.door()

	elseif r == 0 and g > 0 and b > 0 then
		return enemy.building()

	elseif r == 0 and g > 0 and b == 0 then
		return enemy.forest()
	
	elseif r == 0 and g == 0 and b > 0 then
		return enemy.water()

	else
		return enemy.ground()
	end
end


-- Поведение в здании
function enemy.wall()
	return "unreachable"
end

function enemy.door()
	return "unreachable"
end

function enemy.water()
	return "unreachable"
end

function enemy.building()
	return "unreachable"
end

-- Поведение в лесу
function enemy.forest()
	enemy.speed = ENEMY_SPEED / 2
	return "forest"
end


-- Поведение на земле
function enemy.ground()
	enemy.speed = ENEMY_SPEED
	return "ground"
end

-- Убийство игрока в случае сопрокосновения
function enemy.checkcollision(dt)

	if player.posx == enemy.posx and player.posy == enemy.posy then
		player.death()
	end
end