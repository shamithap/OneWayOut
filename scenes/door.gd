extends Area2D

@onready var hint = $"../../Hint"

func _on_body_entered(body: Node2D) -> void:
	hint.visible(true)

func _on_body_exited(body: Node2D) -> void:
	hint.visible(false)
