extends Node2D

@export var arrow_scene: PackedScene
@export var spawn_interval: float = 1.2
@export var arrow_speed: float = 380.0

var timer: float = 0.0
var enabled = true

func _process(delta):
	if not enabled:
		return
	timer += delta
	if timer >= spawn_interval:
		timer = 0.0
		spawn_arrow()
		# Gradually increase difficulty
		spawn_interval = max(0.3, spawn_interval - 0.015)

func spawn_arrow():
	var screen = get_viewport_rect().size
	var arrow = arrow_scene.instantiate()
	
	arrow.position = Vector2(-20, randf_range(0, screen.y))
	arrow.direction = Vector2(1, randf_range(-0.3, 0.3)).normalized()
	arrow.rotation = 0

	arrow.speed = arrow_speed
	get_parent().add_child(arrow)
