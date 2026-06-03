extends Control



func _on_back_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	Global.reset_game()
	
