extends Button
class_name RecipeOption

var recipe_icons: Array[TextureRect] = []
@onready var label: Label = $HBoxContainer/Label
@onready var option_icon: TextureRect = $HBoxContainer/option_icon
@onready var option_icon_2: TextureRect = $HBoxContainer/option_icon2
@onready var option_icon_3: TextureRect = $HBoxContainer/option_icon3
@onready var option_icon_4: TextureRect = $HBoxContainer/option_icon4
@onready var option_icon_5: TextureRect = $HBoxContainer/option_icon5
@onready var option_icon_6: TextureRect = $HBoxContainer/option_icon6
@onready var option_icon_7: TextureRect = $HBoxContainer/option_icon7
var arrow_icon: Resource = load("res://ItemIcons/arrowRight.png")
var recipe_data: Recipe

signal recipe_pressed(recipe: Recipe)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	recipe_icons.append(option_icon)
	recipe_icons.append(option_icon_2)
	recipe_icons.append(option_icon_3)
	recipe_icons.append(option_icon_4)
	recipe_icons.append(option_icon_5)
	recipe_icons.append(option_icon_6)
	recipe_icons.append(option_icon_7)
	label.label_settings = LabelSettings.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_recipe_display(recipe: Recipe) -> void:
	recipe_data = recipe
	label.text = recipe.name
	if recipe.is_alternate_recipe == true:
		label.label_settings.font_color = Color(0.98, 0.584, 0.286) #Satisfactory Orange
	var icon_index: int = 0
	#set all icons to null
	for recipe_icon: TextureRect in recipe_icons:
		recipe_icon.texture = null

	#set inputs
	for input in recipe.inputs:
		recipe_icons[icon_index].texture = input.item.icon
		icon_index += 1

	#set arrow	
	recipe_icons[icon_index].texture = arrow_icon
	icon_index += 1

	#set outputs
	for output in recipe.outputs:
		recipe_icons[icon_index].texture = output.item.icon
		icon_index += 1

func _on_pressed() -> void:
	recipe_pressed.emit(recipe_data)