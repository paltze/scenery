local test = {}

function test:load()
    print("In scene 1")
    self.testValue = "Scenery is awesome"
end

function test:update(dt)
    print(self.testValue)
    print(dt)
    setScene("test2", dt)
end

return test