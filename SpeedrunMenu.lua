Speedrun = Speedrun or {}
local Speedrun 							= Speedrun
local LAM2 									= LibAddonMenu2
local wm 										= WINDOW_MANAGER
local sV
local cV
----------------------------------------------------------------------------------------------------------
------------------------------------[ 		PROFILE    ]----------------------------------------------------
----------------------------------------------------------------------------------------------------------
local profileToAdd 					= ""
local profileToLoad 				= ""
local profileToDelete 			= ""
-- local profileToCopyFrom 		= ""
-- local profileToCopyTo 			= ""
local trialMenuTimers = {
		[635]  = {},
		[636]  = {},
		[638]  = {},
		[639]  = {},
		[677]  = {},
		[725]  = {},
		[975]  = {},
		[1000] = {},
		[1051] = {},
		[1082] = {},
		[1121] = {},
		[1196] = {},
		[1227] = {},
		[1263] = {},
}

-- function Speedrun.CreateProfileDescriptionTitle()
-- 		local parent = Speedrun_ProfileSubmenu
-- 		local data = {
-- 				type = "description"
-- 		}
-- 		local name = "Speedrun_ActiveProfileDecriptionTitle"
-- 		local control = LAM2.util.CreateBaseControl(parent, data, name)
-- 		-- local control = wm:CreateControl(name, parent, CT_CONTROL)
-- 		local width = (parent:GetWidth() - 60) / 2	--225
--
-- 		control:SetWidth(width)
-- 		control:SetResizeToFitDescendents(true)
-- 		control:SetDimensionConstraints(width, 0, width, 0)
--
-- 		control.title =	wm:CreateControl(nil, control, CT_LABEL)
-- 		local title = control.title
-- 		title:SetWidth(width)
-- 		title:SetAnchor(TOPLEFT, control, TOPLEFT)
-- 		title:SetFont("ZoFontWinH4")
-- 		title:SetText("Currently Active Profile:")
--
-- 		return control
-- end

-- function Speedrun.CreateProfileDescriptionDisplay()
-- 		local parent = "Speedrun_ProfileSubmenu"
-- 		local name = "Speedrun_ActiveProfileDecriptionName"
-- 		local control = wm:CreateControl(name, parent, CT_CONTROL)
-- 		local width = 225
--
-- 		control:SetWidth(width)
-- 		control:SetResizeToFitDescendents(true)
-- 		control:SetDimensionConstraints(width, 0, width, 0)
--
-- 		local title = wm:CreateControl(nil, control, CT_LABEL)
-- 		title:SetWidth(width)
-- 		title:SetAnchor(TOPRIGHT, control, TOPRIGHT)
-- 		title:SetFont("ZoFontWinH4")
-- 		title:SetText(Speedrun.GetActiveProfileDisplay())
--
-- 		return control
-- end

-- function Speedrun:GetProfileNames()
-- 		local profiles 				= {}
-- 		Speedrun.numProfiles  = 0
--
-- 		for name, v in pairs(sV.profiles) do
-- 				table.insert(profiles, name)
-- 				Speedrun.numProfiles = Speedrun.numProfiles	+ 1
-- 		end
-- 		return profiles
-- end

-- function Speedrun:GetProfileNamesToCopyTo()
-- 		local profilesToCopyTo = {}
-- 		for name, v in pairs(sV.profiles) do
-- 				if name ~= profileToCopyFrom then
-- 						table.insert(profilesToCopyTo, name)
-- 				end
-- 		end
-- 		return profilesToCopyTo
-- end

function Speedrun.AddProfile()
		local name = Speedrun_ProfileEditbox.editbox:GetText()
		Speedrun:dbg(0, "Adding new profile [<<1>>]", name)

		if name == "Default" then return end
		if sV.profiles[name] ~= nil then
				Speedrun:dbg(0, "Profile [".. name .."] Already Exist!")
				return
		end

		if (name ~= "") then
				sV.profiles[name] = Speedrun.GetDefaultProfile()
				Speedrun.activeProfile = name
				cV.activeProfile = Speedrun.activeProfile

				-- Speedrun.UpdateDropdowns()

				Speedrun.LoadProfile(name)
		else
				Speedrun:dbg(0, "Failed to add profile!")
		end
		profileToAdd = ""
end

-- function Speedrun.CopyProfile(from, to)
-- 		for k, v in pairs(sV.profiles) do
-- 				if sV.profiles[k] == to then
-- 						sV.profiles[k] = {}
-- 						sV.profiles[k] = sV.profiles[from]
-- 				end
-- 		end
-- 		if (sV.profiles[to] == Speedrun.activeProfile and Speedrun.IsInTrialZone()) then
-- 				ReloadUI("ingame")
-- 		end
-- 		profileToCopyFrom = ""
-- 		profileToCopyTo = ""
-- end

function Speedrun.DeleteProfile(name)
		local name = profileToDelete	-- = Speedrun_ProfileDeleteDropdown.data.getFunc() -- profileToDelete
		local setDefault = profileToDelete == Speedrun.activeProfile and true or false

		-- "Default" profile can't be deleted
		if name == "Default" then
				Speedrun:dbg(0, "[Default] can't be deleted!")
				return
		end

		Speedrun:dbg(0, "Deleting profile: [<<1>>]", name)

		-- update profile vars
		local new_list = { }
		for k, v in pairs(sV.profiles) do
				if name ~= k then
						new_list[k] = v
				end
		end
		sV.profiles = new_list

		-- set "Default" as active if deleted profile was active
		if setDefault == true then
				Speedrun.LoadProfile("Default")
		else
				Speedrun.UpdateDropdowns()
		end
		profileToDelete = ""
end

function Speedrun.LoadProfile(name)
		if sV.profiles[name] == nil then Speedrun:dbg(0, "ERROR! Profile: [<<1>>] not found.", name) return end
		if sV.profiles[name] == Speedrun.activeProfile then Speedrun:dbg(0, "Profile: [<<1>>] is already active.", name) return end

		Speedrun:dbg(0, "Loading profile: [<<1>>]", name)

		Speedrun.activeProfile = name
		cV.activeProfile = Speedrun.activeProfile

		-- profileToLoad = ""

		Speedrun.ValidateProfile(Speedrun.activeProfile)
		Speedrun.RefreshProfileSettings()

		if Speedrun.IsInTrialZone() then
				Speedrun.ResetUI()
				Speedrun.CreateRaidSegment(Speedrun.raidID)
				if GetRaidDuration() <= 0 and not IsRaidInProgress() then
						SpeedRun_Score_Label:SetText(Speedrun.BestPossible(Speedrun.raidID))
				end
				Speedrun.UpdateCurrentVitality()
		end
end

function Speedrun.UpdateDropdowns()
		-- Speedrun.UpdatePanelDropdown()
		if Speedrun.inMenu then
				local profileNames = Speedrun:GetProfileNames()
				Speedrun_ProfileDropdown:UpdateChoices(profileNames)
				Speedrun_ProfileDeleteDropdown:UpdateChoices(profileNames)

				-- Speedrun_ProfileCopyFrom:UpdateChoices(profileNames)
				-- Speedrun_ProfileCopyTo:UpdateChoices(Speedrun:GetProfileNamesToCopyTo())
				Speedrun_ProfileImportTo:UpdateChoices(profileNames)
		end
		-- Speedrun.UpdateProfileList()
end

function Speedrun.RefreshProfileSettings()
		Speedrun:dbg(2, "Updating Menu")
		Speedrun.addsOnCR	= sV.profiles[Speedrun.activeProfile].addsOnCR
		Speedrun.hmOnSS 	= sV.profiles[Speedrun.activeProfile].hmOnSS
		Speedrun.LoadRaidlist(Speedrun.activeProfile)
		Speedrun.LoadCustomTimers(Speedrun.activeProfile)
		Speedrun.UpdateDropdowns()

		-- Speedrun.RefreshTrialTimers()
end
----------------------------------------------------------------------------------------------------------
------------------------------------[ 		TRIAL    ]------------------------------------------------------
----------------------------------------------------------------------------------------------------------
function Speedrun.GetTime(seconds)
    if seconds then
        if seconds < 3600 then
            return 	string.format("%02d:%02d", math.floor((seconds / 60) % 60), seconds % 60)
        else
            return string.format("%02d:%02d:%02d", math.floor(seconds / 3600), math.floor((seconds / 60) % 60), seconds % 60)
        end
    end
end

function Speedrun.GetTooltip(timer)
    if timer then
				return zo_strformat(SI_SPEEDRUN_STEP_DESC_EXIST, math.floor(timer / 1000), Speedrun.GetTime(math.floor(timer / 1000)))
    else
				return zo_strformat(SI_SPEEDRUN_STEP_DESC_NULL)
    end
end

function Speedrun.Simulate(raidID)
    local timer = 0
    for i, x in pairs(Speedrun.Data.customTimerSteps[raidID]) do
				if Speedrun.GetSavedTimer(raidID, i) then
						timer = Speedrun.GetSavedTimer(raidID, i) + timer
        end
    end

		local r = 0
		if timer > 0 then
				if (timer % 1000) >= 500 then r = 1 end
		end
		local t = math.floor(timer / 1000) + r

    local vitality = Speedrun.GetTrialMaxVitality(raidID)

    local score = tostring(math.floor(Speedrun.GetScore(t, vitality, raidID)))
    local fScore = string.sub(score,string.len(score)-2,string.len(score))
    local dScore = string.gsub(score,fScore,"")
    score = dScore .. "'" .. fScore

    d("|cdf4242" .. zo_strformat(SI_ZONE_NAME,GetZoneNameById(raidID)) .. "|r")
    d(zo_strformat(SI_SPEEDRUN_SIMULATE_FUNCTION, Speedrun.GetTime(t), score))
end

function Speedrun.Overwrite(raidID)
		for k, v in pairs(Speedrun.customTimerSteps[raidID]) do
				if Speedrun.customTimerSteps[raidID][k] ~= "" then
						if Speedrun.GetCustomTimerStep(raidID, k) == "0" then
								Speedrun.SaveTimerStep(raidID, k, nil)
						else
								Speedrun.SaveTimerStep(raidID, k, tonumber(Speedrun.GetCustomTimerStep(raidID, k)) * 1000)
						end
						Speedrun.SaveCustomStep(raidID, k, "")
				end
		end

		if Speedrun.IsInTrialZone() then
				ReloadUI("ingame")
				Speedrun.ResetUI()
				Speedrun.CreateRaidSegment(raidID)
				if GetRaidDuration() <= 0 and not IsRaidInProgress() then
						SpeedRun_Score_Label:SetText(Speedrun.BestPossible(Speedrun.raidID))
				end
		end
end

function Speedrun.ResetData(raidID)
		-- For MA and VH
    if raidID == 677 or raidID == 1227 then
			 	if cV.individualArenaTimers then
					 	if cV.arenaList[raidID].timerSteps then
        				cV.arenaList[raidID].timerSteps = {}
						end
				else
						if sV.profiles[Speedrun.activeProfile].raidList[raidID].timerSteps then
								sV.profiles[Speedrun.activeProfile].raidList[raidID].timerSteps = {}
						end
				end
		else
				if Speedrun.raidList[raidID].timerSteps then
					Speedrun.raidList[raidID].timerSteps = {}
					sV.profiles[Speedrun.activeProfile].raidList = Speedrun.raidList
				end
    end

		Speedrun.RefreshProfileSettings()
		ReloadUI("ingame")
		if Speedrun.IsInTrialZone() then
				Speedrun.ResetUI()
				Speedrun.CreateRaidSegment(raidID)
		end
end

function Speedrun.CreateOptionTable(raidID, step)
    return {
				type = "editbox",
	      name = zo_strformat(SI_SPEEDRUN_STEP_NAME, Speedrun.Data.stepList[raidID][step]),
	      tooltip = function() return Speedrun.GetTooltip(sV.profiles[Speedrun.activeProfile].raidList[raidID].timerSteps[step]) end,
				-- tooltip = function() return Speedrun.GetTooltip(trialMenu[raidID][step]) end,
	      default = "",
	      getFunc = function() return Speedrun.GetCustomTimerStep(raidID, step) end,
	      setFunc = function(newValue)
	        	Speedrun.SaveCustomStep(raidID, step, newValue)
      	end,
				reference = "Speedrun_Custom_" .. raidID .. "_" .. step,
    }
end

function Speedrun.CreateRaidMenu(raidID)
    local raidMenu = {}

		table.insert(raidMenu,
		{   type = "description",
				text = zo_strformat(SI_SPEEDRUN_RAID_DESC),
    })

    if raidID == 1051 then
        table.insert(raidMenu,
				{		type = "checkbox",
            name = zo_strformat(SI_SPEEDRUN_ADDS_CR_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_ADDS_CR_DESC),
            default = true,
            getFunc = function() return Speedrun.addsOnCR end,
            setFunc = function(newValue)
								Speedrun.addsOnCR = newValue
                sV.profiles[Speedrun.activeProfile].addsOnCR = Speedrun.addsOnCR
            end,
        })
    end

    if raidID == 1121 then
        local choices = {
            [1] = zo_strformat(SI_SPEEDRUN_ZERO),
            [2] = zo_strformat(SI_SPEEDRUN_ONE),
            [3] = zo_strformat(SI_SPEEDRUN_TWO),
            [4] = zo_strformat(SI_SPEEDRUN_THREE),
        }
        table.insert(raidMenu,
				{		type = "dropdown",
            name = zo_strformat(SI_SPEEDRUN_HM_SS_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_HM_SS_DESC),
            choices = choices,
						default = choices[4],
						getFunc = function() return choices[Speedrun.hmOnSS] end,
						setFunc = function(selected)
								for index, name in ipairs(choices) do
										if name == selected then
												Speedrun.hmOnSS = index
												sV.profiles[Speedrun.activeProfile].hmOnSS = Speedrun.hmOnSS
												break
										end
								end
						end,
        })
    end

    for i, x in ipairs(Speedrun.Data.stepList[raidID]) do
        table.insert(raidMenu, Speedrun.CreateOptionTable(raidID, i))
    end

		table.insert(raidMenu,
		{   type = "button",
				name = zo_strformat(SI_SPEEDRUN_SIMULATE_NAME),
        tooltip = zo_strformat(SI_SPEEDRUN_SIMULATE_DESC),
        func = function()
            Speedrun.Simulate(raidID)
        end,
        width = "half",
    })

		table.insert(raidMenu,
		{   type = "description",
				name = "",
        width = "half",
    })

		table.insert(raidMenu,
		{		type = "button",
        name = "Apply Times",
        tooltip = "Overwrite current saved times with entered custom times.\nFields left blank wont be changed.\nCurrently tooltips wont update correctly until you reload UI, but the timers are being saved.",
        func = function()
          	Speedrun.Overwrite(raidID)
        end,
        width = "half",
				isDangerous = true,
        warning = "Confirm Changes.",
    })

		table.insert(raidMenu,
		{		type = "button",
        name = zo_strformat(SI_SPEEDRUN_RESET_NAME),
        tooltip = zo_strformat(SI_SPEEDRUN_RESET_DESC),
        func = function()
            Speedrun.ResetData(raidID)
        end,
        width = "half",
        isDangerous = true,
        warning = zo_strformat(SI_SPEEDRUN_RESET_WARNING),
    })

    return
		{		type = "submenu",
        name = (zo_strformat(SI_ZONE_NAME, GetZoneNameById(raidID))),
        controls = raidMenu,
				reference = "Speedrun_raidmenu_" .. raidID,
    }
end

function Speedrun.RefreshTrial(raidID)
		trialMenuTimers[raidID] = {}

		for i, x in pairs(Speedrun.Data.customTimerSteps[raidID]) do
				if Speedrun.Data.customTimerSteps[raidID][i] then
						if Speedrun.GetSavedTimerStep(raidID, i) then
								trialMenuTimers[raidID][i] = Speedrun.GetSavedTimerStep(raidID, i)
						end
				end
		end
end

function Speedrun.RefreshTrialTimers()
		for i, x in pairs(Speedrun.Data.customTimerSteps) do
				if Speedrun.Data.customTimerSteps[i] then
						Speedrun.RefreshTrial(i)
				end
		end
end

----------------------------------------------------------------------------------------------------------
-----------------------------------[ 		SETTINGS WINDOW    ]----------------------------------------------
----------------------------------------------------------------------------------------------------------

-- function Speedrun.BuildSettingsTable()
-- 		local p = Speedrun.activeProfile
-- 		local c = sV.profiles[p].customTimerSteps
-- 		local r = sV.profiles[p].raidList

function Speedrun.CreateSettingsWindow()
		local panelData = {
        type = "panel",
        name = "Speedrun",
        displayName = "Speed|cdf4242Run|r",
        author = "Floliroy, Panaa, @nogetrandom [PC-EU]",
        version = Speedrun.version,
        slashCommand = "/speed menu",
        registerForRefresh = true,
    }

    local cntrlOptionsPanel = LAM2:RegisterAddonPanel("Speedrun_Settings", panelData)

		sV = Speedrun.savedVariables
		cV = Speedrun.savedSettings

		-- Speedrun.RefreshTrialTimers()

		CALLBACK_MANAGER:RegisterCallback("LAM-PanelOpened", function(panel)
				if panel ~= cntrlOptionsPanel then return end
				Speedrun.inMenu = true
				SpeedRun_Panel:SetHidden(false)
				Speedrun.ShowInMenu()
		end)
		CALLBACK_MANAGER:RegisterCallback("LAM-PanelClosed", function(panel)
				if panel ~= cntrlOptionsPanel then return end
				Speedrun.inMenu = false
				SpeedRun_Panel:SetHidden(true)
				Speedrun.SetUIHidden(true)
		end)

		local optionsData = {
				{		type = "divider"	},

				{		type = "checkbox",	name = "Enable Tracking",							--zo_strformat(SI_SPEEDRUN_ENABLE_NAME),
						tooltip = "Turn trial time and score tracking on / off",	--zo_strformat(SI_SPEEDRUN_ENABLE_DESC),
						default = true,
						getFunc = function() return cV.isTracking end,
						setFunc = function(newValue)
								Speedrun.ToggleTracking()
						end	},

				{   type = "divider"	},

				{		type = "checkbox",	name = "Panel Always Active",
            tooltip = "The panel at the top of the SpeedRun window will be visible outside of trials.",
            default = true,
            getFunc = function() return sV.showPanelAlways end,
            setFunc = function()
								sV.showPanelAlways = not sV.showPanelAlways
                Speedrun.UpdateUIConfiguration()
            end,
						width = "half"	},

				{		type = "checkbox",	name = "Unlock UI",	--zo_strformat(SI_SPEEDRUN_LOCK_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_LOCK_DESC),
            default = true,
            getFunc = function() return sV.unlockUI end,
            setFunc = function()
                Speedrun.ToggleUILocked()
            end,
						width = "half"	},

				{		type = "checkbox",	name = zo_strformat(SI_SPEEDRUN_ENABLEUI_NAME),
						tooltip = zo_strformat(SI_SPEEDRUN_ENABLEUI_DESC),
						default = true,
						getFunc = function() return sV.showUI end,
						setFunc = function(value)
								sV.showUI = value
								Speedrun.UpdateUIConfiguration()
						end,
						width = "half"	},

				{		type = "divider"	},

				{   type = "checkbox",		name = "Use Character unique timers for MA & VH",
						tooltip = "On = Will only save and load times set on your current character.\nOff = Will save times to your current profile and will load times set by any of your characters while this setting was off.\n(Only applies to Maelstrom Arena and Vateshran Hollows).",
						default = true,
						getFunc = function() return cV.individualArenaTimers end,
						setFunc = function(newValue)
								cV.individualArenaTimers = newValue
								Speedrun.RefreshProfileSettings()
						end	},

				{		type = "divider"	},

				{   type = "checkbox",		name = "Best Possible & Gain On Last",
						tooltip = "Enable the Best Possible & Gain On Last UI section",
						default = true,
						getFunc = function() return sV.showAdvanced end,
						setFunc = function(newValue)
								sV.showAdvanced = newValue
								Speedrun.UpdateAnchors()
								SpeedRun_Advanced:SetHidden(not newValue)
						end		},

				{   type = "checkbox",		name = "Vateshran Hollows add tracker",
						tooltip = "Enable the monster kill counter UI section for Vateshran Hollows.",
						default = true,
						getFunc = function() return sV.showAdds end,
						setFunc = function(newValue)
								sV.showAdds = newValue
								SpeedRun_Adds:SetHidden(not newValue)
						end		},

        -- {		type = "checkbox",	name = "Simple Display",
				-- 		tooltip = "Display only score, vitality and timer",
				-- 		default = false,
				-- 		getFunc = function() return sV.uiSimple end,
				-- 		setFunc = function(newValue)
				-- 				sV.uiSimple = newValue
				-- 				Speedrun.SetSimpleUI(sV.uiSimple)
				-- 		end,
				-- 		reference = "Speedrun_SimpleUI_Checkbox",
        -- },

				{	  type = "submenu",		name = "Profile Options",
						reference = "Speedrun_ProfileSubmenu",
						controls = {

								{   type = "description",	title = "Currently Active Profile:",
										text = "",
										width = "half",
										reference = "Speedrun_ActiveProfileDescriptionTitle"	},

								{   type = "description",	title = function() return Speedrun.GetActiveProfileDisplay() end,
										text = "",
										width = "half",
										reference = "Speedrun_ActiveProfileDescriptionName"	},

								{		type = 'dropdown',		name = "Select Profile To Use",
										choices = Speedrun:GetProfileNames(),
										getFunc = function() return profileToLoad end,
										setFunc = function(value)
												profileToLoad = value
										end,
										scrollable = 12,
										reference = "Speedrun_ProfileDropdown"	},

								{		type = "button",			name = "Load Profile",
										func = function()
												Speedrun.LoadProfile(profileToLoad)
												SpeedRun_Timer_Container_Profile:SetText(Speedrun.GetActiveProfileDisplay())
										end,
										disabled = function() return profileToLoad == "" and true or false end	},

								{		type = "divider"	},

								{		type = "editbox",			name = "Create New Profile",
										tooltip = "Enter the new profile name and click the Save button to confirm",
										getFunc = function() return "" end,
										setFunc = function(value)
												profileToAdd = value
										end,
										reference = "Speedrun_ProfileEditbox"	},

								{		type = "button",			name = "Save",
										func = Speedrun.AddProfile,
										disabled = function() return profileToAdd == "" and true or false end	},

								{		type = "divider"	},

								{		type = 'dropdown',		name = "Select Profile To Delete",
										choices = Speedrun:GetProfileNames(),
										getFunc = function() return "" end,
										setFunc = function(value)
												profileToDelete = value
										end,
										scrollable = 12,
										reference = "Speedrun_ProfileDeleteDropdown"	},

								{		type = "button",			name = "Delete Profile",
										func = Speedrun.DeleteProfile,
										disabled = function() return profileToDelete == "" and true or false end,
										isDangerous = true,
										warning = "This can't be undone."	},

								-- {		type = "divider"	},

								-- {		type = "description",			title = "Copy Data",
								-- 		text = "Below you can copy data from one profile to another.\nIf you used this addon before profiles were intruduced, then you can copy that data on to selected profile.\n|cdf4242NOTICE!|r This will wipe any new data collected on targeted profile."	},

								-- {		type = 'dropdown',				name = "Profile To Copy From",
								-- 		choices = Speedrun:GetProfileNames(),
								-- 		getFunc = function() return "" end,
								-- 		setFunc = function(value)
								-- 				profileToCopyFrom = value
								-- 		end,
								-- 		scrollable = 12,
								-- 		reference = "Speedrun_ProfileCopyFrom"	},

								-- {		type = 'dropdown',				name = "Profile To Copy To",
								-- 		choices = Speedrun:GetProfileNamesToCopyTo(),
								-- 		getFunc = function() return "" end,
								-- 		setFunc = function(value)
								-- 				profileToCopyTo = value
								-- 		end,
								-- 		scrollable = 12,
								-- 		reference = "Speedrun_ProfileCopyTo"	},

								-- {		type = "button",					name = "Confirm Copy",
								-- 		func = Speedrun.CopyProfile(profileToCopyFrom, profileToCopyTo),
								-- 		disabled = function() return (profileToCopyTo ~= "" and profileToCopyFrom ~= "") and false or true end,
								-- 		isDangerous = true,
								-- 		warning = "This can't be undone. Are you sure?\n|cdf4242NOTICE!|r If you are currently in a trial and [Profile To Copy To] is currently set as active, then this will reload UI."	},

								{		type = "divider"	},

								{		type = "description",		title = "Import Data From Old",
										text = "If you used this addon before profiles were intruduced you can then copy that data on to selected profile.\n|cdf4242NOTICE!|r This will wipe any new data collected on targeted profile."	},

								{		type = 'dropdown',			name = "Profile To Import To",
										choices = Speedrun:GetProfileNames(),
										getFunc = function() return "" end,
										setFunc = function(value)
												Speedrun.profileToImportTo = value
										end,
										scrollable = 12,
										reference = "Speedrun_ProfileImportTo"	},

								{		type = "button",				name = "Confirm Import",
										disabled = function() return Speedrun.profileToImportTo == "" and true or false end,
										isDangerous = true,
										func = function() Speedrun.ImportVariables() end,
										warning = "This can't be undone.\n|cdf4242NOTICE!|r If you are currently in a trial and [Profile To Import To] is currently set as active, then this will reload UI."	},

						}, },

				{   type = "header",		name = "Score Simulator and Records"	},

				{   type = "submenu",		name = "info",
            controls = {
		            {   type = "description",		text = "Details are still under construction"	},

		            {   type = "description",		text = zo_strformat(SI_SPEEDRUN_GLOBAL_DESC)	},

								{   type = "divider"	},

								{		type = "description",
										text = "Available [/speed] commands are:\n[ show ] or [ hide ]: to show or hide the display.\n[ track 0 - 3 ] To get trial updates in chat.\n    [ 0 ]: Only settings change confirmations.\n    [ 1 ]: Trial Checkpoint Updates.\n    [ 2 ]: Internal addon updates.\n    [ 3 ]: All tracked event updates (a lot of spam in trial).\n[ hg ] or [ hidegroup ]: Toggle function on/off. More options available in 'Extra'.\n[ score ]: List score point factors of your current trial in chat"	},

								{   type = "divider"	},

						}, },

				{   type = "submenu",		name = "Trials",
						controls = { --Speedrun.RefreshTrialMenu(),
								Speedrun.CreateRaidMenu(638),
								Speedrun.CreateRaidMenu(636),
								Speedrun.CreateRaidMenu(639),
								Speedrun.CreateRaidMenu(725),
								Speedrun.CreateRaidMenu(975),
								Speedrun.CreateRaidMenu(1000),
								Speedrun.CreateRaidMenu(1051),
								Speedrun.CreateRaidMenu(1121),
								Speedrun.CreateRaidMenu(1196),
								Speedrun.CreateRaidMenu(1263),
						},
						reference = "Speedrun_Trial_Menu" },

				{   type = "submenu",		name = "Arenas",
            controls = {

								-- {   type = "checkbox",		name = "Use Character unique timers for MA and VH",
								-- 		tooltip = "On = Will only save and load times set on your current character.\nOff = Will save times to your current profile and will load times set by any of your characters while this setting was off.\n(Only applies to Maelstrom Arena and Vateshran Hollows).",
					      --     default = true,
					      --     getFunc = function() return cV.individualArenaTimers end,
					      --     setFunc = function(newValue)
					      --         cV.individualArenaTimers = newValue
					      --         Speedrun.RefreshProfileSettings()
					      --     end	},
								--
								-- {   type = "checkbox",		name = "Enable Vateshran Hollows adds UI",
								-- 		tooltip = "Enable the add kill counter UI section for Vateshran Hollows",
					      --     default = true,
					      --     getFunc = function() return sV.showAdds end,
					      --     setFunc = function(newValue)
					      --         sV.showAdds = newValue
					      --         SpeedRun_Adds:SetHidden(not newValue)
				        --   	end		},

								Speedrun.CreateRaidMenu(635),
				        Speedrun.CreateRaidMenu(1082),
				        Speedrun.CreateRaidMenu(677),
								Speedrun.CreateRaidMenu(1227),

						},	},

				{		type = "submenu",		name = "Extra",
						controls = {

								{		type = "checkbox",		name = "Difficulty Updates",
										tooltip = "Print notification in chat if trial difficulty has changed.",
										default = true,
										getFunc = function() return sV.printDiffChange end,
										setFunc = function(newValue)
												sV.printDiffChange = newValue
										end	},

								{		type = "divider"	},

								{		type = "description",	text = "These settings will be applied when using the Hide Group toggle."	},

								{		type = "checkbox",		name = "Hide Nameplates",
										tooltip = "On = nameplates will be hidden.\nOff = nameplates will be shown.\nYour original nameplates setting will be set when Hide Group is turned off.",
										default = true,
										getFunc = function() return sV.hideNameplates end,
					          setFunc = function(newValue)
					              sV.hideNameplates = newValue
					          end,
										width = "half"	},

								{		type = "checkbox",		name = "Hide Healthbars",
										tooltip = "On = healthbars will be hidden.\nOff = healthbars will be shown.\nYour original healthbars setting will be set when Hide Group is turned off.",
										default = true,
										getFunc = function() return sV.hideHealthbars end,
					          setFunc = function(newValue)
					              sV.hideHealthbars = newValue
					          end,
										width = "half"	},

								{		type = "divider"	},

								{		type = "description",
										text = "Block the interaction choice pop-up while in combat and in a location matching the setting's name, allowing you to only use the ressurect option if available.",
										width = "full"	},

								{		type = "checkbox",		name = "Block Always",
										tooltip = "Will apply while in combat in any location.",
										default = false,
										getFunc = function() return cV.interactBlockAny end,
										setFunc = function(newValue)
												cV.interactBlockAny = newValue
										end,
										width = "half"	},

								{		type = "description",	text = "",
										width = "half"	},

								{		type = "checkbox",		name = "Block in Trials",
										tooltip = "Will apply while in combat in any Trial.",
										default = false,
										getFunc = function() return cV.interactBlockTrial end,
										setFunc = function(newValue)
												cV.interactBlockTrial = newValue
										end,
										disabled = function() return cV.interactBlockAny end,
										width = "half"	},

								{		type = "checkbox",		name = "Block in PvP",
										tooltip = "Will apply while in combat in Cyrodiil, Imperial City and Battlegrounds.",
										default = false,
										getFunc = function() return cV.interactBlockPvP end,
										setFunc = function(newValue)
												cV.interactBlockPvP = newValue
										end,
										disabled = function() return cV.interactBlockAny end,
										width = "half"	},

						},	},	}

    LAM2:RegisterOptionControls("Speedrun_Settings", optionsData)
end
