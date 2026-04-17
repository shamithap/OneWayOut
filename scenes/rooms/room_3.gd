extends Node2D


@onready var player := $Player
@onready var spawn_marker : Marker2D = $SpawnPoint

func _ready():
	player.global_position = spawn_marker.global_position
