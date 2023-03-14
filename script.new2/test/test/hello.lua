---@diagnostic disable: lowercase-global

function test_hello()
    local t = require "test.luaunit"
    local a = {
        hello = 'world',
        pretty = 'print',
    }
    t.assertEquals(a.hello , 'world')
end

function test_next()
    local t = require "test.luaunit"

    local meta = {aaa='a', bbb='b'}
    local a = {hello='world', fire='fox',}
    setmetatable(a,meta)
    local k ,v = nil, nil
    k, v = next(a, k)
    t.assertNotIsNil(k)
    t.assertNotIsNil(v)

    k, v = next(a, k)
    t.assertNotIsNil(k)
    t.assertNotIsNil(v)

    k, v = next(a, k)
    t.assertIsNil(k)
    t.assertIsNil(v)
end