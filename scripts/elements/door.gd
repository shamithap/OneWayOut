extends Node2D

class_name Door

@onready var hint : Label = $CanvasLayer/Hint
@onready var spawn : Marker2D = $Spawn

#room that the door will take you to
@export var destination_room_name : String
#the spawn point within the destination room
@export var destination_door_tag : String 
#the direction the character should be facing at this door
@export var spawn_direction : String

#helps keep track when player is nearby
var player_in_range = false 


func _on_door_body_entered(body: Node2D) -> void:
	if body is Player:
		hint.visible = true
		player_in_range = true 

func _on_door_body_exited(body: Node2D) -> void:
	if body is Player:
		hint.visible = false
		player_in_range = false

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		NavigationManager.go_to_level(destination_room_name, destination_door_tag)
