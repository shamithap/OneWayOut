extends Node2D

@onready var hint_label = $Hint
@onready var puzzle_panel = $PuzzlePanel
@onready var hour_input = $PuzzlePanel/HourInput
@onready var minute_input = $PuzzlePanel/MinuteInput
@onready var check_button = $PuzzlePanel/CheckButton
@onready var result_label = $PuzzlePanel/ResultLabel
@onready var tick_sound = $TickSound
@onready var chime_sound = $ChimeSound

var player_near = false
var puzzle_solved = false

func _ready():
	hint_label.visible = false
	puzzle_panel.visible = false
	result_label.text = ""
	
	#make sure both sounds are stopped when the scene starts
	tick_sound.stop()
	chime_sound.stop()

	check_button.pressed.connect(_on_check_button_pressed)

func _process(_delta):
	if player_near and Input.is_action_just_pressed("interact"):
		if not puzzle_solved:
			puzzle_panel.visible = true
			hint_label.visible = false
		else:
			puzzle_panel.visible = false

func _on_interact_area_body_entered(body):
	if body is Player:
		player_near = true
		if not puzzle_solved:
			hint_label.visible = true
			
			#play ticking sound when player gets close to the clock
			# The "if not playing" check prevents the sound from restarting repeatedly
			if not tick_sound.playing:
				tick_sound.play()

func _on_interact_area_body_exited(body):
	if body is Player:
		player_near = false
		hint_label.visible = false
		# stop ticking sound when player leaves the clock area
		if tick_sound.playing:
			tick_sound.stop()

func _on_check_button_pressed():
	var hour = hour_input.text.strip_edges()
	var minute = minute_input.text.strip_edges()

	if hour == "6" and minute == "00":
		puzzle_solved = true
		
		hour_input.visible = false
		minute_input.visible = false
		check_button.visible = false
		hint_label.visible = false
		
		#stop ticking sound when the puzzle is solved
		if tick_sound.playing:
			tick_sound.stop()
		
		#play chime sound as a success sound
		chime_sound.play()
		
		result_label.text = "Correct! \nA hidden note:\n\"Dinner is waiting in the Dining Room.\"\nPress E to close."
	else:
		result_label.text = "That time does not seem right. Try again."
