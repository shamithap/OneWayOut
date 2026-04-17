extends Node2D


@onready var player : PackedScene = preload("res://scenes/player.tscn")
@onready var spawn_marker : Marker2D = $SpawnPoint

func on_ready():
	player.position = spawn_marker
