extends GraphNode
class_name SearchRecipe

# Variables de nodos de la escena
@onready var search_field: LineEdit = $LineEdit
@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var recipe_container: VBoxContainer = $ScrollContainer/VBoxContainer
var enabled: bool = true

# Constante para la escena del botón de opción
const BUTTON_OPTION = preload("res://Scenes/button_option.tscn")

# Lista de recetas cargadas
var recipe_list: Array[Recipe] = []
var recipe_buttons: Array[Button] = []

signal add_building(recipe: Recipe)
signal panel_disabled()

# Función llamada cuando el nodo entra en el árbol de la escena por primera vez
func _ready() -> void:
	initialize_buttons()
	pass
# Función llamada cuando el texto en el campo de búsqueda cambia
func _on_text_edit_text_changed(new_text: String) -> void:
	hide_buttons(recipe_container)
	if new_text.length() > 0:
		#show_recipes(search_recipes(new_text.to_lower()))
		show_recipes(search_recipes(new_text.to_lower()))
	else:
		show_recipes(recipe_list)


# Buscar recetas que coincidan parcial o completamente con la entrada
func search_recipes(input: String) -> Array:
	var results: Array = []
	
	for recipe in recipe_list:
		for output in recipe.outputs:
			if input.length() > 0 and output.item.name.to_lower().find(input.to_lower()) != -1:
				results.append(recipe)
				break # Evita agregar la misma receta varias veces
			elif input == output.item.name:
				results.append(recipe)
				break # Evita agregar la misma receta varias veces
	
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
	add_building.emit(recipe)
	disable_panel()

func _on_node_deselected() -> void:
	disable_panel()
	pass

func disable_panel() -> void:
	enabled = false
	visible = false
	selected = false
	panel_disabled.emit()
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_block_signals(true)


func enable_panel() -> void:
	enabled = true
	visible = true
	selected = true
	set_process(true)
	set_physics_process(true)
	set_process_input(true)
	set_block_signals(false)
	reset_panel()

func reset_panel() -> void:
	search_field.text = ""
	scroll_container.scroll_vertical = 0
	show_recipes(recipe_list)