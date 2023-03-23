---@diagnostic disable: lowercase-global

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
