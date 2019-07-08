require "test.utils.save_load"
require "test.shiori.response"

-- とりあえずすぐ試したいテストはここに書く。
function test_shiori_event()
    local t = require "test.luaunit"
    local events = require "shiori.events"
    local response = require "shiori.response"
    local ev = events.get_event_table()
    local ser = require "libs.serpent"
    local env = {}

    local X = response.join

    do
        local req = {}
        req.version = 30
        req.method  = "get"
        req.id      = "version"
        req.charset = "UTF-8"
        req.security_level = "local"
        req.sender = "SSP"
        local act = ev:fire_request(env,req)
        local exp = X(  "SHIORI/3.0 204 No Content",
                        "Charset: UTF-8",
                        "Sender: emo",
                        "SecurityLevel: local",
                        "X-Warn-Resion: no_entry")
        t.assertEquals(act, exp)
        t.assertNotIsNil(env.save.no_entry.version)
    end

end


-- ここまで

local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
