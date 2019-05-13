-------------------------
---- Variables    ----
-------------------------
Speedrun = Speedrun or {}
local Speedrun = Speedrun
local WM = GetWindowManager()
local globalTimer
local previousSegment
local currentRaid


-------------------------
---- Functions       ----
-------------------------
function Speedrun.SaveLoc()
    Speedrun.savedVariables["speedrun_container_OffsetX"] = SpeedRun_Timer_Container:GetLeft()
    Speedrun.savedVariables["speedrun_container_OffsetY"] = SpeedRun_Timer_Container:GetTop()
end

function Speedrun.ResetUI()
    SpeedRun_Timer_Container:SetHeight(0)
    if Speedrun.segments then
        for i,x in ipairs(Speedrun.segments) do
            x:SetHidden(true)
        end
    end
end

function Speedrun.ResetAnchors()
    SpeedRun_Timer_Container:ClearAnchors()
    SpeedRun_Timer_Container:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, Speedrun.savedVariables["speedrun_container_OffsetX"], Speedrun.savedVariables["speedrun_container_OffsetY"])
end

function Speedrun.ToggleMovable()
    local self = Speedrun
    if not Speedrun.isMovable then
        SpeedRun_Timer_Container:SetMovable(true)

        Speedrun.SetUIHidden(false)
    else
        SpeedRun_Timer_Container:SetMovable(false)

        Speedrun.SetUIHidden(true)
    end
end

function Speedrun.SetUIHidden(hide)
    SpeedRun_Timer_Container:SetHidden(hide)
    SpeedRun_TotalTimer_Title:SetHidden(hide)
    SpeedRun_Advanced:SetHidden(hide)
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
    Speedrun.segmentTimer = {}

    local raid = Speedrun.raidList[id]
    SpeedRun_Timer_Container_Raid:SetText(zo_strformat(SI_ZONE_NAME, GetZoneNameById(id)))

    for i, x in ipairs(Speedrun.stepList[id]) do

        local segmentRow
        if WM:GetControlByName("SpeedRun_Segment", i) then
            segmentRow = WM:GetControlByName("SpeedRun_Segment", i)
        else
            segmentRow = WM:CreateControlFromVirtual("SpeedRun_Segment", SpeedRun_Timer_Container, "SpeedRun_Segment", i)
        end
        segmentRow:GetNamedChild('_Name'):SetText(x);

        if Speedrun.GetSavedTimer(raid.id, i) then
            if i == 1 then
                Speedrun.segmentTimer[i] = Speedrun.GetSavedTimer(raid.id, i)
            else
                Speedrun.segmentTimer[i] = Speedrun.GetSavedTimer(raid.id, i) + Speedrun.segmentTimer[i - 1]
            end
            segmentRow:GetNamedChild('_Best'):SetText(Speedrun.FormatRaidTimer(Speedrun.segmentTimer[i], true))
        else
            if i == 1 then
                Speedrun.segmentTimer[i] = 0
            else
                Speedrun.segmentTimer[i] = 0 + Speedrun.segmentTimer[i - 1]
            end
            segmentRow:GetNamedChild('_Best'):SetText("NA:NA")
        end

        --TODO NIQUE TAGRAND LUI DE CON
        if i == 1 then
            segmentRow:SetAnchor(TOPLEFT, SpeedRun_Timer_Container, TOPLEFT, 0, 40)
        else
            segmentRow:SetAnchor(TOPLEFT, SpeedRun_Timer_Container, TOPLEFT, 0, (i * 20) + 20)
        end
        segmentRow:SetHidden(false)
        Speedrun.segments[i] = segmentRow;
    end

    Speedrun.SetUIHidden(false)
    --d(SpeedRun_Timer_Container:GetWidth())
    SpeedRun_Timer_Container_Title:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
    SpeedRun_Timer_Container_Raid:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
end

function Speedrun.UpdateSegment(step, raid)
    --TODO Divide into multiple function
    local difference
    if Speedrun.segmentTimer[step] then
        difference = Speedrun.currentRaidTimer[step] - Speedrun.segmentTimer[step]
    else
        difference = 0
    end

    --TODO correct previousSegementDif
    local previousSegementDif
    if Speedrun.GetSavedTimer(raid.id, step) and step > 1 then
        previousSegementDif = Speedrun.currentRaidTimer[step] - Speedrun.currentRaidTimer[step - 1] - Speedrun.GetSavedTimer(raid.id, step)
    elseif Speedrun.GetSavedTimer(raid.id, step) and step == 1 then
        previousSegementDif = Speedrun.currentRaidTimer[step] - Speedrun.GetSavedTimer(raid.id, step)
    else
        previousSegementDif = 0
    end

    --TODO IF NO PRESAVED TIME
    if Speedrun.segmentTimer[table.getn(Speedrun.segmentTimer)] then 
        local bestPossibleTime = difference + Speedrun.segmentTimer[table.getn(Speedrun.segmentTimer)]
        SpeedRun_Advanced_BestPossible_Value:SetText(Speedrun.FormatRaidTimer(bestPossibleTime))
    else
        SpeedRun_Advanced_BestPossible_Value:SetText("NA:NA")
    end    
    SpeedRun_Advanced_PreviousSegment:SetText(Speedrun.FormatRaidTimer(previousSegementDif))
    Speedrun.segments[Speedrun.Step]:GetNamedChild('_Best'):SetText(Speedrun.FormatRaidTimer(Speedrun.currentRaidTimer[step]))

    local segment = Speedrun.segments[Speedrun.Step]:GetNamedChild('_Diff')
    segment:SetText(Speedrun.FormatRaidTimer(difference, true))

    Speedrun.DifferenceColor(difference, segment)
    Speedrun.DifferenceColor(previousSegementDif, SpeedRun_Advanced_PreviousSegment)
end

function Speedrun.DifferenceColor(diff, segment)
    if diff > 0 then
        segment:SetColor(unpack { 1, 0, 0 })
    else
        segment:SetColor(unpack { 0, 1, 0 })
    end
end