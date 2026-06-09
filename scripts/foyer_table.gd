extends StaticBody2D

@onready var hint := $"../CanvasLayer/Hint"
@onready var scroll := $"../CanvasLayer/Scroll"
@onready var player := $"../Player"
@onready var exclamation_point := $"../ExclamationPoint"

var player_in_range : bool = false

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		scroll.visible = !scroll.visible
		player.can_move = !player.can_move
		exclamation_point.visible = false

func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		hint.visible = true

func _on_trigger_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		hint.visible = false
