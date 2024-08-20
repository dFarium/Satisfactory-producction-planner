extends GraphEdit

var search_panel_res: PackedScene = preload("res://Scenes/search_recipe.tscn")

var one_input_one_output: PackedScene = preload("res://Scenes/Factories/1input1output.tscn")
var one_input_two_output: PackedScene = preload("res://Scenes/Factories/1input2output.tscn")
var two_input_one_output: PackedScene = preload("res://Scenes/Factories/2input1output.tscn")
var three_input_one_output: PackedScene = preload("res://Scenes/Factories/3input1output.tscn")
var four_input_one_output: PackedScene = preload("res://Scenes/Factories/4input1output.tscn")
var one_output: PackedScene = preload("res://Scenes/Factories/1output.tscn")
var two_input_two_output: PackedScene = preload("res://Scenes/Factories/2input2output.tscn")
var four_input_two_output: PackedScene = preload("res://Scenes/Factories/4input2output.tscn")
var three_input_two_output: PackedScene = preload("res://Scenes/Factories/3input2output.tscn")

var recipe_list: Array[Recipe] = []
var search_panel: SearchRecipe

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load_recipes()
	load_recipes()

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
		search_panel.panel_disabled.connect(_on_panel_disabled)
		search_panel.add_building.connect(_on_add_building)
		add_child(search_panel)
	elif not search_panel.enabled:
		add_child(search_panel)
		search_panel.enable_panel()
	search_panel.set_position_offset((get_local_mouse_position() + scroll_offset) / zoom)
	
func _on_panel_disabled() -> void:
	remove_child(search_panel)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("right_click"):
		instantiate_search_panel()
		
func _on_add_building(recipe: Recipe) -> void:
	match [recipe.inputs.size(), recipe.outputs.size()]:
		[0, 1]:
			instantiate_building(one_output, recipe)
		[1, 1]:
			instantiate_building(one_input_one_output, recipe)
		[1, 2]:
			instantiate_building(one_input_two_output, recipe)
		[2, 1]:
			instantiate_building(two_input_one_output, recipe)
		[3, 1]:
			instantiate_building(three_input_one_output, recipe)
		[4, 1]:
			instantiate_building(four_input_one_output, recipe)
		[2, 2]:
			instantiate_building(two_input_two_output, recipe)
		[4, 2]:
			instantiate_building(four_input_two_output, recipe)
		[3, 2]:
			instantiate_building(three_input_two_output, recipe)
		_:
			print("BUILDING NOT FOUND")

func instantiate_building(building: PackedScene, recipe: Recipe) -> void:
	if building:
		var building_instance: GraphNode = building.instantiate()
		add_child(building_instance)
		building_instance.setup_building(recipe)
		building_instance.position_offset = search_panel.position_offset
		building_instance.slot_value_updated.connect(_on_slot_value_updated)
		
func load_recipes() -> void:
	recipe_list = []
	var dir: DirAccess = DirAccess.open("res://Recipes/")
	
	# Verifica si el directorio "Recipes" se pudo abrir
	if not dir:
		return
	
	dir.list_dir_begin()
	var sub_dir_name: String = dir.get_next()
	
	# Recorre cada subcarpeta dentro de "Recipes"
	while sub_dir_name != "":
		# Si no es un directorio, pasa al siguiente elemento
		if not dir.current_is_dir():
			sub_dir_name = dir.get_next()
			continue

		var sub_dir_path: String = "res://Recipes/" + sub_dir_name

		# Si la carpeta es "Resources," carga las recetas directamente
		if sub_dir_name == "Resources":
			var resources_dir: DirAccess = DirAccess.open(sub_dir_path)
			if not resources_dir:
				sub_dir_name = dir.get_next()
				continue

			resources_dir.list_dir_begin()
			var recipe_file: String = resources_dir.get_next()
			while recipe_file != "":
				if resources_dir.current_is_dir():
					recipe_file = resources_dir.get_next()
					continue

				# Carga el recurso de receta y lo añade a la lista de recetas
				var recipe: Recipe = load(sub_dir_path + "/" + recipe_file)
				recipe_list.append(recipe)

				recipe_file = resources_dir.get_next()
			resources_dir.list_dir_end()
		else:
			# Caso para las carpetas de "tiers" y "output"
			var tier_dir: DirAccess = DirAccess.open(sub_dir_path)
			if not tier_dir:
				sub_dir_name = dir.get_next()
				continue

			tier_dir.list_dir_begin()
			var output_dir_name: String = tier_dir.get_next()
			
			# Recorre cada subcarpeta de "output" dentro del tier actual
			while output_dir_name != "":
				if not tier_dir.current_is_dir():
					output_dir_name = tier_dir.get_next()
					continue

				var output_dir_path: String = sub_dir_path + "/" + output_dir_name
				var output_dir: DirAccess = DirAccess.open(output_dir_path)
				if not output_dir:
					output_dir_name = tier_dir.get_next()
					continue

				output_dir.list_dir_begin()
				var recipe_file: String = output_dir.get_next()
				
				var recipe_group: Array[Recipe] = []
				# Recorre cada archivo de receta dentro del tipo de output actual
				while recipe_file != "":
					if output_dir.current_is_dir():
						recipe_file = output_dir.get_next()
						continue

					# Carga el recurso de receta y lo añade a la lista de recetas
					var recipe: Recipe = ResourceLoader.load(output_dir_path + "/" + recipe_file)
					#recipe_list.append(recipe)
					recipe_group.append(recipe)
					
					recipe_file = output_dir.get_next()
				recipe_group.sort_custom(sort_by_regular_recipe)
				recipe_list.append_array(recipe_group)
				output_dir.list_dir_end()

				output_dir_name = tier_dir.get_next()
			tier_dir.list_dir_end()
		
		sub_dir_name = dir.get_next()
	dir.list_dir_end()
	
	# Llama a una función para establecer identificadores de ítems, si es necesario
	set_item_ids()

func sort_by_regular_recipe(a: Recipe, b: Recipe) -> bool:
	return int(a.is_alternate_recipe) < int(b.is_alternate_recipe)
	
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
