extends Node2D

class_name Theater

@onready var player_packed_scene = preload("res://scenes/player.tscn")

@onready var scroll := $CanvasLayer/Scroll
@onready var scroll_hint := $CanvasLayer/ScrollHint
@onready var scroll_sound := $ScrollArea/AudioStreamPlayer2D
@onready var mirror_hint := $MirrorArea/MirrorHint
@onready var mirror_return_point := $MirrorReturnPoint
@onready var mirror_area := $MirrorArea
@onready var mirror_decor := $Node2D/Extra_Decor
@onready var theater_marker := $theaterMarker


var player : Player = null
var in_scroll_range = false
var in_mirror_range = false

func _ready():
	ensure_player()
	scroll.visible = false
	scroll_hint.visible = false
	mirror_hint.visible = false

	if Global.theater_complete:
		mirror_decor.visible = false
		mirror_area.monitoring = false
		mirror_hint.visible = false
	
		if not Global.theater_item_collected:
			ItemManager.get_item(theater_marker.global_position)
			Global.theater_item_collected = true

func _process(_delta):
	if in_scroll_range and Input.is_action_just_pressed("interact"):
		scroll.visible = !scroll.visible
		player.can_move = !scroll.visible
		scroll_sound.play()
	
	if in_mirror_range and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/rooms/theater/theater_minigame.tscn")

func ensure_player():
	if NavigationManager.player != null:
		add_child(NavigationManager.player)
		player = NavigationManager.player
	else:
		player = player_packed_scene.instantiate()
		NavigationManager.player = player
		add_child(player)

	if Global.return_from_mirror:
		player.global_position = mirror_return_point.global_position
		player.last_direction = "down"
		Global.return_from_mirror = false
	elif NavigationManager.spawn_door_tag != null:
		_on_level_spawn(NavigationManager.spawn_door_tag)

func _on_level_spawn(destination_tag : String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)

func _on_scroll_area_body_entered(body: Node2D) -> void:
	if body is Player:
		scroll_hint.visible = true
		in_scroll_range = true

func _on_scroll_area_body_exited(body: Node2D) -> void:
	if body is Player:
		scroll_hint.visible = false
		in_scroll_range = false
		scroll.visible = false
		player.can_move = true

func _on_mirror_area_body_entered(body: Node2D) -> void:
	if body is Player and not Global.theater_complete:
		mirror_hint.visible = true
		in_mirror_range = true

func _on_mirror_area_body_exited(body: Node2D) -> void:
	if body is Player:
		mirror_hint.visible = false
		in_mirror_range = false
