extends Node2D

class_name Broom

@onready var hint : Label = $CanvasLayer/Hint

var player_in_range = false

func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body is Player:
		hint.visible = true
		player_in_range = true

func _on_trigger_area_body_exited(body: Node2D) -> void:
	if body is Player:
		hint.visible = false
		player_in_range = false

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/rooms/library/dust_minigame.tscn")
