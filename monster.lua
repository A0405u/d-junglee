local monster = {}

function monster:new(x, y, sz, sp, rng, rt, cl)

    self.__index = self

    return setmetatable({
        posx = x,
		posy = y,

		initx = x,
		inity = y,
		
		velx = 0,
		vely = 0,
    
        size = sz or 1,
		speed = sp or 1,

		range = rng or 16,

		returning = rt,

		color = cl or {1, 0, 0},

		turncount = 0,
		delay = 0,

		smult = 1, -- speed multiplier

		path = {
			nodes = {},
			delay = 0
		},
    }, self)
end

function monster:update(dt)

	if cycle.state == "day" then
		return
	end

	self.delay = self.delay - dt

	if self.turncount > 0 then

		if self.delay <= 0 then

			self:turn()
			self.delay = turn.delay / self.speed
		end
	end
end


function monster:draw()

	if cycle.state == "night" then
		if time % 0.5 > 0.25 then
			love.graphics.setColor(color.black)
			love.graphics.points(self.posx + 0.5, self.posy + 0.5)
		else
			love.graphics.setColor(self.color)
			love.graphics.setBlendMode("add")
			love.graphics.draw(sprite.dot, self.posx - 7, self.posy - 7)
			love.graphics.setBlendMode("alpha")
		end

		-- love.graphics.setColor(self.color)
		-- love.graphics.setBlendMode("add")
		-- love.graphics.circle("line", self.posx, self.posy, self.range)
		-- love.graphics.setBlendMode("alpha")

--		self:drawpath()
	end
end



function monster:addturn()

	if cycle.state == "day" then
		return
	end

	self.turncount = self.turncount + self.speed
end



function monster:turn()

	self.turncount = self.turncount - 1

	self:physics()
	self:checkcollision()
end

-- Проверка на достижимость клетки, возвращает true если возможно дальнейшее движение
function monster:checkwall()
	--Случай когда движимся наискось
	if self.velx ~= 0 and self.vely ~= 0 then
		-- Если клетка наискось достижима
		if self:check(self.posx + self.velx, self.posy + self.vely) ~= "unreachable" then
			return true
		end
		-- Иначе смотрим клетку по х
		if self:check(self.posx + self.velx, self.posy) ~= "unreachable" then
			self.vely = 0
			return true
		end
		-- Иначе смотрим клетку по y
		if self:check(self.posx, self.posy + self.vely) ~= "unreachable" then
			self.velx = 0
			return true
		end
		-- Иначе никуда не идем
		self.velx = 0
		self.vely = 0
		return false
	end
	--Случай когда мы движимся вертикально или горизонтально
	if self:check(self.posx + self.velx, self.posy + self.vely) == "unreachable" then
		self.velx = 0
		self.vely = 0
		return false
	end
	return true
end


function monster:distance(posx, posy)

	local xdif = self.posx - posx
	local ydif = self.posy - posy

	return math.sqrt(xdif * xdif + ydif * ydif)
end


function monster:getpath()

	local temp = nil -- Переменная для хранения пути

	if self:distance(player.posx, player.posy) <= self.range then -- Если игрок находится в радиусе обнаружения
		temp = path.get(self.posx, self.posy, player.posx, player.posy) -- Поиск пути к игроку
	end
	
	if self.returning and not temp then -- Если монстр возвращается и пути к игроку нет или он далеко
		temp = path.get(self.posx, self.posy, self.initx, self.inity)  -- он уходит на начальную позицию
	end

	if not temp then return end -- Если и пути назад не нашлось, не ищем новый путь, а двигаемся по старому

	self.path.nodes = {}

	for node, count in temp:nodes() do
		self.path.nodes[count] = {node:getPos()}
	end

	table.remove(self.path.nodes, 1)

end



function monster:drawpath()

	if next(self.path.nodes) ~= nil then

		love.graphics.setColor(1, 0, 0)
		for i = 1, #self.path.nodes do
			love.graphics.points(self.path.nodes[i][1] + 0.5, self.path.nodes[i][2] + 0.5)
		end
	end
end


function monster:follow()

	if next(self.path.nodes) ~= nil then

		local current = table.remove(self.path.nodes, 1)

		self:setvel(current[1] - self.posx, self.vely)

		self:setvel(self.velx, current[2] - self.posy)
	end
end



function monster:physics()

	if self:checkwall() then

		if self.velx ~= 0 or self.vely ~= 0 then

			self.posx = self.posx + self.velx -- отдельно x от y
			self.posy = self.posy + self.vely -- независимое движение

			sound.play(sound.monster.step)

			self.velx = 0
			self.vely = 0
		end
		
		self:getpath()
		self:follow()
	end
end


function monster:setvel(dirx, diry)

	self.velx = dirx
	self.vely = diry
end


function monster:check(posx, posy)
	local p = map.get(posx, posy)
	if p == "wall" or p == "building" or p == "door" or p == "water" then
		return "unreachable"
	end
	return p
end


-- Поведение в лесу
function monster:forest()
	return "forest"
end


-- Поведение на земле
function monster:ground()
	return "ground"
end


-- Убийство игрока в случае сопрокосновения
function monster:checkcollision()

	if player.posx == self.posx and player.posy == self.posy then
		player.death()
	end
end


return monster