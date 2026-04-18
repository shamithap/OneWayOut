extends CharacterBody2D

class_name Player

@export var speed := 120.0
@onready var anim = $AnimatedSprite2D

var last_direction = "down"

func _ready():
	NavigationManager.on_trigger_player_spawn.connect(_on_spawn)

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")

	velocity = direction * speed
	move_and_slide()

	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				last_direction = "right"
			else:
				last_direction = "left"
		else:
			if direction.y > 0:
				last_direction = "down"
			else:
				last_direction = "up"

		anim.play("walk_" + last_direction)
	else:
		anim.play("idle_" + last_direction)
		

func _on_spawn(spawn_position : Vector2, direction : String):
	global_position = spawn_position
	velocity = Vector2.ZERO
	last_direction = direction
	anim.play("walk_" + direction)
