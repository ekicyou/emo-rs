local CT={}

function CT:register(fn)
    local items=self.cts.items
    items[#items+1]=fn
end




local CTS={}

local meta_CT = {__index=CT}
function CTS:token()
    local ct={cts=self}
    setmetatable(cts, meta_CT)
    return cts
end
local function run_drop(i,t)

end

function CTS:drop()


end



local M={}

local meta_CTS = {__index=CTS}
local function M.create()
    local cts={
        items={},
    }
    setmetatable(cts, meta_CTS)
    return cts
end

return M
