extends Item

@onready var texture := $TextureRect
@onready var collision := $CollisionShape2D

func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("interact"):
		ItemManager.pickup_item("Hourglass")

		var minimap = Overlay.get_node("CanvasLayer/Minimap")
		minimap.hourglass_activated = true
		minimap.timer.start()

		texture.visible = false
		collision.disabled = true
		queue_free()
