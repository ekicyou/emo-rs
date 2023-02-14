local MOD = {}

local talk = {}

talk.entry {"会話", function(env)
    local emo, mur = env.actor("えも", "紫")
    local jump = env.jump()

    jump.entry {"天気予報", function(env)
        emo "明日の天気は晴れのようです。"
        mur "にっこり。"
    end}

    jump.entry {"天気予報", function(env)
        emo "明日の天気は雨のようです。"
        mur "ぐんにょり。"
    end}

    emo "今日はいい天気ですね。"
    mur "明日の天気はどうかしら。"
    jump "天気予報"
    talk "明後日の天気"
end}

return MOD

--[[
＠＠＠
＠えも
今日はいい天気ですね。
＠紫
明日の天気はどうかしら。
＞天気予報

＠＠天気予報
＠えも
明日の天気は晴れのようです。
＠紫
にっこり。

＠＠天気予報
＠えも
明日の天気は雨のようです。
＠紫
ぐんにょり。


]]
