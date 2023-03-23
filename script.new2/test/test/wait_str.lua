---@diagnostic disable: lowercase-global

function test_char_ss()
    local t = require "test.luaunit"
    local ws = require "emo.dic.wait_str"
    local utf8 = require "emo.libs.luajit-utf8"
    local text = "ABC\\\\\\0\\a\\s1\\![abc]xyz\\_ax\\_a[123]."

    local ext = {
        { "A",  1 },
        { "B",  1 },
        { "C",  1 },
        { "\\", 2 },
        { "\\", 1 },
        { "\\", 2 },
        { "0",  2 },
        { "\\", 2 },
        { "a",  2 },
        { "\\", 2 },
        { "s",  2 },
        { "1",  2 },
        { "\\", 2 },
        { "!",  2 },
        { "[",  2 },
        { "a",  2 },
        { "b",  2 },
        { "c",  2 },
        { "]",  2 },
        { "x",  1 },
        { "y",  1 },
        { "z",  1 },
        { "\\", 2 },
        { "_",  2 },
        { "a",  2 },
        { "x",  1 },
        { "\\", 2 },
        { "_",  2 },
        { "a",  2 },
        { "[",  2 },
        { "1",  2 },
        { "2",  2 },
        { "3",  2 },
        { "]",  2 },
        { ".",  1 }
    }
    local act = {}
    for cp, tp in ws.en_char_ss(text) do
        table.insert(act, { utf8.char(cp), tp })
    end
    t.assertEquals(act, ext)
end

function test_wait_str()
    local t = require "test.luaunit"
    local ws = require "emo.dic.wait_str"
    local utf8 = require "emo.libs.luajit-utf8"
    -- ABC,!?xy,z-.az.bc･･･,def.
    -- 1111131121141141155531114
    local text = "ABC,!?xy,z-.az.bc///\\s[skip],def."
    local wait = {
        050, -- 通常wait
        300, -- 半濁点
        400, -- エクステンション
        500, -- 濁点
        200, -- 点々
    }
    local ext = {
        { "A",  050 },
        { "B",  050 },
        { "C",  050 },
        { ",",  050 },
        { "!",  050 },
        { "?",  450 },
        { "x",  050 },
        { "y",  050 },
        { ",",  350 },
        { "z",  050 },
        { "-",  050 },
        { ".",  550 },
        { "a",  050 },
        { "z",  050 },
        { ".",  550 },
        { "b",  050 },
        { "c",  050 },
        { "/",  200 },
        { "/",  200 },
        { "/",  200 },
        { "\\", 000 },
        { "s",  000 },
        { "[",  000 },
        { "s",  000 },
        { "k",  000 },
        { "i",  000 },
        { "p",  000 },
        { "]",  000 },
        { ",",  350 },
        { "d",  050 },
        { "e",  050 },
        { "f",  050 },
        { ".",  550 },
    }
    local act = {}
    for c, ms in ws.en_char_wait(wait, text) do
        table.insert(act, { utf8.char(c), ms })
    end
    t.assertEquals(act, ext)
end
