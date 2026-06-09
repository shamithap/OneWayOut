extends Control

@onready var key_pieces = {
	"KeyPiece1" : $KeyPiece1,
	"KeyPiece2" : $KeyPiece2,
	"KeyPiece3" : $KeyPiece3,
}

func _ready() -> void:
	self.visible = false
	Global.restart_game_signal.connect(reset_key)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("overlay"):
		self.visible = !self.visible

func unlock_key(piece : String):
	key_pieces[piece].visible = true
	Global.key_tracker += 1

func reset_key():
	for key in key_pieces.values():
		key.visible = false
