local entries = {}
local words = {}

local l4={}
local l3={}
local l2={}
local l1={}
local last_entry = {}
local last_scene = {}
local last_word = false

local function reset_entry()
    last_entry = {}
    last_scene = {}
    last_word = false
end

local function reset()
    l4={}
    l3={}
    l2={}
    l1={}
    reset_entry()
end

local function h4(t)
    l4=t
    l3={}
    l2={}
    l1={}
    reset_entry()
end

local function h3(t)
    l3=t
    l2={}
    l1={}
    reset_entry()
end

local function h2(t)
    l2=t
    l1={}
    reset_entry()
end

local function h1(t)
    l1=t
    reset_entry()
end



local function table_concat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

local function merge_entry(entry, h)
    if h.title then entry.title = h.title
    end
    if h.require then table_concat(entry.require, h.require)
    end
    if h.either  then table_concat(entry.either , h.either)
    end
    if h.forget  then table_concat(entry.forget , h.forget)
    end
    if h.memory  then table_concat(entry.memory , h.memory)
    end
end

local function create_entry()
    local entry = {
        title = "",
        require = {},
        either = {},
        forget = {},
        memory = {},
    }
    merge_entry(entry, h4)
    merge_entry(entry, h3)
    merge_entry(entry, h2)
    merge_entry(entry, h1)
    return entry
end


-- サブエントリの追加
local function sub(key, fn)
    last_scene = {fn}
    local section = last_entry.section[key]
    if not section then
        section = {}
        last_entry.section[key] = section
    end
    table.insert(section , last_scene)
end

-- 直前のscene にトークをつなげる
local function chain(fn)
    table.insert(last_scene , fn)
end

-- トップレベルエントリ,key="@"
local function top(fn)
    last_entry = create_entry()
    table.insert(entries, last_entry)
    sub("@", fn)
end

local function word(...)
    local args = {...}
    if not last_word then
        last_word = create_entry()
        last_word.words = {}
        table.insert(words, last_word)
    end
    table_concat(last_word.words, args)
end

--[[
パスタスクリプトテスト構文

最初の柱まではドキュメントコメントとします。
]]

-- 会話辞書の冒頭でリセット
reset()

h3({require={"通常トーク",}})

h2({require={"午前",}})

h1({title={"お天気はどうですか",}})

top(function(t)
    t.actor("パスタ")
    t.talk("おはようございます。")
    t.talk("明日の天気を当ててみてましょう。")
    t.local_jump("１")
end)

sub("１", function(t)
    t.act("笑顔")
    t.talk("サンダルは晴れと出ました！")
    t.talk("お出かけ出来たら楽しいですよ。")
end)

sub("１", function(t)
    t.act("曇り顔")
    t.talk("サンダルは雨と出ました。")
    t.talk("引きこもりでも、雨はじっとりなのです。")
end)

chain(function(t)
    t.chain()
    t.actor("パスタ")
    t.talk("トーク区切り。")
end)

h1({title={"同名柱",}})
h1({title={"同名柱",}})

h2({require={"お昼過ぎ",}})

h1({title={"お昼過ぎですね",}})

top(function(t)
    t.actor("パスタ")
    t.act("笑顔")
    t.talk("こんにちは！")
    t.act("通常")
    t.talk("お昼過ぎになりましたね。")
end)

-- 単語辞書の冒頭でリセット
reset()

h1({either={"人名",}})

word("パスタ","おじさん")