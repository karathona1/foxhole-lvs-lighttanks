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
	local DriverSeat = self:AddDriverSeat( Vector(20,-11,40), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local GunnerSeat = self:AddPassengerSeat( Vector(12,10,60), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = false
	self:SetGunnerSeat( GunnerSeat )

	local ID = self:LookupAttachment( "muzzle_end" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "vehicles/LightTankColonialShot01.wav", "vehicles/LightTankColonialShot02.wav" )
	self.SNDTurret:SetSoundLevel( 100 )
	self.SNDTurret:SetParent( self, ID )

	self:AddEngine( Vector(-72,0,72), Angle(0,-90,0) )
	self:AddFuelTank( Vector(-82,0,71), Angle(0,0,0), 800, LVS.FUELTYPE_PETROL )

	//FRONT ARMOR
	self:AddArmor( Vector(73,0,40), Angle( -25,0,0 ), Vector(-10,-35,-15), Vector(10,35,38), 800, self.FrontArmor )

	//LEFT ARMOR
	self:AddArmor( Vector(0,35,65), Angle( 0,0,0 ), Vector(-70,-5,-10), Vector(50,5,10), 600, self.SideArmor )

	//RIGHT ARMOR
	self:AddArmor( Vector(0,-35,65), Angle( 0,0,0 ), Vector(-70,-5,-10), Vector(50,5,10), 600, self.SideArmor )

	//BACK ARMOR
	self:AddArmor( Vector(-85,0,48), Angle( 0,0,0 ), Vector(-7,-30,-20), Vector(7,30,20), 400, self.BackArmor )


	//TURRET ARMOR
	local TurretArmor = self:AddArmor( Vector(15,10,70), Angle(0,0,0), Vector(-35,-25,5), Vector(35,25,30), 900, self.TurretArmor )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
	TurretArmor:SetLabel( "Turret" )
	self:SetTurretArmor( TurretArmor )

	self:AddTrailerHitch( Vector(-91.44,0,17.12), LVS.HITCHTYPE_MALE )

end
