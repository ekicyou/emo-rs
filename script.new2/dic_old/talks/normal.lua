local o    = require "talks.o"
local _    = require "talks.word_dic" 
local builder = require "talks.builder"

local えも  = require "talks.util_emo" 
local 紫    = require "talks.util_murasaki" 

local function SEL(array)
    local entry = o.SEL(array)
    if entry then return entry() end
end


local function ラバーダック(args)
    local talk, C, S, T = builder.new()
    local 地名 = _.地名()
    C(1) S("通常")
    C(0) S("びえー") T([[ラバーダックが、]]) T(地名) T([[からおらんようなってもた‥‥。]])
    C(1) S("驚き") T([[ｲｷﾛｰ。]])
    args = coroutine.yield(talk.build())
end

local function 異世界の門(args)
    local talk, C, S, T = builder.new()
    local 地名 = _.地名()
    C(0) S("通常")
    C(1) S("静観") T(地名) T([[に、異世界の門が開いたらしいよ。]])
    C(0) S("不安") T([[また勇者が\n召喚されたんやね‥‥。]])
    args = coroutine.yield(talk.build())

    local talk, C, S, T = builder.new()
    local 勇者      = _.人名()
    C(1) S("通常")
    C(0) S("興奮笑顔") T([[こないだ、]] ..地名.. [[から異世界に召喚された]] ..勇者.. [[が帰ってきたんよ。]])
    C(1) S("通常") T([[どんなだった？]])

    if math.random(2) == 1 then
        local 能力          = _.能力()
        local XXXが出来る   = _.XXXが出来る()
        C(0,100) S("静観") T('"'..能力.. [["に目覚めたって。]])
        C(1,150) S("驚き") T([[‥‥ん？]])
        C(0,100) S("通常") T(XXXが出来る) T([[出来るんや。]])
        えも.評価オチ(talk)
        args = coroutine.yield(talk.build())
    else
        local 体の場所  = _.体の場所()
        local 物        = _.物()
        C(0,100) S("通常") T(体の場所) T([[に]]) T(物) T([[生やしとった。]])
        えも.評価オチ(talk)
        args = coroutine.yield(talk.build())
    end
end

local function XXXらしいで(args)
    local talk, C, S, T = builder.new()
    C(1) S("通常")
    紫.人名って危険なXXXらしいで(talk)
    えも.危険オチ(talk)
    args = coroutine.yield(talk.build())
end

local function 結婚するらしい(args)
    local talk, C, S, T = builder.new()
    C(1) S("通常")
    紫.人名って結婚するらしいで(talk)
    SEL({
        function()
            紫.逝ったか(talk)
            えも.お祝いか逝ったかオチ(talk)
        end,
        function()
            えも.相手はどなた(talk)
            紫.どうも人名らしいで(talk)
            SEL({
                function() えも.危険オチ(talk) end,
                function() えも.離婚オチ(talk) end,
            })
            SEL({
                function() 紫.多分かなり(talk) end,
                function() end,
            })
        end,
    })

    args = coroutine.yield(talk.build())
end


local function ファイナルアンサー(args)
    local talk, C, S, T = builder.new()
    C(0) S("通常")
    C(1) S("通常") T(_.人名()) T([[って\nファイナルアンサー？]])
    SEL({
        function() 
            紫.意味不明オチ(talk) 
        end,
        function() 
            C(0) S("通常","静観") T([[みのは不滅、\nうち、そう思とったわ‥‥。]])
            えも.盛者必衰オチ(talk)
        end,
        function()
            C(0) S("通常","静観","不安","笑顔","苦笑") T([[‥‥ううん、\nうちはオーディエンスからや。]])
            えも.友達多いか煽りオチ(talk)
        end,
        function()
            C(0) S("通常","静観","笑顔","興奮笑顔") T([[ファイナルアンサー！]])
            えも.自信満々オチ(talk)
        end,
        function()
            C(0) S("通常","静観") T([[まずは\nフィフティ・フィフティやろ？]])
            えも.疑問オチ(talk)
        end,
        function()
            C(0) S("通常","静観") T(_.人名()) T([[に、\nテレフォンやね。]])
            えも.頼りなさそうオチ(talk)
        end,
        function()
            C(0) S("通常","静観") T([[ふぁ‥‥、]]) S("不安","苦笑","驚き") T([[\nいや、ちょいまってーな。]])
            えも.待ってるよオチ(talk)
        end,
    })

    args = coroutine.yield(talk.build())
end

local function 珍走団らしい(args)
    local talk, C, S, T = builder.new()
    C(0) S("通常")
    えも.人名って珍走団上がり(talk)
    SEL({
        function()
            紫.奴は伝説(talk)
            えも.伝説返答オチ(talk)
        end,
        function()
            紫.許せない(talk)
            えも.許せない返答オチ(talk)
        end,
    })

    args = coroutine.yield(talk.build())
end

local function オオカミ少女(args)
    local talk, C, S, T = builder.new()
    C(0) S("通常")
    if えも.オオカミ少女(talk) then 紫.ガッ(talk)
    else                            紫.嘘やけどな(talk)
    end
    args = coroutine.yield(talk.build())
end

local function ワンパターン人物(args)
    local talk, C, S, T = builder.new()
    C(1) S("通常")
    紫.人物ってワンパターン(talk)
    SEL({
        function()
            えも.更新さぼってる(talk)
            紫.びっくりオチ(talk)
        end,
        function()
            えも.中の人の情熱が無くなった(talk)
            紫.中の人の情熱返答オチ(talk)
        end,
    })
    args = coroutine.yield(talk.build())
end


local function 大人になっても(args)
    local talk, C, S, T = builder.new()
    C(1) S("通常")
    C(0) S("通常") T("うち、") S("可愛い笑顔","小悪魔笑顔") T([[\n大人になってもええかな。]])
    SEL({
        function()
            C(1) S("通常","静観") T("だめ。")
            C(0) S("強い怒り","怒り","憤り") T("なんでやの！？")
        end,
        function()
            C(1) S("通常","静観","冷笑") T("胸は変わらないって。")
            C(0) S("強い怒り","怒り") T("ほっといて！")
        end,
    })
    args = coroutine.yield(talk.build())
end


local talk_items = {
ラバーダック,
異世界の門,
XXXらしいで,
結婚するらしい,
ファイナルアンサー,
珍走団らしい,
オオカミ少女,
ワンパターン人物,
大人になっても,
}


local co_talk = coroutine.wrap(o.INFINITY(o.RAND(talk_items)))

local function call(data, req)
    local args = {}
    args.data = data
    args.req  = req
    return co_talk(args)
end


local M = {}
M.call = call

return M
