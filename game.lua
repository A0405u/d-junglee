game = {}

function game.load()
    
    game.state = "intro"
    game.key = 0
end

function game.setKey()

    if game.key < 99 and pickups[5].picked == true then
        game.key = 99
        game.ending()
    end

    if game.key < 1 and pickups[1].picked == true then
        game.key = 1
        screen.tip.show = true
        screen.tip.text = "Попробуй выяснить что произошло"
    end
end

function game.info(header, text, choices)

    game.state = "info"

    print(header)

    screen.header = header
    screen.text = text
    choice.set(choices)

    screen.show("info")
end

function game.terminal()

    game.state = "terminal"
    screen.show("terminal")
    love.keyboard.setKeyRepeat(true)
end


function game.title()
    game.state = "title"
    screen.show("title")

    sound.stop(sound.logo)
    sound.stop(sound.day)
    sound.stop(sound.night)
    
    sound.play(sound.intro)
end


function game.map()

    game.state = "map"
    screen.show("map")
    love.keyboard.setKeyRepeat(false)
end


function game.file()

    game.state = "file"
    screen.show("file")
end


function game.font()

    game.state = "font"
    screen.show("font")
end


function game.map()

    game.state = "map"
    screen.show("map")
end


function game.logo()

    game.state = "logo"
    screen.show("logo")

    sound.play(sound.logo)
end


function game.death()

    game.state = "death"
    screen.show("death")

    sound.stop(sound.day)
    sound.stop(sound.night)
    sound.play(sound.death)
end


function game.ending()

    game.state = "ending"

    screen.tip.show = false
    screen.show("ending")
    
    sound.stop(sound.day)
    sound.stop(sound.night)
    sound.stop(sound.pickup)
end