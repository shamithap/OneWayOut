extends Node

#keeps track of player room position in building
#starts at (-1, -1) for foyer
var player_position : Vector2i = Vector2i(-1, -1)

#index = y * width + x
var explored_rooms : Array[String]
var height : int = 3
var width : int = 4

func _ready():
	#initalize rooms array
	explored_rooms.resize (height * width)
	explored_rooms.fill("")
