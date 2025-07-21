expose("Test document", function()
    local document = require "moonscribe.document"
    describe("parse preamble", function()
        it("should return the whole text if there was no preamble", function()
          local texts = { "hello world",  "hello\nworld", "--- no closing dashes"}
          for _, text in ipairs(texts) do
            local metadata = document.parse_content(text)
            assert.are.same({ content = text }, metadata)
          end
        end)
        it("should parse preamble and content", function()
          local text1 = [[---
title: Hello title
---
Hello world
]]

          local text2 = [[
---
title: "Hello title"
---
Hello world
]]

          for _, text in ipairs({ text1, text2 }) do
            local metadata = document.parse_content(text)
            assert.are.same({
              title = "Hello title",
              content = "Hello world\n"
            }, metadata)
          end
        end)
        it("should parse dates", function()
          local origdate =  "2025-07-20"
          local text = string.format("---\ntest: %s\n---\nxxx", origdate)
          local metadata = document.parse_content(text)
          -- the yaml library parses dates as Lua timestamps and substracts 8 hours, I don't know why
          -- but we can fix it by adding 8 hours
          assert.same(os.date("%Y-%m-%d", metadata.test + 8 * 3600), origdate)
        end)
    end)
end)
