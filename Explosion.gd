extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var howManyFrames = null
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimatedSprite").set_frame(0)
	get_node("AnimatedSprite").play("default")
	
	var frames = get_node("AnimatedSprite").get_sprite_frames()
	howManyFrames = frames.get_frame_count("default")
	howManyFrames -= 1 # because animation start in zero
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if howManyFrames != null:
		if get_node("AnimatedSprite").frame == howManyFrames:
			free()
			pass
		pass
	pass
