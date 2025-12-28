local ImGui = require('ImGui')

local UI = { open = true }

function UI.Draw(State, classModule)
    if not UI.open then return end

    ImGui.Begin('CombatControl', true)

    if ImGui.BeginTabBar('##tabs') then
        if ImGui.BeginTabItem('Overview') then
            ImGui.Text('Class: ' .. classModule.ClassName)
            ImGui.Text('Combat: ' .. (State.inCombat and 'YES' or 'NO'))
            ImGui.PlotLines('HP %', State.hp, #State.hp, 0, nil, 0, 100, 200, 60)
            ImGui.PlotLines('Mana %', State.mana, #State.mana, 0, nil, 0, 100, 200, 60)
            ImGui.PlotLines('DPS', State.dps, #State.dps, 0, nil, 0, 0, 200, 60)
            ImGui.EndTabItem()
        end

        if ImGui.BeginTabItem('Class Options') then
            classModule.DrawUI()
            ImGui.EndTabItem()
        end

        ImGui.EndTabBar()
    end

    ImGui.End()
end

return UI
