extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Doors = []
var inicialized = false
export var logDoorEntered = false
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Array of all door inatilized!")
	inicialized = true
	pass # Replace with function body.
func pushDoor(door):
	Doors.push_back(door)
	if(logDoorEntered):
		print("Added: ", door.portID)
func openDoorState(doorDestinyID):
	for d in Doors:
		if d.portID == doorDestinyID:
			if(d.has_method("openDoor")):
				d.openDoor(true)
			pass
	pass
func closeDoorState(doorDestinyID):
	for d in Doors:
		if d.portID == doorDestinyID:
			if(d.has_method("closeDoor")):
				d.closeDoor(true)
			pass
	pass
func get_correlative(doorDestinyID):
	for d in Doors:
		if d.portID == doorDestinyID:
			return d
	return "not found"
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
