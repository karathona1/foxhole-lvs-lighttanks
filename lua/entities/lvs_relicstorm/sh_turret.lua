
include("entities/lvs_tank_wheeldrive/modules/sh_turret.lua")

ENT.TurretAimRate = 15

ENT.TurretRotationSound = "vehicles/turret_traverse2.wav"

ENT.TurretPitchPoseParameterName = "turret_pitch"
ENT.TurretPitchMin = -30
ENT.TurretPitchMax = 30
ENT.TurretPitchMul = 0.5
ENT.TurretPitchOffset = 0

ENT.TurretYawPoseParameterName = "turret_yaw"
ENT.TurretYawMul = -1
ENT.TurretYawOffset = 0