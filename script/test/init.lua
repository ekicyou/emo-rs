require "test.utils.save_load"
require "test.shiori.response"
require "test.shiori.event"


-- とりあえずすぐ試したいテストはここに書く。
function test_every()
    local t = require "test.luaunit"
    local utils = require "shiori.utils"

    do
        local act = utils.get_status("talking,choosing,balloon(0=2,1=0)")
        t.assertNotIsTrue(act.talking)
    end
end

-- ここまで

local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
