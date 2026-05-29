extends Room

@onready var exit_lock_sprite := $ExitLock
@onready var exit_door := $Doors/Door_N

func _process(_delta: float) -> void:
	check_exit_unlocked()

func check_exit_unlocked():
	if Global.key_tracker == 3 and get_tree().current_scene.name == "graveyard":
		exit_lock_sprite.animation = "opening"
