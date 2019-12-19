extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var area2DDetector
var enableFog = false
var state = false
var nodeParentMap
# Called when the node enters the scene tree for the first time.
func _ready():
	nodeParentMap = get_parent()
	area2DDetector = get_parent().get_node("Area2D")
	if area2DDetector.get_class() == "[Object:null]":
		print("Area 2D not found in node.")
	else: enableFog = true
		 
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enableFog == true:
		var oBodies = area2DDetector.get_overlapping_bodies()
		var findPlayer = false
		if oBodies.size() >0:
			for b in oBodies:
				if "isAPlayer" in b: # verify if is player
					findPlayer= true
					var source = b
					var pa = b.get_parent()
					var pos = b.get_position() - nodeParentMap.get_position()# remove bug position relatives
					#print(b.get_owner().name)
					#note we need change portal system
					#print(nodeParentMap.name," node") 
					if b.get_owner() != nodeParentMap:
						pa.remove_child(b)#remove of main
						nodeParentMap.add_child(source)
						source.owner = nodeParentMap
						source.set_position(pos)
						print("plauer are in:", source.get_parent().name)
						print("plauer owner in:", source.owner.name)
		nodeParentMap.set_visible(findPlayer) #if find player turn on visible or not
		
	pass
