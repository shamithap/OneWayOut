extends "res://scripts/rooms/room.gd"

@onready var scroll_hint = $CanvasLayer/ScrollHint
@onready var scroll_sound = $ScrollArea/AudioStreamPlayer2D
@onready var scroll = $CanvasLayer/Scroll

var in_scroll_range : bool = false

func _ready():
	super._ready()
	scroll_hint.visible = false
	scroll.visible = false

func _process(_delta: float) -> void:
	if in_scroll_range and Input.is_action_just_pressed("interact"):
		scroll.visible = !scroll.visible

		if NavigationManager.player != null:
			NavigationManager.player.can_move = !NavigationManager.player.can_move

		scroll_sound.play()

func _on_scroll_area_body_entered(body: Node2D) -> void:
	if body is Player:
		scroll_hint.visible = true
		in_scroll_range = true

func _on_scroll_area_body_exited(body: Node2D) -> void:
	if body is Player:
		scroll_hint.visible = false
		in_scroll_range = false
		scroll.visible = false

		if NavigationManager.player != null:
			NavigationManager.player.can_move = true
