extends Node

const scene_main = preload("res://scenes/rooms/main.tscn")
const scene_room1 = preload("res://scenes/rooms/room1.tscn")
const scene_room3 = preload("res://scenes/rooms/room3.tscn")

signal on_trigger_player_spawn

var spawn_door_tag
var scene_to_load

var player : Player = null

#input the room that you want to go to and the tag of the 
#door the player should be spawning at
func go_to_level(destination_room_name, destination_door_tag):
	match destination_room_name:
		"main":
			scene_to_load = scene_main
		"room1":
			scene_to_load = scene_room1
		"room3":
			scene_to_load = scene_room3
	
	if scene_to_load != null:
		spawn_door_tag = destination_door_tag
		get_tree().change_scene_to_packed(scene_to_load)

#sends signal to player to spawn at given position w/ given direction
func trigger_player_spawn(position : Vector2, direction : String):
	on_trigger_player_spawn.emit(position, direction)
