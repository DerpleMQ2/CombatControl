--=====================================================================
-- CombatControl/classes/SK.lua
-- Shadowknight Combat Module
--
-- Handles:
--  - Aggro via Terror / AE hate
--  - Self lifetaps
--  - Emergency defensives
--  - Optional auto-attack
--
-- Designed to complement (not replace) CWTN / RGMercs
--=====================================================================

local mq    = require('mq')
local ImGui = require('ImGui')

-----------------------------------------------------------------------
-- Module Table
-----------------------------------------------------------------------
local SK    = {
    ClassName = 'Shadowknight',

    settings = {
        autoAttack   = true,
        useTerrors   = true,
        useAETaunt   = true,
        useLifeTaps  = true,
        useDefensive = true,

        lifetapHP    = 70,
        defensiveHP  = 40,
    },
}

-----------------------------------------------------------------------
-- Internal Helpers
-----------------------------------------------------------------------

---Checks whether we can safely cast abilities
---@return boolean
local function canCast()
    return not (
        mq.TLO.Me.Dead() or
        mq.TLO.Me.Feigning() or
        mq.TLO.Me.Stunned() or
        mq.TLO.Me.Silenced() or
        mq.TLO.Me.Charmed()
    )
end

---Attempt to use an AA if ready
---@param aaName string
local function useAA(aaName)
    if mq.TLO.Me.AltAbility(aaName).Ready() then
        mq.cmdf('/alt act %s', mq.TLO.Me.AltAbility(aaName).ID())
        return true
    end
    return false
end

---Attempt to cast a spell by name (if memmed & ready)
---@param spellName string
local function castSpell(spellName)
    if mq.TLO.Me.SpellReady(spellName)() then
        mq.cmdf('/cast "%s"', spellName)
        return true
    end
    return false
end

-----------------------------------------------------------------------
-- Combat Pulse
-----------------------------------------------------------------------
---Called every frame while in combat
---@param State table
function SK.CombatPulse(State)
    if not canCast() then return end

    local meHP = mq.TLO.Me.PctHPs() or 100
    local xt   = mq.TLO.Me.XTarget(1)

    -- Ensure auto-attack
    if SK.settings.autoAttack and not mq.TLO.Me.Combat() then
        mq.cmd('/attack on')
    end

    -- Emergency Defensive
    if SK.settings.useDefensive and meHP <= SK.settings.defensiveHP then
        if useAA('Deflection') then return end
        if useAA('Harmshield') then return end
    end

    -- Lifetap self-healing
    if SK.settings.useLifeTaps and meHP <= SK.settings.lifetapHP then
        if castSpell('Touch of Lutzen') then return end
        if castSpell('Dire Indictment') then return end
    end

    -- Aggro control
    if xt and xt.ID() > 0 then
        -- Single target terror
        if SK.settings.useTerrors then
            if castSpell('Terror of Death') then return end
        end

        -- AE hate for adds
        if SK.settings.useAETaunt then
            useAA('Explosion of Hatred')
        end
    end
end

-----------------------------------------------------------------------
-- Idle Pulse
-----------------------------------------------------------------------
---Called when NOT in combat
---@param State table
function SK.IdlePulse(State)
    -- Placeholder for buffs, stance resets, etc.
end

-----------------------------------------------------------------------
-- UI Rendering
-----------------------------------------------------------------------
---Draw class-specific ImGui controls
function SK.DrawUI()
    ImGui.Text('Shadowknight Settings')
    ImGui.Separator()

    SK.settings.autoAttack =
        ImGui.Checkbox('Auto Attack', SK.settings.autoAttack)

    SK.settings.useTerrors =
        ImGui.Checkbox('Use Terror Spells', SK.settings.useTerrors)

    SK.settings.useAETaunt =
        ImGui.Checkbox('Use AE Hate AAs', SK.settings.useAETaunt)

    SK.settings.useLifeTaps =
        ImGui.Checkbox('Use Lifetaps', SK.settings.useLifeTaps)

    SK.settings.useDefensive =
        ImGui.Checkbox('Use Emergency Defensives', SK.settings.useDefensive)

    ImGui.Separator()
    ImGui.Text('Thresholds')

    SK.settings.lifetapHP =
        ImGui.SliderInt('Lifetap HP %', SK.settings.lifetapHP, 10, 100)

    SK.settings.defensiveHP =
        ImGui.SliderInt('Defensive HP %', SK.settings.defensiveHP, 5, 80)
end

-----------------------------------------------------------------------
return SK
