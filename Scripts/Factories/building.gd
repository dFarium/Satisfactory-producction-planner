extends GraphNode
class_name GraphBuilding

@export var inputs:Array[VBoxContainer]
@export var outputs:Array[VBoxContainer]
@onready var building_name:Label = $Buildings/BuildingName
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
func _process(_delta:float) -> void:
	pass

func setup_building(recipe:Recipe) -> void:
	title = recipe.name
	building_name.text = get_building_name(recipe.building)
	
	#inputs
	for i in range(input_nodes.size()):
		print(recipe.inputs[i].item.name)
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
	
func get_building_name(building:int) -> String:
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
