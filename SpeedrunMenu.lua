Speedrun = Speedrun or {}
local Speedrun = Speedrun

local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")

function Speedrun.GetTime(seconds)
    if seconds then
        if seconds < 3600 then
            return string.format("%02d:%02d",
                math.floor((seconds / 60) % 60),
                seconds % 60)
        else
            return string.format("%02d:%02d:%02d",
                math.floor(seconds / 3600),
                math.floor((seconds / 60) % 60),
                seconds % 60)
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
    local totalTime = 0
    for i, x in pairs(Speedrun.customTimerSteps[raidID]) do
        if Speedrun.GetSavedTimer(raidID,i) then
            totalTime = math.floor(Speedrun.GetSavedTimer(raidID,i) / 1000) + totalTime
        end
    end

    local vitality
    if raidID == 638 or raidID == 636 or raidID == 639 or raidID == 1082 or raidID == 635 then
        vitality = 24
    elseif raidID == 725 or raidID == 975 or raidID == 1000 or raidID == 1051 or raidID == 1121 then
        vitality = 36
    elseif raidID == 677 then
        vitality = 15
    end

    local score = tostring(math.floor(Speedrun.GetScore(totalTime, vitality, raidID)))
    local fScore = string.sub(score,string.len(score)-2,string.len(score))
    local dScore = string.gsub(score,fScore,"")
    score = dScore .. "'" .. fScore

    d("|cdf4242" .. zo_strformat(SI_ZONE_NAME,GetZoneNameById(raidID)) .. "|r")
    d(zo_strformat(SI_SPEEDRUN_SIMULATE_FUNCTION, Speedrun.GetTime(totalTime), score))
end

function Speedrun.ResetData(raidID)
    local formatID = raidID
    if raidID == 677 then  --for vMA
        formatID = raidID .. GetUnitName("player")
        if Speedrun.raidList[formatID] == nil or Speedrun.raidList[formatID] == {} then
            formatID = raidID
        end
    end
    if Speedrun.raidList[formatID].timerSteps then
        Speedrun.raidList[formatID].timerSteps = {}
        Speedrun.savedVariables.raidList = Speedrun.raidList
        ReloadUI("ingame")
    end
end

function Speedrun.CreateOptionTable(raidID, step)
    local formatID = raidID 
    if raidID == 677 then  --for vMA
        formatID = raidID .. GetUnitName("player")
        if Speedrun.raidList[formatID] == nil or Speedrun.raidList[formatID] == {} then
            formatID = raidID
        end
    end

    return {type = "editbox",
            name = zo_strformat(SI_SPEEDRUN_STEP_NAME, Speedrun.stepList[raidID][step]),
            tooltip = Speedrun.GetTooltip(Speedrun.raidList[formatID].timerSteps[step]),
            default = "",
            getFunc = function() return tostring(Speedrun.customTimerSteps[raidID][step]) end,
            setFunc = function(newValue)
                Speedrun.savedVariables.customTimerSteps[raidID][step] = newValue
                Speedrun.customTimerSteps[raidID][step] = newValue
            end,
    }
end

function Speedrun.CreateRaidMenu(raidID)
    local raidMenu = {}
    table.insert(raidMenu, {    type = "description",
                                text = zo_strformat(SI_SPEEDRUN_RAID_DESC),
    })

    if raidID == 1051 then
        table.insert(raidMenu, {type = "checkbox",
            name = zo_strformat(SI_SPEEDRUN_ADDS_CR_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_ADDS_CR_DESC),
            default = true,
            getFunc = function() return Speedrun.savedVariables.addsOnCR end,
            setFunc = function(newValue)
                Speedrun.savedVariables.addsOnCR = newValue
                Speedrun.addsOnCR = newValue
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
        table.insert(raidMenu, {type = "dropdown",
            name = zo_strformat(SI_SPEEDRUN_HM_SS_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_HM_SS_DESC),
            choices = choices,
			default = choices[4],
			getFunc = function() return choices[Speedrun.savedVariables.hmOnSS] end,
			setFunc = function(selected)
				for index, name in ipairs(choices) do
					if name == selected then
						Speedrun.savedVariables.hmOnSS = index
						Speedrun.hmOnSS = index
						break
					end
				end
			end,
        })
    end


    for i, x in ipairs(Speedrun.stepList[raidID]) do
        table.insert(raidMenu, Speedrun.CreateOptionTable(raidID, i))
    end

    table.insert(raidMenu, {    type = "button",
                                name = zo_strformat(SI_SPEEDRUN_SIMULATE_NAME),
                                tooltip = zo_strformat(SI_SPEEDRUN_SIMULATE_DESC),
                                func = function()
                                    Speedrun.Simulate(raidID)
                                end,
                                width = "half",
    })

    table.insert(raidMenu, {    type = "button",
                                name = zo_strformat(SI_SPEEDRUN_RESET_NAME),
                                tooltip = zo_strformat(SI_SPEEDRUN_RESET_DESC),
                                func = function()
                                    Speedrun.ResetData(raidID)
                                end,
                                width = "half",
                                isDangerous = true,
                                warning = zo_strformat(SI_SPEEDRUN_RESET_WARNING),
    })

    return {    type = "submenu",
                name = (zo_strformat(SI_ZONE_NAME, GetZoneNameById(raidID))),
                controls = raidMenu,
    }
end
-------------------------
---- Settings Window ----
-------------------------
function Speedrun.CreateSettingsWindow()
    local panelData = {
        type = "panel",
        name = "Speedrun",
        displayName = "Speed|cdf4242Run|r",
        author = "Floliroy, Panaa",
        version = Speedrun.version,
        slashCommand = "/speedrun",
        registerForRefresh = true,
        registerForDefaults = true,
    }

    local cntrlOptionsPanel = LAM2:RegisterAddonPanel("Speedrun_Settings", panelData)

    local optionsData = {
        {   type = "description",
            text = zo_strformat(SI_SPEEDRUN_GLOBAL_DESC),
        },
        {   type = "divider",
        },
        --[[{   type = "checkbox",
            name = zo_strformat(SI_SPEEDRUN_ENABLE_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_ENABLE_DESC),
            default = true,
            getFunc = function() return end,
            setFunc = function(newValue)
                --TODO
            end,
        },]]
        {   type = "checkbox",
            name = zo_strformat(SI_SPEEDRUN_LOCK_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_LOCK_DESC),
            default = true,
            getFunc = function() return Speedrun.isMovable end,
            setFunc = function(newValue)
                Speedrun.isMovable = newValue
                Speedrun.savedVariables.isMovable = newValue
                Speedrun.ToggleMovable()
            end,
        },
        {   type = "checkbox",
            name = zo_strformat(SI_SPEEDRUN_ENABLEUI_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_ENABLEUI_DESC),
            default = true,
            getFunc = function() return Speedrun.uiIsHidden end,
            setFunc = function(newValue)
                Speedrun.uiIsHidden = newValue
                Speedrun.savedVariables.uiIsHidden = newValue
                Speedrun.SetUIHidden(newValue)
            end,
        },
        {   type = "divider",
        },
        Speedrun.CreateRaidMenu(638),
        Speedrun.CreateRaidMenu(636),
        Speedrun.CreateRaidMenu(639),
        Speedrun.CreateRaidMenu(725),
        Speedrun.CreateRaidMenu(975),
        Speedrun.CreateRaidMenu(1000),
        Speedrun.CreateRaidMenu(1051),
        Speedrun.CreateRaidMenu(1121),
        Speedrun.CreateRaidMenu(1082),
        Speedrun.CreateRaidMenu(677),
        Speedrun.CreateRaidMenu(635),
    }

    LAM2:RegisterOptionControls("Speedrun_Settings", optionsData)
end
