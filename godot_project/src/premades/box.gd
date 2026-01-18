extends RigidBody3D

@export_range(0,100,1) var faultRate
@export var color:Color = Color.WHITE:
	get:
		return color
	set(newColor):
		color = newColor
		#$Mesh.material_override.set_shader_parameter("albedo_color", color)
		$Mesh.material_override.albedo_color = color

var forceObjects:Array[ForceObjectData] = []
var faulty:bool = false
@export var boxID:int = -1:
	get:
		return boxID
	set(newID):
		boxID = newID

func _ready() -> void:
	add_to_group("Products")
	var faultRng = randf() * 100
	if faultRng < faultRate:
		faulty = true

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# freeze mode off otherwise problems
	var size := forceObjects.size()
	if size > 0:
		var dir:Vector3 = Vector3.ZERO
		var speed:float = 0.0
		for obj in forceObjects:
			dir += obj.direction
			speed += obj.speed
		dir /= size
		speed /= size
		state.linear_velocity = dir * speed

func AddForceObject(obj:ForceObjectData)->void:
	forceObjects.append(obj)
	freeze = false

func RemoveForceObject(id:int)->void:
	# TODO: can be optimized
	for obj in forceObjects:
		if obj.dataSetterID == id:
			forceObjects.erase(obj)
			break
