Speedrun = Speedrun or {}
local Speedrun = Speedrun
local sV
local cV
function Speedrun.MainHRC()
  for i = 1, MAX_BOSSES do
    if DoesUnitExist("boss" .. i) then
      -- zo_strformat("<<C:1>>", GetUnitName('boss1'))
      Speedrun.currentBossName = string.lower(GetUnitName("boss" .. i))
      if (Speedrun.lastBossName == Speedrun.currentBossName) then return end
      if IsUnitInCombat("player") then
        Speedrun.UpdateWaypointNew(GetRaidDuration())
        EM:UnregisterForUpdate(Speedrun.name .. "HelRaCitadel")
      end
    else return end
  end
end
