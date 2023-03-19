---@diagnostic disable: lowercase-global

function test_hello()
    local t = require "test.luaunit"
    local a = {
        hello = 'world',
        pretty = 'print',
    }
    t.assertEquals(a.hello, 'world')
end

function test_next()
    local t = require "test.luaunit"

    local meta = { aaa = 'a', bbb = 'b' }
    local a = { hello = 'world', fire = 'fox', }
    setmetatable(a, meta)
    local k, v = nil, nil
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

function test_co_wrap_for()
    local t = require "test.luaunit"
    local function CO()
        coroutine.yield(1, 2)
        coroutine.yield(3, 4)
    end
    local sum = 0
    for a, b in coroutine.wrap(CO) do
        sum = sum + a + b
    end
    t.assertEquals(sum, 10)
end
