extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SERVER_PORT = 1313
const MAX_PLAYERS = 5
const SERVER_IP = "127.0.0.1"
 
# Called when the node enters the scene tree for the first time.
func _ready():
	initializeServer()
	print(get_tree().is_network_server())
	pass # Replace with function body.

func initializeServer():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_peer", peer)
	pass
func initializeCliente():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_peer", peer)
	
# SceneTree.get_network_unique_id() #get unique id
# SceneTree.network_peer_connected(int id)
# SceneTree.network_peer_disconnected(int id)
func killNerwork():
	# send mensage "i'm leaveing" to alert closing
	get_tree().set_network_peer(null)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
