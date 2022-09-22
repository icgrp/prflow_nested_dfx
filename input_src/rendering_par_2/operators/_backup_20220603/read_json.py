import json

test = ['color', 'data']

with open('operator_list.json', 'w') as f:
    json.dump(test, f)

# with open('operator_list.json', 'r') as f:
#     operator_list = json.load(f)

# print(operator_list)
