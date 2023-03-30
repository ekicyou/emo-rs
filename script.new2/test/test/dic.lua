---@diagnostic disable: lowercase-global

function test_dic_actor_register()
    require "test.test_actor"
    local scene_builder = require "emo.dic.scene"
    local t = require "test.luaunit"

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

function test_dic_util_random_selector()
    require "test.test_actor"
    local util = require "emo.dic.util"
    local t = require "test.luaunit"

    local function a(scene) return 'a' end
    local function b(scene) return 'b' end

    local sel = util.select_talk_builder(a, b)
    local scene = {}

    util.random = function() return 1 end
    t.assertEquals(sel(scene), 'a')
    util.random = function() return 2 end
    t.assertEquals(sel(scene), 'b')
end

function test_dic_util_gen_shuffle_builder()
    require "test.test_actor"
    local util = require "emo.dic.util"
    local t = require "test.luaunit"

    local a = 1
    local b = 2
    local c = 3
    util.random = function(x, y) return y end
    local gen = util.gen_shuffle_builder(a, b, c)
    t.assertEquals(gen(), 1)
    t.assertEquals(gen(), 2)
    t.assertEquals(gen(), 3)
    t.assertEquals(gen(), 1)
    t.assertEquals(gen(), 2)
    t.assertEquals(gen(), 3)
end
