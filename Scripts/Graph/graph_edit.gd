extends GraphEdit

var search_panel_res: PackedScene = load("res://Scenes/search_recipe.tscn")
@onready var search_panel: SearchRecipe = $SearchPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#search_panel.hide_search_panel()
	#search_panel.add_building.connect(_on_add_building)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func instance_search_panel() -> void:
	if not search_panel:
		for child in get_children():
			if child.has_method("deselect_building"):
				child.deselect_building()
		search_panel = search_panel_res.instantiate()
		add_child(search_panel)
		search_panel.add_building.connect(_on_add_building)
	search_panel.set_position_offset((get_local_mouse_position() + scroll_offset) / zoom)
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("right_click"):
		instance_search_panel()
		
func _on_add_building(recipe: Recipe) -> void:
	match [recipe.inputs.size(), recipe.outputs.size()]:
		[0, 1]:
			instantiate_building("res://Scenes/Factories/1output.tscn", recipe)
		[1, 1]:
			instantiate_building("res://Scenes/Factories/1input1output.tscn", recipe)
		[2, 1]:
			instantiate_building("res://Scenes/Factories/2input1output.tscn", recipe)
		[3, 1]:
			instantiate_building("res://Scenes/Factories/3input1output.tscn", recipe)
		[4, 1]:
			instantiate_building("res://Scenes/Factories/4input1output.tscn", recipe)
		_:
			print("BUILDING NOT FOUND")

func instantiate_building(path: String, recipe: Recipe) -> void:
	var building: PackedScene = load(path)
	if building:
		var building_instance: GraphNode = building.instantiate()
		add_child(building_instance)
		building_instance.setup_building(recipe)
		building_instance.position_offset = search_panel.position_offset
