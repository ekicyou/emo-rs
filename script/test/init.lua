require "test.shiori"

local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
os.exit( t.run("-v -output text") )
