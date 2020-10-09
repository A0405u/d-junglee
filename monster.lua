local monster = {}

function monster:new(x, y, sz, sp)

    self.__index = self

    return setmetatable({
        posx = x,
		posy = y,
		
		velx = 0,
		vely = 0,
    
        size = sz,
		speed = sp,

		smult = 1, -- speed multiplier
		timer = 0,
    }, self)
end

function monster:update(dt)
	if cycle.state == "night" then
		self:physics(dt)
	end
	self:checkcollision(dt)
end


function monster:draw()

	if cycle.state == "night" then
		if time % 0.5 > 0.25 then
			love.graphics.setColor(97/255, 0, 0)
		else
			love.graphics.setColor(1, 0, 0)
		end
		love.graphics.points(self.posx + 0.5, self.posy + 0.5)
	end
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


function monster:follow()

	if self.posx > player.posx then
		self:setvel(-1, self.vely)
	
	elseif self.posx < player.posx then
		self:setvel(1, self.vely)

	else
		self:setvel(0, self.vely)
	end

	if self.posy > player.posy then
		self:setvel(self.velx, -1)
	
	elseif self.posy < player.posy then
		self:setvel(self.velx, 1)

	else
		self:setvel(self.velx, 0)
	end
end


function monster:physics(dt)

	if time >= self.timer then

		if self:checkwall() then

			self.posx = self.posx + self.velx -- отдельно x от y
			self.posy = self.posy + self.vely -- независимое движение

			sound.play(sound.monster.step)

			self.velx = 0
			self.vely = 0
		end
	end
	
	self:follow()
end


function monster:setvel(dirx, diry)

	self.velx = dirx
	self.vely = diry

	if time >= self.timer then
		self.timer = time + 1 / (self.speed * self.smult)
	end
end


function monster:check(posx, posy)
	local p = map.get(posx, posy)
	if p == "wall" or p == "building" or p == "door" or p == "water" then
		return "unreachable"
	end
	return p
end


function monster:apply(surface)

	if surface == "forest" then
		return self:forest()
	end

	if surface == "ground" then
		return self:ground()
	end
end


-- Поведение в лесу
function monster:forest()
	self.smult = 0.5 
	return "forest"
end


-- Поведение на земле
function monster:ground()
	self.smult = 1
	return "ground"
end


-- Убийство игрока в случае сопрокосновения
function monster:checkcollision(dt)

	if player.posx == self.posx and player.posy == self.posy then
		player.death()
	end
end


return monster