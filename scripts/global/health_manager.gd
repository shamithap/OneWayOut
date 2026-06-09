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
	Global.restart_game_signal.connect(restore_health)

func lose_health() -> void:
	print("you lost a heart!")
	if health <= 0:
		return

	hurt_sound.play()
	health -= 1
	Global.player_health = health

	match health:
		2:
			heart3.play("lose")
		1:
			heart2.play("lose")
		0:
			heart1.play("lose")
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
	Global.player_health = health
	heart1.play("idle")
	heart2.play("idle")
	heart3.play("idle")
