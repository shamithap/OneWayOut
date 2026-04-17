extends Node2D

@onready var hint = $"../CanvasLayer/Hint"

#helps keep track when player is nearby
var player_in_range = false 


func _on_door_body_entered(_body: Node2D) -> void:
	hint.visible = true
	player_in_range = true 

func _on_door_body_exited(_body: Node2D) -> void:
	hint.visible = false
	player_in_range = false

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		Global.spawn_location = "door1" 
		get_tree().change_scene_to_file("res://scenes/rooms/room1.tscn")
