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

# Función llamada cuando el texto en el campo de búsqueda cambia
func _on_text_edit_text_changed() -> void:
	# Limpiar las opciones anteriores
	clear_children(recipe_container)
	
	# Buscar recetas que coincidan con el texto de búsqueda
	var search_results := search_recipes(search_field.text.to_lower())
	
	# Crear y añadir opciones de receta basadas en los resultados de búsqueda
	for recipe:Recipe in search_results:
		var recipe_option := BUTTON_OPTION.instantiate()
		recipe_container.add_child(recipe_option)
		
		# Obtener la última opción añadida y configurar la receta
		var option: RecipeOption = recipe_container.get_child(recipe_container.get_child_count() - 1)
		set_recipe(option, recipe)

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
