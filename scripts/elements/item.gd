extends Area2D
class_name Item

@onready var hint := $CanvasLayer/Hint
var can_interact = false

func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("interact"):
		ItemManager.pickup_item(name)
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		can_interact = true
		hint.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		can_interact = false
		hint.visible = false
