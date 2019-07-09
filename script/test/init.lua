require "test.utils.save_load"
require "test.shiori.response"

-- とりあえずすぐ試したいテストはここに書く。
function test_shiori_event()
    local t = require "test.luaunit"
    local events = require "shiori.events"
    local response = require "shiori.response"
    local make = require "test.shiori.make_request"
    local ev = events.get_event_table()
    local ser = require "libs.serpent"
    local env = {}

    local X = response.join

    do
        local req = make.get("version")
        local act = ev:fire_request(env,req)
        local exp = X(  "SHIORI/3.0 204 No Content",
                        "Charset: UTF-8",
                        "Sender: emo",
                        "SecurityLevel: local",
                        "X-Warn-Resion: no_entry")
        t.assertEquals(act, exp)
        t.assertNotIsNil(env.save.no_entry.version)
    end
    do
        local args = {}
        args[0] = ""
        local req = make.notify("OnInitialize", args)
        local act = ev:fire_request(env,req)
        local exp = X(  "SHIORI/3.0 204 No Content",
                        "Charset: UTF-8",
                        "Sender: emo",
                        "SecurityLevel: local")
        t.assertEquals(act, exp)
        t.assertEquals(env.notify.OnInitialize.reference[0], "")
        t.assertIsNil(env.notify.OnInitialize.reference[1])
    end
    do
        local args = {}
        args[0] = "2.3.86"
        args[1] = "SSP"
        args[2] = "2.3.86.3000"
        local req = make.notify("basewareversion", args)
        local act = ev:fire_request(env,req)
        local exp = X(  "SHIORI/3.0 204 No Content",
                        "Charset: UTF-8",
                        "Sender: emo",
                        "SecurityLevel: local")
        t.assertEquals(act, exp)
        t.assertEquals(env.notify.basewareversion.reference[0], "2.3.86")
        t.assertEquals(env.notify.basewareversion.reference[1], "SSP")
        t.assertEquals(env.notify.basewareversion.reference[2], "2.3.86.3000")
        t.assertIsNil(env.notify.basewareversion.reference[3])
    end

end


-- ここまで

local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
