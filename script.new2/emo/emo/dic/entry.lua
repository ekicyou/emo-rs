-- エントリ管理
local MOD = {}

local ENTRY_META = {}



function MOD.create()
    local a = {}
    a.rate = 1
    setmetatable(a, ENTRY_META)
    return a
end

return MOD