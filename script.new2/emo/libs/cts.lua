local CT={}

-- CTS解放時に呼び出される関数を登録します。
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

-- CTSを解放します。
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

local MOD={}

local meta_CTS = {__index=CTS}
function MOD.create()
    local cts={
        items={},
    }
    setmetatable(cts, meta_CTS)
    return cts
end

-- スコープから外れたときにキャンセルされる関数を実行します。
-- 呼び出される関数の第一引数にはキャンセルトークンを渡します。
function MOD.pcall(fn, ...)
    local cts = MOD.create()
    return cts:pcall(fn, ...)
end

MOD.using = MOD.pcall

return MOD
