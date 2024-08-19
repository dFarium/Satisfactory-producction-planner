import re

# Ruta del archivo específico que deseas modificar
file_path = "D:/Proyectos/Satisfactory production planner/Recipes/Resources/bauxite.tres"

# Mapeo de cambios necesarios
replacements = {
    "item_amount.gd": "ItemAmount.cs",
    "recipe.gd": "Recipe.cs",
    "item": "Item",
    "quantity": "Amount",
    "manufacturing_cycle": "ProcessingTime",
    "is_alternate_recipe": "IsAlternative"
}

def replace_text_in_file(file_path, replacements):
    # Leer el contenido del archivo
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    # Realizar los reemplazos
    for old, new in replacements.items():
        content = re.sub(r'\b{}\b'.format(re.escape(old)), new, content)

    # Escribir el contenido modificado de nuevo en el archivo
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(content)

def main():
    replace_text_in_file(file_path, replacements)
    print(f"Modificaciones completadas en {file_path}")

if __name__ == "__main__":
    main()
