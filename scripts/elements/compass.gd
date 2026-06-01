extends Item

@onready var texture := $TextureRect
@onready var collision := $CollisionShape2D

func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("interact"):
		ItemManager.pickup_item(name)
		Overlay.get_node("CanvasLayer/Minimap").compass_activated = true
		Overlay.get_node("CanvasLayer/Minimap").ghost.visible = true
		
		texture.visible = false
		collision.disabled = true
		
		Overlay.get_node("CanvasLayer/Minimap").timer.start()
		
		queue_free()
		
