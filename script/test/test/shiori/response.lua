local t = require "test.luaunit"


function test_response()
    local response = require "shiori.response"
    local X = response.join
    do
        local exp = X(  "SHIORI/3.0 200 OK",
                        "Charset: UTF-8",
                        "Value: ほにゃららら")
        local act = response.talk(os.time(), "ほにゃららら")
        t.assertEquals(act, exp)
    end
    do
        local exp = X(  "SHIORI/3.0 204 No Content",
                        "Charset: UTF-8")
        local act = response.no_content()
        t.assertEquals(act, exp)
    end
    do
        local exp = X(  "SHIORI/3.0 500 Internal Server Error",
                        "Charset: UTF-8",
                        "X-Error-Resion: ##ERROR##")
        local act = response.err("##ERROR##")
        t.assertEquals(act, exp)
    end
end
