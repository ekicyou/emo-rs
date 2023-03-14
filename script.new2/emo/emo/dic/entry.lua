-- エントリ管理
local MOD = {}

local ENTRY_META = {}

function ENTRY_META:__pairs()
    local k,v = nil, nil
    return function()
        ::start::
        k,v = next(self, k)
        if k == nil then
            return k,v
        elseif k == 'rate' then
            goto start
        end
        return k,v
    end
end

function ENTRY_META:__len()
    local count = 0
    for k,v in pairs(self) do
        count = count + 1
    end
    return count
end

local function rate1(env) return 1 end

function MOD.create()
    local a = {}
    a.rate = rate1
    setmetatable(a, ENTRY_META)
    return a
end

return MOD