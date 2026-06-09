extends Item

@onready var texture := $TextureRect
@onready var collision := $CollisionShape2D

func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("interact"):
		ItemManager.pickup_item("Compass")

		var minimap = Overlay.get_node("CanvasLayer/Minimap")
		minimap.compass_activated = true
		minimap.compass_timer.start()
		minimap.ghost.visible = true
		
		queue_free()
