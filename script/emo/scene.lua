local SCENE = {}
local meta_SCENE = {__index=SCENE}

-- 会話。
function SCENE:talk(actor, script)
end

-- シーン区切り。
function SCENE:cut(n)
end



-- シーンを開始します。
local function open(...)
    -- scene オブジェクト
    local scene = {
        -- actor一覧
        actors = {...}
    }
    setmetatable(scene, meta_SCENE)
    return scene
end

-- scene モジュール
local MOD = {
    open=open,
}

return MOD
