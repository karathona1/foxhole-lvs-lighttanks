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

	local GunnerSeat = self:AddPassengerSeat( Vector(10,0,50), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = false
	self:SetGunnerSeat( GunnerSeat )

	local ID = self:LookupAttachment( "muzzle_end" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "vehicles/LightTankColonialShot01.wav", "vehicles/LightTankColonialShot02.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	self:AddEngine( Vector(-72,0,72), Angle(0,-90,0) )
	self:AddFuelTank( Vector(-82,0,71), Angle(0,0,0), 800, LVS.FUELTYPE_PETROL )

	//FRONT ARMOR
	self:AddArmor( Vector(120,0,40), Angle( 0,0,0 ), Vector(-20,-55,-25), Vector(20,55,50), 1200, self.FrontArmor )

	//LEFT ARMOR
	self:AddArmor( Vector(15,45,65), Angle( 0,0,0 ), Vector(-120,-10,-10), Vector(80,10,40), 1000, self.SideArmor )

	//RIGHT ARMOR
	self:AddArmor( Vector(15,-45,65), Angle( 0,0,0 ), Vector(-120,-10,-10), Vector(80,10,40), 1000, self.SideArmor )

	//BACK ARMOR
	self:AddArmor( Vector(-130,0,60), Angle( 0,0,0 ), Vector(-10,-55,-25), Vector(20,55,45), 900, self.BackArmor )


	//TURRET ARMOR
	local TurretArmor = self:AddArmor( Vector(42,0,85), Angle(0,0,0), Vector(-45,-45,0), Vector(45,45,45), 2600, self.TurretArmor )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
	TurretArmor:SetLabel( "Turret" )
	self:SetTurretArmor( TurretArmor )
end
