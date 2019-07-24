require "test.utils.save_load"
require "test.shiori.response"
require "test.shiori.event"
require "test.shiori.utils"
require "test.shiori.load"


-- とりあえずすぐ試したいテストはここに書く。
function test_os_date()
    local t = require "test.luaunit"
    local ser = require "libs.serpent"

    local d = os.date("*t")
    t.assertIsTrue(d.year > 2018)

    local act = (nil or 0) + 1
    t.assertEquals(act, 1)
end

-- ここまで

local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
