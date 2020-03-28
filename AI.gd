extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Zombie ai, walking in grid floor
var agro = "Target"
var tileMapCollide = "Coliders"
var tilePosition
var patch = []

var finderPosition = Vector2(0,0)

var radiusFinder = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	# Position X Y in tilemap
	agro = get_parent().get_node(tileMapCollide).world_to_map(get_parent().get_node(agro).get_position())
	get_parent().clear()
	get_parent().set_cell(agro.x,agro.y, 1, false, false, false,Vector2( 3, 7 ))
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	"""var detectorBodies = get_node("Detector").get_overlapping_bodies()
	for x in detectorBodies:
		if("isAPlayer" in detectorBodies):
			agro = x
			pass
		pass"""
	pass

"""
func pathFind():
	pass
	
func movePath():
	pass"""
