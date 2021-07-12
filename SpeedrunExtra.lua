Speedrun                 = Speedrun or {}
local Speedrun           = Speedrun
local sV
local cV
local LS                 = LoadingScreen_Base
local EM                 = EVENT_MANAGER
Speedrun.slash           = "/speed" or "/SPEED"
Speedrun.prefix          = "|cffffffSpeed|r|cdf4242Run|r: "
Speedrun.trialDifficulty = 1
-------------------------
---- Functions    -------
-------------------------

--[[

/script JumpToSpecificHouse("@playername", houseid)

/script for houseid = 1, 100 do d("["..houseid .."] "..GetCollectibleName(GetCollectibleIdForHouse(houseid))) end

/script JumpToSpecificHouse("@player", 3)

SCENE_MANAGER:GetCurrentScene()

]]

function Speedrun.SlashCommand(string)
		local command = string.lower(string)
	  -- Debug Options ----------------------------------------------------------
    if command == "track 0" then
				d(Speedrun.prefix .. "Tracking: Off")
    		cV.debugMode = 0

		elseif command == "track 1" then
				d(Speedrun.prefix .. "Tracking: low (only checkpoints)")
				cV.debugMode = 1

		elseif command == "track 2" then
				d(Speedrun.prefix .. "Tracking: medium (checkpoints and some function updates)")
				cV.debugMode = 2

	  elseif command == "track 3" then
				d(Speedrun.prefix .. "Tracking: high (everything. can be a lot of spam.)")
				cV.debugMode = 3

		elseif command == "time" then
				d(Speedrun.prefix .. "Game time - start = <<1>>. Duration = <<2>>.", GetGameTimeSeconds() - Speedrun.timeStarted, GetRaidDuration() / 1000)
		-- UI Options -------------------------------------------------------------
		elseif command == "move" or command == "lock" then
				Speedrun.ToggleUILocked()

		elseif command == "hide" then
				Speedrun.SetUIHidden(true)
				-- Speedrun:dbg(0, "UI: Off.")
				-- sV.showUI = false
				-- Speedrun.UpdateUIConfiguration()

		elseif command == "show" then
				Speedrun.SetUIHidden(false)
				-- Speedrun:dbg(0, "UI: On. - Only inside vet trials.")
				-- sV.showUI = true
				-- Speedrun.UpdateUIConfiguration()

		-- Hide Group -------------------------------------------------------------
		elseif command == "hg" or command == "hidegroup" then
				Speedrun.HideGroupToggle()

	  -- Adds -------------------------------------------------------------------
		elseif command == "score" then
				-- if Speedrun.trialState >= 1 then
						Speedrun.PrintScoreReasons()
				-- else
						Speedrun.PrintLastScoreReasons()
				-- end

		elseif command == "lastscore" then
				Speedrun.PrintLastScoreReasons()

		-- elseif command == "sharescore" or command == "SHARESCORE" then
		-- 		Speedrun.ShareScoreReasons()

		elseif (command == "h" and GetDisplayName() == "@nogetrandom") then
				RequestJumpToHouse(38)

		elseif (command == "bisse" and GetDisplayName() == "@Mille_W") then
				JumpToSpecificHouse("@nogetrandom", 70)

		-- Default ----------------------------------------------------------------
    else
        d(Speedrun.prefix .. " Command not recognized!\n[ |cffffff/speed|r (|cffffffcommand|r) ] options are:\n[ |cffffffshow|r or |cffffffhide|r ]: To toggle UI.\n[ |cffffffmove|r or |cfffffflock|r ]: Both will toggle the UI's current lock state.\n[ |cfffffftrack (|cffffff0|r - |cffffff3|r) ]: Chat notification.\n(|cffffff0|r): Only settings change confirmations.\n(|cffffff1|r): Trial checkpoint updates.\n(|cffffff2|r): Checkpoint and internal function updates.\n(|cffffff3|r): Everything the addon is set to register (|cff0000Spam Warning|r).\n[ |cffffffhg|r ] or [ |cffffffhidegroup|r ]: Toggle function on/off.\n[ |cffffffscore|r ]: List current trial score variables in chat.\n[ |cfffffflastscore|r ]: List previous trial score variables in chat (only stores 1 trial, and only if completed).")
    end
end

function Speedrun.LoadUtils()
		sV = Speedrun.savedVariables
		cV = Speedrun.savedSettings

		Speedrun.trialDifficulty = ZO_GetEffectiveDungeonDifficulty()

		SLASH_COMMANDS[Speedrun.slash] = Speedrun.SlashCommand

		Speedrun.ConfigureHideGroup()
		Speedrun.ConfigureCombatInteractBlocker()
		Speedrun.RegisterDifficultyChange()
end

function Speedrun:dbg(debugLevel, ...)
    if debugLevel <= Speedrun.savedSettings.debugMode then
        local message = zo_strformat(...)
        d(Speedrun.prefix .. message)
    end
end

function Speedrun:post( ... )
    local message = zo_strformat(...)
    d( message )
end

function Speedrun.RegisterDifficultyChange()
		local changes      = 0
		local isLoading    = false
		local hasChanged   = false
		local portStart    = 0
		local portFailed   = false
		local loadingStart = 0
		local loadingEnd   = 0

		local function PrintChange(msg)
				d(Speedrun.prefix .. msg)
		end

		local function GetDifficulty()
				local diff = ZO_GetEffectiveDungeonDifficulty() == 2 and "Veteran" or "Normal"
				return diff
		end

		local function OnDifficultyChanged()
				local d = ZO_GetEffectiveDungeonDifficulty()
				if ((not isLoading) and d ~= Speedrun.trialDifficulty) then
						local str = zo_strformat("Difficulty changed to: |cffffff<<1>>|r", GetDifficulty())
						Speedrun.UpdateDifficultySwitch()
						if sV.printDiffChange == true then
								PrintChange(str)
						else
								Speedrun:dbg(1, "<<1>>", str)
						end
						changes = 0
				else
						changes = changes + 1
				end
				Speedrun.trialDifficulty = d
		end

		local function OnPortStarted()
				portFailed = false
				portStart = GetGameTimeMilliseconds()
		end

		local function OnPortFailed()
				portFailed = true
		end

		local function OnLoadingStart()
				isLoading = true
				loadingStart = GetGameTimeMilliseconds()
		end

		local function OnLoadingEnd()
				loadingEnd = GetGameTimeMilliseconds()
				local time = string.format("%.2f",(loadingEnd - LoadingStart) / 1000)
				Speedrun:dbg(2, "Load Time: <<1>> sec.", time)
				if changes == 0 then
						Speedrun:post("No changes.")
				elseif changes == 1 then
						Speedrun:post("<<1>>", str)
				else
						Speedrun:post("Instances have been reset. Difficulty is currently set to: <<1>> after <<2>> changes", GetDifficulty(), changes)
				end
				changes = 0
		end

		-- LS:RegisterCallback("OnPrepareForJump")
		EM:RegisterForEvent(Speedrun.name .. "IsVet1", EVENT_VETERAN_DIFFICULTY_CHANGED, OnDifficultyChanged)
		EM:RegisterForEvent(Speedrun.name .. "IsVet2", EVENT_GROUP_VETERAN_DIFFICULTY_CHANGED, OnDifficultyChanged)
		-- EM:RegisterForEvent(Speedrun.name .. "PortStart", EVENT_PREPARE_FOR_JUMP, OnPortStarted)
		-- EM:RegisterForEvent(Speedrun.name .. "PortFailed", EVENT_JUMP_FAILED, OnPortFailed)
		-- EM:RegisterForEvent(Speedrun.name .. "LoadingStart", EVENT_AREA_LOAD_STARTED, OnLoadingStart)
		-- EM:RegisterForEvent(Speedrun.name .. "LoadingEnd", EVENT_RESUME_FROM_SUSPEND, OnLoadingEnd)

end

local hidden = false
function Speedrun.IsActivalted()
		hidden = false
		Speedrun.ConfigureHideGroup()
		Speedrun.UpdateDifficultySwitch()
end

function Speedrun.ConfigureHideGroup()

		local function RegisterHideGroup()
				if hidden ~= true then
						Speedrun.HideGroup(true)
						hidden = true
				end
		end

		if cV.groupHidden == false then
				EM:UnregisterForEvent(Speedrun.name .. "GroupHidden")
				SetCrownCrateNPCVisible(false)
				SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES, tostring(sV.nameplates))
				SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS, tostring(sV.healthBars))
				hidden = false
				return
		end

		if cV.groupHidden == true then
				RegisterHideGroup()
		end
end

function Speedrun.HideGroupToggle()
		Speedrun.HideGroup(not cV.groupHidden)
end

function Speedrun.HideGroup(hide) --copied from HideGroup by Wheels - thanks!
		local function RestoreNamePlateSettings()
				SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES, tostring(sV.nameplates))
				SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS, tostring(sV.healthBars))
		end

		if hide == true then
				SetCrownCrateNPCVisible(true)
				if cV.groupHidden ~= hide then
						Speedrun:dbg(0, "Hiding Group Members")
						sV.nameplates = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES)
						sV.healthBars = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS)
				end
				if sV.hideNameplates == true then
						SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES, tostring(NAMEPLATE_CHOICE_NEVER))
				end

				if sV.hideHealthbars == true then
						SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS, tostring(NAMEPLATE_CHOICE_NEVER))
				end

				-- EM:UnregisterForEvent(Speedrun.name .. "GroupHidden")
				-- EM:RegisterForEvent(Speedrun.name .. "GroupHidden", EVENT_PLAYER_ACTIVATED,
				-- function()
						-- Speedrun.HideGroup(cV.groupHidden)
				-- end)

		else
				if cV.groupHidden ~= hide then
						local stats = SCENE_MANAGER:GetHUDScene("stats")
						SCENE_MANAGER:SetHUDScene("stats")
						EM:UnregisterForEvent(Speedrun.name .. "GroupHidden")
						zo_callLater(function()
								SetCrownCrateNPCVisible(false)
								RestoreNamePlateSettings()
								SCENE_MANAGER:SetHUDScene("hud")
								SCENE_MANAGER:ShowBaseScene()
								Speedrun:dbg(0, "Showing Group Members")
						end, 10)
				end
		end
		cV.groupHidden = hide
end

function Speedrun.ConfigureCombatInteractBlocker()
		ZO_PreHook(PLAYER_TO_PLAYER, "ShowPlayerInteractMenu", function(shouldBlock)
				if IsUnitInCombat("player") then
						local block = false
						if cV.interactBlockAny then
								block = cV.interactBlockAny
						else
								if (IsInCampaign() or IsActiveWorldBattleground()) then
										block = cV.interactBlockPvP
								elseif Speedrun.IsInTrialZone() then
										block = cV.interactBlockTrial
								end
						end

						if block then
								return true
						end
				end
		end)
end

function Speedrun.PrintScoreReasons()
		Speedrun:dbg(0, "[|cffffffCurrent Trial|r |cdf4242Score|r |cffffffFactors|r]")
		for k, v in pairs(Speedrun.scores) do

				local score = Speedrun.scores[k]
				if score.id ~= RAID_POINT_REASON_LIFE_REMAINING then

						if score.times > 0 then
								Speedrun:post('|cdf4242' .. score.name .. '|r' .. ' x ' .. score.times .. ' = ' .. score.total .. ' points.')
						end
				else
						zo_callLater(function()
								Speedrun:post('|cdf4242' .. score.name .. '|r' .. ' x ' .. score.times)
						end, 100)
				end
		end
end

function Speedrun.UpdateScoreFactors(profile, raid)

		for k, v in pairs(Speedrun.scores) do

				local score = Speedrun.scores[k]

				if (score.id ~= RAID_POINT_REASON_LIFE_REMAINING and score.times > 0) then

						if sV.profiles[profile].raidList[raid].scoreFactors.scoreReasons[k] == nil then
								sV.profiles[profile].raidList[raid].scoreFactors.scoreReasons[k] = score

						else

								local factor = sV.profiles[profile].raidList[raid].scoreFactors.scoreReasons[k]

								if (factor.times < score.times) then
										factor.times = score.times
										sV.profiles[profile].raidList[raid].scoreFactors.scoreReasons[k].times = factor.times
								end

								if factor.total < score.total then
										factor.total = score.total
										sV.profiles[profile].raidList[raid].scoreFactors.scoreReasons[k].total = factor.total
								end
						end
				end
		end

		local best = sV.profiles[profile].raidList[raid].scoreFactors

		if ((best.bestTime == nil) or (best.bestTime > sV.totalTime)) then
				best.bestTime = sV.totalTime
		end

		if ((best.bestScore == nil) or (best.bestScore < sV.finalScore)) then
				best.bestScore = sV.finalScore
		end

		if not Speedrun.IsInTrialZone() then return end

		local vit = GetRaidReviveCountersRemaining()

		if vit > 0 then
				if ((best.vitality < vit) or (best.vitality == nil)) then
						best.vitality = vit
				end
		end
end

function Speedrun.GetTrialMaxVitality(raidID)
		local vitality
		if raidID == 638 or raidID == 636 or raidID == 639 or raidID == 1082 or raidID == 635 then
				vitality = 24

		elseif raidID == 725 or raidID == 975 or raidID == 1000 or raidID == 1051 or raidID == 1121 or raidID == 1196 or raidID == 1263 then
				vitality = 36

		elseif raidID == 677 or raidID == 1227 then
				vitality = 15

		else
				viatality = 0
		end
		return vitality
end

function Speedrun.BestPossible(raidID)

		local timer = 0
		local vitality = Speedrun.GetTrialMaxVitality(raidID)

    for i, x in pairs(Speedrun.customTimerSteps[raidID]) do

				if Speedrun.GetSavedTimer(raidID,i) then
						timer = Speedrun.GetSavedTimer(raidID,i) + timer
        end
    end

		local t = timer > 0 and (timer / 1000) or 0

    local score = math.floor(Speedrun.GetScore(t, vitality, raidID))	--= 0
		local scoreString = Speedrun.FormatRaidScore(score)

		-- TODO Calculate the score using saved score factors is any exists.
		-- local score = GetScoreFromSavedFactors()

		-- local fScore = string.sub(score,string.len(score)-2,string.len(score))
    -- local dScore = string.gsub(score,fScore,"")
    -- score = dScore .. "'" .. fScore
		-- Speedrun:dbg(2, "Best Possible Score Calculated.")
		Speedrun.isScoreSet = true
    return scoreString
end

-- functions for debugging and maybe useful for new functions
function Speedrun.SetLastTrial()
		Speedrun.ResetLastTrial()
		sV.lastScores 		= Speedrun.scores
		sV.lastRaidID 		= sV.raidID
		sV.lastRaidTimer 	= Speedrun.currentRaidTimer
		Speedrun.scores		= Speedrun.GetDefaultScores()
		sV.scores 				= Speedrun.scores
end

function Speedrun.GetLastTrial(score, id, timer)
		local t = {}
		if score 	then	t.score 	= sV.lastScores 		end
		if id 		then 	t.id 			= sV.lastRaidID 		end
		if timer 	then 	t.timer 	= sV.lastRaidTimer 	end
		return t
end

function Speedrun.ResetLastTrial()
		sV.lastScores 		= {}
		sV.lastRaidID 		= 0
		sV.lastRaidTimer 	= {}
end

function Speedrun.PrintLastScoreReasons()
		Speedrun:dbg(0, "[|cffffffLast Trial|r |cdf4242Score|r |cffffffFactors|r]")
		for k, v in pairs(sV.lastScores) do

				local lastScore = sV.lastScores[k]
				if lastScore.id ~= RAID_POINT_REASON_LIFE_REMAINING then

						if lastScore.times > 0 then
								Speedrun:post('|cdf4242' .. lastScore.name .. '|r' .. ' x ' .. lastScore.times .. ' = ' .. lastScore.total .. ' points.')
						end
				else
						zo_callLater(function()
								Speedrun:post('|cdf4242' .. lastScore.name .. '|r' .. ' x ' .. lastScore.times)
						end, 100)
				end
		end
end

function Speedrun.ResolveVeteranDifficulty()
    if GetGroupSize() <= 1 and IsUnitUsingVeteranDifficulty('player') then
        return true
    elseif GetCurrentZoneDungeonDifficulty() == 2 or IsGroupUsingVeteranDifficulty() == true then
        return true
    else
        return false
    end
end

--[[

local function GetScoreFromSavedFactors()
		-- example
		if raidID == 1051 then
				-- adds at side bosses
				score = tostring(math.floor(Speedrun.GetScore(timer, vitality, 1051) - 2250 + sV.profiles[Speedrun.activeProfile].raidList[raidID].scoreFactors.scoreReasons[3].total))
		end
end

function Speedrun.ShareScoreReasons()

		Speedrun.Print(Speedrun.prefix .. "Current Trial Score Factors:")
		for k, v in pairs(Speedrun.scores) do

				local score = Speedrun.scores[k]
				if score.id ~= RAID_POINT_REASON_LIFE_REMAINING then

						if score.times > 0 then
								Speedrun.Print('|cdf4242' .. score.name .. '|r' .. ' x ' .. score.times .. ' = ' .. score.total .. ' points.')
						end
				else
						zo_callLater(function()
								Speedrun.Print('|cdf4242' .. score.name .. '|r' .. ' x ' .. score.times)
						end, 100)
				end
		end
end

function Speedrun.Print( message )
		local outPut = string.format( message )
		CHAT_SYSTEM.textEntry:SetText( outPut )
		CHAT_SYSTEM:Maximize()
		CHAT_SYSTEM.textEntry:Open()
		CHAT_SYSTEM.textEntry:FadeIn()
end
]]

--[[

NameplateDisplayChoice:
		NAMEPLATE_CHOICE_ALL
		NAMEPLATE_CHOICE_ALLY
		NAMEPLATE_CHOICE_ALWAYS
		NAMEPLATE_CHOICE_CENTER
		NAMEPLATE_CHOICE_ENEMY
		NAMEPLATE_CHOICE_INJURED
		NAMEPLATE_CHOICE_INJURED_OR_TARGETED
		NAMEPLATE_CHOICE_INVALID
		NAMEPLATE_CHOICE_LEFT
		NAMEPLATE_CHOICE_NEVER
		NAMEPLATE_CHOICE_NONE
		NAMEPLATE_CHOICE_TARGETED

NameplateDisplayType:

		NAMEPLATE_TYPE_FOLLOWER_INDICATORS

		NAMEPLATE_TYPE_GROUP_INDICATORS
		NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS
		NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS_HIGHLIGHT
		NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES
		NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES_HIGHLIGHT

		NAMEPLATE_TYPE_RESURRECT_INDICATORS
		NAMEPLATE_TYPE_SHOW_PLAYER_GUILDS
		NAMEPLATE_TYPE_SHOW_PLAYER_TITLES
]]
