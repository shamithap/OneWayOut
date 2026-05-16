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
	
@onready var middle_door_sprite : AnimatedSprite2D = $UnlockableDoors/NorthDoor/NorthDoorSprite
@onready var middle_door_collision : CollisionShape2D = $UnlockableDoors/NorthDoor/NorthDoorCollision
@onready var middle_chest_sprite : AnimatedSprite2D = $Chests/MiddleChest/Sprite2D

@onready var right_door_collision : CollisionShape2D = $UnlockableDoors/ChestDoor/ChestDoorCollision
@onready var right_door_sprite : AnimatedSprite2D = $UnlockableDoors/ChestDoor/ChestDoorSprite
@onready var right_chest_sprite : AnimatedSprite2D = $Chests/RightChest/Sprite2D

var levers_active : Array[bool] = [false, false, false]
var middle_door_lever_combo : Array[bool] = [true, false, false]
var right_door_lever_combo : Array[bool] = [false, true, true]

var player : Player = null
var player_in_range : bool = false
var lever_player_in_range_of : int

func _ready():
	ensure_player()
	if Global.dungeon_tracker[0]:
		right_door_finished()
	if Global.dungeon_tracker[1]:
		middle_door_finished()
		
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
		hint.visible = true
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
		hint.visible = false

func switch_lever(lever : int):
	levers_active[lever] = !levers_active[lever]
	lever_sprites[lever].flip_h = !lever_sprites[lever].flip_h

func check_levers():
	if levers_active == right_door_lever_combo and not Global.dungeon_tracker[0]:
		right_door_sprite.animation = "opening"
		right_chest_sprite.animation = "opening"
		right_door_collision.disabled = true
		Global.dungeon_tracker[0] = true
		
	if levers_active == middle_door_lever_combo and not Global.dungeon_tracker[1]:
		middle_door_sprite.animation = "opening"
		middle_chest_sprite.animation = "opening"
		middle_door_collision.disabled = true
		Global.dungeon_tracker[1] = true
		

#index : 0
func right_door_finished():
	right_door_sprite.animation = "open"
	right_chest_sprite.animation = "open"
	right_door_collision.disabled = true
	
#index : 1
func middle_door_finished():
	middle_door_sprite.animation = "open"
	middle_chest_sprite.animation = "open"
	middle_door_collision.disabled = true
