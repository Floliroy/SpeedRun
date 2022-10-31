Speedrun = Speedrun or {}
local Speedrun = Speedrun
local sV
local cV
function Speedrun.CombatCR()
  for i = 1, MAX_BOSSES do
    if DoesUnitExist("boss" .. i) then
      local current, max, effectiveMax = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
      if (max > 64000000 and IsUnitAttackable("boss" .. i)) then
        if IsUnitInCombat("player") then
          -- zmaja name: ["Z'Maja"], ["З'Маджа"], ["ズマジャ"]
          -- zo_strformat("<<C:1>>", GetUnitName('boss1'))
          Speedrun.currentBossName = string.lower(GetUnitName("boss" .. i))
          sV.currentBossName       = Speedrun.currentBossName
          local z                  = {
            index     = i,
            name      = Speedrun.currentBossName,
            hpMax     = max,
            hpCurrent = current,
          }
          zmaja                    = z
          isZmaja                  = true
          if Speedrun.Step == 1 then
            Speedrun.UpdateWaypointNew(GetRaidDuration())
            EM:UnregisterForUpdate(Speedrun.name .. "MiniTrial")
            EM:RegisterForUpdate(Speedrun.name .. "MiniTrial", 333, Speedrun.MainCloudrest)
          end
          Speedrun.inCombat = true

          zo_callLater(function()
            EM:UnregisterForUpdate(Speedrun.name .. "CombatEnded")
            EM:RegisterForUpdate(Speedrun.name .. "CombatEnded", 4000, Speedrun.OnCombatEnd)
          end, 1000)
        end

      else
        isZmaja = false
      end
    end
  end
end

function Speedrun.ZmajaShade()
  for i = 1, MAX_BOSSES do
    if DoesUnitExist("boss" .. i) then
      -- zo_strformat("<<C:1>>", GetUnitName('boss1'))
      local boss = string.lower(GetUnitName("boss" .. i))
      if (boss ~= zmaja.name and Speedrun.Step == 5) then
        -- if (boss ~= Speedrun.currentBossName and Speedrun.Step == 5) then
        Speedrun.currentBossName = boss
        sV.currentBossName       = Speedrun.currentBossName
        Speedrun.UpdateWaypointNew(GetRaidDuration())
        EM:UnregisterForEvent(Speedrun.name .. "BossChangeCR", EVENT_BOSSES_CHANGED)
      end
    end
  end
end

-- IsUnitActivelyEngaged(string unitTag)
-- Returns: boolean isActivelyEngaged

-- IsUnitAttackable(string unitTag)
-- Returns: boolean attackable

function Speedrun.MainCloudrest()
  if isZmaja then
    local current, max, effectiveMax = GetUnitPower("boss" .. zmaja.index, POWERTYPE_HEALTH)
    local percentageHP = current / max

    -- check for highest possible step in case 1 or 2 steps were passed while player was in portal
    if (percentageHP <= 0.06) then
      -- if Speedrun.Step < 5 then
      Speedrun.Step = 4
      Speedrun.UpdateWaypointNew(GetRaidDuration())
      EM:UnregisterForEvent(Speedrun.name .. "BossChangeCR", EVENT_BOSSES_CHANGED)
      EM:RegisterForEvent(Speedrun.name .. "BossChangeCR", EVENT_BOSSES_CHANGED, Speedrun.ZmajaShade)
      EM:UnregisterForUpdate(Speedrun.name .. "MiniTrial")
      return
      -- end
    elseif (percentageHP <= 0.25 and percentageHP >= 0.06) then
      if Speedrun.Step < 4 then
        Speedrun.Step = 3
        Speedrun.UpdateWaypointNew(GetRaidDuration())
        -- EM:UnregisterForEvent(Speedrun.name .. "BossChangeCR", EVENT_BOSSES_CHANGED)
        -- EM:RegisterForEvent(Speedrun.name .. "BossChangeCR", EVENT_BOSSES_CHANGED, Speedrun.ZmajaShade)
        return
      end

    elseif (percentageHP <= 0.5 and percentageHP > 0.25) then
      if Speedrun.Step < 3 then
        Speedrun.Step = 2
        Speedrun.UpdateWaypointNew(GetRaidDuration())
        return
      end

    elseif (percentageHP <= 0.75 and percentageHP > 0.5) then
      if Speedrun.Step < 2 then
        Speedrun.Step = 1
        Speedrun.UpdateWaypointNew(GetRaidDuration())
        return
      end
    end

  else
    EM:UnregisterForUpdate(Speedrun.name .. "MiniTrial")
  end
end
