
include("entities/lvs_tank_wheeldrive/modules/sh_turret.lua")

ENT.TurretAimRate = 20

ENT.TurretRotationSound = "vehicles/turret_traverse2.wav"

ENT.TurretPitchPoseParameterName = "turret_pitch_l"
ENT.TurretPitchMin = -20
ENT.TurretPitchMax = 20
ENT.TurretPitchMul = 0.5
ENT.TurretPitchOffset = 0

ENT.TurretYawPoseParameterName = "turret_yaw_l"
ENT.TurretYawMul = 2
ENT.TurretYawOffset = 45