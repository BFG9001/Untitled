--Rip
--I kinda want to do some shit with vehicles so I'll just start by adding damage while in prisoner pod entities

local SeatDamage_Config = {}

SeatDamage_Config.BlastScaling = .75
SeatDamage_Config.GeneralScaling = 1

--Hooks

--Bullets
hook.Add("EntityFireBullets", "SeatDamage_Bullet", function(ent, bulletdata)
	//print("Fired")
	local attacker = bulletdata.Attacker or ent:GetOwner() or ent.Owner
	
	--HL2 weapon bullets don't have bulletdata.Attacker and the guns dont have owners, so I have to make a workaround.

	bulletdata._BCallback = bulletdata.Callback
	//print(attacker)
	bulletdata.Callback = function(ply, trace, dmg)
			local HitEnt = trace.Entity
			local PERCENT = SeatDamage_Config.GeneralScaling
			//print(HitEnt)
			if IsValid(HitEnt) and (HitEnt:GetClass() == "prop_vehicle_prisoner_pod") then
				local driver = HitEnt:GetDriver()
				if IsValid(driver) and not (driver == attacker) then
					if IsValid(attacker) and driver:GetShootPos():Distance(bulletdata.Src) > 5 then --This is the workaround.
						dmg:ScaleDamage(PERCENT or 1)
						driver:TakeDamageInfo(dmg)
						//print(PERCENT)
					end
				end
			end
			if bulletdata._BCallback then
				bulletdata._BCallback(ply, trace, dmg)
			end			
		end
	bulletdata.Force = 10
	return true
end)

// Explosions and misc damage
local function DoExplosionSeatDamage( target, dmginfo )
	//print("called")
 	if target:GetClass() == "prop_vehicle_prisoner_pod" then 
	//print("called")
	local blastscale = SeatDamage_Config.BlastScaling

		if IsValid(target:GetDriver()) then

			dmginfo:ScaleDamage(blastscale or .9)

			target:GetDriver():TakeDamage(dmginfo:GetDamage(), dmginfo:GetAttacker(), dmginfo:GetInflictor())
			//target:GetDriver():TakeDamageInfo(dmginfo)
		end
	end
end
hook.Add("EntityTakeDamage","SeatDamage_ExplosionMisc", DoExplosionSeatDamage )
