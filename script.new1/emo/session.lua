local CLASS = {}
local meta_CLASS = {__index=CLASS}

-- 対象。
function CLASS:actor(...)
end

-- 会話。
function CLASS:talk(script)
end

-- テキストをそのまま出力
function CLASS:raw(script)
end

-- シーン区切りを入れる。１回の会話を終了して次のタイミングまで待機する。
function CLASS:yield()
    local script = "スクリプト"
    self.yield_count = self.yield_count+1
    coroutine.yield(script)
    return script
end


-- 新しいオブジェクトを作成します。
local function new(...)
    -- scene オブジェクト
    local instance = {
        -- actor一覧
        actors = {...},
        -- シーン区切りの回数
        yield_count = 0,
    }
    setmetatable(instance, meta_CLASS)
    return instance
end

-- scene モジュール
local MOD = {
    new=new,
}

return MOD
