local door = {}

function door:new(posx, posy, o)

    self.__index = self

    return setmetatable({
        x = posx,
        y = posy,

        open = o
    }, self)
end

function door:open()

    self.open = true
end

function door:close()

    self.open = false
end

function door:try()

    if self.open then
        sound.play(sound.door.open)
        return true
    else
        sound.play(sound.door.closed)
        return false
    end
end

return door