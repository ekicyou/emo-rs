-- シーン（一連の会話）管理
local MOD = {}
local actor = require "emo.dic.actor"

--############################################################

--- ボード、シーンにおける立ち位置。アクター一人が１ボードに立つ。
--- @class Board
--- @field scene Scene シーン
--- @field id integer 立ち位置番号（１スタート）
--- @field actor Actor アクター定義
local BOARD_METHOD = {}
local BOARD_META = {}
BOARD_META.__index = BOARD_METHOD

--- ボードを作成する。
--- @param scene Scene シーン
--- @param id integer ステージ番号（１スタート）
--- @param actor Actor アクター情報
--- @return Board board ボード（立ち位置）
local function create_board(scene, id, actor)
    local a = {
        scene = scene,
        id    = id,
        actor = actor,
    }
    setmetatable(a, BOARD_META)
    return a
end

--############################################################

--- シーン
--- @class Scene
local SCENE_METHOD = {}
local SCENE_META = {}
SCENE_META.__index = SCENE_METHOD


--- text をそのままスクリプトに登録する。
--- @param text string スクリプト
--- @return Scene
function SCENE_METHOD:append(text)
    self.raw_script = self.raw_script .. text
    return self
end

--- actorの取得、アクター入場
--- @vararg string アクター名を列挙
--- @return Board board1 立ち位置1
--- @return Board board2 立ち位置2
function SCENE_METHOD:enter(...)
    local boards = {}
    for i, name in ipairs({ ... }) do
        local a = actor.get(name)
        local b = create_board(self, i, a)
        table.insert(boards, b)
    end
    self.boards = boards
    return unpack(boards)
end

--- シーンをカットして次のシーンを始める。チェイントーク。
--- @return Scene
function SCENE_METHOD:cut()
    local s = self.raw_script
    if #s > 0 then
        coroutine.yield(s)
    end
    self.raw_script = ''
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
