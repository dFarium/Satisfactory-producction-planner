extends Node2D

var selected:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if selected:
		follow_mouse()
	
	
func follow_mouse() -> void:
	position = get_global_mouse_position()


func _on_area_2d_input_event(viewport:Node, event:InputEvent, shape_idx:int) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		print('so true')
		selected = true
	else:
		print('so false')
		selected = false
