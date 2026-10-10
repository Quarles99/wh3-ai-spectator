# Plan

Based on community sources, not the live game. **Verify every API against the game's own `lib_battle_script_ai_planner.lua`** and the current patch.

## Phase 0: Reconnaissance
- Unpack AI General 3 / AI Army Control to study (do not copy code).
- Read `lib_battle_script_ai_planner.lua`. Confirm how a battle script is loaded from a mod pack.
- Confirm how to mark an army AI-controlled before battle.

## Phase 1: Minimal working mod
- At battle start attach a planner to each alliance; free camera; hide command UI.
- Test in single-player custom battles.

## Phase 2: Deterministic architecture (multiplayer foundation)
See `DETERMINISM.md`. Already scaffolded: `det.lua`, `decision_log.lua`.

## Phase 3: Smarter AI
Battle assessment, role assignment, focus fire, flank timing, retreat/rally, abilities (per faction, last), fixed shared personality profiles.

## Phase 4: Spectator features
Free camera, speed controls, optional status panel. Client-only UI must never feed back into decisions.

## Phase 5: Multiplayer test matrix
Same-version 2-4 player battles: land, siege, mixed armies. Repeat many times; desyncs are intermittent.

## Risks
1. Multiplayer determinism (largest).
2. Planner is not the enemy AI; siege behaviour not exposed, planner discouraged for sieges.
3. Sieges / Survival Battles likely stay weak.
4. Patch breakage.
5. "Smart" must be measured: AI-vs-AI harness comparing win rates against stock planner.
