extends Control

@onready var graph_edit: GraphEdit = $GraphEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_items()
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_graph_edit_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_edit.connect_node(from_node, from_port, to_node, to_port)
	print(graph_edit.get_connection_list())
	
	pass # Replace with function body.

func _on_add_building(scene: PackedScene) -> void:
	var new_building: GraphNode = scene.instantiate()
	graph_edit.add_child(new_building)
	new_building.position_offset = get_global_mouse_position()
	pass # Replace with function body.

func _on_graph_edit_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_edit.disconnect_node(from_node, from_port, to_node, to_port)
	pass # Replace with function body.


func load_items() -> void:
	var id_count:int = 0
	var recipe_files := DirAccess.get_files_at("res://Items/")
	for recipe_file in recipe_files:
		var item: SatisfactoryItem = ResourceLoader.load("res://Items/" + recipe_file)
		item.id = id_count
		id_count += 1
