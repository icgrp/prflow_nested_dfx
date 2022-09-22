import os.path
from natsort import natsorted
import math
import json

clockregion_resource_dict = {'X0Y3': ['{SLICE_X0Y180:SLICE_X28Y239}',\
                                      '{DSP48E2_X0Y72:DSP48E2_X5Y95}',\
                                      '{RAMB18_X0Y72:RAMB18_X3Y95}',\
                                      '{RAMB36_X0Y36:RAMB36_X3Y47}'],
                             'X0Y4': ['{SLICE_X0Y240:SLICE_X28Y299}',\
                                      '{DSP48E2_X0Y96:DSP48E2_X5Y119}',\
                                      '{RAMB18_X0Y96:RAMB18_X3Y119}',\
                                      '{RAMB36_X0Y48:RAMB36_X3Y59}'],
                             'X0Y5': ['{SLICE_X0Y300:SLICE_X28Y359}',\
                                      '{DSP48E2_X0Y120:DSP48E2_X5Y143}',\
                                      '{RAMB18_X0Y120:RAMB18_X3Y143}',\
                                      '{RAMB36_X0Y60:RAMB36_X3Y71}'],
                             'X0Y6': ['{SLICE_X0Y360:SLICE_X28Y419}',\
                                      '{DSP48E2_X0Y144:DSP48E2_X5Y167}',\
                                      '{RAMB18_X0Y144:RAMB18_X3Y167}',\
                                      '{RAMB36_X0Y72:RAMB36_X3Y83}']}
pblock_page_dict = {
            'p4': ['4','5','6','7'], 
            'p8': ['8','9','10','11'],
            'p12': ['12','13','14','15'],
            'p16': ['16','17','18','19'],
            'p20': ['20','21','22','23'],

            'p2': ['2','3'], 
            'p4_p0': ['4','5'], 'p4_p1': ['6','7'],
            'p8_p0': ['8','9'], 'p8_p1': ['10','11'], 
            'p12_p0': ['12','13'], 'p12_p1': ['14','15'], 
            'p16_p0': ['16','17'], 'p16_p1': ['18','19'],
            'p20_p0': ['20','21'], 'p20_p1': ['22','23'],

            'p2_p0': ['2'], 'p2_p1': ['3'],
            'p4_p0_p0': ['4'], 'p4_p0_p1': ['5'], 'p4_p1_p0': ['6'], 'p4_p1_p1': ['7'],
            'p8_p0_p0': ['8'], 'p8_p0_p1': ['9'], 'p8_p1_p0': ['10'], 'p8_p1_p1': ['11'],
            'p12_p0_p0': ['12'], 'p12_p0_p1': ['13'], 'p12_p1_p0': ['14'], 'p12_p1_p1': ['15'],
            'p16_p0_p0': ['16'], 'p16_p0_p1': ['17'], 'p16_p1_p0': ['18'], 'p16_p1_p1': ['19'],
            'p20_p0_p0': ['20'], 'p20_p0_p1': ['21'], 'p20_p1_p0': ['22'], 'p20_p1_p1': ['23']
}

clock_boundary_Y = {59, 60, 119, 120, 179, 180, 239, 240, 299, 300, 359, 360}

def is_in_range(range_list, loc):
    loc_x = int(loc.split('Y')[0].split('X')[1])
    loc_y = int(loc.split('Y')[1])
    for range_elem in range_list:
        [loc_s, loc_e] = range_elem.split(':')
        loc_s_x = int(loc_s.split('Y')[0].split('X')[1])
        loc_s_y = int(loc_s.split('Y')[1])
        loc_e_x = int(loc_e.split('Y')[0].split('X')[1])
        loc_e_y = int(loc_e.split('Y')[1])
        if((loc_s_x <= loc_x <= loc_e_x) and (loc_s_y <= loc_y <= loc_e_y)):
            return True
    return False

# returns 'SLICE' from ['SLICE_X33Y190:SLICE_X33Y239', 'SLICE_X16Y180:SLICE_X32Y239']
def get_resource_type(resource_range_list):
    return resource_range_list[0].split('_')[0] 

# returns 'X57Y185' from 'SLICE_X57Y185/GFF2' or
# returns 'X57Y185' from 'SLICE_X57Y185 \\'
def get_loc_tcl(line):
    if('/' in line):
        return line.split('/')[0].split('_')[1]
    else:
        return line.split('\\')[0].strip().split('_')[1]


# returns 'X28Y217/B' from ''SLICE_X28Y217/B6LUT \\''
def get_lut_loc(line):
    tile_loc = line.split('/')[0].split('_')[1]
    lut_idx = line.split('/')[1]
    lut_idx = lut_idx[0]
    return tile_loc + '/' + lut_idx


# returns [X33Y190:X33Y239, X16Y180:X32Y239] from {SLICE_X33Y190:SLICE_X33Y239 SLICE_X16Y180:SLICE_X32Y239}
def get_range_xdc(resource_range_list):
    range_list = []
    for range_elem in resource_range_list:
        [loc_s, loc_e] = range_elem.split(':')
        loc_s = loc_s.split('_')[1]
        loc_e = loc_e.split('_')[1]
        range_list.append(loc_s + ':' + loc_e)
    return range_list

def include_condition(line):
    if(('CARRY8' in line) or ('MUX' in line) or ('FF' in line)):
        return False
    else:
        return True

# remove unnecessary lines

        pre_process(blocked_file, blocked_sites_file, blocked_file_short)

def pre_process(blocked_file, blocked_sites_file, blocked_file_short):
    lines_seen = set() # holds lines already seen
    outfile = open(blocked_file_short, "w")
    for line in open(blocked_file, "r"):
        if (line not in lines_seen and include_condition(line)): # not a duplicate
            outfile.write(line)
            lines_seen.add(line)
    for line in open(blocked_sites_file, "r"):
        if (line not in lines_seen and include_condition(line)\
                and not line.startswith(' set mysites')\
                and not line.startswith('select_objects')):
            outfile.write(line)
            lines_seen.add(line)
    outfile.close()


def update_seen_slice_loc_list(line, seen_lut_loc_list):
    lut_loc = get_lut_loc(line) # e.g. X16Y221/H
    # make sure that we don't double count 'SLICE_X16Y221/H5LUT' and 'SLICE_X16Y221/H6LUT
    if(lut_loc not in seen_lut_loc_list):
        seen_lut_loc_list.append(lut_loc)
    else:
        # print(lut_loc + ' is already in')
        pass


def update_seen_dsp_loc_list(line, seen_loc_list):
    loc = get_loc_tcl(line)
    # if one elem in DSP is blocked, then mark the DSP tile unavailable
    if(loc not in seen_loc_list):
        seen_loc_list.append(loc)

def update_seen_ram_loc_list(line, seen_loc_list):
    loc = get_loc_tcl(line)
    if(loc not in seen_loc_list):
        seen_loc_list.append(loc)


def gen_pblock_resource_dict(xdc_files):
    pblock_resource_dict = {}
    for xdc_file in xdc_files:        
        with open(xdc_file, 'r') as file:
            for line in file:
                if(line.startswith('create_pblock')):
                    pblock_name = line.split()[1]
                    # print(pblock_name)
                    if(pblock_name != 'p_bft'):
                        pblock_resource_dict[pblock_name] = {}
                elif(line.startswith('resize_pblock')):
                    pblock_name = line.strip().split('-add ')[0].split('get_pblocks ')[1].split(']')[0]
                    if(pblock_name != 'p_bft'):
                        resource_range_list = line.strip().split('-add ')[1].replace('{','').replace('}','').split()
                        # print(resource_range_list)
                        resource_type = get_resource_type(resource_range_list)
                        if(resource_type not in pblock_resource_dict[pblock_name]):
                            range_list = get_range_xdc(resource_range_list)
                            pblock_resource_dict[pblock_name][resource_type] = range_list
                        else:
                            range_list = get_range_xdc(resource_range_list)
                            pblock_resource_dict[pblock_name][resource_type] += range_list
                        # print(resource_type)
    return pblock_resource_dict

# e.g. returns ['X0Y3','X0Y4']
def get_clockregion_list(loc_s,loc_e):
    loc_s_x = int(loc_s.split('Y')[0].split('X')[1])
    loc_s_y = int(loc_s.split('Y')[1])
    loc_e_x = int(loc_e.split('Y')[0].split('X')[1])
    loc_e_y = int(loc_e.split('Y')[1])
    assert(loc_s_x == 0 and loc_e_x == 0)
    clockregion_list = []
    for idx in range(loc_s_y, loc_e_y+1):
        clockregion_list.append('X0Y'+str(idx))
    return clockregion_list

def get_clockregion_resources_lines(pblock_name, clockregion_list):
    new_lines = ''
    for clockregion in clockregion_list:
        new_resources = clockregion_resource_dict[clockregion]
        for elem in new_resources:
            new_lines += 'resize_pblock [get_pblocks ' + pblock_name + '] -add ' + elem + '\n'
    return new_lines

# changes CLOCKREGION into valid data elements in .xdc files
# Currently only supports CLOCKREGION_X0Y3 ~ CLOCKREGION_X0Y6
def pre_process_xdc(target_dir, xdc_dir, xdc_file):
    filedata = ''
    print_flag = False
    with open(xdc_dir + xdc_file, 'r') as file:
        for line in file:
            if(line.startswith('resize_pblock')):
                pblock_name = line.strip().split('-add ')[0].split('get_pblocks ')[1].split(']')[0]
                resource_range_list = line.strip().split('-add ')[1].replace('{','').replace('}','').split()
                # print(resource_range_list)
                resource_type = get_resource_type(resource_range_list)
                if(resource_type == 'CLOCKREGION'):
                    # print(xdc_file)
                    print_flag = True
                    range_list = get_range_xdc(resource_range_list)
                    # TODO: For now, assume that something like 
                    # {CLOCKREGION_X0Y3:CLOCKREGION_X0Y3 CLOCKREGION_X0Y4:CLOCKREGION_X0Y4} does NOT exist
                    loc_s = range_list[0].split(':')[0]
                    loc_e = range_list[0].split(':')[1]
                    clockregion_list = get_clockregion_list(loc_s,loc_e)
                    # print(line)
                    # print(loc_s + ', ' + loc_e)
                    # print(clockregion_list)

                    new_lines = get_clockregion_resources_lines(pblock_name, clockregion_list)
                    line = new_lines
            filedata += line
    if(print_flag):
        # print("----FILE NAME: " + xdc_file)
        # print(filedata)
        pass

    with open(target_dir + xdc_file, "w") as file:
        file.write(filedata)

# returns the number of ramb18 sites whose parent ramb36 sites are NOT blocked
def get_num_ramb18_extra(blocked_resource_loc_dict, pblock_name):
    ramb36_list = blocked_resource_loc_dict[pblock_name]['RAMB36']
    ramb18_list = blocked_resource_loc_dict[pblock_name]['RAMB18']
    count = 0
    for ramb18_loc in ramb18_list:
        loc_x = int(ramb18_loc.split('Y')[0].split('X')[1])
        loc_y = int(ramb18_loc.split('Y')[1])
        ramb36_loc_x = loc_x
        ramb36_loc_y = int(math.floor(loc_y/2))
        ramb36_loc = 'X' + str(ramb36_loc_x) + 'Y' + str(ramb36_loc_y)
        if(ramb36_loc not in ramb36_list):
            count += 1
    return count



def main():

    ## setting starts
    overlay_dir = './../'

    xdc_dir = overlay_dir + 'xdc/nested/'
    # blocked_files = [overlay_dir + 'hd_visual_dir/'  + d + '/blockedBelsOutputs.tcl' \
    #                                         for d in os.listdir(overlay_dir + 'hd_visual_dir/')]
    blocked_files = [overlay_dir + 'hd_visual_dir/hd_visual_p20_p1/blockedBelsOutputs.tcl']


    # blocked_file = overlay_dir + 'hd_visual_dir/hd_visual_p2/' + 'blockedBelsOutputs.tcl'
    # blocked_sites_file = overlay_dir + 'hd_visual_dir/hd_visual_p2/' + 'blockedSitesInputs.tcl'
    ## setting ends

    xdc_files = [f for f in os.listdir(xdc_dir) if f.endswith('.xdc')]
    # print(xdc_files)
    if(not os.path.isdir(xdc_dir + '_xdc')):
        os.mkdir(xdc_dir + '_xdc')
    for xdc_file in xdc_files:
        # xdc_file = xdc_file.split(overlay_dir)[1]
        if(not os.path.isfile(xdc_dir + '_xdc/' + xdc_file)): 
            pre_process_xdc(xdc_dir + '_xdc/', xdc_dir, xdc_file)
        else:
            print("clock_region fixed ver. already exists")
            break
    xdc_files = [(xdc_dir + '_xdc/' + f) for f in os.listdir(xdc_dir + '_xdc/') if f.endswith('.xdc')]


    pblock_resource_dict = gen_pblock_resource_dict(xdc_files)
    print("parse xdc files")
    # print(pblock_resource_dict)
    # {'p8_p0_p0': {'SLICE': ['SLICE_X0Y180:SLICE_X15Y239', 'SLICE_X33Y190:SLICE_X33Y239', 'SLICE_X16Y180:SLICE_X32Y239'], 
    #               'DSP48E2': ...]}}

    # for pblock_name in pblock_resource_dict:
    #     print("####" + pblock_name)
    #     for resource_type in pblock_resource_dict[pblock_name]:
    #         print(resource_type)
    #         print(pblock_resource_dict[pblock_name][resource_type])


    blocked_resource_final_dict = {}
    for blocked_file in natsorted(blocked_files):
        blocked_sites_file = os.path.dirname(blocked_file) + '/blockedSitesInputs.tcl'
        blocked_file_short = blocked_file.split('.tcl')[0] + '_short.tcl'
        print(blocked_file)

        # print(blocked_sites_file)
        # print(blocked_file_short)


        if(not os.path.isfile(blocked_file_short)): 
            pre_process(blocked_file, blocked_sites_file, blocked_file_short)
        else:
            print("short ver. already exists")

        print('--------------------------------------------------')

        blocked_resource_dict = {}
        for pblock_name in pblock_resource_dict:
            blocked_resource_dict[pblock_name] = {}
            blocked_resource_dict[pblock_name]['SLICE'] = []
            blocked_resource_dict[pblock_name]['DSP48E2'] = []
            blocked_resource_dict[pblock_name]['RAMB18'] = []
            blocked_resource_dict[pblock_name]['RAMB36'] = []


        with open(blocked_file_short, 'r') as file:
            for line in file:
                line = line.strip()
                if(line.startswith('DSP48E2')):
                    loc = get_loc_tcl(line)
                    for pblock_name in pblock_resource_dict:
                        # print(pblock_name)
                        if(is_in_range(pblock_resource_dict[pblock_name]['DSP48E2'], loc)):
                            blocked_resource_dict[pblock_name]['DSP48E2'].append(line)
                            # blocked_resource_dict[pblock_name]['DSP48E2'].append(loc)

                elif(line.startswith('SLICE')):
                    loc = get_loc_tcl(line)
                    loc_y = int(loc.split('Y')[1])
                    for pblock_name in pblock_resource_dict:
                        # SLICES on the clock boundary are already blocked, so don't take them into account
                        if(is_in_range(pblock_resource_dict[pblock_name]['SLICE'], loc) and loc_y not in clock_boundary_Y):
                            blocked_resource_dict[pblock_name]['SLICE'].append(line)
                            # blocked_resource_dict[pblock_name]['SLICE'].append(loc)

                elif(line.startswith('RAMB18')):
                    loc = get_loc_tcl(line)
                    # print(loc)
                    for pblock_name in pblock_resource_dict:
                        if(is_in_range(pblock_resource_dict[pblock_name]['RAMB18'], loc)):
                            blocked_resource_dict[pblock_name]['RAMB18'].append(line)
                            # blocked_resource_dict[pblock_name]['RAMB18'].append(loc)

                elif(line.startswith('RAMB36')):
                    loc = get_loc_tcl(line)
                    for pblock_name in pblock_resource_dict:
                        if(is_in_range(pblock_resource_dict[pblock_name]['RAMB36'], loc)):
                            blocked_resource_dict[pblock_name]['RAMB36'].append(line)
                            # blocked_resource_dict[pblock_name]['RAMB36'].append(loc)

        print("add blocked resource to each pblock dict")
        # for pblock_name in blocked_resource_dict:
        #     print("####" + pblock_name)
            # for resource_type in blocked_resource_dict[pblock_name]:
            #     print(resource_type)
            #     print(blocked_resource_dict[pblock_name][resource_type])
            #     print(len(blocked_resource_dict[pblock_name][resource_type]))

        print('--------------------------------------------------')


        blocked_resource_loc_dict = {}
        for pblock_name in pblock_resource_dict:
            blocked_resource_loc_dict[pblock_name] = {}

        for pblock_name in blocked_resource_dict:
            # print(pblock_name)
            for resource_type in blocked_resource_dict[pblock_name]:

                if(resource_type == 'SLICE'):
                    seen_lut_loc_list = []
                    for line in blocked_resource_dict[pblock_name]['SLICE']:
                        update_seen_slice_loc_list(line, seen_lut_loc_list)
                    blocked_resource_loc_dict[pblock_name]['SLICE'] = seen_lut_loc_list

                elif(resource_type == 'DSP48E2'):
                    seen_loc_list = []
                    for line in blocked_resource_dict[pblock_name]['DSP48E2']:
                        update_seen_dsp_loc_list(line, seen_loc_list)
                    blocked_resource_loc_dict[pblock_name]['DSP48E2'] = seen_loc_list

                elif(resource_type == 'RAMB36'):
                    seen_loc_list = []
                    for line in blocked_resource_dict[pblock_name]['RAMB36']:
                        update_seen_ram_loc_list(line, seen_loc_list)
                    blocked_resource_loc_dict[pblock_name]['RAMB36'] = seen_loc_list

                elif(resource_type == 'RAMB18'):
                    seen_loc_list = []
                    for line in blocked_resource_dict[pblock_name]['RAMB18']:
                        update_seen_ram_loc_list(line, seen_loc_list)
                    blocked_resource_loc_dict[pblock_name]['RAMB18'] = seen_loc_list


        print("post-process LUTs, DSPs")
        # for pblock_name in natsorted(blocked_resource_loc_dict.keys()):
        #     print(pblock_name)
        #     for resource_type in blocked_resource_loc_dict[pblock_name]:
        #         # print(resource_type + ': ' + str(len(blocked_resource_loc_dict[pblock_name][resource_type])))
        #         print(resource_type)
        #         print(blocked_resource_loc_dict[pblock_name][resource_type])
        #         # print(len(blocked_resource_loc_dict[pblock_name][resource_type]))
        #     print()

        print('--------------------------------------------------')


        blocked_resource_count_dict = {}
        for pblock_name in pblock_resource_dict:
            blocked_resource_count_dict[pblock_name] = {}

        for pblock_name in natsorted(blocked_resource_loc_dict.keys()):
            # print(pblock_name)
            for resource_type in blocked_resource_loc_dict[pblock_name]:
                if(resource_type == 'SLICE'):
                    blocked_resource_count_dict[pblock_name]['SLICE_LUTs'] = len(blocked_resource_loc_dict[pblock_name][resource_type])
                elif(resource_type == 'DSP48E2'):
                    blocked_resource_count_dict[pblock_name]['DSP48E2'] = len(blocked_resource_loc_dict[pblock_name][resource_type])
                elif(resource_type == 'RAMB36'):
                    blocked_resource_count_dict[pblock_name]['RAMB36'] = len(blocked_resource_loc_dict[pblock_name][resource_type])
                elif(resource_type == 'RAMB18'): # IMPORTANT!
                    num_ramb18_extra = get_num_ramb18_extra(blocked_resource_loc_dict, pblock_name)
                    blocked_resource_count_dict[pblock_name]['RAMB18_extra'] = num_ramb18_extra

        print("count blocked resources")

        print('--------------------------------------------------')

        print(blocked_resource_count_dict)
        with open('blocked_util.json', 'w') as outfile:
            json.dump(blocked_resource_count_dict, outfile) # json for human readable file


        # for pblock_name in natsorted(blocked_resource_count_dict):
        #     # print("####" + pblock_name)
        #     # for resource_type in blocked_resource_count_dict[pblock_name]:
        #     #     print(resource_type + ': ' + str(blocked_resource_count_dict[pblock_name][resource_type]))
        #     # print()
        #     if(len(pblock_page_dict[pblock_name]) == 1): 
        #         print(pblock_name + ', ' + str(blocked_resource_count_dict[pblock_name]['SLICE_LUTs']) +\
        #                             ', ' + str(blocked_resource_count_dict[pblock_name]['RAMB36']) +\
        #                             ', ' + str(blocked_resource_count_dict[pblock_name]['DSP48E2']))
        # for pblock_name in natsorted(blocked_resource_count_dict):
        #     if(len(pblock_page_dict[pblock_name]) == 2): 
        #         print(pblock_name + ', ' + str(blocked_resource_count_dict[pblock_name]['SLICE_LUTs']) +\
        #                             ', ' + str(blocked_resource_count_dict[pblock_name]['RAMB36']) +\
        #                             ', ' + str(blocked_resource_count_dict[pblock_name]['DSP48E2']))
        # for pblock_name in natsorted(blocked_resource_count_dict):
        #     if(len(pblock_page_dict[pblock_name]) == 4): 
        #         print(pblock_name + ', ' + str(blocked_resource_count_dict[pblock_name]['SLICE_LUTs']) +\
        #                             ', ' + str(blocked_resource_count_dict[pblock_name]['RAMB36']) +\
        #                             ', ' + str(blocked_resource_count_dict[pblock_name]['DSP48E2']))
        # print()

    #     subdivide_pblock_name = os.path.dirname(blocked_file).replace(overlay_dir + 'hd_visual_dir/hd_visual_', '')
    #     blocked_resource_final_dict[subdivide_pblock_name] = {}
    #     for pblock_name in natsorted(blocked_resource_count_dict):
    #         if(len(pblock_page_dict[pblock_name]) == 4 or pblock_name == 'p2'):
    #             blocked_resource_final_dict[subdivide_pblock_name][pblock_name] = \
    #                                                 str(blocked_resource_count_dict[pblock_name]['SLICE_LUTs']) +\
    #                                         ', ' + str(blocked_resource_count_dict[pblock_name]['RAMB36']) +\
    #                                         ', ' + str(blocked_resource_count_dict[pblock_name]['DSP48E2'])

    # print(blocked_resource_final_dict)


if __name__ == '__main__':
    main()
