extends Node2D

@onready var dust_group = $DustGroup
@onready var instruction = $CanvasLayer/Instructions

var dust_left = 0

func _ready():
	dust_left = dust_group.get_child_count()

	for dust in dust_group.get_children():
		dust.dust_cleaned.connect(_on_dust_cleaned)

func _on_dust_cleaned():
	dust_left -= 1

	if dust_left == 0:
		win()

func win():
	instruction.text = "You cleaned the library!"
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/rooms/library/library.tscn")
