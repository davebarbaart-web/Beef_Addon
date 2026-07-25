-- Thin Gora and ceremony stubs: the Core ledgers plus the My Standing strip that
-- drives them. Widget behaviour comes from tests/wow_ui_stub.lua, so this proves
-- routing, refusals and payouts only — the in-game feel still needs the client.
local stub = require("wow_ui_stub")
local restore = stub.install()

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Ladder.lua")
dofile("addon/ChurchOfBeef/Core/Scoring.lua")
dofile("addon/ChurchOfBeef/Core/Officer.lua")
dofile("addon/ChurchOfBeef/Core/Gora.lua")
dofile("addon/ChurchOfBeef/Core/Ceremony.lua")
dofile("addon/ChurchOfBeef/Core/DB.lua")

local COB = ChurchOfBeef
local Points = COB.Scoring.Points

local function reset()
  COB.Ladder:ResetForTests()
  COB.Scoring:ResetForTests()
  COB.Gora:ResetForTests()
  COB.Ceremony:ResetForTests()
end

local function standingOf(name)
  return COB.Ladder:GetRecord(name).standing
end

ChurchOfBeefDB = nil
COB.DB:Init()
reset()

--------------------------------------------------------------------------------
-- Gora: a recorded result pays both combatants
--------------------------------------------------------------------------------
local result = COB.Gora:RecordResult("Beefina", "Steakina", "win", 1)
assert_true(result ~= nil, "a win is recorded")
assert_eq(result.winnerPoints, Points.GoraWin, "the winner is paid the win grant")
assert_eq(result.loserPoints, Points.GoraLoss, "losses must pay")
assert_eq(result.loserPoints, 8, "the loss grant is 8 standing")
assert_eq(result.outcome, "win", "the outcome is echoed back")
assert_eq(result.challenged, false, "an unchallenged duel still records")
assert_eq(standingOf("Beefina"), 25, "the winner's standing rose")
assert_eq(standingOf("Steakina"), 8, "the loser's standing rose too")

-- Win is the default because the parameters already name the winner.
result = COB.Gora:RecordResult("Beefina", "Chuckina", nil, 1)
assert_eq(result.outcome, "win", "outcome defaults to win")
assert_eq(standingOf("Chuckina"), 8, "the defaulted result still pays the loser")

--------------------------------------------------------------------------------
-- Gora: a draw pays both sides the draw grant
--------------------------------------------------------------------------------
reset()
result = COB.Gora:RecordResult("Beefina", "Steakina", "draw", 1)
assert_eq(result.winnerPoints, Points.GoraDraw, "a draw pays the first combatant the draw grant")
assert_eq(result.loserPoints, Points.GoraDraw, "a draw pays the second combatant the same")
assert_eq(standingOf("Beefina"), 10, "draw standing landed on the ladder")
assert_eq(standingOf("Steakina"), 10, "both draw grants landed")

--------------------------------------------------------------------------------
-- Gora: refusals
--------------------------------------------------------------------------------
reset()
assert_eq(select(1, COB.Gora:RecordResult(nil, "Steakina")), nil, "a missing winner is refused")
assert_eq(select(1, COB.Gora:RecordResult("Beefina", "")), nil, "an empty loser is refused")
assert_eq(select(1, COB.Gora:RecordResult("Beefina", "Beefina")), nil, "nobody fights themselves")
assert_eq(select(1, COB.Gora:RecordResult("Beefina", "beefina")), nil,
  "the self check ignores capitalisation")

local refused, why = COB.Gora:RecordResult("Beefina", "Steakina", "loss")
assert_eq(refused, nil, "'loss' is not an outcome: the winner is named first")
assert_true(why:find("naming the winner first", 1, true) ~= nil, "the refusal says how to record a loss")
assert_eq(standingOf("Beefina"), 0, "a refused result pays nobody")
assert_eq(select(1, COB.Gora:RecordResult("Beefina", "Steakina", "victory")), nil,
  "an unknown outcome is refused")

--------------------------------------------------------------------------------
-- Gora: the loser is paid even when the winner's daily cap is spent
--------------------------------------------------------------------------------
reset()
local cap = COB.Scoring.DailyCaps.gora
for _ = 1, math.floor(cap / Points.GoraWin) do
  COB.Gora:RecordResult("Beefina", "Filler", "win", 1)
end
assert_eq(COB.Scoring:GetRemaining("Beefina", "gora", 1), 0, "the winner has spent the daily gora cap")

result = COB.Gora:RecordResult("Beefina", "Steakina", "win", 1)
assert_eq(result.winnerPoints, 0, "a capped winner earns nothing more today")
assert_eq(result.loserPoints, Points.GoraLoss, "the loser is paid regardless of the winner's cap")
assert_eq(standingOf("Steakina"), 8, "the loser's standing still moved")

--------------------------------------------------------------------------------
-- Gora: challenges are notes that a recorded result clears
--------------------------------------------------------------------------------
reset()
local challenge = COB.Gora:Challenge("Steakina", "Beefina", 100)
assert_true(challenge ~= nil, "a challenge is opened")
assert_eq(challenge.challenger, "Beefina", "the challenger is recorded")
assert_eq(challenge.target, "Steakina", "the target is recorded")
assert_eq(COB.Gora:IsChallenged("Beefina", "Steakina"), true, "the pair is challenged")
assert_eq(COB.Gora:IsChallenged("Steakina", "Beefina"), true, "direction does not matter")
assert_eq(#COB.Gora:GetPending(100), 1, "one challenge is pending")

-- Either combatant may report, so the result clears the pair's challenge.
result = COB.Gora:RecordResult("Steakina", "Beefina", "win", 101)
assert_eq(result.challenged, true, "the recorded result matched an open challenge")
assert_eq(#COB.Gora:GetPending(101), 0, "recording the result clears the challenge")

assert_eq(select(1, COB.Gora:Challenge("Beefina", "Beefina")), nil, "nobody challenges themselves")
assert_eq(select(1, COB.Gora:Challenge("", "Beefina")), nil, "an empty target is refused")

COB.Gora:Challenge("Steakina", "Beefina", 200)
assert_eq(COB.Gora:Cancel("Steakina", "Beefina"), true, "a challenge can be withdrawn")
assert_eq(COB.Gora:Cancel("Steakina", "Beefina"), false, "withdrawing twice is a no-op")

-- Trash talk nobody follows through on must not accumulate forever.
COB.Gora:Challenge("Steakina", "Beefina", 300)
assert_eq(#COB.Gora:GetPending(300), 1, "the challenge is live inside its window")
assert_eq(#COB.Gora:GetPending(300 + 3600), 0, "a stale challenge expires")

--------------------------------------------------------------------------------
-- Ceremony: only an officer may start or close one
--------------------------------------------------------------------------------
reset()
local flock = { "Beefina", "Steakina", "Chuckina" }

stub.guildRankIndex = 5
assert_eq(select(1, COB.Ceremony:Start("Ascension", flock, 1)), nil, "a member cannot start a ceremony")
assert_eq(COB.Ceremony:IsActive(), false, "the refused ceremony did not open")

stub.guildRankIndex = 0
local started = COB.Ceremony:Start("Ascension", flock, 1)
assert_true(started ~= nil, "an officer starts the ceremony")
assert_eq(started.label, "Ascension", "the label is kept")
assert_eq(#started.tracked, 3, "everyone present at the start is tracked")
assert_eq(COB.Ceremony:IsActive(), true, "the ceremony is under way")
assert_eq(select(1, COB.Ceremony:Start("Second", flock, 1)), nil, "two ceremonies cannot overlap")

stub.guildRankIndex = 5
assert_eq(select(1, COB.Ceremony:Close(flock, 2)), nil, "a member cannot close a ceremony")
assert_eq(COB.Ceremony:IsActive(), true, "the refused close left the ceremony open")
assert_eq(standingOf("Beefina"), 0, "a refused close granted nothing")
stub.guildRankIndex = 0

--------------------------------------------------------------------------------
-- Ceremony: a clean close grants everyone who attended and stayed
--------------------------------------------------------------------------------
local closed = COB.Ceremony:Close(flock, 2)
assert_true(closed ~= nil, "the officer closes the ceremony")
assert_eq(#closed.attendees, 3, "all three attendees are credited")
assert_eq(closed.attendees[1].points, Points.Ceremony, "an attendee is paid the ceremony grant")
assert_eq(closed.total, 3 * Points.Ceremony, "the total is reported")
assert_eq(standingOf("Beefina"), Points.Ceremony, "ceremony standing landed on the ladder")
assert_eq(standingOf("Chuckina"), Points.Ceremony, "every attendee's standing landed")
assert_eq(COB.Ceremony:IsActive(), false, "closing ends the ceremony")
assert_eq(select(1, COB.Ceremony:Close(flock, 3)), nil, "closing twice is refused")

--------------------------------------------------------------------------------
-- Ceremony: who does not get paid
--------------------------------------------------------------------------------
reset()
COB.Ceremony:Start("Vigil", {
  { name = "Beefina" },
  { name = "Steakina" },
  { name = "Pugina", inGuild = false },
  { name = "Nappina", afk = true },
  { name = "Leaverina" },
}, 1)

local active = COB.Ceremony:GetActive()
assert_eq(#active.tracked, 3, "non-guildmates and AFK flesh are never tracked")
assert_eq(standingOf("Pugina"), 0, "starting a ceremony grants nothing by itself")

closed = COB.Ceremony:Close({
  { name = "Beefina" },
  { name = "Steakina", afk = true },
  { name = "Pugina", inGuild = false },
  { name = "Latina" },
}, 2)

assert_eq(#closed.attendees, 1, "only the attendee who stayed and was awake is credited")
assert_eq(closed.attendees[1].name, "Beefina", "the credited attendee is the one who stayed")
assert_eq(standingOf("Beefina"), Points.Ceremony, "the faithful attendee is paid")
assert_eq(standingOf("Steakina"), 0, "going AFK before the close forfeits the credit")
assert_eq(standingOf("Leaverina"), 0, "leaving before the close forfeits the credit")
assert_eq(standingOf("Pugina"), 0, "a non-guildmate never earns church standing")
assert_eq(standingOf("Latina"), 0, "arriving only for the closing second earns nothing")
assert_eq(closed.latecomers, 1, "the close reports who wandered in at the end")

--------------------------------------------------------------------------------
-- Ceremony: Mark folds a mid-rite arrival into the tracked set
--------------------------------------------------------------------------------
reset()
COB.Ceremony:Start("Procession", { "Beefina" }, 1)
assert_eq(COB.Ceremony:Mark({ "Beefina", "Steakina" }, 2), 1, "one new face joined mid-rite")
assert_eq(COB.Ceremony:Mark({ "Beefina", "Steakina" }, 3), 0, "re-sampling the same group adds nobody")

closed = COB.Ceremony:Close({ "Beefina", "Steakina" }, 4)
assert_eq(#closed.attendees, 2, "the mid-rite arrival is credited")
assert_eq(standingOf("Steakina"), Points.Ceremony, "the marked attendee was paid")

assert_eq(COB.Ceremony:Mark({ "Beefina" }, 5), 0, "marking outside a ceremony does nothing")

--------------------------------------------------------------------------------
-- Ceremony: cancelling pays nobody; the daily cap still bites
--------------------------------------------------------------------------------
reset()
COB.Ceremony:Start("Abandoned", flock, 1)
assert_eq(COB.Ceremony:Cancel(), true, "an officer can abandon a ceremony")
assert_eq(COB.Ceremony:IsActive(), false, "cancelling ends it")
assert_eq(standingOf("Beefina"), 0, "an abandoned ceremony pays nobody")
assert_eq(COB.Ceremony:Cancel(), false, "cancelling nothing is a no-op")

local ceremonyCap = COB.Scoring.DailyCaps.ceremony
for i = 1, 3 do
  COB.Ceremony:Start("Rite " .. i, { "Beefina" }, 1)
  COB.Ceremony:Close({ "Beefina" }, 1)
end
assert_eq(standingOf("Beefina"), ceremonyCap, "ceremony grants stop at the daily cap")

--------------------------------------------------------------------------------
-- Ceremony: the live party/raid sampler is what runs in game
--------------------------------------------------------------------------------
reset()
stub.playerName = "Popeina"
stub.groupSize = 4
stub.group = {
  party1 = { name = "Steakina" },
  party2 = { name = "Pugina", inGuild = false },
  party3 = { name = "Nappina", afk = true },
}

started = COB.Ceremony:Start("Party rite", nil, 1)
assert_eq(#started.tracked, 2, "the live sampler keeps the officiant and the awake guildmate")
assert_eq(started.tracked[1], "Popeina", "the officiant attends their own ceremony")
assert_eq(started.tracked[2], "Steakina", "the guildmate in the party attends")
COB.Ceremony:Close(nil, 2)
assert_eq(standingOf("Popeina"), Points.Ceremony, "the officiant is credited")
assert_eq(standingOf("Steakina"), Points.Ceremony, "the party guildmate is credited")
assert_eq(standingOf("Pugina"), 0, "the pug is not")

-- Raid unit ids include the player, so the sampler must not pay them twice.
reset()
stub.inRaid = true
stub.groupSize = 2
stub.group = {
  raid1 = { name = "Popeina" },
  raid2 = { name = "Steakina" },
}
started = COB.Ceremony:Start("Raid rite", nil, 1)
assert_eq(#started.tracked, 2, "the officiant is sampled once in a raid")
COB.Ceremony:Close(nil, 2)
assert_eq(standingOf("Popeina"), Points.Ceremony, "the officiant is paid once")

stub.inRaid = false
stub.groupSize = 0
stub.group = {}

--------------------------------------------------------------------------------
-- My Standing strip: the buttons call Core and report what Core decided
--------------------------------------------------------------------------------
reset()
dofile("addon/ChurchOfBeef/UI/MainFrame.lua")
dofile("addon/ChurchOfBeef/UI/Announce.lua")
dofile("addon/ChurchOfBeef/UI/LadderTab.lua")
dofile("addon/ChurchOfBeef/UI/StandingTab.lua")
dofile("addon/ChurchOfBeef/UI/OfficerTab.lua")
dofile("addon/ChurchOfBeef/UI/Minimap.lua")
dofile("addon/ChurchOfBeef/UI/Toasts.lua")

local Tab = COB.StandingTab
stub.playerName = "Beefina"
stub.guildRankIndex = 5 -- a plain member drives the Gora half

COB.UI:Init()
COB.UI:Show()
assert_eq(COB.UI:ShowTab("standing"), "standing", "the standing tab activates")

assert_eq(Tab.record:GetText(), "Record Gora Result", "the Gora button is labelled")
assert_eq(Tab.ceremony:GetText(), "Start Ceremony", "the ceremony button starts in Start")
assert_eq(Tab.outcome:GetText(), "I won", "the outcome stepper starts on a win")

-- No opponent: refuse before anything reaches Core.
assert_eq(stub.fire(Tab.record, "OnClick"), true, "the Gora button is wired")
assert_eq(Tab.statusText, "name the member you fought", "an empty opponent is refused")
assert_true(Tab.status:GetText():find("Refused", 1, true) ~= nil, "the refusal is dual-encoded")
assert_eq(standingOf("Beefina"), 0, "the refused click granted nothing")

-- Recording a loss pays 8: the whole point of showing up for the spectacle.
Tab.opponent:SetText("Steakina")
assert_eq(Tab:CycleOutcome(), "lost", "the stepper moves to a loss")
assert_eq(Tab.outcome:GetText(), "I lost", "the stepper label follows")
stub.fire(Tab.record, "OnClick")
assert_eq(standingOf("Beefina"), Points.GoraLoss, "recording a loss grants 8 standing")
assert_eq(standingOf("Steakina"), Points.GoraWin, "the named opponent is credited with the win")
assert_true(Tab.statusText:find("+8 standing (loss)", 1, true) ~= nil, "the status names the payout")
assert_eq(COB.Toasts.frame.text:GetText(), "Gora loss: +8 standing", "credit is toasted privately")
assert_true(Tab.history[1]:GetText():find("+8 gora", 1, true) ~= nil, "the strip refreshed the history")

assert_eq(Tab:CycleOutcome(), "draw", "the stepper reaches a draw")
stub.fire(Tab.record, "OnClick")
assert_eq(standingOf("Beefina"), Points.GoraLoss + Points.GoraDraw, "a draw pays the draw grant")
assert_eq(Tab:CycleOutcome(), "won", "the stepper wraps back to a win")
stub.fire(Tab.record, "OnClick")
assert_eq(standingOf("Beefina"), Points.GoraLoss + Points.GoraDraw + Points.GoraWin,
  "a win pays the win grant")

--------------------------------------------------------------------------------
-- My Standing strip: the ceremony button is an officer control
--------------------------------------------------------------------------------
assert_eq(Tab.ceremony:IsEnabled(), false, "a member cannot press the ceremony button")
stub.fire(Tab.ceremony, "OnClick")
assert_eq(Tab.statusText, "only an officer may start a ceremony", "Core refuses a member outright")
assert_eq(COB.Ceremony:IsActive(), false, "no ceremony opened")

reset()
stub.guildRankIndex = 0
COB.UI:MarkDirty("standing")
assert_eq(Tab.ceremony:IsEnabled(), true, "an officer may press the ceremony button")

stub.groupSize = 2
stub.group = { party1 = { name = "Steakina" } }
stub.fire(Tab.ceremony, "OnClick")
assert_eq(COB.Ceremony:IsActive(), true, "the button starts the ceremony")
assert_eq(Tab.ceremony:GetText(), "Close Ceremony", "the button flips to Close while it runs")
assert_true(Tab.statusText:find("2 present", 1, true) ~= nil, "the status counts who is present")
assert_eq(standingOf("Beefina"), 0, "starting alone grants nothing")

stub.fire(Tab.ceremony, "OnClick")
assert_eq(COB.Ceremony:IsActive(), false, "the button closes the ceremony")
assert_eq(Tab.ceremony:GetText(), "Start Ceremony", "the button flips back")
assert_eq(standingOf("Beefina"), Points.Ceremony, "closing credits the officiant")
assert_eq(standingOf("Steakina"), Points.Ceremony, "closing credits the attendee")
assert_true(Tab.statusText:find("2 attendee(s) credited", 1, true) ~= nil,
  "the status reports the credited attendees")

stub.groupSize = 0
stub.group = {}
COB.Toasts:HideAll()
restore()
