-- トーク→スクリプト変換（wait差し込み）
local MOD = {}

--- @class TalkBuilder
local METHOD = {}
local META = {}
META.__index = METHOD

local function WAIT(ms)
    if ms > 0 then
        local rc = [=[\_w[]=] .. ms .. [=[]]=]
        return rc
    end
    return ""
end

--- トークテキストに適切なウェイトを挟んでスクリプトを返します。
function METHOD:talk2script(text)
end

--- トークビルダーの取得
---@param wait number[]
---@return TalkBuilder
function MOD.create(wait)
    local a = {
        WAIT1 = wait[1],
        WAIT2 = wait[2],
        WAIT3 = wait[3],
        WAIT4 = wait[4],
    }
    setmetatable(a, META)
    return a
end

return MOD
