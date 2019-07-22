# emo.dll の lua コード呼び出し手順

## package.path

1. {GHOST}/profile/emo/save/?.lua
2. {GHOST}/profile/emo/save/?/init.lua
3. {GHOST}/dic/?.lua
4. {GHOST}/dic/?/init.lua
5. {GHOST}/emo/?.lua
6. {GHOST}/emo/?/init.lua

## load()で実行する lua 疑似コード

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

## request()の Lua 疑似コード

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

## 通常会話の制御

会話を適切なタイミングで行う。
適切なタイミング
　 → 設定した時間間隔に概ね従うこと。
　 → 会話終了後、一定時間無声であること。
　 → 時報会話の邪魔をしないこと。
時間間隔
　 →10 分間に会話する回数 {env.talk.freq_10min}
　 → 会話終了後の無声秒数 {env.talk.sleep_talk_sec}
　 → 時報前無声秒数 {env.talk.sleep_news_sec}

### 会話の開始判定

- 会話をしていない{req.status_dic.talking == false}

  - 直前が talking == true だった場合、会話終了時刻を保存{env.talk.end_talk_time}

* 開始時刻の会話あり(env.talk.next_time[{time}])
