extends Node2D

@onready var player_packed_scene = preload("res://scenes/player.tscn")
@onready var hint := $CanvasLayer/Hint

@onready var levers : Array[StaticBody2D] = [
	$Levers/Lever1, 
	$Levers/Lever2, 
	$Levers/Lever3]
	
@onready var lever_sprites : Array[Sprite2D] = [
	$Levers/Lever1/LeverSprite, 
	$Levers/Lever2/LeverSprite,  
	$Levers/Lever3/LeverSprite]

@onready var lever_interact_areas : Array[Area2D] = [
	$Levers/Lever1/Interact1,
	$Levers/Lever2/Interact2,
	$Levers/Lever3/Interact3]
	
@onready var north_door_sprite : AnimatedSprite2D = $UnlockableDoors/NorthDoor/NorthDoorSprite
@onready var north_door_collision : CollisionShape2D = $UnlockableDoors/NorthDoor/NorthDoorCollision
@onready var chest_door_collision : CollisionShape2D = $UnlockableDoors/ChestDoor/ChestDoorCollision
@onready var chest_door_sprite : AnimatedSprite2D = $UnlockableDoors/ChestDoor/ChestDoorSprite

var levers_active : Array[bool] = [false, false, false]
var north_door_lever_combo : Array[bool] = [true, false, false]
var chest_door_lever_combo : Array[bool] = [false, true, true]

var player : Player = null
var player_in_range : bool = false
var lever_player_in_range_of : int

func _ready():
	ensure_player()
	if Global.dungeon_tracker[0]:
		chest_door_finished()
	if Global.dungeon_tracker[1]:
		north_door_finished()
		
	for i in range(lever_interact_areas.size()):
		lever_interact_areas[i].body_entered.connect(_on_area_body_entered.bind(lever_interact_areas[i]))
		

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		switch_lever(lever_player_in_range_of)
		check_levers()

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

func _on_area_body_entered(body: Node2D, area_node: Area2D):
	if body is Player:
		player_in_range = true
		match area_node.name:
			"Interact1":
				lever_player_in_range_of = 0
			"Interact2":
				lever_player_in_range_of = 1
			"Interact3":
				lever_player_in_range_of = 2

func _on_interact_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false

func switch_lever(lever : int):
	levers_active[lever] = !levers_active[lever]
	lever_sprites[lever].flip_h = !lever_sprites[lever].flip_h

func check_levers():
	if levers_active == chest_door_lever_combo:
		chest_door_sprite.animation = "opening"
		chest_door_collision.disabled = true
		Global.dungeon_tracker[0] = true
		
	if levers_active == north_door_lever_combo:
		north_door_sprite.animation = "opening"
		north_door_collision.disabled = true
		Global.dungeon_tracker[1] = true
		

#index : 0
func chest_door_finished():
	chest_door_sprite.animation = "open"
	chest_door_collision.disabled = true
	
#index : 1
func north_door_finished():
	north_door_sprite.animation = "open"
	north_door_collision.disabled = true
