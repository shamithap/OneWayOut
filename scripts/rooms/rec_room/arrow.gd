extends Area2D

@export var speed := 10.0
var direction := Vector2.ZERO

func _on_body_entered(body):
	Overlay.get_node("CanvasLayer/HealthBar").lose_health()

func _process(delta):
	global_position += direction * speed * delta
	
	var screen = get_viewport_rect().size
	if position.x > screen.x + 128:  # arrow fully crossed the room
		get_parent().arrow_dodged()  # tell main the player dodged it

func _ready():
	body_entered.connect(_on_body_entered)
