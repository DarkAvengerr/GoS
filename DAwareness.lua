if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end

local DAwareness = MenuConfig("DAwareness", "DAwareness")
DAwareness:Menu("WayPoints", "WayPoints")
DAwareness.WayPoints:Menu("Allies", "Ally Team")
DAwareness.WayPoints:Menu("Enemies", "Enemy Team")
DAwareness.WayPoints.Allies:Boolean(GetObjectName(myHero).."WP", " "..GetObjectName(myHero).." ", true)
--DAwareness:Menu("CD", "Cooldown")
--DAwareness.CD:Menu("Allies", "Ally Team")
--DAwareness.CD:Menu("Enemies", "Enemy Team")
--DAwareness.CD.Allies:Boolean(GetObjectName(myHero).."CD", " "..GetObjectName(myHero).." ", true)

DelayAction(function()
  for k,v in pairs(GetEnemyHeroes()) do
  DAwareness.WayPoints.Enemies:Boolean(GetObjectName(v).."WP", " "..GetObjectName(v).." ", true)
  --DAwareness.CD.Enemies:Boolean(GetObjectName(v).."CD", " "..GetObjectName(v).." ", true)
  end

  for k,v in pairs(GetAllyHeroes()) do
  DAwareness.WayPoints.Allies:Boolean(GetObjectName(v).."WP", " "..GetObjectName(v).." ", true)
  --DAwareness.CD.Allies:Boolean(GetObjectName(v).."CD", " "..GetObjectName(v).." ", true)
  end
end, 1)

OnProcessWaypoint(function(unit,waypoint)
  for k,v in pairs(GetAllyHeroes()) do
    if GetObjectName(v) == GetObjectName(unit) and DAwareness.WayPoints.Allies[GetObjectName(v).."WP"]:Value() then
      if waypoint.index == 1 then
      place = waypoint.position
      allywaypoint = unit
      end
	  end
  end
  
  for k,v in pairs(GetEnemyHeroes()) do
    if GetObjectName(v) == GetObjectName(unit) and DAwareness.WayPoints.Enemies[GetObjectName(v).."WP"]:Value() then
      if waypoint.index == 1 then
      place2 = waypoint.position
      enemywaypoint = unit
      end
	  end
  end
  
  if unit == GetMyHero() and DAwareness.WayPoints.Allies[GetObjectName(myHero).."WP"]:Value() then
    if waypoint.index == 1 then
    myplace = waypoint.position
    mywaypoint = unit
    end
  end
  
end)
 
OnDraw(function(myHero)
  
  if place and GetDistance(allywaypoint,place) < 1 then place = nil end
  if place ~= nil and DAwareness.WayPoints.Allies[GetObjectName(allywaypoint).."WP"]:Value() then
  local drawPos = WorldToScreen(0,place.x,place.y,place.z)
  DrawLine3D(GetOrigin(allywaypoint).x,GetOrigin(allywaypoint).y,GetOrigin(allywaypoint).z, place.x, place.y, place.z, 1, ARGB(255, 255, 0, 0))
  DrawText(""..GetObjectName(allywaypoint), 15, drawPos.x, drawPos.y-10, ARGB(155, 255, 255, 255))
  DrawText((math.floor(GetDistance(allywaypoint,place)/GetMoveSpeed(allywaypoint)*10)/10).."s", 15, drawPos.x, drawPos.y+10, ARGB(155, 255, 255, 255))
  end

  if place and GetDistance(enemywaypoint,place2) < 1 then place2 = nil end
  if place2 ~= nil and DAwareness.WayPoints.Enemies[GetObjectName(enemywaypoint).."WP"]:Value() then
  local drawPos2 = WorldToScreen(0,place2.x,place2.y,place2.z)
  DrawLine3D(GetOrigin(enemywaypoint).x,GetOrigin(enemywaypoint).y,GetOrigin(enemywaypoint).z, place2.x, place2.y, place2.z, 1, ARGB(255, 255, 0, 0))
  DrawText(""..GetObjectName(enemywaypoint), 15, drawPos2.x, drawPos2.y-10, ARGB(155, 255, 255, 255))
  DrawText((math.floor(GetDistance(enemywaypoint,place2)/GetMoveSpeed(enemywaypoint)*10)/10).."s", 15, drawPos2.x, drawPos2.y+10, ARGB(155, 255, 255, 255))
  end

  if myplace and GetDistance(myplace) < 1 then myplace = nil end
  if myplace ~= nil and DAwareness.WayPoints.Allies[GetObjectName(myHero).."WP"]:Value() then
  local drawPos3 = WorldToScreen(0,myplace.x,myplace.y,myplace.z)
  DrawLine3D(GetOrigin(myHero).x,GetOrigin(myHero).y,GetOrigin(myHero).z, myplace.x, myplace.y, myplace.z, 1, ARGB(255, 255, 0, 0))
  DrawText(""..GetObjectName(myHero), 15, drawPos3.x, drawPos3.y-10, ARGB(155, 255, 255, 255))
  DrawText((math.floor(GetDistance(mywaypoint,myplace)/GetMoveSpeed(myHero)*10)/10).."s", 15, drawPos3.x, drawPos3.y+10, ARGB(155, 255, 255, 255))
  end

end)

function DrawLine3D(x,y,z,a,b,c,width,col)
	local p1 = WorldToScreen(0, Vector(x,y,z))
	local p2 = WorldToScreen(0, Vector(a,b,c))
	DrawLine(p1.x, p1.y, p2.x, p2.y, width, col)
end