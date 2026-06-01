extends Node2D

@onready var player_packed_scene = preload("res://scenes/player.tscn")
@onready var spawn_point := $SpawnPoint
@onready var mirror_glow := $CanvasLayer/MirrorGlow
@onready var win_panel := $CanvasLayer/Control/WinPanel
@onready var animation_player := $CanvasLayer/MirrorGlow/AnimationPlayer
var player : Player = null
@onready var mirror_exit_hint := $MirrorExitArea/MirrorHint
@onready var mirror_sound = $MirrorSound
@onready var mirror_crack_sound = $MirrorCrackSound

var in_mirror_exit_range = false

@onready var masks := [
	$Mask1,
	$Mask2,
	$Mask3,
	$Mask4,
	$Mask5
]

func _ready():
	ensure_player()
	win_panel.visible = false
	mirror_exit_hint.visible = false
	if mirror_sound:
		mirror_sound.play()
	print("Playing mirror glow animation")
	pulse_glow()
	
func _process(_delta):
	if in_mirror_exit_range and Input.is_action_just_pressed("interact"):
		#NavigationManager.spawn_door_tag = "MirrorReturn"
		get_tree().change_scene_to_file("res://scenes/rooms/theater/theater.tscn")
	
func pulse_glow():
	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(mirror_glow, "modulate:a", 0.8, 0.5)
	tween.tween_property(mirror_glow, "modulate:a", 0.05, 0.5)

func ensure_player():
	if NavigationManager.player != null:
		add_child(NavigationManager.player)
		player = NavigationManager.player
	else:
		player = player_packed_scene.instantiate()
		NavigationManager.player = player
		add_child(player)

	player.global_position = spawn_point.global_position
	
func check_win():
	for mask in masks:
		if not mask.is_correct():
			return
	
	Global.theater_complete = true
	player.can_move = false
	if mirror_crack_sound:
		mirror_crack_sound.play()
	
	await get_tree().create_timer(1.5).timeout
	
	win_panel.visible = true
	
func _on_mirror_exit_area_body_entered(body: Node2D) -> void:
	if body is Player:
		mirror_exit_hint.visible = true
		in_mirror_exit_range = true

func _on_mirror_exit_area_body_exited(body: Node2D) -> void:
	if body is Player:
		mirror_exit_hint.visible = false
		in_mirror_exit_range = false


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/rooms/theater/theater.tscn")
