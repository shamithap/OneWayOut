extends "res://scripts/rooms/room.gd"

@onready var scroll_hint = $CanvasLayer/ScrollHint
@onready var scroll_sound = $ScrollArea/AudioStreamPlayer2D
@onready var scroll = $CanvasLayer/Scroll

@onready var dance_hint = get_node_or_null("DanceArea/DanceHint")
@onready var step_sound = get_node_or_null("StepSound")
@onready var wrong_sound = get_node_or_null("WrongSound")
@onready var success_sound = get_node_or_null("SuccessSound")

var in_dance_range : bool = false
var dance_active : bool = false
var dance_solved : bool = false

var correct_steps = ["ui_left", "ui_right", "ui_left", "ui_down"]
var current_step_index = 0
var in_scroll_range : bool = false

func _ready():
	super._ready()
	scroll_hint.visible = false
	scroll.visible = false

	if dance_hint != null:
		dance_hint.visible = false

func _process(_delta: float) -> void:
	if in_scroll_range and Input.is_action_just_pressed("interact"):
		scroll.visible = !scroll.visible

		if NavigationManager.player != null:
			NavigationManager.player.can_move = !NavigationManager.player.can_move

		scroll_sound.play()
		return

	if scroll != null and scroll.visible:
		return

	if in_dance_range and Input.is_action_just_pressed("interact") and not dance_solved:
		if dance_active:
			cancel_dance()
		else:
			start_dance()
		return

	if dance_active:
		check_dance_step("ui_left")
		check_dance_step("ui_right")
		check_dance_step("ui_up")
		check_dance_step("ui_down")

func _on_scroll_area_body_entered(body: Node2D) -> void:
	if body is Player:
		scroll_hint.visible = true
		in_scroll_range = true

func _on_scroll_area_body_exited(body: Node2D) -> void:
	if body is Player:
		scroll_hint.visible = false
		in_scroll_range = false
		scroll.visible = false

		if NavigationManager.player != null:
			NavigationManager.player.can_move = true
			
func start_dance():
	dance_active = true
	current_step_index = 0

	if NavigationManager.player != null:
		NavigationManager.player.can_move = false

	if dance_hint != null:
		dance_hint.visible = true
		dance_hint.text = "Follow the rhythm: ← → ← ↓"


func cancel_dance():
	dance_active = false
	current_step_index = 0

	if NavigationManager.player != null:
		NavigationManager.player.can_move = true

	if dance_hint != null and not dance_solved:
		dance_hint.text = "Press E to start the dance"


func check_dance_step(action_name):
	if Input.is_action_just_pressed(action_name):
		if action_name == correct_steps[current_step_index]:
			current_step_index += 1

			if step_sound != null:
				step_sound.play()

			if dance_hint != null:
				dance_hint.text = "Good! Step " + str(current_step_index) + " / " + str(correct_steps.size())

			if current_step_index == correct_steps.size():
				solve_dance()
		else:
			current_step_index = 0

			if wrong_sound != null:
				wrong_sound.play()

			if dance_hint != null:
				dance_hint.text = "Wrong step. Try again: ← → ← ↓"


func solve_dance():
	dance_solved = true
	dance_active = false

	if NavigationManager.player != null:
		NavigationManager.player.can_move = true

	if success_sound != null:
		success_sound.play()

	if dance_hint != null:
		dance_hint.visible = true
		dance_hint.text = "Perfect dance!"

	print("Ballroom dance puzzle solved!")


func _on_dance_area_body_entered(body: Node2D) -> void:
	if body is Player and not dance_solved:
		in_dance_range = true

		if dance_hint != null:
			dance_hint.visible = true
			dance_hint.text = "Press E to start the dance"


func _on_dance_area_body_exited(body: Node2D) -> void:
	if body is Player:
		in_dance_range = false
		dance_active = false
		current_step_index = 0

		if NavigationManager.player != null:
			NavigationManager.player.can_move = true

		if dance_hint != null and not dance_solved:
			dance_hint.visible = false
