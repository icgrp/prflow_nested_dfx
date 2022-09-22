import os, argparse, json, time, sys
sys.path.append('../../pr_flow')
from p23_pblock import pblock_page_dict, LUT_MARGIN_single_dict, LUT_MARGIN_double_dict, LUT_MARGIN_quad_dict, \
                       BRAM_MARGIN_EXTRA_single_dict, BRAM_MARGIN_EXTRA_double_dict
#from natsort import natsorted

parser = argparse.ArgumentParser()
parser.add_argument('-prj',       '--project_name',        help="operators directory")
args = parser.parse_args()

RAM_DSP_MARGIN_SINGLE = 0.1
RAM_DSP_MARGIN_DOUBLE = 0.1
RAM_DSP_MARGIN_QUAD = 0.1

def get_page_size(pblock_name):
    return len(pblock_page_dict[pblock_name])


def get_overlay_util_dict(overlay_util_dict):
    overlay_util_dict_single = {}
    overlay_util_dict_double = {}
    overlay_util_dict_quad = {}
    for pblock in overlay_util_dict:
        if(get_page_size(pblock) == 1):
            overlay_util_dict_single[pblock] = overlay_util_dict[pblock]
        elif(get_page_size(pblock) == 2):
            overlay_util_dict_double[pblock] = overlay_util_dict[pblock]
        elif(get_page_size(pblock) == 4):
            overlay_util_dict_quad[pblock] = overlay_util_dict[pblock]
    return overlay_util_dict_single, overlay_util_dict_double, overlay_util_dict_quad


# returns whether the operator fits in the page
def is_fit(op_resource_tuple, overlay_resource_tuple, pblock_name):
    [num_clb, num_ram36, num_ram18, num_dsp] = op_resource_tuple
    [num_clb_overlay, num_ram36_overlay, num_ram18_overlay, num_dsp_overlay] = overlay_resource_tuple
    num_clb, num_ram36, num_ram18, num_dsp = int(num_clb), int(num_ram36), int(num_ram18), int(num_dsp)
    num_clb_overlay, num_ram36_overlay, num_ram18_overlay, num_dsp_overlay = \
                int(num_clb_overlay), int(num_ram36_overlay), int(num_ram18_overlay), int(num_dsp_overlay)

    pblock_pages = pblock_page_dict[pblock_name]
    pblock_size = len(pblock_pages)

    if(pblock_size == 1):
        LUT_MARGIN = LUT_MARGIN_single_dict[pblock_name]
    elif(pblock_size == 2):
        LUT_MARGIN = LUT_MARGIN_double_dict[pblock_name]
    elif(pblock_size == 4):
        LUT_MARGIN = LUT_MARGIN_quad_dict[pblock_name]
    else:
        raise Exception("Invalid pblock size")

    if(pblock_size == 1):
        RAM_DSP_MARGIN = RAM_DSP_MARGIN_SINGLE + BRAM_MARGIN_EXTRA_single_dict[pblock_name]
    elif(pblock_size == 2):
        RAM_DSP_MARGIN = RAM_DSP_MARGIN_DOUBLE + BRAM_MARGIN_EXTRA_double_dict[pblock_name]
    elif(pblock_size == 4):
        RAM_DSP_MARGIN = RAM_DSP_MARGIN_QUAD
    else:
        raise Exception("Invalid pblock size")

    # print(RAM_DSP_MARGIN)
    # print(num_dsp)
    # print(num_dsp_overlay)
    resource_condition = ((num_clb * (1+LUT_MARGIN) < num_clb_overlay) and \
                            num_ram36 * (1+RAM_DSP_MARGIN) <= num_ram36_overlay and \
                            num_ram18 * (1+RAM_DSP_MARGIN) <= num_ram18_overlay and \
                            num_dsp * (1+RAM_DSP_MARGIN) <= num_dsp_overlay)
    return resource_condition

# returns False if the page is occupied by different operator
def is_valid_pblock(page_valid_dict, pblock_name):
    pblock_pages = pblock_page_dict[pblock_name]
    for page in pblock_pages:
        if(page_valid_dict[page] is not None):
            return False
    return True

def get_tightest_pblock(op_resource_tuple, overlay_util_dict, possible_pblock_list):
    [num_clb, num_ram36, num_ram18, num_dsp] = op_resource_tuple
    num_clb, num_ram36, num_ram18, num_dsp = int(num_clb), int(num_ram36), int(num_ram18), int(num_dsp)
    pblock_ratio_dict = {} # contains tightness ratio for each pblock
    for pblock_name in possible_pblock_list:
        overlay_resource_tuple = overlay_util_dict[pblock_name]
        [num_clb_overlay, num_ram36_overlay, num_ram18_overlay, num_dsp_overlay] = overlay_resource_tuple
        num_clb_overlay, num_ram36_overlay, num_ram18_overlay, num_dsp_overlay = \
                    int(num_clb_overlay), int(num_ram36_overlay), int(num_ram18_overlay), int(num_dsp_overlay)
        LUT_percent = float(num_clb) / num_clb_overlay 
        BRAM_percent = float(num_ram18) / num_ram18_overlay 
        DSP_percent = float(num_dsp) / num_dsp_overlay
        pblock_ratio_dict[pblock_name] = LUT_percent + BRAM_percent + DSP_percent
    # print(pblock_ratio_dict)

    return max(pblock_ratio_dict, key=pblock_ratio_dict.get) # returns tightest pblock

# updates page_valid_dict and pblock_assign_dict
def update_assignment(overlay_util_dict, pblock_op, op_resource_tuple, page_valid_dict, pblock_assign_dict, pblock_assign_dict_prev):
    # iterate through overlay_util_dict's page_num in ascending order
    # We don't need to, but for the debuging purposes..
    possible_pblock_list = []
    for pblock_name in sorted(overlay_util_dict.keys()):
        overlay_resource_tuple = overlay_util_dict[pblock_name]
        # print(pblock_name, overlay_resource_tuple)


        if(is_fit(op_resource_tuple, overlay_resource_tuple, pblock_name) and is_valid_pblock(page_valid_dict, pblock_name)):
            # pblock_assign_dict[pblock_op] = pblock_name
            # pblock_pages = pblock_page_dict[pblock_name]
            # for page in pblock_pages:
            #     page_valid_dict[page] = pblock_op
            # # don't go to next pblock_name
            # break
            possible_pblock_list.append(pblock_name)

    # print(possible_pblock_list)

    if(possible_pblock_list): # if not empty
        if(pblock_assign_dict_prev is not None and pblock_op in pblock_assign_dict_prev):
            pblock_prev = pblock_assign_dict_prev[pblock_op]
            if(pblock_prev in possible_pblock_list):
                pblock_name_final = pblock_assign_dict_prev[pblock_op] # prioritize previously assigned pblock if any
            else:
                pblock_name_final = get_tightest_pblock(op_resource_tuple, overlay_util_dict, possible_pblock_list)
        else:
            pblock_name_final = get_tightest_pblock(op_resource_tuple, overlay_util_dict, possible_pblock_list)
        # print(pblock_name_final)
        pblock_assign_dict[pblock_op] = pblock_name_final
        pblock_pages = pblock_page_dict[pblock_name_final]
        for page in pblock_pages:
            page_valid_dict[page] = pblock_op


def is_assigned_all(pblock_assign_dict, pblock_operators_list):
    for pblock_op in pblock_operators_list:
        if(pblock_op not in pblock_assign_dict):
            return False
    return True

# add criterial to util_dict based on resource usage
def add_criteria_util_dict(util_dict):
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
    for key, value in util_dict.items():
        [num_clb, num_ram36, num_ram18, num_dsp] = value
        num_clb, num_ram18, num_dsp = int(num_clb), int(num_ram18), int(num_dsp) # ignore num_ram36
        LUT_percent = float(num_clb) / total_LUT 
        BRAM_percent = float(num_ram18) / total_BRAM 
        DSP_percent = float(num_dsp) / total_DSP
        criteria = LUT_percent + BRAM_percent + DSP_percent
        # print(criteria)
        util_dict[key] = (value, criteria)
    return util_dict

def get_num_op(operator):
    return len(operator.split())

def get_page_assign_dict(pblock_assign_dict):
    page_assign_dict = {}
    for pblock_op in pblock_assign_dict: # pblock_op is space splitted string, e.g.: "coloringFB_bot_m coloringFB_top_m"
        # print(pblock_op)
        # print(get_num_op(pblock_op))
        if(get_num_op(pblock_op) == 1):
            pblock_name = pblock_assign_dict[pblock_op]
            pages = pblock_page_dict[pblock_name]
            min_page = str(min(int(p) for p in pages))
            page_assign_dict[pblock_op] = min_page
        else:
            pblock_name = pblock_assign_dict[pblock_op]
            pages = pblock_page_dict[pblock_name]
            # print(pages)
            # print(pblock_op)
            for sub_op in pblock_op.split():
                min_page = str(min(int(p) for p in pages))
                page_assign_dict[sub_op] = min_page
                pages.remove(min_page)
    return page_assign_dict

# convert pblock_assign_dict's key(tuple) to space splitted string
def convert_key_str(pblock_assign_dict):
    pblock_assign_dict_key_str = {}
    for op_tuple, pblock_name in pblock_assign_dict.items():
        op_str = " ".join(op_tuple)
        pblock_assign_dict_key_str[op_str] = pblock_name
    return pblock_assign_dict_key_str

def get_util_dict(pblock_operators_list):
    util_dict = {}
    for pblock_op in pblock_operators_list:
        pblock_op_list = pblock_op.split()
        if(len(pblock_op_list) == 1):
            with open('./' + pblock_op_list[0] + '/utilization.rpt', 'r') as file:
                for line in file:
                    if(line.startswith('| leaf')):
                        # print(line.split())
                        num_clb = str(line.split()[5])
                        num_ram36 = str(line.split()[15])
                        num_ram18 = str(int(line.split()[15])*2 + int(line.split()[17]))
                        num_dsp = str(line.split()[21])
                        # print(num_clb, num_ram18, num_dsp)
                        util_dict[pblock_op] = (num_clb, num_ram36, num_ram18, num_dsp)
        else: # multiple ops in a single page
            (num_clb, num_ram36, num_ram18, num_dsp) = (0, 0, 0, 0)
            for sub_op in pblock_op_list:
                # print(sub_op)
                with open('./' + sub_op + '/utilization.rpt', 'r') as file:
                    for line in file:
                        if(line.startswith('| leaf')):
                            # print(line.split())
                            num_clb = int(line.split()[5]) + num_clb
                            num_ram36 = int(line.split()[15]) + num_ram36
                            num_ram18 = int(line.split()[15])*2 + int(line.split()[17]) + num_ram18
                            num_dsp = int(line.split()[21]) + num_dsp
            util_dict[pblock_op] = (num_clb, num_ram36, num_ram18, num_dsp)
    return util_dict

def get_pblock_operators_list(project_name):
    pblock_ops_dir = './../../input_src/' + project_name + '/operators'
    with open(pblock_ops_dir + '/pblock_operators_list.json', 'r') as infile:
        pblock_operators_list = json.load(infile)
    # print(pblock_operators_list)
    # temp_list = [tuple(pblock_op.split()) for pblock_op in pblock_operators_list]
    # pblock_operators_list = temp_list
    return pblock_operators_list

def main():
    
    project_name = args.project_name

    pblock_operators_list = get_pblock_operators_list(project_name)
    print(pblock_operators_list)
    #e.g. pblock_operators_list = ["coloringFB_bot_m coloringFB_top_m", "data_redir_m", ... , "zculling_top"]

    util_dict = get_util_dict(pblock_operators_list)
    # print(util_dict)
    # e.g.: at this point, util_dict = {"coloringFB_bot_m coloringFB_top_m": ('8839', '31', '0'), 
    #                                   "data_transfer": ('2303', '7', '6'), ... }
    util_dict = add_criteria_util_dict(util_dict)
    # print(util_dict)
    # e.g.: at this point, util_dict = {"coloringFB_bot_m, coloringFB_top_m": (('8839', '31', '0'), 0.049), 
    #                                   "data_transfer": (('2303', '7', '6'), 0.014), ... }

    # OVERLAY_DIR will be updated in syn.py
    OVERLAY_DIR = '/PATH_TO_OVERLAY/'
    # OVERLAY_DIR = '/home/dopark/workspace/zcu102_tuning/prflow_riscv/workspace/F001_overlay/ydma/zcu102/zcu102_dfx_manual/'

    overlay_util_json_file = OVERLAY_DIR + 'overlay_p23/util_all.json'
    with open(overlay_util_json_file, 'r') as infile:
        overlay_util_dict = json.load(infile)

    #for elem in natsorted(overlay_util_dict.keys()):
    #    print(elem + ' '+ overlay_util_dict[elem][0] + \
    #                 ' '+ overlay_util_dict[elem][1] + \
    #                 ' '+ overlay_util_dict[elem][2] + \
    #                 ' '+ overlay_util_dict[elem][3])

    # print(util_dict)
    for elem in util_dict:
        print(str(util_dict[elem][0]))

    overlay_util_dict_single, overlay_util_dict_double, overlay_util_dict_quad = \
        get_overlay_util_dict(overlay_util_dict)



    # 1) load previous pblock_assignment.json and page_assignment.json, and find out ops that don't fit
    # 2) if everything maps well, pass. if there exist ops that don't map, try to map those ops to unoccupied pblocks
    # 3) if don't map, start over again but prioritize previously mapped pblock

    # Incremental pblock assignment
    if(os.path.exists('./pblock_assignment.json') and os.path.exists('./page_assignment.json')):
        page_valid_dict = {'2': None, '3': None, '4': None, '5': None, '6': None, '7': None, '8': None, 
            '9': None, '10': None, '11': None, '12': None, '13': None, '14': None, '15': None, '16': None, 
            '17': None, '18': None, '19': None, '20': None, '21': None, '22': None, '23': None}
        pblock_assign_dict = {}

        with open('./pblock_assignment.json', 'r') as infile:
            (overlay_n, pblock_assign_dict_prev) = json.load(infile)
        with open('./page_assignment.json', 'r') as infile:
            (overlay_n, page_num_dict_prev) = json.load(infile)

        dont_fit_op_list = []
        for pblock_op, value in sorted(util_dict.items(), key=lambda x:x[1][1], reverse=True): # sorted by criteria
            op_resource_tuple = value[0]
            # print(pblock_op, op_resource_tuple)
            if(pblock_op in pblock_assign_dict_prev.keys()):
                pblock_name = pblock_assign_dict_prev[pblock_op]
                overlay_resource_tuple = overlay_util_dict[pblock_name]

                if(not is_fit(op_resource_tuple, overlay_resource_tuple, pblock_name)):
                    dont_fit_op_list.append(pblock_op)
            else: # new op
                dont_fit_op_list.append(pblock_op)

        # restore page_valid_dict and pblock_assign_dict, don't include ops that don't fit or disappered
        for pblock_op in pblock_operators_list:
            if(pblock_op not in dont_fit_op_list):
                pblock_name = pblock_assign_dict_prev[pblock_op]
                pblock_pages = pblock_page_dict[pblock_name]
                for page in pblock_pages:
                    page_valid_dict[page] = pblock_op
                pblock_assign_dict[pblock_op] = pblock_name

        # print(dont_fit_op_list)
        # Assign ops that don't fit to the previous pblocks
        for pblock_op, value in sorted(util_dict.items(), key=lambda x:x[1][1], reverse=True): # sorted by criteria
            if(pblock_op in dont_fit_op_list):
                op_resource_tuple = value[0]

                pblock_op_list = pblock_op.split()
                num_op = len(pblock_op_list)
                if(num_op == 1):
                    update_assignment(overlay_util_dict_single, pblock_op, op_resource_tuple, page_valid_dict, pblock_assign_dict, None)
                if(num_op <= 2 and not pblock_op in pblock_assign_dict):
                    update_assignment(overlay_util_dict_double, pblock_op, op_resource_tuple, page_valid_dict, pblock_assign_dict, None)
                if(num_op <= 4 and not pblock_op in pblock_assign_dict):
                    update_assignment(overlay_util_dict_quad, pblock_op, op_resource_tuple, page_valid_dict, pblock_assign_dict, None)

        # print(pblock_assign_dict)
        # if the incremental pblock assignment failed, start the pblock assignment from the beginning
        if(not is_assigned_all(pblock_assign_dict, pblock_operators_list)):
            page_valid_dict = {'2': None, '3': None, '4': None, '5': None, '6': None, '7': None, '8': None, 
                '9': None, '10': None, '11': None, '12': None, '13': None, '14': None, '15': None, '16': None, 
                '17': None, '18': None, '19': None, '20': None, '21': None, '22': None, '23': None}
            pblock_assign_dict = {}

            # iterate through util_dict's pblock_op in descending order of resource usage
            # iterate through overlay_util_dict's page_num in ascending order
            for pblock_op, value in sorted(util_dict.items(), key=lambda x:x[1][1], reverse=True): # sorted by criteria
                op_resource_tuple = value[0]
                # print(pblock_op, op_resource_tuple)

                pblock_op_list = pblock_op.split()
                num_op = len(pblock_op_list)
                if(num_op == 1):
                    update_assignment(overlay_util_dict_single, pblock_op, op_resource_tuple, page_valid_dict, pblock_assign_dict, pblock_assign_dict_prev)
                if(num_op <= 2 and not pblock_op in pblock_assign_dict):
                    update_assignment(overlay_util_dict_double, pblock_op, op_resource_tuple, page_valid_dict, pblock_assign_dict, pblock_assign_dict_prev)
                if(num_op <= 4 and not pblock_op in pblock_assign_dict):
                    update_assignment(overlay_util_dict_quad, pblock_op, op_resource_tuple, page_valid_dict, pblock_assign_dict, pblock_assign_dict_prev)

    else: #if it's 1st assignment
        page_valid_dict = {'2': None, '3': None, '4': None, '5': None, '6': None, '7': None, '8': None, 
            '9': None, '10': None, '11': None, '12': None, '13': None, '14': None, '15': None, '16': None, 
            '17': None, '18': None, '19': None, '20': None, '21': None, '22': None, '23': None}
        pblock_assign_dict = {}

        # iterate through util_dict's pblock_op in descending order of resource usage
        # iterate through overlay_util_dict's page_num in ascending order
        for pblock_op, value in sorted(util_dict.items(), key=lambda x:x[1][1], reverse=True): # sorted by criteria
            op_resource_tuple = value[0]
            # print(pblock_op, op_resource_tuple)

            pblock_op_list = pblock_op.split()
            num_op = len(pblock_op_list)
            if(num_op == 1):
                update_assignment(overlay_util_dict_single, pblock_op, op_resource_tuple, page_valid_dict, pblock_assign_dict, None)
            if(num_op <= 2 and not pblock_op in pblock_assign_dict):
                update_assignment(overlay_util_dict_double, pblock_op, op_resource_tuple, page_valid_dict, pblock_assign_dict, None)
            if(num_op <= 4 and not pblock_op in pblock_assign_dict):
                update_assignment(overlay_util_dict_quad, pblock_op, op_resource_tuple, page_valid_dict, pblock_assign_dict, None)

    print(pblock_assign_dict)
    # print(pblock_operators_list)
    if(not is_assigned_all(pblock_assign_dict, pblock_operators_list)):
        raise Exception("Operators do not fit in any of the pre-generated NoC overlay")

    overlay_n = 'overlay_p23'
    # pblock_assign_dict = convert_key_str(pblock_assign_dict)
    # print(overlay_n, pblock_assign_dict)
    # e.g.: pblock_assign_dict = {"coloringFB_bot_m coloringFB_top_m": 'p2', ...}

    page_assign_dict = get_page_assign_dict(pblock_assign_dict)

    # In pblock_assignment, both "coloringFB_bot_m" and "coloringFB_top_m" belong to the same pblock, p2
    with open('pblock_assignment.json', 'w') as outfile:
        json.dump((overlay_n, pblock_assign_dict), outfile)

    # In page_assignment, "coloringFB_bot_m" and "coloringFB_top_m" have separate port, '2' and '3'
    with open('page_assignment.json', 'w') as outfile:
        json.dump((overlay_n, page_assign_dict), outfile)

    print(page_valid_dict)

    # For incremental compile, let each operator to have separate .json file
    for op_impl in pblock_assign_dict:
        ops = op_impl.split()
        for op in ops:
            pblock_name = pblock_assign_dict[op_impl]
            page_num = page_assign_dict[op]
            # IMPORTANT!, changes pblock.json only when the contents have been changed
            if(os.path.exists('./' + op + '/pblock.json')):
                with open('./' + op + '/pblock.json', 'r') as infile:
                    (overlay_n_old, pblock_name_old, page_num_old) = json.load(infile)
                if(overlay_n != overlay_n_old or pblock_name != pblock_name_old or page_num != page_num_old):
                    with open('./' + op + '/pblock.json', 'w') as outfile:
                        json.dump((overlay_n, pblock_name, page_num), outfile)
            else: # first time
                with open('./' + op + '/pblock.json', 'w') as outfile:
                    json.dump((overlay_n, pblock_name, page_num), outfile)

    # timestr = time.strftime("%Y%m%d_%H%M%S")
    # with open('pblock_assignment_'+timestr+'.json', 'w') as outfile: # for the record
    #     json.dump((overlay_n, pblock_assign_dict), outfile)


if __name__ == '__main__':
    main()
