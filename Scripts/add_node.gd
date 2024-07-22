extends Button

@export var building:PackedScene

signal add_building(building_scene:PackedScene)

func _on_pressed() -> void:
	add_building.emit(building)
	pass # Replace with function body.
