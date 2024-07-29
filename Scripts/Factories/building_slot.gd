extends LineEdit

var expr := preload("res://Scripts/expression.gd").new()
const REGEX_PATTERN: String = r"^\d+(\.\d+)?$"
var regex: RegEx
var last_valid_value: String = "0"

enum BuildingSlot {
	#Default
	Unnasigned,
	#Inputs
	Input1,
	Input2,
	Input3,
	Input4,
	Input5,
	Input6,
	#Outputs
	Output1,
	Output2,
	Output3,
	Output4,
	Output5,
	Output6,
	#Factory
	Building,
	OnlyOutput,
}

signal slot_value_updated(slot: BuildingSlot, value: float)

@export var slot:BuildingSlot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	regex = RegEx.new()
	regex.compile(REGEX_PATTERN)
	text = "0"
	text_submitted.connect(_on_text_submitted)
	focus_exited.connect(_on_focus_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_focus_exited() -> void:
	evaluate_math_expression(text)
	slot_value_updated.emit(slot, text.to_float())

func _on_text_submitted(_new_text:String) -> void:
	evaluate_math_expression(text)
	
	if BuildingSlot.OnlyOutput != slot:
		slot_value_updated.emit(slot, text.to_float())


func evaluate_math_expression(new_text: String) -> void:
	var rounded:float = snapped(expr.evalute(new_text),0.001)
	var result:String = str(rounded)
	text = check_input(str(result))

func check_input(input: String) -> String:
	var match: RegExMatch = regex.search(input)
	
	if match:
		var value: float = input.to_float()
		
		# Validar y manejar casos especiales
		if value < 0 or input == "-0" or input.strip_edges().is_empty():
			return last_valid_value
		
		#actualizar el valor válido
		last_valid_value = input
		return input
	else:
		# No es un número válido
		return last_valid_value