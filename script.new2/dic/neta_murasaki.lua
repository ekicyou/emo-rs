--- 紫のネタ
local MOD = {}

local util = require "emo.dic.util"
local _ = require "dic.word_dic"

local SEL = util.select_talk_builder

MOD.人名って危険なXXXらしいで = SEL({
    function(scene, 紫) 紫:通常 [[%sって、\n目に爆弾抱えとるらしいで。]]:format(_.人名()) end,
    function(scene, 紫)
        紫:通常 [[%sって、\n護身用にサバイバルナイフ携帯してるらしいで。]]:format(
            _.人名())
    end,
})
