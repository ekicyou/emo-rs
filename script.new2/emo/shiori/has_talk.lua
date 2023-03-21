local utils  = require "shiori.utils" 

local M = {}

-- 会話中でなければtrue
function M.quick(status_dic)
    return status_dic.talking
end

-- 会話終了後の経過時間を見て
-- 発言可能かどうかを判断する関数
-- 戻り値：
--     0 発動OK
--  数値 残り時間
--    -1 会話中
-- 参照：
--   data.save.talking.wait_sec  : 会話終了後に発言を開ける秒数
--   data.save.talking.time_talk : 最後に会話中だった時刻
--   date.save.talking.time_check: この関数を最後に呼び出した時刻
--   date.save.talking.time_ok   : この関数が最後にtrueを返した時刻
function M.normal(status_dic, data)
    now = os.time()
    local x = utils.get_tree_entry(data, "save", "talking")
    x.time_check = now
    if x.wait_sec == nil then
        x.wait_sec = 30
        x.time_talk = nil
    end
    if x.time_talk == nil then
        x.time_talk = now
    end
    if M.quick(status_dic) then
        x.time_talk = now
        return -1
    end
    local remain_sec = -(now - x.time_talk - x.wait_sec)
    if remain_sec <= 0 then
        x.time_ok=now
        return 0
    end
    return remain_sec
end

-- おさわり反応の発動タイミングならtrueを返す関数
--   [data.save.touch]
--      limit_sec  : 我慢の限界秒数
--      time_start : 触り始めた時刻
--      time_event : 最後のイベント時刻
--      time_ok    : この関数が最後にtrueを返した時刻
--      ref3       : 前回のref3値
--      ref4       : 前回のref4値
--      last_flag  : 前回のis_touch

function M.touch(data, req)
    local x = utils.get_tree_entry(data, "save", "touch")
    local now           = os.time()
    local status_dic    = req.status_dic
    local ref           = req.reference
    local is_touch      = true
    --- 会話中はタッチ状態としない
    is_touch = is_touch and (not status_dic.talking)

    --- 対象が変わった場合はタッチ状態としない
    is_touch = is_touch and x.ref3 == ref[3]
    is_touch = is_touch and x.ref4 == ref[4]
    x.ref3 = ref[3]
    x.ref4 = ref[4]

    --- 最後のイベントから２秒経過したならタッチ状態としない
    is_touch = is_touch and x.time_event+2 > now
    x.time_event = now

    --- タッチ状態ではないときの処理
    if not is_touch then
        x.time_start    = now
        x.last_flag     = false
        return false
    end

    --- 時間経過を確認
    if not x.limit_sec then
        x.limit_sec = 3
    end
    if x.time_start+x.limit_sec > now then
        return false
    end

    --- タッチがOFF→ONになったときだけtrue
    local last_flag = x.last_flag
    x.last_flag = is_touch
    return last_flag ~= is_touch
end

return M