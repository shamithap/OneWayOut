extends Node2D

@onready var player_packed_scene = preload("res://scenes/player.tscn")
@onready var lever1 := $Levers/Lever1
@onready var lever2 := $Levers/Lever2
@onready var lever3 := $Levers/Lever3
@onready var hint := $CanvasLayer/Hint

var lever1_active : bool = false
var lever2_active : bool = false
var lever3_active : bool = false
var player : Player = null

#makes sure the player is in the scene
func _ready():
	ensure_player()

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


func _on_lever1_interact_entered(body: Node2D) -> void:
	if body is Player:
		print("lever1 entered")
		if Input.is_action_just_pressed("interact"):
			lever1_active = !lever1_active
			print(lever1_active)

func _on_lever2_interact_entered(body: Node2D) -> void:
	if body is Player:
		print("lever2 entered")
		
		if Input.is_action_just_pressed("interact"):
			lever2_active = !lever2_active
			print(lever2_active)


func _on_lever3_interact_entered(body: Node2D) -> void:
	if body is Player:
		print("lever3 entered")
		
		if Input.is_action_just_pressed("interact"):
			lever3_active = !lever3_active
			print(lever3_active)
