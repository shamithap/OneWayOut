extends Node2D

func go_to_end_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/end_screen.tscn")

func _ready() -> void:
	Ghost.visible = false
