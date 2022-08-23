local SCENE = {}
local meta_SCENE = {__index=SCENE}

-- 会話。
function SCENE:talk(actor, script)
end

-- テキストをそのまま出力
function SCENE:raw(script)
end

-- シーン区切り。coroutine.yiled(SCENE)を実行
function SCENE:cut(n)
end

-- グローバルジャンプ。targetに指定したルールで次の関数に制御を移す
function SCENE:jump(target)
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
