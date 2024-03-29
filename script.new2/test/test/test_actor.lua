package.loaded["emo.dic.actor"] = nil
local actor = require "emo.dic.actor"

actor.register("えも")
    :set_wait(50, 300, 400, 500, 200)
    :set_talk_line(100)
    :set_scope_change_line(150)
    :set_emote("通常", 0)
    :set_emote("嬉しい", 1)
    :set_emote("怒り", 2)
    :set_emote("悲しい", 3)
    :set_emote("驚き", 4)
    :set_emote("照れ", 5)
    :set_emote("眠い", 6)
    :set_emote("楽しい", 7)
    :set_emote("不安", 8)
    :set_emote("にやり", 9)
actor.register("紫")
    :set_wait(50, 300, 400, 500, 200)
    :set_talk_line(100)
    :set_scope_change_line(150)
    :set_emote("通常", 10)
    :set_emote("嬉しい", 11)
    :set_emote("怒り", 12)
    :set_emote("悲しい", 13)
    :set_emote("驚き", 14)
    :set_emote("照れ", 15)
    :set_emote("眠い", 16)
    :set_emote("楽しい", 17)
    :set_emote("不安", 18)
    :set_emote("にやり", 19)
return actor
