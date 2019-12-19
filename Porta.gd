extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var IsDoorOpened = false
var blockCollision
var woodAnimation

export var portal_destiny = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	blockCollision = get_node("Door/StaticBody2D/Collider")
	woodAnimation = get_node("Door/WoodDoor/Animation")
	woodAnimation.set_current_animation("Closing")
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var portal = get_node("Door/Portal").get_overlapping_bodies()
	var portaSwitch = get_node("Door/Area2D").get_overlapping_bodies()
	
	for b in portal:
		if b.get_class() == "KinematicBody2D":
			b.set_position(get_node("Position2D").get_global_position())
			pass
		pass
		

	if (woodAnimation.get_current_animation_position() >= woodAnimation.get_current_animation_length()-1) and woodAnimation.get_current_animation() == "Opening":
			IsDoorOpened = true
			blockCollision.disabled = true
	else: ## Open the door
		if (woodAnimation.get_current_animation_position() >= woodAnimation.get_current_animation_length()-1) and woodAnimation.current_animation == "Closing":
			IsDoorOpened = false
			blockCollision.disabled = false
		pass
			
	if portaSwitch.size()>0: ## Verify if have anyone in area 2D	
		if(IsDoorOpened == false):
			woodAnimation.play("Opening")
		pass
	else: ## Close the door
		if IsDoorOpened == true:
			woodAnimation.play("Closing")
		pass