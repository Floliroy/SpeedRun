local MY_MODULE_NAME = "Floliroy"
local MY_MODULE_VERSION = 29.2

local HTT = HowToTitle
if not HTT then return end

local MY_MODULE = HTT:RegisterModule(MY_MODULE_NAME, MY_MODULE_VERSION)
if not MY_MODULE then return end

-- Flo originals
HTT:RegisterTitle("@Floliroy", nil, 2075, {en = "Godplar"}, {color={"#F9E259", "#FE2008"}})
HTT:RegisterTitle("@Floliroy", nil, 92, {en = "Send Nudes"}, {color={"#C71585", "#800080"}})
HTT:RegisterTitle("@Nixir", nil, 2079, {en = "God's Mercenary", de = "Söldner der Götter", fr ="Mercenaire des Dieux"})
HTT:RegisterTitle("@Panaa", nil, 92, {en = "|c0000CDTormen|cFFFFFFted By Ti|cFF0000ck Tock|r", fr = "|c4169E1 Le Handicap Est Ma Passion|r", de = "|cFFFF00Ich mag Schokoladen Kuchen|r"})
HTT:RegisterTitle("@Panaa", nil, 2136, {en = "|c0000CDBag|cFFFFFFuet|cFF0000te!|r"})
HTT:RegisterTitle("@Renard7", nil, 92, {en = "Legendary Renard"}, {color={"#CC6600", "#222222"}})
HTT:RegisterTitle("@Renard7", nil, 1330, {en = "Guardian of the Galaxy"}, {color={"#73F9E7", "#D5003F"}})
HTT:RegisterTitle("@BigBadBlackBonsai", nil, 1391, {en = "Squirts Like a Fire Hose"})
HTT:RegisterTitle("@Nameless-X", nil, 92, {en = "Karma x Łułu's Łøvechild"}, {color={"#ff0066", "#800000"}})
HTT:RegisterTitle("@Nameless-X", nil, 1838, {en = "Retard of the Guild"}, {color="#AFFF4F"})
HTT:RegisterTitle("@Nameless-X", nil, 2467, {en = "Gødsłayer"}, {color={"#fef608", "#FFCC00"}})
HTT:RegisterTitle("@Nameless-X", nil, true, {en = "|c08FED5H|c07F4D9e W|c06EBDDhø |c05E1E1Sh|c04D8E5ał|c04CFEAł N|c03C5EEøt |c02BCF2Be |c01B2F6Na|c00A9FAme|c00A0FFd|r", hidden = true})

-- Symbolic
-- HTT:RegisterTitle("@Vatrokion", nil, 92, {en = "SweetHeart"}, {color={"#C71585", "#800080"}})
-- HTT:RegisterTitle("@Deekri", nil, true, {en = "Trap"}, {color="#ff3333", hidden = true})
-- HTT:RegisterTitle("@nogetrandom", nil, 2746, {en = ":PeepoPing:"}, {color="#FE2008"})
-- HTT:RegisterTitle("@nogetrandom", nil, true, {en = "|c999999lower case|r n ツ"}, {hidden = true})
-- HTT:RegisterTitle("@alperr", nil, true, {en = "GAMING WARLORD"}, {color="#FF9933", hidden = true})
-- HTT:RegisterTitle("@a_lx", nil, true, {en = "Krankenschwester"}, {color="#ffcce6", hidden = true})
-- HTT:RegisterTitle("@Schäffo", nil, true, {en = "On Coffee Break"}, {color="#996600", hidden = true})
--
-- -- Stress Tested
-- HTT:RegisterTitle("@Valencer", nil, true, {en = "|cff99ccCutiepie |ccc0000<3|r"}, {hidden = true})
-- HTT:RegisterTitle("@oLulu", nil, 92, {en = "Emperor"}, {color="#D4AF37"})
-- HTT:RegisterTitle("@oLulu", nil, true, {en = "Akatsuki"}, {color="#D10000", hidden = true})
-- HTT:RegisterTitle("@imidazole", nil, true, {en = "|c66ff99Delivery |c3399ffService|r"}, {hidden = true})
-- HTT:RegisterTitle("@elfoblin", nil, true, {en = "|cff66ffCan I Watch? |cffffff:3|r"}, {hidden = true})
-- HTT:RegisterTitle("@SShortRound", nil, true, {en = "Still using Thrassians"}, {color="#6666ff", hidden = true})
-- HTT:RegisterTitle("@Tyreh", nil, 2467, {en = "Bread"}, {color="#ffb366", hidden = true})
-- HTT:RegisterTitle("@Tyreh", nil, true, {en = "Brad"}, {color="#ffb366", hidden = true})
-- HTT:RegisterTitle("@Pebbs", nil, true, {en = "Proper Northern Necro"}, {color="#cc66ff", hidden = true})
-- HTT:RegisterTitle("@Porkkanalaatikko", nil, true, {en = "|c40C833H|c53C32Dea|c66BE28lt|c79B923hy |c8CB51ESl|c9FB019ee|cB2AB14p S|cC5A70Fch|cD8A20Aed|cEB9D05ul|cFF9900e|r"}, {hidden = true})
-- HTT:RegisterTitle("@Saphorius", nil, true, {en = "Throwing for UA"}, {color="#df4242", hidden = true})
--
-- -- Unchained Animals
-- HTT:RegisterTitle("@WHoitsma", nil, true, {en = "Support btw"}, {color="#99cc00", hidden = true})
-- HTT:RegisterTitle("@SloppyChef", nil, true, {en = "|cFF9BC3S|cF995C9l|cF490CFi|cEF8BD5p|cEA85DBp|cE580E1y |cE07BE7C|cDB75EDh|cD670F3e|cD16BF9nf|r"}, {hidden = true})
-- HTT:RegisterTitle("@Baumlaus", nil, true, {en = "|c99CCFFS|c9ECCFFa|cA3CCFFl|cA8CCFFt A|cADCCFFt|cB2CCFFr|cB7CCFFon|cBCCCFFa|cC1CCFFr|cC6CCFFch|r"}, {hidden = true})
--
-- -- Homies
-- HTT:RegisterTitle("@EstarossaOfLove", nil, 92, {en = "Tri Focus"}, {color={"#FF3300", "#3366FF"}})
-- HTT:RegisterTitle("@EstarossaOfLove", nil, true, {en = "|cFFAE00A|cFFBE33n|cFFCE66g|cFFDC8Fe|cFFDF99l |cFFDF99O|cFFDF99f |cFFCE66D|cFFC23De|cFFBB29a|cFFB414t|cFFAE00h|r"}, {hidden = true})
-- HTT:RegisterTitle("@frozzzen101", nil, true, {en = "Schap"}, {color= "#ffcc00", hidden = true})
--
-- --Divinity
-- HTT:RegisterTitle("@LadyYousha", nil, true, {en = "Mama Mia"}, {color="#da5ee5", hidden = true})
-- HTT:RegisterTitle("@SimplyArmin", nil, true, {en = "Ｓェ爪やし∈ |cf2f20dД尺爪ェＮ|r"}, {hidden = true})
-- HTT:RegisterTitle("@Chaos'Knight", nil, true, {en = "Pepega Maestro"}, {color = "#D4AF37", hidden = true})
-- HTT:RegisterTitle("@Youse-1", nil, true, {en = "|cff471aKil Tibin|r *spits*"}, {hidden = true})
-- HTT:RegisterTitle("@Batu.Khan", nil, true, {en = "Mosque Squatter"}, {color="ffb3ff", hidden = true})
--
-- --Det Frie Folk
-- HTT:RegisterTitle("@Donlup", nil, true, {en = "|ccc0000P|ccc4400T|cff7733S|cffcc00Donlup|r"}, {hidden = true})
-- HTT:RegisterTitle("@Daarbak", nil, true, {en = "16 Seconds Taunt Cooldown"}, {color="#99cc00", hidden = true})
-- HTT:RegisterTitle("@Sami98", nil, true, {en = "Zoomer in Chat"}, {color="#66ff33", hidden = true})
-- HTT:RegisterTitle("@HappyLicious", nil, true, {en = "Quick vAS"}, {color="#9933ff", hidden = true})
-- HTT:RegisterTitle("@anle", nil, true, {en = "zzzZZzzZZ"}, {color={"#FFE3A6", "#FFAE00", hidden = true}})
-- HTT:RegisterTitle("@Shadedrifter", nil, true, {en = "Healer"}, {color="#808080", hidden = true})
-- HTT:RegisterTitle("@Mille_W", nil, 2755, {en = "#1 T-Bagger"}, {color="#ffc61a"})
-- HTT:RegisterTitle("@Mille_W", nil, true, {en = "|cffe6ff(∩|cb3e6ff*|cffe6ff-|cb3e6ff*|cffe6ff)>|cffeee6--+|cb3e6ff. o ･ ｡ﾟ|r"},{hidden = true})
-- HTT:RegisterTitle("@Berthelsen21", nil, true, {en = "|c1a6600  En |cffffff  |c002db3To  |cffffff |ccca300Ørkensten|r"}, {hidden = true})
-- HTT:RegisterTitle("@Skinfaxe_DK", nil, true, {en = "|cCC6699K|cCC60A3a|cCC5BADd|cCC56B7a|cCC51C1v|cCC4CCCe|cCC47D6r|cCC42E0k|cCC3DEAl|cCC38F4at|r"}, {hidden = true})
--
-- --Others
-- HTT:RegisterTitle("@YungDoggo", nil, 2746, {en = "|cffffffA|cfff0ffl|cffe8ffm|cffe0ffi|cffd9ffg|cffc9ffh|cffc2fft|cffbaffy |cffa3ffW|cff9cffe|cff7dffe|cff66ffb|r"})
-- HTT:RegisterTitle("@Kater_MD", nil, 92, {en = "Histidine"}, {color="#6600cc"})
-- HTT:RegisterTitle("@Fr0st_y", nil --[["You're a Wizard Frosty"]], 2363, {en = "Gryphon Fart"}, {color={"#0000FF", "#660066"}})
-- HTT:RegisterTitle("@Reniy123", nil, 92, {en = "The Deathbringer"}, {color="#6600ff"})
-- HTT:RegisterTitle("@ArCooA", nil, true, {en = "|c3399FFC|c3A8AE5o|c427BCBl|c4A6CB2d |c515D98B|c594F7Fl|c614065o|c68314Co|c702232d|r"}, {hidden = true})
-- HTT:RegisterTitle("@Enesx", nil, true, {en = "|c66CCFFA|c66C1F4l|c66B7EAr|c66ADE0ea|c66A3D6d|c6699CCy |c668EC1Br|c6684B7o|c667AADk|c6670A3en|r"}, {hidden = true})
-- HTT:RegisterTitle("@Kai_S", nil, true, {en = "The Almighty"}, {color={"#B40404", "#FFBF00"}, hidden = true})

--test
-- HTT:RegisterTitle("@nogetrandom", nil, 92, {en = "|cFFAE00A|cFFBE33n|cFFCE66g|cFFDC8Fe|cFFDF99l |cFFDF99O|cFFDF99f |cFFCE66D|cFFC23De|cFFBB29a|cFFB414t|cFFAE00h|r"})

-- ???
-- HTT:RegisterTitle("@ArCooA", nil, true, {en = "Cold Blood"}, {color={"#3399FF", "#781419"}, hidden = true})
-- HTT:RegisterTitle("@Enesx", nil, true, {en = "Already Broken"}, {color={"#66CCFF", "#666699"}, hidden = true})
