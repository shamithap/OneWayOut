extends Node

#track completed rooms
#[right chest, middle chest]
var dungeon_tracker : Array[bool] = [false, false]
var wine_cellar_complete : bool = false
var wine_cellar_item_collected : bool = false
var armory_complete : bool = false
var armory_item_collected : bool = false

#0 pieces collected
var key_tracker = 0
