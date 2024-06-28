extends Node2D

var product_menu_resource:PackedScene
var is_menu_active:bool = false
var is_menu_exitable:bool = false
var product_menu_instance:Node
@onready var timer:Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	product_menu_resource = load("res://Scenes/product_menu.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass
	
	
func _input(event:InputEvent) -> void:
	if Input.is_action_just_pressed("right_click"):
		invoke_menu()
	elif Input.is_action_just_pressed("ui_cancel") and is_menu_active == true:
		product_menu_instance.queue_free()
		is_menu_active = false

func invoke_menu() -> void:
	if not is_menu_active:
		is_menu_active = true
		product_menu_instance = product_menu_resource.instantiate()
		add_child(product_menu_instance)
		product_menu_instance.position = get_global_mouse_position()
		product_menu_instance.connect("mouse_exited",on_product_menu_mouse_exited)
		product_menu_instance.connect("mouse_entered",on_product_menu_mouse_entered)
	else:
		product_menu_instance.position = get_global_mouse_position()
		
func on_product_menu_mouse_exited() -> void:
	print("sali")
	is_menu_exitable = true
	
func on_product_menu_mouse_entered() -> void:
	print("entre")
	is_menu_exitable = false
	
