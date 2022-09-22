import os, argparse, json, time
# import pickle

parser = argparse.ArgumentParser()
parser.add_argument('-ops',       '--operators',        help="all operators",    nargs='+')
args = parser.parse_args()
MARGIN = 0.10 # 10% margin

# returns 10 when overlay_name is 'overlay_p10'
def get_n(overlay_name):
    return int(overlay_name.split('overlay_p')[1])


# returns (overlay_dict, sorted_key_list) 
# e.g.: ({'overlay_p23': /PATH_OVERLAY/overlay_p23/util_all.pickle, ... ,
#         'overlay_p10': /PATH_OVERLAY/overlay_p10/util_all.pickle),
#        ['overlay_p10', 'overlay_p23'])
def get_overlay_dict(overlay_dir):
    # overlay_dict = {d : overlay_dir+d+'/util_all.pickle' \
    # for d in os.listdir(overlay_dir) \
    # if (d.startswith('overlay_p') and os.path.isdir(overlay_dir+d))}
    overlay_dict = {d : overlay_dir+d+'/util_all.json' \
                    for d in os.listdir(overlay_dir) \
                    if (d.startswith('overlay_p') and os.path.isdir(overlay_dir+d))}
    # print(overlay_dict)

    key_sorted_list = []
    for key in overlay_dict.keys():
        key_sorted_list.append(get_n(key)) # [15, 23, 10]

    key_sorted_list = sorted(key_sorted_list) # [10, 15, 23]
    tmp = []
    for elem in key_sorted_list:
        tmp.append('overlay_p' + str(elem))
    key_sorted_list = tmp # [overlay_p10, overlay_p15, overlay_p23]
    return (overlay_dict, key_sorted_list)
    # print(key_sorted_list)


# returns whether the operator fits in the page and the page is available
def is_fit(op_resource_tuple, overlay_resource_tuple, assign_dict, page_num):
    [num_clb, num_ram18, num_dsp] = op_resource_tuple
    [num_clb_overlay, num_ram18_overlay, num_dsp_overlay] = overlay_resource_tuple
    num_clb, num_ram18, num_dsp = int(num_clb), int(num_ram18), int(num_dsp)
    num_clb_overlay, num_ram18_overlay, num_dsp_overlay = \
                int(num_clb_overlay), int(num_ram18_overlay), int(num_dsp_overlay)

    resource_condition = ((num_clb * (1+MARGIN) < num_clb_overlay) and \
                            num_ram18 <= num_ram18_overlay and \
                            num_dsp <= num_dsp_overlay)
    used_condition = (page_num not in assign_dict.values())
    return resource_condition and used_condition


# returns {op: page_num, ... }
# e.g.: {'coloringFB_bot_m': 1, 'coloringFB_top_m': 9, ...}
def get_assignment(overlay_util_dict, util_dict):
    # get total resource available
    with open('./resource.txt', 'r') as file:
        for line in file:
            if(not line.startswith('Total')):
                resources = line.split()
                total_LUT = int(resources[0])
                # total_dict['FFs'] = int(resources[1])
                total_BRAM = int(resources[2])
                total_DSP = int(resources[3])

    # add criteria in util_dict's value
    assign_dict = {}
    for key, value in util_dict.items():
        [num_clb, num_ram18, num_dsp] = value
        num_clb, num_ram18, num_dsp = int(num_clb), int(num_ram18), int(num_dsp)
        LUT_percent = float(num_clb) / total_LUT 
        BRAM_percent = float(num_ram18) / total_BRAM 
        DSP_percent = float(num_dsp) / total_DSP
        criteria = LUT_percent + BRAM_percent + DSP_percent
        # print(criteria)
        util_dict[key] = (value, criteria)

    # iterate through util_dict's op in descending order of resource usage
    # iterate through overlay_util_dict's page_num in ascending order
    # We don't need to, but for the debuging purposes..
    # print(util_dict)
    for op, value in sorted(util_dict.items(), key=lambda x:x[1][1], reverse=True): # sorted by criteria
        op_resource_tuple = value[0]
        # print(op, op_resource_tuple)
        page_list = [int(key) for key in overlay_util_dict.keys()]
        for page_num in sorted(page_list):
            overlay_resource_tuple = overlay_util_dict[str(page_num)]
            # print(page_num, overlay_resource_tuple)
            if(is_fit(op_resource_tuple, overlay_resource_tuple, assign_dict, page_num)):
                assign_dict[op] = page_num
                # don't go to next page_num
                break

    # print(assign_dict)
    found = (len(assign_dict) == len(util_dict)) # at least one operator doesn't fit into page
    return found, assign_dict


# if overlay_n = overlay_p17, p11~p17 are removed
def remove_tandem_leaves(overlay_n, overlay_util_dict):
    n = get_n(overlay_n)
    new_overlay_util_dict = {}
    for page_num in overlay_util_dict.keys():
        if(int(page_num) <= n-7):
            new_overlay_util_dict[page_num] = overlay_util_dict[page_num]
    return new_overlay_util_dict


def main():
    # print(args.operators)
    util_dict = {}
    for op_dir in args.operators:
        with open('./' + op_dir + '/utilization.rpt', 'r') as file:
            for line in file:
                if(line.startswith('| leaf')):
                    # print(line.split())
                    num_clb = line.split()[5]
                    num_ram18 = int(line.split()[15])*2 + int(line.split()[17])
                    num_dsp = line.split()[21]
                    # print(num_clb, num_ram18, num_dsp)
                    util_dict[op_dir] = (num_clb, num_ram18, num_dsp)
    # print(util_dict)
    # e.g.: at this point, util_dict = {'rasterization2_m': ('4771', 12, '12'), 
    #                                   'data_transfer': ('1575', 6, '0'), ... }    

    assign_dict = {}
    # OVERLAY_DIR will be updated in syn.py
    OVERLAY_DIR = '/PATH_TO_OVERLAY/'

    (overlay_dict, key_sorted_list) = get_overlay_dict(OVERLAY_DIR)
    # print(overlay_dict, key_sorted_list)
    # print()

    found = False
    # overlay_n is e.g.: overlay_p17
    for overlay_n in key_sorted_list:
        # overlay_util_pickle_file = overlay_dict[overlay_n]
        # with open(overlay_util_pickle_file, 'rb') as handle:
        #   overlay_util_dict = pickle.load(handle)
        overlay_util_json_file = overlay_dict[overlay_n]
        with open(overlay_util_json_file, 'r') as infile:
            overlay_util_dict = json.load(infile)

        # print("overlay_util_dict are: ")
        # print(overlay_util_dict)
        # e.g.: overlay_util_dict = {'20': ('8352', '72', '72'), '21': ('7424', '48', '72'), ... }
        # print()
        # last 7 leaves are reserved for t2_1, t2_2, t2_3, t2c_1, t2c_2, t2c_3, tc_all
        # overlay_util_dict = remove_tandem_leaves(overlay_n, overlay_util_dict)

        print(overlay_util_dict)
        if(len(util_dict) <= len(overlay_util_dict)): # num of ops <= num of leaves in the overlay
            (found, assign_dict) = get_assignment(overlay_util_dict, util_dict)
            if(found):
                break # don't search for the overlays with lager number of leaves(n)
        else:
            continue

    if(not found):
        raise Exception("Operators do not fit in any of the pre-generated NoC overlay")

    print(overlay_n, assign_dict)
    # with open('page_assignment.txt', 'w') as file:
    #   file.write(str(assign_dict) + "\n" + overlay_n)

    # with open('page_assignment.pickle', 'wb') as handle:
    #   pickle.dump((overlay_n, assign_dict), handle, protocol=2) # protocol=2 so that python2 can read it

    with open('page_assignment.json', 'w') as outfile:
        json.dump((overlay_n, assign_dict), outfile) # json for human readable file

    timestr = time.strftime("%Y%m%d_%H%M%S")
    with open('page_assignment_'+timestr+'.json', 'w') as outfile: # for the record
        json.dump((overlay_n, assign_dict), outfile)
    
if __name__ == '__main__':
    main()
