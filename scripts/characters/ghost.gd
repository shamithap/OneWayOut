extends Area2D

var astar := AStar2D.new()
var room_ids := {}

var current_room := ""
var player_room := ""

var move_timer: Timer
var waiting_for_continue := false

var room_stay_time := 60.0

@onready var laugh_sound_1: AudioStreamPlayer = $LaughSound1
@onready var laugh_sound_2: AudioStreamPlayer = $LaughSound2
@onready var laugh_sound_3: AudioStreamPlayer = $LaughSound3
@onready var whisper_sound: AudioStreamPlayer = $WhisperSound


@onready var warning_panel := $CanvasLayer/Panel

var quiet_volume = 0
var medium_volume = -18
var loud_volume = -5


#we love adj dictionaries 
var room_connections = {
	"dungeon": ["armory", "graveyard"],
	"armory": ["dungeon", "theater", "recreationalroom"],
	"theater": ["armory", "ballroom", "library"],
	"ballroom": ["theater", "livingroom"],

	"graveyard": ["dungeon", "recreationalroom", "winecellar"],
	"recreationalroom": ["graveyard", "library", "armory", "kitchen"],
	"library": ["recreationalroom", "livingroom", "theater", "diningroom"],
	"livingroom": ["library", "ballroom", "main", "fancybathroom"],
	"main": ["livingroom"],

	"winecellar": ["graveyard", "kitchen"],
	"kitchen": ["winecellar", "recreationalroom", "diningroom"],
	"diningroom": ["kitchen", "library", "fancybathroom"],
	"fancybathroom": ["diningroom", "livingroom"]
}
var laugh_sounds = [
	preload("res://sounds/ghostLaugh/ghostlaugh1.ogg"),
	preload("res://sounds/ghostLaugh/ghostlaugh2.ogg"),
	preload("res://sounds/ghostLaugh/ghostlaugh3.ogg"),
	preload("res://sounds/ghostLaugh/ghostlaugh4.ogg"),
	preload("res://sounds/ghostLaugh/ghostlaugh5.ogg"),
	preload("res://sounds/ghostLaugh/ghostlaugh6.ogg"),
	preload("res://sounds/ghostLaugh/ghostlaugh7.ogg")
]

var whisper_sounds = [
	preload("res://sounds/ghostLaugh/whisper1.ogg"),
	preload("res://sounds/ghostLaugh/whisper2.ogg"),
	preload("res://sounds/ghostLaugh/scary_gibberish.ogg")
]



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
	
	await get_tree().process_frame
	
	# immediately re-evaluate ghost appearance, capture, and audio
	update_visual_position()
	check_capture()
	update_danger_audio()

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
		check_capture()
	else:
		hide()
	update_danger_audio()

	# speed scaling
	# speed = max(min_speed, speed * speed_decay)
	# move_timer.wait_time = room_stay_time

func get_room_name(id: int) -> String:
	for room in room_ids:
		if room_ids[room] == id:
			return room
	return ""
	

func caught_player():
	var current_scene_name = get_tree().current_scene.name
	Global.in_dialogue = true
	waiting_for_continue = true
	if(current_scene_name == "CreditScreen"):
		warning_panel.visible = false
	else:
		warning_panel.visible = true
	if(player_room == "graveyard"):
		current_room = "main"
	else:
		current_room = "graveyard"
	Overlay.get_node("CanvasLayer/Minimap").update_ghost_position(current_room)
	
func _input(event):
	if waiting_for_continue and event.is_action_pressed("interact"):
		Global.in_dialogue = false
		waiting_for_continue = false
		warning_panel.visible = false
		Overlay.get_node("CanvasLayer/HealthBar").lose_health()
		print("Current health:", Global.player_health)
		hide()
	
func check_capture():
	if current_room == player_room:
		caught_player()

#func attack_player() -> void:
	## take one heart away
	#Overlay.get_node("CanvasLayer/HealthBar").lose_health()
	## print ghost got you! dialouge box
	## TODO: dialouge box
	#hide()
	## transport ghost back to graveyard 
	#current_room = "graveyard"
	#if(player_room == "graveyard"):
		#current_room = "main"
		
func show_ghost_location():
	print("Ghost currently in:", current_room)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Ghost started chasing you")
	setup_graph()

	current_room = "graveyard"
	player_room = NavigationManager.current_room_name

	# listen for room changes
	NavigationManager.room_changed.connect(_on_room_changed)
	
	# ghost room display
	var debug_timer = Timer.new()
	debug_timer.wait_time = 1.0
	debug_timer.timeout.connect(show_ghost_location)
	add_child(debug_timer)
	debug_timer.start()
	
	# setup timer
	move_timer = $Timer
	move_timer.wait_time = room_stay_time
	move_timer.timeout.connect(_on_timer_timeout)
	move_timer.start()
	
	#mwahahahahahah
func play_spooky_audio(volume):

	if laugh_sound_1.playing or laugh_sound_2.playing or laugh_sound_3.playing or whisper_sound.playing:
		return

	var laugh_players = [laugh_sound_1, laugh_sound_2, laugh_sound_3]

	for laugh_player in laugh_players:
		laugh_player.stream = laugh_sounds.pick_random()
		laugh_player.volume_db = volume + randf_range(-4, 1)
		laugh_player.pitch_scale = randf_range(0.85, 1.15)
		laugh_player.play()

	whisper_sound.stream = whisper_sounds.pick_random()
	whisper_sound.volume_db = volume - 10
	whisper_sound.pitch_scale = randf_range(0.75, 0.95)

	await get_tree().create_timer(0.25).timeout
	whisper_sound.play()

func update_danger_audio():

	#no ghost audio in exit room
	if player_room == "exitroom":
		laugh_sound_1.stop()
		laugh_sound_2.stop()
		laugh_sound_3.stop()
		whisper_sound.stop()
		return

	#loud if same room
	if current_room == player_room:

		play_spooky_audio(loud_volume)

		print("Playing loud laugh |", player_room, "|", current_room)

	#medium 
	elif current_room in room_connections.get(player_room, []):

		play_spooky_audio(medium_volume)

		print("Playing medium laugh |", player_room, "|", current_room)

	#stop audio otherwise
	else:

		if laugh_sound_1.playing:
			laugh_sound_1.stop()

		if laugh_sound_2.playing:
			laugh_sound_2.stop()

		if laugh_sound_3.playing:
			laugh_sound_3.stop()

		if whisper_sound.playing:
			whisper_sound.stop()

		
		
