extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Zombie ai, walking in grid floor
var pathfinding = load("res://pathfindingAStar.gd")
var instanced_pf = null
var agro = "Target"
var nodeAI = "Ai"
var map = "ways"
var tileMapCollide = "Coliders"
var tilePosition
var patch = []

var finderPosition = Vector2(0,0)

var radiusFinder = 1




# Called when the node enters the scene tree for the first time.
func _ready():
	# Position X Y in tilemap of agro target
	var AIdestiny = get_parent().get_node(tileMapCollide).world_to_map(get_parent().get_node(agro).get_position())
	get_parent().clear()
	# get self position in tilemap
	var tilePosition = get_parent().get_node(tileMapCollide).world_to_map(get_parent().get_node(nodeAI).get_position())
	get_parent().clear()
	#set yellow tile in agro position
	get_parent().set_cell(agro.x,agro.y, 1, false, false, false,Vector2( 3, 7 ))
	var tileMapTeste = get_parent().get_node(map)
	#instance pathfinding class
	instanced_pf = pathfinding.PathFinding.new(tilePosition,AIdestiny,tileMapTeste)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass