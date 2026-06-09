extends Control

@onready var health_bar := $CanvasLayer/HealthBar

func turn_off_overlay() -> void:
	visible = false
	health_bar.visible = false

func turn_health_on() -> void:
	health_bar.visible = true
