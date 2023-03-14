---@diagnostic disable: lowercase-global
local t = require "test.luaunit"

require "test.hello"

-- とりあえずすぐ試したいテストはここに書く。


function test_dic_entry()


end

-- ここまで
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
