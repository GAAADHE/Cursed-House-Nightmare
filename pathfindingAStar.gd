extends Node
class PathFinding:
	#pathfinding v0.1
	#author: GAADHE
	#Date: 30 abr 2020
	#Last Edit:
	
	var openedList = []
	var closedList = []
	
	var actualPosition = null
	var botPos = null
	
	var target = null
	
	var map = null
	
	
	# positionAI, destinyAI: Type: Vector2D
	func _init(positionAI,destinyAI,gridMap):
		startAStar(positionAI,destinyAI,gridMap)
		pass
	# Separated because you can use again later.
	func startAStar(positionAI,destinyAI,gridMap):
		#clear all list to start again
		reset()
		
		# set map level
		map = gridMap
		
		# set bot var position
		botPos = positionAI
		
		
		#set initial field
		var node_initial = create_node(positionAI,0, "none", "begin")
		add_to_opened(node_initial)
		
		
		#set destiny field
		target = create_node(destinyAI,0, "none", "end")
		
		
		#set initial node
		actualPosition = node_initial
		
		#start loop
		set_finding_state(true)
		
		
	func _process(delta):
		if(get_finding_state() == true):
			var nodeWithLessF = find_node_low_cost_f()
			add_to_closed(nodeWithLessF)
			remove_opened(nodeWithLessF)
			actualPosition = nodeWithLessF
			findNeighbors(actualPosition)
			pass
		pass
	
	# var to control loop of find
	var findingStatus = false
	func set_finding_state(value):
		findingStatus = value
	func get_finding_state():
		return findingStatus
		
	# Algorithm to scan filds
	func findNeighbors(actualNode):
		# used to scan around any position
		var Neighbors = [[-1,-1],[ 0,-1],[ 1,-1],
						[-1, 0],        [ 1, 0],
						[-1, 1],[ 0, 1],[ 1, 1]]
						
		for n in Neighbors:
			# calc actual position using 8 possibilities of array Neighbors
			var posRelativeToPosNode = Vector2(float(n[0]),float(n[1])) - actualNode.position
			
			#Verify if have any tile blocking the way
			if has_path(posRelativeToPosNode):
				if !aready_in_list(posRelativeToPosNode):
					var new_node = null
					#create a new node
					# if is a diag increase cost, because movement in diag is a bit longer than horizontal and vertical.
					if n == [-1,-1] or n == [1,-1] or n == [-1,1] or n == [1,1]:
						new_node = create_node(posRelativeToPosNode,14)+actualNode.cost
					else:
						new_node = create_node(posRelativeToPosNode,10)+actualNode.cost
					#append to list
					
					new_node.parent = actualNode.name
	
					add_to_opened(new_node)
				else:
					#if already in list verify if can short using actual position as parent
					#-----------------
					#by default
					var lower_neighbour = openedList[0]
					var f_lower_cost = f(lower_neighbour.cost,h(lower_neighbour.position))
					var cost_of_acctual = f(actualNode.cost,h(actualNode.position))
					# find low cost neighbour
					for x in openedList:
						# F=G+H - reseted for each item
						var cost_f_of_x = f(x.cost , h(x.position))
						if(cost_f_of_x + cost_of_acctual < f_lower_cost):
							#set object lower cost to var
							lower_neighbour = x
							#set cost of object
							f_lower_cost = cost_f_of_x
							pass
						pass
					#re parent neighbour-------------------------------------
					actualPosition = lower_neighbour
					pass
			pass
		pass
	# by the position veify is alreandy in list
	func aready_in_list(posNode):
		for i in openedList:
			if i.position == posNode:
				return true
		return false
	#------------------------------------------------------
	#Manhattan
	func h(nodePosition):
		# add X
		var H = (-nodePosition.x + target.position.x)*10
		# add Y
		H += (-nodePosition.y + target.position.y)*10
		return H
	#F
	func f(g,h):
		return g+h
	
	# find the cust f 
	func find_node_low_cost_f():
		if("cost" in openedList[0]):
			# set by default the first item
			var low_cost = openedList[0]
			# F=G+H - by default the first item
			var f_low_cost = low_cost.cost + h(low_cost.position)
			# try one by one find lower
			for x in openedList:
				# F=G+H - reseted for each item
				var cost_f_of_x = f(x.cost , h(x.position))
				if(cost_f_of_x < f_low_cost):
					low_cost = x
					f_low_cost = cost_f_of_x
					pass
				pass
			return low_cost
		else:
			print("error trying find cost: it\'s not a node!")
	
	#
	func reset():
		openedList.clear()
		closedList.clear()
	#node methods
	func create_node(position = Vector2(0,0),cost = null,parent = null, name = "noname"):
		var map_node = {"cost":cost,"position":position,"parent":str(parent),"name":str(name)}
		return map_node
		pass
	func is_actual_node(node):
		node.position
	
	#verify if have can pass through to use any way
	func has_path(position):
		# you need edit this depending of what way you use.
		if map.get_cell(position) > -1:
			#can't pass through
			return false
		else:
			#can :)
			return true
		
	#list methods
	func add_to_opened(node):
		openedList.append(node)
		
	func add_to_closed(node):
		closedList.append(node)
	func remove_opened(node):
		var i = openedList.find(node)
		openedList.remove(i)
	func remove_closed(node):
		var i = closedList.find(node)
		openedList.remove(i)
	
	
