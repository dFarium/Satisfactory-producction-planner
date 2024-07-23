extends GraphNode
class_name GraphBuilding

@export var inputs:Array[VBoxContainer]
@export var outputs:Array[VBoxContainer]
var input_nodes:Array[Array]
var output_nodes:Array[Array]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_close_button()	
	#Label,TextureRect,Spinbox
	for input in inputs:
		input_nodes.append(input.get_children())
	for output in outputs:
		output_nodes.append(output.get_children())
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass

func setup_building(recipe:Recipe) -> void:
	#inputs
	for i in range(input_nodes.size()):
		input_nodes[i][0].text = recipe.inputs[i].item.name
		input_nodes[i][1].texture = recipe.inputs[i].item.icon
	#outputs
	for i in range(output_nodes.size()):
		output_nodes[i][0].text = recipe.outputs[i].item.name
		output_nodes[i][1].texture = recipe.outputs[i].item.icon
		
		
func update_production_info() -> void:
	pass
	
func set_close_button() -> void:
	#Close button
	var hbox:HBoxContainer = get_titlebar_hbox()
	var btn:Button = Button.new()
	btn.text = " X "
	btn.pressed.connect(queue_free)
	hbox.add_child(btn)
