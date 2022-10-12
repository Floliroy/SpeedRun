
Speedrun = Speedrun or {}
local Speedrun = Speedrun
local sV
local cV
function Speedrun.MiniBossDead(eventCode, scoreUpdateReason, scoreAmount, totalScore)
    local timer
    Speedrun:dbg(2, "|cffffff<<1>>|r MINI BOSS fight time: |cffffff<<2>>|r AND UPDATE <<3>>!", Speedrun.currentBossName, Speedrun.FormatTimerForChatUpdate(timer), scoreUpdateReason)

    if (scoreUpdateReason == RAID_POINT_REASON_KILL_MINIBOSS and scoreUpdateReason == RAID_POINT_REASON_KILL_BOSS) and  'sail ripper' ~= Speedrun.currentBossName then
  
      timer = (GetRaidDuration() - Speedrun.fightBegin) / 1000
  
  
      Speedrun.lastBossName     = Speedrun.currentBossName
      sV.lastBossName           = Speedrun.lastBossName
      Speedrun.currentBossName  = ""
      sV.currentBossName        = Speedrun.currentBossName
      Speedrun.isBossDead       = true
      sV.isBossDead             = Speedrun.isBossDead
      Speedrun.UpdateWaypointNew(GetRaidDuration())
  
    end
  end