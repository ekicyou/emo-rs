-- エントリ管理
local MOD = {}

--- @class Entry
local METHOD = {}
local META = {}
META.__index = METHOD

--- pairs、不要なrate キーを除いて返す
--- @param self Entry
local function pairs(self)
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
METHOD.pairs = pairs
META.__pairs = pairs

-- #、不要なrateを除いたカウントを返す。
function META:__len()
    local count = 0
    for k,v in pairs(self) do
        count = count + 1
    end
    return count
end

local function rate1(env) return 1 end

-- エントリーを作成する。
function MOD.create()
    local a = {}
    a.rate = rate1
    setmetatable(a, META)
    return a
end

return MOD