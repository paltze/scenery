# Scenery - A dead simple Love2D SceneManager

![image](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua)
![image](https://img.shields.io/static/v1?label=L%C3%B6ve2D&message=11.4&labelColor=e64998&color=28abe3&style=for-the-badge)
![image](https://img.shields.io/badge/Version-0.3.1-blue?style=for-the-badge)

Scenery is a dead simple SceneManager for Love2D. Love2D does not have a built in scene system and for someone who comes from [`Phaser`](https://phaser.io) that seemed to be a big gap in a game library so complete. Therefore to fill that gap I implemented this simple library.

Scenes are to games what acts are to plays. You may also think of them as Game State. Lets say, for example, after completing a level you want to display the score to player. Normally you would stop running the code that renders the game and run the code that draws the score instead. But that can quickly become both cumbersome and messy as the game becomes more and more complex. Scenes to the rescue. With scenes there can be a better approach to this. In the above example you just divide your game into two scenes: `Game` and `Score`. You first run the `Game` scene and after game over switch over to the `Score` scene. As simple as that.

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
> Scenery supports all the Love2D 11.4 [callbacks](https://love2d.org/wiki/Category:Callbacks).

> You must call all the callbacks with Love2D which you intend to use in your scenes.

### Scenes

Scenes are, at the basic level, just tables returned by a file. In Scenery each scene must have a separate file for itself and return a table containing all the callback methods. Scene callbacks methods are exactly the same as Love callback methods, except `load`, which has an optional argument containing data transferred by other scenes.

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

If you, however, consider yourself a tad bit more hardworking than rest of the people, you can manually load you scenes. The function returned by `scenery.lua` can accept multiple tables, each for one scene.
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

Changing scenes in Scenery is very simple. Scenery creates a global `setScene` function to change scenes. The function accepts scene key as first parameter and an optional argument which will be passed to the `load` callback of the new scene. It is as simple as:

```lua
setScene("menu", { score = 52 })
```

Then you can access the score in menu scene by:
```lua
function menu:load(args)
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

This repository contains an `example` folder with the many working examples. It is best to see them at least once to get a better understanding of the library.

## Roadmap

- [X] Support all Love2D callbacks.
- [X] Communicate between the scenes.
- [X] Automatically load the scenes.
- [X] Add more examples.
- [X] Pausing and playing scenes.
- [ ] Automatically call love callbacks.

## Contributing

If you found any bug or have any suggestion, feel free to open an issue. If you solved a bug or added a new feature feel free to add a pull request and I will be happy to merge it.

## License

The project is licensed under the MIT License. A copy of the license can be found in the repository by the name of LICENSE.txt