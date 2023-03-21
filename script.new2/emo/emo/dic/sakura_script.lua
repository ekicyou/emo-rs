-- さくらスクリプト変換ユーティリティ
local MOD = {}

local utf8 = require "emo.libs.luajit-utf8"
local wait_str = require "emo.dic.wait_str"

--- msウェイトをスクリプトに変換する。但しms-50で換算する。
---@param ms number ウェイト、但し50の時に０ウェイトとする
function MOD.wait(ms)
    local target = ms - 50
    if target <= 0 then return "" end
    local w50 = math.floor(target / 50)
    local remain = target - (w50 * 50)
    if remain == 0 and w50 > 0 and w50 < 10 then
        return "\\w" .. w50
    end
    return "\\_w[" .. target .. "]"
end

--- トークテキストとしてウエイト入りスクリプトに展開する。
--- @param wait number[] ウェイト設定配列
--- @param text string トーク
function MOD.talk(wait, text)
    local script = ""
    for c, ms in wait_str.en_char_wait(wait, text) do
        script = script .. utf8.char(c) .. MOD.wait(ms)
    end
    return script
end

--- 改行コード
--- @param em number 改行幅
--- @return string 改行スクリプト
function MOD.new_line(em)
    if em <= 0 then return "" end
    local a = math.floor(em)
    local remain = em - a
    if remain == 0 and a > 0 and a < 10 then
        return "\\n" .. a
    else
        return "\\n[" .. em .. "]"
    end
end

--- 表情（サーフェス）切り替え
--- @param num number サーフェス番号
function MOD.surface(num)
    return "\\s[" .. num .. "]"
end

--- スコープ切り替え
--- @param num number スコープ番号
function MOD.scope(num)
end

return MOD
