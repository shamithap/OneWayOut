extends Node2D

@onready var container := $WineBottles/HBoxContainer
var correct_wine_order = ["cherry", "apple", "orange", "grape"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/rooms/winecellar/winecellar.tscn")
	check_wine_order()

func check_wine_order():
	var bottles := container.get_children()
	var array : Array[String] = []
	for bottle in bottles:
		array.append(bottle.get_texture().replace("_wine.png", ""))
		
	if array == correct_wine_order:
		win()

func win():
	Global.wine_cellar_complete = true
	NavigationManager.go_to_level("winecellar", "T")
