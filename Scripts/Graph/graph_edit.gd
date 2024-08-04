extends GraphEdit

var search_panel_res: PackedScene = load("res://Scenes/search_recipe.tscn")
var recipe_list: Array[Recipe] = []
var search_panel: SearchRecipe

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load_recipes()
	load_recipes_testing()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func instantiate_search_panel() -> void:
	if not search_panel:
		for child in get_children():
			if child.has_method("deselect_building"):
				child.deselect_building()

		search_panel = search_panel_res.instantiate()
		search_panel.recipe_list = recipe_list
		search_panel.add_building.connect(_on_add_building)
		add_child(search_panel)
	search_panel.set_position_offset((get_local_mouse_position() + scroll_offset) / zoom)
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("right_click"):
		instantiate_search_panel()
		
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
		building_instance.slot_value_updated.connect(_on_slot_value_updated)

func load_recipes() -> void:
	var recipe_files: PackedStringArray = DirAccess.get_files_at("res://Recipes/")
	for recipe_file in recipe_files:
		var recipe: Recipe = ResourceLoader.load("res://Recipes/" + recipe_file)
		recipe_list.append(recipe)
	set_item_ids()
		
func load_recipes_testing() -> void:
	recipe_list = []
	var dir: DirAccess = DirAccess.open("res://Recipes/")
	#Check if recipes directory exists
	if not dir:
		return
	
	dir.list_dir_begin()
	var tier_dir_name: String = dir.get_next()
	#Iterate through all tier directories
	while tier_dir_name != "":
		if not dir.current_is_dir():
			tier_dir_name = dir.get_next()
			continue
		#Open tier directory
		var tier_dir: DirAccess = DirAccess.open("res://Recipes/" + tier_dir_name)
		if not tier_dir:
			tier_dir_name = dir.get_next()
			continue

		tier_dir.list_dir_begin()
		var output_dir_name: String = tier_dir.get_next()

		#Iterate through all output directories
		while output_dir_name != "":
			if not tier_dir.current_is_dir():
				output_dir_name = tier_dir.get_next()
				continue
			#Open output directory
			var output_dir: DirAccess = DirAccess.open("res://Recipes/" + tier_dir_name + "/" + output_dir_name)
			if not output_dir:
				output_dir_name = tier_dir.get_next()
				continue

			output_dir.list_dir_begin()
			var recipe_file: String = output_dir.get_next()
			#Iterate through all recipe files
			while recipe_file != "":
				if output_dir.current_is_dir():
					recipe_file = output_dir.get_next()
					continue
				#Load recipe
				var recipe: Recipe = ResourceLoader.load("res://Recipes/" + tier_dir_name + "/" + output_dir_name + "/" + recipe_file)
				recipe_list.append(recipe)
				recipe_file = output_dir.get_next()
			output_dir.list_dir_end()

			output_dir_name = tier_dir.get_next()
		tier_dir.list_dir_end()
		
		tier_dir_name = dir.get_next()
	dir.list_dir_end()
	set_item_ids()
	
func set_item_ids() -> void:
	var id_count: int = 0
	var item_list: Array[SatisfactoryItem] = []
	for recipe: Recipe in recipe_list:
		for item_amount: ItemAmount in recipe.inputs:
			if item_amount.item not in item_list:
				item_amount.item.id = id_count
				id_count += 1
				item_list.append(item_amount.item)
		for item_amount: ItemAmount in recipe.outputs:
			if item_amount.item not in item_list:
				item_amount.item.id = id_count
				id_count += 1
				item_list.append(item_amount.item)
	
	for item in item_list:
		print(item.name + " ID: " + str(item.id))

func get_graphbuilding(path: String) -> GraphBuilding:
	return get_node(path)

func get_input_nodes_values(node: String) -> Array[Dictionary]:
	var input_values: Array[Dictionary] = []
	var connections: Array[Dictionary] = get_connection_list()
	for i in range(connections.size()):
		if connections[i].to_node == node:
			input_values.append({"port": connections[i].to_port, "value": get_graphbuilding(connections[i].from_node).get_output_value(connections[i].from_port)})
	return input_values

func _on_slot_value_updated(node: StringName, _slot: int, _value: float) -> void:
	for connection in get_connection_list():
		if connection.from_node == node:
			var graph_building: GraphBuilding = get_graphbuilding(connection.to_node)
			graph_building.set_input_value_from_connection(graph_building.find_bottleneck(get_input_nodes_values(connection.to_node)))
	pass

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_node(from_node, from_port, to_node, to_port)

	var array: Array[Dictionary] = get_connection_list()
	for connection: Dictionary in array:
		var graph_building: GraphBuilding = get_graphbuilding(connection.to_node)
		graph_building.set_input_value_from_connection(graph_building.find_bottleneck(get_input_nodes_values(connection.to_node)))
	pass # Replace with function body.

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)
	pass # Replace with function body.