local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")
-----------------
---- Globals ----
-----------------

Speedrun = {}
Speedrun.name = "Speedrun"
Speedrun.version = "0.1"

Speedrun.raidList = {
    [638] = {
        name = "AA",
        id = 638,
        bestTimer,
        timerEtapes = {},
	},
	[636] = {
        name = "HRC",
        id = 636,
        bestTimer,
        timerEtapes = {},
	},
	[639] = {
        name = "SO",
        id = 639,
        bestTimer,
        timerEtapes = {},
	},
	[725] = {
        name = "MoL",
        id = 725,
        bestTimer,
        timerEtapes = {},
	},
	[975] = {
        name = "HoF",
        id = 975,
        bestTimer,
        timerEtapes = {},
	},
	[1000] = {
        name = "SO",
        id = 1000,
        bestTimer,
        timerEtapes = {},
	},
	[1051] = {
        name = "CR",
        id = 1051,
        bestTimer,
        timerEtapes = {},
	},
	[1082] = {
        name = "BRP",
        id = 1082,
        bestTimer,
        timerEtapes = {},
	},
	[677] = {
        name = "MA",
        id = 677,
        bestTimer,
        timerEtapes = {},
	},
	[635] = {
        name = "DSA",
        id = 635,
        bestTimer,
        timerEtapes = {},
    },
}

---------------------------
---- Variables Default ----
---------------------------
Speedrun.Default = {
}

-------------------------
---- Settings Window ----
-------------------------
function Speedrun.CreateSettingsWindow()
	--TODO switch in settings window in another file and complete it
	local panelData = {
		type = "panel",
		name = "Speedrun",
		displayName = "SpeedRun",
		author = "Floliroy",
		version = Speedrun.version,
		slashCommand = "/speedrun",
		registerForRefresh = true,
		registerForDefaults = true,
	}
	
	local cntrlOptionsPanel = LAM2:RegisterAddonPanel("Speedrun_Settings", panelData)
	
	local optionsData = {
		[1] = {
			type = "header",
			name = "Header",
		},
		[2] = {
			type = "description",
			text = "Description",
		},
	}
	
	LAM2:RegisterOptionControls("Speedrun_Settings", optionsData)
end

-------------------
---- Functions ----
-------------------

function Speedrun.Test()
	if IsRaidInProgress() then
		d("|cffffffTest: |r" .. GetRaidDuration())
	end
end

function Speedrun.Main()
	for i = 1, MAX_BOSSES do
		if DoesUnitExist("boss" .. i) then --TODO : test if UnitExist when dead
			if IsUnitInCombat("player") then    
				--Debut combat avec tel ou tel boss
			else
				local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
				if currentTargetHP == 0 then
				--Fin combat avec tel ou tel boss
				end
			end
		end
	end
end

function Speedrun.Reset()
	--TODO : test
	--When EVENT_BOSSES_CHANGED and EVENT_PLAYER_COMBAT_STATE proc
	--Maybe EVENT_PLAYER_ACTIVATED also

	if IsRaidInProgress() then --if in vet trial
		EVENT_MANAGER:RegisterForUpdate(Speedrun.name,EVENT_BOSSES_CHANGED, Speedrun.Main) 
		EVENT_MANAGER:RegisterForUpdate(Speedrun.name,EVENT_PLAYER_COMBAT_STATE, Speedrun.Main)
    	else 
		EVENT_MANAGER:UnregisterForUpdate(Speedrun.name,EVENT_BOSSES_CHANGED, Speedrun.Main)
		EVENT_MANAGER:UnregisterForUpdate(Speedrun.name,EVENT_PLAYER_COMBAT_STATE, Speedrun.Main)
   	end
end

function Speedrun:Initialize()
	--Settings
	Speedrun.CreateSettingsWindow()
	
	--Saved Variables
	Speedrun.savedVariables = ZO_SavedVars:New("SpeedrunVariables", 1, nil, Speedrun.Default)

	--EVENT_MANAGER
	EVENT_MANAGER:RegisterForUpdate(Speedrun.name, 100, Speedrun.Test)
	--EVENT_MANAGER:RegisterForEvent(Speedrun.name, EVENT_BOSSES_CHANGED, Speedrun.Test)
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