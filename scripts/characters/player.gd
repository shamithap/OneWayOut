extends CharacterBody2D

@export var speed := 120.0
@onready var anim = $AnimatedSprite2D

var last_direction = "down"

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
