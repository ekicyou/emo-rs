require "test.utils.save_load"
require "test.shiori.response"
require "test.shiori.event"
require "test.shiori.utils"
require "test.shiori.load"
require "test.shiori.insert_wait"
require "test.talks.o"


-- とりあえずすぐ試したいテストはここに書く。

function test_dkit()
    local t = require "test.luaunit"
    local dkit = require "talks.dkit"
    local csv_data = require "talks.word"
    local db = dkit.create_word_db(csv_data)
    local ser = require "libs.serpent"
    --print(ser.dump(db.cols.dic["関係"], {nocode = true, indent = ' '}))
    t.assertNotIsNil(db.cols.dic["関係"])
    t.assertEquals(db.cols.dic["関係"].row_dic["家庭教師"][2].name, "一花")
    t.assertEquals(#(dkit.filter_names(db, "関係", "家庭教師","特徴","勉強オバケ")), 1)

    local names = dkit.filter_names(db, "カテゴリー", "キャラ")
    t.assertEquals(#names, 95)
    --print(ser.block(names))

    local place = dkit.value_items(db, "生息地")
    t.assertEquals(#place, 25)
    --print(ser.block(place))

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
