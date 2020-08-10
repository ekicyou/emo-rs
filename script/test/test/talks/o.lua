
function test_talk_seq_1()
    local t = require "test.luaunit"
    local o = require "talks.o"

    local items = {"1","2","3"}
    local co = coroutine.wrap(o.SEQ(items))
    local args = {
        data= {},
        req = {},
    }
    t.assertEquals(co(args), "1")
    t.assertEquals(co(args), "2")
    t.assertEquals(co(args), "3")
    t.assertEquals(co(args), nil)
end

function test_talk_inf()
    local t = require "test.luaunit"
    local o = require "talks.o"

    local items = {"1","2","3"}
    local co = coroutine.wrap(o.INFINITY(items))
    local args = {
        data= {},
        req = {},
    }
    t.assertEquals(co(args), "1")
    t.assertEquals(co(args), "2")
    t.assertEquals(co(args), "3")
    t.assertEquals(co(args), "1")
end

function test_talk_seq_fn()
    local t = require "test.luaunit"
    local o = require "talks.o"

    local function func(args)
        return "1"
    end
    local items = o.ONE(func)
    local co = coroutine.wrap(o.SEQ(items))
    local args = {
        data= {},
        req = {},
    }
    t.assertEquals(co(args), "1")
    t.assertEquals(co(args), nil)
end

function test_talk_seq_str()
    local t = require "test.luaunit"
    local o = require "talks.o"

    local items = "1"
    local co = coroutine.wrap(o.SEQ(items))
    local args = {
        data= {},
        req = {},
    }
    t.assertEquals(co(args), "1")
    t.assertEquals(co(args), nil)
end

function test_talk_rand_1()
    local t = require "test.luaunit"
    local o = require "talks.o"

    local items = {"1","1"}
    local co = coroutine.wrap(o.RAND(items))
    local args = {
        data= {},
        req = {},
    }
    t.assertEquals(co(args), "1")
    t.assertEquals(co(args), "1")
    t.assertEquals(co(args), nil)
end

function test_talk_rand_2()
    local t = require "test.luaunit"
    local o = require "talks.o"

    local items = {"1","2"}
    local co = coroutine.wrap(o.RAND(items))
    local args = {
        data= {},
        req = {},
    }
    local a = co(args)
    local b = co(args)
    local c = co(args)

    t.assertNotEquals(a, b)
    t.assertEquals(c, nil)
end

function test_talk_seq_rev()
    local t = require "test.luaunit"
    local o = require "talks.o"

    local function co_task(args)
        coroutine.yield("2")
        coroutine.yield("3")
    end
    local function one_task(args)
        return "4"
    end
    local subs = {"5","6"}

    local items = {
        "1",
        co_task,
        o.ONE(one_task),
        subs
    }

    local co = coroutine.wrap(o.SEQ(items))
    local args = {
        data= {},
        req = {},
    }
    t.assertEquals(co(args), "1")
    t.assertEquals(co(args), "2")
    t.assertEquals(co(args), "3")
    t.assertEquals(co(args), "4")
    t.assertEquals(co(args), "5")
    t.assertEquals(co(args), "6")
    t.assertEquals(co(args), nil)
end

