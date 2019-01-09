local function swap(array, index1, index2)
    array[index1], array[index2] = array[index2], array[index1]
end

local function shuffle(array)
    local counter = #array
    while counter > 1 do
        local index = math.random(counter)
        swap(array, index, counter)
        counter = counter - 1
    end
end

local api = {
  swap = swap,
  shuffle = shuffle,
}

table.swap    = swap
table.shuffle = shuffle

return api
