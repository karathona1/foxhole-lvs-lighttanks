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
	local DriverSeat = self:AddDriverSeat( Vector(-45,20,44), Angle(0,-90,0) )
	DriverSeat.HidePlayer = false

	local GunnerSeat = self:AddPassengerSeat( Vector(-35,-20,48), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = false
	self:SetGunnerSeat( GunnerSeat )

	local Pod1 = self:AddPassengerSeat( Vector(-68,20,50), Angle(0,-90,0))

	local ID = self:LookupAttachment( "muzzle_end" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "vehicles/LightTankColonialShot01.wav", "vehicles/LightTankColonialShot02.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	self:AddEngine( Vector(-72,0,72), Angle(0,-90,0) )
	self:AddFuelTank( Vector(-72,0,72), Angle(0,-90,0), 800, LVS.FUELTYPE_PETROL )

	//FRONT ARMOR
	self:AddArmor( Vector(80,0,50), Angle( -70,0,0 ), Vector(-10,-34,-15), Vector(10,34,45), 1000, self.FrontArmor )

	//LEFT ARMOR
	self:AddArmor( Vector(15,35,35), Angle( 0,0,0 ), Vector(-70,-5,-15), Vector(40,5,40), 800, self.SideArmor )

	//RIGHT ARMOR
	self:AddArmor( Vector(15,-35,35), Angle( 0,0,0 ), Vector(-70,-5,-15), Vector(40,5,40), 800, self.SideArmor )

	//BACK ARMOR
	self:AddArmor( Vector(-95,0,40), Angle( 0,0,0 ), Vector(-35,-35,-10), Vector(15,35,30), 600, self.BackArmor )


	//TURRET ARMOR
	local TurretArmor = self:AddArmor( Vector(-30,0,60), Angle(0,0,0), Vector(-50,-45,0), Vector(40,45,35), 1200, self.TurretArmor )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
	TurretArmor:SetLabel( "Turret" )
	self:SetTurretArmor( TurretArmor )
end
