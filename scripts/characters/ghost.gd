extends Area2D

var astar := AStar2D.new()
var room_ids := {}

var current_room := ""
var player_room := ""

var move_timer: Timer

var room_stay_time := 60.0
# var speed_decay := 0.98

func setup_graph():
	astar.clear()
	room_ids.clear()
	
	var rooms = [
		"main",
		"library",
		"armory",
		"livingroom",
		"dungeon",
		"theater",
		"recreationalroom",
		"winecellar",
		"ballroom",
		"diningroom",
		"kitchen",
		"graveyard",
		"fancybathroom",
		"exitroom"
	]

	for i in range(rooms.size()):
		room_ids[rooms[i]] = i
		astar.add_point(i, Vector2(i * 100, 0))

# Connect doors
	connect_rooms("dungeon","armory")
	connect_rooms("dungeon","graveyard")

	connect_rooms("armory","recreationalroom")
	connect_rooms("armory","theater")

	connect_rooms("theater","library")
	connect_rooms("theater","ballroom")

	connect_rooms("ballroom","livingroom")

	connect_rooms("graveyard","winecellar")
	connect_rooms("graveyard","recreationalroom")

	connect_rooms("recreationalroom","library")
	connect_rooms("recreationalroom","kitchen")

	connect_rooms("library","diningroom")
	connect_rooms("library","livingroom")

	connect_rooms("livingroom","fancybathroom")
	connect_rooms("livingroom","main")
	
	connect_rooms("graveyard","exitroom")

func connect_rooms(a, b):
	if not room_ids.has(a) or not room_ids.has(b):
		print("Invalid room connection:", a, b)
		return

	astar.connect_points(room_ids[a], room_ids[b])

func _on_room_changed(room_name:String):
	if room_ids.has(room_name):
		player_room = room_name
	else:
		print("Unknown player room:", room_name)

	# immediately re-evaluate ghost appearance
	update_visual_position()

func _on_timer_timeout() -> void:
	#player_room = NavigationManager.current_room_name	
	print(
		"Player room:", player_room,
		"| Ghost room:", current_room
	)
	chase_player()
	
func update_visual_position():

	# Ghost only appears if player and ghost share room
	if current_room != player_room:
		hide()
		return

	var scene = get_tree().current_scene

	if scene == null:
		hide()
		return

	var point = scene.find_child("GhostPoint", true, false)

	if point == null:
		print("No GhostPoint in:", scene.name)
		hide()
		return

	global_position = point.global_position
	show()

func chase_player():
	print("CHASE:",current_room,"->",player_room)

	if !room_ids.has(current_room):
		return

	if !room_ids.has(player_room):
		return

	var path = astar.get_id_path(
		room_ids[current_room],
		room_ids[player_room]
	)

	if path.size() > 1:
		var next_room = get_room_name(path[1])

		print("Ghost moves:", current_room, "->", next_room)

		current_room = next_room
		Overlay.get_node("CanvasLayer/Minimap").update_ghost_position(current_room)

	# Show ghost only if ghost and player share room
	if current_room == player_room:
		update_visual_position()
		attack_player()
	else:
		hide()

	# speed scaling
	# speed = max(min_speed, speed * speed_decay)
	# move_timer.wait_time = room_stay_time

func get_room_name(id: int) -> String:
	for room in room_ids:
		if room_ids[room] == id:
			return room
	return ""
	
func attack_player() -> void:
	# take one heart away
	# print ghost got you! dialouge box
	hide()
	# transport ghost back to graveyard 
	current_room = "graveyard"
	if(player_room == "graveyard"):
		current_room = "main"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Ghost started chasing you")
	setup_graph()

	current_room = "graveyard"
	player_room = NavigationManager.current_room_name

	# listen for room changes
	NavigationManager.room_changed.connect(_on_room_changed)
	
	# setup timer
	move_timer = $Timer
	move_timer.wait_time = room_stay_time
	move_timer.timeout.connect(_on_timer_timeout)
	move_timer.start()
