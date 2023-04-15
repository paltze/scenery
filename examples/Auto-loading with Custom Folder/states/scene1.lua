local scene1 = {}

function scene1:load()
    self.counter = 0
end

function scene1:draw()
    love.graphics.print(self.counter .. " people love Scenery", 300, 250)
end

function scene1:update()
    self.counter = self.counter + 1

    if self.counter > 500 then
        self.setScene("scene2", self.counter)
    end
end

return scene1