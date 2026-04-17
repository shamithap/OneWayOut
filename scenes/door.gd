extends Node2D

@onready var hint = $"../Hint"

func _on_door_body_entered(_body: Node2D) -> void:
	hint.visible = true

func _on_door_body_exited(_body: Node2D) -> void:
	hint.visible = false
