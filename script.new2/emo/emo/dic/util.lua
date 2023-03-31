-- ユーティリティ関数
local MOD = {}

function MOD.random(...)
    return math.random(...)
end

--- ランダムトーク関数を作成する。
--- @vararg any トーク関数
--- @return function randam_talk ランダムトーク関数
function MOD.select_talk_builder(...)
    local array = { ... }
    if #array == 0 then
        error("#{...} is 0")
    end
    if #array == 1 then
        local item = array[1]
        if type(item) == "table" then
            array = item
        end
    end
    return function(...)
        local random_index = MOD.random(#array)
        local random_element = array[random_index]
        return random_element(...)
    end
end

--- 要素をshuffleして列挙し続ける関数を作成する。
--- @vararg any アイテム
--- @return function gen アイテムをshuffleして返し続ける列挙関数
function MOD.gen_shuffle_builder(...)
    local array = { ... }
    if #array == 0 then
        error("#{...} is 0")
    end

    local function GEN()
        ::START::
        local shuffled_array = {}
        for i = 1, #array do
            local pos = MOD.random(1, i)
            shuffled_array[i] = shuffled_array[pos]
            shuffled_array[pos] = array[i]
        end
        for i = 1, #shuffled_array do
            coroutine.yield(shuffled_array[i])
        end
        goto START
    end

    return coroutine.wrap(GEN)
end

return MOD
