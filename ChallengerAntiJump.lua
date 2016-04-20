require('OpenPredict')

ChallengerAntiJumpVersion     = "0.01"

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
  if not self.Supported[GetObjectName(myHero)] then PrintChat(string.format("<b><font color='#EE2EC'>Challenger AntiJump -</font></b><b><font color='#ff0000'> "..GetObjectName(myHero).." Is Not Supported! </font></b>")) return end
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
