extends Button
class_name RecipeOption

var icons:Array[TextureRect] = []
@onready var option_icon:TextureRect = $HBoxContainer/option_icon
@onready var option_icon_2:TextureRect = $HBoxContainer/option_icon2
@onready var option_icon_3:TextureRect = $HBoxContainer/option_icon3
@onready var option_icon_4:TextureRect = $HBoxContainer/option_icon4
@onready var option_icon_5:TextureRect = $HBoxContainer/option_icon5
@onready var option_icon_6:TextureRect = $HBoxContainer/option_icon6
var arrow_icon:Resource

# Called when the node enters the scene tree for the first time.
func _ready() ->void:
	icons.append(option_icon)
	icons.append(option_icon_2)
	icons.append(option_icon_3)
	icons.append(option_icon_4)
	icons.append(option_icon_5)
	icons.append(option_icon_6)
	arrow_icon = load("res://Items/Icons/arrowRight.png")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) ->void:
	pass


func set_recipe_display(recipe:Recipe) ->void:
	text = recipe.name
	var icon_index:int = 0
	while icon_index <5:
		icons[icon_index].texture = null
		icon_index+=1	
	icon_index = 0
	#inputs
	for input in recipe.inputs:
		icons[icon_index].texture = input.item.icon
		icon_index+=1
	#arrow	
	icons[icon_index].texture = arrow_icon
	icon_index+=1
	#outputs
	for output in recipe.outputs:
		icons[icon_index].texture = output.item.icon
		icon_index+=1
