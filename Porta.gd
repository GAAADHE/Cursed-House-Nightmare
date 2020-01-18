extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const CLOSED = 0
const OPENED = 1
const OPENING = 2
const CLOSING = 3
var statusDoor = 0
export var closedDoor = true 

var blockCollision
var woodAnimation
var flagInitialized = false

export var portID = " "
export var portDestineID = " "
export var openSameTime = true

#remotely open
var isOpenRemotely = false

# Called when the node enters the scene tree for the first time.
func _ready():
	blockCollision = get_node("Door/StaticBody2D/Collider")
	woodAnimation = get_node("Door/WoodDoor/Animation")
	
	
	#define first state of door
	if closedDoor:
		statusDoor = CLOSED
		woodAnimation.set_current_animation("Closing")
		pass
	else:
		statusDoor = OPENED
		woodAnimation.set_current_animation("Opening")
		pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var portal = get_node("Door/Portal").get_overlapping_bodies()
	var portaSwitch = get_node("Door/Area2D").get_overlapping_bodies()
	
	for b in portal:
		if b.get_class() == "KinematicBody2D":
			#b.set_position(get_node("Position2D").get_global_position())
			if(!str(get_correlativeDoor()) == "not found"):
				b.set_position(get_correlativeDoor().get_node("Spawn").get_global_position())
			else:
				b.set_position(get_node("Spawn").get_global_position())
		pass
		
	
	if (woodAnimation.get_current_animation_position() >= woodAnimation.get_current_animation_length()-1) and woodAnimation.get_current_animation() == "Opening":
		statusDoor = OPENED

	elif(woodAnimation.get_current_animation() == "Opening"):
		statusDoor = OPENING

	if (woodAnimation.get_current_animation_position() >= woodAnimation.get_current_animation_length()-1) and woodAnimation.get_current_animation() == "Closing":
		statusDoor = CLOSED

	elif(woodAnimation.get_current_animation() == "Closing"):
		statusDoor = CLOSING

	if statusDoor == OPENED: ## Open the door
		blockCollision.disabled = true
	else:
		blockCollision.disabled = false
		
	
	if portaSwitch.size()>0: ## Verify if have anyone in area 2D
		if(statusDoor == CLOSED):
			openDoor(false)
			pass
		pass
	elif(statusDoor == OPENED and !isOpenRemotely): ## Close the door
		closeDoor(false)
		pass
	
	

		
	#define global array with list of all doors
	if(!flagInitialized):
		if(get_tree().get_root().has_node("Main")): #if to avoid error, if missed node
			var theMain = get_tree().get_root().get_node("Main")
			if(!theMain.has_node("GlobalDoor")):
				var GlobalDoor = load("res://assets/porta/GlobalDoor.tscn")
				var NodeGlobalDoor = GlobalDoor.instance()
				NodeGlobalDoor.set_name("GlobalDoor")	
				theMain.add_child(NodeGlobalDoor,true)
				#theMain.call_deferred("add_child",NodeGlobalDoor)
				pass
			if(theMain.has_node("GlobalDoor")):
				var node = theMain.get_node("GlobalDoor")
				node.pushDoor(self)
				flagInitialized = true
				pass
func openDoorAtSameTime():
	var GlobalDoor = get_tree().get_root().get_node("Main").get_node("GlobalDoor")
	if(openSameTime):
		#print(portID , " to ", portDestineID)
		GlobalDoor.openDoorState(portDestineID)
	pass
func closeDoorAtSameTime():
	var GlobalDoor = get_tree().get_root().get_node("Main").get_node("GlobalDoor")
	if(openSameTime):
		#print(portID , " to ", portDestineID)
		if(!str(GlobalDoor) == "[Object:null]"):
			GlobalDoor.closeDoorState(portDestineID)
	pass
func get_correlativeDoor():
	var GlobalDoor = get_tree().get_root().get_node("Main").get_node("GlobalDoor")
	return GlobalDoor.get_correlative(portDestineID)
	pass
	
func openDoor(breakRescursive):
	if(openSameTime and !breakRescursive):
		openDoorAtSameTime()
		pass
	else:
		isOpenRemotely = true
	if(statusDoor == CLOSED):
		woodAnimation.play("Opening")
		$SomFechando.stop()
		$SomAbrindo.play(0.0)
	pass
func closeDoor(breakRescursive):
	if(openSameTime and !breakRescursive):
		closeDoorAtSameTime()
	else:
		isOpenRemotely = false
		pass
	if (statusDoor == OPENED):
		woodAnimation.play("Closing")
		$SomAbrindo.stop()
		$SomFechando.play(0.0)
	pass