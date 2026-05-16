extends Node2D

@onready var player_packed_scene = preload("res://scenes/player.tscn")
@onready var scroll_hint := $CanvasLayer/ScrollHint
@onready var table_hint := $CanvasLayer/TableHint
@onready var scroll := $CanvasLayer/Scroll
@onready var chest := $Environment/Objects/Chest
@onready var wrong_table := $Environment/Objects/WrongTable
@onready var correct_table := $Environment/Objects/CorrectTable

var player : Player = null
var in_scroll_range : bool = false
var scroll_active : bool = false
var in_table_range : bool = false

func _ready():
	ensure_player()
	if Global.wine_cellar_complete:
		won()
	
func _process(_delta: float) -> void:
	if in_scroll_range and Input.is_action_just_pressed("interact") and not Global.wine_cellar_complete:
		scroll.visible = !scroll_active
		scroll_active = !scroll_active
	
	if in_table_range and Input.is_action_just_pressed("interact") and not Global.wine_cellar_complete:
		get_tree().change_scene_to_file("res://scenes/rooms/winecellar/wine_cellar_minigame.tscn")

func ensure_player():
	if NavigationManager.player != null:
		add_child(NavigationManager.player)
	else :
		player = player_packed_scene.instantiate()
		NavigationManager.player = player
		add_child(player)
	
	if NavigationManager.spawn_door_tag != null :
		_on_level_spawn(NavigationManager.spawn_door_tag)

func _on_level_spawn(destination_tag : String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)

func just_won():
	chest.animation = "opening"

func won():
	chest.animation = "open"
	wrong_table.visible = false
	correct_table.visible = true

func _on_scroll_area_body_entered(body: Node2D) -> void:
	if body is Player and not Global.wine_cellar_complete:
		scroll_hint.visible = true
		in_scroll_range = true

func _on_scroll_area_body_exited(body: Node2D) -> void:
	if body is Player:
		scroll_hint.visible = false
		in_scroll_range = false

func _on_table_area_body_entered(body: Node2D) -> void:
	if body is Player and not Global.wine_cellar_complete:
		table_hint.visible = true
		in_table_range = true

func _on_table_area_body_exited(body: Node2D) -> void:
	if body is Player:
		table_hint.visible = false
		in_table_range = false
