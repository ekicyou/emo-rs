function test_event_reg(d)
    local t = require "test.luaunit"
    require "reg_system"
    local ev = require "event"
    t.assertNotIsNil(ev.fire_request)
    t.assertNotIsNil(ev.OnBoot)
end
