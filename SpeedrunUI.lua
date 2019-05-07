-------------------------
----    Variables    ----
-------------------------
Speedrun = Speedrun or { }
local Speedrun = Speedrun
local WM = GetWindowManager()
local globalTimer
local previousSegment
local currentRaid
Speedrun.segments = {}


-------------------------
---- Functions       ----
-------------------------

function Speedrun.SaveLoc()
    Speedrun.savedVariables["speedrun_container_OffsetX"] = SpeedRun_Timer_Container:GetLeft()
    Speedrun.savedVariables["speedrun_container_OffsetY"] = SpeedRun_Timer_Container:GetTop()
end

function Speedrun.ResetAnchors()
    SpeedRun_Timer_Container:ClearAnchors()
    SpeedRun_Timer_Container:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, Speedrun.savedVariables["speedrun_container_OffsetX"], Speedrun.savedVariables["speedrun_container_OffsetY"])
end

function Speedrun.ToggleMovable()
    local self = Speedrun
    Speedrun.isMovable = not Speedrun.isMovable
    if Speedrun.isMovable then


    else
        SpeedRun_Timer_Container:SetMovable(false)
        SpeedRun_TotalTimer:SetMovable(false)
        SpeedRun_Advanced:SetMovable(false)

        SpeedRun_Timer_Container:SetHidden(true)
        SpeedRun_TotalTimer:SetHidden(true)
        SpeedRun_Advanced:SetHidden(true)
    end
end


function Speedrun.UpdateGlobalTimer()
    SpeedRun_TotalTimer_Title:SetText(Speedrun.FormatRaidTimer(GetRaidDuration(), true))
end


function Speedrun.UpdateWindowPanel(waypoint, raid)
    waypoint = waypoint or 1
    raid = raid or nil
    if waypoint and raid then
        Speedrun.UpdateSegment(waypoint, raid)
    end
    Speedrun.UpdateGlobalTimer()
end

function Speedrun.CreateRaidSegment(id)
    --TODO make initialize function

    --Reset segment control
    Speedrun.segment = {}
    Speedrun.lastBossName = Speedrun.Default.lastBoosName
    Speedrun.raidID = Speedrun.Default.raidID
    Speedrun.Step = Speedrun.Default.Step


    local raid = Speedrun.raidList[id]
    SpeedRun_Timer_Container_Raid:SetText(zo_strformat(SI_ZONE_NAME,GetZoneNameById(id)))

    for i, x in ipairs(Speedrun.stepList[id]) do

        local segmentRow = WM:CreateControlFromVirtual("SpeedRun_Segment", SpeedRun_Timer_Container, "SpeedRun_Segment", i)
        segmentRow:GetNamedChild('_Name'):SetText(x);

        if raid.timerSteps[i] then
            segmentRow:GetNamedChild('_Best'):SetText(Speedrun.FormatRaidTimer(raid.timerSteps[i], true))
        else
            segmentRow:GetNamedChild('_Best'):SetText("NA:NA")
        end

    --TODO NIQUE TAGRAND LUI DE CON
        if i == 1 then
            segmentRow:SetAnchor(TOPLEFT, SpeedRun_Timer_Container, TOPLEFT, 0, 40)
        else
            segmentRow:SetAnchor(TOPLEFT, SpeedRun_Timer_Container, TOPLEFT, 0, (i*20)+20)
        end
        segmentRow:SetHidden(false)
        Speedrun.segments[i] = segmentRow;
    end

    SpeedRun_Timer_Container:SetHidden(false)
    SpeedRun_Advanced:SetHidden(false)
    SpeedRun_TotalTimer:SetHidden(false)
    SpeedRun_Timer_Container_Title:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
    SpeedRun_Timer_Container_Raid:SetHorizontalAlignment(TEXT_ALIGN_CENTER)

end

function Speedrun.UpdateSegment(step, raid)

    --TODO if raid already has steptimer
    --d("UpdateSegment")
    local difference
    if raid.timerSteps[step] then
        difference = GetRaidDuration() - raid.timerSteps[step]
    else
        difference = 0
        Speedrun.segments[Speedrun.Step]:GetNamedChild('_Best'):SetText(Speedrun.FormatRaidTimer(GetRaidDuration()))
    end


    local segment = Speedrun.segments[Speedrun.Step]:GetNamedChild('_Diff')
    segment:SetText(Speedrun.FormatRaidTimer(difference, true))
    if difference > 0 then
        segment:SetColor(unpack{1,0,0})
    else
        segment:SetColor(unpack{0,1,0})
    end
end

