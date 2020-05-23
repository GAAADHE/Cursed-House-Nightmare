extends Node
#warnings-disable:
class PathFinding:
	#pathfinding v1.0
	#author: GAADHE
	#Date: 14 maio 2020
	var debug_color = false
	
	var openedList = []
	var closedList = []
	
	var initial_point = null
	var acctual_node = null
	
	var map_colisions = null
	var map_to_paint  = null
	var target_point = null
	var final_path = null
	var Node_Manager = NodeManager.new()
	
	func _init(initial_p : Vector2, target_p : Vector2, map_tile: TileMap, map_floor: TileMap):
		initial_point = initial_p
		target_point = Node_Manager.create_end(target_p)
		map_colisions = map_tile
		map_to_paint = map_floor
		
		#open the first node in acctual position
		_add_node_opened(Node_Manager.create_begin(initial_p))
		var f = _find()
		final_path = _final_path()
		if debug_color:
			for n in final_path:
				map_to_paint.set_cell(n.position.x,n.position.y, 1, false, false, false,Vector2( 10, 0 ))
		# return the final path
		
	func _find():
		var control_loop = true
		while(control_loop):
			
			acctual_node = _find_low_cost_f()
			if acctual_node == null: return 0
			
			if debug_color:
				map_to_paint.set_cell(acctual_node.position.x,acctual_node.position.y, 1, false, false, false,Vector2( 21, 0 ))
			_add_node_closed(acctual_node)
			_remove_node_opened(acctual_node)
			
			if acctual_node.position == target_point.position: return 1
			
			for neighbor in _find_neighbors(acctual_node):
				# if the node aren't in open list----------------
				if !_pos_are_in_list_opened(neighbor.position):
					# give the cost
					if _is_move_diag(neighbor.position,acctual_node.position):
						neighbor.g = 14 + acctual_node.g
					else:
						neighbor.g = 10 + acctual_node.g
					# calculate manhattan
					var distance = neighbor.position + acctual_node.position
					neighbor.h =  (distance.x + distance.y)*10
					# calculate F = G + H
					neighbor.f = neighbor.g + neighbor.h
					# put parent
					neighbor.parent = acctual_node.position
					openedList.push_back(neighbor)
				else:
					# try test if the node can be used as a shortcut, if aready in list opened.
					# if it are in openedList do
					var new_g
					# cost of diagonal / cost h or v
					if(_is_move_diag(neighbor.position,acctual_node.position)):
						new_g = 14 + acctual_node.g
					else:
						new_g = 10 + acctual_node.g
					
					# new cost of the shortcut
					if(new_g < acctual_node.g):
						neighbor.parent = acctual_node.position
						neighbor.g = new_g
						neighbor.f = neighbor.g + neighbor.h
					pass
				pass
				if len(openedList) == 0: return -1
			pass
		pass
		
		
	# Heristic
	# here can have some tie in the select, but the loop will select the first found.
	func _find_low_cost_f():
		if(len(openedList) > 0):
			var low = openedList[0]
			for x in openedList:
				if(x.f < low.f):
					low = x
					pass
				pass
			return low
		"""else:
			return 0"""
		pass
	
	# neighbors
	func _find_neighbors(acct_node):
		var array = []
		var positions = [Vector2(-1,-1),Vector2(0, -1),Vector2( 1, -1),
						 Vector2(-1, 0),               Vector2( 0, 1),
						 Vector2(-1, 1),Vector2( 1, 0),Vector2( 1, 1)]
		
		for pos in positions:
			# if not have way jump to next 
			var neighbor_position = pos + acct_node.position
			if(!_verify_way(neighbor_position,acct_node.position)):continue
			
			# create then the node and push in array
			array.push_back(Node_Manager.create_node(neighbor_position))
			
			pass
		# scan new nodes
		return array
		
	
	func _verify_way(pos:Vector2, acct_po:Vector2):
		# ignore if are in closed list.
		for node in closedList:
			if node.position == pos:
				return false
				
		# ignore if node is block in map.
		if(_has_block_in_cell(pos)):
			return false
		# ignore if diag is blocked.
		if _is_move_diag(pos, acct_po) and !_is_diags_open(pos, acct_po):
			return false
			
		return true
	func _has_block_in_cell(pos):
		if map_colisions.get_cell(pos.x,pos.y) > -1:
			return true
		
	func _is_move_diag(pos,acct_po):
		# Debug later---------------------------------
		var vect = pos - acct_po
		# diags
		# -------------------- Some wrong are wrong here
		var digs = [Vector2(-1,-1), Vector2(-1, 1),
					Vector2( 1,-1), Vector2( 1, 1)]
		for d in digs:
			if(vect==d):
				return true
		return false
		
	# function to see if movement in diagnal is blocked
	# return true if are open neighbor
	func _is_diags_open(pos, acct_po):
		# vertical and horizontals
		# i was very laziness to think in other solution.
		var vect = pos - acct_po
		# Left top
		if vect == Vector2(-1,-1):
			if _has_block_in_cell(pos + Vector2(1,0)) or _has_block_in_cell(pos + Vector2(0,1)):
				return false
			pass
		# Right top
		if vect == Vector2(1,-1):
			if _has_block_in_cell(pos + Vector2(-1,0)) or _has_block_in_cell(pos + Vector2(0,1)):
				return false
			pass
		# Left down
		if vect == Vector2(-1,1):
			if _has_block_in_cell(pos + Vector2(0,-1)) or _has_block_in_cell(pos + Vector2(1,0)):
				return false
			pass
		# Right down
		if vect == Vector2(1,1):
			if _has_block_in_cell(pos + Vector2(-1,0)) or _has_block_in_cell(pos + Vector2(0,-1)):
				return false
			pass
		
		return true
	
	
	# list
	func _pos_are_in_list_opened(pos:Vector2):
		for n in openedList:
			if(n.position == pos):
				return true
			pass
		return false
	# return the path when finish following the parents nodes in list opened.
	func _catch_node_by_pos(pos):
		for n in closedList:
			if n.position == pos:
				return n
		return 
	func _final_path():
		#here will the final nodes
		
		var path = []
		
		# invert to turn more easy to work
		closedList.invert()
		
		# push the target node first
		if len(closedList) > 0:
			path.push_front(closedList[0])
		else:
			return -1
		
		var control = true
		while(control):
			
			# catch the parent of node
			path.push_front(_catch_node_by_pos(path[0].parent))
			
			if(path[0].has("name")):
				if(path[0].name == "begin"):
					control = false
					break
			
			pass
			
		return path
	# nodes
	func _add_node_opened(nodeM:Dictionary):
		openedList.push_back(nodeM)
		pass
	func _remove_node_opened(nodeM:Dictionary):
		var i = openedList.find(nodeM)
		openedList.remove(i)
		pass
		
	func _add_node_closed(nodeM:Dictionary):
		closedList.push_back(nodeM)
		pass
	func _remove_node_closed(nodeM:Dictionary):
		var i = closedList.find(nodeM)
		closedList.remove(i)
		pass
		
class NodeManager:
	func create_begin(pos):
		return {"position":pos, "f":0, "g":0, "h":0, "name":"begin"}
		pass
	func create_end(pos):
		return {"position":pos, "f":0, "g":0, "h":0, "name":"end"}
		pass
	func create_node(pos:Vector2, parent = null, f:int = 0, g:int = 0, h:int = 0, name:String = "defaul"):
		return {"position":pos, "parent":parent,"f":f, "g":g, "h":h, "name":name}
		pass