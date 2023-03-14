-- トーク→スクリプト変換（wait差し込み）
local MOD = {}

--- @class TalkBuilder
local METHOD = {}
local META = {}
META.__index = METHOD


local function utable(table, no, s)
    for p, c in utf8.codes(s) do
        table[c] = no
    end
end

local WAIT1 = 1
local WAIT2 = 2
local WAIT3 = 3
local WAIT4 = 4
local SKIP = 5
local match_wait_table = {}

utable(match_wait_table, WAIT1, [=[。．｡.]=])
utable(match_wait_table, WAIT2, [=[？！?!]=])
utable(match_wait_table, WAIT3, [=[、，）］｝」』､,)]}｣]=])
utable(match_wait_table, WAIT4, [=[・‥…･]=])
utable(match_wait_table, SKIP, "\r\n\t")


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


function　　　 M.insert_wait(text)
    local rc = ""
    local remain = 0
    for p, c in utf8.codes(text) do
        local pre = 0
        local suf = 0
        local wait = match_wait_table[c]
        if wait == nil then
            pre = remain
            remain = 0
        elseif wait == -1 then
            goto CTRL_SKIP
        elseif wait > 0 then
            if remain < wait then
                remain = wait
            end
        elseif wait < 0 then
            pre = remain
            remain = 0
            suf = 0 - wait
        end
        local u = utf8.char(c)
        rc = rc .. WAIT(pre)
        rc = rc .. u
        rc = rc .. WAIT(suf)
        ::CTRL_SKIP::
    end
    rc = rc .. WAIT(remain)
    return rc
end


--- トークビルダーの取得
---@param wait number[]
---@return TalkBuilder
function MOD.create(wait)
    local a = {
        WAIT1= wait[1],
        WAIT2= wait[2],
        WAIT3= wait[3],
        WAIT4= wait[4],
    }
    setmetatable(a, META)
    return a
end

return MOD