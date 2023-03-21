---@diagnostic disable: lowercase-global

function test_wait_str()
    local t = require "test.luaunit"
    local ws = require "emo.dic.wait_str"
    local utf8 = require "emo.libs.luajit-utf8"
    -- ABC,!?xy,z-.az.bc･･･,def.
    -- 1111131121141141155531114
    local text = "ABC,!?xy,z-.az.bc///,def."
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
    t.assertEquals(a[01], { "A", 050 })
    t.assertEquals(a[02], { "B", 050 })
    t.assertEquals(a[03], { "C", 050 })
    t.assertEquals(a[04], { ",", 050 })
    t.assertEquals(a[05], { "!", 050 })
    t.assertEquals(a[06], { "?", 450 })
    t.assertEquals(a[07], { "x", 050 })
    t.assertEquals(a[08], { "y", 050 })
    t.assertEquals(a[09], { ",", 350 })
    t.assertEquals(a[10], { "z", 050 })
    t.assertEquals(a[11], { "-", 050 })
    t.assertEquals(a[12], { ".", 550 })
    t.assertEquals(a[13], { "a", 050 })
    t.assertEquals(a[14], { "z", 050 })
    t.assertEquals(a[15], { ".", 550 })
    t.assertEquals(a[16], { "b", 050 })
    t.assertEquals(a[17], { "c", 050 })
    t.assertEquals(a[18], { "/", 200 })
    t.assertEquals(a[19], { "/", 200 })
    t.assertEquals(a[20], { "/", 200 })
    t.assertEquals(a[21], { ",", 350 })
    t.assertEquals(a[22], { "d", 050 })
    t.assertEquals(a[23], { "e", 050 })
    t.assertEquals(a[24], { "f", 050 })
    t.assertEquals(a[25], { ".", 550 })
end
