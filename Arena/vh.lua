Speedrun        = Speedrun or {}
local Speedrun  = Speedrun
local sV
local cV
local lastPrint = ""
local sideBoss  = ""
function Speedrun.MainVH()
  for i = 1, MAX_BOSSES do
    if DoesUnitExist("boss" .. i) then

      --zo_strformat("<<C:1>>", GetUnitName('boss1'))
      local boss = GetUnitName("boss" .. i)
      Speedrun.currentBossName = string.lower(boss)

      if lastPrint ~= Speedrun.currentBossName then
        lastPrint = Speedrun.currentBossName
        Speedrun:dbg(2, "<<1>> Detected!", boss)
      end

      -- local current, max, effmax = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)

      if Speedrun.Step <= 6 then

        if ((Speedrun.currentBossName == Speedrun.lastBossName) or not IsUnitInCombat("player")) then return end

        if (
            string.find("leptfire", Speedrun.currentBossName) or string.find("xobutar", Speedrun.currentBossName) or
                string.find("mynar", Speedrun.currentBossName)) then
          if Speedrun.isSideBoss == false then
            Speedrun.isSideBoss = true
            sideBoss            = boss
          end
        else
          Speedrun.isSideBoss = false
          sideBoss            = ""
        end

        if (Speedrun.isSideBoss == true and IsUnitInCombat("player")) then
          EM:UnregisterForUpdate(Speedrun.name .. "SideBoss")
          EM:RegisterForUpdate(Speedrun.name .. "SideBoss", 100, Speedrun.SideBoss)
          return
        end

        if IsUnitInCombat("player") then
          if Speedrun.lastBossName ~= Speedrun.currentBossName then
            EM:RegisterForEvent(Speedrun.name .. "ArenaBoss", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.arenaBoss)
          else
            return
          end
        end
      end
    end
  end
end

function Speedrun.SideBoss()
  local current, max, effmax = GetUnitPower("boss1", POWERTYPE_HEALTH)

  if current <= 0 then
    EM:UnregisterForUpdate(Speedrun.name .. "SideBoss")
    Speedrun:dbg(1, "|cdf4242<<1>>|r killed at |cffff00<<2>>|r", sideBoss,
      Speedrun.FormatTimerForChatUpdate(GetRaidDuration()))
    Speedrun.lastBossName = Speedrun.currentBossName
    sV.lastBossName       = Speedrun.lastBossName
  end
end
