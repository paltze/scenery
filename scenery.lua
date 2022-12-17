local Scenery = {
    __NAME = "Scenery";
    __VERSION = "0.3.1";
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

-- Split file into name and extension
local split = function(inputstr, sep)
    local t = {}
    for res in string.gmatch(inputstr, "([^"..sep.."]+)") do table.insert(t, res) end
    return t[1], t[#t]
end

-- Automatically load scenes from the given directory
local autoLoad = function(directory)
    -- Get the files in the directory
    local files = love.filesystem.getDirectoryItems(directory)
    local scenes = {}

    for _, value in ipairs(files) do
        local file, ext = split(value, ".")

        -- Require scene
        if ext == "lua" and file ~= "conf" and file ~= "main" then
            scenes[file] = require(directory .. "." .. file)
        end
    end

    return scenes
end

-- Iterate over the passed tables
local manualLoad = function(config)
    local scenes = {}
    local currentScene

    -- Loop through the parameters
    for _, value in ipairs(config) do
        -- Check if path is string
        assert(type(value.path) == "string", "Given path not a string.")

        -- Check if key is number or string
        assert(type(value.key) == "number" or type(value.key) == "string", "Given key not a number or string.")

        --Check for duplicate scene keys
        assert(not scenes[value.key], "Duplicate scene keys provided")

        scenes[value.key] = require(value.path)

        -- Check if default scene present
        if value.default then
            assert(not currentScene, "More than one default scene defined")
            currentScene = value.key
        end
    end

    -- If no default scene, set first scene as default
    if not currentScene then
        currentScene = config[1].key
    end

    return scenes, currentScene
end

local checkScenePresent = function(scene, sceneTable)
    local present = false

    for index, _ in pairs(sceneTable) do
        if index == scene then
            present = true
        end
    end

    return present
end

-- The base Scenery Class
Scenery.__index = Scenery

function Scenery.init(...)
    -- Set metatable to create a class
    local this = setmetatable({}, Scenery)

    -- Get all the parameters
    local config = { ... }

    -- Get scenes
    if config[1] == nil then
        error("No default scene supplied", 2)
    elseif type(config[1]) == "table" then
        this.scenes, this.currentscene = manualLoad(config)
    elseif type(config[1]) =="string" then
        this.scenes = autoLoad(config[2] or "scenes")
        assert(checkScenePresent(config[1], this.scenes), "No scene '" .. config[1] .. "' present")
        this.currentscene = config[1]
    else
        error("Unknown token '" .. config[1] .. "'", 2)
    end

    for _, value in pairs(this.scenes) do
        value["paused"] = false
    end

    -- Create a global function to change scenes
    function _G.setScene(key, data)
        assert(this.scenes[key], "No such scene '" .. key .. "'")
        this.currentscene = key
        if this.scenes[this.currentscene].load then
            this.scenes[this.currentscene]:load(data)
        end
    end

    -- All the callbacks available in Love 11.4 as described on https://love2d.org/wiki/Category:Callbacks
    local loveCallbacks = {
        "directorydropped";
        "displayrotated";
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
        "textedited";
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
            assert(type(self.scenes[self.currentscene]) == "table", "Scene '" .. self.currentscene .. "' not a valid scene.")

            -- Check if the function exists on the class
            if self.scenes[self.currentscene][value] then
                return self.scenes[self.currentscene][value](self.scenes[self.currentscene], ...)
            end
        end
    end

    this["draw"] = function (self, ...)
        assert(type(self.scenes[self.currentscene]) == "table", "Scene '" .. self.currentscene .. "' not a valid scene.")

        -- Check if the scene paused
        if self.scenes[self.currentscene]["draw"] and not self.scenes[self.currentscene]["paused"] then
            self.scenes[self.currentscene]["draw"](self.scenes[self.currentscene], ...)
        elseif self.scenes[self.currentscene]["draw"] and self.scenes[self.currentscene]["paused"] then
            self.scenes[self.currentscene]["pause"](self.scenes[self.currentscene], ...)
        end
    end

    return this
end

-- Return the initialising function
return Scenery.init