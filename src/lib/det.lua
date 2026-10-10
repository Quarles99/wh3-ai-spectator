-- Deterministic helpers. Pure Lua 5.1; integer math kept below 2^53.
local det = {}

local MOD = 2147483647 -- 2^31 - 1

-- Sorted keys (numbers before strings, then natural order).
function det.sorted_keys(t)
  local keys = {}
  for k in pairs(t) do keys[#keys + 1] = k end
  table.sort(keys, function(a, b)
    local ta, tb = type(a), type(b)
    if ta ~= tb then return ta < tb end
    return a < b
  end)
  return keys
end

-- Iterator over t in stable key order.
function det.sorted_pairs(t)
  local keys, i = det.sorted_keys(t), 0
  return function()
    i = i + 1
    local k = keys[i]
    if k ~= nil then return k, t[k] end
  end
end

-- Hash a string to [0, MOD).
function det.hash_string(s, h)
  h = h or 7
  for i = 1, #s do h = (h * 31 + s:byte(i)) % MOD end
  return h
end

-- Fold integers into a hash.
function det.hash_ints(h, ...)
  for _, n in ipairs({ ... }) do
    h = (h * 31 + (math.floor(n) % MOD)) % MOD
  end
  return h
end

-- Park-Miller RNG. Seed from shared battle state (e.g. det.hash_ints(...)).
function det.rng(seed)
  local state = seed % MOD
  if state == 0 then state = 1 end
  local r = {}
  function r.next()
    state = (state * 16807) % MOD
    return state
  end
  function r.float() return r.next() / MOD end
  function r.range(lo, hi) return lo + (r.next() % (hi - lo + 1)) end
  return r
end

return det
