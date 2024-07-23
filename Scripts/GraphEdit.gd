extends GraphEdit

var menu_resource:PackedScene = load("res://Scenes/search_recipe.tscn")
var search_menu:GraphNode

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	for node in get_tree().get_nodes_in_group("recipe_option"):
		node.add_building.connect(_on_add_building)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float)->void:
	pass

func show_search_menu()->void:
	if not is_instance_valid(search_menu):
		search_menu = menu_resource.instantiate()
		add_child(search_menu)
	search_menu.position_offset = get_global_mouse_position()

	
func _input(event:InputEvent) -> void:
	if Input.is_action_just_pressed("right_click"):
		show_search_menu()
		
func _on_add_building(recipe:Recipe) -> void:
	match [recipe.inputs.size(),recipe.outputs.size()]:
		[0,1]:
			instantiate_building("res://Scenes/Factories/1output.tscn",recipe)
		[1,1]:
			instantiate_building("res://Scenes/Factories/1input1output.tscn",recipe)
		[2,1]:
			instantiate_building("res://Scenes/Factories/2input1output.tscn",recipe)
		[3,1]:
			instantiate_building("res://Scenes/Factories/3input1output.tscn",recipe)
		[4,1]:
			instantiate_building("res://Scenes/Factories/4input1output.tscn",recipe)
		_:
			print("NO ENCONTRADO")

func instantiate_building(path:String, recipe:Recipe) -> void:
	var building:PackedScene = load(path)
	var build_instance:GraphNode = building.instantiate()
	build_instance.setup_building(recipe)
	add_child(build_instance)
	build_instance.position_offset = get_global_mouse_position()
