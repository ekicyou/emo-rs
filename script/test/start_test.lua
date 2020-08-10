require "test.utils.save_load"
require "test.shiori.response"
require "test.shiori.event"
require "test.shiori.utils"
require "test.shiori.load"
require "test.shiori.insert_wait"


-- とりあえずすぐ試したいテストはここに書く。


function test_talk_seq_1()
    local t = require "test.luaunit"
    local o = require "talks.o"

    local items = {"1","2","3"}
    local co = o.SEQ(items)
    local args = {
        data= {},
        req = {},
    }
    t.assertEquals(co(args), "1")
    t.assertEquals(co(args), "2")
    t.assertEquals(co(args), "3")
    t.assertEquals(co(args), nil)
end

function test_talk_inf()
    local t = require "test.luaunit"
    local o = require "talks.o"

    local items = {"1","2","3"}
    local co = o.INFINITY(items)
    local args = {
        data= {},
        req = {},
    }
    t.assertEquals(co(args), "1")
    t.assertEquals(co(args), "2")
    t.assertEquals(co(args), "3")
    t.assertEquals(co(args), "1")
end


function test_cts()
    local t = require "test.luaunit"
    local ser = require "libs.serpent"
    local cts = require "shiori.cts"

    local function drop_action()
        print("drop: func_a")
    end
    local function func_a(ct)
        ct:reg(drop_action)
        ct:reg(function()
            print("drop: anonymous")
        end)
    end

    local ok, rc = cts.using(func_a)

    local ok, rc = cts.using(function(ct)
        print("exec: using1")
        ct:reg(function()
            print("drop: using1")
        end)
        print("exec: using2")
        ct:reg(function()
            print("drop: using2")
        end)
    end)

end


-- ここまで

local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
