local scene1 = {}

function scene1:load()
    self.counter = 0
end

function scene1:draw()
    love.graphics.print("Waiting...", 200, 300)
end

function scene1:update(dt)
    self.counter = self.counter + dt

    if self.counter > 5 then
        self.setScene("scene2")
    end
end

return scene1