---@diagnostic disable: lowercase-global
local t = require "test.luaunit"
local pp = require "libs.pprint"

function test_hello()
    local a = {
        hello = 'world',
        pretty = 'print',
    }
    print ("   _VERSION: ".._VERSION)
end
