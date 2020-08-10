local M = {}

local function utable(table, no, s)
    for p, c in utf8.codes(s) do
        table[c] = no
    end
end

local match_wait_table = {}
utable(match_wait_table, 800, [=[。．]=])
utable(match_wait_table, 600, [=[？！]=])
utable(match_wait_table, 400, [=[、，）］｝」』]=])
utable(match_wait_table, -200, [=[・‥…]=])

utable(match_wait_table, 800, [=[｡]=])
utable(match_wait_table, 400, [=[､｣]=])
utable(match_wait_table, -200, [=[･]=])


local function WAIT(ms)
    if ms > 0 then
        local rc = [=[\_w[]=] .. ms .. [=[]]=]
        return rc
    end
    return ""
end

function M.insert_wait(text)
    local rc = ""
    local remain = 0
    for p, c in utf8.codes(text) do
        local pre = 0
        local suf = 0
        local u = utf8.char(c)
        local wait = match_wait_table[c]
        if wait == nil then
            pre = remain
            remain = 0
        elseif wait > 0 then
            if remain < wait then
                remain = wait
            end
        elseif wait < 0 then
            pre = remain
            remain = 0
            suf = 0 - wait
        end
        rc = rc .. WAIT(pre)
        rc = rc .. u
        rc = rc .. WAIT(suf)
    end
    rc = rc .. WAIT(remain)
    return rc
end


return M