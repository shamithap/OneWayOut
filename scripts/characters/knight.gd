extends StaticBody2D

@onready var hint : Label = $Bubbles/ChatBubble/Label
@onready var chat_bubble:= $Bubbles/ChatBubble
@onready var indicator_bubble := $Bubbles/IndicatorBubble
var player_in_range : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body is Player:
		switch_bubbles(true)
		hint.visible = true
		player_in_range = true
		hint.text = "Hey! Get out!!!"

func _on_trigger_area_body_exited(body: Node2D) -> void:
	if body is Player:
		switch_bubbles(false)
		hint.visible = false
		player_in_range = false

func switch_bubbles(bubble_visibility : bool) -> void:
	chat_bubble.visible = bubble_visibility
	indicator_bubble.visible = !bubble_visibility
