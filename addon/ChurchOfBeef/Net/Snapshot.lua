ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Snapshot request / response apply (Bible §20.3, §13.1). Catch-up is not
-- peer SYNC: congregation Request(); only a Pope client BuildResponse().
-- This file encodes and Restores. It does not send, whisper, or route.
local Snapshot = {}
COB.Snapshot = Snapshot

local BIBLE = { "eventId", "state", "riteType", "subjects", "sequence" }

local function bibleFields(src)
  local out = {}
  for i = 1, #BIBLE do
    local key = BIBLE[i]
    out[key] = src[key]
  end
  return out
end

function Snapshot:Request()
  return COB.Codec:EncodeSnapshot({ role = "request" })
end

function Snapshot:BuildResponse()
  local snap = COB.Runtime:Snapshot()
  if snap.state == "QUIET" then
    return nil, "no event"
  end
  local fields = bibleFields(snap)
  fields.role = "response"
  return COB.Codec:EncodeSnapshot(fields)
end

function Snapshot:ApplyResponse(blob)
  local msg, err = COB.Codec:DecodeSnapshot(blob)
  if not msg then return nil, err end
  if not COB.Codec:IsCompatible(msg.version) then
    return nil, "protocol mismatch"
  end
  if msg.role ~= "response" then
    return nil, "invalid role"
  end
  return COB.Runtime:Restore(bibleFields(msg))
end
