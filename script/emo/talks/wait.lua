local utf8 = require "utf8"
local esc = utf8.escape
local MODULE = {}

local chars_tp = [=[。．｡.]=]
local chars_ins = [=[？！?!]=]
local chars_semi = [=[、，）］｝」』､,)]}｣]=]
local chars_think = [=[・‥…･]=]

local chars_wait1 = chars_tp .. chars_ins .. chars_semi
local chars_wait2 = chars_think

local re_wait1 = '[' .. esc(chars_wait1) ..']+'
local re_wait2 = '[' .. esc(chars_wait2) ..']+'


local function rep_wait1()

function MODULE.wait1(s, w1, w2)

end



return MODULE