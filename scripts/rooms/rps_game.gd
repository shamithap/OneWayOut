extends Control

@onready var players_texture := $Sprites/PlayerChoice
@onready var knights_texture := $Sprites/KnightChoice
@onready var label := $Label
@onready var game_win_or_lose := $EndPanel/VBoxContainer/GameWinOrLose
@onready var next_round_button := $NextRoundButton
@onready var confirmation_button := $Buttons/HBoxContainer/Confirmationbutton

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

func _process(_delta) -> void:
	if round_count <= 3 and not in_round and player_win_count != 2:
		in_round = true
		await confirmation_button.pressed #player makes choice
		knight_turn() #player done making choice, time for knight
		round_winner() #see who won
		await next_round_button.pressed #next round
	elif round_count > 3 or player_win_count == 2:
		$EndPanel.visible = true
		if(player_win_count == 2):
			game_win_or_lose.text = "Congrats you won!"
		else:
			game_win_or_lose.text = "You lost..."

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
	next_round_button.visible = true
	
func player_won_round():
	player_win_count += 1
	label.text = "You won the round!"
	
func knight_won_round():
	label.text = "You lost this round..."

func _on_sword_button_pressed() -> void:
	if can_make_choice:
		players_choice = "sword"
		players_texture.texture = option_pictures[players_choice]

func _on_shield_button_pressed() -> void:
	if can_make_choice:
		players_choice = "shield"
		players_texture.texture = option_pictures[players_choice]

func _on_scroll_button_pressed() -> void:
	if can_make_choice:
		players_choice = "scroll"
		players_texture.texture = option_pictures[players_choice]

func _on_next_round_button_pressed() -> void:
	next_round_button.visible = false
	round_count += 1
	reset()

func _on_return_room_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/rooms/armory/armory.tscn")

func _on_confirmation_button_pressed() -> void:
	can_make_choice = false
