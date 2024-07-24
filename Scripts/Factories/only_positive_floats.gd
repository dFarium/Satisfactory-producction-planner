extends LineEdit

const REGEX_PATTERN: String = r"^\d+(\.\d+)?$"
var regex: RegEx

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	regex = RegEx.new()
	regex.compile(REGEX_PATTERN)
	text = "0"
	text_submitted.connect(evaluate_math_expression)
	focus_exited.connect(_on_focus_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_focus_exited() -> void:
	text = check_input(text)

func check_input(input: String) -> String:
	var match: RegExMatch = regex.search(input)
	
	if match:
		var value: float = input.to_float()
		
		# Validar y manejar casos especiales
		if value < 0 or input == "-0" or input.strip_edges().is_empty():
			return "0"
		
		# Verificar decimal inválido
		var parts: PackedStringArray = input.split(".")
		if parts.size() > 2:
			return parts[0] # Devolver solo la parte entera
		
		return input
	else:
		# No es un número válido
		return "0"

func evaluate_math_expression(new_text: String) -> void:
	var expression: Expression = Expression.new()
	expression.parse(new_text)
	var result: Variant = expression.execute()
	print(result)
	if result == null:
		text = "0"
	text = check_input(str(result))
