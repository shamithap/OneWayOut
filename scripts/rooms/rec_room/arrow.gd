extends Area2D

@export var speed := 300.0
var direction := Vector2.ZERO

func _process(delta):
	global_position += direction * speed * delta
