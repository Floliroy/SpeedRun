Speedrun = Speedrun or {}
local Speedrun = Speedrun
local sV
function Speedrun.MiniBossDead(eventCode, scoreUpdateReason, scoreAmount, totalScore)
  sV = Speedrun.savedVariables
  local timer

  if scoreUpdateReason == RAID_POINT_REASON_KILL_MINIBOSS and Speedrun.Step == 5 then
    if (Speedrun.raidID == 1344 and Speedrun.Step == 6) then return end

    timer = (GetRaidDuration() - Speedrun.fightBegin) / 1000

    Speedrun:dbg(2, "|cffffff<<1>>|r fight time: |cffffff<<2>>|r!", Speedrun.currentBossName,
      Speedrun.FormatTimerForChatUpdate(timer))


    for i = 1, MAX_BOSSES do
      if DoesUnitExist("boss" .. i) then

        local name = GetUnitName("boss" .. i)
        if string.lower(name) == Speedrun.currentBossName then
          local currentTargetHP, _, _ = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
          if currentTargetHP > 0 then
            return
          else
            Speedrun.lastBossName    = Speedrun.currentBossName
            sV.lastBossName          = Speedrun.lastBossName
            Speedrun.currentBossName = ""
            sV.currentBossName       = Speedrun.currentBossName
            Speedrun.isBossDead      = true
            sV.isBossDead            = Speedrun.isBossDead
            Speedrun.UpdateWaypointNew(GetRaidDuration())
          end
        end
      end
    end

  end
end
