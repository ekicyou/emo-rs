# emo.dllのluaコード呼び出しルール

## package.path

1. {GHOST}/profile/emo/save/?.lua
2. {GHOST}/profile/emo/save/?/init.lua
3. {GHOST}/dic/?.lua
4. {GHOST}/dic/?/init.lua
5. {GHOST}/emo/?.lua
6. {GHOST}/emo/?/init.lua

## load()で実行するlua疑似コード

```lua
-- 呼び出し引数
local hinst = 99                -- DllMainで渡されるhinst
local ansi_load_dir = '{GHOST}' -- ANSI文字コードの emo.dll ディレクトリ

-- 初期化を行い、グローバル変数 shiori を作成
require('shiori');

-- shiori.loadの呼び出し
local rc = shiori.load(hinst, ansi_load_dir)
-- rc = trueの時、正常終了とする
```

## request()のLua疑似コード

```lua
-- 呼び出し引数
local req = {
    method  = { "get" | "notify"  }
    version = 30
    charset = { Charset: "UTF-8" }
    security_level = { SecurityLevel: "local" }
    sender  = { Sender: ? }
    status  = { Status: ? }
    id      = { ID: ? }
    base_id = { BaseID: ? }
    reference ={
        [0] = { Reference0: ? }
        [1] = { Reference1: ? }
        [N] = { ReferenceN: ? }
    }
    time = {year, month, day, hour, min, sec, ns, yday, wday }
}

-- 呼び出し
local res = shiori.request(req)
-- resはUTF-8フォーマットの応答文字列
```
