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
