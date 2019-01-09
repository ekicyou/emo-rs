--[[
メインループ
SHIORI requestを受け取り、responseを返すジェネレータです。
]]

local binser  = require "binser"
local outcome = require "outcome"

local data = {env={}, save={}}

--データを読み込みます。存在しない場合は空のテーブルを返します。
local function load(path)
    local status, result = pcall(binser.readFile, path)
    if status then return result
    else return {}
    end
end

--データを保存します。エラーは無視します。
local function save(path, data)
    local status, result = pcall(binser.writeFile, path, data)
end

--ディレクトリを作成します。エラーは無視します。
local function create_dir(dir)
end

--初期化処理を実行します。
local function start(args)
    local x, tmp_sep, swap = package.config
    local load_dir  = args.ansi_load_dir
    local profile_dir = load_dir    ..x.."profile"
    local emo_dir     = profile_dir ..x.."emo" 
    local cache_dir   = emo_dir     ..x.."cache" 
    local save_path   = emo_dir     ..x.."save.txt"

    local env = data.env
    env.hinst     = args.hinst
    env.load_dir  = load_dir
    env.cache_dir = cache_dir
    env.save_path = save_path

    data.save = read(save_path)
    return outcome.ok()
end

--解放処理を実行します。
local function drop()
    write(data.env.save_path, data.save)
    return outcome.ok()
end

--メインループ（コルーチン）
local function main_loop(req)
    -- load処理 ここから
    local res = start(req)
    -- load処理 ここまで
    while req do
        req = coroutine.yield(res)
        -- request処理 ここから

        res = outcome.ok("shiori response")
        -- request処理 ここまで
    end
    -- unload処理 ここから
    return drop()
    -- unload処理 ここまで
end 

local function create()
    return coroutine.wrap(main_loop)
end

local rc = {
    create = create,
}

return rc