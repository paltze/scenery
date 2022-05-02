local sceneryInit = require('scenery')
local scenery = sceneryInit(
    {path = "scenes.test"; key = "test", default = true},
    {path = "scenes.test2"; key = "test2"}
)

function love.load()
    scenery:load()
end

function love.draw()
    scenery:draw()
end

function love.update(dt)
    scenery:update(dt)
end