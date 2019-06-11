--[[
SHIORI RESPONSE
    SHIORI/3.0 200 OK[CRLF]
    Charset: Shift_JIS[CRLF]
    Sender: サンプル[CRLF]
    SecurityLevel: local[CRLF]
    Value: \0\s[0]おはこんばんちは。[CRLF]
    [CRLF]
]]

local pub ={}
local CRLF = "\r\n"
local SPLIT = ": "
local env ={
    char_set=       "UTF-8",
    sender=         "emo",
    security_level= "local",
}
pub.env = env

--Charset
pub.set_char_set=function(value)
    env.char_set = value
end

--Sender
pub.set_sender=function(value)
    env.sender = value
end

--SecurityLevel
pub.set_security_level=function(value)
    env.security_level = value
end

--SHIORI RESPONSE BUILD
pub.build=function(code, dic)
    local rc = "SHIORI/3.0 " .. code .. CRLF
    rc = rc .. "Charset"        .. SPLIT .. env.char_set        .. CRLF
    rc = rc .. "Sender"         .. SPLIT .. env.sender          .. CRLF
    rc = rc .. "SecurityLevel"  .. SPLIT .. env.security_level  .. CRLF
    for k, v in pairs(dic) do
        rc = rc .. k .. SPLIT .. v .. CRLF
    end
    return rc
end

-- 200 OK           正常に終了し、会話がある
pub.ok=function(value, dic)
    if !dic then dic={}
    end
    dic["Value"] = value
    return build("200 OK", dic)
end

-- 204 No Content   正常に終了したが、返すべきデータがない
pub.no_content=function(dic)
    return build("204 No Content", dic)
end

-- 311 Not Enough   TEACH リクエストを受けたが、情報が足りない
pub.not_enough=function(dic)
    return build("311 Not Enough", dic)
end

-- 312 Advice       TEACH リクエスト内の最も新しいヘッダが解釈不能
pub.advice=function(dic)
    return build("312 Advice", dic)
end

-- 400 Bad Request  リクエスト不備
pub.bad_request=function(dic)
    return build("400 Bad Request", dic)
end

-- 500 Internal Server Error    サーバ内でエラーが発生した
pub.err=function(resion ,dic)
    if !dic then dic={}
    end
    dic["X-Error-Resion"] = resion
    return build("500 Internal Server Error", dic)
end


return pub