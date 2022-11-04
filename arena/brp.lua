Speedrun = Speedrun or {}
local Speedrun = Speedrun
function Speedrun.GetBRPStage()
  local x, y = GetMapPlayerPosition('player');
  if (x > 0.54 and x < 0.64 and y > 0.79 and y < 0.89) then return 1
  elseif (x > 0.3 and x < 0.4 and y > 0.69 and y < 0.8) then return 2
  elseif (x > 0.41 and x < 0.52 and y > 0.43 and y < 0.53) then return 3
  elseif (x > 0.63 and x < 0.73 and y > 0.22 and y < 0.32) then return 4
  elseif (x > 0.4 and x < 0.5 and y > 0.08 and y < 0.18) then return 5
  else return 0 end
end

function Speedrun.GetBRPStep()
  local step = ((Speedrun.GetBRPStage() * 5) - 5) + Speedrun.arenaRound
  return step
end

function Speedrun.PortalSpawnBRP(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType,
                                 sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log,
                                 sourceUnitId, targetUnitId, abilityId)

  if result == ACTION_RESULT_EFFECT_GAINED then
    local t = GetGameTimeMilliseconds()
    if t - lastPortal > 2000 then brpWave = brpWave + 1 end
    lastPortal = t
  end
end
