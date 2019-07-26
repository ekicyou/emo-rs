--[[
メインループ
SHIORI requestを受け取り、responseを返すジェネレータです。
]]

local ser    = require "libs.serpent"
local utils  = require "shiori.utils" 
local cts    = require "shiori.cts"

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
    -- ディレクトリ解決と環境の作成
    local config  = split(package.config, "\n")
    local x       = config[1]
    local tmp_sep = config[2]
    local swap    = config[3]

    local load_dir  = args.ansi_load_dir            -- ghost/masterフォルダ
    local profile_dir = load_dir    ..x.."profile"  -- {ghost}/profile  一時情報フォルダ
    local emo_dir     = profile_dir ..x.."emo"      -- ..{profile}/emo      一時保存先
    local cache_dir   = emo_dir     ..x.."cache"    -- ..{emo}/cache        キャッシュ
    local save_dir    = emo_dir     ..x.."save"     -- ..{emo}/save         saveフォルダ
    local save_path   = save_dir    ..x.."save.lua" -- ..{save}/save.lua    saveファイル

    local env = data.env
    env.hinst     = args.hinst
    env.load_dir  = load_dir
    env.cache_dir = cache_dir
    env.save_path = save_path

    -- save.luaの読み込み
    data.save = require "save"
    local touch = utils.get_tree_entry(data.save, touch)
    touch.load = os.date()

    -- イベントテーブルの読み込み
    local events = require "shiori.events"
    local ev = events.get_event_table()

    return true, ev
end

--解放処理を実行します。
local function drop()
    local touch = utils.get_tree_entry(data.save, touch)
    touch.drop = os.date()

    write(data.env.save_path, data.save)
    return true
end

--リクエスト処理を実行します。
local function request(ev, req)
    local touch = utils.get_tree_entry(data.save, touch)
    touch.request = os.date()

    local res = ev:fire_request(data, req)
    return res
end

--メインループ（コルーチン）
local function main_loop(req)
    local res, ev = init(req)
    while req do
        req = coroutine.yield(res)
        if req then
            res = request(ev, req)
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