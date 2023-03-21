--- SHIORI RESPONSE
local MOD            = {}

local CRLF           = "\r\n"
local SPLIT          = ": "

local char_set       = "UTF-8"
local sender         = "emo"
local security_level = "local"
local time_ok        = 0

--- 最後にトークを行った時刻
function MOD.time_ok()
    return time_ok
end

--- Charset
function MOD.set_char_set(value)
    char_set = value
end

--- Sender
function MOD.set_sender(value)
    sender = value
end

--- SecurityLevel
function MOD.set_security_level(value)
    security_level = value
end

--- SHIORI RESPONSE BUILD
local function build(code, dic)
    local rc = "SHIORI/3.0 " .. code .. CRLF
    rc = rc .. "Charset" .. SPLIT .. char_set .. CRLF
    rc = rc .. "Sender" .. SPLIT .. sender .. CRLF
    rc = rc .. "SecurityLevel" .. SPLIT .. security_level .. CRLF

    if type(dic) == 'table' then
        for k, v in pairs(dic) do
            rc = rc .. k .. SPLIT .. v .. CRLF
        end
    end

    return rc .. CRLF
end

--- dicがtableで無い場合はtableで初期化して返す。
--- @return table
local function init_dic(dic)
    if type(dic) ~= 'table' then
        dic = {}
    end
    return dic
end

--- [200 OK]         正常に終了し、会話がある
---                  time_ok に最終送信時刻を保存
--- @param value string さくらスクリプト
--- @param dic table 追加の辞書パラメーター
--- @return string response
function MOD.ok(value, dic)
    time_ok = os.time()
    dic = init_dic(dic)
    dic["Value"] = value
    return build("200 OK", dic)
end

--- [204 No Content] 正常に終了したが、返すべきデータがない
function MOD.no_content(dic)
    return build("204 No Content", dic)
end

--- [311 Not Enough] TEACH リクエストを受けたが、情報が足りない
function MOD.not_enough(dic)
    return build("311 Not Enough", dic)
end

--- [312 Advice]     TEACH リクエスト内の最も新しいヘッダが解釈不能
function MOD.advice(dic)
    return build("312 Advice", dic)
end

--- [400 Bad Request]  リクエスト不備
function MOD.bad_request(dic)
    return build("400 Bad Request", dic)
end

--- [500 Internal Server Error]    サーバ内でエラーが発生した
function MOD.err(resion, dic)
    dic = init_dic(dic)
    dic["X-Error-Resion"] = resion
    return build("500 Internal Server Error", dic)
end

--- [204 No Content] ワーニングあり
function MOD.warn(resion, dic)
    dic = init_dic(dic)
    dic["X-Warn-Resion"] = resion
    return MOD.no_content(dic)
end

return MOD
