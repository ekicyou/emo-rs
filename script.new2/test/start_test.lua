---@diagnostic disable: lowercase-global

require "test.hello"

-- とりあえずすぐ試したいテストはここに書く。


function test_dic_entry()
    local t = require "test.luaunit"
    local entry = require "emo.dic.entry"

    local a = entry.create()
    t.assertEquals(a.rate(), 1)
    a.talk1 = function(env)
    end
    a.talk2 = function(env)
    end
    t.assertEquals(#a, 2)
end

function test_scene()
    local dic = require "emo.dic"
    local actor = require "emo.dic.actor"
    local env = {}
    local wait = {
        050, -- 通常wait
        300, -- 半濁点
        400, -- エクステンション
        500, -- 濁点
        200, -- 点々
    }
    actor.register("えも", wait, {}, "通常")
    actor.register("紫", wait, {}, "通常")
    local scene = dic.create_scene(env)
    local a, b = scene:actor("えも", "紫")
end

function test_wait_str()
    local t = require "test.luaunit"
    local ws = require "emo.dic.wait_str"

    -- 今日はいい天気、！？です、ね～。あと‥‥、明日はどうかな。
    --  1 1 1 1 1 1 1 1 1 3 1 1 2 1 1 4 1 1 5 5 2 1 1 1 1 1 1 1 4
    local text = "今日はいい天気、！？です、ね～。あと‥‥、明日はどうかな。"
    local wait = {
        050, -- 通常wait
        300, -- 半濁点
        400, -- エクステンション
        500, -- 濁点
        200, -- 点々
    }
    local a = {}
    for c, ms in ws.en_char_wait(wait, text) do
        table.insert(a, { utf8.char(c), ms })
    end
    t.assertEquals(a[1], { "今", 050 })
    t.assertEquals(a[2], { "日", 050 })
    t.assertEquals(a[3], { "は", 050 })
    t.assertEquals(a[4], { "い", 050 })
    t.assertEquals(a[5], { "い", 050 })
    t.assertEquals(a[6], { "天", 050 })
    t.assertEquals(a[7], { "気", 050 })
    t.assertEquals(a[8], { "、", 300 })
end

function test_co_wrap_for()
    local t = require "test.luaunit"
    local function CO()
        coroutine.yield(1, 2)
        coroutine.yield(3, 4)
    end
    local sum = 0
    for a, b in coroutine.wrap(CO) do
        sum = sum + a + b
    end
    t.assertEquals(sum, 10)
end

-- ここまで
local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
