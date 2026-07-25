package.path = package.path .. ";./tests/?.lua;./addon/ChurchOfBeef/?.lua;./addon/ChurchOfBeef/?/?.lua"

require("wow_stub")

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
  "test_ranks",
  "test_ladder",
  "test_scoring",
  "test_officer",
  "test_net_validate",
}

for _, name in ipairs(suites) do
  local ok, err = pcall(function() require(name) end)
  if not ok then
    -- Suites appear as tasks land; missing suite is OK until created.
    if not tostring(err):find("module '" .. name .. "' not found") then
      failed = failed + 1
      print("FAIL suite " .. name .. ": " .. tostring(err))
    end
  end
end

print(string.format("Tests finished: %d passed, %d failed", passed, failed))
if failed > 0 then os.exit(1) end
