-- CombatControl/main.lua
local mq      = require('mq')
local ImGui   = require('ImGui')

local State   = require('CombatControl.state')
local UI      = require('CombatControl.ui')

local running = true
local myClass = mq.TLO.Me.Class.ShortName()

local function loadClass()
    local ok, mod = pcall(require, 'CombatControl.classes.' .. myClass)
    if ok and mod then
        print('[CombatControl] Loaded class: ' .. myClass)
        return mod
    end
    return require('CombatControl.classes.DEFAULT')
end

local classModule = loadClass()

mq.imgui.init('RGMercsUI', function() return UI.Draw(State, classModule) end)


while running do
    mq.doevents()
    State.update()

    if State.inCombat then
        classModule.CombatPulse(State)
    else
        classModule.IdlePulse(State)
    end

    mq.delay(50)
end
