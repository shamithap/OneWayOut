extends Node2D

func _ready() -> void:
	#doesn't need to check if player exists because right now
	#player just starts in main room
	#might be changed in the future
	if NavigationManager.spawn_door_tag != null:
		_on_level_spawn(NavigationManager.spawn_door_tag)

#gets the spawn marker from the door and send that info to the player
#through a signal so it spawns at teh correct place
func _on_level_spawn(destination_tag : String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
