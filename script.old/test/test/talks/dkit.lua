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