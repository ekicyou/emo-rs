local response  = require "shiori.response"
local utils     = require "shiori.utils"

local function check_impl(data, req)
    if req.status_dic.talking == true then return false
    end
    local talk = get_tree_entry(data ,"env" ,"talk")
    -- トーク終了
    local end_talk_time = talk.end_talk_time
    if end_talk_time == nil then
        talk.end_talk_time = os.time()
        return false
    end
    -- 会話終了後の無音秒数
    if talk.sleep_sec == nil then
        talk.sleep_sec = 3
        return false
    end
    local now = os.time()
    local sleep_sec = os.difftime(now, end_talk_time)
    if sleep_sec < talk.sleep_sec then return false
    end
    -- 10分間に会話する回数
    if talk.freq_10min == nil then
        talk.freq_10min = 10*3
        return false
    end
    local




    return false
end
local function check(data, req)
    local ok, rc = pcall(check_impl, data, req)
    if ok and rc then
        start(data)
        return true
    else
        return false
    end
end

-- 会話開始、会話間隔に関する情報の記録
local function start(data)
    local talk = get_tree_entry(data ,"env" ,"talk")
    talk.start_talk_time = os.time()
    talk.end_talk_time = nil


end

-- 会話間隔に関する情報のリセット
local function reset(data)
    local talk = get_tree_entry(data ,"env" ,"talk")
    -- 会話の時間間隔を測定
    talk.start_talk_time = os.time()
    talk.end_talk_time = nil


end



return function(EV)
-- 秒の更新
function EV:OnSecondChange(data, req)
    local rc = check(data, req)
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
