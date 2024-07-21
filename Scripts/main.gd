extends Control

@onready var add_node_button:Button = $AddNode
@onready var graph_edit:GraphEdit = $GraphEdit
var bgn = load("res://Scenes/Factories/base_graph_node.tscn")
var assembler = load("res://Scenes/Factories/assembler.tscn")
var initial_position:Vector2 = Vector2(40,40)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
