extends Node

@onready var item_dict := {
	"KeyPiece1" : preload("res://scenes/items/key_piece_1.tscn"),
	"KeyPiece2" : preload("res://scenes/items/key_piece_2.tscn"),
	"KeyPiece3" : preload("res://scenes/items/key_piece_3.tscn"),
	"Compass" : preload("res://scenes/items/compass.tscn"),
	"Hourglass" : preload("res://scenes/items/hourglass.tscn"),
	"HealthVial": preload("res://scenes/items/health_vial.tscn")
}

@onready var pickup_dialogue := {
	"KeyPiece1" : "You picked up a key piece",
	"KeyPiece2" : "You picked up a key piece",
	"KeyPiece3" : "You picked up a key piece",
	"Compass" : "You picked up a compass! You'll be able to see where the ghost is on the minimap for the next 4 minutes.",
	"Hourglass" : "You picked up an hourglass! The ghost will approach you slower for 2 minutes.",
	"HealthVial": "You picked up a health vial. One heart restored"
}

@onready var inventory = []
@onready var label : Label = $CanvasLayer/Label
@onready var timer : Timer = $Timer
@onready var sound : AudioStreamPlayer2D = $AudioStreamPlayer2D
var reward_count = 0

func get_item(position : Vector2):
	reward_count += 1
	var possible_items = item_dict.keys()
	
	#chooses a random item but if we're at 3 hearts, then you can't get a vial
	if Global.player_health >= Global.max_health:
		possible_items.erase("HealthVial")
		
	var key_items = []
	#removes keys from item pool since they should be unique
	for item in possible_items:
		if item == "KeyPiece1" or item == "KeyPiece2" or item == "KeyPiece3":
			key_items.append(item)
			
	var random_item
	#the first reward and every other reward after that guarantees a key
	if reward_count % 2 == 1 and key_items.size() > 0:
		random_item = key_items.pick_random()
	else:
		random_item = possible_items.pick_random()
		
	var item_instance = item_dict[random_item].instantiate()
	get_parent().add_child(item_instance)
	item_instance.global_position = position

	if random_item == "KeyPiece1" or random_item == "KeyPiece2" or random_item == "KeyPiece3":
		item_dict.erase(random_item)

func pickup_item(item):
	inventory.append(item)
	print(inventory)
	
	#shows key piece on overlay
	if item == "KeyPiece1" or item == "KeyPiece2" or item == "KeyPiece3":
		Overlay.get_node("CanvasLayer/KeyOverlay").unlock_key(item)
	if item == "HealthVial":
		var health_bar = get_tree().root.get_node("Overlay/CanvasLayer/HealthBar")
		health_bar.heal_health()
		
	sound.play()
	label.text = pickup_dialogue[item]
	timer.start()
	await timer.timeout
	label.text = ""
