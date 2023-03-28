---@diagnostic disable: lowercase-global

-- actorの読込
do
    package.loaded["emo.dic.actor"] = nil
    local actor = require "emo.dic.actor"
    actor.register("えも")
        :set_wait(50, 300, 400, 500, 200)
        :set_emote("通常", "\\s[1]")
    actor.register("紫")
        :set_wait(50, 300, 400, 500, 200)
        :set_emote("通常", "default")
end

function test_dic_actor_register()
    local t             = require "test.luaunit"
    local actor         = require "test.test_actor"
    local scene_builder = require "emo.dic.scene"

    local function EN()
        local env         = {}
        local scene       = scene_builder.create(env)
        local えも, 紫 = scene:enter("えも", "紫")
        えも:通常 [[ねぇ、紫ちゃん。今日は何の日かな？]]
        紫:通常 [[今日は木曜日だよ。]]
        えも:楽しい [[何か楽しいことあるよね！]]
        紫 [[そんな予定はないね。]]
        えも:悲しい [[えー‥‥‥]]
        scene:cut()
    end
    local items = {}
    for script in coroutine.wrap(EN) do
        table.insert(items, script)
    end
    t.assertEquals(#items, 1)
    t.assertEquals(items[1],
        [[\1\s[0]\0\s[0]ねぇ、\w6紫ちゃん。\_w[500]今日は何の日かな？\w8\1\s[10]今日は木曜日だよ。\_w[500]\0\n[150]\s[7]何か楽しいことあるよね！\w8\1\n[150]そんな予定はないね。\_w[500]\0\n[150]\s[3]えー‥\w3‥\w3‥\w3\e]])
end
