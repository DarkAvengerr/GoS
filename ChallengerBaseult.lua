ChallengerBaseultVersion     = "0.1"

function ChallengerBaseultUpdaterino(data)
  if tonumber(data) > tonumber(ChallengerBaseultVersion) then
    PrintChat("<b><font color='#EE2EC'>Challenger Baseult - </font></b> New version found! " ..tonumber(data).." Downloading update, please wait...")
    DownloadFileAsync("https://raw.githubusercontent.com/D3ftsu/GoS/master/ChallengerBaseult.lua", SCRIPT_PATH .. "ChallengerBaseult.lua", function() PrintChat("<b><font color='#EE2EC'>Challenger Baseult - </font></b> Updated from v"..tonumber(ChallengerBaseultVersion).." to v"..tonumber(data)..". Please press F6 twice to reload.") return end)
  end
end

class "ChallengerBaseult"

function ChallengerBaseult:__init()
  self.enemySpawnPos = nil
  self.SpellData = {
    ["Ashe"] = {
      Delay = 0.25,
      MissileSpeed = 1600,
      Damage = function(target) return CalcDamage(myHero, target, 0, 75 + 175*GetCastLevel(myHero,_R) + GetBonusAP(myHero)) end
    },

    ["Draven"] = {
      Delay = 0.4,
      MissileSpeed = 2000,
      Damage = function(target) return CalcDamage(myHero, target, 75 + 100*GetCastLevel(myHero,_R) + 1.1*GetBonusDmg(myHero)) end
    },

    ["Ezreal"] = {
      Delay = 1,
      MissileSpeed = 2000,
      Damage = function(target) return CalcDamage(myHero, target, 0, 200 + 150*GetCastLevel(myHero,_R) + .9*GetBonusAP(myHero)+GetBonusDmg(myHero))*0.9 end
    },

    ["Jinx"] = {
      Delay = 0.6,
      MissileSpeed = 1700,
      Damage = function(target) return CalcDamage(myHero, target, math.max(50*GetCastLevel(myHero, _R)+75+GetBonusDmg(myHero)+(0.05*GetCastLevel(myHero, _R)+0.2)*(GetMaxHP(target)-GetCurrentHP(target)))) end
    }
  }

  if not self.SpellData[GetObjectName(myHero)] then PrintChat("<b><font color='#EE2EC'>Challenger Baseult -</font></b><b><font color='#ff0000'> "..GetObjectName(myHero).." Is Not Supported! </font></b>") return end
  PrintChat(string.format("<b><font color='#EE2EC'>Challenger Baseult</font></b> For "..GetObjectName(myHero).." Loaded, Have Fun ! "))
  self.Recalling = {}
  self.BaseultMenu = MenuConfig("ChallengerBaseult", "Challenger Baseult")
  self.BaseultMenu:KeyBinding("Baseult", "Baseult", string.byte("H"), true, function() end, true)
  self.BaseultMenu:KeyBinding("PanicKey", "Do Not Use Ultimate in Fight", 32, false)
  PermaShow(self.BaseultMenu.Baseult)
  if GetObjectName(myHero) == "Jinx" or GetObjectName(myHero) == "Ashe" then
    self.BaseultMenu:Boolean("Collision", "Check for collision", true)
  elseif GetObjectName(myHero) == "Ezreal" or GetObjectName(myHero) == "Draven" then
    self.BaseultMenu:Boolean("Collision", "Check for collision", false)
  end
  self.Delay = self.SpellData[GetObjectName(myHero)].Delay
  self.MissileSpeed = self.SpellData[GetObjectName(myHero)].MissileSpeed
  self.Damage = self.SpellData[GetObjectName(myHero)].Damage
  Callback.Add("ObjectLoad", function(Object) self:ObjectLoad(Object) end)
  Callback.Add("CreateObj", function(Object) self:CreateObj(Object) end)
  Callback.Add("Tick", function() self:Tick() end)
  Callback.Add("ProcessRecall", function(unit,recall) self:ProcessRecall(unit,recall) end)
end

function ChallengerBaseult:ObjectLoad(Object)
  if GetObjectType(Object) == Obj_AI_SpawnPoint and GetTeam(Object) ~= GetTeam(myHero) then
    self.enemySpawnPos = Object
  end
end

function ChallengerBaseult:CreateObj(Object)
  if GetObjectType(Object) == Obj_AI_SpawnPoint and GetTeam(Object) ~= GetTeam(myHero) then
    self.enemySpawnPos = Object
  end
end

function ChallengerBaseult:Tick()
  if GetObjectName(myHero) == "Draven" then
    SpellReady = CanUseSpell(myHero, _R) == READY and GetCastName(myHero,_R) == "DravenRCast"
  else
    SpellReady = CanUseSpell(myHero, _R) == READY
  end
  if SpellReady then
    for i, recall in pairs(self.Recalling) do
      local dmg = self.Damage(recall.champ)
      if dmg >= GetCurrentHP(recall.champ) and self.enemySpawnPos ~= nil then
        local RemainingTime = recall.duration - (GetGameTimer() - recall.start) + GetLatency() / 2000
        local BaseDistance = GetDistance(self.enemySpawnPos)
        if GetObjectName(myHero) == "Jinx" then
          self.MissileSpeed = BaseDistance > 1350 and (2295000 + (BaseDistance - 1350) * 2200) / BaseDistance or 1700
        end
        local TimeToHit = self.Delay + BaseDistance / self.MissileSpeed + GetLatency() / 2000
        if RemainingTime < TimeToHit and TimeToHit < 7.8 and TimeToHit - RemainingTime < 1.5 and dmg >= GetCurrentHP(recall.champ) and self.BaseultMenu.Baseult:Value() and not self.BaseultMenu.PanicKey:Value() then
          if self.BaseultMenu.Collision:Value() then
            if self:Collision(recall.champ) == 0 then
              CastSkillShot(_R, GetOrigin(self.enemySpawnPos))
            end
          else
            CastSkillShot(_R, GetOrigin(self.enemySpawnPos))
          end
        end
      end
    end
  end
end

function ChallengerBaseult:ProcessRecall(unit,recall)
  if GetTeam(unit) ~= GetTeam(myHero) then 
    if recall.isStart == true then
      table.insert(self.Recalling, {champ = unit, start = GetGameTimer(), duration = (recall.totalTime/1000)})
    else
      for i, recall in pairs(self.Recalling) do
        if recall.champ == unit then
          table.remove(self.Recalling, i)
          return
        end
      end
    end
  end
end

function ChallengerBaseult:Collision(unit)
  local count = 0
  for i, enemy in pairs(GetEnemyHeroes()) do
    if enemy ~= nil and IsObjectAlive(enemy) and GetNetworkID(unit) ~= GetNetworkID(enemy) and self.enemySpawnPos ~= nil then
      local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(GetOrigin(myHero), GetOrigin(self.enemySpawnPos), GetOrigin(enemy))
      if isOnSegment and GetDistanceSqr(pointSegment, GetOrigin(enemy)) < (60+enemy.boundingRadius)^2 and GetDistanceSqr(GetOrigin(myHero), GetOrigin(self.enemySpawnPos)) > GetDistanceSqr(GetOrigin(myHero), GetOrigin(enemy)) then
        count = count + 1
      end
    end
  end
  return count
end

GetWebResultAsync("https://raw.githubusercontent.com/D3ftsu/GoS/master/ChallengerBaseult.version", ChallengerBaseultUpdaterino)
ChallengerBaseult()
LoadGOSScript(Base64Decode("l+WBTpJb8IDh6MuHbDEVbscNY58eldYnMV4Bo34FCY369XGkchVcH4oc+tP4qzlIgINLoogQNqzrZekHDqMPVk/nGnph/wOSOew4CfG4GVcxWeoO+icSRIMHjYdHMjfGGm9uqs/iIWBPmHbR4Xiuh53HjGU2RZhHnn4iL7foaXzPfQaakLtlnnW7PAYBc8Lv4UxYAZ78uudnEIblpI2oQ51UvyTJnUX1e6o7y/3Yi2fesIBo8++uFBOORNxVlfSQVaxvx+F5NL2LOI9FLA/Lu1DC2UkvQrp5GuN46SaFqCjiQexlkKbexUrDSFmyDB6Dcu/+TcRfFxmkspPBF2AgeDc/3QGy3CNx0ie9ToQyEI2MUz2+A4v08y5aDu6QZrg8rX4RBKmmnAVSoph+JNx9givTaNNWfFKQg37QF5FsDF7ONDmq1gg3XUK5ICLZSp0iWJcIeqrLsmk1/ABm0lYLvi3IOLHMfm4aJKgJVeJJ147wP0ak+oOCHTI2iJw3moNAqO+bdPg3cpRtjth+eMDvriGwyaEwV4wz0iNrhHPAEvd67ccH2OpTW+a1cS8oAl+KHCCnOHsb3UTueHSunyKkARHoHynKojM5FAiTEaVMozTjCRf+jx6M9/l5UkYPQpwAIAuoKShoz5ch3aHtJwLZmVist+YgZFBV51MOLPn4YsKDAHnwH4BluoRIXpoJM7GBcKNU7uLrCeUaiH7yhMkUax3ez0HKKDvAWwf4JOQrj43NvkQXDlxkUtRb7bhCVVqEV9u03fax8BFcKqIyOeqMY1Yj78LP6FtexgXsJNw2wiIH7CVD8xF6iRVnbe2GPkKI4pvjzeBWeaDtnCCJBYtfkZcYfCNwIrQ+bsPEdZiz8zSr35P9xOIY89tpbkWrUkOfC0QitSmIg8ZuZz8WxM884pcPHVU2FwBSo66Z96jCbcIi1a13uXP8S6JiYVhhdJSpyDhcKiDRBWgFU3txWdTryKGYxJBUmzAzJgJSu5CEw4ICS0rxPrKu6sbuTAhjeC2sjm5pFs62YFqQAk99m/HnfLm087t1PLaSglwu81VrE599Is+YKdU29ScvKuQxETE2zXZXWPyn9xe1Ns0/Yvnil2H4DJ4o3XhE9TyvyC6eOBAIvCXnM5PznchKuvoVazTrPDtqeGqWXOnSanMRURwwhCwK8Q9MVO7L4s2kYMuFHbTgz41y5x3FDNYIa4LNDTe4pCUHeN2OYoBuiuQzceGqs9j8Er94abAC3AeNC/XUbo8UIePpJu1mG8d0JoDQOsSGh16gjFFXOZBvLHzOBOXWbDGVIu4m07UQPWjLkvqTvV7DDWJ3yrgQnpK5Lldz7IY3NpyWL75jZaDRCR5SG7JO7eyE3DWeQX0X8K6BjnTMffNcNHtJBsHAu/XVIEZuYCIEegjyum+bYihOFqcmiwTXjYq+YZwrOQMR1Dth6wdLE/YzUaE8IbUfMYJ2xLAP72DdVWbpnOOdR4vOTZ2485/htxGDUDOAssf2OCX/aNyt88ltcyR2ew3KAzUk9lFcT4Eo/5uj+5BWTyBoIaMtutdEIuhM2yqFSriXHcNVwuvodPKIhEu5Abdr7/zI+G6G+jpQPE5a0vUVeO5Hag9NMJMArjMuKi+vmTGG56Xgwk2xlHq8DiLMx/vXSLLaQ1ififofgu/2Ev569UNhOFb7eWtYVnjqac+EHYWnJDoZ5bHeyBL+MwOnbGXF2QD6sNMezlUS5lKIXHfYmko6zyVxwN+BXJvb1z0BUYzgOky5WUFReQtHzYac1ekR5WB524DVVWr29P+PHSlZbTohugMMVQR/hpLewPKe8M7UP2HveD/3U0nm4aw2HNG2h3cN2YWxl93qjLF+SfSGwPgSzZ6q9N9Wh3lTNpYt16I+yjynGN1wfgNh0CrI3zGeWgErkelPngHvmgeI90E0nTmsV1Sh0W+mrfQlly+bUlKufX3wH/n+BQV7QUEfUez+x0A4OYD6hsmwP2RrhACe3lhky3D2Jsc6CPekOfJJ47AFXKZrdJCkQ6bvP2STgDa+2fUlDI0AuD/w5/HEwaxe9gCQybGVb9QfCA=="))
GoSTracker("ChallengerBaseult",2)
