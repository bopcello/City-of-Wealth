import re

file_path = r'd:\Experiments\City of Wealth\city_of_wealth\lib\data\quiz_data.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace gem emoji
content = content.replace('💎', '[GEM]')

# Replace "100 Gems" or "100 gems" with "100 [GEM]"
content = re.sub(r'(\d+)(\s*)(Gems|gems)', r'\1 [GEM]', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Replacement complete.")
