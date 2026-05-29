extends Door


func _process(_delta):
	if Global.key_tracker != 3:
		hint.text = "Looks like you need a key..."
	else:
		hint.text = "Press E to interact"
	
	if player_in_range and Input.is_action_just_pressed("interact") and Global.key_tracker == 3:
		NavigationManager.go_to_level(destination_room_name, destination_door_tag)
