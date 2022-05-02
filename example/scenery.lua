local Scenery = {
    __NAME = "Scenery";
    __VERSION = "v1.0";
    __DESCRIPTION = "Scenery - A dead simple Love2D SceneManager";
    __LICENSE = [[
        MIT License

        Copyright (c) 2022 Paltze

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
    ]]
}

-- The base Scenery Class
Scenery.__index = Scenery

function Scenery.init(...)
    -- Set metatable to create a class
    local this = setmetatable({}, Scenery)
    this.scenes = {}

    -- Get all the parameters
    local config = { ... }

    -- Loop through the parameters and store then in Scenery.scenes
    for _, value in ipairs(config) do
        assert(type(value.path) == "string", "Given path not a string.")
        assert(type(value.key) == "number" or type(value.key) == "string", "Given key not a number or string.")

        this.scenes[value.key] = require(value.path)

        -- Check if default scene present
        if value.default and not this.currentscene then
            this.currentscene = value.key
        elseif value.default and this.currentscene then
            error("A default scene '" .. this.currentscene .. "' already set", 2)
        end
    end

    -- If no default scene, set first scene as default
    if not this.currentscene then
        this.currentscene = config[1].key
    end

    -- Create a global function to change scenes
    function _G.setScene(key, data)
        this.currentscene = key
        if this.scenes[this.currentscene].load then
            this.scenes[this.currentscene]:load(data)
        end
    end

    -- All the callbacks available in Love 11.4 as described on https://love2d.org/wiki/Category:Callbacks
    local loveCallbacks = {
        "directorydropped";
        "displayrotated";
        "draw";
        "errhand";
        "errorhandler";
        "filedropped";
        "focus";
        "gamepadaxis";
        "gamepadpressed";
        "gamepadreleased";
        "joystickadded";
        "joystickaxis";
        "joystickhat";
        "joystickpressed";
        "joystickreleased";
        "joystickremoved";
        "keypressed";
        "keyreleased";
        "load";
        "lowmemory";
        "mousefocus";
        "mousemoved";
        "mousepressed";
        "mousereleased";
        "quit";
        "resize";
        "run";
        "textedit";
        "textinput";
        "threaderror";
        "touchmoved";
        "touchpressed";
        "touchreleased";
        "update";
        "visible";
        "wheelmoved";
    }

    -- Loop through the callbacks creating a function with same name on the base class
    for _, value in ipairs(loveCallbacks) do
        this[value] = function(self, ...)
            -- Check if the function exists on the class
            if self.scenes[self.currentscene][value] then
                self.scenes[self.currentscene][value](self.scenes[self.currentscene], ...)
            end
        end
    end

    return this
end

-- Return the initialising function
return Scenery.init