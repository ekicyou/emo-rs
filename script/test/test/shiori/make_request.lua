local response  = require "shiori.response"
local env  =response.env
local CRLF =env.CRLF
local SPLIT=env.SPLIT
local SPLIT=env.SPLIT
local M={}

function make(method, id, reference)
    local req = {}
    req.version         = 30
    req.method          = method
    req.id              = id
    req.charset         = env.char_set
    req.security_level  = env.security_level
    req.sender          = env.sender
    req.reference       = reference
    return req
end

function M.get(id, reference)
    return make("get", id, reference)
end

function M.notify(id, reference)
    return make("notify", id, reference)
end

return M