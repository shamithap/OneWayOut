extends Node2D

@onready var health : int = 3
@onready var max_health : int = 3

@onready var heart1 := $Heart1
@onready var heart2 := $Heart2
@onready var heart3 := $Heart3
@onready var hurt_sound := $HurtSound

signal player_died

func _ready():
	Global.player_health = health

func lose_health() -> void:
	print("you lost a heart!")
	if health <= 0:
		return

	hurt_sound.play()
	health -= 1
	Global.player_health = health

	match health:
		2:
			heart3.animation = "lose"
		1:
			heart2.animation = "lose"
		0:
			heart1.animation = "lose"
			death()

func heal_health() -> void:
	if health >= max_health:
		return

	health += 1
	Global.player_health = health

	match health:
		1:
			heart1.animation = "idle"
		2:
			heart2.animation = "idle"
		3:
			heart3.animation = "idle"

func death() -> void:
	player_died.emit()
	
func restore_health() -> void:
	health = 3
	heart1.animation = "idle"
	heart2.animation = "idle"
	heart3.animation = "idle"
