extends "res://scripts/rooms/room.gd"

@onready var dining_hint = get_node_or_null("CanvasLayer/DiningHint")
@onready var puzzle_panel = get_node_or_null("CanvasLayer/DinnerPuzzlePanel")
@onready var result_label = get_node_or_null("CanvasLayer/DinnerPuzzlePanel/ResultLabel")
@onready var wrong_answer_sound = get_node_or_null("WrongAnswerSound")
@onready var correct_answer_sound = get_node_or_null("CorrectAnswerSound")

var in_table_range : bool = false
var dinner_puzzle_solved : bool = false

func _ready():
	super._ready()

	if dining_hint != null:
		dining_hint.visible = false

	if puzzle_panel != null:
		puzzle_panel.visible = false

func _process(_delta: float) -> void:
	if in_table_range and Input.is_action_just_pressed("interact") and not dinner_puzzle_solved:
		open_dinner_puzzle()

func open_dinner_puzzle():
	if puzzle_panel != null:
		puzzle_panel.visible = true

	if dining_hint != null:
		dining_hint.visible = false

	if NavigationManager.player != null:
		NavigationManager.player.can_move = false

	if result_label != null:
		result_label.text = ""

func close_dinner_puzzle():
	if puzzle_panel != null:
		puzzle_panel.visible = false

	if NavigationManager.player != null:
		NavigationManager.player.can_move = true

	if dining_hint != null and in_table_range and not dinner_puzzle_solved:
		dining_hint.visible = true

func choose_wrong_answer():
	if wrong_answer_sound != null:
		wrong_answer_sound.play()

	if result_label != null:
		result_label.text = "That belongs to the living..."

func choose_correct_answer():
	dinner_puzzle_solved = true
	
	if correct_answer_sound != null:
		correct_answer_sound.play()

	if result_label != null:
		result_label.text = "Correct! Dinner was never meant to be eaten."

	if NavigationManager.player != null:
		NavigationManager.player.can_move = true

	print("Dining room puzzle solved!")

func _on_table_area_body_entered(body: Node2D) -> void:
	if body is Player and not dinner_puzzle_solved:
		in_table_range = true

		if dining_hint != null:
			dining_hint.visible = true
			dining_hint.text = "Press E to inspect the dinner"

func _on_table_area_body_exited(body: Node2D) -> void:
	if body is Player:
		in_table_range = false

		if dining_hint != null:
			dining_hint.visible = false

		if puzzle_panel != null:
			puzzle_panel.visible = false

		if NavigationManager.player != null:
			NavigationManager.player.can_move = true
	
func _on_bread_button_pressed() -> void:
	choose_wrong_answer()

func _on_wine_button_pressed() -> void:
	choose_wrong_answer()

func _on_empty_plate_button_pressed() -> void:
	choose_correct_answer()
