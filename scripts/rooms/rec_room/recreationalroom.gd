extends Node2D

class_name RecreationalRoom

@onready var player_packed_scene = preload("res://scenes/player.tscn")

var player : Player = null
var arrows_dodged: int = 0
var doors_locked: bool = true

# makes sure the player is in the scene
func _ready():
	if NavigationManager.player != null:
		add_child(NavigationManager.player)
	else :
		player = player_packed_scene.instantiate()
		NavigationManager.player = player
		add_child(player)
	
	if NavigationManager.spawn_door_tag != null :
		_on_level_spawn(NavigationManager.spawn_door_tag)

# gets the spawn marker from the door and send that info to the player
# through a signal so it spawns at the correct place
func _on_level_spawn(destination_tag : String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
	
func arrow_dodged():
	arrows_dodged += 1
	if arrows_dodged <= 5 and  doors_locked:
		lock_doors()

func lock_doors():
	doors_locked = false
	$Doors/Door_E.lock()
	$Doors/Door_N.lock()
	$Doors/Door_S.lock()
	$Doors/Door_W.lock()
