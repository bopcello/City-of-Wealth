import sys
import os

filepath = r'd:\Experiments\City of Wealth\city_of_wealth\lib\data\quiz_data.dart'
restorepath = r'd:\Experiments\City of Wealth\city_of_wealth\restore_block.txt'

with open(filepath, 'r', encoding='utf-8') as f:
    lines = f.readlines()

with open(restorepath, 'r', encoding='utf-8') as f:
    restore_content = f.read()

# Replace lines 281 (index 280) to 1603 (index 1602)
# lines[280:1603] replaces lines from index 280 to 1602 inclusive.
new_lines = lines[:280] + [restore_content] + lines[1603:]

with open(filepath, 'w', encoding='utf-8') as f:
    f.writelines(new_lines)
