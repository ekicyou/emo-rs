-- とりあえずすぐ試したいテストはここに書く。
function test_hello()
    local t = require "test.luaunit"
    print "hello"
end


-- ここまで
local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
