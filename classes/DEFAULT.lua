local DEFAULT = { ClassName = 'Generic' }
function DEFAULT.CombatPulse(State) end
function DEFAULT.IdlePulse(State) end
function DEFAULT.DrawUI()
    ImGui.Text('No class module loaded.')
end
return DEFAULT
