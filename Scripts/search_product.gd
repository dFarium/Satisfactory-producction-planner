extends Control

# Variables de nodos de la escena
@onready var search_field: TextEdit = $TextEdit
@onready var recipe_container: VBoxContainer = $ScrollContainer/VBoxContainer

# Constante para la escena del botón de opción
const BUTTON_OPTION = preload("res://Scenes/button_option.tscn")

# Lista de recetas cargadas
var recipe_list: Array[Recipe] = []

# Función llamada cuando el nodo entra en el árbol de la escena por primera vez
func _ready() -> void:
	load_recipes()
	show_recipes(recipe_list)

# Función llamada cuando el texto en el campo de búsqueda cambia
func _on_text_edit_text_changed() -> void:
	clear_children(recipe_container)
	var input_field:TextEdit = get_node("TextEdit")
	if input_field.text.length() > 0:
		show_recipes(search_recipes(search_field.text.to_lower()))
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
		if input.length() > 0 and recipe.name.to_lower().find(input) != -1:
			results.append(recipe)
		elif input == recipe.name:
			results.append(recipe)
	return results

# Eliminar todos los hijos de un nodo
func clear_children(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()

# Configurar la visualización de una opción de receta
func set_recipe(option: RecipeOption, recipe: Recipe) -> void:
	option.set_recipe_display(recipe)
	
func show_recipes(recipes_to_show:Array) -> void:
	# Crear y añadir opciones de receta basadas en los resultados de búsqueda
	for recipe:Recipe in recipes_to_show:
		var recipe_option := BUTTON_OPTION.instantiate()
		recipe_container.add_child(recipe_option)
		# Obtener la última opción añadida y configurar la receta
		var option: RecipeOption = recipe_container.get_child(-1)
		set_recipe(option, recipe)
