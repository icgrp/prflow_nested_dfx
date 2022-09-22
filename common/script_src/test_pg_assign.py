import os, argparse, json


def main():
    
    with open('./pblock_assignment.json', 'r') as infile:
        (overlay_n, pblock_assign_dict) = json.load(infile)
    with open('./page_assignment.json', 'r') as infile:
        (overlay_n, page_num_dict) = json.load(infile)

    ops = [op for op in os.listdir('./') if os.path.isdir(os.path.join('./',op))]
    print(pblock_assign_dict)
    print(pblock_assign_dict.keys())

    for op in pblock_assign_dict.keys():
        pblock_name = pblock_assign_dict[op]
        page_num = page_num_dict[op]
        os.system('mkdir -p ' + op)
        with open('./' + op + '/pblock.json', 'w') as outfile:
            json.dump((overlay_n, pblock_name, page_num), outfile)

if __name__ == '__main__':
    main()
