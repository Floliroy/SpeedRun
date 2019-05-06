-------------------------
----    Variables    ----
-------------------------
Speedrun = Speedrun or { }
local Speedrun = Speedrun
local WM = GetWindowManager()
local globalTimer
local currentRaid
Speedrun.segments = {}


-------------------------
---- Functions       ----
-------------------------
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
    --Ui
    globalTimer = WM:CreateControlFromVirtual("SpeedRun_Segment",   SpeedRun_Timer_Container, "SpeedRun_Segment")

    local raid = Speedrun.raidList[id]
    for i, x in ipairs(Speedrun.stepList[id]) do

        local segmentRow = WM:CreateControlFromVirtual("SpeedRun_Segment", SpeedRun_Timer_Container, "SpeedRun_Segment", i)
        segmentRow:GetNamedChild('_Name'):SetText(x);

        if raid.timerSteps[i] then
            segmentRow:GetNamedChild('_Best'):SetText(Speedrun.FormatRaidTimer(raid.timerSteps[i], true))
        else
            segmentRow:GetNamedChild('_Best'):SetText("NA:NA")
        end

        segmentRow:SetAnchor(TOPLEFT, SpeedRun_Timer_Container, TOPLEFT, 0, i*20)
        segmentRow:SetHidden(false)
        Speedrun.segments[i] = segmentRow;
    end

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

