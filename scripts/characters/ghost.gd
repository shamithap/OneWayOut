extends Node2D

var astar := AStar2D.new()
var room_ids := {}

var current_room := ""
var player_room := ""

var move_timer: Timer

var speed := 1.2
var min_speed := 0.4
var speed_decay := 0.98

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
	
func _on_room_changed(room_name: String):
	if room_ids.has(room_name):
		player_room = room_name
	else:
		print("Bad room signal:", room_name)

func _on_timer_timeout() -> void:
	player_room = NavigationManager.current_room_name
	chase_player()

func chase_player():
	print("Chase:", current_room, "->", player_room)
	if not room_ids.has(current_room) or not room_ids.has(player_room):
		return

	var path = astar.get_id_path(
		room_ids[current_room],
		room_ids[player_room]
	)

	if path.size() <= 1:
		return

	var next_room = get_room_name(path[1])

	print("Ghost moves:", current_room, "->", next_room)

	current_room = next_room
	
	var scene = get_tree().current_scene
	var point = scene.get_node_or_null("GhostPoint")
	if point == null:
		print("No GhostPoint in current scene:", scene.name)
		return

	global_position = point.global_position

	# Speed increase over time
	speed = max(min_speed, speed * speed_decay)
	move_timer.wait_time = speed

func get_room_name(id: int) -> String:
	for room in room_ids:
		if room_ids[room] == id:
			return room
	return ""

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
	move_timer.wait_time = speed
	move_timer.timeout.connect(_on_timer_timeout)
	move_timer.start()
