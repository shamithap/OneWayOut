extends Node

@onready var player := $Control/Player

@onready var layout_dict := {
	"exit" : $Control/Markers/exit,
	"dungeon" : $Control/Markers/dungeon, 
	"graveyard" : $Control/Markers/graveyard, 
	"winecellar" : $Control/Markers/winecellar,
	"armory" : $Control/Markers/armory, 
	"recreationalroom" : $Control/Markers/recreationalroom, 
	"kitchen" : $Control/Markers/kitchen,
	"theater": $Control/Markers/theater, 
	"library" : $Control/Markers/library, 
	"diningroom" : $Control/Markers/diningroom,
	"ballroom" : $Control/Markers/ballroom, 
	"livingroom" : $Control/Markers/livingroom, 
	"fancybathroom" : $Control/Markers/fancybathroom,
	"main" : $Control/Markers/foyer
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NavigationManager.update_minimap_position.connect(update_position)
	self.visible = false
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("map"):
		self.visible = !self.visible

func update_position(destination_room_name) -> void:
	var current_room = layout_dict[destination_room_name]
	
	if current_room:
		player.global_position = current_room.global_position
