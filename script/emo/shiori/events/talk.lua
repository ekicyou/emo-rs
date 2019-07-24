local response  = require "shiori.response"
local utils     = require "shiori.utils"

local ENTRY = utils.get_tree_entry

local function check_impl(EV, data, req)
    if req.status_dic.talking == true then return false
    end
    -- トーク終了を記録
    local talk = ENTRY(data ,"save" ,"talk")
    local end_talk_time = mark_fin(talk)

    -- 会話終了後の無音秒数
    local now = os.time()
    if os.difftime(now, end_talk_time) < talk.sleep_sec then return false
    end





    return false
end
local function check(EV, data, req)
    local ok, rc = pcall(check_impl, EV, data, req)
    if ok and rc then
        mark_start(data)
        return true
    else
        return false
    end
end

-- 会話終了の記録
local function mark_fin(talk)
    if not talk.end_talk_time then
        talk.end_talk_time = os.time()
    end
    return talk.end_talk_time
end

-- 会話開始の記録
local function mark_start(data)
    local talk = ENTRY(data ,"save" ,"talk")
    local now = os.time()
    if talk.start_talk_time then
        talk.count = talk.count or 0 + 1
        local due = os.difftime(now, talk.start_talk_time)
        talk.due = talk.due or 0 + due
    end
    talk.start_talk_time = now
    talk.end_talk_time = nil
    -- 次回会話の時刻決定
    if talk.freq_10min == nil then
        talk.freq_10min = 10*3
    end
    do
        local span      = 600 / talk.freq_10min
        local all_due   = talk.due   or span
        local all_count = talk.count or 1
        local due       = all_due / all_count
        local adjust    = (span - due) / 3
        if      adjust >  2 then adjust =  2
        elseif  adjust < -2 then adjust = -2
        end
        span = span + adjust
        if span < 5 then span = 5
        end
        talk.next_talk_time = now + span
    end
end

-- 会話時刻情報のリセット
local function mark_reset(data)
    local talk = ENTRY(data ,"save" ,"talk")
    -- 会話の時間間隔を測定
    talk.start_talk_time = nil
    talk.end_talk_time = nil
    talk.count = nil
    talk.due = nil
    talk.next_talk_time = nil
    talk.next_news = nil
end

return function(EV)
-- 秒の更新
function EV:OnSecondChange(data, req)
    local rc = check(EV, data, req)
    if rc then
        self:on_talk_normal(data, req)
    else
        return self:no_entry(data, req)
    end
end
-- 10分間に会話する回数を変更
function EV:reset_freq_timer(data)
    reset(data)
end

--


end
