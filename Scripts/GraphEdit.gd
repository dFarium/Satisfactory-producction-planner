extends GraphEdit

var menu_resource:PackedScene = load("res://Scenes/search_recipe.tscn")
var search_menu:GraphNode

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	pass # Replace with function body.


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
