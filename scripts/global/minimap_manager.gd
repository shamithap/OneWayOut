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

@onready var explored_dict := {
	"exit" : $Control/Explored/explored_exit,
	"dungeon" : $Control/Explored/explored_dungeon,
	"graveyard" : $Control/Explored/explored_graveyard,
	"winecellar" : $Control/Explored/explored_winecellar,
	"armory" : $Control/Explored/explored_armory,
	"recreationalroom" : $Control/Explored/explored_recreationalroom,
	"kitchen" : $Control/Explored/explored_kitchen,
	"theater": $Control/Explored/explored_theater,
	"library" : $Control/Explored/explored_library,
	"diningroom" : $Control/Explored/explored_diningroom,
	"ballroom" : $Control/Explored/explored_ballroom,
	"livingroom" : $Control/Explored/explored_livingroom,
	"fancybathroom" : $Control/Explored/explored_fancybathroom,
	"main" : $Control/Explored/explored_foyer
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
	var explored_texture = explored_dict[destination_room_name]
	
	if current_room:
		player.global_position = current_room.global_position
		explored_texture.visible = true
		
