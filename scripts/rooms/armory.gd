extends Node2D

@onready var player_packed_scene = preload("res://scenes/player.tscn")
@onready var chest := $RewardChest/Sprite2D
var player : Player = null

func _ready():
	ensure_player()
	if Global.armory_complete:
		already_won()

func ensure_player():
	if NavigationManager.player != null:
		add_child(NavigationManager.player)
	else :
		player = player_packed_scene.instantiate()
		NavigationManager.player = player
		add_child(player)
	
	if NavigationManager.spawn_door_tag != null :
		_on_level_spawn(NavigationManager.spawn_door_tag)

func _on_level_spawn(destination_tag : String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)

func already_won():
	chest.animation = "open"
	
