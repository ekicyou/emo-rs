require "test.shiori.event"


-- とりあえずすぐ試したいテストはここに書く。

function test_hello(d)
    local t = require "test.luaunit"
    local x = "hello"
    t.assertEquals(x,"hello")
    t.assertEquals(_VERSION,"Lua 5.1")
end


function test_utf8(d)
    local t = require "test.luaunit"
    local utf8 = require("libs.utf8"):init()
    local str = "пыщпыщ ололоо я водитель нло"
    print(str:find("(.л.+)н"))
    -- 8	26	ололоо я водитель

    local rep, cnt = str:gsub("ло+", "보라")
    t.assertEquals(rep, "пыщпыщ о보라보라о я водитель н보라")
    t.assertEquals(rep, 3)

    t.assertEquals(str:match("^п[лопыщ ]*я"), "пыщпыщ ололоо я")

end

-- ここまで

local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
