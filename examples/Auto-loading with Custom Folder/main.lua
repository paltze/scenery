local SceneryInit = require("scenery")
local scenery = SceneryInit("scene1", "states")

function love.load()
    scenery:load()
end

function love.draw()
    scenery:draw()
end

function love.update(dt)
    scenery:update(dt)
end