extends GraphEdit

var search_panel_res: PackedScene = load("res://Scenes/search_recipe.tscn")
var recipe_list: Array[Recipe] = []
var search_panel: SearchRecipe

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	recipe_list = load_recipes()
	pass

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

func load_recipes() -> Array[Recipe]:
	var recipe_files := DirAccess.get_files_at("res://Recipes/")
	for recipe_file in recipe_files:
		var recipe: Recipe = ResourceLoader.load("res://Recipes/" + recipe_file)
		recipe_list.append(recipe)
	set_item_ids()
	return recipe_list

func set_item_ids() -> void:
	var id_count: int = 0
	var item_list: Array[SatisfactoryItem] = []
	for recipe in recipe_list:
		for item_amount:ItemAmount in recipe.inputs:
			if item_amount.item not in item_list:
				item_amount.item.id = id_count
				id_count += 1
				item_list.append(item_amount.item)
		for item_amount in recipe.outputs:
			if item_amount.item not in item_list:
				item_amount.item.id = id_count
				id_count += 1
				item_list.append(item_amount.item)
	
	for item in item_list:
		print(item.name + " ID: " + str(item.id))
