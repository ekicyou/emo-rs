--- 紫のネタ
local MOD = {}

local util = require "emo.dic.util"
local _ = require "dic.word_dic"

local SEL = util.select_talk_builder


MOD.人名って危険なXXXらしいで = SEL({
    function(scene, 紫)
        紫:通常([[%sって、\n目に爆弾抱えとるらしいで。]],
            _.人名())
    end,
    function(scene, 紫)
        紫:通常([[%sって、\n護身用にサバイバルナイフ携帯してるらしいで。]],
            _.人名())
    end,
    function(scene, 紫)
        紫:通常([[%sって、\n盲牌が完璧らしいで。]],
            _.人名())
    end,
    function(scene, 紫)
        紫:通常([[%sって、\n必殺仕事人やって。]],
            _.人名())
    end,
    function(scene, 紫)
        紫:通常([[%sって、\n%sが出来るらしいで。]],
            _.人名(),
            _.XXXが出来る()
        )
    end,
    function(scene, 紫)
        紫:通常([[%sにつける薬はないらしいで。]],
            _.人名())
    end,
    function(scene, 紫)
        紫:通常([[%sのビームやけど、\n%sじゃあ防がれへんらしいで。]],
            _.人名(),
            _.能力())
    end,
})

MOD.人名って結婚するらしいで = SEL({
    function(scene, 紫)
        紫:通常・笑顔([[%sって、\n今度結婚するらしいで。]],
            _.人名())
    end,
    function(scene, 紫)
        紫:通常・笑顔([[%sに、\n結婚の噂があるやんか。]],
            _.人名())
    end,
})
