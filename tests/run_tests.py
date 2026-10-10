#!/usr/bin/env python3
"""Out-of-game tests for the pure-Lua modules. Requires: pip install lupa"""
import sys
from pathlib import Path
from lupa import LuaRuntime

ROOT = Path(__file__).resolve().parent.parent
lua = LuaRuntime(unpack_returned_tuples=True)

def load(rel):
    return lua.eval("function(src) return loadstring and loadstring(src) or load(src) end")(
        (ROOT / rel).read_text())()

det = load("src/lib/det.lua")
dlog = load("src/lib/decision_log.lua")
assess = load("src/ai/assess.lua")

failures = 0
def check(name, cond):
    global failures
    print(("ok   " if cond else "FAIL ") + name)
    if not cond: failures += 1

# sorted_pairs is order-stable
t = lua.table_from({"b": 2, "a": 1, "c": 3})
order = list(det.sorted_keys(t).values())
check("sorted_pairs order", order == ["a", "b", "c"])

# rng deterministic and in range
r1, r2 = det.rng(12345), det.rng(12345)
seq1 = [r1.range(1, 6) for _ in range(50)]
seq2 = [r2.range(1, 6) for _ in range(50)]
check("rng reproducible", seq1 == seq2)
check("rng in range", all(1 <= x <= 6 for x in seq1))

# hash stable and sensitive
h = det.hash_string("attack:12")
check("hash stable", h == det.hash_string("attack:12"))
check("hash sensitive", h != det.hash_string("attack:13"))

# decision log chains identically for identical decisions, diverges otherwise
a, b = dlog.new(det), dlog.new(det)
for tick, label in [(1, "move:3"), (2, "attack:7")]:
    a.record(tick, label); b.record(tick, label)
check("decision chains match", a.chain == b.chain)
b.record(3, "retreat:1"); a.record(3, "attack:1")
check("decision chains diverge", a.chain != b.chain)

# assessment
def army(*pairs): return lua.table_from([lua.table_from({"hp": hp, "dmg": d}) for hp, d in pairs])
big, small = army((100, 10), (100, 10)), army((50, 10))
check("ratio", assess.ratio(big, small) == 4)
check("stance aggressive", assess.stance(4) == "aggressive")
check("stance defensive", assess.stance(0.5) == "defensive")
check("stance balanced", assess.stance(1.0) == "balanced")

sys.exit(1 if failures else 0)
