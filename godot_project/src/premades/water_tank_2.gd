extends StaticBody3D

@onready var inTag: PLCTag = $TankFillIn/PLCTag
@onready var outTag: PLCTag = $TankEmptyOut/PLCTag
@onready var innerWall: MeshInstance3D = $water_tank/InnerWall

@export var maxFillRate := 50.0

var curFillAmount := 0.0
var curFillRate := 0.0
const maxVolume := 1500.0

func _ready() -> void:
	$InflowParticles.emitting = false
	$OutfloParticles.emitting = false


func _process(delta: float) -> void:
	var inFlow:float = remap(float(inTag.Read()), 0.0, Snap7Cpp.analogValueMax, 0, maxFillRate)
	var outFlow:float = remap(float(outTag.Read()), 0.0, Snap7Cpp.analogValueMax, 0, maxFillRate)
	curFillRate = inFlow - outFlow
	curFillAmount += curFillRate * delta
	### TODO: MUUTA ANALOGI VOULME/FILL SHITTI
	curFillAmount = clampf(curFillAmount, Snap7Cpp.analogValueMax, maxVolume)
	var levelNormalized:float = curFillAmount / Snap7Cpp.analogValueMax
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
