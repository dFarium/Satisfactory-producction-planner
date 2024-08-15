import os
import re

def modify_tres_file(filepath):
    with open(filepath, 'r') as file:
        lines = file.readlines()

    new_lines = []
    script_changed = False
    name_changed = False
    icon_changed = False
    description_found = False

    for line in lines:
        if 'script_class="SatisfactoryItem"' in line:
            new_lines.append(line.replace('script_class="SatisfactoryItem"', 'script_class="Item"'))
            script_changed = True
        elif 'item.gd' in line:
            new_lines.append(line.replace('item.gd', 'Item.cs'))
            script_changed = True
        elif 'name = ' in line:
            new_lines.append(line.replace('name', 'Name'))
            name_changed = True
        elif 'icon = ' in line:
            new_lines.append(line.replace('icon', 'Icon'))
            icon_changed = True
        elif 'description = ' in line:
            description_found = True
        else:
            new_lines.append(line)

    if not script_changed:
        print(f"Warning: 'item.gd' not found in {filepath}")
    
    if not name_changed:
        print(f"Warning: 'name' not found in {filepath}")

    if not icon_changed:
        print(f"Warning: 'icon' not found in {filepath}")

    if description_found:
        new_lines = [line for line in new_lines if 'description = ' not in line]

    new_lines.append('Amount = 0.0\n')
    new_lines = remove_duplicate_amount_lines(new_lines)

    with open(filepath, 'w') as file:
        file.writelines(new_lines)

def remove_duplicate_amount_lines(lines):
    seen = False
    filtered_lines = []
    for line in lines:
        if line.strip().startswith('Amount ='):
            if not seen:
                filtered_lines.append(line)
                seen = True
        else:
            filtered_lines.append(line)
            if not line.strip().startswith('Amount ='):
                seen = False
    return filtered_lines


def process_directory(directory):
    for filename in os.listdir(directory):
        if filename.endswith('.tres'):
            filepath = os.path.join(directory, filename)
            modify_tres_file(filepath)
            print(f"Processed: {filepath}")

if __name__ == '__main__':
    folder_path = input("Enter the path to the directory containing .tres files: ")
    process_directory(folder_path)
