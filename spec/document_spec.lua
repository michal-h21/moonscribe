expose("Test document", function()
    local document = require "moonscribe.document"
    describe("some assertions", function()
        it("tests positive assertions", function()
            assert.is_true(true)    -- Lua keyword chained with _
            assert.True(true)         -- Lua keyword using a capital
            assert.are.equal(1, 1)
            assert.has.errors(function() error("this should fail") end)
        end)
    end)
end)
