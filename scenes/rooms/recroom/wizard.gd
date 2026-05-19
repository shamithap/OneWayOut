extends StaticBody2D

@onready var hint = get_node("../CanvasLayer/Hint")
@onready var chat_bubble:= $Bubbles/ChatBubble
@onready var indicator_bubble := $Bubbles/IndicatorBubble
var player_in_range : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Wizard path:", get_path())
	print("Parent:", get_parent())
	print("Found hint:", get_node_or_null("../CanvasLayer/Hint"))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/rooms/recroom/guess_popup.tscn")

func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body is Player:
		switch_bubbles(true)
		hint.visible = true
		player_in_range = true
		hint.text = "Press E to play"

func _on_trigger_area_body_exited(body: Node2D) -> void:
	if body is Player:
		switch_bubbles(false)
		hint.visible = false
		player_in_range = false

func switch_bubbles(bubble_visibility : bool) -> void:
	chat_bubble.visible = bubble_visibility
	indicator_bubble.visible = !bubble_visibility
