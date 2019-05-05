-----------------
---- Globals ----
-----------------
Speedrun = Speedrun or { }
local Speedrun = Speedrun

Speedrun.name = "Speedrun"
Speedrun.version = "0.1"

Speedrun.lastBossName = ""
Speedrun.Step = 1

---------------------------
---- Variables Default ----
---------------------------
Speedrun.Default = {
	customTimerSteps = {}
}
Speedrun.Default.customTimerSteps = Speedrun.customTimerSteps

-------------------
---- Functions ----
-------------------
function Speedrun.Test()
	d("SUPER CHIBRE")
end

function Speedrun.FormatRaidTimer(timer)
	local raidDurationSec = math.floor( timer / 1000)
		
	return string.format(
	    "%02d:%02d:%02d",
	    math.floor(raidDurationSec / 3600),
	    math.floor((raidDurationSec / 60) % 60),
	    raidDurationSec % 60
	)
end

function Speedrun.GetScore(timer, vitality, raidID)
	if raidID == 638 then --AA
		return (124300 + (1000 * vitality)) * (1 + (900 - timer) / 10000)
	elseif raidID == 636 then --HRC
		return (133100 + (1000 * vitality)) * (1 + (900 - timer) / 10000)
	elseif raidID == 639 then --SO
		return (142700 + (1000 * vitality)) * (1 + (1500 - timer) / 10000)
	elseif raidID == 725 then --MoL
		return (108150 + (1000 * vitality)) * (1 + (2700 - timer) / 10000)
	elseif raidID == 975 then --HoF
		return (160100 + (1000 * vitality)) * (1 + (2700 - timer) / 10000)
	elseif raidID == 1000 then --AS
		return (70000 + (1000 * vitality)) * (1 + (1200 - timer) / 10000)
	elseif raidID == 1051 then --CR
		if Speedrun.addsOnCR == 1 then
			return (85750 + (1000 * vitality)) * (1 + (1200 - timer) / 10000)
		else
			return (88000 + (1000 * vitality)) * (1 + (1200 - timer) / 10000)
		end
	elseif raidID == 1082 then --BRP
		return (75000 + (1000 * vitality)) * (1 + (2400 - timer) / 10000)
	elseif raidID == 677 then --MA
		return (426000 + (1000 * vitality)) * (1 + (5400 - timer) / 10000)
	elseif raidID == 635 then --DSA
		return (20000 + (1000 * vitality)) * (1 + (3600 - timer) / 10000)
	end	
end

function Speedrun.UpdateWaypoint()
	local waypoint = Speedrun.Step
	for i=1, table.getn(Speedrun.raidList) do
		local raid = Speedrun.raidList[i]
		if raid.id == GetZoneId(GetUnitZoneIndex("player")) then
			--TODO Speedrun.UpdateWindowPanel
			if raid.timerSteps[waypoint] < math.floor(GetRaidDuration() / 1000) then
				raid.timerSteps[waypoint] = math.floor(GetRaidDuration() / 1000)
			end
			d("SR:debug " .. waypoint)
			Speedrun.Step = Speedrun.Step + 1
			return
		end
	end
end

function Speedrun.MainCloudrest()
	for i = 1, MAX_BOSSES do
		if DoesUnitExist("boss" .. i) then
			local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
			if Speedrun.Step == 1 then --start fight with boss
				Speedrun.UpdateWaypoint()
				Speedrun.lastBossName = GetUnitName("boss" .. i)
			end
			if IsUnitInCombat("player") then    
				local percentageHP = currentTargetHP / maxTargetHP 
				if percentageHP <= 0.75 and Speedrun.Step == 2 then
					Speedrun.UpdateWaypoint()
				end
				if percentageHP <= 0.5 and Speedrun.Step == 3 then
					Speedrun.UpdateWaypoint()
				end
				if percentageHP <= 0.25 and Speedrun.Step == 4 then
					Speedrun.UpdateWaypoint()
				end		
				if GetUnitName("boss" .. i) ~= Speedrun.lastBossName and Speedrun.Step == 5 then
					--ZMaja Shadow
					Speedrun.UpdateWaypoint()
				end	
			else
				if currentTargetHP <= 0 and Speedrun.Step == 6 then 
					--boss dead
					Speedrun.UpdateWaypoint()
				elseif currentTargetHP > 0 then
					Speedrun.lastBossName = ""
					Speedrun.Step = 1
				end
			end
		end
	end
end

function Speedrun.MainAsylum()
	for i = 1, MAX_BOSSES do
		if DoesUnitExist("boss" .. i) then
			local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
			if Speedrun.Step == 1 then --start fight with boss
				Speedrun.UpdateWaypoint()
			end
			if IsUnitInCombat("player") then    
				local percentageHP = currentTargetHP / maxTargetHP 
				if percentageHP <= 0.9 and Speedrun.Step == 2 then
					Speedrun.UpdateWaypoint()
				end
				if percentageHP <= 0.75 and Speedrun.Step == 3 then
					Speedrun.UpdateWaypoint()
				end
				if percentageHP <= 0.5 and Speedrun.Step == 4 then
					Speedrun.UpdateWaypoint()
				end
				if percentageHP <= 0.25 and Speedrun.Step == 5 then
					Speedrun.UpdateWaypoint()
				end				
			else
				if currentTargetHP <= 0 then 
					--boss dead
					Speedrun.UpdateWaypoint()
				else
					Speedrun.Step = 1
				end
			end
		end
	end
end

function Speedrun.MainBoss()
	for i = 1, MAX_BOSSES do
		if DoesUnitExist("boss" .. i) then
			if IsUnitInCombat("player") then    
				--begin fight with a boss
				if Speedrun.lastBossName ~= GetUnitName("boss" .. i) then
					Speedrun.lastBossName = GetUnitName("boss" .. i)
					Speedrun.UpdateWaypoint()
					return
				end
			else
				local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
				if currentTargetHP <= 0 then 
					--boss dead
					Speedrun.UpdateWaypoint()
					return
				end
			end
		end
	end
end

function Speedrun.Reset()
	--TODO : test
	--When EVENT_BOSSES_CHANGED and EVENT_PLAYER_COMBAT_STATE proc
	--Maybe EVENT_PLAYER_ACTIVATED also

	if IsRaidInProgress() then --if vet trial started
		if GetZoneId(GetUnitZoneIndex("player")) == 1000 then --AS
			EVENT_MANAGER:RegisterForUpdate(Speedrun.name, 333, Speedrun.MainAsylum) 
			EVENT_MANAGER:RegisterForUpdate(Speedrun.name, 900, Speedrun.UpdateWindowPanel)
		elseif GetZoneId(GetUnitZoneIndex("player")) == 1051 then --CR
			EVENT_MANAGER:RegisterForUpdate(Speedrun.name, 333, Speedrun.MainCloudrest) 
			EVENT_MANAGER:RegisterForUpdate(Speedrun.name, 900, Speedrun.UpdateWindowPanel)
		else --Other Raids
			EVENT_MANAGER:RegisterForEvent(Speedrun.name,EVENT_BOSSES_CHANGED, Speedrun.MainBoss) 
			EVENT_MANAGER:RegisterForEvent(Speedrun.name,EVENT_PLAYER_COMBAT_STATE, Speedrun.MainBoss)
			EVENT_MANAGER:RegisterForUpdate(Speedrun.name, 900, Speedrun.UpdateWindowPanel)
		end
	else 
		EVENT_MANAGER:UnregisterForEvent(Speedrun.name,EVENT_BOSSES_CHANGED)
		EVENT_MANAGER:UnregisterForEvent(Speedrun.name,EVENT_PLAYER_COMBAT_STATE)
		EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "Update")
		Speedrun.lastBossName = ""
		Speedrun.Step = 1
	end 
end

function Speedrun:Initialize()
	--Settings
	Speedrun.CreateSettingsWindow()
	
	--Saved Variables
	Speedrun.savedVariables = ZO_SavedVars:NewAccountWide("SpeedrunVariables", 1, nil, Speedrun.Default)
	Speedrun.customTimerSteps = Speedrun.savedVariables.customTimerSteps

	--EVENT_MANAGER
	--EVENT_MANAGER:RegisterForEvent(Speedrun.name, EVENT_RAID_TRIAL_STARTED, Speedrun.Reset)
	--EVENT_MANAGER:RegisterForEvent(Speedrun.name, EVENT_RAID_TRIAL_COMPLETE, Speedrun.Reset)
	--EVENT_MANAGER:RegisterForEvent(Speedrun.name, EVENT_RAID_TRIAL_FAILED, Speedrun.Reset)
	EVENT_MANAGER:RegisterForEvent(Speedrun.name, EVENT_PLAYER_COMBAT_STATE, Speedrun.Test)
	EVENT_MANAGER:UnregisterForEvent(Speedrun.name, EVENT_ADD_ON_LOADED)
	
end

function Speedrun.SaveLoc()
	Speedrun.savedVariables.OffsetX = SpeedrunAlert:GetLeft()
	Speedrun.savedVariables.OffsetY = SpeedrunAlert:GetTop()
end	
 
function Speedrun.OnAddOnLoaded(event, addonName)
	if addonName ~= Speedrun.name then return end
		Speedrun:Initialize()
end

EVENT_MANAGER:RegisterForEvent(Speedrun.name, EVENT_ADD_ON_LOADED, Speedrun.OnAddOnLoaded)
