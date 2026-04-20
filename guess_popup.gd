extends Control

var target_number := 0

@onready var input := $Panel/LineEdit
@onready var feedback := $Panel/Feedback

func _ready():
	randomize()
	target_number = randi_range(1, 100)

	feedback.text = "Guess a number (1–100)"

	# This enables Enter key submission
	input.text_submitted.connect(_on_text_submitted)

	# optional: auto focus so player can type immediately
	input.grab_focus()


func _on_text_submitted(text: String) -> void:
	if text.strip_edges() == "":
		feedback.text = "Type a number!"
		return

	if not text.is_valid_int():
		feedback.text = "Please enter a valid number!"
		return

	var guess = text.to_int()

	if guess < target_number:
		feedback.text = "Too low!"
	elif guess > target_number:
		feedback.text = "Too high!"
	else:
		feedback.text = "Correct!"
		# reset game
		target_number = randi_range(1, 100)
		feedback.text += " New number generated!"
