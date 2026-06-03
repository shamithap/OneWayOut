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
	
	# lock doors at the start
	if !Global.recroom_complete:
		lock_doors()
		arrow_dodged()

# gets the spawn marker from the door and send that info to the player
# through a signal so it spawns at the correct place
func _on_level_spawn(destination_tag : String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
	
func arrow_dodged():
	arrows_dodged += 1
	if arrows_dodged >= 10 and doors_locked:
		print("dodged 10 arrows...unlocking doors")
		Global.recroom_complete = true
		unlock_doors()
		$CanvasLayer.visible = true

func lock_doors():
	$Doors/Door_E.locked = true
	$Doors/Door_N.locked = true
	$Doors/Door_S.locked = true
	$Doors/Door_W.locked = true
	$Doors/Door_E/CanvasLayer/Hint.text = "Door is locked"
	$Doors/Door_N/CanvasLayer/Hint.text = "Door is locked"
	$Doors/Door_S/CanvasLayer/Hint.text = "Door is locked"
	$Doors/Door_W/CanvasLayer/Hint.text = "Door is locked"
	

func unlock_doors():
	doors_locked = false
	$Doors/Door_E.locked = false
	$Doors/Door_N.locked = false
	$Doors/Door_S.locked = false
	$Doors/Door_W.locked = false
	$Doors/Door_E/CanvasLayer/Hint.text = "Press E to enter"
	$Doors/Door_N/CanvasLayer/Hint.text = "Press E to enter"
	$Doors/Door_S/CanvasLayer/Hint.text = "Press E to enter"
	$Doors/Door_W/CanvasLayer/Hint.text = "Press E to enter"
	
