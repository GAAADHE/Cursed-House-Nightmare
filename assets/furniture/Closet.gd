extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var fIsDown = false

var statusDoor = 0;
"""
statusDoor
0: closed
1: openning
2: openned
3: closing
"""

var animationStatus = false


func _process(delta):
	
	animationStatus = get_node("AnimationPlayer").is_playing()
		
	var overBoddies = get_node("Detector").get_overlapping_bodies()
	
	for x in overBoddies:
		#Verify if is a player on sensor
		if "isAPlayer" in x:
			fIsDown = true
		else:
			fIsDown = false
		
	# Set when is closed
	if(statusDoor == 3 and animationStatus == false):
		statusDoor = 0
	# Set when is open
	if(statusDoor == 1 and animationStatus == false):
		statusDoor = 2
		
	# Active Animation Opening
	if(fIsDown and animationStatus == false and statusDoor == 0):
		get_node("AnimationPlayer").play("Abrindo")
		statusDoor = 1
		pass	
	# if has a player on sensor and door openned and state is openned
	if(!fIsDown and animationStatus == false and statusDoor == 2):
		get_node("AnimationPlayer").play_backwards("Abrindo")
		statusDoor = 3
		pass
		
	
	
	
	
	