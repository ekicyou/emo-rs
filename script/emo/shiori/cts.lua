local CT={}

function CT:reg(fn)
    local items=self.cts.items
    items[#items+1]=fn
end


local CTS={}

local meta_CT = {__index=CT}
function CTS:token()
    local ct={cts=self}
    setmetatable(ct, meta_CT)
    return ct
end

local function run_drop(fn)
    fn()
end
function CTS:drop()
    local items = self.items
    self.items = nil
    for i = #items, 1, -1 do
        pcall(items[i])
    end
end
function CTS:pcall(fn, ...)
    local ct = self:token()
    local ok, rc = pcall(fn, ct, ...)
    self:drop()
    return ok, rc
end

local M={}

local meta_CTS = {__index=CTS}
function M.create()
    local cts={
        items={},
    }
    setmetatable(cts, meta_CTS)
    return cts
end

function M.pcall(fn, ...)
    local cts = M.create()
    return cts:pcall(fn, ...)
end
M.using = M.pcall

return M
