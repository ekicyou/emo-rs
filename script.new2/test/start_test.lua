---@diagnostic disable: lowercase-global

require "test"

-- とりあえずすぐ試したいテストはここに書く。

function test_ss_talk()
    local t = require "test.luaunit"
    local ss = require "emo.dic.sakura_script"

    local wait = {
        050, -- 通常wait
        300, -- 半濁点
        432, -- エクステンション
        600, -- 濁点
        150, -- 点々
    }
    local text = [=[今日は、いい天気？だめだね。改行‥‥\n[123]だよ。]=]
    local ext = [=[今日は、\w6いい天気？\_w[432]だめだね。\_w[600]改行‥\w2‥\w2\n[123]だよ。\_w[600]]=]
    local act = ss.talk(wait, text)
    t.assertEquals(act, ext)
end

function test_dic_entry()
    local t = require "test.luaunit"
    local entry = require "emo.dic.entry"

    local a = entry.create()
    t.assertEquals(a.rate(), 1)
    a.talk1 = function(env)
    end
    a.talk2 = function(env)
    end
    t.assertEquals(#a, 0)
end

-- ここまで
local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_DEFAULT)
local rc = t.run()
