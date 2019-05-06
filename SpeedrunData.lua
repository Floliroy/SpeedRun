Speedrun = Speedrun or { }
local Speedrun = Speedrun

-------------------
---- Raid List ----
-------------------
Speedrun.raidList = {
    [638] = {
        name = "AA",
        id = 638,
        bestTimer,
        timerSteps = {},
    },
    [636] = {
        name = "HRC",
        id = 636,
        bestTimer,
        timerSteps = {},
    },
    [639] = {
        name = "SO",
        id = 639,
        bestTimer,
        timerSteps = {},
    },
    [725] = {
        name = "MoL",
        id = 725,
        bestTimer,
        timerSteps = {},
    },
    [975] = {
        name = "HoF",
        id = 975,
        bestTimer,
        timerSteps = {},
    },
    [1000] = {
        name = "AS",
        id = 1000,
        bestTimer,
        timerSteps = {},
    },
    [1051] = {
        name = "CR",
        id = 1051,
        bestTimer,
        timerSteps = {},
    },
    [1082] = {
        name = "BRP",
        id = 1082,
        bestTimer,
        timerSteps = {},
    },
    [677] = {
        name = "MA",
        id = 677,
        bestTimer,
        timerSteps = {},
    },
    [635] = {
        name = "DSA",
        id = 635,
        bestTimer,
        timerSteps = {},
    },
}

-----------------------
---- Custom Timers ----
-----------------------
Speedrun.customTimerSteps = {
    [638] = { --AA
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = "",
        [7] = "",
        [8] = ""
    },
    [636] = { --HRC
    },
    [639] = { --SO
    },
    [725] = { --MoL
    },
    [975] = { --HoF
    },
    [1000] = { --AS
    },
    [1051] = { --CR
    },
    [1082] = { --BRP
    },
    [677] = { --MA
    },
    [635] = { --DSA
    },
}

-------------------
---- Step List ----
-------------------
Speedrun.stepList = {
    [638] = { --AA
        [1] = "Begin Lightning Atro",
        [2] = "Kill Lightning Atro",
        [3] = "Begin Stone Atro",
        [4] = "Kill Stone Atro",
        [5] = "Begin Varlariel",
        [6] = "Kill Varlariel",
        [7] = "Begin The Mage",
        [8] = "Kill The Mage"
    },
    [636] = { --HRC
        [1] = "Begin Ra Kotu",
        [2] = "Kill Ra Kotu",
        [3] = "TODO",
        [4] = "TODO",
        [5] = "Begin The Warrior",
        [6] = "Kill The Warrior"
    },
    [639] = { --SO
        [1] = "Begin Mantikora",
        [2] = "Kill Mantikora",
        [3] = "Begin Stonebreaker",
        [4] = "Kill Stonebreaker",
        [5] = "Begin Ozara",
        [6] = "Kill Ozara",
        [7] = "Begin The Serpent",
        [8] = "Kill The Serpent"
    },
    [725] = { --MoL
        [1] = "Begin Zhaj'Hassa",
        [2] = "Kill Zhaj'Hassa",
        [3] = "Begin Twins",
        [4] = "Kill Twins",
        [5] = "Begin Rakkhat",
        [6] = "Kill Rakkhat"
    },
    [975] = { --HoF
        [1] = "Begin Hunter Killer",
        [2] = "Kill Hunter Killer",
        [3] = "Begin Factotum",
        [4] = "Kill Factotum",
        [5] = "Begin Archcustodian",
        [6] = "Kill Archcustodian",
        [7] = "Begin Commitee",
        [8] = "Kill Commitee",
        [9] = "Begin Assembly",
        [10] = "Kill Assembly"
    },
    [1000] = { --AS
        [1] = "Begin Olms",
        [2] = "90% HP",
        [3] = "75% HP",
        [4] = "50% HP",
        [5] = "25% HP",
        [6] = "Kill Olms"
    },
    [1051] = { --CR
        [1] = "Begin Z'Maja",
        [2] = "Siroria",
        [3] = "Relequen",
        [4] = "Galenwe",
        [5] = "Shadow Appear",
        [6] = "Kill Shadow"
    },
    [1082] = { --BRP
        --Comment ce comportera l'addon sur le 4eme stage ?
    },
    [677] = { --MA
        --TODO (flemme)
    },
    [635] = { --DSA
        --TODO (flemme)
    },
}

--TEST
Speedrun.raidList[639].timerSteps[1] = 1000
Speedrun.raidList[639].timerSteps[2] = 1200000
Speedrun.raidList[639].timerSteps[3] = 2200000
Speedrun.raidList[639].timerSteps[4] = 2400000
Speedrun.raidList[639].timerSteps[5] = 3000000
Speedrun.raidList[639].timerSteps[6] = 3600000
Speedrun.raidList[639].timerSteps[7] = 4600000
Speedrun.raidList[639].timerSteps[8] = 5600000

Speedrun.raidList[638].timerSteps[1] = 1800000
Speedrun.raidList[638].timerSteps[2] = 1900000
Speedrun.raidList[638].timerSteps[3] = 2200000
Speedrun.raidList[638].timerSteps[4] = 2400000
Speedrun.raidList[638].timerSteps[5] = 3000000
Speedrun.raidList[638].timerSteps[6] = 3600000
Speedrun.raidList[638].timerSteps[7] = 4600000
Speedrun.raidList[638].timerSteps[8] = 5600000
