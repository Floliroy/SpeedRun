Speedrun = Speedrun or {}
local Speedrun = Speedrun
local sV
local cV
function Speedrun.LastArchive()
    if IsUnitInCombat("player") and Speedrun.Step == 6 then
      for i = 1, MAX_BOSSES do
        if DoesUnitExist("boss" .. i) then
          local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
          if currentTargetHP > 0 then
            Speedrun.UpdateWaypointNew(GetRaidDuration())
            --Unregister for update then register again on update for UI panel
            EM:UnregisterForUpdate(Speedrun.name .. "LastAA")
          end
        end
      end
    end
  end