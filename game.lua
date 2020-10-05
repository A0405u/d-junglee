game = {}

function game.load()

    game.state = "intro"
    game.key = 0
end

function game.setKey()

    if game.key < 99 and pickups[4].picked == true then
        game.key = 99
        game.setState("end")
    end

    if game.key < 1 and pickups[0].picked == true then
        game.key = 1
        screen.tip.show = true
        screen.tip.text = "Try to find out what happened"
    end
end

function game.setState(state)

    if state == "logo" then
        screen.setState("logo")
        sound.logo:seek(0)
        sound.logo:play()
        return
    end

    if state == "title" then
        screen.setState("title")
        sound.day:stop()
        sound.logo:stop()
        sound.night:stop()
        sound.intro:seek(0)
        sound.intro:play()
        return
    end

    if state == "file" then
        screen.setState("file")
        sound.intro:stop()
        sound.day:seek(0)
        sound.day:play()
        sound.start:seek(0)
        sound.start:play()
        return
    end

    if state == "info" then
        screen.setState("info")
        screen.header = "Sunrise"
        screen.text = "You woke up in open cave. You can see sandy beach and hear seaguls rumble.\n\nYou came across this cave yesterday, and fell asleep staring at the beautiful view.\n\nIt's time to get back."
        return
    end

    if state == "death" then
        screen.setState("death")
        sound.day:stop()
        sound.night:stop()
        sound.death:seek(0)
        sound.death:play()
        return
    end

    if state == "end" then
        screen.setState("end")
        sound.day:stop()
        sound.night:stop()
        sound.pickup:stop()
    end
end
