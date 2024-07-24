extends Control
class_name SearchRecipe

# Variables de nodos de la escena
@onready var recipe_container: VBoxContainer = $ScrollContainer/VBoxContainer

# Constante para la escena del botón de opción
const BUTTON_OPTION = preload ("res://Scenes/button_option.tscn")

# Lista de recetas cargadas
var recipe_list: Array[Recipe] = []
var recipe_buttons: Array[Button] = []

signal add_building(recipe: Recipe)

# Función llamada cuando el nodo entra en el árbol de la escena por primera vez
func _ready() -> void:
	load_recipes()
	initialize_buttons()
	show_recipes(recipe_list)

# Función llamada cuando el texto en el campo de búsqueda cambia
func _on_text_edit_text_changed(new_text: String) -> void:
	hide_buttons(recipe_container)
	if new_text.length() > 0:
		show_recipes(search_recipes(new_text.to_lower()))
	else:
		show_recipes(recipe_list)

# Cargar las recetas desde la carpeta 'Recipes'
func load_recipes() -> void:
	var recipe_files := DirAccess.get_files_at("res://Recipes/")
	for recipe_file in recipe_files:
		var recipe := ResourceLoader.load("res://Recipes/" + recipe_file)
		recipe_list.append(recipe)

# Buscar recetas que coincidan parcial o completamente con la entrada
func search_recipes(input: String) -> Array:
	var results: Array = []
	for recipe in recipe_list:
		if input.length() > 0 and recipe.name.to_lower().find(input) != - 1:
			results.append(recipe)
		elif input == recipe.name:
			results.append(recipe)
	return results

# Eliminar todos los hijos de un nodo
func hide_buttons(node: Control) -> void:
	for button in node.get_children():
		button.visible = false

func show_recipes(recipes_to_show: Array) -> void:
	# Crear y añadir opciones de receta basadas en los resultados de búsqueda
	for button in recipe_buttons:
		if button.recipe_data in recipes_to_show:
			button.visible = true

func initialize_buttons() -> void:
	for recipe: Recipe in recipe_list:
		var recipe_option: Button = BUTTON_OPTION.instantiate()
		recipe_container.add_child(recipe_option)
		recipe_option.recipe_pressed.connect(_on_recipe_pressed)
		recipe_buttons.append(recipe_option)
		recipe_option.set_recipe_display(recipe)

func _on_recipe_pressed(recipe: Recipe) -> void:
	visible = false
	add_building.emit(recipe)

func _on_node_deselected() -> void:
	visible = false
