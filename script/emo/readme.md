# emo.dllのluaコード呼び出しルール

## package.path

1. {GHOST}/profile/emo/save/?.lua
2. {GHOST}/profile/emo/save/?/init.lua
3. {GHOST}/dic/?.lua
4. {GHOST}/dic/?/init.lua
5. {GHOST}/emo/?.lua
6. {GHOST}/emo/?/init.lua

## load()で実行する疑似luaコード

```lua
local hinst = 99                -- DllMainで渡されるhinst
local ansi_load_dir = '{GHOST}' -- ANSI文字コードの emo.dll ディレクトリ

-- 初期化を行い、グローバル変数 shiori を作成
require('shiori');

-- shiori.loadの呼び出し
local rc = shiori.load(hinst, ansi_load_dir)
-- rc = trueの時、正常終了とする
```
