extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
var players = []
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var detect = get_overlapping_bodies()
	
	for i in detect:
		# add the player in list players array
		if "isAPlayer" in i:
			if(!i.isOnBack):
				i.set_back_of_object(false)
				players.push_back(i)
		# remove if the player out the area
		for v in players:
			if(!findPlayerInArea(v,detect)):
				v.set_back_of_object(false)
				players.erase(v)
				print("tryind remove")
	
	pass

func findPlayerInArea(player,actualPlayers):
	for p in actualPlayers:
		if(p == player):
			return 1
	return 0