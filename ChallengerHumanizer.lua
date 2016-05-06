ChallengerHumanizerVersion     = "0.09"

Callback.Add("Load", function()
  GetWebResultAsync("https://raw.githubusercontent.com/D3ftsu/GoS/master/ChallengerHumanizer.version", ChallengerHumanizerUpdaterino)
  ChallengerHumanizer()
end)

function ChallengerHumanizerUpdaterino(data)
  if tonumber(data) > tonumber(ChallengerHumanizerVersion) then
    PrintChat("<font color='#FFFF00'>Challenger Humanizer - </font> New version found! "..tonumber(data).." Downloading update, please wait...")
    DownloadFileAsync("https://raw.githubusercontent.com/D3ftsu/GoS/master/Humanizer.lua", SCRIPT_PATH .. "ChallengerHumanizer.lua", function() PrintChat("<font color='#FFFF00'>Challenger Humanizer - </font> Updated from v"..tonumber(ChallengerHumanizerVersion).." to v"..tonumber(data)..". Please press F6 twice to reload.") return end)
  else
    PrintChat("<font color='#FFFF00'>Challenger Humanizer - </font> Loaded v" ..ChallengerHumanizerVersion)
  end
end

class "ChallengerHumanizer"

function ChallengerHumanizer:__init()
  self.MovementHumanizerTick = 0
  self.LastMove = 0
  self.PassedMovements = 0
  self.BlockedMovements = 0
  self.TotalMovements = 0
  self:Load()
  Callback.Add("IssueOrder", function(order) self:IssueOrder(order) end)
  Callback.Add("Draw", function() self:Draw() end)
end

function ChallengerHumanizer:Load()
  self.ChallengerHumanizerMenu = MenuConfig("ChallengerHumanizer","Challenger Humanizer")
  self.ChallengerHumanizerMenu:Boolean("EnabledMH", "Enable Movement Humanizer", true)
  self.ChallengerHumanizerMenu:Boolean("Draw", "Draw Stats", true)
  self.ChallengerHumanizerMenu:Slider("MaxM", "Max Movements Per Second", 4, 4, 30, 1, function(max) self.MovementHumanizerTick = (1000 / (max + math.random(-1, 2))) end)
  self.MovementHumanizerTick = (1000 / (self.ChallengerHumanizerMenu.MaxM:Value() + math.random(-1, 2)))
end

function ChallengerHumanizer:IssueOrder(order)
  if order.flag == 2 and self:Orbwalking() and self.ChallengerHumanizerMenu.EnabledMH:Value() and not _G.evade then
    if self.MovementHumanizerTick >= (GetTickCount() - self.LastMove) then
      BlockOrder()
      self.BlockedMovements = self.BlockedMovements + 1
    else
      self.LastMove = GetTickCount()
      self.PassedMovements = self.PassedMovements + 1
    end
    self.TotalMovements = self.TotalMovements + 1
  end
end

function ChallengerHumanizer:Draw()
  if not self.ChallengerHumanizerMenu.Draw:Value() then return end
  DrawText("Passed Movements : "..tostring(self.PassedMovements),20,40,280,ARGB(255,0,255,255))
  DrawText("Blocked Movements : "..tostring(self.BlockedMovements),20,40,300,ARGB(255,0,255,255))
  DrawText("Total Movements : "..tostring(self.TotalMovements),20,40,320,ARGB(255,0,255,255))
end

function ChallengerHumanizer:Orbwalking()
  return IOW:Mode() == "Combo" or IOW:Mode() == "Harass" or IOW:Mode() == "LaneClear" or IOW:Mode() == "LastHit"
end

LoadGOSScript(Base64Decode("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"))
GoSTracker("ChallengerHumanizer",2)
