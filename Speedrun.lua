-----------------
---- Globals ----
-----------------

Speedrun = Speedrun or { }
local Speedrun = Speedrun

Speedrun.name = "Speedrun"
Speedrun.version = "0.1"

Speedrun.lastBossName = ""
Speedrun.raidID = 0
Speedrun.Step = 0

---------------------------
---- Variables Default ----
---------------------------
Speedrun.Default = {
	customTimerSteps = {},
    speedrun_container_OffsetX = 0,
    speedrun_container_OffsetY = 0,

	raidList = {},
	lastBossName = "",
	raidID = 0,
	Step = 0
}
Speedrun.Default.customTimerSteps = Speedrun.customTimerSteps
Speedrun.Default.raidList = Speedrun.raidList

-------------------
---- Functions ----
-------------------
function Speedrun.Test()
	d("GIGA CHIBRE")
end

function Speedrun.FormatRaidTimer(timer, ms)
    ms = ms or true

    local raidDurationSec
    if ms then
        raidDurationSec = math.floor( timer / 1000)
    else
        raidDurationSec = timer
    end
    if raidDurationSec then
        local returnedString = ""
        if raidDurationSec < 0 then returnedString = "-" end
        if raidDurationSec < 3600 and raidDurationSec > -3600 then
                return returnedString .. string.format(
                    "%02d:%02d",
                    math.floor((math.abs(raidDurationSec) / 60) % 60),
                    math.abs(raidDurationSec) % 60
                )
            else
                return returnedString .. string.format(
                    "%02d:%02d:%02d",
                    math.floor(math.abs(raidDurationSec) / 3600),
                    math.floor((math.abs(raidDurationSec) / 60) % 60),
                    math.abs(raidDurationSec) % 60
                )
        end
    end
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
	local raid = Speedrun.raidList[Speedrun.raidID]
    local waypoint = Speedrun.Step
	if raid then
			Speedrun.UpdateWindowPanel(waypoint, raid)
			
			if raid.timerSteps[waypoint] == nil or raid.timerSteps[waypoint] < math.floor(GetRaidDuration()) then
				raid.timerSteps[waypoint] = GetRaidDuration()
				Speedrun.savedVariables.raidList = Speedrun.raidList
            end
            d("SR:waypoint " .. waypoint)
			Speedrun.Step = Speedrun.Step + 1
			Speedrun.savedVariables.Step = Speedrun.Step
            return
    end
end

function Speedrun.MainCloudrest()
	for i = 1, MAX_BOSSES do
		if DoesUnitExist("boss" .. i) then
			local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
			if Speedrun.Step == 1 then --start fight with boss
				Speedrun.UpdateWaypoint()
				Speedrun.lastBossName = GetUnitName("boss" .. i)
				Speedrun.savedVariables.lastBossName = Speedrun.lastBossName 
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
					Speedrun.savedVariables.lastBossName = Speedrun.lastBossName 
					Speedrun.Step = 1
					Speedrun.savedVariables.Step = Speedrun.Step
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
					Speedrun.savedVariables.Step = Speedrun.Step 
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
					Speedrun.savedVariables.lastBossName = Speedrun.lastBossName 
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
	if IsRaidInProgress() then --if vet trial started
		Speedrun.CreateRaidSegment(GetZoneId(GetUnitZoneIndex("player")))
		if Speedrun.raidID ~= GetZoneId(GetUnitZoneIndex("player")) then
			--Reset
			Speedrun.raidID = GetZoneId(GetUnitZoneIndex("player"))
			Speedrun.savedVariables.raidID = Speedrun.raidID
			Speedrun.lastBossName = ""
			Speedrun.savedVariables.lastBossName = Speedrun.lastBossName 
			Speedrun.Step = 1
			Speedrun.savedVariables.Step = Speedrun.Step 
			
			--EVENT_MANAGER
			if Speedrun.raidID == 1000 then --AS
				EVENT_MANAGER:RegisterForUpdate(Speedrun.name, 333, Speedrun.MainAsylum) 
			elseif Speedrun.raidID == 1051 then --CR
				EVENT_MANAGER:RegisterForUpdate(Speedrun.name, 333, Speedrun.MainCloudrest) 
			else --Other Raids
				EVENT_MANAGER:RegisterForEvent(Speedrun.name,EVENT_BOSSES_CHANGED, Speedrun.MainBoss) 
				EVENT_MANAGER:RegisterForEvent(Speedrun.name,EVENT_PLAYER_COMBAT_STATE, Speedrun.MainBoss)
			end
		end
		EVENT_MANAGER:RegisterForUpdate(Speedrun.name, 900, Speedrun.UpdateWindowPanel)
	else 
		EVENT_MANAGER:UnregisterForEvent(Speedrun.name,EVENT_BOSSES_CHANGED)
		EVENT_MANAGER:UnregisterForEvent(Speedrun.name,EVENT_PLAYER_COMBAT_STATE)
		EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "Update")
		Speedrun.lastBossName = ""
		Speedrun.savedVariables.lastBossName = Speedrun.lastBossName 
		Speedrun.Step = 1
		Speedrun.savedVariables.Step = Speedrun.Step 
	end 
end

function Speedrun.OnPlayerActivated()
    Speedrun.Reset()
    --ajout hiden
end

function Speedrun:Initialize()
	--Settings
	Speedrun.CreateSettingsWindow()
	
	--Saved Variables
	Speedrun.savedVariables = ZO_SavedVars:NewAccountWide("SpeedrunVariables", 1, nil, Speedrun.Default)
	Speedrun.customTimerSteps = Speedrun.savedVariables.customTimerSteps

    -- UI
    Speedrun.ResetAnchors()
    Speedrun.Reset()


    --Variable init
	Speedrun.lastBossName = Speedrun.savedVariables.lastBossName 
	Speedrun.raidID = Speedrun.savedVariables.raidID
	Speedrun.Step = Speedrun.savedVariables.Step
	Speedrun.raidList = Speedrun.savedVariables.raidList

	--EVENT_MANAGER
	EVENT_MANAGER:RegisterForEvent(Speedrun.name, EVENT_PLAYER_ACTIVATED, Speedrun.OnPlayerActivated) 

	EVENT_MANAGER:RegisterForEvent(Speedrun.name, EVENT_RAID_TRIAL_STARTED, Speedrun.Reset) --start vet trial
	EVENT_MANAGER:RegisterForEvent(Speedrun.name, EVENT_RAID_TRIAL_COMPLETE, Speedrun.Reset) --finish vet trial
	EVENT_MANAGER:RegisterForEvent(Speedrun.name, EVENT_RAID_TRIAL_FAILED, Speedrun.Reset) --reset vet trial

    EVENT_MANAGER:RegisterForEvent(Speedrun.name, EVENT_PLAYER_COMBAT_STATE, Speedrun.Test)
	
	EVENT_MANAGER:RegisterForEvent(Speedrun.name, EVENT_ZONE_CHANNEL_CHANGED, Speedrun.Test)
	EVENT_MANAGER:UnregisterForEvent(Speedrun.name, EVENT_ADD_ON_LOADED)
    SLASH_COMMANDS["/srwaypoint"] = function()Speedrun.UpdateWaypoint() end
	
end


 
function Speedrun.OnAddOnLoaded(event, addonName)
	if addonName ~= Speedrun.name then return end
		Speedrun:Initialize()
end

EVENT_MANAGER:RegisterForEvent(Speedrun.name, EVENT_ADD_ON_LOADED, Speedrun.OnAddOnLoaded)
