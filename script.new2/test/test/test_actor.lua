package.loaded["emo.dic.actor"] = nil
local actor = require "emo.dic.actor"

actor.register("えも")
    :wait(50, 300, 400, 500, 200)
    :emote("通常", "\\s[1]")
actor.register("紫")
    :wait(50, 300, 400, 500, 200)
    :emote("通常", "default")

return actor
