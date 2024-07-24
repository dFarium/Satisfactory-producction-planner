extends GraphNode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_close_button()
	#set_slot(0, true, 0, Color(1,1,1,1), true, 0 , Color(1,1,1,1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass
	
func create_close_button() -> void:
	var hbox:HBoxContainer = get_titlebar_hbox()
	var close_button:Button = Button.new()
	close_button.text = "X"
	close_button.pressed.connect(_on_close_button_pressed)
	hbox.add_child(close_button)
	
func _on_close_button_pressed() -> void:
	queue_free()
