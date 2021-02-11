function test_insert_wait()
    local t = require "test.luaunit"
    local api = require "shiori.insert_wait"
    local act = [=[あつい、あつい！‥‥ﾀｽｹﾃ｡]=]
    local exp = [=[あつい、\_w[400]あつい！\_w[600]‥\_w[200]‥\_w[200]ﾀｽｹﾃ｡\_w[800]]=]
    t.assertEquals(api.insert_wait(act), exp)
end
