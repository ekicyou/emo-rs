---@diagnostic disable: lowercase-global

-- actorの読込
do
    package.loaded["emo.dic.actor"] = nil
    local actor = require "emo.dic.actor"
    actor.register("えも")
        :wait(50, 300, 400, 500, 200)
        :emote("通常", "\\s[1]")
    actor.register("紫")
        :wait(50, 300, 400, 500, 200)
        :emote("通常", "default")
end

function test_dic_actor_register()
    local t             = require "test.luaunit"
    local pp            = require "libs.pprint"
    local actor         = require "test.test_actor"
    local scene_builder = require "emo.dic.scene"

    local env           = {}
    local scene         = scene_builder.create(env)
    local エモ, 紫   = scene:enter("エモ", "紫")
    pp.pprint(scene)

    --[=[
    エモ:通常 [[ねぇ、紫ちゃん。今日は何の日かな？]]
    紫:通常 [[今日は木曜日だよ。]]
    エモ:楽しい [[何か楽しいことあるよね！]]
    紫 [[そんな予定はないね。]]
    エモ:悲しい [[えー。。。]]
    ]=]
end
