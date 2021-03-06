-- イベント試験
function test_shiori_event()
    local t = require "test.luaunit"
    local events = require "shiori.events"
    local response = require "shiori.response"
    local make = require "test.shiori.make_request"
    local ev = events.get_event_table()
    local ser = require "libs.serpent"
    local data = {}

    local X = response.join

    do
        local req = make.get("version")
        req.status ="talking,balloon(0=0)"
        local act = ev:fire_request(data,req)
        local exp = X(  "SHIORI/3.0 204 No Content",
                        "Charset: UTF-8",
                        "X-Warn-Resion: no_entry")
        t.assertEquals(act, exp)
        t.assertNotIsNil(data.save.no_entry.version)
        t.assertEquals(req.status_dic.talking, true)
        t.assertEquals(req.status_dic.balloon['0'], '0')
    end
    do
        local args = {}
        args[0] = ""
        local req = make.notify("OnInitialize", args)
        local act = ev:fire_request(data,req)
        local exp = X(  "SHIORI/3.0 204 No Content",
                        "Charset: UTF-8")
        t.assertEquals(act, exp)
        t.assertEquals(data.notify.OnInitialize.reference[0], "")
        t.assertIsNil(data.notify.OnInitialize.reference[1])
    end
    do
        local args = {}
        args[0] = "2.3.86"
        args[1] = "SSP"
        args[2] = "2.3.86.3000"
        local req = make.notify("basewareversion", args)
        local act = ev:fire_request(data,req)
        local exp = X(  "SHIORI/3.0 204 No Content",
                        "Charset: UTF-8")
        t.assertEquals(act, exp)
        t.assertEquals(data.notify.basewareversion.reference[0], "2.3.86")
        t.assertEquals(data.notify.basewareversion.reference[1], "SSP")
        t.assertEquals(data.notify.basewareversion.reference[2], "2.3.86.3000")
        t.assertIsNil(data.notify.basewareversion.reference[3])
    end
--[[
=====send=====
GET SHIORI/3.0
ID: OnTranslate
Charset: UTF-8
Sender: SSP
SecurityLevel: local
Reference0: \1\s[1512]\1\![bind,アクセサリ,CLOSED,0]\![set,otherghosttalk,true]\n\0\s[0]こんばんは。\w7\nユーザさんは晩ご飯食べた？\w9\n\n\s[5]まだだったら、\w4用意するよ。\w6\e
Reference1:
Reference2: OnBoot
Reference3: マスターシェル

=====response=====
***CallTime:2msec.
SHIORI/3.0 200 OK
Value: \1\s[1512]\1\![bind,アクセサリ,CLOSED,0]\![set,otherghosttalk,true]\n\0\s[0]こんばんは。\w7\nユーザさんは晩ご飯食べた？\w9\n\n\s[5]まだだったら、\w4用意するよ。\w6\e
Charset: UTF-8

]]--
    do
        local args = {}
        args[0] = "変換対象の文章"
        args[1] = ""
        args[2] = "OnBoot"
        args[3] = "マスターシェル"
        local req = make.get("OnTranslate", args)
        local act = ev:fire_request(data,req)
        local exp = X(  "SHIORI/3.0 200 OK",
                        "Charset: UTF-8",
                        "Value: 変換対象の文章")
        t.assertEquals(act, exp)
    end
--[[
=====send=====
GET SHIORI/3.0
Charset: UTF-8
Sender: SSP
SecurityLevel: local
ID: OnBoot
Reference0: マスターシェル

=====response=====
***CallTime:2146msec.
SHIORI/3.0 200 OK
Value: \1\s[1512]\1\![bind,アクセサリ,CLOSED,0]\![set,otherghosttalk,true]\n\0\s[0]こんばんは。\w7\nユーザさんは晩ご飯食べた？\w9\n\n\s[5]まだだったら、\w4用意するよ。\w6\e
Charset: UTF-8

]]--
    do
        local args = {}
        args[0] = "マスターシェル"
        local req = make.get("OnBoot", args)
        local act = ev:fire_request(data,req)
        local exp = X(  "SHIORI/3.0 200 OK",
                        "Charset: UTF-8",
                        [=[Value: \1\s[10]\0\s[0]OnBoot:起動トークです。\e]=])
        t.assertEquals(act, exp)
        t.assertEquals(data.notify.OnInitialize.reference[0], "")
        t.assertIsNil(data.notify.OnInitialize.reference[1])
    end

--[[
=====send=====
GET SHIORI/3.0
Charset: UTF-8
Sender: SSP
SecurityLevel: local
Status: balloon(0=0)
ID: OnSecondChange
Reference0: 1
Reference1: 0
Reference2: 0
Reference3: 1
Reference4: 0
]]--
    do
        local now = os.time({
            year =2019,
            month=   7,
            day  =  25,
            hour =  21,
            min  =  17,
            sec  =   0,
        })
        local args = {}
        args[0] = "マスターシェル"
        local req = make.get("OnSecondChange", args)
        req.now  = now
        local act = ev:fire_request(data,req)
        local exp = X(  "SHIORI/3.0 200 OK",
                        "Charset: UTF-8",
                        [=[Value: \1\s[10]\0\s[0]OnBoot:起動トークです。\e]=])
        --t.assertEquals(act, exp)
        --t.assertEquals(data.notify.OnInitialize.reference[0], "")
        --t.assertIsNil(data.notify.OnInitialize.reference[1])
    end

end
