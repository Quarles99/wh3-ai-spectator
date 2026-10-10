-- Pure battle assessment. Input is plain tables, no game API.
-- unit = { id = number, hp = number, dmg = number, role = string }
local M = {}

local function strength(army)
  local total = 0
  for _, u in ipairs(army) do total = total + u.hp * u.dmg end
  return total
end

-- Returns ratio of side A to side B (>1 means A stronger).
function M.ratio(a, b)
  local sb = strength(b)
  if sb == 0 then return math.huge end
  return strength(a) / sb
end

-- Stance from strength ratio: fixed thresholds, no randomness.
function M.stance(ratio)
  if ratio >= 1.3 then return "aggressive" end
  if ratio <= 0.7 then return "defensive" end
  return "balanced"
end

return M
