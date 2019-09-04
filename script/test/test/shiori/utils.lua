-- Statusの分解
function test_shiori_status()
    local t = require "test.luaunit"
    local utils = require "shiori.utils"
    local ser = require "libs.serpent"

    do
        -- act.talking  = true
        -- act.choosing = true
        -- act.balloon._0 = '2'
        -- act.balloon._1 = '0'
        --                                     111111111122222222223333333333
        --                            1234567890123456789012345678901234567890
        --                            @      @       @
        local act = utils.get_status("talking,choosing,balloon(0=2,1=0)")
        t.assertIsTrue(act.talking)
        t.assertIsTrue(act.choosing)
        t.assertIsTrue(act.choosing)
        t.assertEquals(act.balloon['0'], '2')
        t.assertEquals(act.balloon['1'], '0')
    end
end

-- merge(a, b) テーブルaにbを合成する。同じキーの場合はaを優先する。
function test_shiori_status()
    local t = require "test.luaunit"
    local utils = require "shiori.utils"
    local ser = require "libs.serpent"

    do
        local a = {
            a = 1,
            b = 2,
            c={d=14,e="123"},
        }
        local b = {
            a = 2,
            c = {d=16, f="456"},
            f = {d=16, f="456"},
            g = 999,
        }
        local act = utils.merge(a,b)
        t.assertEquals(act.a  , 1)
        t.assertEquals(act.b  , 2)
        t.assertEquals(act.c.d, 14)
        t.assertEquals(act.c.e, "123")
        t.assertEquals(act.c.f, "456")
        t.assertEquals(act.f.d, 16)
        t.assertEquals(act.f.f, "456")
        t.assertEquals(act.g, 999)
    end
end

function test_os_date()
    local t = require "test.luaunit"
    local ser = require "libs.serpent"

    local d = os.date("*t")
    t.assertIsTrue(d.year > 2018)

    local act = (nil or 0) + 1
    t.assertEquals(act, 1)
end

