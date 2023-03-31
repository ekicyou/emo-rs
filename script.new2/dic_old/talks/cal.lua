local o = require "talks.o"
local _ = require "talks.word_dic" 
local builder = require "talks.builder"

local function 時報共通(hour, talk)
    local cal = string.format("T%02d00", hour)
    return {cal=cal, talk=talk.build()}
end

local function 時報深夜０時(hour)
    local talk, C, S, T = builder.new()
    C(0) S("通常")
    C(1) S("通常") T([[深夜0時になったよ。]])
    C(0) S("不安") T([[新しい日‥‥はええから、寝よ寝よ。]])
    return 時報共通(hour, talk)
end

local function 時報深夜(hour)
    local talk, C, S, T = builder.new()
    C(0) S("静観")
    C(1) S("通常") T([[午前]]..hour..[[時になったよ。]])
    C(0) S("静観") T([[（‥‥ぐぅ）]])
    return 時報共通(hour, talk)
end

local function 時報早朝(hour)
    local talk, C, S, T = builder.new()
    C(0) S("通常")
    C(1) S("通常") T([[午前]]..hour..[[時になったよ。]])
    C(0) S("落胆") T([[うぅ、起こさんといて、二度寝‥‥。]])
    return 時報共通(hour, talk)
end

local function 時報朝(hour)
    local talk, C, S, T = builder.new()
    C(0) S("通常")
    C(1) S("通常") T([[午前]]..hour..[[時になったよ。]])
    C(0) S("笑顔") T([[おはよー！パンを咥えて、\n気になるあの子にぶつかるでー。]])
    return 時報共通(hour, talk)
end

local function 時報午前(hour)
    local talk, C, S, T = builder.new()
    C(0) S("通常")
    C(1) S("通常") T([[午前]]..hour..[[時になったよ。]])
    C(0) S("落胆") T([[うち、まだ眠いわ‥‥。]])
    return 時報共通(hour, talk)
end

local function 時報正午(hour)
    local talk, C, S, T = builder.new()
    C(0) S("通常")
    C(1) S("通常") T([[正午だよ。]])
    C(0) S("笑顔") T([[おっひるはなにかいなー♪]])
    return 時報共通(hour, talk)
end

local function 時報午後(hour)
    local talk, C, S, T = builder.new()
    C(0) S("通常")
    C(1) S("通常") T([[午後]]..(hour-12)..[[時になったよ。]])
    C(0) S("笑顔") T([[午後もがんばろー！]])
    return 時報共通(hour, talk)
end

local function 時報夕方(hour)
    local talk, C, S, T = builder.new()
    C(0) S("通常")
    C(1) S("通常") T([[午後]]..(hour-12)..[[時になったよ。]])
    C(0) S("通常") T([[そろそろ夕方やね。]])
    return 時報共通(hour, talk)
end

local function 時報晩御飯(hour)
    local talk, C, S, T = builder.new()
    C(0) S("通常")
    C(1) S("通常") T([[午後]]..(hour-12)..[[時になったよ。]])
    C(0) S("笑顔") T([[お夕飯はなにかいなー♪]])
    return 時報共通(hour, talk)
end

local function 時報夜(hour)
    local talk, C, S, T = builder.new()
    C(0) S("通常")
    C(1) S("通常") T([[午後]]..(hour-12)..[[時になったよ。]])
    C(0) S("苦笑") T([[夜更かしはほどほどにして、\n寝なあかんよ。]])
    return 時報共通(hour, talk)
end

local talk_items = {
    時報深夜０時(0),
    時報深夜(1),
    時報深夜(2),
    時報深夜(3),
    時報早朝(4),
    時報早朝(5),
    時報朝(6),
    時報朝(7),
    時報朝(8),
    時報午前(9),
    時報午前(10),
    時報午前(11),
    時報正午(12),
    時報午後(13),
    時報午後(14),
    時報午後(15),
    時報午後(16),
    時報夕方(17),
    時報夕方(18),
    時報晩御飯(19),
    時報晩御飯(20),
    時報夜(21),
    時報夜(22),
    時報夜(23),
}

return talk_items