# Scenery - A dead simple Love2D SceneManager

Scenery is a dead simple SceneManager for Love2D. As we all know that Love2D does not have a built in scene system and for someone who comes from [`Phaser`](https://phaser.io) that seemed to be a big gap in a game library so complete. Those who have not worked with scenes before will find that it makes games much more organised. Therefore to fill that gap I implemented this simple library.

## Installation

Just grab the `scenery.lua` from this repository and `require` it in you `main.lua` file.

## Usage

The `scenery.lua` returns a function which accepts multiple scene config table (described below), which in turn returns a table.
+ To use a callback, call the function in returned table with Love callbacks of corresponding name and parameters (see example below).
+ To change the scene, call the global `setScene` function, created by Scenery, with the scene key as first parameter. Anything passed in as second parameter to `setScene` will be passed to `load` function of the new scene.

### Scene Config

The scene config can have following properties:
Property | Descreption
---------|------------
`path`   | The path to the file returning a table structured in the form a scene table (described below).
`key`    | A unique string identifying the scene.
`default`| A boolean value representing the default scene. Must not be `true` on more than one scene. If ommited the first scene in the arguments will be considered default.

### Scene Table

A scene table is a table returned by the file containing a scene. A scene has the exact same callbacks as Love, eg. `load`, `draw`, `update`, etc. Scenery supports all the [callbacks](https://love2d.org/wiki/Category:Callbacks) supported in Love 11.4.

## Example

In `main.lua`
```lua

local sceneryInit = require("path.to.scenery")

local scenery = sceneryInit(
    {path = "path.to.scene1"; key = "scene1"},
    {path = "path.to.scene2"; key = "scene2"}
)

function love.load()
    scenery:load()
end

function love.update(dt)
    scenery:update(dt)
end

function love.draw()
    scenery:draw()
end

```

In `scene1.lua`
```lua

local scene1 = {}

function scene1:load()
    print("Currently in Scene 1")
    self.counter = 0
end

function scene1:update(dt)
    self.counter = self.counter + dt

    if (self.counter > 5) then
        setScene("scene2", "Scenery is awesome")
    end
end

return scene1

```

In `scene2.lua`

```lua

local scene2 = {}

function scene2:load(data)
    self.data = data
end

function scene2:draw()
    love.graphics.print(
        "Now in Scene 2 and recieved '" .. self.data .."' from Scene 1",
        200,
        300
    )
end

return scene2

```

After running the code, if everthing went right, you will have the following output in console:
```
Currently in Scene 1
```

And the following written on screen after 5 seconds:
```
Now in Scene 2 and recieved 'Scenery is awesome' from Scene 1
```
This repository also contains a `example` folder with the another working example.
## Contributing

If you found any bug or have any suggestion, feel free to open an issue. If you solved a bug or added a new feature feel free to add a pull request and I will be happy to merge it.

## License

The project is licensed under the MIT License. A copy of the license can be found in the repository.