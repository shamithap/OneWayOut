extends Node

@onready var player := $Player
@onready var ghost := $Ghost
@onready var timer := $CompassTimer
var compass_activated = false

@onready var layout_dict := {
	"dungeon" : $Markers/dungeon, 
	"graveyard" : $Markers/graveyard, 
	"winecellar" : $Markers/winecellar,
	"armory" : $Markers/armory, 
	"recreationalroom" : $Markers/recreationalroom, 
	"kitchen" : $Markers/kitchen,
	"theater": $Markers/theater, 
	"library" : $Markers/library, 
	"diningroom" : $Markers/diningroom,
	"ballroom" : $Markers/ballroom, 
	"livingroom" : $Markers/livingroom, 
	"fancybathroom" : $Markers/fancybathroom,
	"main" : $Markers/foyer
}

@onready var explored_dict := {
	"dungeon" : $Explored/explored_dungeon,
	"graveyard" : $Explored/explored_graveyard,
	"winecellar" : $Explored/explored_winecellar,
	"armory" : $Explored/explored_armory,
	"recreationalroom" : $Explored/explored_recreationalroom,
	"kitchen" : $Explored/explored_kitchen,
	"theater": $Explored/explored_theater,
	"library" : $Explored/explored_library,
	"diningroom" : $Explored/explored_diningroom,
	"ballroom" : $Explored/explored_ballroom,
	"livingroom" : $Explored/explored_livingroom,
	"fancybathroom" : $Explored/explored_fancybathroom,
	"main" : $Explored/explored_foyer
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NavigationManager.update_minimap_position.connect(update_player_position)
	self.visible = false
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("overlay"):
		self.visible = !self.visible

func update_player_position(destination_room_name) -> void:
	var current_room = layout_dict[destination_room_name]
	var explored_texture = explored_dict[destination_room_name]
	
	if current_room:
		player.global_position = current_room.global_position
		explored_texture.visible = true
		

func update_ghost_position(destination_room_name) -> void:
	if compass_activated:
		var current_room = layout_dict[destination_room_name]
		if current_room:
			ghost.global_position = current_room.global_position
			

func turn_off_compass() -> void:
	Overlay.get_node("CanvasLayer/Minimap").compass_activated = false
	Overlay.get_node("CanvasLayer/Minimap").ghost.visible = false
