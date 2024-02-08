AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_tankview.lua" )
AddCSLuaFile( "cl_attached_playermodels.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "sh_tracks.lua" )
include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")

ENT.DSArmorDamageReductionType = DMG_BULLET + DMG_CLUB
ENT.DSArmorIgnoreDamageType = DMG_SONIC

function ENT:OnSpawn( PObj )

	local DriverSeat = self:AddDriverSeat( Vector(-20.3,15.6,35), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local GunnerSeat = self:AddPassengerSeat( Vector(-8.1,-10.9,35), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = true
	self:SetGunnerSeat( GunnerSeat )

	local Pod1 = self:AddPassengerSeat( Vector(-64,15.5,35), Angle(0,-90,0))
	local Pod2 = self:AddPassengerSeat( Vector(-64,-15.5,35), Angle(0,-90,0))

	local ID = self:LookupAttachment( "muzzle_mg" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, ID )

	-- if self.TurretSeatIndex == 1 then
    --     self:SetWeaponSeat( DriverSeat )
    -- elseif self.TurretSeatIndex == 2 then
    --     self:SetWeaponSeat( GunnerSeat )
    -- end

	//FRONT ARMOR
	self:AddArmor( Vector(40,0,35), Angle( 0,0,0 ), Vector(-10,-35,-15), Vector(10,35,50), 600, self.FrontArmor )

	//LEFT ARMOR
	self:AddArmor( Vector(-30,35,35), Angle( 0,0,0 ), Vector(-40,-10,-15), Vector(60,10,50), 400, self.SideArmor )

	//Right ARMOR
	self:AddArmor( Vector(-30,-35,35), Angle( 0,0,0 ), Vector(-40,-10,-15), Vector(60,10,50), 400, self.SideArmor )

	//FRONT ARMOR
	self:AddArmor( Vector(-75,0,35), Angle( 0,0,0 ), Vector(-10,-35,-15), Vector(10,35,50), 250, self.BackArmor )

	self:AddEngine( Vector(52,0,52), Angle(0,-90,0) )
	self:AddFuelTank( Vector(-84,0,32), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL )

	self:AddTrailerHitch( Vector(-73,0,25), LVS.HITCHTYPE_MALE )
end
