package.path = package.path .. ";./tests/?.lua;./addon/ChurchOfBeef/?.lua;./addon/ChurchOfBeef/?/?.lua"

require("wow_stub")

-- Suites need the test-only escape hatches (ResetForTests); the addon never sets this.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

-- Loads first in the TOC and first here for the same reason: every Core module reads
-- the shared identity law and clocks from it, so no suite has to remember to load it.
dofile("addon/ChurchOfBeef/Core/Common.lua")

-- Same reasoning for the design system: every dressed surface reads palette, fonts,
-- and textures from Theme, so suites never load it themselves.
dofile("addon/ChurchOfBeef/UI/Theme.lua")

local failed = 0
local passed = 0

function assert_eq(a, b, msg)
  if a ~= b then
    failed = failed + 1
    print("FAIL: " .. (msg or "") .. " expected " .. tostring(b) .. " got " .. tostring(a))
  else
    passed = passed + 1
  end
end

function assert_true(v, msg)
  assert_eq(not not v, true, msg)
end

-- Individual suites register themselves by calling their file when required.
local suites = {
  "test_common",
  "test_theme",
  "test_ranks",
  "test_roster",
  "test_officer",
  "test_sender",
  "test_db",
  "test_store",
  "test_archive",
  "test_recognition",
  "test_knighting",
  "test_runtime",
  "test_net_validate",
  "test_net_codec",
  "test_net_snapshot",
  "test_net_adversarial",
  "test_net_v2",
  "test_ceremony_chaos",
  "test_ui",
  "test_console",
  "test_console_dock",
  "test_hud",
  "test_fighter_card",
  "test_inputs",
  "test_markers",
  "test_records",
  "test_minimap",
  "test_gora",
  "test_confession",
  "test_gora_ceremony",
  "test_decree",
  "test_decree_ui",
  "test_sound",
  "test_wire_glue",
}

--------------------------------------------------------------------------------
-- Nothing is allowed to disappear quietly
--------------------------------------------------------------------------------
-- A missing suite used to be tolerated ("suites appear as tasks land"), which meant
-- deleting or renaming a test file turned the whole thing green. The list above is
-- now a contract in both directions: every name must load, and every test_*.lua on
-- disk must be listed.

local listed = {}
for _, name in ipairs(suites) do listed[name] = true end

local function discoveredSuites()
  local ok, pipe = pcall(io.popen, "ls tests/test_*.lua 2>/dev/null")
  if not ok or not pipe then return nil end
  local found = {}
  for line in pipe:lines() do
    local name = line:match("([^/]+)%.lua$")
    if name then found[#found + 1] = name end
  end
  pipe:close()
  return found
end

local discovered = discoveredSuites()
if discovered then
  for _, name in ipairs(discovered) do
    if not listed[name] then
      failed = failed + 1
      print("FAIL runner: tests/" .. name .. ".lua exists but is not in run.lua's suite list")
    end
  end
end

--------------------------------------------------------------------------------
-- Run
--------------------------------------------------------------------------------
-- A suite that raises loses the rest of its own assertions, but must not take the
-- other suites with it: each is pcall'd, and the count it reached is reported so an
-- abort halfway through cannot masquerade as a small suite.

local aborted = {}

for _, name in ipairs(suites) do
  -- Force the flag before every suite load so an earlier suite flipping it
  -- (then raising before it restores) can never poison a later suite.
  ChurchOfBeef._IN_TEST = true

  local before = passed + failed
  local ok, err = pcall(function() require(name) end)
  local ran = (passed + failed) - before

  if not ok then
    failed = failed + 1
    aborted[#aborted + 1] = name
    if tostring(err):find("module '" .. name .. "' not found", 1, true) then
      print("FAIL suite " .. name .. ": missing — tests/" .. name .. ".lua is listed but not on disk")
    else
      print(string.format("FAIL suite %s: aborted after %d assertions: %s", name, ran, tostring(err)))
    end
  end
end

if #aborted > 0 then
  print("Aborted suites: " .. table.concat(aborted, ", "))
end

print(string.format("Tests finished: %d passed, %d failed", passed, failed))
if failed > 0 then os.exit(1) end
