local MOD = {}

local talk = {}

talk.entry {
    "会話", function(env)
        local えも, 紫 = env.actor("えも", "紫")
        local jump = env.jump()

        jump.entry { "天気予報", function(env)
            えも "明日の天気は晴れのようです。"
            紫 "にっこり。"
        end }

        jump.entry { "天気予報", function(env)
            えも "明日の天気は雨のようです。"
            紫 "ぐんにょり。"
        end }

        えも "今日はいい天気ですね。"
        紫 "明日の天気はどうかしら。"
        jump "天気予報"
        talk "明後日の天気"
    end,
}

return MOD
