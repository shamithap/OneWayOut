extends Node2D

@onready var player_packed_scene = preload("res://scenes/player.tscn")
@onready var chest := $RewardChest/Sprite2D
@onready var chest_marker := $RewardChest/Marker2D
var player : Player = null

#makes sure the player is in the scene
func _ready():
	if NavigationManager.player != null:
		add_child(NavigationManager.player)
	else :
		player = player_packed_scene.instantiate()
		NavigationManager.player = player
		add_child(player)
	
	if NavigationManager.spawn_door_tag != null :
		_on_level_spawn(NavigationManager.spawn_door_tag)

	if Global.kitchen_complete:
		already_won()

#gets the spawn marker from the door and send that info to the player
#through a signal so it spawns at the correct place
func _on_level_spawn(destination_tag : String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
	
	
func already_won():
	if not Global.kitchen_item_collected:
		chest.animation = "opening"
		await chest.animation_finished
		ItemManager.get_item(chest_marker.global_position)
		Global.kitchen_item_collected = true
	else:
		chest.animation = "open"
