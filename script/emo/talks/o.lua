local shuffle  = require "libs.shuffle"

local function table_copy(t)
    local t2 = {}
    for k,v in pairs(t) do
        t2[k] = v
    end
    return t2
end


-- SEQ実行
local function SEQ(talk)
    local function task(args)
        local talk_type = type(talk)
        -- 文字列：そのまま1回返す
        if talk_type == "string" then
            args = coroutine.yield(talk)
            return
        -- 関数：コルーチンとみなしてループを回す
        elseif talk_type == "function" then
            local co = coroutine.wrap(talk)
            while true do
                value = co(args)
                if value == nil then
                    break
                end
                args = coroutine.yield(value)
            end
        -- テーブル：配列とみなして1つずつSEQ()を回す。
        elseif talk_type == "table" then
            for i,v in ipairs(talk) do
                local co = SEQ(v)
                while true do
                    value = co(args)
                    if value == nil then
                        break
                    end
                    args = coroutine.yield(value)
                end
            end        
        end
    end
    return coroutine.wrap(task)
end

-- シャッフル実行
local function RAND(talk)
    local sh = table_copy(talk)
    shuffle.shuffle(sh)
    return SEQ(sh)
end

-- 無限SEQ実行
local function INFINITY(talk)
    local function task(args)
        while true do
            local co = SEQ(talk)
            while true do
                value = co(args)
                if value == nil then
                    break
                end
                args = coroutine.yield(value)
            end
        end
    end
    return coroutine.wrap(task)
end

-- 関数を1回実行するタスク（warpはSEQで行うこと）
local function ONE(func)
    local function task(args)
        coroutine.yield(func(args))
    end
    return task
end

return {
    INFINITY = INFINITY,
    SEQ      = SEQ,
    RAND     = RAND,
    ONE      = ONE,
}