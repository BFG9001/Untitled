AddCSLuaFile()

local __spin360_time, __spin360, __yaw, __newyaw, CLHasDone360


function Spin360(time)
	__spin360_time = time
	__spin360 = true
	__yaw = LocalPlayer():GetAngles( ).y
  __newyaw = __yaw + 360
	CLHasDoneA360 = true
	timer.Simple(0.5, function()
		CLHasDoneA360 = false
	end)
end

local view
local function CalcView( pl, pos, ang, fov )
	if __spin360 then
	view = GAMEMODE:CalcView( pl, pos, ang, fov )
	
	__yaw = math.Clamp(__yaw + FrameTime( ) * __spin360_time * 360,__yaw, __newyaw)
	
	if __yaw == __newyaw then
		__spin360 = false
	end
	
	view.angles.y = __yaw
 
	return view
	end
end

hook.Add( "CalcView", "SpinView360", CalcView )

local function WeaponEquip( _, wep )
  if wep:IsWeapon() then
  wep.SecondaryAttack360 = wep.SecondaryAttack --why not preserve original function?
  wep.SecondaryAttack = function(self)
    	Spin360()
    	self:SecondaryAttack()
    end
  end
end
hook.Add("AllowPlayerPickup", "do360", WeaponEquip )
