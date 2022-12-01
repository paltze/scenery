local test = {}

function test:load()
    print("In scene 1")
    self.counter = 0
end

function test:update(dt)
    self.counter = self.counter + dt
    if self.counter > 2 then
        self.paused = not self.paused
        self.counter = 0
    end
end

function test:pause()
    love.graphics.print("Now Paused", 400, 300)
end

function test:draw()
    love.graphics.print("Now Playing", 400, 300)
end

return test