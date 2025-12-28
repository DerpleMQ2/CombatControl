local mq = require('mq')

local State = {
    inCombat = false,
    hp = {},
    mana = {},
    dps = {},
    maxSamples = 120,
}

local function push(tbl, val, max)
    table.insert(tbl, val)
    if #tbl > max then table.remove(tbl, 1) end
end

function State.update()
    State.inCombat = mq.TLO.Me.Combat()
    push(State.hp, mq.TLO.Me.PctHPs() or 0, State.maxSamples)
    push(State.mana, mq.TLO.Me.PctMana() or 0, State.maxSamples)
end

return State
