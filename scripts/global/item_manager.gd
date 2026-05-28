extends Node

@onready var item_dict := {
	"KeyPiece1" : preload("res://scenes/items/key_piece_1.tscn"),
	"KeyPiece2" : preload("res://scenes/items/key_piece_2.tscn"),
	"KeyPiece3" : preload("res://scenes/items/key_piece_3.tscn")
}

@onready var inventory = []
@onready var label : Label = $CanvasLayer/Label
@onready var timer : Timer = $Timer
@onready var sound : AudioStreamPlayer2D = $AudioStreamPlayer2D

func get_item(position : Vector2):
	var random_item = item_dict.keys().pick_random()
	var item_instance = item_dict[random_item].instantiate()
	get_parent().add_child(item_instance)
	item_instance.global_position = position

func pickup_item(item):
	inventory.append(item)
	sound.play()
	label.text = "You picked up a " + item
	timer.start()
	await timer.timeout
	label.text = ""
