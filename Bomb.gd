extends KinematicBody2D
# configs
export var bomb_Damage = 400
export var bomb_push_force = 10
export var bomb_push_velocity = 10
# Declare member variables here. Examples:
var explosion = preload("res://explosion.tscn")
var howManyFrames = null
# Vars of impact physics
var transStartPosition = Vector2()
var transVect = Vector2()
var translateEndPosition = Vector2()
var animTransIsEnabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("BombAnimation").set_frame(0)
	get_node("BombAnimation").play("loading",false)
	
	var frames = get_node("BombAnimation").get_sprite_frames()
	howManyFrames = frames.get_frame_count("loading")
	howManyFrames -= 1 # because animation start in zero
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	# when bomb animation end
	if howManyFrames != null:
		if  animTransIsEnabled == true:
			#cancel animation when hit other collision object
			for i in get_slide_count():
				var collisionVar = get_slide_collision(i)
				#collision.get_position()
				#print(collisionVar)
				#print(str("Collider is:",collisionVar.collider))
				#print(str("base is:",collisionVar))
				
				
				if(!str(collisionVar) == "[Object:null]"):
					if(!str(collisionVar.collider) == "[Object:null]"):
						if(collisionVar.collider.get_class() == "TileMap"):
							var vec1 = get_position()
							var newP = Vector2()
							newP.x = int(collisionVar.position.x)
							newP.y = float(int(collisionVar.position.y))
							
							#print("vec1: ",vec1)
							#print("newp: ",(newP.x),":",(newP.y))
							var vec2 = (collisionVar.collider.map_to_world(collisionVar.collider.world_to_map(newP)))
							
							#var radiusBomb = (get_node("CollisionShape2D").get_shape().radius)
							var sizeTile = + collisionVar.collider.get_cell_size()
							get_node("../teste").set_position(vec2)
							if is_on_wall():
								#verify if are inner area top tile
								if vec1.x >= vec2.x and vec1.x <= vec2.x + sizeTile.x:
									# if top
									if vec1.y <= vec2.y:
										transVect.y = transVect.y * -1
										pass
									else:# if bottom
										if vec1.y >= vec2.y:
											transVect.y = transVect.y * -1
											pass
									pass
								#verify if walls area
								else:
									if vec1.y >= vec2.y and vec1.y <= vec2.y + sizeTile.y:
										# if right
										if vec1.x <= vec2.x:
											transVect.x = transVect.x * -1
											pass
										else:# if left
											if vec1.x >= vec2.x:
												transVect.x = transVect.x * -1
												pass
										#move_and_slide(transVect, Vector2(0,0))
										translateEndPosition.x = get_position().x + 10
										translateEndPosition.y = get_position().y + 10
										transStartPosition=get_position()
										pass
										
							
			#get_node("AnimatedSprite").play("onAir")
# warning-ignore:unused_variable
			var cana = move_and_slide(transVect, Vector2(0,0))
			var actualPos = get_position()
			var dis = sqrt(pow((transStartPosition.x-translateEndPosition.x),2) + pow((transStartPosition.y-translateEndPosition.y),2))
			var actualDis = sqrt(pow((transStartPosition.x-actualPos.x),2) + pow((transStartPosition.y-actualPos.y),2))
			if  (actualDis>dis):
				#print("on collide")
				animTransIsEnabled = false
				transStartPosition = Vector2()
				translateEndPosition = Vector2()
				pass
			
			#print(actualPos)
			pass
		
		if get_node("BombAnimation").frame == howManyFrames: #Check if is the last frame to explosion bodies
			var explosionInScene = explosion.instance()
			explosionInScene.position = position # set acctual position bom to explosion
			get_parent().add_child(explosionInScene)
			
			# damage in characters	
			var areasOverX = get_node("Area2D").get_overlapping_bodies()
			for c in areasOverX:
				if "life_bar" in c:
					c.life_bar -= bomb_Damage
					pass
				#ignore self object
				
				if !(c.get_instance_id() == get_instance_id() if c.has_method("get_instance_id") else true):
					# add push bomb effect
					if c.has_method("translateOfImpact"):
						var vect = Vector2()
						vect.x = c.get_position().x - get_position().x
						vect.y = c.get_position().y - get_position().y 
						#print("vet t:", vect)
						#print("vet character:", c.get_position() )
						#print("vet this bomb:", get_position())
						if(vect.x < 0):
							vect.x = floor(sqrt(-vect.x))
							vect.x = -vect.x
						else:
							vect.x = floor(sqrt(vect.x))
							vect.x = vect.x
						if(vect.y < 0):
							vect.y = floor(sqrt(-vect.y))
							vect.y = -vect.y
						else:
							vect.y = floor(sqrt(vect.y))
							vect.y = vect.y
							
						#print(vect)
						# fix bug 0,0 vector
						if vect.x == 0 && vect.y == 0:
							if(rand_range(0,1)):
								vect.x = 1
								vect.y = 1
							else:
								vect.x = -1
								vect.y = -1
						
						#vect.x += bomb_push_force
						#vect.y += bomb_push_force
						c.translateOfImpact(vect,bomb_push_force,bomb_push_velocity)
						pass
					pass
				pass
			#delete
			free()
			pass
		pass
	pass
	
func translateOfImpact( vect, radius, speed):
	transStartPosition = get_position()
	transVect = vect * speed
	translateEndPosition.x = get_position().x + radius
	translateEndPosition.y = get_position().y + radius
	animTransIsEnabled = true
	pass
"""	
func get_node_by_name(name,root):
	if root.name == name:
		return root
	for child in root.get_children():
		if child.name  == name:
			return child
		var found = get_node_by_name(name,child)
		if found: return found
		pass
	return null"""