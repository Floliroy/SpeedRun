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
    for i, x in pairs(Speedrun.raidList[raidID].timerSteps) do
        totalTime = math.floor(x / 1000) + totalTime
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

-------------------------
---- Settings Window ----
-------------------------
function Speedrun.CreateSettingsWindow()
    local panelData = {
        type = "panel",
        name = "Speedrun",
        displayName = "SpeedRun",
        author = "Floliroy, Panaa",
        version = Speedrun.version,
        slashCommand = "/speedrun",
        registerForRefresh = true,
        registerForDefaults = true,
    }

    local cntrlOptionsPanel = LAM2:RegisterAddonPanel("Speedrun_Settings", panelData)

    local optionsData = {
        [1] = {
            type = "description",
            text = "Here you can set custom step point time to the different trials.\nIf you leave the editbox blank then it will take your best time.\nYou can also simulate your best possible score if you do all your best time for all step point without any deaths.",
        },
        [2] = {
            type = "divider",
        },
        [3] = {
            type = "checkbox",
            name = "Enabled",
            tooltip = "a tooltip",
            default = true,
            getFunc = function() return end,
            setFunc = function(newValue)
                --TODO
            end,
        },
        [4] = {
            type = "button",
            name = "Lock",
            tooltip = "Use it to reposition the window.",
            func = function() Speedrun.ToggleMovable() end,
            width = "half",
        },
        [5] = {
            type = "divider",
        },
        [6] = {
            type = "submenu",
            name = (zo_strformat(SI_ZONE_NAME, GetZoneNameById(638))),
            controls = {
                [1] = {
                    type = "description",
                    text = "You can use custom step point time or leave it blank to use your best personnal (tooltip will tell you what is your best personnal).\nMake sure to type time in seconds (1 min = 60 sec).",
                },
                [2] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[638][1] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[1]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[638][1]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[638][1] = tonumber(newValue)
                        Speedrun.customTimerSteps[638][1] = tonumber(newValue)
                    end,
                },
                [3] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[638][2] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[2]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[638][2]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[638][2] = tonumber(newValue)
                        Speedrun.customTimerSteps[638][2] = tonumber(newValue)
                    end,
                },
                [4] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[638][3] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[3]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[638][3]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[638][3] = tonumber(newValue)
                        Speedrun.customTimerSteps[638][3] = tonumber(newValue)
                    end,
                },
                [5] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[638][4] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[4]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[638][4]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[638][4] = tonumber(newValue)
                        Speedrun.customTimerSteps[638][4] = tonumber(newValue)
                    end,
                },
                [6] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[638][5] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[5]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[638][5]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[638][5] = tonumber(newValue)
                        Speedrun.customTimerSteps[638][5] = tonumber(newValue)
                    end,
                },
                [7] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[638][6] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[6]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[638][6]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[638][6] = tonumber(newValue)
                        Speedrun.customTimerSteps[638][6] = tonumber(newValue)
                    end,
                },
                [8] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[638][7] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[7]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[638][7]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[638][7] = tonumber(newValue)
                        Speedrun.customTimerSteps[638][7] = tonumber(newValue)
                    end,
                },
                [9] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[638][8] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[8]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[638][8]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[638][8] = tonumber(newValue)
                        Speedrun.customTimerSteps[638][8] = tonumber(newValue)
                    end,
                },
                [10] = {
                    type = "button",
                    name = "Simulate",
                    tooltip = "You will simulate your best possible score if you do all your best time for all step point without any deaths.",
                    func = function()
                        Speedrun.Simulate(638)
                    end,
                    width = "half",
                },
            },
        },
        [7] = {
            type = "submenu",
            name = (zo_strformat(SI_ZONE_NAME, GetZoneNameById(636))),
            controls = {
                [1] = {
                    type = "description",
                    text = "You can use custom step point time or leave it blank to use your best personnal (tooltip will tell you what is your best personnal).\nMake sure to type time in seconds (1 min = 60 sec).",
                },
                [2] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[636][1] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[636].timerSteps[1]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[636][1]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[636][1] = tonumber(newValue)
                        Speedrun.customTimerSteps[636][1] = tonumber(newValue)
                    end,
                },
                [3] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[636][2] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[636].timerSteps[2]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[636][2]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[636][2] = tonumber(newValue)
                        Speedrun.customTimerSteps[636][2] = tonumber(newValue)
                    end,
                },
                [4] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[636][3] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[636].timerSteps[3]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[636][3]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[636][3] = tonumber(newValue)
                        Speedrun.customTimerSteps[636][3] = tonumber(newValue)
                    end,
                },
                [5] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[636][4] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[636].timerSteps[4]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[636][4]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[636][4] = tonumber(newValue)
                        Speedrun.customTimerSteps[636][4] = tonumber(newValue)
                    end,
                },
                [6] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[636][5] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[636].timerSteps[5]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[636][5]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[636][5] = tonumber(newValue)
                        Speedrun.customTimerSteps[636][5] = tonumber(newValue)
                    end,
                },
                [7] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[636][6] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[636].timerSteps[6]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[636][6]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[636][6] = tonumber(newValue)
                        Speedrun.customTimerSteps[636][6] = tonumber(newValue)
                    end,
                },
                [8] = {
                    type = "button",
                    name = "Simulate",
                    tooltip = "You will simulate your best possible score if you do all your best time for all step point without any deaths.",
                    func = function()
                        Speedrun.Simulate(636)
                    end,
                    width = "half",
                },
            },
        },
        [8] = {
            type = "submenu",
            name = (zo_strformat(SI_ZONE_NAME, GetZoneNameById(639))),
            controls = {
                [1] = {
                    type = "description",
                    text = "You can use custom step point time or leave it blank to use your best personnal (tooltip will tell you what is your best personnal).\nMake sure to type time in seconds (1 min = 60 sec).",
                },
                [2] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[639][1] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[639].timerSteps[1]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[639][1]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[639][1] = tonumber(newValue)
                        Speedrun.customTimerSteps[639][1] = tonumber(newValue)
                    end,
                },
                [3] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[639][2] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[639].timerSteps[2]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[639][2]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[639][2] = tonumber(newValue)
                        Speedrun.customTimerSteps[639][2] = tonumber(newValue)
                    end,
                },
                [4] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[639][3] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[639].timerSteps[3]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[639][3]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[639][3] = tonumber(newValue)
                        Speedrun.customTimerSteps[639][3] = tonumber(newValue)
                    end,
                },
                [5] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[639][4] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[639].timerSteps[4]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[639][4]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[639][4] = tonumber(newValue)
                        Speedrun.customTimerSteps[639][4] = tonumber(newValue)
                    end,
                },
                [6] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[639][5] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[639].timerSteps[5]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[639][5]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[639][5] = tonumber(newValue)
                        Speedrun.customTimerSteps[639][5] = tonumber(newValue)
                    end,
                },
                [7] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[639][6] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[639].timerSteps[6]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[639][6]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[639][6] = tonumber(newValue)
                        Speedrun.customTimerSteps[639][6] = tonumber(newValue)
                    end,
                },
                [8] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[639][7] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[639].timerSteps[7]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[639][7]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[639][7] = tonumber(newValue)
                        Speedrun.customTimerSteps[639][7] = tonumber(newValue)
                    end,
                },
                [9] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[639][8] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[639].timerSteps[8]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[639][8]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[639][8] = tonumber(newValue)
                        Speedrun.customTimerSteps[639][8] = tonumber(newValue)
                    end,
                },
                [10] = {
                    type = "button",
                    name = "Simulate",
                    tooltip = "You will simulate your best possible score if you do all your best time for all step point without any deaths.",
                    func = function()
                        Speedrun.Simulate(639)
                    end,
                    width = "half",
                },
            },
        },
        [9] = {
            type = "submenu",
            name = (zo_strformat(SI_ZONE_NAME, GetZoneNameById(725))),
            controls = {
                [1] = {
                    type = "description",
                    text = "You can use custom step point time or leave it blank to use your best personnal (tooltip will tell you what is your best personnal).\nMake sure to type time in seconds (1 min = 60 sec).",
                },
                [2] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[725][1] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[725].timerSteps[1]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[725][1]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[725][1] = tonumber(newValue)
                        Speedrun.customTimerSteps[725][1] = tonumber(newValue)
                    end,
                },
                [3] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[725][2] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[725].timerSteps[2]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[725][2]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[725][2] = tonumber(newValue)
                        Speedrun.customTimerSteps[725][2] = tonumber(newValue)
                    end,
                },
                [4] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[725][3] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[725].timerSteps[3]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[725][3]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[725][3] = tonumber(newValue)
                        Speedrun.customTimerSteps[725][3] = tonumber(newValue)
                    end,
                },
                [5] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[725][4] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[725].timerSteps[4]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[725][4]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[725][4] = tonumber(newValue)
                        Speedrun.customTimerSteps[725][4] = tonumber(newValue)
                    end,
                },
                [6] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[725][5] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[725].timerSteps[5]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[725][5]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[725][5] = tonumber(newValue)
                        Speedrun.customTimerSteps[725][5] = tonumber(newValue)
                    end,
                },
                [7] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[725][6] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[725].timerSteps[6]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[725][6]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[725][6] = tonumber(newValue)
                        Speedrun.customTimerSteps[725][6] = tonumber(newValue)
                    end,
                },
                [8] = {
                    type = "button",
                    name = "Simulate",
                    tooltip = "You will simulate your best possible score if you do all your best time for all step point without any deaths.",
                    func = function()
                        Speedrun.Simulate(725)
                    end,
                    width = "half",
                },
            },
        },
        [10] = {
            type = "submenu",
            name = (zo_strformat(SI_ZONE_NAME, GetZoneNameById(975))),
            controls = {
                [1] = {
                    type = "description",
                    text = "You can use custom step point time or leave it blank to use your best personnal (tooltip will tell you what is your best personnal).\nMake sure to type time in seconds (1 min = 60 sec).",
                },
                [2] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[975][1] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[975].timerSteps[1]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[975][1]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[975][1] = tonumber(newValue)
                        Speedrun.customTimerSteps[975][1] = tonumber(newValue)
                    end,
                },
                [3] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[975][2] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[975].timerSteps[2]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[975][2]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[975][2] = tonumber(newValue)
                        Speedrun.customTimerSteps[975][2] = tonumber(newValue)
                    end,
                },
                [4] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[975][3] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[975].timerSteps[3]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[975][3]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[975][3] = tonumber(newValue)
                        Speedrun.customTimerSteps[975][3] = tonumber(newValue)
                    end,
                },
                [5] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[975][4] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[975].timerSteps[4]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[975][4]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[975][4] = tonumber(newValue)
                        Speedrun.customTimerSteps[975][4] = tonumber(newValue)
                    end,
                },
                [6] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[975][5] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[975].timerSteps[5]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[975][5]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[975][5] = tonumber(newValue)
                        Speedrun.customTimerSteps[975][5] = tonumber(newValue)
                    end,
                },
                [7] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[975][6] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[975].timerSteps[6]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[975][6]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[975][6] = tonumber(newValue)
                        Speedrun.customTimerSteps[975][6] = tonumber(newValue)
                    end,
                },
                [8] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[975][7] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[975].timerSteps[7]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[975][7]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[975][7] = tonumber(newValue)
                        Speedrun.customTimerSteps[975][7] = tonumber(newValue)
                    end,
                },
                [9] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[975][8] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[975].timerSteps[8]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[975][8]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[975][8] = tonumber(newValue)
                        Speedrun.customTimerSteps[975][8] = tonumber(newValue)
                    end,
                },
                [10] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[975][9] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[975].timerSteps[9]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[975][9]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[975][9] = tonumber(newValue)
                        Speedrun.customTimerSteps[975][9] = tonumber(newValue)
                    end,
                },
                [11] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[975][10] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[975].timerSteps[10]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[975][10]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[975][10] = tonumber(newValue)
                        Speedrun.customTimerSteps[975][10] = tonumber(newValue)
                    end,
                },
                [12] = {
                    type = "button",
                    name = "Simulate",
                    tooltip = "You will simulate your best possible score if you do all your best time for all step point without any deaths.",
                    func = function()
                        Speedrun.Simulate(975)
                    end,
                    width = "half",
                },
            },
        },
        [11] = {
            type = "submenu",
            name = (zo_strformat(SI_ZONE_NAME, GetZoneNameById(1000))),
            controls = {
                [1] = {
                    type = "description",
                    text = "You can use custom step point time or leave it blank to use your best personnal (tooltip will tell you what is your best personnal).\nMake sure to type time in seconds (1 min = 60 sec).",
                },
                [2] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1000][1] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1000].timerSteps[1]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1000][1]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1000][1] = tonumber(newValue)
                        Speedrun.customTimerSteps[1000][1] = tonumber(newValue)
                    end,
                },
                [3] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1000][2] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1000].timerSteps[2]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1000][2]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1000][2] = tonumber(newValue)
                        Speedrun.customTimerSteps[1000][2] = tonumber(newValue)
                    end,
                },
                [4] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1000][3] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1000].timerSteps[3]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1000][3]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1000][3] = tonumber(newValue)
                        Speedrun.customTimerSteps[1000][3] = tonumber(newValue)
                    end,
                },
                [5] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1000][4] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1000].timerSteps[4]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1000][4]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1000][4] = tonumber(newValue)
                        Speedrun.customTimerSteps[1000][4] = tonumber(newValue)
                    end,
                },
                [6] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1000][5] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1000].timerSteps[5]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1000][5]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1000][5] = tonumber(newValue)
                        Speedrun.customTimerSteps[1000][5] = tonumber(newValue)
                    end,
                },
                [7] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1000][6] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1000].timerSteps[6]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1000][6]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1000][6] = tonumber(newValue)
                        Speedrun.customTimerSteps[1000][6] = tonumber(newValue)
                    end,
                },
                [8] = {
                    type = "button",
                    name = "Simulate",
                    tooltip = "You will simulate your best possible score if you do all your best time for all step point without any deaths.",
                    func = function()
                        Speedrun.Simulate(1000)
                    end,
                    width = "half",
                },
            },
        },
        [12] = {
            type = "submenu",
            name = (zo_strformat(SI_ZONE_NAME, GetZoneNameById(1051))),
            controls = {
                [1] = {
                    type = "description",
                    text = "You can use custom step point time or leave it blank to use your best personnal (tooltip will tell you what is your best personnal).\nMake sure to type time in seconds (1 min = 60 sec).",
                },
                [2] = {
                    type = "checkbox",
                    name = "With Adds",
                    tooltip = "Set here if you're doing adds before last boss or not.",
                    default = true,
                    getFunc = function() return Speedrun.savedVariables.addsOnCR end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.addsOnCR = newValue
                        Speedrun.addsOnCR = newValue
                    end,
                },
                [3] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1051][1] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1051].timerSteps[1]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1051][1]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1051][1] = tonumber(newValue)
                        Speedrun.customTimerSteps[1051][1] = tonumber(newValue)
                    end,
                },
                [4] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1051][2] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1051].timerSteps[2]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1051][2]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1051][2] = tonumber(newValue)
                        Speedrun.customTimerSteps[1051][2] = tonumber(newValue)
                    end,
                },
                [5] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1051][3] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1051].timerSteps[3]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1051][3]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1051][3] = tonumber(newValue)
                        Speedrun.customTimerSteps[1051][3] = tonumber(newValue)
                    end,
                },
                [6] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1051][4] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1051].timerSteps[4]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1051][4]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1051][4] = tonumber(newValue)
                        Speedrun.customTimerSteps[1051][4] = tonumber(newValue)
                    end,
                },
                [7] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1051][5] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1051].timerSteps[5]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1051][5]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1051][5] = tonumber(newValue)
                        Speedrun.customTimerSteps[1051][5] = tonumber(newValue)
                    end,
                },
                [8] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1051][6] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1051].timerSteps[6]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1051][6]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1051][6] = tonumber(newValue)
                        Speedrun.customTimerSteps[1051][6] = tonumber(newValue)
                    end,
                },
                [9] = {
                    type = "button",
                    name = "Simulate",
                    tooltip = "You will simulate your best possible score if you do all your best time for all step point without any deaths.",
                    func = function()
                        Speedrun.Simulate(1051)
                    end,
                    width = "half",
                },
            },
        },
        [13] = {
            type = "submenu",
            name = (zo_strformat(SI_ZONE_NAME, GetZoneNameById(1082))),
            controls = {
                [1] = {
                    type = "description",
                    text = "You can use custom step point time or leave it blank to use your best personnal (tooltip will tell you what is your best personnal).\nMake sure to type time in seconds (1 min = 60 sec).",
                },
                [2] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1082][1] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1082].timerSteps[1]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1082][1]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1082][1] = tonumber(newValue)
                        Speedrun.customTimerSteps[1082][1] = tonumber(newValue)
                    end,
                },
                [3] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1082][2] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1082].timerSteps[2]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1082][2]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1082][2] = tonumber(newValue)
                        Speedrun.customTimerSteps[1082][2] = tonumber(newValue)
                    end,
                },
                [4] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1082][3] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1082].timerSteps[3]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1082][3]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1082][3] = tonumber(newValue)
                        Speedrun.customTimerSteps[1082][3] = tonumber(newValue)
                    end,
                },
                [5] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1082][4] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1082].timerSteps[4]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1082][4]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1082][4] = tonumber(newValue)
                        Speedrun.customTimerSteps[1082][4] = tonumber(newValue)
                    end,
                },
                [6] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1082][5] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1082].timerSteps[5]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1082][5]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1082][5] = tonumber(newValue)
                        Speedrun.customTimerSteps[1082][5] = tonumber(newValue)
                    end,
                },
                [7] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[1082][6] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[1082].timerSteps[6]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[1082][6]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[1082][6] = tonumber(newValue)
                        Speedrun.customTimerSteps[1082][6] = tonumber(newValue)
                    end,
                },
                [8] = {
                    type = "button",
                    name = "Simulate",
                    tooltip = "You will simulate your best possible score if you do all your best time for all step point without any deaths.",
                    func = function()
                        Speedrun.Simulate(1082)
                    end,
                    width = "half",
                },
            },
        },
        [14] = {
            type = "submenu",
            name = (zo_strformat(SI_ZONE_NAME, GetZoneNameById(677))),
            controls = {
                [1] = {
                    type = "description",
                    text = "You can use custom step point time or leave it blank to use your best personnal (tooltip will tell you what is your best personnal).\nMake sure to type time in seconds (1 min = 60 sec).",
                },
                [2] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[677][1] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[677].timerSteps[1]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[677][1]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[677][1] = tonumber(newValue)
                        Speedrun.customTimerSteps[677][1] = tonumber(newValue)
                    end,
                },
                [3] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[677][2] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[677].timerSteps[2]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[677][2]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[677][2] = tonumber(newValue)
                        Speedrun.customTimerSteps[677][2] = tonumber(newValue)
                    end,
                },
                [4] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[677][3] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[677].timerSteps[3]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[677][3]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[677][3] = tonumber(newValue)
                        Speedrun.customTimerSteps[677][3] = tonumber(newValue)
                    end,
                },
                [5] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[677][4] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[677].timerSteps[4]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[677][4]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[677][4] = tonumber(newValue)
                        Speedrun.customTimerSteps[677][4] = tonumber(newValue)
                    end,
                },
                [6] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[677][5] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[677].timerSteps[5]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[677][5]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[677][5] = tonumber(newValue)
                        Speedrun.customTimerSteps[677][5] = tonumber(newValue)
                    end,
                },
                [7] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[677][6] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[677].timerSteps[6]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[677][6]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[677][6] = tonumber(newValue)
                        Speedrun.customTimerSteps[677][6] = tonumber(newValue)
                    end,
                },
                [8] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[677][7] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[677].timerSteps[7]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[677][7]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[677][7] = tonumber(newValue)
                        Speedrun.customTimerSteps[677][7] = tonumber(newValue)
                    end,
                },
                [9] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[677][8] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[677].timerSteps[8]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[677][8]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[677][8] = tonumber(newValue)
                        Speedrun.customTimerSteps[677][8] = tonumber(newValue)
                    end,
                },
                [10] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[677][9] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[677].timerSteps[9]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[677][9]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[677][9] = tonumber(newValue)
                        Speedrun.customTimerSteps[677][9] = tonumber(newValue)
                    end,
                },
                [11] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[677][10] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[677].timerSteps[10]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[677][10]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[677][10] = tonumber(newValue)
                        Speedrun.customTimerSteps[677][10] = tonumber(newValue)
                    end,
                },
                [12] = {
                    type = "button",
                    name = "Simulate",
                    tooltip = "You will simulate your best possible score if you do all your best time for all step point without any deaths.",
                    func = function()
                        Speedrun.Simulate(677)
                    end,
                    width = "half",
                },
            },
        },
        [15] = {
            type = "submenu",
            name = (zo_strformat(SI_ZONE_NAME, GetZoneNameById(635))),
            controls = {
                [1] = {
                    type = "description",
                    text = "You can use custom step point time or leave it blank to use your best personnal (tooltip will tell you what is your best personnal).\nMake sure to type time in seconds (1 min = 60 sec).",
                },
                [2] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[635][1] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[635].timerSteps[1]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[635][1]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[635][1] = tonumber(newValue)
                        Speedrun.customTimerSteps[635][1] = tonumber(newValue)
                    end,
                },
                [3] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[635][2] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[635].timerSteps[2]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[635][2]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[635][2] = tonumber(newValue)
                        Speedrun.customTimerSteps[635][2] = tonumber(newValue)
                    end,
                },
                [4] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[635][3] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[635].timerSteps[3]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[635][3]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[635][3] = tonumber(newValue)
                        Speedrun.customTimerSteps[635][3] = tonumber(newValue)
                    end,
                },
                [5] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[635][4] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[635].timerSteps[4]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[635][4]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[635][4] = tonumber(newValue)
                        Speedrun.customTimerSteps[635][4] = tonumber(newValue)
                    end,
                },
                [6] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[635][5] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[635].timerSteps[5]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[635][5]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[635][5] = tonumber(newValue)
                        Speedrun.customTimerSteps[635][5] = tonumber(newValue)
                    end,
                },
                [7] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[635][6] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[635].timerSteps[6]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[635][6]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[635][6] = tonumber(newValue)
                        Speedrun.customTimerSteps[635][6] = tonumber(newValue)
                    end,
                },
                [8] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[635][7] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[635].timerSteps[7]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[635][7]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[635][7] = tonumber(newValue)
                        Speedrun.customTimerSteps[635][7] = tonumber(newValue)
                    end,
                },
                [9] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[635][8] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[635].timerSteps[8]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[635][8]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[635][8] = tonumber(newValue)
                        Speedrun.customTimerSteps[635][8] = tonumber(newValue)
                    end,
                },
                [10] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[635][9] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[635].timerSteps[9]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[635][9]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[635][9] = tonumber(newValue)
                        Speedrun.customTimerSteps[635][9] = tonumber(newValue)
                    end,
                },
                [11] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[635][10] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[635].timerSteps[10]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[635][10]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[635][10] = tonumber(newValue)
                        Speedrun.customTimerSteps[635][10] = tonumber(newValue)
                    end,
                },
                [12] = {
                    type = "editbox",
                    name = "Step " .. Speedrun.stepList[635][11] .. " (sec)",
                    tooltip = Speedrun.GetTooltip(Speedrun.raidList[635].timerSteps[11]),
                    default = "",
                    getFunc = function() return tostring(Speedrun.customTimerSteps[635][11]) end,
                    setFunc = function(newValue)
                        Speedrun.savedVariables.customTimerSteps[635][11] = tonumber(newValue)
                        Speedrun.customTimerSteps[635][11] = tonumber(newValue)
                    end,
                },
                [13] = {
                    type = "button",
                    name = "Simulate",
                    tooltip = "You will simulate your best possible score if you do all your best time for all step point without any deaths.",
                    func = function()
                        Speedrun.Simulate(635)
                    end,
                    width = "half",
                },
            },
        },
    }

    LAM2:RegisterOptionControls("Speedrun_Settings", optionsData)
end
