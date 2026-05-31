extends Control


func _on_play_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/rooms/main.tscn")


func _on_credits_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/rooms/credit_screen.tscn")


func _on_quit_button_down() -> void:
	get_tree().quit()
