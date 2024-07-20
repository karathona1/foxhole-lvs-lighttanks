ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "Storm Tank"
ENT.Author = "Kalamari"
ENT.Information = "Kalamari's Foxhole Vehicles"
ENT.Category = "[LVS] - Foxhole"

ENT.VehicleCategory = "Foxhole"
ENT.VehicleSubCategory = "Light Tank"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/tank_relicstorm.mdl"

ENT.AITEAM = 1

ENT.MaxHealth = 2500

ENT.SpawnNormalOffset = 40

//damage system
ENT.DSArmorIgnoreForce = 1200
ENT.CannonArmorPenetration = 3900

ENT.MaxVelocity = 270
ENT.MaxVelocityReverse = 200

ENT.EngineCurve = 0.1
ENT.EngineTorque = 250

ENT.TransGears = 3
ENT.TransGearsReverse = 1

ENT.FastSteerAngleClamp = 15
ENT.FastSteerDeactivationDriftAngle = 12

ENT.PhysicsWeightScale = 1.5
ENT.PhysicsDampingForward = true
ENT.PhysicsDampingReverse = true

ENT.lvsShowInSpawner = true

ENT.WheelBrakeAutoLockup = true
ENT.WheelBrakeLockupRPM = 15

ENT.EngineSounds = {
	{
		sound = "vehicles/MediumTankIdleLoopW.wav",
		Volume = 5,
		Pitch = 100,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "vehicles/MediumTankDriveLoopW.wav",
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
				pos = Vector(130.22,0,73.7),
				colorB = 200,
				colorA = 150,
			},
			
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(130.22,0,73.7),
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

//anti-tank gun
function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)

	//CANNON
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/bullet_ap.png")
	weapon.Ammo = 40
	weapon.Delay = 5.5
	weapon.HeatRateUp = 1
	weapon.HeatRateDown = 0.1818
	weapon.Attack = function( ent )

		//Gun
		local ID = ent:LookupAttachment( "muzzle_end" )

		local Muzzle = ent:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= -Muzzle.Ang:Forward()
		bullet.Spread 	= Vector(0.005,0.005,0.005)
		bullet.TracerName = "lvs_tracer_autocannon"
		bullet.Force	= 3000
		bullet.HullSize = 1
		bullet.Damage	= 600
		bullet.SplashDamage = 250
		bullet.SplashDamageRadius = 100
		bullet.SplashDamageEffect = "lvs_bullet_impact_explosive"
		bullet.SplashDamageType = DMG_BLAST
		bullet.Velocity = 10000
		bullet.Attacker = ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )
		
		local PhysObj = ent:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:ApplyForceOffset( -bullet.Dir * 50000, bullet.Src )
		end

		ent:TakeAmmo( 1 )

		ent.SNDTurret:PlayOnce( 100 + math.cos( CurTime() + ent:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

		ent:EmitSound("vehicles/FieldGunReloadNew.wav", 75, 100, 1, CHAN_WEAPON )
	end
	weapon.StartAttack = function( ent )
		if not IsValid( ent.SNDTurretMG ) then return end
		ent.SNDTurretMG:Play()
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent.SNDTurretMG ) then return end
		ent.SNDTurretMG:Stop()
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local ID = ent:LookupAttachment( "muzzle_end" )

		local Muzzle = ent:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos, 
				endpos = Muzzle.Pos + -Muzzle.Ang:Forward() * 50000,
				filter = ent:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			ent:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )
			ent:LVSPaintHitMarker( MuzzlePos2D )
		end
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
		pos = Vector(-59.75,-7.38,116.04),
		ang = Angle(270,0,0),
	},
	{
		pos = Vector(-59.75,7.38,116.04),
		ang = Angle(270,0,0),
	},
}