extends Area2D

signal dust_cleaned

@onready var dust_sprite = $Sprite2D
@onready var smoke = $AnimatedSprite2D

var cleaned = false

func _ready():
	smoke.visible = false

func _on_area_entered(area):
	print("Dust touched by: ", area.name)

	if cleaned:
		return

	if area.name == "Hitbox":
		cleaned = true
		get_parent().get_parent().play_clean_sound()
		dust_sprite.visible = false
		smoke.visible = true
		smoke.play("dust")

		await smoke.animation_finished
		dust_cleaned.emit()
		queue_free()

		
