sound = {}

function sound.load()

    sound.player = {}
    sound.player.step = {}
    sound.player.step.ground = love.audio.newSource("Sounds/playerstepground.wav", "static")
    sound.player.step.forest = love.audio.newSource("Sounds/playerstepforest.wav", "static")
    sound.player.step.building = love.audio.newSource("Sounds/playerstepbuilding.wav", "static")
    sound.player.step.water = love.audio.newSource("Sounds/playerstepwater.wav", "static")

    sound.monster = {}
    sound.monster.step = love.audio.newSource("Sounds/enemystep.wav", "static")

    sound.pickup = love.audio.newSource("Sounds/pickup.wav", "static")

    sound.death = love.audio.newSource("Sounds/death.wav", "static")

    sound.shot = love.audio.newSource("Sounds/shot.wav", "static")
    sound.last = love.audio.newSource("Sounds/end.wav", "static")

    sound.intro = love.audio.newSource("Sounds/intro.wav", "static")
    sound.intro:setLooping(true)

    sound.logo = love.audio.newSource("Sounds/logo.wav", "static")
    sound.start = love.audio.newSource("Sounds/start.wav", "static")
    sound.screen = love.audio.newSource("Sounds/screen.wav", "static")
    sound.cycle = love.audio.newSource("Sounds/cycle.wav", "static")
    sound.tip = {
        show = love.audio.newSource("Sounds/tipshow.wav", "static"),
        hide = love.audio.newSource("Sounds/tiphide.wav", "static")
    }

    sound.day = love.audio.newSource("Sounds/day.wav", "static")
    sound.day:setLooping(true)

    sound.night = love.audio.newSource("Sounds/night.wav", "static")
    sound.night:setLooping(true)
end

function sound.play(sound)
	sound:stop()
	sound:seek(0)
	sound:play()
end