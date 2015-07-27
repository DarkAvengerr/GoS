Config = scriptConfig("Blitzcrank", "Blitzcrank:")
Config.addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)

OnLoop(function(myHero)
	
        if IWalkConfig.Combo then
	      local target = GetTarget(1000, DAMAGE_MAGIC)
	               if ValidTarget(target, 1000) then
	              	
	              	
		              local QPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),1800,250,925,70,true,true)
                              if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and Config.Q then
                              CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
	                      end
                          
			
                              if CanUseSpell(myHero, _W) == READY and not IsInDistance(target, 150) and IsInDistance(target, 400) and Config.W then
                              CastTargetSpell(myHero, _W)
		              end
			
                              if CanUseSpell(myHero, _E) == READY and IsInDistance(target, 250) and Config.E then
                              CastTargetSpell(myHero, _E)
		              end
		              
		              local RPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),0,250,0,500,false,true)
		              if CanUseSpell(myHero, _R) == READY and RPred.HitChance == 1 and Config.R then
                              CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
	                      end
	                      
                        end
	end	
end)
