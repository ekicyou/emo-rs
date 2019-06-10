--[[
SHIORI RESPONSE
    SHIORI/3.0 200 OK[CRLF]
    Charset: Shift_JIS[CRLF]
    Sender: サンプル[CRLF]
    SecurityLevel: local[CRLF]
    Value: \0\s[0]おはこんばんちは。[CRLF]
    [CRLF]
]]


local CRLF = "\r\n"
local SPLIT = ": "
local env ={
    char_set=       "UTF-8",
    sender=         "emo",
    security_level= "local",
}

local function set_char_set(value)
    env.char_set = value
end

local function set_sender(value)
    env.sender = value
end

local function set_security_level(value)
    env.security_level = value
end

--SHIORI RESPONSE BUILD
local function build(code, dic)
    local rc = "SHIORI/3.0 " .. code .. CRLF
    rc = rc .. "Charset"        .. SPLIT .. env.char_set        .. CRLF
    rc = rc .. "Sender"         .. SPLIT .. env.sender          .. CRLF
    rc = rc .. "SecurityLevel"  .. SPLIT .. env.security_level  .. CRLF
    for k, v in pairs(dic) do
        rc = rc .. k .. SPLIT .. v .. CRLF
    end
    return rc
end

-- 200 OK           正常に終了した
-- 204 No Content   正常に終了したが、返すべきデータがない
-- 311 Not Enough   TEACH リクエストを受けたが、情報が足りない
-- 312 Advice       TEACH リクエスト内の最も新しいヘッダが解釈不能
-- 400 Bad Request  リクエスト不備
local function bad_request(resion, dic)
    return build(" 400 Bad Request", dic)
end


-- 500 Internal Server Error    サーバ内でエラーが発生した
local function err(resion)
    local dic = []
    dic["X-Error-Resion"] = resion
    return build("500 Internal Server Error", dic)
end


--エントリーポイント
response = {
    env=        env,
    char_set=   char_set,
    build=      build,
    err=        err,
}

return shiori