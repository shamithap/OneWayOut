extends CharacterBody2D

class_name Player

@export var speed := 120.0
@onready var anim = $AnimatedSprite2D
@onready var animation_player := $FadeOut/AnimationPlayer
@onready var fade_out := $FadeOut/FadeOut
@onready var gameover_audio := $Sounds/GameOver
@onready var footsteps_audio := $Sounds/Footsteps
@onready var footstep_timer := $FootstepTimer

var lose_animation_playing = false
var last_direction = "down"
var can_move : bool = true

func _ready():
	NavigationManager.on_trigger_player_spawn.connect(_on_spawn)
	Overlay.get_node("CanvasLayer/HealthBar").player_died.connect(player_lost)


func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if can_move and not lose_animation_playing and not Global.in_dialogue:
		velocity = direction * speed
		move_and_slide()

		if direction != Vector2.ZERO:
			if abs(direction.x) > abs(direction.y):
				if direction.x > 0:
					last_direction = "right"
				else:
					last_direction = "left"
			else:
				if direction.y > 0:
					last_direction = "down"
				else:
					last_direction = "up"

			anim.play("walk_" + last_direction)
			if not footsteps_audio.playing and footstep_timer.is_stopped():
				footsteps_audio.play()
				footstep_timer.start()
		else:
			anim.play("idle_" + last_direction)
			if footsteps_audio.playing:
				footsteps_audio.stop()
			

#is triggered from navigation manager
func _on_spawn(spawn_position : Vector2, direction : String):
	global_position = spawn_position
	velocity = Vector2.ZERO
	last_direction = direction
	anim.play("walk_" + direction)

func player_lost() -> void:
	gameover_audio.play()
	
	lose_animation_playing = true
	anim.play("idle_" + last_direction)
	
	fade_out.visible = true
	animation_player.play("FadeOut")
	await animation_player.animation_finished

	get_tree().change_scene_to_file("res://scenes/lost_screen.tscn")
