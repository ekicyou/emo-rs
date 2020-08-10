require "test.utils.save_load"
require "test.shiori.response"
require "test.shiori.event"
require "test.shiori.utils"
require "test.shiori.load"


-- とりあえずすぐ試したいテストはここに書く。


local function utable(table, no, s)
    for p, c in utf8.codes(s) do
        table[c] = no
    end
end

local match_wait_table = {}
utable(match_wait_table, 900, [=[。．）］｝」』]=])
utable(match_wait_table, 600, [=[？！]=])
utable(match_wait_table, 400, [=[、，]=])
utable(match_wait_table, -300, [=[・‥…]=])

utable(match_wait_table, 900, [=[｡｣]=])
utable(match_wait_table, 600, [=[?!]=])
utable(match_wait_table, 400, [=[､]=])
utable(match_wait_table, -300, [=[･]=])


local function WAIT(ms)
    if ms > 0 then
        local rc = [=[\_w[]=] .. ms .. [=[]]=]
        return rc
    end
    return ""
end

local function insert_wait(text)
    local rc = ""
    local remain = 0
    for p, c in utf8.codes(text) do
        local pre = 0
        local suf = 0
        local u = utf8.char(c)
        local wait = match_wait_table[c]
        if wait == nil then
            pre = remain
            remain = 0
        elseif wait > 0 then
            if remain < wait then
                remain = wait
            end
        elseif wait < 0 then
            pre = remain
            remain = 0
            suf = 0 - wait
        end
        rc = rc .. WAIT(pre)
        rc = rc .. u
        rc = rc .. WAIT(suf)
    end
    rc = rc .. WAIT(remain)
    return rc
end

function test_utable()
    local t = require "test.luaunit"
    local at = {}
    utable(at, 200, "あいうえおabcde")
    t.assertEquals(at[97], 200)
    t.assertEquals(at[999], nil)
end


function test_match_wait_table()
    local t = require "test.luaunit"
    t.assertEquals(match_wait_table[999], nil)
    t.assertEquals(match_wait_table[12290], 900)
end

function test_insert_wait()
    local t = require "test.luaunit"
    local act = [=[あつい、あつい！‥‥ﾀｽｹﾃ｡]=]
    local exp = [=[あつい、\_w[400]あつい！\_w[600]‥\_w[300]‥\_w[300]ﾀｽｹﾃ｡\_w[900]]=]
    t.assertEquals(insert_wait(act), exp)
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
