extends KinematicBody2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Zombie ai, walking in grid floor
var pathfinding = load("res://pathfindingAStar.gd")
var instanced_pf = null
var agro = "Target"
var map = "Coliders"
var tilePosition
var patch = []

var finderPosition = Vector2(0,0)

var radiusFinder = 1


#_init(initial_p : Vector2, target_p : Vector2, map_tile: TileMap):

# Called when the node enters the scene tree for the first time.
func _ready():
	# Position X Y in tilemap of agro target
	var AIdestiny = get_parent().get_node(map).world_to_map(get_parent().get_node(agro).get_position())
	
	# get self position in tilemap
	var tilePosition = get_parent().get_node(map).world_to_map(get_position())
	
	#set yellow tile in agro position
	"""var agroPos = get_parent().get_node(agro).position
	get_parent().set_cell(agroPos.x,agroPos.y, 1, false, false, false,Vector2( 3, 7 ))
	"""
	var tileMapTeste = get_parent().get_node(map)
	
	#instance pathfinding class
	#var path = pathfinding.new()
	#print(path)
	var map_colisions = get_parent().get_node(map)
	var map_floor = get_parent().get_node("floor")
	var astar_instance = pathfinding.PathFinding.new(tilePosition,AIdestiny,map_colisions, map_floor)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass