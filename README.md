# wh3-ai-spectator

A Total War: WARHAMMER III mod that hands **both sides** of a battle to a smarter AI so you can spectate, built to stay in sync in **multiplayer**.

> **Status: early scaffold. Nothing here has been run inside the game yet.** The pure-Lua helper libraries are unit tested outside the game; the in-game entry point (`src/battle/ai_spectator.lua`) is a stub whose API calls are unverified. See [`docs/PLAN.md`](docs/PLAN.md).

## Goals
1. Do what *AI General 3* does (AI controls the player's army), but better.
2. A "smart" tactical layer on top of the native battle AI planner (roles, focus fire, flank timing, retreat/rally).
3. Deterministic by construction so multiplayer battles do not desync. See [`docs/DETERMINISM.md`](docs/DETERMINISM.md).

## Layout
| Path | Purpose |
|---|---|
| `src/lib/det.lua` | Deterministic helpers: stable iteration, state-derived RNG, hashing |
| `src/lib/decision_log.lua` | Per-tick decision hash chain for diffing logs between clients |
| `src/ai/assess.lua` | Pure battle-state assessment (no game API) |
| `src/battle/ai_spectator.lua` | Game-facing entry point (stub, unverified API) |
| `tests/` | Out-of-game tests (`python3 tests/run_tests.py`, needs `pip install lupa`) |
| `docs/` | Plan and determinism rules |

## Credits / prior art
- [AI General 3](https://steamcommunity.com/sharedfiles/filedetails/?id=2799316652) and [AI Army Control](https://steamcommunity.com/sharedfiles/filedetails/?id=3787823404) show the approach; no code is copied here.
