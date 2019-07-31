-- 一度もsave dataが作成されていない場合に読み込まれる。
return {
    is_first_boot=true,
    talk={
        freq_10min=30,      -- 10分間に会話する回数
        sleep_sec=3,        -- 会話終了後の無声秒数
        sleep_news_sec=20,  -- 時報前無声秒数
    },
    get={
        username  ="ユーザさん",
    },

}