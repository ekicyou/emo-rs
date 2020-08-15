--- どこいつ(DKIT)関数
local M={}

--- ヘッダを読み込んでcolデータを作成
local RE_DIC = "^#(.+)$"

local function load_header(line)
    local items = {}
    local dic = {}
    local cols = {
        dic = dic,
        items = items,
    }
    for i,name in ipairs(line) do
        local col = {i = i-1, name = name, row_dic={}}
        local s,e,m = string.find(name, RE_DIC)
        local is_dic = false
        if m then
            is_dic = true
            name = m
            local dic_col = dic[name]
            if dic_col == nil then
                dic_col = {name = name, row_dic={} }
                dic[name] = dic_col
            end
            col = dic_col
        else
            dic[name] = col
        end
        table.insert(items,col)
    end
    return cols
end

--- 行の取り込み
--- nameについて、「呼称　→名称」の優先度で決定する。
local function load_row(cols, line)
    local row = {}
    for i,value in ipairs(line) do
        -- 行データの作成
        if value == nil or #value == 0 then
            goto LOOP_END
        end
        local col = cols[i]
        if col.i then
            row[col.name] = value
        else
            local dic = row[col.name]
            if dic == nil then
                dic = {}
                row[col.name] = dic
            end
            dic[value] = 1
        end

        -- 検索用インデックスの作成
        col.row_dic[value] = row

        -- continue
        ::LOOP_END::
    end
    -- [name]フィールドの決定
    row.name = row["呼称"]
    if row.name == nil then
        row.name = row["名称"]
    end

    return row
end

--- CSVデータよりどこいつ検索テーブルを作成
function M.create_word_db(csv_data)
    local db = false
    for i,row in ipairs(csv_data) do
        if db then 
            local row = load_row(db.cols.items, row)
            row.i = i
            table.insert(db.rows, row)
        else
            local cols = load_header(row)
            db = {cols=cols, rows={}}
        end
    end
    return db
end

return M