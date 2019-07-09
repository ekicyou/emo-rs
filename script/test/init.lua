require "test.utils.save_load"
require "test.shiori.response"
require "test.shiori.event"


-- とりあえずすぐ試したいテストはここに書く。
function test_every()
end

-- ここまで

local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
