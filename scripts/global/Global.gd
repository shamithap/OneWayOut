extends Node

#track completed rooms
var dungeon_tracker : Array[bool] = [false, false] #[right chest, middle chest]
var wine_cellar_complete : bool = false
var wine_cellar_item_collected : bool = false
var armory_complete : bool = false
var armory_item_collected : bool = false
var library_complete = false
var library_item_collected = false
var theater_complete = false
var theater_item_collected = false
var return_from_mirror = false
var theater_mask_states = [-1, -1, -1, -1, -1]
var ballroom_item_collected = false
var ballroom_complete = false
var diningroom_item_collected = false
var diningroom_complete = false

var recroom_complete = false
var player_health = 3
var max_health = 3

var in_dialogue = false

#0 pieces collected
var key_tracker = 0

func reset_game() -> void:
	player_health = 3
	Overlay.get_node("CanvasLayer/HealthBar").restore_health()
	ItemManager.reset_inventory()
