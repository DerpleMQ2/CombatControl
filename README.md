# CombatControl

**CombatControl** is a modular, plug-and-play combat control and visualization framework
for **MacroQuest (EverQuest)** written in Lua.

## Features
- Automatic class detection
- Modular class logic (drop-in support)
- ImGui UI with live charts (HP, Mana, DPS)
- Designed to complement CWTN / RGMercs

## Installation
1. Copy the `CombatControl` folder into your MQ `lua/` directory
2. Run with:
   ```
   /lua run CombatControl/main.lua
   ```

## Extending
Add new class files under `classes/` using the same interface:
- CombatPulse(State)
- IdlePulse(State)
- DrawUI()

## License
MIT
