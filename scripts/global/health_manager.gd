extends CanvasLayer

@onready var health : int = 3
@onready var heart1 := $Heart1
@onready var heart2 := $Heart2
@onready var heart3 := $Heart3
@export var test = false

func _process(delta: float) -> void:
	if test:
		lose_health()

func lose_health() -> void:
	health = health - 1
	match health:
		2:
			heart3.animation = "lose"
		1:
			heart2.animation = "lose"
		0:
			heart1.animation = "lose"

func death() -> void:
	print("dead")
