--[[
メインループ
SHIORI requestを受け取り、responseを返すジェネレータです。
]]

local response  = require "shiori.response"
local ser       = require "libs.serpent"
local utils     = require "shiori.utils"
local cts       = require "shiori.cts"

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
local function init(unload, args)
    local load = {}
    local env  = {load=load}
    local data = {env=env}

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

    load.hinst     = args.hinst
    load.load_dir  = load_dir
    load.cache_dir = cache_dir
    load.save_path = save_path

    -- save.luaの読み込み/保存
    package.loaded["save"] = nil
    data.save = require "save"
    utils.init_data_table(data)
    local env, save = data:ENTRY()
    local touch = save:ENTRY("touch")
    touch.load = os.date()
    unload:reg(function()
        touch.unload = os.date()
        write(load.save_path, save)
    end)

    -- イベントテーブルの読み込み
    local events = require "shiori.events"
    local ev = events.get_event_table(unload, data)

    -- response.reg.talk(value, dic)call backの結合
    response.reg.talk = function(now, value, dic)
        ev:on_talk_start(data, now, value, dic)
    end

    --
    return true, ev, data
end

--リクエスト処理を実行します。
local function request(ev, data, req)
    local ok, rc = cts.using(function(drop)
        data.drop = drop
        local touch = data.save:ENTRY("touch")
        touch.request = os.date()
        local res = ev:fire_request(data, req)
        return res
    end)
    data.drop = nil
    return ok and rc or response.err(rc)
end

--メインループ（コルーチン）
local function main_loop(req)
    local ok, rc = cts.using(function(unload)
        local res, ev, data = init(unload, req)
        while req do
            req = coroutine.yield(res)
            if req then
                res = request(ev, data, req)
            else
                break
            end
        end
        return true
    end)
    return ok and rc or false
end

local function create()
    return coroutine.wrap(main_loop)
end

return {
    create = create,
}