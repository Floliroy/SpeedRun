Speedrun = Speedrun or {}
local Speedrun = Speedrun
local sV
local cV
function Speedrun.CombatAS()
  if IsUnitInCombat("player") then
    for i = 1, MAX_BOSSES do
      if DoesUnitExist("boss" .. i) then
        local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
        if maxTargetHP > 99000000 then
          -- zo_strformat("<<C:1>>", GetUnitName('boss1'))
          Speedrun.currentBossName = string.lower(GetUnitName("boss" .. i))
          sV.currentBossName       = Speedrun.currentBossName
          Speedrun.inCombat        = true

          zo_callLater(function()
            EM:UnregisterForUpdate(Speedrun.name .. "CombatEnded")
            EM:RegisterForUpdate(Speedrun.name .. "CombatEnded", 4000, Speedrun.OnCombatEnd)
          end, 1000)
        end
      end
    end
  end
end

function Speedrun.MainAsylum()
  for i = 1, MAX_BOSSES do
    if DoesUnitExist("boss" .. i) then
      local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
      local percentageHP = currentTargetHP / maxTargetHP
      --start fight with boss
      if Speedrun.inCombat and Speedrun.isBossDead == true then
        --Olms got more than 99Million HP
        if (Speedrun.Step == 1 and maxTargetHP >= 99000000) then Speedrun.UpdateWaypointNew(GetRaidDuration()) end
        if (percentageHP <= 0.9 and Speedrun.Step == 2) then Speedrun.UpdateWaypointNew(GetRaidDuration()) end
        if (percentageHP <= 0.75 and Speedrun.Step == 3) then Speedrun.UpdateWaypointNew(GetRaidDuration()) end
        if (percentageHP <= 0.5 and Speedrun.Step == 4) then Speedrun.UpdateWaypointNew(GetRaidDuration()) end
        if (percentageHP <= 0.25 and Speedrun.Step == 5) then Speedrun.UpdateWaypointNew(GetRaidDuration()) end
        -- else
        --   if (currentTargetHP > 0 and Speedrun.Step <= 6) then
        --     Speedrun.currentRaidTimer = {}
        --     sV.currentRaidTimer = Speedrun.currentRaidTimer
        --     Speedrun.Step = 1
        --     sV.Step = Speedrun.Step
        --   elseif currentTargetHP <= 0 then
        --     -- not in HM
        --     Speedrun.isBossDead = false
        --     sV.isBossDead = Speedrun.isBossDead
        -- end
      end
    end
  end
end
