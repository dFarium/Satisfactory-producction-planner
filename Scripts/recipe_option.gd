extends Button
class_name RecipeOption

var icons:Array[TextureRect] = []
@onready var label:Label = $HBoxContainer/Label
@onready var option_icon:TextureRect = $HBoxContainer/option_icon
@onready var option_icon_2:TextureRect = $HBoxContainer/option_icon2
@onready var option_icon_3:TextureRect = $HBoxContainer/option_icon3
@onready var option_icon_4:TextureRect = $HBoxContainer/option_icon4
@onready var option_icon_5:TextureRect = $HBoxContainer/option_icon5
@onready var option_icon_6:TextureRect = $HBoxContainer/option_icon6
@onready var option_icon_7:TextureRect = $HBoxContainer/option_icon7
var arrow_icon:Resource = load("res://Items/Icons/arrowRight.png")
var recipe_data:Recipe

signal add_building(recipe:Recipe)

# Called when the node enters the scene tree for the first time.
func _ready() ->void:
	icons.append(option_icon)
	icons.append(option_icon_2)
	icons.append(option_icon_3)
	icons.append(option_icon_4)
	icons.append(option_icon_5)
	icons.append(option_icon_6)
	icons.append(option_icon_7)
	pressed.connect(_on_pressed)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) ->void:
	pass

func set_recipe_display(recipe:Recipe) ->void:
	recipe_data = recipe
	label.text = recipe.name
	var icon_index:int = 0
	for icon:TextureRect in icons:
		icon.texture = null
	#set inputs
	for input in recipe.inputs:
		icons[icon_index].texture = input.item.icon
		icon_index+=1
	#set arrow	
	icons[icon_index].texture = arrow_icon
	icon_index+=1
	#set outputs
	for output in recipe.outputs:
		icons[icon_index].texture = output.item.icon
		icon_index+=1

func _on_pressed() -> void:
	setup_building()
	pass # Replace with function body.
	
func setup_building() -> void:
	match [recipe_data.inputs.size(),recipe_data.outputs.size()]:
		[0,1]:
			instantiate_building("res://Scenes/Factories/1output.tscn")
		[1,1]:
			instantiate_building("res://Scenes/Factories/1input1output.tscn")
		[2,1]:
			instantiate_building("res://Scenes/Factories/2input1output.tscn")
		[3,1]:
			instantiate_building("res://Scenes/Factories/3input1output.tscn")
		[4,1]:
			instantiate_building("res://Scenes/Factories/4input1output.tscn")
		_:
			print("NO ENCONTRADO")

func instantiate_building(path:String) -> void:
	var building:PackedScene = load(path)
	var build_instance:GraphBuilding = building.instantiate()
	build_instance.setup_building(recipe_data)
	#get_node(/root/)
