-- とりあえずすぐ試したいテストはここに書く。

function test_hello(d)
    local t = require "test.luaunit"
    local x = "hello"
    t.assertEquals(x,"hello")

end

function test_event_reg(d)
    local t = require "test.luaunit"
    require "reg_system"
    local ev = require "event"
    t.assertNotIsNil(ev.fire_request)
    t.assertNotIsNil(ev.OnBoot)
end

-- ここまで

local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
