extends Control

@onready var search_field:TextEdit = $TextEdit
@onready var recipe_container:VBoxContainer = $ScrollContainer/VBoxContainer
const BUTTON_OPTION = preload("res://Scenes/button_option.tscn")
var recipe_list:Array[Recipe]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_recipes()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass


func _on_text_edit_text_changed() -> void:
	clear_children(recipe_container)
	for recipe:Recipe in search_recipes(search_field.text.to_lower()):
		var recipe_option := BUTTON_OPTION.instantiate()
		recipe_container.add_child(recipe_option)
		var option :RecipeOption= recipe_container.get_child(-1)
		set_recipe(option,recipe)

func load_recipes() -> void:
	for recipe in DirAccess.get_files_at("res://Recipes/"):
		recipe_list.append(ResourceLoader.load("res://Recipes/"+recipe))
		
func search_recipes(input:String) -> Array:
	var results:Array
	for recipe in recipe_list:
		# Partial match
		if input.length() > 0 and recipe.name.to_lower().find(input) != -1:
			results.append(recipe)
		# Perfect match
		elif input == recipe.name:
			results.append(recipe)
	return results
	
func clear_children(node: Node) -> void:
	if node.get_child_count() > 0:
		var children := node.get_children()
		for child in children:
			child.queue_free()
			
func get_last_option_added(node:Node)-> Node:
	return node.get_child(node.get_child_count()-1)

func set_recipe(option:RecipeOption, recipe:Recipe) -> void:
	option.set_recipe_display(recipe)
