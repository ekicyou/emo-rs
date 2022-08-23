local CLASS = {}
local meta_CLASS = {__index=CLASS}

-- emo.save 値を保存する
function CLASS:save()
end

-- emo.save 値を読み込む
function CLASS:load()
end

-- emo.save メタオブジェクトの設定
local function set_meta(obj)
    setmetatable(obj, meta_CLASS)
    return obj
end

-- emo.save モジュール
local MOD = set_meta({})
MOD:load()

return MOD