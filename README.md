# Scenery - A dead simple Love2D Scene/State Manager

![image](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua)
![image](https://img.shields.io/static/v1?label=L%C3%B6ve2D&message=11.4&labelColor=e64998&color=28abe3&style=for-the-badge)
![image](https://img.shields.io/badge/Version-0.4-blue?style=for-the-badge)

Scenery is a dead simple Scene/State Manager for Love2D.

Scenes (or States) are a very popular organising system for games. Scenery is a simple to use and lightweight implementation of the system for Love2D.

## Installation

Just grab the `scenery.lua` from this repository and `require` it in you `main.lua` file.

## Usage

After initialization of Scenery (described in detail below) just call the used callbacks in corresponding Love2D callbacks.

For example:
```lua
local SceneryInit = require("path.to.scenery")
local scenery = SceneryInit(...)

function love.load()
    scenery:load()
end

function love.draw()
    scenery:draw()
end

function love.update(dt)
    scenery:update(dt)
end
```
Also, the `scenery` instance has a `hook` method on it, which will do the boilerplate for you. The above example can be shortened as:
```lua
local SceneryInit = require("path.to.scenery")
local scenery = SceneryInit(...)
scenery:hook(lua)
```

> Scenery supports all the Love2D 11.4 [callbacks](https://love2d.org/wiki/Category:Callbacks).

> The `hook` method optionally accepts a second argument, a table, with the callbacks which will be hooked. eg `{ "load", "draw", "update" }`

### Scenes

Scenes are, in Scenery, just tables returned by a file. Each scene must have a separate file for itself and return a table containing all the callback methods. Scene callbacks methods are exactly the same as Love callback methods, except `load`, which has an optional argument containing data transferred by other scenes.

An Example Scene:
```lua
local game = {}

function game:load()
    print("Scenery is awesome")
end

function game:draw()
    love.graphics.print("Scenery makes life easier", 200, 300)
end

function game:update(dt)
    print("You agree, don't you?")
end

return game
```

### Loading the Scenes

#### Automatic Loading
Scenery can automatically load your scenes for you. `scenery.lua` returns a function that accepts a default scene as first parameter and path to the folder containing scenes as an optional second parameter. If no path is supplied Scenery will look into `scenes` folder from the folder containing your `main.lua` file for scenes.

Example:
```lua
local SceneryInit = require("path.to.scenery")
local scenery = SceneryInit("scene", "path/to/scenes")
```

> The filename of the file (without the extension) containing scene will be considered the scene key.

> If your file name has periods (.) before the file extension (eg `game.scene.lua`) then only the string before the first period (ie `game` in the above case) will be considered the scene key.

#### Manual Loading

Scenery can also manually load you scenes. The function returned by `scenery.lua` can accept multiple tables, each for one scene.
You can have the following properties in the table:

Property | Description
---------|------------
`path`   | The path to the file returning a table structured in the form a scene table.
`key`    | A unique string identifying the scene.
`default` (optional)| A boolean value representing the default scene. Must not be `true` on more than one scene. If omitted the first scene in the arguments will be considered default.

Example:
```lua
local SceneryInit = require("path.to.scenery")
local scenery = SceneryInit(
    { path = "path.to.scene1"; key = "scene1"; default = "true" },
    { path = "path.to.scene2"; key = "scene2"; }
)
```

### Changing Scenes

Changing scenes in Scenery is very simple. Scenery creates a `setScene` method on the scene table to change scenes. The function accepts scene key as first parameter and an optional argument which will be passed to the `load` callback of the new scene. It is as simple as:

```lua
function scene1:load()
    self.setScene("scene2", { score = 52 })
end
```

Then you can access the score in menu scene by:
```lua
function scene2:load(args)
    print(args.score) -- prints 52
end
```

### Pausing Scenes

You can pause the scene by setting the scene's `paused` property to `true` and vice-versa.

eg:
```lua
local scene = {}

scene.paused = true

return scene
```
While being paused instead of `draw` the `pause` function is used for drawing.

## Examples

This repository contains an `example` folder with the working examples. It might be consulted in case of non-clarity.

## Roadmap

- [X] Support all Love2D callbacks.
- [X] Communicate between the scenes.
- [X] Automatically load the scenes.
- [X] Add more examples.
- [X] Pausing and playing scenes.
- [X] Automatically call love callbacks.
- [ ] Take tables as scenes

## Contributing

If you found any bug or have any suggestion, feel free to open an issue. If you solved a bug or added a new feature feel free to add a pull request and I will be happy to merge it.

## License

The project is licensed under the MIT License. A copy of the license can be found in the repository by the name of LICENSE.txt