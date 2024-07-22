
include("entities/lvs_tank_wheeldrive/modules/sh_turret.lua")

ENT.TurretAimRate = 15

ENT.TurretRotationSound = "vehicles/tank_turret_loop1.wav"

ENT.TurretPitchPoseParameterName = "turret_pitch"
ENT.TurretPitchMin = -20
ENT.TurretPitchMax = 10
ENT.TurretPitchMul = 0.5
ENT.TurretPitchOffset = 0

ENT.TurretYawPoseParameterName = "turret_yaw"
ENT.TurretYawMin = -20
ENT.TurretYawMax = 20
ENT.TurretYawMul = 1
ENT.TurretYawOffset = 0