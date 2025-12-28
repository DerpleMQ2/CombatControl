local mq = require('mq')
local WAR = { ClassName = 'Warrior', settings = { autoTaunt = true } }

function WAR.CombatPulse(State)
    if WAR.settings.autoTaunt then mq.cmd('/taunt on') end
end

function WAR.IdlePulse(State) end

function WAR.DrawUI()
    WAR.settings.autoTaunt = ImGui.Checkbox('Auto Taunt', WAR.settings.autoTaunt)
end

return WAR
