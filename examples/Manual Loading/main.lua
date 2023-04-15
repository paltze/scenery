local SceneryInit = require("scenery")
local scenery = SceneryInit(
    { path = "scenes.scene1"; key = "scene1" },
    { path = "scenes.scene2"; key = "scene2" }
)
scenery:hook(love)