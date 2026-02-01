extends StaticBody3D

@onready var inTag: PLCTag = $TankFillIn/PLCTag
@onready var outTag: PLCTag = $TankEmptyOut/PLCTag
@onready var fillLevelTag: PLCTag = $TankFillLevel/PLCTag
@onready var plcTimer: Timer = $TankFillLevel/UpdatePLCTimer
@onready var innerWall: MeshInstance3D = $water_tank/InnerWall

@export var maxFillRate := 50.0
@export var plcUpdateInterval := 0.2

var curVolume := 0.0
var curFillRate := 0.0
const maxVolume := 1500.0

func _ready() -> void:
	$InflowParticles.emitting = false
	$OutfloParticles.emitting = false


func _process(delta: float) -> void:
	var inFlow:float = remap(float(inTag.Read()), 0.0, Snap7Cpp.analogValueMax, 0, maxFillRate)
	var outFlow:float = remap(float(outTag.Read()), 0.0, Snap7Cpp.analogValueMax, 0, maxFillRate)
	curFillRate = inFlow - outFlow

	var fillrateInLiters = remap(curFillRate, 0.0, Snap7Cpp.analogValueMax, 0, maxFillRate)
	curVolume += fillrateInLiters * delta
	curVolume = clampf(curVolume, 0, maxVolume)
	var levelNormalized:float = curVolume / maxVolume

	if !is_zero_approx(curFillRate):
		if plcTimer.is_stopped():
			plcTimer.start(plcUpdateInterval)
	else:
		plcTimer.stop()

	innerWall.get_active_material(0).set_shader_parameter("waterLevel", levelNormalized)
	if inFlow > 0.0001:
		SetInflowParticles(true)
	else:
		SetInflowParticles(false)
	if outFlow > 0.0001:
		SetOutflowParticles(true)
	else:
		SetOutflowParticles(false)


func SetInflowParticles(enabled:bool)->void:
	$InflowParticles.emitting = enabled

func SetOutflowParticles(enabled:bool)->void:
	$OutfloParticles.emitting = enabled


func _on_update_plc_timer_timeout() -> void:
	pass # Replace with function body.
