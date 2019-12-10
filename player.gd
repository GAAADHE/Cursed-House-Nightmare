extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var SPEED = 400
export var life_bar = 1000
export var invencible = false

var movedir = Vector2()
#var keys = {"keyup":false,"keydown":false,"keyleft":false,"keyright":false}

var bomb = preload("res://Bomb.tscn")
var HUDscene = preload("res://HUD.tscn") 

#translate of impact presets
var animTransIsEnabled = false
var transVect = Vector2()
var transStartPosition = Vector2()
var translateEndPosition = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimatedSprite").play("idle")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if ! animTransIsEnabled:
		if ! get_parent().has_node("HUD"):
			var playerHUD = HUDscene.instance()
			playerHUD.set_name("HUD")
			get_parent().add_child(playerHUD)
			#print(playerHUD)
			pass
			
		if get_parent().has_node("HUD"):
			get_parent().get_node("HUD").get_node("BarLife").value = life_bar
			pass
		control_process()
		move_process()
		"""	
		var velocity = Vector2()
				
		if Input.is_action_pressed("player_up") :
			get_node("AnimatedSprite").play("walkup")
			keys.keyup = true
			velocity.y-=1
			pass
		if Input.is_action_pressed("player_down") :
			get_node("AnimatedSprite").play("walkdown")
			keys.keydown = true
			velocity.y+=1
			pass
		if Input.is_action_pressed("player_left") :
			get_node("AnimatedSprite").play("walkleft")
			keys.keyleft = true
			velocity.x-=1
			pass
		if Input.is_action_pressed("player_right") :
			get_node("AnimatedSprite").play("walkright")
			keys.keyright = true
			velocity.x+=1
			pass
			
		#nomalize and set pos
		if velocity.length() > 0:
			velocity = velocity.normalized() * SPEED
			
		position += velocity * delta
		
		#release
		if Input.is_action_just_released("player_up") :
			keys.keyup = false
			pass
		if Input.is_action_just_released("player_down") :
			keys.keydown = false
			pass
		if Input.is_action_just_released("player_left") :
			keys.keyleft = false
			pass
		if Input.is_action_just_released("player_right") :
			keys.keyright = false
			pass
		
		#verify if idle
		if is_all_keys_false():
			get_node("AnimatedSprite").play("idle")
			pass
		"""	
		# bomb instance
		if Input.is_action_just_released("player_atack") :
			var bombScene = bomb.instance()
			bombScene.position = position
			get_parent().add_child(bombScene)
			pass
			
		# if is die
		if !invencible and life_bar < 0:
			pass
	else:
		get_node("AnimatedSprite").play("onAir")
		# translate actived lose control
		#set_position(get_position() + transVect)
		move_and_slide(transVect, Vector2(0,0))
		var actualPos = get_position()
		var dis = sqrt(pow((transStartPosition.x-translateEndPosition.x),2) + pow((transStartPosition.y-translateEndPosition.y),2))
		var actualDis = sqrt(pow((transStartPosition.x-actualPos.x),2) + pow((transStartPosition.y-actualPos.y),2))
		
		if(actualDis>dis):
			animTransIsEnabled = false
			transStartPosition = Vector2()
			translateEndPosition = Vector2()
			pass
		pass
		#cancel animation when hit other collision object
		if is_on_ceiling() or is_on_floor() or is_on_wall():
			#print("on collide")
			animTransIsEnabled = false
			transStartPosition = Vector2()
			translateEndPosition = Vector2()
			pass
			
	pass
	
"""	
func is_all_keys_false():
	for c in keys:
		if keys[c] == true: #verify if have one key pressed
			return false
		pass
	return true
	pass
"""
#move the object
func translateOfImpact( vec, radius, speed):
	transStartPosition = get_position()
	transVect = vec * speed
	translateEndPosition.x = get_position().x + radius
	translateEndPosition.y = get_position().y + radius
	animTransIsEnabled = true
	pass
#input 

#controls
func control_process():
	var LEFT = Input.is_action_pressed("player_left")
	var RIGHT= Input.is_action_pressed("player_right")
	var UP   = Input.is_action_pressed("player_up")
	var DOWN = Input.is_action_pressed("player_down")
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN) 
	#print("y:",movedir.y,"x:",movedir.x)
	#set animation
	if movedir.y == 0 and movedir.x == 0:
		get_node("AnimatedSprite").play("idle")
		pass
	if movedir.y == -1 :
		get_node("AnimatedSprite").play("walkup")
		pass
	if movedir.y == 1 :
		get_node("AnimatedSprite").play("walkdown")
		pass
	if movedir.x == -1:
		get_node("AnimatedSprite").play("walkleft")
		pass
	if movedir.x == 1:
		get_node("AnimatedSprite").play("walkright")
		pass
		
	pass
func move_process():
	var motion = movedir.normalized() * SPEED
	move_and_slide(motion, Vector2(0,0))
	pass