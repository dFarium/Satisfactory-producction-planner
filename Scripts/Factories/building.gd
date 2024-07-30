extends GraphNode
class_name GraphBuilding

@export var inputs: Array[VBoxContainer]
@export var outputs: Array[VBoxContainer]
@onready var building_name: Label = $Buildings/BuildingName
@onready var building_count_text: LineEdit = $Buildings/LineEdit

signal slot_value_updated(node: StringName, slot: int, value: float)


var input_nodes: Array[Array]
var output_nodes: Array[Array]

var input_values: Array[LineEdit] = []
var output_values: Array[LineEdit] = []

var input_items: Array[ItemAmount]
var output_items: Array[ItemAmount]

var current_recipe: Recipe


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_close_button()
	#Label,TextureRect,HBoxContainer(LineEdit,Label)
	for input in inputs:
		input_nodes.append(input.get_children())
		
	for output in outputs:
		output_nodes.append(output.get_children())
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	pass

func setup_building(recipe: Recipe) -> void:
	#print(building_name)
	current_recipe = recipe
	title = recipe.name
	building_name.text = get_building_name(recipe.building) + " (" + str(recipe.manufacturing_cycle) + " sec)"
	
	#inputs
	for i in range(input_nodes.size()):
		input_nodes[i][0].text = recipe.inputs[i].item.name
		input_nodes[i][1].texture = recipe.inputs[i].item.icon

		input_values.append(input_nodes[i][2].get_node("LineEdit"))
		
	#outputs
	for i in range(output_nodes.size()):
		output_nodes[i][0].text = recipe.outputs[i].item.name
		output_nodes[i][1].texture = recipe.outputs[i].item.icon

		output_values.append(output_nodes[i][2].get_node("LineEdit"))

	set_slot_type()
	
func _on_slot_value_updated(slot: int, value: float) -> void:
	#value = items per minute
	var building_count: float = 0
	var items_per_min_per_building: float = 0
	var cycles_per_minute: float = 60 / current_recipe.manufacturing_cycle
	#si slot es un input
	if slot >= 0 and slot <= 6:
		items_per_min_per_building = cycles_per_minute * current_recipe.inputs[slot - 1].quantity
	#si es un output
	elif slot >= 7 and slot <= 12:
		items_per_min_per_building = cycles_per_minute * current_recipe.outputs[slot - 7].quantity

	#si es el slot de cantidad de edificios
	if slot == 13:
		building_count = value
	#si es solo output
	elif slot == 14:
		slot_value_updated.emit(self.name, slot, value)
		return
	else:
		building_count = value / items_per_min_per_building
		building_count_text.text = str(snapped(building_count, 0.001))

	for i in input_values.size():
		var items_per_min: float = building_count * float(current_recipe.inputs[i].quantity) * cycles_per_minute
		input_values[i].text = str(snapped(items_per_min, 0.001))
	
	for i in output_values.size():
		var items_per_min: float = building_count * float(current_recipe.outputs[i].quantity) * cycles_per_minute
		output_values[i].text = str(snapped(items_per_min, 0.001))
	
	slot_value_updated.emit(self.name, slot, value)
	
func set_slot_type() -> void:
	var i_count: int = get_input_port_count()
	var o_count: int = get_output_port_count()
	#print("count ", i_count, " ", o_count)

	for i in range(i_count):
		set_slot_color_left(i + 1, Color(1, 1, 1))
		set_slot_type_left(i + 1, current_recipe.inputs[i].item.id)
	
	for i in range(o_count):
		set_slot_color_right(i + 1, Color(1, 1, 1))
		set_slot_type_right(i + 1, current_recipe.outputs[i].item.id)

	#print("set_slot_type ", get_input_port_type(0), " ", get_input_port_type(1), " / output ", get_output_port_type(0), " ", get_output_port_type(1))
		
func set_close_button() -> void:
	#Close button
	var hbox: HBoxContainer = get_titlebar_hbox()
	var btn: Button = Button.new()
	btn.text = " X "
	btn.pressed.connect(queue_free)
	hbox.add_child(btn)
	
func get_building_name(building: int) -> String:
	match building:
		Recipe.Building.Assembler:
			return "Assembler"
		Recipe.Building.Blender:
			return "Blender"
		Recipe.Building.Constructor:
			return "Constructor"
		Recipe.Building.Manufacturer:
			return "Manufacturer"
		Recipe.Building.Merger:
			return "Merger"
		Recipe.Building.Miner:
			return "Miner"
		Recipe.Building.NuclearPowerPlant:
			return "Nuclear Power Plant"
		Recipe.Building.OilExtractor:
			return "Oil Extractor"
		Recipe.Building.Packager:
			return "Packager"
		Recipe.Building.ParticleAccelerator:
			return "Particle Accelerator"
		Recipe.Building.Refinery:
			return "Refinery"
		Recipe.Building.Smelter:
			return "Smelter"
		Recipe.Building.Splitter:
			return "Splitter"
		Recipe.Building.WaterExtractor:
			return "Water Extractor"
		Recipe.Building.WellExtractor:
			return "Well Extractor"
		_:
			return "Unknown Building"

func set_input_value_from_connection(slot: int, value: float, bottleneck: Dictionary) -> void:
	#el valor viene desde un output hacia un input
	#input_values[slot].text = str(value)
	slot = bottleneck.port
	value = bottleneck.value
	var building_count: float = 0
	var items_per_min_per_building: float = 0
	var cycles_per_minute: float = 60 / current_recipe.manufacturing_cycle
	items_per_min_per_building = cycles_per_minute * current_recipe.inputs[slot].quantity

	building_count = value / items_per_min_per_building
	building_count_text.text = str(snapped(building_count, 0.001))

	for i in input_values.size():
		var items_per_min: float = building_count * float(current_recipe.inputs[i].quantity) * cycles_per_minute
		input_values[i].text = str(snapped(items_per_min, 0.001))
	
	for i in output_values.size():
		var items_per_min: float = building_count * float(current_recipe.outputs[i].quantity) * cycles_per_minute
		output_values[i].text = str(snapped(items_per_min, 0.001))

	slot_value_updated.emit(self.name, slot, value)
	pass

func find_bottleneck(input_array: Array[Dictionary]) -> Dictionary:
	#not enough inputs, zero production
	var production_potencial: Array[float] = []
	if input_array.size() != current_recipe.inputs.size():
		return {"port": - 1, "value": 0}
	#get production potential for each input
	for i in range(0, input_array.size()):
		production_potencial.append(input_array[i].value / current_recipe.inputs[i].quantity)
	#return the smallest production potential

	return input_array[find_min_index(production_potencial)]


static func find_min_index(arr: Array) -> int:
	if arr.size() == 0:
		return -1 # Devuelve -1 si el array está vacío

	var min_value: float = arr[0]
	var min_index: int = 0

	for i in range(1, arr.size()):
		if arr[i] < min_value:
			min_value = arr[i]
			min_index = i

	return min_index

func get_output_value(slot: int) -> float:
	return float(output_values[slot].text)

func deselect_building() -> void:
	selected = false
