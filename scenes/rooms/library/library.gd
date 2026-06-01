extends Node2D

class_name Library

@onready var player_packed_scene = preload("res://scenes/player.tscn")
@onready var scroll := get_node_or_null("CanvasLayer/Scroll")
@onready var scroll_hint := $CanvasLayer/ScrollHint
@onready var scroll_sound := get_node_or_null("ScrollArea/AudioStreamPlayer2D")
@onready var key_marker := get_node_or_null("libraryMarker")
@onready var broom := get_node_or_null("Broom")

var player : Player = null
var in_scroll_range = false

func _ready():
	ensure_player()
	
	if scroll != null:
		scroll.visible = false
	
	if scroll_hint != null:
		scroll_hint.visible = false
	
	if Global.library_complete:
		won()
		if broom != null:
			broom.queue_free()

func _process(_delta):
	if in_scroll_range and Input.is_action_just_pressed("interact") and not Global.library_complete:
		scroll.visible = !scroll.visible
		
		if player != null:
			player.can_move = !scroll.visible
		
		scroll_sound.play()

func ensure_player():
	if NavigationManager.player != null:
		add_child(NavigationManager.player)
		player = NavigationManager.player
	else:
		player = player_packed_scene.instantiate()
		NavigationManager.player = player
		add_child(player)
	
	if NavigationManager.spawn_door_tag != null:
		_on_level_spawn(NavigationManager.spawn_door_tag)

func _on_level_spawn(destination_tag : String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)

func won():
	if not Global.library_item_collected:
		ItemManager.get_item(key_marker.global_position)
		Global.library_item_collected = true
		

func _on_scroll_area_body_entered(body: Node2D) -> void:
	if body is Player and not Global.library_complete:
		scroll_hint.visible = true
		in_scroll_range = true

func _on_scroll_area_body_exited(body: Node2D) -> void:
	if body is Player:
		scroll_hint.visible = false
		in_scroll_range = false
