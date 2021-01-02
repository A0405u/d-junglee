cycle = {}

function cycle.load()
    cycle.day = 16
    cycle.night = 12
    cycle.time = 0
    cycle.state = "day"
    cycle.len = cycle.day
end

function cycle.turn()
    cycle.time = cycle.time + 1
    if cycle.time >= cycle.len then
        cycle.switch()
    end
end

function cycle.switch()

    if cycle.state == "day" then
        cycle.state = "night"
        cycle.len = cycle.night
        --sound.stop(sound.day)
        --sound.play(sound.night)
    else
        cycle.state = "day"
        cycle.len = cycle.day
        --sound.stop(sound.night)
        --sound.play(sound.day)
    end
    
    color.theme(cycle.state)
    cycle.time = 0
end