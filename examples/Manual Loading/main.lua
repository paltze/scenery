local SceneryInit = require("scenery")
local scenery = SceneryInit(
    { path = "scenes.scene1"; key = "scene1" },
    { path = "scenes.scene2"; key = "scene2" }
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