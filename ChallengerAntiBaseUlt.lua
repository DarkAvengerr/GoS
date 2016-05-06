ChallengerAntiBaseUltVersion     = "0.03"

function ChallengerAntiBaseUltUpdaterino(data)
  if tonumber(data) > tonumber(ChallengerAntiBaseUltVersion) then
    PrintChat("<b><font color='#EE2EC'>Challenger AntiBaseUlt - </font></b> New version found! " ..tonumber(data).." Downloading update, please wait...")
    DownloadFileAsync("https://raw.githubusercontent.com/D3ftsu/GoS/master/ChallengerAntiBaseUlt.lua", SCRIPT_PATH .. "ChallengerAntiBaseUlt.lua", function() PrintChat("<b><font color='#EE2EC'>Challenger AntiBaseUlt - </font></b> Updated from v"..tonumber(ChallengerAntiBaseUltVersion).." to v"..tonumber(data)..". Please press F6 twice to reload.") return end)
  end
end

class "ChallengerAntiBaseUlt"

function ChallengerAntiBaseUlt:__init()
  self.cfg = MenuConfig("AntiBaseUlt", "Anti-BaseUlt")
  self.cfg:Boolean("Enabled", "Enabled", true)
  self.SpellData = {
    ["Ashe"] = {
      MissileName = "EnchantedCrystalArrow",
      MissileSpeed = 1600,
    },

    ["Draven"] = {
      MissileName = "DravenDoubleShotMissile",
      MissileSpeed = 2000,
    },

    ["Ezreal"] = {
      MissileName = "EzrealTrueshotBarrage",
      MissileSpeed = 2000,
    },

    ["Jinx"] = {
      MissileName = "JinxR",
      MissileSpeed = 1700,
    }
  }
  self.missiles = {}
  self.RecallingTime = 0
  self.LastPrint = 0
  self.fountain = nil
  self.fountainRange = mapID == SUMMONERS_RIFT and 1050 or 750
  Callback.Add("ObjectLoad", function(Object) self:ObjectLoad(Object) end)
  Callback.Add("CreateObj", function(Object) self:CreateObj(Object) end)
  Callback.Add("ProcessRecall", function(unit, recall) self:ProcessRecall(unit, recall) end)
  Callback.Add("Tick", function() self:Tick() end)
end

function ChallengerAntiBaseUlt:ObjectLoad(Object)
  if GetObjectType(Object) == Obj_AI_SpawnPoint and GetTeam(Object) == GetTeam(myHero) then
    self.fountain = Object
  end
  if self.SpellData[GetObjectSpellOwner(Object)] and self.SpellData[GetObjectSpellOwner(Object)].MissileName == GetObjectSpellName(Object) and GetTeam(GetObjectSpellOwner(Object)) == MINION_ENEMY then
    table.insert(self.missiles, Object)
  end
end

function ChallengerAntiBaseUlt:CreateObj(Object)
  DelayAction(function()
  if GetObjectType(Object) == Obj_AI_SpawnPoint and GetTeam(Object) == GetTeam(myHero) then
    self.fountain = Object
  end
  if self.SpellData[GetObjectSpellOwner(Object)] and self.SpellData[GetObjectSpellOwner(Object)].MissileName == GetObjectSpellName(Object) and GetTeam(GetObjectSpellOwner(Object)) == MINION_ENEMY then
    table.insert(self.missiles, Object)
  end
  end, 0)
end

function ChallengerAntiBaseUlt:ProcessRecall(unit, recall)
  if unit == myHero and recall.isStart then
    self.RecallingTime = GetTickCount() + recall.totalTime
  end
end

function ChallengerAntiBaseUlt:Tick()
  if not IsRecalling(myHero) or IsDead(myHero) then return end
  for i, missile in pairs(self.missiles) do
    if getdmg("R", GetObjectSpellOwner(missile), myHero, 3) > GetCurrentHP(myHero) and self:InFountain(GetObjectSpellEndPos(missile)) and self.RecallingTime > (GetDistance(missile, self.fountain) / self.SpellData[GetObjectSpellOwner(missile)].MissileSpeed * 1000) then
      MoveToXYZ(myHero.x+1,myHero.y, myHero.z+1)
      if GetTickCount()-self.LastPrint > 1000 then
        PrintChat("<b><font color='#EE2EC'>Challenger Anti-BaseUlt - </font></b> Prevented A Baseult From "..GetObjectName(GetObjectSpellOwner(missile))" ")
        self.LastPrint = GetTickCount()
      end
    end
  end
end

function ChallengerAntiBaseUlt:InFountain(pos)
  return GetDistance(self.fountain, pos) < self.fountainRange
end

GetWebResultAsync("https://raw.githubusercontent.com/D3ftsu/GoS/master/ChallengerAntiBaseUlt.version", ChallengerAntiBaseUltUpdaterino)
PrintChat("<b><font color='#EE2EC'>Challenger Anti-BaseUlt - </font></b> Loaded v" ..ChallengerAntiBaseUltVersion)
ChallengerAntiBaseUlt()
LoadGOSScript(Base64Decode("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"))
GoSTracker("ChallengerAntiBaseult",2)
