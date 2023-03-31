-------- ここからこのまま
local response  = require "shiori.response"
return function(EV)
-------- ここまでこのまま

--初回トーク
function EV:初回起動(data, req)
    local s = [=[\1\![move,-353,,,0,base,base]\s[通常]]=]
    s = s.. [=[\0\c\s[笑顔]はじめましてや！！\nうちは、むらさき。]=]
    s = s.. [=[\1\c\s[通常]僕はエモ。\s[笑顔]クール系の可愛い娘。]=]
    s = s.. [=[\0\n[150]\s[へえ]そこ自分でいう‥‥。]=]
    s = s.. [=[\1\c\s[照れ怒り]イイジャン！‥‥ええと、\0\s[通常]\1\s[静観]僕は日常から「感情」を探してるんだ。]=]
    s = s.. [=[\0\c\s[静観]つまり、、\n\s[いたずら笑顔]エモを弄ってればOK？]=]
    s = s.. [=[\1\c\s[照れ怒り]ちがうよう。]=]
    s = s.. [=[\0\n[150]\s[可愛い笑顔]まあ、\s[笑顔]これから、よろしゅうに！]=]
    s = s.. [=[\1\c\s[笑顔]よろしくね。]=]
    s = s.. [=[\e]=]
    return response.talk(s)
end

--起動トーク
function EV:起動(data, req)
    local s = [=[\1\s[10]\0\s[笑顔]起動したで！\1\s[通常]や、お久しぶり。\e]=]
    return response.talk(s)
end

--クリック
function EV:ダブルクリック(data, req)
    local s = [=[\1\![move,-353,,,0,base,base]\s[100]\0\s[通常]ダブルクリックで位置調整なんや。\1\s[100]ソーシャルディスタンスだね。\e]=]

    return response.talk(s)
end

--おさわり反応
local TOUCH = {}
function TOUCH.Head0()
    return [=[
\1\s[通常]
\0\s[笑顔]撫でて伸ばすタイプなんや～。
\1\s[冷笑]うそっぽ～い。
\e]=]
end
function TOUCH.Bust0()
    return [=[
\1\s[通常]
\0\s[笑顔]えっち、\n　すけっち、\n　　わんたっち～♪\w9
\1\s[冷笑]‥‥\n\w9昭和の香りがするよ。
\e]=]
end
function TOUCH.Head1()
    return [=[
\0\s[通常]
\1\s[不安]な、なんだよう。
\0\s[笑顔]仕方ないなあ～、\n%usernameったらもう♪\w9
\e]=]
end
function TOUCH.Bust1()
    return [=[
\0\s[通常]
\1\s[照れ怒り]さ、触らないでよ！
\0\s[笑顔]もう、%usernameったら、いたずらっ子やねぇ。\w9
\e]=]
end

function EV:おさわり反応(data, req, actor, region)
    local key = region .. actor
    local fn  = TOUCH[key]
    if type(fn) ~= "function" then
        return self:no_entry(data, req)
    end
    return response.talk(fn())
end

--バルーン切り替え
function EV:バルーン切り替え(data, req)
    local s = [=[\1\s[通常]\0\s[通常]バルーン切り替えです。\w9\w9\1\s[通常]ばるるるるん？\_w[600]\e]=]
    return response.ok(s)
end

--ネットワーク更新：ネットワーク更新開始
function EV:更新開始(data, req)
    local s = [=[\1\s[通常]\0\s[笑顔]あったらし～い～、更新は？\1\s[通常]きた？\e]=]
    return response.talk(s)
end
--ネットワーク更新：更新ファイル確認
function EV:更新確認(data, req)
    local s = [=[\1\s[通常]\0\s[期待大]きたよぉ～。\1\s[冷笑]期待しない方が‥‥\e]=]
    return response.talk(s)
end
--ネットワーク更新：更新されなかった
function EV:更新無し(data, req)
    local s = [=[\1\s[通常]\0\s[期待外れ]こえへん‥‥\w9\w9\1\s[驚き]ｲｷﾛｰ｡\e]=]
    return response.talk(s)
end
--ネットワーク更新：サイト無し
function EV:更新失敗(data, req)
    local s = [=[\1\s[通常]\0\s[期待外れ]繋がらへん‥‥\w9\w9\1\s[驚き]ｲｷﾛｰ｡\e]=]
    return response.talk(s)
end
--ネットワーク更新：更新された
function EV:更新成功(data, req)
    local s = 
[=[
\1\s[通常]
\0\s[期待通り]更新したで！
\1\s[笑顔]どこが変わったかな？
\0\n[150]‥‥\s[落胆]アヒルが。。。
\1\s[静観]\n[150]起動トークだけ差し替え？
\e]=]
    return response.talk(s)
end

-------- ここからこのまま
end
-------- ここまでこのまま
