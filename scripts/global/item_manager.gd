extends Node

@onready var item_dict := {
	"KeyPiece1" : preload("res://scenes/items/key_piece_1.tscn"),
	"KeyPiece2" : preload("res://scenes/items/key_piece_2.tscn"),
	"KeyPiece3" : preload("res://scenes/items/key_piece_3.tscn")
}

@onready var pickup_dialogue := {
	"KeyPiece1" : "You picked up a key piece",
	"KeyPiece2" : "You picked up a key piece",
	"KeyPiece3" : "You picked up a key piece",
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
	
	#removes keys from item pool since they should be unique
	if random_item == "KeyPiece1" or random_item == "KeyPiece2" or random_item == "KeyPiece3":
		item_dict.erase(random_item)

func pickup_item(item):
	inventory.append(item)
	print(inventory)
	
	#shows key piece on overlay
	if item == "KeyPiece1" or item == "KeyPiece2" or item == "KeyPiece3":
		Overlay.get_node("CanvasLayer/KeyOverlay").unlock_key(item)
		
	sound.play()
	label.text = pickup_dialogue[item]
	timer.start()
	await timer.timeout
	label.text = ""
