-- シーン（一連の会話）管理
local MOD = {}
local actor = require "emo.dic.actor"
local yen = require "emo.dic.sakura_script"

--############################################################

--- ボード、シーンにおける立ち位置。アクター一人が１ボードに立つ。
--- @class Board
--- @field scene Scene シーン
--- @field id integer 立ち位置番号（１スタート）
--- @field actor Actor アクター定義
--- @field private last_emote_script string 最後に指定した表情
--- @field scope_change_count integer 会話中になった回数
local BOARD_METHOD = {}

--- cut時の処理。状況のリセット
function BOARD_METHOD:cut()
    self.last_emote_script = nil
    self.scope_change_count = 0
end

--- 表情を指定する。
--- @param script string 表情
function BOARD_METHOD:emote_script(script)
    if self.last_emote_script == script then return end
    self.scene:scope(self)
    self.last_emote_script = script
    self.scene:append_raw(script)
end

--- トークを行う。
--- @param self Board ボード
--- @param talk string トーク
function BOARD_METHOD:talk(talk)
    self.scene:scope(self)
    self.scene:talk(self, talk)
end

--- ボードを作成する。
--- @param scene Scene シーン
--- @param id integer ステージ番号（１スタート）
--- @param actor Actor アクター情報
--- @return Board board ボード（立ち位置）
local function create_board(scene, id, actor)
    local a = {
        scene              = scene,
        id                 = id,
        actor              = actor,
        scope_change_count = 0,
    }
    local t = {}
    for k, v in pairs(BOARD_METHOD) do t[k] = v end
    setmetatable(t, {
        __index = actor.BOARD_METHOD,
    })
    setmetatable(a, {
        __index = t,
        __call = BOARD_METHOD.talk,
    })
    return a
end

--############################################################

--- シーン
--- @class Scene
--- @field env any 環境
--- @field sakura_script string  作成中のスクリプト
--- @field private boards Board[] 登場人物一覧
--- @field private last_talking Board 最後にしゃべった登場人物
local SCENE_METHOD = {}
local SCENE_META = {}
SCENE_META.__index = SCENE_METHOD


--- talk を追加する。
--- @param board Board 登場人物
--- @return Scene
function SCENE_METHOD:scope(board)
    local script = ''
    if not self.last_talking then
        -- 初回：登場人物をすべて表示
        for i, target in ipairs(self.boards) do
            if target ~= board then
                script = script .. yen.scope(target.id - 1)
                script = script .. board.actor.default_emote_script
            end
        end
    end
    if self.last_talking ~= board then
        -- スコープ切り替え
        script = script .. yen.scope(board.id - 1)

        -- スコープ切り替え改行
        if board.scope_change_count > 0 then
            script = script .. yen.new_line(board.actor.scope_change_line)
        end
        board.scope_change_count = board.scope_change_count + 1
    end
    self.last_talking = board
    self.sakura_script = self.sakura_script .. script
    return self
end

--- talk を追加する。
--- @param board Board 登場人物
--- @param talk string トーク
--- @return Scene
function SCENE_METHOD:talk(board, talk)
    local script = yen.talk(board.actor.wait, talk)
    self.sakura_script = self.sakura_script .. script
    return self
end

--- script をそのままスクリプトに登録する。
--- @param script string スクリプト
--- @return Scene
function SCENE_METHOD:append_raw(script)
    self.sakura_script = self.sakura_script .. script
    return self
end

--- actorの取得、アクター入場
--- @vararg string アクター名を列挙
--- @return table board1 立ち位置1
--- @return table board2 立ち位置2
function SCENE_METHOD:enter(...)
    local boards = {}
    for i, name in ipairs({ ... }) do
        local a = actor.get(name)
        local b = create_board(self, i, a)
        table.insert(boards, b)
    end
    self.boards = boards
    self.last_talking = nil
    return unpack(boards)
end

--- シーンをカットして次のシーンを始める。チェイントーク。
--- @return Scene
function SCENE_METHOD:cut()
    local s = self.sakura_script
    if #s > 0 then
        s = s .. yen.e()
        coroutine.yield(s)
    end
    self.sakura_script = ''
    return self
end

--- scene作成
--- @param env any 環境情報
--- @return Scene
function MOD.create(env)
    --- @class Scene
    local scene = {
        env           = env,
        sakura_script = '',
        boards        = {},
    }
    setmetatable(scene, SCENE_META)
    return scene
end

return MOD
