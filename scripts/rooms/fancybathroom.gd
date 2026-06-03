extends Node2D

class_name FancyBathroom

@onready var player_packed_scene = preload("res://scenes/player.tscn")
@onready var toilet_sound = $TileMaps/Toilet/AudioStreamPlayer2D
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

#gets the spawn marker from the door and send that info to the player
#through a signal so it spawns at teh correct place
func _on_level_spawn(destination_tag : String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player :
		toilet_sound.play()
