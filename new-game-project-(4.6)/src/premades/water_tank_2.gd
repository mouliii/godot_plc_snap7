extends StaticBody3D

@onready var inTag: PLCTag = $TankFillIn/PLCTag
@onready var outTag: PLCTag = $TankEmptyOut/PLCTag
@onready var FillLevelTag: PLCTag = $TankFillLevel/PLCTag
@onready var fillLevelTag: PLCTag = $TankFillLevel/PLCTag
@onready var plcTimer: Timer = $UpdatePLCTimer
@onready var innerWall: MeshInstance3D = $water_tank/InnerWall
## in leters
@export var maxFillRate := 50.0
## in liters
@export var maxVolume := 1500.0
@export var plcUpdateInterval := 0.2

var curVolume := 0.0
var curFillRate := 0.0

func _ready() -> void:
	$InflowParticles.emitting = false
	$OutfloParticles.emitting = false


func _process(delta: float) -> void:
	var inFlow:float = remap(inTag.Read(), 0.0, Snap7Cpp.analogValueMax, 0, maxFillRate)
	var outFlow:float = remap(outTag.Read(), 0.0, Snap7Cpp.analogValueMax, 0, maxFillRate)
	curFillRate = inFlow - outFlow
	curVolume = clampf(curVolume + curFillRate * delta, 0, maxVolume)
	
	if !is_zero_approx(curFillRate):
		if plcTimer.is_stopped():
			plcTimer.start(plcUpdateInterval)
			WriteToPlc()
	else:
		plcTimer.stop()

	var levelNormalized:float = curVolume / maxVolume
	innerWall.get_active_material(0).set_shader_parameter("waterLevel", levelNormalized)
	if !is_zero_approx(inFlow):
		SetInflowParticles(true)
	else:
		SetInflowParticles(false)
	if !is_zero_approx(outFlow):
		SetOutflowParticles(true)
	else:
		SetOutflowParticles(false)

func SetInflowParticles(enabled:bool)->void:
	$InflowParticles.emitting = enabled

func SetOutflowParticles(enabled:bool)->void:
	$OutfloParticles.emitting = enabled

func _on_update_plc_timer_timeout() -> void:
	WriteToPlc()

func WriteToPlc()->void:
	var level := remap(curVolume, 0.0, maxVolume, 0, Snap7Cpp.analogValueMax)
	FillLevelTag.Write(int(level))
