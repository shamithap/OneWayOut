extends Door

@onready var animation_player := $"../../FadeOut/AnimationPlayer"

func _process(_delta):
	if Global.key_tracker != 3:
		hint.text = "Looks like you need a key..."
	else:
		hint.text = "Press E to interact"
	
	if player_in_range and Input.is_action_just_pressed("interact") and Global.key_tracker == 3:
		Overlay.turn_off_overlay()
		ItemManager.get_node("CanvasLayer/Label").text = ""
		animation_player.play("FadeOut")

func go_to_exit():
	get_tree().change_scene_to_file("res://scenes/rooms/exit_cutscene.tscn")
