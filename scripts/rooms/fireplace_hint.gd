extends Sprite2D

@onready var hint_label = $Hint
@onready var note_panel = $NotePanel
@onready var clue_label = $NotePanel/ClueLabel

var player_in_range = false
var note_open = false

func _ready():
	hint_label.visible = false
	note_panel.visible = false
	clue_label.text = "The fireplace went dark at 7:30."

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		note_open = !note_open
		note_panel.visible = note_open
		
		if note_open:
			hint_label.visible = false
		else:
			hint_label.visible = true

func _on_interact_area_body_entered(body):
	if body is Player:
		player_in_range = true
		if not note_open:
			hint_label.visible = true

func _on_interact_area_body_exited(body):
	if body is Player:
		player_in_range = false
		hint_label.visible = false
		note_panel.visible = false
		note_open = false
