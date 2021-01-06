sprite = {}

sprite.dot = love.graphics.newImage("sprites/dot.png")

sprite.screen = {

    logo = love.graphics.newImage("sprites/logo.png"),
    title = love.graphics.newImage("sprites/title.png"),
    file = love.graphics.newImage("sprites/file.png"),

    blood = {
        [1] = love.graphics.newImage("sprites/blooddot.png"),
        [2] = love.graphics.newImage("sprites/blood.png")
    },

    noise = love.graphics.newImage("sprites/noise.png"),
    ghost = love.graphics.newImage("sprites/ghost.png"),

    off = {
        [1] = love.graphics.newImage("sprites/off000.png"),
        [2] = love.graphics.newImage("sprites/off001.png")
    },

    help = love.graphics.newImage("sprites/tiphelp.png")
}