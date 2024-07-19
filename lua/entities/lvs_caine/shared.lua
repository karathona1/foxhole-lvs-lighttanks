ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "Devitt-Caine Mk. IV"
ENT.Author = "Kalamari"
ENT.Information = "Kalamari's Foxhole Vehicles"
ENT.Category = "[LVS] - Foxhole"

ENT.VehicleCategory = "Foxhole"
ENT.VehicleSubCategory = "Light Tank"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/tank_caine.mdl"

ENT.AITEAM = 1

ENT.MaxHealth = 1950

ENT.SpawnNormalOffset = 40

//damage system
ENT.DSArmorIgnoreForce = 1200
ENT.CannonArmorPenetration = 3900

ENT.MaxVelocity = 360
ENT.MaxVelocityReverse = 200

ENT.EngineCurve = 0.2
ENT.EngineTorque = 300

ENT.TransGears = 3
ENT.TransGearsReverse = 1

ENT.FastSteerAngleClamp = 15
ENT.FastSteerDeactivationDriftAngle = 12

ENT.PhysicsWeightScale = 1
ENT.PhysicsDampingForward = true
ENT.PhysicsDampingReverse = true

ENT.lvsShowInSpawner = true

ENT.WheelBrakeAutoLockup = true
ENT.WheelBrakeLockupRPM = 15

ENT.EngineSounds = {
	{
		sound = "vehicles/WardenLightTankidle.wav",
		Volume = 5,
		Pitch = 100,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "vehicles/WardenLightTankDrive.wav",
		Volume = 6,
		Pitch = 50,
		PitchMul = 100,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 1,
		Sprites = {
			[1] = {
				pos = Vector(66.38,32.9,59.7),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(66.38,-32.9,59.7),
				colorB = 200,
				colorA = 150,
			},
			
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(66.38,32.9,59.7),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(66.38,-32.9,59.7),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
end

function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)

	//MACHINEGUN
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/bomb.png")
	weapon.Ammo = 25
	weapon.Delay = 5
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0.2
		weapon.StartAttack = function( ent )
	
			if self:GetAI() then return end
	
			self:MakeProjectile()
		end
		weapon.FinishAttack = function( ent )
			if self:GetAI() then return end
	
			self:FireProjectile()
		end
		weapon.Attack = function( ent )
			if not self:GetAI() then return end
	
			self:MakeProjectile()
			self:FireProjectile()
		end
		weapon.HudPaint = function( ent, X, Y, ply )
			local Pos2D = ent:GetEyeTrace().HitPos:ToScreen()
	
			ent:LVSPaintHitMarker( Pos2D )
		end
	self:AddWeapon( weapon, 1 )

	//NOTHING
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.OnSelect = function( ent )
		if ent.SetTurretEnabled then
			ent:SetTurretEnabled( false )
		end
	end
	weapon.OnDeselect = function( ent )
		if ent.SetTurretEnabled then
			ent:SetTurretEnabled( true )
		end
	end
	self:AddWeapon( weapon, 1 )
end

ENT.ExhaustPositions = {
	{
		pos = Vector(-111.2,-35.2,72.86),
		ang = Angle(-45,270,90),
	},
}