extends KinematicBody2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Zombie ai, walking in grid floor
# warnings-disable
var pathfinding = load("res://pathfindingAStar.gd")
var instanced_pf = null
var agro = "Target"
var map = "Coliders"
var tilePosition
var patch = []

var finderPosition = Vector2(0,0)

var radiusFinder = 1

var astar_instance

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
	astar_instance = pathfinding.PathFinding.new(tilePosition,AIdestiny,map_colisions, map_floor)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

var speed  = 50
var movement = 0

var size = Vector2(1,1)
var size_ai = Vector2(0,0)
func has_arrive(pos,des):
	var dis = pos - des
	var sum_of_halfs = size + size_ai
	
	if(abs(dis.x) < sum_of_halfs.x and abs(dis.y) < sum_of_halfs.y):
		return true
	
	return false
	

func _physics_process(delta):
	if len(astar_instance.final_path) > 0:
		#position = $"../Coliders".map_to_world(astar_instance.final_path[0].position)
		var p = $"../Coliders".map_to_world(astar_instance.final_path[0].position)
		var direc = p - position
		movement = direc.normalized()
		move_char(movement,delta)
		if(has_arrive(position,p)):
			astar_instance.final_path.remove(0)
			print(rad2deg(atan2(direc.x, direc.y)))
	else:
		$AnimatedSprite.stop()
func move_char(direct, delta):
	position+=(direct * speed * delta)
	update_animation(direct)
	


func update_animation(direct):
	var sprite = $AnimatedSprite
	var angle = rad2deg(atan2(direct.x, direct.y))
	# Top
	if  (angle < -157.5 and angle >= -180) or (angle > 157.5 and angle <= 180):
		sprite.play("walk_top")
		return
	# Down
	if angle > -22.5 and angle < 22.5:
		sprite.play("walk_down")
		return
	# Right
	if angle > 67.5 and angle < 112.5:
		sprite.play("walk_horizontal")
		sprite.flip_h = false
		return
	# Left
	if angle < -67.5 and angle > -112.5:
		sprite.play("walk_horizontal")
		sprite.flip_h = true
		return
	# Diagonals
	
	# Top Left
	if angle > -157.5 and angle < -112.5:
		sprite.flip_h = true
		sprite.play("walk_diag_top")
		return
	# Top Right
	if angle < 157.5 and angle > 112.5:
		sprite.flip_h = false
		sprite.play("walk_diag_top")
		return
	# Down Left
	if angle > -67.5 and angle < -22.5:
		sprite.flip_h = false
		sprite.play("walk_diag_down")
		return
	# Down Right
	if angle > 22.5 and angle < 67.5:
		sprite.flip_h = true
		sprite.play("walk_diag_down")
		return
	pass