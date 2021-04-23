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
    local utf8 = require "utf8"
    local str = "пыщпыщ ололоо я водитель нло"

    local rep, cnt = str:gsub("ло+", "《》")
    t.assertEquals(rep, "пыщпыщ о《》《》о я водитель н《》")
    t.assertEquals(cnt, 3)

    local rep, cnt = utf8.gsub(str, "ло+", "《》")
    t.assertEquals(rep, "пыщпыщ о《》《》 я водитель н《》")
    t.assertEquals(cnt, 3)

    t.assertEquals(str:match("^п[лопыщ ]*я"), "пыщпыщ ололоо я")




end

-- ここまで

local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
