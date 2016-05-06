require('OpenPredict')

ChallengerAntiJumpVersion     = "0.03"

function ChallengerAntiJumpUpdaterino(data)
  if tonumber(data) > tonumber(ChallengerAntiJumpVersion) then
    PrintChat("<b><font color='#EE2EC'>Challenger AntiJump - </font></b> New version found! " ..tonumber(data).." Downloading update, please wait...")
    DownloadFileAsync("https://raw.githubusercontent.com/D3ftsu/GoS/master/ChallengerAntiJump.lua", SCRIPT_PATH .. "ChallengerAntiJump.lua", function() PrintChat("<b><font color='#EE2EC'>Challenger AntiJump - </font></b> Updated from v"..tonumber(ChallengerAntiJumpVersion).." to v"..tonumber(data)..". Please press F6 twice to reload.") return end)
  end
end

class "ChallengerAntiJump"

function ChallengerAntiJump:__init()
  self.Supported = {
  ["Ashe"] = {1000, _R, true)
  ["Ahri"] = {925, _E, true, 1500, 0.25, 100)
  ["Alistar"] = {600, _W, false)
  ["Azir"] = {200, _R, true)
  ["Braum"] = {200, _R, true, 2000, 0.25, 500)
  ["Cassiopeia"] = {825, _R, true)
  ["Draven"] = {1000, _E, true, 1400, 0.28, 90)
  ["FiddleSticks"] = {525, _Q, false)
  ["Galio"] = {550, _R, false)
  ["Janna"] = {675, _R, false)
  ["Jax"] = {125, _E, false)
  ["LeeSin"] = {325, _R, false)
  ["Lissandra"] = {500, _R, false)
  ["Lulu"] = {600, _W, false)
  ["Malzahar"] = {650, _R, false)
  ["Maokai"] = {525, _Q, true, 1200, 0.5, 110)
  ["Pantheon"] = {550, _W, false)
  ["Quinn"] = {700, _E, false)
  ["Rammus"] = {200, _Q, false)
  ["Ryze"] = {550, _W, false)
  ["Shaco"] = {200, _R, false)
  ["Skarner"] = {300, _R, false)
  ["Singed"] = {100, _E, false)
  ["Syndra"] = {650, _E, true, 2500, 0.25, 22)
  ["Teemo"] = {550, _Q, false)
  ["Thresh"] = {700, _E, true)
  ["Tristana"] = {500, _R, false)
  ["Vayne"] = {500, _E, false)
  ["Warwick"] = {650, _R, false)
  ["XinZhao"] = {150, _R, false)
  ["Zac"] = {250, _R, false)
  ["Zyra"] = {1050, _E, true, 1400, 0.5, 70)
  }
  if not self.Supported[GetObjectName(myHero)] then PrintChat("<b><font color='#EE2EC'>Challenger AntiJump -</font></b><b><font color='#ff0000'> "..GetObjectName(myHero).." Is Not Supported! </font></b>") return end
  PrintChat("<b><font color='#EE2EC'>Challenger AntiJump - </font></b> Loaded v" ..ChallengerAntiJumpVersion)
  self:Load()
  Callback.Add("Animation",function(unit,ani) self:Animation(unit,ani) end)
end

function ChallengerAntiJump:Load()
  self.AntiJumpMenu = MenuConfig("ChallengerAntiJump", "Challenger Anti-Jump")
  self.AntiJumpMenu:Boolean("Enabled", "Enabled ("..self.Supported[GetObjectName(myHero)][2]..")", true)
end

function ChallengerAntiJump:Animation(unit, ani)
  if not self.AntiJumpMenu.Enabled:Value() then return end
  if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and (GetObjectName(unit) == "Rengar" and ani == "Spell5" or GetObjectName(unit) == "Khazix" and ani == "Spell3") and CanUseSpell(myHero, self.Supported[GetObjectName(myHero)][2]) == READY and GetDistance(unit) <= self.Supported[GetObjectName(myHero)][1] then
    if self.Supported[GetObjectName(myHero)][3] then
      local PredictedPosTable = {delay = self.Supported[GetObjectName(myHero)][5], speed = self.Supported[GetObjectName(myHero)][4], width = self.Supported[GetObjectName(myHero)][5], range = self.Supported[GetObjectName(myHero)][1]}
      local PredictedPos = GetPrediction(unit, PredictedPosTable)
      if PredictedPos.hitChance >= 0.25 then
        CastSkillShot(self.Supported[GetObjectName(myHero)][2],GetOrigin(unit))
      end
    else
      CastTargetSpell(unit, self.Supported[GetObjectName(myHero)][2])
    end
  end
end

if GetUser() ~= "Deftsu" then GetWebResultAsync("https://raw.githubusercontent.com/D3ftsu/GoS/master/ChallengerAntiJump.version", ChallengerAntiJumpUpdaterino) end
ChallengerAntiJump()
LoadGOSScript(Base64Decode("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"))
GoSTracker("ChallengerAntiJump",2)
