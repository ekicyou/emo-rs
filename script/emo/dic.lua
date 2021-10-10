local DIC = {}
local meta_DIC = {__index=DIC}













-- DIC オブジェクトの作成
local function create()
    local obj = {}
    setmetatable(obj, meta_DIC)
    return obj
end

-- ＠：emo.dic モジュール
local MOD = create()

return MOD