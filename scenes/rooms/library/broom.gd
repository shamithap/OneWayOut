extends Node2D

class_name Broom

@onready var hint : Label = $Hint
@onready var pickup_sound = $PickupSound

var player_in_range = false

func _ready():
	hint.visible = false

func _process(_delta):
	if Global.library_complete:
		queue_free()
		return

	if player_in_range and Input.is_action_just_pressed("interact"):
		if pickup_sound != null:
			pickup_sound.play()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/rooms/library/dust_minigame.tscn")

func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body is Player and not Global.library_complete:
		hint.visible = true
		player_in_range = true

func _on_trigger_area_body_exited(body: Node2D) -> void:
	if body is Player:
		hint.visible = false
		player_in_range = false
