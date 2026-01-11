extends Node
class_name PLCTag

@export var pollFromPlc:bool = true
@export var dataType = Snap7Cpp.DATA_TYPE.BOOL
@export var memoryArea = Snap7Cpp.MEM_AREA.DATA_BLOCK
@export var value:Variant
@export_category("Tag data")
@export var DB_num:int = 1
@export var offset:int
@export var bit:int
var size:int

func _ready() -> void:
	match dataType:
		Snap7Cpp.DATA_TYPE.BOOL:
			value = false
		Snap7Cpp.DATA_TYPE.INT:
			value = 0
	if pollFromPlc:
		add_to_group("PLC_TAGS")

## automatically called if added to group: PLC_TAGS
func PollPlcData()->void:
	value = Fetch()

## Write to PLC
func Write(newVal:Variant)->void:
	Snap7Cpp.WritePlc(memoryArea, dataType, DB_num, offset, bit, newVal)
## Read from PLC
func Fetch()->Variant:
	return Snap7Cpp.ReadPlc(memoryArea, dataType, DB_num, offset, bit)
## Read cached value ( returns value )
func Read()->Variant:
	return value
