extends Node

#track completed rooms
#[right chest, middle chest]
var dungeon_tracker : Array[bool] = [false, false]
var wine_cellar_complete : bool = false
var wine_cellar_item_collected : bool = false
var armory_complete : bool = false
var armory_item_collected : bool = false
var library_complete = false
var library_item_collected = false
var theater_complete = false
var theater_item_collected = false
var return_from_mirror = false


#0 pieces collected
var key_tracker = 0
