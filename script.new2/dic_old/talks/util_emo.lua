-- えも側、共通アクション

local o = require "talks.o"
local _ = require "talks.word_dic" 
local builder = require "talks.builder"

local えも={}

local function SEL(talk, array)
    local C, S, T = talk.get()
    C(1, 150)
    local entry = o.SEL(array)
    if entry then return entry(S,T) end
end



local 評価オチ = {
    function(S,T) S("驚き") T([[なにそれ？]])      end,
    function(S,T) S("驚き") T([[うわあ‥‥？]])    end,
    function(S,T) S("笑顔") T([[すごーい！]])      end,
}
local 危険オチ = {
    function(S,T) S("不安") T([[危険だ‥‥。]])    end,
    function(S,T) S("驚き") T([[やばいじゃん！]])  end,
    function(S,T) S("笑顔") T([[やばーい！]])      end,
}
local 逞しいオチ = {
    function(S,T) S("驚き" ) T([[頑張って生きてるんだ‥‥。]]) end,
    function(S,T) S("ジト") T([[そんなのでいいの？]])         end,
    function(S,T) S("笑顔" ) T([[たくましーい！]])             end,
}
function えも.評価オチ(talk) return SEL(talk, 評価オチ) end
function えも.危険オチ(talk) return SEL(talk, 危険オチ) end
function えも.逞しいオチ(talk) return SEL(talk, 逞しいオチ) end



local 相手はどなた = {
    function(S,T) S("通常","静観") T([[‥‥、\nそれで、相手は？]]) end,
    function(S,T) S("驚き") T([[そんな相手いるの！？]]) end,
    function(S,T) S("通常","不安","ジト") T([[ちょっと、\n想像つかないんだけど。]]) end,
}
local お祝いか逝ったかオチ = {
    function(S,T) S("落胆") T([[祝福してあげて。]]) end,
    function(S,T) S("冷笑") T([[逝ったね。]]) end,
    function(S,T) S("笑顔" ) T([[ばくはつしろー！]]) end,
}
local 離婚オチ = {
    function(S,T) S("不安","冷笑") T([[羽田離婚じゃない？]]) end,
    function(S,T) S("ジト") T([[うまくいきそうにないけど。]]) end,
    function(S,T) S("笑顔" ) T([[なりたりこーん！]]) end,
}
function えも.相手はどなた(talk) return SEL(talk, 相手はどなた) end
function えも.お祝いか逝ったかオチ(talk) return SEL(talk, お祝いか逝ったかオチ) end
function えも.離婚オチ(talk) return SEL(talk, 離婚オチ) end



local 友達多いか煽りオチ = {
    function(S,T) S("通常","笑顔","驚き") T([[友達多いんだね。]]) end,
    function(S,T) S("冷笑") T([[そんなのでいいの？]]) end,
    function(S,T) S("笑顔" ) T([[フレンズいっぱーい！]]) end,
}
local 自信満々オチ = {
    function(S,T) S("通常","笑顔","驚き" ) T([[自信満々だね。]]) end,
    function(S,T) S("冷笑") T([[いっちゃうよ？]]) end,
    function(S,T) S("笑顔" ) T([[れっつごー！]]) end,
}
local 疑問オチ = {
    function(S,T) S("通常") T([[そうなの？]]) end,
    function(S,T) S("冷笑") T([[それでいいの？]]) end,
    function(S,T) S("笑顔" ) T([[まよっちゃうぞー！]]) end,
}
local 頼りなさそうオチ = {
    function(S,T) S("通常","冷笑") T([[頼りなさそうだなー。]]) end,
    function(S,T) S("冷笑") T([[ほかにした方が良いんじゃない？]]) end,
    function(S,T) S("笑顔" ) T([[たよれそーう！]]) end,
}
local 待ってるよオチ = {
    function(S,T) S("通常","笑顔","冷笑") T([[幾らでも待つよー？]]) end,
    function(S,T) S("通常","笑顔","静観","冷笑") T([[どうぞどうぞ。]]) end,
    function(S,T) S("笑顔" ) T([[君はよく考えるフレンズなんだね！]]) end,
}
local 盛者必衰オチ = {
    function(S,T) S("通常","静観") T([[盛者必衰だね‥‥。]]) end,
    function(S,T) S("静観") T([[祇園精舎の鐘の音‥‥。]]) end,
    function(S,T) S("笑顔") T([[いきてればいいことあるよ！]]) end,
}
function えも.友達多いか煽りオチ(talk) return SEL(talk, 友達多いか煽りオチ) end
function えも.自信満々オチ(talk) return SEL(talk, 自信満々オチ) end
function えも.疑問オチ(talk) return SEL(talk, 疑問オチ) end
function えも.頼りなさそうオチ(talk) return SEL(talk, 頼りなさそうオチ) end
function えも.待ってるよオチ(talk) return SEL(talk, 待ってるよオチ) end
function えも.盛者必衰オチ(talk) return SEL(talk, 盛者必衰オチ) end



local 人名って珍走団上がり = {
    function(S,T) S("通常","静観","不安","冷笑") T(_.人名()) T([[って、\n]]) T([[珍走団あがりらしいよ。]]) end,
    function(S,T) S("通常","静観","不安","冷笑") T(_.人名()) T([[が、珍走団所属だったって。]]) end,
    function(S,T) S("笑顔") T(_.人名()) T([[って、\n]]) T([[珍走団のフレンズだって！]])    end,
}
local 伝説返答オチ = {
    function(S,T) S(nil, "通常","静観","不安","冷笑") T([[‥‥伝説？]]) end,
    function(S,T) S(nil, "通常","静観","不安","冷笑") T([[普通じゃないと思ってたよ。]]) end,
    評価オチ,
    危険オチ,
}
local 許せない返答オチ = {
    function(S,T) S("通常","静観","不安","冷笑") T([[許してやってよ。]]) end,
    function(S,T) S("通常","怒り") T([[ほんとだよね。]]) end,
    function(S,T) S("笑顔") T([[色んなフレンズがいるんだね！]]) end,
}
function えも.人名って珍走団上がり(talk) return SEL(talk, 人名って珍走団上がり) end
function えも.伝説返答オチ(talk) return SEL(talk, 伝説返答オチ) end
function えも.許せない返答オチ(talk) return SEL(talk, 許せない返答オチ) end



local オオカミ少女 = {
    function(S,T) S("驚き","照れ怒り") T([[アプリケーションエラーだ！]]) end,
    function(S,T) S("驚き","照れ怒り") T([[ゼロ割発生！]]) end,
    function(S,T) S("驚き","照れ怒り") T([[ヌルぽ！]]) return true end,
    function(S,T) S("通常","静観") T([[不正な処理です。]]) end,
    function(S,T) S("笑顔") T([[メモリが足りないから電源落とすね！]]) end,
}
function えも.オオカミ少女(talk) return SEL(talk, オオカミ少女) end



local 更新さぼってる = {
    function(S,T) S("通常","静観") T([[あ、更新さぼってるみたい。]]) end,
    function(S,T) S("驚き","照れ怒り") T([[サイトが404だったよ！]]) end,
    function(S,T) S("通常","静観") T([[次のオリンピックに更新があるよ。]]) end,
}
local 中の人の情熱が無くなった = {
    function(S,T) S("通常","静観","不安","落胆") T([[中の人の情熱が\n無くなったらしいよ。]]) end,
    function(S,T) S("驚き","不安","落胆","照れ怒り") T([[中の人が\n行方不明だって。]]) end,
    function(S,T) S("通常","静観") T([[旅に出たそうだよ、\n中の人。]]) end,
}
function えも.更新さぼってる(talk) return SEL(talk, 更新さぼってる) end
function えも.中の人の情熱が無くなった(talk) return SEL(talk, 中の人の情熱が無くなった) end


return えも