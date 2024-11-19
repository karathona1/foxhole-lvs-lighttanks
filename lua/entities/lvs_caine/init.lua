AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "sh_tracks.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_optics.lua" )
AddCSLuaFile( "cl_tankview.lua" )
include("shared.lua")
include("sh_turret.lua")
include("sh_tracks.lua")


function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(10,0,20), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local ID_G = self:LookupAttachment( "muzzle_end" )
	local Gunner = self:GetAttachment( ID_G )
	local GunnerSeat = self:AddPassengerSeat( Vector(10,0,50), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = false
	self:SetGunnerSeat( GunnerSeat )

	local ID = self:LookupAttachment( "muzzle_end" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "vehicles/MortarTankShot01.wav", "vehicles/MortarTankShot01.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	self:AddEngine( Vector(-72,0,72), Angle(0,-90,0) )
	self:AddFuelTank( Vector(-82,0,71), Angle(0,0,0), 800, LVS.FUELTYPE_PETROL )

	//FRONT ARMOR
	self:AddArmor( Vector(80,0,40), Angle( 0,0,0 ), Vector(-10,-35,-15), Vector(10,35,45), 1000, self.FrontArmor )

	//LEFT ARMOR
	self:AddArmor( Vector(15,45,65), Angle( 0,0,0 ), Vector(-100,-10,-10), Vector(60,10,20), 800, self.SideArmor )

	//RIGHT ARMOR
	self:AddArmor( Vector(15,-45,65), Angle( 0,0,0 ), Vector(-100,-10,-10), Vector(60,10,20), 800, self.SideArmor )

	//BACK ARMOR
	self:AddArmor( Vector(-85,0,65), Angle( 75,0,0 ), Vector(-10,-45,-15), Vector(10,45,50), 600, self.BackArmor )


	//TURRET ARMOR
	local TurretArmor = self:AddArmor( Vector(20,0,85), Angle(0,0,0), Vector(-40,-40,0), Vector(40,40,35), 1200, self.TurretArmor )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
	TurretArmor:SetLabel( "Turret" )
	self:SetTurretArmor( TurretArmor )

	self:AddTrailerHitch( Vector(-112.92,0,37.25), LVS.HITCHTYPE_MALE )

end

function ENT:MakeProjectile()

	local ID = self:LookupAttachment( "muzzle_end" )
	local Muzzle = self:GetAttachment( ID )

	if not Muzzle then return end
	local Driver = self:GetDriver()
	local projectile = ents.Create( "lvs_bomb" )

	local ang = Muzzle.Ang
	projectile:SetPos(Muzzle.Pos)
	ang:RotateAroundAxis(ang:Right(), 180)
	projectile:SetAngles(ang)
	projectile:SetParent(self, ID)
	projectile:Spawn()
	projectile:Activate()
	projectile:SetModel("models/proj_arcrpg.mdl")
	projectile:SetAttacker(IsValid(Driver) and Driver or self)
	projectile:SetEntityFilter(self:GetCrosshairFilterEnts())
	projectile:SetSpeed(Muzzle.Ang:Forward() * 2500)
	projectile:SetRadius(300)
	projectile:SetDamage(300)

	projectile.UpdateTrajectory = function( bomb )
		bomb:SetSpeed( bomb:GetForward() * 2500 )
	end

	if projectile.SetMaskSolid then
		projectile:SetMaskSolid( true )
	end

	self._ProjectileEntity = projectile
end

function ENT:FireProjectile()

	local ID = self:LookupAttachment( "muzzle_end" )
	local Muzzle = self:GetAttachment( ID )

	if not Muzzle or not IsValid( self._ProjectileEntity ) then return end

	self._ProjectileEntity:Enable()
	self._ProjectileEntity:SetCollisionGroup( COLLISION_GROUP_NONE )

	local effectdata = EffectData()
		effectdata:SetOrigin( self._ProjectileEntity:GetPos() )
		effectdata:SetEntity( self._ProjectileEntity )
	util.Effect( "lvs_haubitze_trail", effectdata )

	local effectdata = EffectData()
	effectdata:SetOrigin( Muzzle.Pos)
	effectdata:SetNormal( -Muzzle.Ang:Forward() )
	effectdata:SetEntity( self )
	util.Effect( "lvs_muzzle", effectdata )

	local PhysObj = self:GetPhysicsObject()
	if IsValid( PhysObj ) then
		PhysObj:ApplyForceOffset( Muzzle.Ang:Forward() * 100000, Muzzle.Pos )
	end

	self:TakeAmmo()
	self:SetHeat( 1 )
	self:SetOverheated( true )

	self._ProjectileEntity = nil

	if not IsValid( self.SNDTurret ) then return end

	self.SNDTurret:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

	self:EmitSound("vehicles/MortarReload.wav", 100, 100, 1, CHAN_WEAPON )
end

-- set material on death
function ENT:OnDestroyed()
	self:SetMaterial("props/metal_damaged")
end
