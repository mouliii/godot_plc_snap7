@tool
extends Node

@export var inputOffset := 10
@export var outputOffset := 0
@export var tagTableName:String = "Table"
@export_tool_button("Generate", "AnimationTrackList") var button = Execute

var tagsArr: Array[PLCTag] = []
	
func Execute()->void:
	var rootNode := get_parent()
	tagsArr.clear()
	# step 1: get all tags
	GetAllChildren(rootNode)
	# step 2: Configure tags nodes
	ConfigTags()
	# step 3: Export XML
	ExportXML()

func GetAllChildren(inNode):
	if inNode is PLCTag:
		tagsArr.append(inNode)
	for child in inNode.get_children():
		GetAllChildren(child)

func ConfigTags()->void:
	var ioffset := [inputOffset, 0]
	var qoffset := [outputOffset, 0]
	for tag in tagsArr:
		if tag.pollFromPlc:
			qoffset = SetTag(tag, false, qoffset)
		else:
			ioffset = SetTag(tag, true, ioffset)

func SetTag(tag:PLCTag, isInput:bool, offset:Array)->Array:
	var newOffset = offset
	
	if isInput:
		tag.memoryArea = Snap7Wrapper.MEM_AREA.M_MEM
	else:
		tag.memoryArea = Snap7Wrapper.MEM_AREA.OUTPUT

	match tag.dataType:
		Snap7Cpp.DATA_TYPE.BOOL:
			tag.offset = offset[0]
			tag.bit = offset[1]
		Snap7Cpp.DATA_TYPE.INT, Snap7Cpp.DATA_TYPE.WORD, Snap7Cpp.DATA_TYPE.REAL:
			tag.offset = offset[0] + 1
			newOffset[0] += 1
			tag.bit = 0
		_:
			push_error("datatype: ", tag.dataType, " not implemented in automatic XML creator")

	match tag.dataType:
		Snap7Cpp.DATA_TYPE.BOOL:
			newOffset[1] += 1
			if newOffset[1] > 7:
				newOffset[0] += 1
				newOffset[1] = 0
		Snap7Cpp.DATA_TYPE.INT, Snap7Cpp.DATA_TYPE.WORD:
			newOffset[0] += 2
			newOffset[1] = 0
		Snap7Cpp.DATA_TYPE.REAL:
			newOffset[0] += 4
			newOffset[1] = 0
		_:
			push_error("datatype: ", tag.dataType, " not implemented in automatic XML creator")

	return newOffset

func ExportXML()->void:
	var file := FileAccess.open("res://data.xml", FileAccess.WRITE)
	if file:
		var xml := "<?xml version='1.0' encoding='utf-8'?>\n"
		xml += "<Tagtable name='%s'>\n" % tagTableName
		xml += "<!-- exported from Godot -->\n"
		for tag in tagsArr:
			var dt:String
			var addr:String
			var tagName:String = tag.get_parent().name
			var io:String = "Q" if tag.pollFromPlc else "M"
			match tag.dataType:
				Snap7Cpp.DATA_TYPE.BOOL:
					dt = "Bool"
					addr = "%{IO}{offset}.{bit}".format({"IO":io,"offset":tag.offset, "bit":tag.bit})
				Snap7Cpp.DATA_TYPE.INT:
					dt = "Int"
					addr = "%{IO}W{offset}".format({"IO":io,"offset":tag.offset})
				Snap7Cpp.DATA_TYPE.WORD:
					dt = "Word"
					addr = "%{IO}W{offset}".format({"IO":io,"offset":tag.offset})
				Snap7Cpp.DATA_TYPE.REAL:
					dt = "Real"
					addr = "%{IO}D{offset}".format({"IO":io,"offset":tag.offset})
			
			xml += "<Tag type='{dt}' hmiVisible='True' hmiWriteable='True' hmiAccessible='True' retain='False' remark='' addr='{offset}'>{tagName}</Tag>\n".format({
				"dt":dt,
				"offset":addr,
				"tagName":tagName
			})
		xml += "</Tagtable>"
		file.store_string(xml)
		file.close()
	print("file created!")
