require "test.shiori.event"


-- とりあえずすぐ試したいテストはここに書く。

function test_hello(d)
    local t = require "test.luaunit"
    local x = "hello"
    t.assertEquals(x,"hello")

end

-- ここまで

local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
