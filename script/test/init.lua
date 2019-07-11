require "test.utils.save_load"
require "test.shiori.response"
require "test.shiori.event"
require "test.shiori.utils"


-- とりあえずすぐ試したいテストはここに書く。
function test_every()
    local t = require "test.luaunit"
    local utils = require "shiori.utils"
    local ser = require "libs.serpent"


end

-- ここまで

local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
