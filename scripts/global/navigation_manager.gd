extends Node

const scene_dict = {
	"main" : preload("res://scenes/rooms/main.tscn"),
	"library": preload("res://scenes/rooms/library/library.tscn"),
	"armory" : preload("res://scenes/rooms/armory/armory.tscn"),
	"livingroom" : preload("res://scenes/rooms/livingroom/livingroom.tscn"),
	"dungeon" : preload("res://scenes/rooms/dungeon.tscn"),
	"theater": preload("res://scenes/rooms/theater.tscn"),
	"winecellar": preload("res://scenes/rooms/winecellar/winecellar.tscn")
}

signal on_trigger_player_spawn
signal update_minimap_position

var spawn_door_tag
var scene_to_load

var player : Player = null

#input the room that you want to go to and the tag of the 
#door the player should be spawning at
func go_to_level(destination_room_name, destination_door_tag):
	scene_to_load = scene_dict[destination_room_name]
	
	if scene_to_load != null:
		spawn_door_tag = destination_door_tag
		update_minimap_position.emit(destination_room_name)
		get_tree().change_scene_to_packed(scene_to_load)

#sends signal to player to spawn at given position w/ given direction
func trigger_player_spawn(position : Vector2, direction : String):
	on_trigger_player_spawn.emit(position, direction)
