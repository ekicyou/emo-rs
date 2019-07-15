--[[
メインループ
SHIORI requestを受け取り、responseを返すジェネレータです。
]]

local ser    = require "libs.serpent"
local utils  = require "shiori.utils" 
local events = require "shiori.events"
local ev = events.get_event_table()

local data = {env={}, save={}}

--データを読み込みます。存在しない場合は空のテーブルを返します。


--データを保存します。エラーは無視します。
local function write(path, data)
    data.is_first_boot=nil
    local text = ser.dump(data, {indent = '  ', sortkeys = true, comment = true, sparse = true})
    local h = io.open(path, "w+")
    h:write(text)
    h:close()
end

--ディレクトリを作成します。エラーは無視します。
local function create_dir(dir)
end

--文字列を特定の文字で分割し配列を返す
local function split(str, ts)
    -- 引数がないときは空tableを返す
    if ts == nil then return {} end

    local t = {};
    i=1
    for s in string.gmatch(str, "([^"..ts.."]+)") do
        t[i] = s
        i = i + 1
    end
    return t
end

--初期化処理を実行します。
local function init(args)
    local config  = split(package.config, "\n")
    local x       = config[1]
    local tmp_sep = config[2]
    local swap    = config[3]

    local load_dir  = args.ansi_load_dir
    local profile_dir = load_dir    ..x.."profile"
    local emo_dir     = profile_dir ..x.."emo"
    local cache_dir   = emo_dir     ..x.."cache"
    local save_path   = emo_dir     ..x.."save.lua"
    --[[
    print("package.path:["..package.path .."]")
    print("load_dir:    ["..load_dir     .."]")
    print("profile_dir: ["..profile_dir  .."]")
    print("emo_dir:     ["..emo_dir      .."]")
    print("cache_dir:   ["..cache_dir    .."]")
    print("save_path:   ["..save_path    .."]")
    --]]

    local env = data.env
    env.hinst     = args.hinst
    env.load_dir  = load_dir
    env.cache_dir = cache_dir
    env.save_path = save_path

    data.save = require "save"

    local touch = utils.get_tree_entry(data.save, touch)
    touch.load = os.date()

    return true
end

--解放処理を実行します。
local function drop()
    local touch = utils.get_tree_entry(data.save, touch)
    touch.drop = os.date()

    write(data.env.save_path, data.save)
    return true
end

--リクエスト処理を実行します。
local function request(req)
    local touch = utils.get_tree_entry(data.save, touch)
    touch.request = os.date()

    local res = ev:fire_request(data, req)
    return res
end

--メインループ（コルーチン）
local function main_loop(req)
    local res = init(req)
    while req do
        req = coroutine.yield(res)
        if req then
            res = request(req)
        else
            break
        end
    end
    return drop()
end

local function create()
    return coroutine.wrap(main_loop)
end

return {
    create = create,
}