extends Control

var target_number := 0

@onready var input: LineEdit = $Panel/LineEdit
@onready var feedback: Label = $Panel/Feedback

func _ready() -> void:
	# Debugging: make sure nodes were found
	print("Input:", input)
	print("Feedback:", feedback)

	# Generate random number
	target_number = randi_range(1, 100)

	# Starting message
	feedback.text = "Guess a number (1–100)"

	# Connect Enter key submission
	input.text_submitted.connect(_on_text_submitted)

	# Automatically focus textbox
	input.grab_focus()


func _on_text_submitted(text: String) -> void:
	text = text.strip_edges()

	if text == "":
		feedback.text = "Type a number!"
		return

	if not text.is_valid_int():
		feedback.text = "Please enter a valid number!"
		return

	var guess := text.to_int()

	if guess < target_number:
		feedback.text = "Too low!"
	elif guess > target_number:
		feedback.text = "Too high!"
	else:
		feedback.text = "Correct! New number generated!"
		target_number = randi_range(1, 100)

	# Clear input box after submission
	input.clear()

	# Refocus for next guess
	input.grab_focus()
