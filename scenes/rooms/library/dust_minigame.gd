extends Node2D

@onready var dust_group = $DustGroup
@onready var instruction = $CanvasLayer/Instructions
@onready var win_panel = $CanvasLayer/Control/WinPanel
@onready var clean_sound = $CleanSound

var dust_left = 0

func _ready():
	win_panel.visible = false
	
	dust_left = dust_group.get_child_count()

	for dust in dust_group.get_children():
		dust.dust_cleaned.connect(_on_dust_cleaned)

func _on_dust_cleaned():
	dust_left -= 1

	if dust_left == 0:
		win()

func win():
	instruction.visible = false
	await get_tree().create_timer(1).timeout
	win_panel.visible = true
	Global.library_complete = true

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/rooms/library/library.tscn")
	
func play_clean_sound():
	if clean_sound:
		clean_sound.play()
