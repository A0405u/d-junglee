local pickup = {}


function pickup:new(x, y, sx, sy, d, n, t)

    self.__index = self

    return setmetatable({
        posx = x,
        posy = y,
    
        sizex = sx,
        sizey = sy,
    
        display = d,
    
        name = n,
        text = t,

        picked = false
    }, self)
end

function pickup:draw()

    if self.picked == false then
        if self.display == true then
            if time % 0.5 < 0.25 then
                love.graphics.setColor(91/255, 168/255, 255/255)
                love.graphics.rectangle("line", self.posx + 0.5, self.posy + 0.5, self.sizex - 0.5, self.sizey - 0.5)
            end
        end
    end
end


function pickup:update(dt)

    if self.picked == false then
        if player.posx >= self.posx and player.posx < self.posx + self.sizex then
            if player.posy >= self.posy and player.posy < self.posy + self.sizey then
                self:pick()
            end
        end
    end
end


function pickup:pick()
    self.posx = screen.size.x
    self.posy = screen.size.y

    screen.header = self.name
    screen.text = self.text
    screen.setState("info")

    sound.pickup:seek(0)
    sound.pickup:play()

    self.picked = true

    game.setKey()
end


return pickup