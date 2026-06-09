extends Item

@onready var texture := $TextureRect
@onready var collision := $CollisionShape2D

func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("interact"):
		ItemManager.pickup_item("Hourglass")
		
		Ghost.hourglass_timer_start()
		
		queue_free()
