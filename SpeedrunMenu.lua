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
        return "At the moment your best personnal time is " .. math.floor(timer / 1000) .. " sec.\nEquivalent to " .. Speedrun.GetTime(math.floor(timer / 1000)) .. "."
    else
        return "At the moment you don't have any best personnal."
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
    elseif raidID == 725 or raidID == 975 or raidID == 1000 or raidID == 1051 then
        vitality = 36
    elseif raidID == 677 then
        vitality = 15
    end

    local score = tostring(math.floor(Speedrun.GetScore(totalTime, vitality, raidID)))
    local fScore = string.sub(score,string.len(score)-2,string.len(score))
    local dScore = string.gsub(score,fScore,"")
    score = dScore .. "'" .. fScore

    d("|cdf4242" .. zo_strformat(SI_ZONE_NAME,GetZoneNameById(raidID)) .. "|r")
    d("Your score with a time of " .. Speedrun.GetTime(totalTime) .. " would be " .. score .. ".")
end

function Speedrun.CreateOptionTable(raidID, step)
    return {type = "editbox",
            name = "Step " .. Speedrun.stepList[raidID][step] .. " (sec)",
            tooltip = Speedrun.GetTooltip(Speedrun.raidList[raidID].timerSteps[step]),
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
                                text = "You can use custom step point time or leave it blank to use your best personnal (tooltip will tell you what is your best personnal).\nMake sure to type time in seconds (1 min = 60 sec).",
    })

    if raidID == 1051 then
        table.insert(raidMenu, {type = "checkbox",
            name = "With Adds",
            tooltip = "Set here if you're doing adds before last boss or not.",
            default = true,
            getFunc = function() return Speedrun.savedVariables.addsOnCR end,
            setFunc = function(newValue)
                Speedrun.savedVariables.addsOnCR = newValue
                Speedrun.addsOnCR = newValue
            end,
        })
    end

    for k, v in pairs(Speedrun.stepList[raidID]) do
        table.insert(raidMenu, Speedrun.CreateOptionTable(raidID, k))
    end

    table.insert(raidMenu, {    type = "button",
                                name = "Simulate",
                                tooltip = "You will simulate your best possible score if you do all your best time for all step point without any deaths.",
                                func = function()
                                    Speedrun.Simulate(raidID)
                                end,
                                width = "half",
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
            text = "Here you can set custom step point time to the different trials.\nIf you leave the editbox blank then it will take your best time.\nYou can also simulate your best possible score if you do all your best time for all step point without any deaths.",
        },
        {   type = "divider",
        },
        {   type = "checkbox",
            name = "Enabled",
            tooltip = "Not working for now, it will always be enable",
            default = true,
            getFunc = function() return end,
            setFunc = function(newValue)
                --TODO
            end,
        },
        {   type = "checkbox",
            name = "Lock UI",
            tooltip = "Lock UI to reposition the window on your screen",
            default = true,
            getFunc = function() return Speedrun.isMovable end,
            setFunc = function(newValue)
                Speedrun.isMovable = newValue
                Speedrun.savedVariables.isMovable = newValue
                Speedrun.ToggleMovable()
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
        Speedrun.CreateRaidMenu(1082),
        Speedrun.CreateRaidMenu(677),
        Speedrun.CreateRaidMenu(635),
    }

    LAM2:RegisterOptionControls("Speedrun_Settings", optionsData)
end
