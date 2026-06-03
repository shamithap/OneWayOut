extends Node

@onready var music: AudioStreamPlayer = $AudioStreamPlayer

var normal_volume = -12

func _ready():
	music.finished.connect(_on_music_finished)
	play_music()

func play_music():
	music.volume_db = normal_volume
	music.play()

func _on_music_finished():
	music.play()

#added a tween to try to make the end less choppy
func fade_out_music():
	var tween = create_tween()
	tween.tween_property(music, "volume_db", -40, 2.0)

	await tween.finished
	music.stop()
