extends Control

@onready var graph_edit:GraphEdit = $GraphEdit
var constructor = load("res://Scenes/Factories/constructor.tscn")
var assembler = load("res://Scenes/Factories/assembler.tscn")
var manufacturer3 = load("res://Scenes/Factories/manufacturer3.tscn")
var manufacturer4 = load("res://Scenes/Factories/manufacturer4.tscn")
var initial_position:Vector2 = Vector2(40,40)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_tree().get_nodes_in_group("test"):
		node.add_building.connect(_on_add_building)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass


func _on_add_node_pressed() -> void:
	var new_graph_node:GraphNode = assembler.instantiate()
	graph_edit.add_child(new_graph_node)
	new_graph_node.position_offset = get_global_mouse_position()


func _on_graph_edit_connection_request(from_node:StringName, from_port:int, to_node:StringName, to_port:int) -> void:
	graph_edit.connect_node(from_node,from_port,to_node,to_port)
	
	pass # Replace with function body.


func _on_add_building(scene:PackedScene) -> void:
	var new_building:GraphNode = scene.instantiate()
	graph_edit.add_child(new_building)
	new_building.position_offset = get_global_mouse_position()
	pass # Replace with function body.
