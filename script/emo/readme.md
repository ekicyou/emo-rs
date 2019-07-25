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
　 →10 分間に会話する回数 `env.talk.freq_10min`
　 → 会話終了後の無声秒数 `env.talk.sleep_sec`
　 → 時報前無声秒数 `env.talk.sleep_news_sec`

### 会話の開始判定の流れ

1. 現在会話中なら中断
   `if req.status_dic.talking then return false end`

2. 会話終了時刻が未記録なら登録
   `local now = os.time()`
   `if not talk.end_talk_time then talk.end_talk_time = now`

3. 時報会話が存在すれば返す
   `local news = check_news(EV, data, now)`
   `if news return news end`

4. 無音秒数が経過していなければ中断
   ```lua
   if os.difftime(now, talk.end_talk_time) < talk.sleep_sec then
       return false
   end
   ```

5. 次回会話時刻に到達していなければ中断
   ```lua
   if     talk.next_talk_time
      and os.difftime(now, talk.next_talk_time) < 0 then
       return false
   end
   ```

6. 通常会話の開始を返す
   `return 'normal'`


### 時報会話の命名規則

|format             |意味             |
|:==================|:================|
|Tnormal            |通常会話         |
|TM15               |毎時15分         |
|TH13               |13:00            |
|TH03               |03:00            |
|TH1430             |14:30            |
|TD0214             |02/14            |
|TD0214T1400        |02/14 14:00      |
|TD20200214T1400    |2020/02/14 14:00 |
|TW5H17             |金曜日 17:00     |
|TW1                |日曜日           |
|TW3                |火曜日           |
