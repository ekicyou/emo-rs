require "test.utils.save_load"
require "test.shiori.response"
require "test.shiori.event"
require "test.shiori.utils"


-- とりあえずすぐ試したいテストはここに書く。
function test_every()
    local t = require "test.luaunit"
    local utils = require "shiori.utils"
    local ser = require "libs.serpent"
    local shiori = require "shiori"
    local response = require "shiori.response"
    local make = require "test.shiori.make_request"
    local X = response.join

    local hinst = 1234
    local WORK_SPACE_DOLDER = os.getenv('WORK_SPACE_DOLDER')
    local ansi_load_dir = WORK_SPACE_DOLDER .. '\\script\\test\\load_dir'
    t.assertEquals(ansi_load_dir, 'C:\\home\\maz\\git\\emo-rs\\script\\test\\load_dir')
    do
        local rc = shiori.load(hinst, ansi_load_dir)
        t.assertIsTrue(rc)
    end
    do
        local args = {}
        args[0] = "マスターシェル"
        local req = make.get("OnBoot", args)
        local res = shiori.request(req)
        local exp = X(  "SHIORI/3.0 200 OK",
                        "Charset: UTF-8",
                        [=[Value: \1\s[10]\0\s[0]OnBoot:起動トークです。\e]=])
        t.assertEquals(res, exp)
    end
    do
        local rc = shiori.unload()
    end
end

-- ここまで

local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
