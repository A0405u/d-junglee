cycle = {}

function cycle.load()
    cycle.day = 1
    cycle.night = 32
    cycle.time = 0
    cycle.state = "day"
    cycle.len = cycle.day
end

function cycle.update(dt)
    cycle.time = cycle.time + dt

    if cycle.time >= cycle.len then

        if cycle.state == "day" then
            cycle.state = "night"
            cycle.len = cycle.night
            sound.day:stop()
            sound.night:seek(0)
            sound.night:play()
        else
            cycle.state = "day"
            cycle.len = cycle.day
            sound.night:stop()
            sound.day:seek(0)
            sound.day:play()
        end
        cycle.time = 0
        sound.cycle:seek(0)
        sound.cycle:play()
    end
end