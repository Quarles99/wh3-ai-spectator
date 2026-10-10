# Determinism rules

Reports from the community indicate desyncs come from scripts that behave differently per client (e.g. per-client RNG) and from mismatched mod files. The game's sync model is not documented in anything I found, so these rules are conservative inference.

1. Decisions use only shared battle state. No UI state, "is host/local player" branches, or real-time clocks.
2. No `math.random`. Use `det.rng` seeded from battle state.
3. Schedule on battle-time callbacks, not wall-clock.
4. Never rely on `pairs()` order. Use `det.sorted_pairs`.
5. Everyone runs the identical pack/version.
6. Log a per-tick decision hash (`decision_log`) and diff between machines to find the first divergence.
