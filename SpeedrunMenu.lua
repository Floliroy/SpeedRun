Speedrun = Speedrun or { }
local Speedrun = Speedrun

local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")

function Speedrun.GetTime(seconds)
    if seconds then
        if seconds < 3600 then
            return string.format(
                "%02d:%02d",
                math.floor((seconds / 60) % 60),
                seconds % 60
            )
        else
            return string.format(
                "%02d:%02d:%02d",
                math.floor(seconds / 3600),
                math.floor((seconds / 60) % 60),
                seconds % 60
            )
        end
    end
end

function Speedrun.GetTooltip(timer)
    if timer then
        return "At the moment your best personnal is " .. math.floor(timer / 1000) .. " sec.\nEquivalent to " ..  Speedrun.GetTime(math.floor(timer / 1000))
    else
        return "At the moment you don't have any best personnal." 
    end
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
            type = "submenu",
            name = "Aetherian Archive",
            controls = {
                [1] = { type = "description",
                        text = "You can use custom step point time or leave it blank to use your best personnal (tooltip will tell you what is your best personnal).\nMake sure to type time in seconds (1 min = 60 sec).",
                },
                [2] = { type = "editbox",
                        name = "Step " .. Speedrun.stepList[638][1] .. " (sec)",
                        tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[1]),
                        default = "",
                        getFunc = function() return tostring(Speedrun.customTimerSteps[638][1]) end,
                        setFunc = function(newValue) 
                            Speedrun.savedVariables.customTimerSteps[638][1] = tonumber(newValue)
                            Speedrun.customTimerSteps[638][1] = tonumber(newValue)
                            end,
                },
                [3] = { type = "editbox",
                        name = "Step " .. Speedrun.stepList[638][2] .. " (sec)",
                        tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[2]),
                        default = "",
                        getFunc = function() return tostring(Speedrun.customTimerSteps[638][2]) end,
                        setFunc = function(newValue) 
                            Speedrun.savedVariables.customTimerSteps[638][2] = tonumber(newValue)
                            Speedrun.customTimerSteps[638][2] = tonumber(newValue)
                            end,
                },
                [4] = { type = "editbox",
                        name = "Step " .. Speedrun.stepList[638][3] .. " (sec)",
                        tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[3]),
                        default = "",
                        getFunc = function() return tostring(Speedrun.customTimerSteps[638][3]) end,
                        setFunc = function(newValue) 
                            Speedrun.savedVariables.customTimerSteps[638][3] = tonumber(newValue)
                            Speedrun.customTimerSteps[638][3] = tonumber(newValue)
                            end,
                },
                [5] = { type = "editbox",
                        name = "Step " .. Speedrun.stepList[638][4] .. " (sec)",
                        tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[4]),
                        default = "",
                        getFunc = function() return tostring(Speedrun.customTimerSteps[638][4]) end,
                        setFunc = function(newValue) 
                            Speedrun.savedVariables.customTimerSteps[638][4] = tonumber(newValue)
                            Speedrun.customTimerSteps[638][4] = tonumber(newValue)
                            end,
                },
                [6] = { type = "editbox",
                        name = "Step " .. Speedrun.stepList[638][5] .. " (sec)",
                        tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[5]),
                        default = "",
                        getFunc = function() return tostring(Speedrun.customTimerSteps[638][5]) end,
                        setFunc = function(newValue) 
                            Speedrun.savedVariables.customTimerSteps[638][5] = tonumber(newValue)
                            Speedrun.customTimerSteps[638][5] = tonumber(newValue)
                            end,
                },
                [7] = { type = "editbox",
                        name = "Step " .. Speedrun.stepList[638][6] .. " (sec)",
                        tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[6]),
                        default = "",
                        getFunc = function() return tostring(Speedrun.customTimerSteps[638][6]) end,
                        setFunc = function(newValue) 
                            Speedrun.savedVariables.customTimerSteps[638][6] = tonumber(newValue)
                            Speedrun.customTimerSteps[638][6] = tonumber(newValue)
                            end,
                },
                [8] = { type = "editbox",
                        name = "Step " .. Speedrun.stepList[638][7] .. " (sec)",
                        tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[7]),
                        default = "",
                        getFunc = function() return tostring(Speedrun.customTimerSteps[638][7]) end,
                        setFunc = function(newValue) 
                            Speedrun.savedVariables.customTimerSteps[638][7] = tonumber(newValue)
                            Speedrun.customTimerSteps[638][7] = tonumber(newValue)
                            end,
                },
                [9] = { type = "editbox",
                        name = "Step " .. Speedrun.stepList[638][8] .. " (sec)",
                        tooltip = Speedrun.GetTooltip(Speedrun.raidList[638].timerSteps[8]),
                        default = "",
                        getFunc = function() return tostring(Speedrun.customTimerSteps[638][8]) end,
                        setFunc = function(newValue) 
                            Speedrun.savedVariables.customTimerSteps[638][8] = tonumber(newValue)
                            Speedrun.customTimerSteps[638][8] = tonumber(newValue)
                            end,
                },
                [10] = { type = "button",
                        name = "Simulate",
                        tooltip = "You will simulate your best possible score if you do all your best time for all step point without any deaths.",
                        func = function()
                            d("TODO")
                        end,
                        width = "half",
                },
            }
        }        
	}
	
	LAM2:RegisterOptionControls("Speedrun_Settings", optionsData)
end
