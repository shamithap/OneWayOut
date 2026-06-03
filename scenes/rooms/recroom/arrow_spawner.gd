extends Node2D

@export var arrow_scene: PackedScene
@export var fire_interval: float = 1.5
@export var arrow_speed: float = 100.0


var arrow_slots = [
	Vector2(-60, -64),
	Vector2(-60, -58),
	Vector2(-60, -32),
	Vector2(-60, -16),
	Vector2(-60, 0),
]

var timer: float = 0.0
var last_slot: int = -1
var arrows_fired: int = 0
var max_arrows: int = 10

func _process(delta):
	if Global.recroom_complete:
		return
	if arrows_fired >= max_arrows:
		return
	timer += delta
	if timer >= fire_interval:
		timer = 0.0
		fire_random()

func fire_random():
	var index = randi() % arrow_slots.size()
	if index == last_slot:
		index = (index + 1) % arrow_slots.size()
	last_slot = index

	var arrow = arrow_scene.instantiate()
	arrow.position = arrow_slots[index]
	arrow.direction = Vector2(1, 0)
	arrow.rotation = 0.0
	arrow.speed = arrow_speed
	get_parent().add_child(arrow)
	
	arrows_fired += 1
