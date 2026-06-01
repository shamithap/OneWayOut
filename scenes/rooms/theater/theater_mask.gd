extends Node2D

@onready var sprite := $mask
@onready var mask_switch_sound = $"../MaskSwitchSound"

@onready var hint := $Hint
@export var correct_index : int = 0

var player_in_range = false


var mask_textures = [
	preload("res://scenes/rooms/theater/minigame_masks/mask_01.png"),
	preload("res://scenes/rooms/theater/minigame_masks/mask_07.png"),
	preload("res://scenes/rooms/theater/minigame_masks/mask_08.png"),
	preload("res://scenes/rooms/theater/minigame_masks/mask_23.png"),
	preload("res://scenes/rooms/theater/minigame_masks/mask_24.png")
]

var current_index = 0

func _ready():
	hint.visible = false

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		current_index += 1
		
		if current_index >= mask_textures.size():
			current_index = 0

		if mask_switch_sound:
			mask_switch_sound.play()
		
		sprite.texture = mask_textures[current_index]
		get_parent().check_win()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		hint.visible = true
		player_in_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		hint.visible = false
		player_in_range = false

func is_correct() -> bool:
	return current_index == correct_index
