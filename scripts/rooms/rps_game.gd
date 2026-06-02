extends Control

@onready var players_texture := $Sprites/PlayerChoice
@onready var knights_texture := $Sprites/KnightChoice
@onready var label := $Help/Label
@onready var game_win_or_lose := $EndPanel/GameWinOrLose
@onready var timer := $NextRoundTimer

@onready var win_sound := $Sounds/Win
@onready var lose_sound := $Sounds/Lose
@onready var select_sound := $Sounds/Select
var sound_triggered = false

@onready var buttons = [
	$Buttons/SwordButton,
	$Buttons/ShieldButton,
	$Buttons/ScrollButton,
	$Buttons/ConfirmationButton,
	$EndPanel/ReturnRoomButton
]

@onready var option_pictures := {
	"sword" : load("res://assets/kenney_tiny-dungeon/Tiles/tile_0104.png"),
	"shield" : load("res://assets/kenney_tiny-dungeon/Tiles/tile_0102.png"),
	"scroll" :load("res://assets/objects/BigWander_ArtOfScrolls/IndividualSprites/Scroll_01_01_ArtOfScrolls_BigWander(16x16).png")
}

var players_choice : String = ""
var knights_choice : String = ""

var player_win_count : int = 0
var round_count : int = 1

var can_make_choice : bool = true
var in_round: bool = false

func _ready() -> void:
	for i in range(buttons.size()):
		buttons[i].pressed.connect(_on_button_pressed.bind(buttons[i]))

func _process(_delta) -> void:
	if round_count <= 3 and not in_round and player_win_count != 2:
		in_round = true
		await buttons[3].pressed #confirmation button - player makes choice
		knight_turn() #player done making choice, time for knight
		round_winner() #see who won
		
		timer.start()
		await timer.timeout
		
		next_round()
	elif round_count > 3 or player_win_count == 2:
		$EndPanel.visible = true
		if(player_win_count == 2):
			Global.armory_complete = true
			if not sound_triggered:
				win_sound.play()
			game_win_or_lose.text = "Congrats you won!"
		else:
			if not sound_triggered:
				lose_sound.play()
			game_win_or_lose.text = "You lost..."
		sound_triggered = true

func knight_turn() -> void:
	knights_choice = option_pictures.keys().pick_random()
	knights_texture.texture = option_pictures[knights_choice]
	
func reset() -> void:
	in_round = false
	can_make_choice = true
	
	players_choice = ""
	knights_choice = ""
	label.text = "Pick an option!"
	
	players_texture.texture = null
	knights_texture.texture = null

func round_winner() -> void:
	if players_choice == "sword" and knights_choice == "shield":
		#knight wins
		knight_won_round()
	elif players_choice == "sword" and knights_choice == "scroll":
		#player wins
		player_won_round()
	elif players_choice == "shield" and knights_choice == "sword":
		#player wins
		player_won_round()
	elif players_choice == "shield" and knights_choice == "scroll":
		#knight wins
		knight_won_round()
	elif players_choice == "scroll" and knights_choice == "sword":
		#knight wins
		knight_won_round()
	elif players_choice == "scroll" and knights_choice == "shield":
		#player wins
		player_won_round()
	else: 
		#tie
		label.text = "It was a tie!"
	
func player_won_round():
	player_win_count += 1
	label.text = "You won the round!"
	
func knight_won_round():
	label.text = "You lost this round..."

func _on_button_pressed(button):
	match button.name:
		"SwordButton":
			if can_make_choice:
				select_sound.play()
				players_choice = "sword"
				players_texture.texture = option_pictures[players_choice]
		"ShieldButton":
			if can_make_choice:
				select_sound.play()
				players_choice = "shield"
				players_texture.texture = option_pictures[players_choice]
		"ScrollButton":
			if can_make_choice:
				select_sound.play()
				players_choice = "scroll"
				players_texture.texture = option_pictures[players_choice]
		"ConfirmationButton":
			can_make_choice = false
		"ReturnRoomButton":
			get_tree().change_scene_to_file("res://scenes/rooms/armory/armory.tscn")

func next_round() -> void:
	round_count += 1
	reset()
