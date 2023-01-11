local MOD = {talk={}}

local talk = MOD.talk

talk.t001 = function(t)
    local a, b = t.actor("えも", "紫")
    t.start = function()
        a "今日の天気は？"
        t.jump "l1"
    end
    t.l1 = {
        function()
            b "晴れだよ。"
            a "にっこり。"
        end,
        function()
            b "雨だよ。"
            a "がっかり。"
        end,
    }
    t.next = "talk"
end


