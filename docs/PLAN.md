# Plan

Phase 0 findings below come from the game's own scripts (`data_script.pack`, WH3 as installed 2026-10-10). Nothing has been run in game. Still verify against the live patch.

## Phase 0: Reconnaissance (mostly done)
Done, from reading `lib_battle_script_ai_planner.lua`, `lib_battle_manager.lua`, `lib_battle_script_unit.lua`, `lib_mod_loader.lua`, `lib_core.lua`:
- **Loading:** the game loads every `*.lua` in `/script/battle/mod/` (and `/script/_lib/mod/`) at battle script startup (`core:load_mods`). Ship `script/battle/mod/ai_spectator.lua`; do not override `battle_start.lua`. Custom battles use `default_battle/battle_start.lua`, campaign battles `campaign_battle/battle_start.lua`; both just call `load_script_libraries()`.
- **Armies:** `bm:get_scriptunits_for_army(alliance_id, army_id[, reinforcement_idx])`, ids 1-based, alliance 1 or 2. `script_units` are auto-generated.
- **Start hook:** `bm:register_phase_change_callback("Deployed", fn)`.
- **Planner:** `script_ai_planner:new(name, sunits)` makes one native planner per alliance (units must share an alliance). Orders: `attack_unit/force`, `rush_unit/force/position`, `move_to_position/force`, `defend_position/force`, `patrol`, `merge_into`, `release`. There is no flank or retreat order; Phase 3 must build those from move/rush/defend and `release`.
- **Timing:** `bm:callback(fn, ms, name)` runs on a timer synced to the battle model. Planner orders re-issue themselves every 15-30 s by default.

Still open (need an in-game test):
- Are all libraries ready when the mod loader runs the file?
- Do custom and multiplayer battles run battle scripts on every client?
- Does planner control take units from a human player cleanly (`take_control` / `release_control` interplay)?
- Is the `bm:callback` interval really ms (docs say both seconds and ms)?

## Phase 1: Minimal working mod
- At `Deployed`, attach a planner to each alliance; free camera; hide command UI.
- Test in single-player custom battles. Answer the open questions above first.

## Phase 2: Deterministic architecture (multiplayer foundation)
See `DETERMINISM.md`. Already scaffolded: `det.lua`, `decision_log.lua`. Known gaps: `det.sorted_keys` errors on boolean/table keys; `rng.range` does not check `lo <= hi`.

## Phase 3: Smarter AI
Battle assessment, role assignment, focus fire, flank timing, retreat/rally, abilities (per faction, last), fixed shared personality profiles.

## Phase 4: Spectator features
Free camera, speed controls, optional status panel. Client-only UI must never feed back into decisions.

## Phase 5: Multiplayer test matrix
Same-version 2-4 player battles: land, siege, mixed armies. Repeat many times; desyncs are intermittent.

## Risks
1. Multiplayer determinism (largest). `bm:local_alliance()`, `local_army()` and `get_player_*` are per client.
2. Planner is not the enemy AI; siege behaviour not exposed, planner discouraged for sieges.
3. Sieges / Survival Battles likely stay weak.
4. Patch breakage.
5. "Smart" must be measured: AI-vs-AI harness comparing win rates against stock planner.
