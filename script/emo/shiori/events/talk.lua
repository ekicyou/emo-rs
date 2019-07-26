local response  = require "shiori.response"
local utils     = require "shiori.utils"

local ENTRY = utils.get_tree_entry

-- 現在時刻で時報会話があるか確認
-- 　時報       :(key, true )
--   時報待機   :(key, false)
--   時報無し   :(nil, nil  )
local function check_news(EV, data, now)
    return utils.unimplemented()
end

-- 時間をチェックして会話の開始タイミングなら検索キーを返す。
-- 開始タイミングでなければnil
local function check_impl(EV, data, req)
    if req.status_dic.talking == true then return nil end
    local save = ENTRY(data ,"save" ,"talk")
    local env  = ENTRY(data ,"env"  ,"talk")
    local now = req.now
    if not env.end_talk_time then env.end_talk_time = now end
    do
        local news, flag = check_news(EV, data, now)
        if news then
            if flag then return news
            else         return nil
            end
        end
    end
    if os.difftime(now, env.end_talk_time) < save.sleep_sec then
        return nil
    end
    if env.next_talk_time and os.difftime(now, env.next_talk_time) < 0 then
        return nil
    end
    return 'normal'
end
local function check(EV, data, req)
    local ok, rc = pcall(check_impl, EV, data, req)
    if ok and rc then
        return rc
    else
        return nil
    end
end

-- 会話開始の記録
local function mark_start(data, now)
    local save = ENTRY(data ,"save" ,"talk")
    local env  = ENTRY(data ,"env"  ,"talk")
    if env.start_talk_time then
        env.count = env.count or 0 + 1
        local due = os.difftime(now, env.start_talk_time)
        env.due = env.due or 0 + due
    end
    env.start_talk_time = now
    env.end_talk_time = nil
    -- 次回会話の時刻決定
    if save.freq_10min == nil then
        save.freq_10min = 10*3
    end
    do
        local span      = 600 / save.freq_10min
        local all_due   = env.due   or span
        local all_count = env.count or 1
        local due       = all_due / all_count
        local adjust    = (span - due) / 3
        if      adjust >  2 then adjust =  2
        elseif  adjust < -2 then adjust = -2
        end
        span = span + adjust
        if span < 5 then span = 5
        end
        env.next_talk_time = now + span
    end
end

-- 会話時刻情報のリセット
local function mark_reset(data)
    local talk = ENTRY(data ,"save" ,"talk")
    -- 会話の時間間隔を測定
    env.start_talk_time = nil
    env.end_talk_time = nil
    env.count = nil
    env.due = nil
    env.next_talk_time = nil
    talk.next_news = nil
end

return function(EV)
-- 秒の更新
function EV:OnSecondChange(data, req)
    local key = check(EV, data, req)
    if key then
        return self['T'..key](self, data, req)
    else
        return self:no_entry(data, req)
    end
end

-- 通常会話
function EV:Tnormal(data, req)
    local value = [=[\1\s[10]\0\s[0]OnOnSecondChange/Tnormal:通常会話です。\e]=]
    return response.talk(req.now, value)
end

-- 全ての会話発生時に発生するイベント
function EV:on_talk_start(data, now, value, dic)
    --mark_start(data, now)
end

-- 10分間に会話する回数を変更
function EV:reset_freq_timer(data)
    mark_reset(data)
end

--


end
