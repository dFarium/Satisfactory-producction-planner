import os
import re
import shutil

# Directorio de entrada y salida
input_directory = "D:/Proyectos/Satisfactory production planner/Recipes/Resources"
output_directory = "D:/Proyectos/Satisfactory production planner/NeoRecipes/Resources"

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
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    # Realiza los reemplazos
    for old, new in replacements.items():
        content = re.sub(r'\b{}\b'.format(re.escape(old)), new, content)

    return content

def process_files(input_dir, output_dir, replacements):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    for root, dirs, files in os.walk(input_dir):
        for file in files:
            if file.endswith(".tres"):
                input_file_path = os.path.join(root, file)
                output_file_path = os.path.join(output_dir, file)

                # Copia el archivo al directorio de salida
                shutil.copy(input_file_path, output_file_path)

                # Realiza las modificaciones en el archivo copiado
                modified_content = replace_text_in_file(output_file_path, replacements)
                
                with open(output_file_path, 'w', encoding='utf-8') as file:
                    file.write(modified_content)

if __name__ == "__main__":
    process_files(input_directory, output_directory, replacements)
