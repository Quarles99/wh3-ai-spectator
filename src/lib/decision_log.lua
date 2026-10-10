-- Per-tick decision hash chain. Compare `chain` across clients to find the
-- first tick where decisions diverged.
local M = {}

function M.new(det_lib)
  local log = { chain = 17, entries = {} }
  function log.record(tick, label)
    log.chain = det_lib.hash_string(label, det_lib.hash_ints(log.chain, tick))
    log.entries[#log.entries + 1] = { tick = tick, label = label, chain = log.chain }
  end
  return log
end

return M
