-- むらさき側、共通アクション

local o = require "talks.o"
local _ = require "talks.word_dic"
local builder = require "talks.builder"

local 紫 = {}

local function SEL(talk, array)
    local C, S, T = talk.get()
    C(0, 150)
    local entry = o.SEL(array)
    if entry then return entry(S, T) end
end

local 人名って危険なXXXらしいで = {
    function(S, T)
        S("通常")
        T(_.人名())
        T([[って、\n]])
        T([[目に爆弾抱えとるらしいで。]])
    end,
    function(S, T)
        S("通常")
        T(_.人名())
        T([[って、\n]])
        T([[護身用にサバイバルナイフ携帯してるらしいで。]])
    end,
    function(S, T)
        S("通常")
        T(_.人名())
        T([[って、\n]])
        T([[盲牌が完璧らしいで。]])
    end,
    function(S, T)
        S("通常")
        T(_.人名())
        T([[って、\n]])
        T([[必殺仕事人やって。]])
    end,
    function(S, T)
        S("通常")
        T(_.人名())
        T([[のビームやけど、\n]])
        T(_.能力())
        T([[じゃあ防がれへんらしいで。]])
    end,
    function(S, T)
        S("通常")
        T(_.人名())
        T([[につける薬はないらしいで。]])
    end,
    function(S, T)
        S("通常")
        T(_.人名())
        T([[って、\n]])
        T(_.XXXが出来る())
        T([[が出来るらしいで。]])
    end,
}
function 紫.人名って危険なXXXらしいで(talk) return SEL(talk, 人名って危険なXXXらしいで) end

local 人名って結婚するらしいで = {
    function(S, T)
        S("通常", "笑顔")
        T(_.人名())
        T([[って、\n]])
        T([[今度結婚するらしいで。]])
    end,
    function(S, T)
        S("通常", "笑顔")
        T(_.人名())
        T([[に、\n]])
        T([[結婚の噂があるやんか。]])
    end,
}
local どうも人名らしいで = {
    function(S, T)
        S("通常", "不安")
        T([[相手、\n]])
        T(_.人名())
        T([[やって。]])
    end,
    function(S, T)
        S("通常", "不安")
        T([[どうも、\n]])
        T(_.人名())
        T([[らしいで。]])
    end,
    function(S, T)
        S("通常", "不安")
        T([[噂やけど、\n]])
        T(_.人名())
        T([[かもしれん。]])
    end,
}
local 逝ったか = {
    function(S, T)
        S("通常", "不安")
        T([[‥‥あの子も逝ったんや。]])
    end,
    function(S, T)
        S("通常", "不安")
        T([[‥‥短い人生やったな。]])
    end,
}
local 多分かなり = {
    function(S, T)
        S("通常", "笑顔")
        T([[多分。]])
    end,
    function(S, T)
        S("通常", "笑顔")
        T([[かなり。]])
    end,
}
function 紫.人名って結婚するらしいで(talk) return SEL(talk, 人名って結婚するらしいで) end

function 紫.どうも人名らしいで(talk) return SEL(talk, どうも人名らしいで) end

function 紫.逝ったか(talk) return SEL(talk, 逝ったか) end

function 紫.多分かなり(talk) return SEL(talk, 多分かなり) end

local 意味不明オチ = {
    function(S, T)
        S("通常", "笑顔", "不安", "苦笑")
        T([[‥‥えっと？]])
    end,
    function(S, T)
        S("通常")
        T([[‥‥意味不明やけど。]])
    end,
    function(S, T)
        S("通常", "笑顔")
        T([[‥‥ネタふるぅない？]])
    end,
}
function 紫.意味不明オチ(talk) return SEL(talk, 意味不明オチ) end

local 奴は伝説 = {
    function(S, T)
        S("通常", "静観", "不安", "苦笑")
        T([[アイツは伝説やからな‥‥。]])
    end,
    function(S, T)
        S("笑顔", "興奮笑顔")
        T([[せや！\n凄い伝説なんやで！]])
    end,
    function(S, T)
        S("通常", "苦笑")
        T([[‥‥伝説ちゃあ、\n伝説やったな。]])
    end,
}
local 許せない = {
    function(S, T)
        S("強い怒り", "怒り", "憤り")
        T([[許せん奴やわ！]])
    end,
    function(S, T)
        S("通常", "憤り", "静観")
        T([[‥‥うち、\n許せんわ。]])
    end,
    function(S, T)
        S("通常", "笑顔", "静観")
        T([[来世になったら許したる。]])
    end,
}
function 紫.奴は伝説(talk) return SEL(talk, 奴は伝説) end

function 紫.許せない(talk) return SEL(talk, 許せない) end

local 嘘やけどな = {
    function(S, T)
        S("通常", "笑顔", "静観")
        T([[ウソやけどな。]])
    end,
    function(S, T)
        S("通常", "憤り", "静観")
        T([[‥‥え、\nせやった？]])
    end,
    function(S, T)
        S("強い怒り", "怒り", "憤り")
        T([[こら！\nオオカミ少女になるで！]])
    end,
}
local ガッ = {
    function(S, T)
        S("強い怒り", "怒り")
        T([[ガッ！！]])
    end,
}
function 紫.嘘やけどな(talk) return SEL(talk, 嘘やけどな) end

function 紫.ガッ(talk) return SEL(talk, ガッ) end

local 人物ってワンパターン = {
    function(S, T)
        S("通常", "静観", "不安", "苦笑")
        T([[最近の]])
        T(_.人名())
        T([[って、\n会話がワンパターンらしいで。]])
    end,
    function(S, T)
        S("通常", "静観", "不安", "苦笑")
        T(_.人名())
        T([[やけど、\n最近ワンパターンやない？]])
    end,
    function(S, T)
        S("通常", "静観", "不安", "苦笑")
        T(_.人名())
        T([[が、\nおんなじことばっかりいうらしいんや。]])
    end,
}
local びっくりオチ = {
    function(S, T)
        S("驚き", "怒り", "憤り")
        T([[なんやて！？]])
    end,
    function(S, T)
        S("驚き", "憤り", "そんなあ")
        T([[そんなぁ～！]])
    end,
    function(S, T)
        S("驚き")
        T([[‥‥えっ！？]])
    end,
    意味不明オチ,
}
local 中の人の情熱返答オチ = {
    function(S, T)
        S("強い怒り", "怒り", "憤り")
        T([[まだや！\n燃え尽きるには早いで！]])
    end,
    function(S, T)
        S("強い怒り", "怒り", "憤り")
        T([[中の人なんておらへん！]])
    end,
    function(S, T)
        S("通常", "不安", "落胆", "憤り", "静観", "期待外れ")
        T([[作家に情熱が消えたらおしまいなんや‥‥]])
    end,
    許せない,
    意味不明オチ,
}
function 紫.人物ってワンパターン(talk) return SEL(talk, 人物ってワンパターン) end

function 紫.びっくりオチ(talk) return SEL(talk, びっくりオチ) end

function 紫.中の人の情熱返答オチ(talk) return SEL(talk, 中の人の情熱返答オチ) end

--エイリアス
-- |0:腕   |1:紅   |2:口     |3:眉     |4:目     |
-- |=======|=======|=========|=========|=========|
-- |A:伸び |0:無し |1:笑顔１ |1:通常   |1:べそ   |
-- |B:組み |1:差し |2:笑顔２ |2:オコ   |2:ジトー |
--                 |3:口開   |3:悲しみ |3:通常   |
--                 |4:うや？ |4:シュン |4:笑顔   |
--                 |5:うう‥ |         |5:静観   |
--                 |6:む？   |
--                 |7:‥‥   |
--                 |8:にこっ |
--                 |9:小口   |
--                 |A:中口   |
--                 |B:うぇ～ |
--                 |C:ハァ～ |


--|ID    |0:腕   |1:紅   |2:口     |3:眉     |4:目  |
--|B1124 |B:伸び |1:差し |1:笑顔１ |2:オコ   |4笑顔 | 興奮笑顔









return 紫
