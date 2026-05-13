extends Node2D

@onready var hint_label = $Hint
@onready var puzzle_panel = $PuzzlePanel
@onready var hour_input = $PuzzlePanel/HourInput
@onready var minute_input = $PuzzlePanel/MinuteInput
@onready var check_button = $PuzzlePanel/CheckButton
@onready var result_label = $PuzzlePanel/ResultLabel

var player_near = false
var puzzle_solved = false

func _ready():
	hint_label.visible = false
	puzzle_panel.visible = false
	result_label.text = ""

	check_button.pressed.connect(_on_check_button_pressed)

func _process(_delta):
	if player_near and Input.is_action_just_pressed("interact") and not puzzle_solved:
		puzzle_panel.visible = true
		hint_label.visible = false

func _on_interact_area_body_entered(body):
	if body is Player:
		player_near = true
		if not puzzle_solved:
			hint_label.visible = true

func _on_interact_area_body_exited(body):
	if body is Player:
		player_near = false
		hint_label.visible = false

func _on_check_button_pressed():
	var hour = hour_input.text.strip_edges()
	var minute = minute_input.text.strip_edges()

	if hour == "6" and minute == "00":
		puzzle_solved = true
		result_label.text = "Correct! The clock reveals a hidden clue."
		hint_label.visible = false
	else:
		result_label.text = "That time does not seem right. Try again."
