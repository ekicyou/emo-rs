---@diagnostic disable: lowercase-global

require "test"

-- とりあえずすぐ試したいテストはここに書く。

function test_shiori_response_ok()
    local t        = require "test.luaunit"
    local response = require "shiori.response"

    local actual   = response.ok("こんにちわ！")
    local CRLF     = "\r\n"
    local expect   = [[SHIORI/3.0 200 OK]] .. CRLF
    expect         = expect .. [[Charset: UTF-8]] .. CRLF
    expect         = expect .. [[Sender: emo]] .. CRLF
    expect         = expect .. [[SecurityLevel: local]] .. CRLF
    expect         = expect .. [[Value: こんにちわ！]] .. CRLF
    expect         = expect .. CRLF
    t.assertEquals(actual, expect)
end

function test_shiori_response_err()
    local t        = require "test.luaunit"
    local response = require "shiori.response"

    local actual   = response.err("なんかあかん")
    local CRLF     = "\r\n"
    local expect   = [[SHIORI/3.0 500 Internal Server Error]] .. CRLF
    expect         = expect .. [[Charset: UTF-8]] .. CRLF
    expect         = expect .. [[Sender: emo]] .. CRLF
    expect         = expect .. [[SecurityLevel: local]] .. CRLF
    expect         = expect .. [[X-Error-Resion: なんかあかん]] .. CRLF
    expect         = expect .. CRLF
    t.assertEquals(actual, expect)
end

function test_dic_entry()
    local t = require "test.luaunit"
    local entry = require "emo.dic.entry"

    local a = entry.create()
    t.assertEquals(a.rate(), 1)
    a.talk1 = function(env)
    end
    a.talk2 = function(env)
    end
    t.assertEquals(#a, 0)
end

-- ここまで
local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_DEFAULT)
local rc = t.run()
