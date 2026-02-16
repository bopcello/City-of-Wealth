import re
import os

root_dir = r'd:\Experiments\City of Wealth\city_of_wealth\lib'
target_dirs = [
    os.path.join(root_dir, 'data'),
    os.path.join(root_dir, 'screens'),
    os.path.join(root_dir, 'widgets'),
]

def process_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Replace gem emoji
    new_content = content.replace('💎', '[GEM]')

    # Replace "100 Gems" or "100 gems" with "100 [GEM]"
    # Avoid replacing if it's already part of [GEM] or a variable name like 'gems'
    # We look for Gems or gems preceded by a number or space, and maybe followed by non-alphanumeric
    new_content = re.sub(r'(\d+)(\s*)(Gems|gems)\b', r'\1 [GEM]', new_content)
    
    # Also replace standalone "Gems" in strings like "Cost: 10 Gems" -> "Cost: 10 [GEM]"
    # This is trickier as we don't want to break variable names.
    # Usually they are in quotes.
    new_content = re.sub(r'(?<=\d)\s*(Gems|gems)\b', r' [GEM]', new_content)

    if new_content != content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated: {file_path}")

for target_dir in target_dirs:
    for root, _, files in os.walk(target_dir):
        for file in files:
            if file.endswith('.dart'):
                process_file(os.path.join(root, file))

print("Replacement complete.")
