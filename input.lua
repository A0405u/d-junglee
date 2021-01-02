input = {}

function input.load()

end

function input.keypressed(pressed_key)

    if screen.state == "info" then

        -- if pressed_key == "return" or pressed_key == "escape" or pressed_key == "space" then
        --     game.map()
        --     return
        -- end

        choice.update(pressed_key)
        return
    end

    -- if pressed_key == 'escape' then
    --     love.event.quit()
    --     return
    --   end

    if screen.state == "title" then
        game.info()
        sound.stop(sound.intro)
        sound.play(sound.start)
        return
    end

    if screen.state == "file" then
        game.map()
        return
    end

    if screen.state == "intro" then
        game.logo()
        return
    end

    if screen.state == "logo" then
        game.title()
        return
    end

    if screen.state == "death" then
        love.load()
        game.title()
        return
    end

    if screen.state == "terminal" then

        if pressed_key == "left" or pressed_key == "right" then
            cursor.move(pressed_key)

        elseif pressed_key == "up" or pressed_key == "down" then
            terminal.move(pressed_key)

        elseif pressed_key == "backspace" then
            terminal.erase()

        elseif pressed_key == "return" then
            terminal.enter()

        elseif pressed_key == "escape" then
            game.map()
        end
        return
    end

    if screen.state == "map" then

        if pressed_key == "tab" then
            --screen.tip.help = false
            if screen.tip.show == true then
                sound.tip.hide:seek(0)
                sound.tip.hide:play()
                screen.tip.show = false
            else
                sound.tip.show:seek(0)
                sound.tip.show:play()
                screen.tip.show = true
            end
            return
        end

        if pressed_key == "escape" then
            game.terminal()
            return
        end

        if pressed_key == "space" then
            cycle.switch()
            return
        end
        
        player.keypressed(pressed_key)

        return
    end
end

function input.textinput(text)

    if screen.state == "terminal" then

        terminal.write(text)
    end
end

function input.update(dt)
    
end