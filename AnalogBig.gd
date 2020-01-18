extends TouchScreenButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
var ongoing_drag = -1 
var radius = Vector2(16,16)
var boudary = 22
var return_accel = 20
var threshold = 10
func _process(delta):
	if ongoing_drag == -1:
		var pos_diference = (Vector2(0,0)) - radius - position
		position += pos_diference * return_accel * delta
func get_button_pos():
	return position + radius
func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var event_dist_from_centre = (event.position - get_parent().global_position).length()
		
		if event_dist_from_centre <= boudary * global_scale.x or event.get_index() == ongoing_drag:
			set_global_position(event.position - radius + global_scale)
			
			if get_button_pos().length() > boudary:
				set_position(get_button_pos().normalized() * boudary - radius)
				
			ongoing_drag = event.get_index()
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1
func get_value():
	if get_button_pos().length() >= threshold:
		return get_button_pos().normalized()
	else:
		return Vector2(0,0)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
