extends Room

class_name Library

@onready var scroll := $CanvasLayer/Scroll
@onready var scroll_hint := $CanvasLayer/ScrollHint
@onready var scroll_sound := $ScrollArea/AudioStreamPlayer2D

var in_scroll_range = false

func _ready():
	super._ready()
	scroll.visible = false
	scroll_hint.visible = false

func _process(_delta):
	if in_scroll_range and Input.is_action_just_pressed("interact"):
		scroll.visible = !scroll.visible
		
		if player != null:
			player.can_move = !scroll.visible
		
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
		
		if player != null:
			player.can_move = true
