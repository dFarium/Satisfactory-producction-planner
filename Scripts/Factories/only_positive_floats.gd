extends LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "0"
	text_submitted.connect(_on_text_submitted)
	focus_exited.connect(_on_text_submitted)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_text_submitted(new_text: String = "") -> void:
	text = check_input(new_text)
	


func check_input(new_text:String) -> String:
	var number: float = 0.0
	if not new_text.is_empty():
		number = new_text.to_float()
	# Verifica si el número es positivo
	if new_text.is_empty() or number < 0.0:
		return "0"
	else:
		return str(number)
	
