extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var isActice
var AreandyPlayed = false
var isSatanSpawned = false
var satanScene = preload("res://assets/Luci.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	frame = 0
	$AnimaPenta.stop()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var innerBodies = $Detector.get_overlapping_bodies()
	isActice = false
	for x in innerBodies:
		isActice=true
		break
	if(isActice and AreandyPlayed == false):
		$AnimaPenta.play("drawpentagram")
		AreandyPlayed = true
	if(AreandyPlayed == true and $AnimaPenta.is_playing() == false and isSatanSpawned == false):
		var Luci = satanScene.instance()
		Luci.set_name("Luci")
		Luci.set_global_position($Spawnpoint.get_global_position())
		get_parent().add_child(Luci)
		isSatanSpawned = true
	for x in $ToggleOff.get_overlapping_bodies():
		for x in get_parent().get_children():
			if(x.get_name() == "Luci"):
				get_parent().remove_child(get_parent().get_node("Luci"))
		frame = 0
		$AnimaPenta.stop()
		AreandyPlayed = false
		isSatanSpawned = false
		break
	pass
