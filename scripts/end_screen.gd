extends Control



func _on_back_button_button_down() -> void:
	MusicManager.play_music()
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
