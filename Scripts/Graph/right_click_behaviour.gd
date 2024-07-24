extends Control

var product_menu_resource:PackedScene = load("res://Scenes/search_recipe.tscn")
var product_menu_instance:Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass
	
	
func _input(event:InputEvent) -> void:
	if Input.is_action_just_pressed("right_click"):
		invoke_menu()

	

func invoke_menu() -> void:
		product_menu_instance = product_menu_resource.instantiate()
		add_child(product_menu_instance)
		product_menu_instance.position = get_global_mouse_position()
		
func on_product_menu_mouse_exited() -> void:
	print("sali")
	
func on_product_menu_mouse_entered() -> void:
	print("entre")
	
