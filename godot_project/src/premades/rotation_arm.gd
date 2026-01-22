extends AnimatableBody3D

@export var setPointRotation:float = 45.0
@export var rotationSpeed:float = 5.0
@export var go:bool
@onready var tag: PLCTag = $PLCTag


func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if tag.Read():
		rotation.y = rotate_toward(rotation.y, deg_to_rad(setPointRotation), rotationSpeed * delta)
	else:
		rotation.y = rotate_toward(rotation.y, 0.0, rotationSpeed * delta)
