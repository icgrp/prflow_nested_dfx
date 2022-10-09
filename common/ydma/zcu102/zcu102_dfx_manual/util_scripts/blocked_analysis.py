from natsort import natsorted
import json

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

with open('util_all_pre_blocked.json', 'r') as infile:
    util_all_pre_blocked = json.load(infile)
# print(util_all_pre_blocked)
print("util_all_pre_blocked")

for pblock_name in natsorted(util_all_pre_blocked):
    if(len(pblock_page_dict[pblock_name]) == 1): 
        # LUT, RAM36, RAM18, DSP
        print(pblock_name + ', ' + str(util_all_pre_blocked[pblock_name][0]) +\
                            ', ' + str(util_all_pre_blocked[pblock_name][2]) +\
                            ', ' + str(util_all_pre_blocked[pblock_name][3]))
for pblock_name in natsorted(util_all_pre_blocked):
    if(len(pblock_page_dict[pblock_name]) == 2): 
        # LUT, RAM36, RAM18, DSP
        print(pblock_name + ', ' + str(util_all_pre_blocked[pblock_name][0]) +\
                            ', ' + str(util_all_pre_blocked[pblock_name][2]) +\
                            ', ' + str(util_all_pre_blocked[pblock_name][3]))
for pblock_name in natsorted(util_all_pre_blocked):
    if(len(pblock_page_dict[pblock_name]) == 4): 
        # LUT, RAM36, RAM18, DSP
        print(pblock_name + ', ' + str(util_all_pre_blocked[pblock_name][0]) +\
                            ', ' + str(util_all_pre_blocked[pblock_name][2]) +\
                            ', ' + str(util_all_pre_blocked[pblock_name][3]))
print()

with open('blocked_util.json', 'r') as infile:
    blocked_resource_count_dict = json.load(infile)
# print(blocked_resource_count_dict)
print("blocked_resource_count_dict")

for pblock_name in natsorted(blocked_resource_count_dict):
    # print("####" + pblock_name)
    # for resource_type in blocked_resource_count_dict[pblock_name]:
    #     print(resource_type + ': ' + str(blocked_resource_count_dict[pblock_name][resource_type]))
    # print()
    if(len(pblock_page_dict[pblock_name]) == 1): 
        print(pblock_name + ', ' + str(blocked_resource_count_dict[pblock_name]['SLICE_LUTs']) +\
                            ', ' + str(blocked_resource_count_dict[pblock_name]['RAMB36']) +\
                            ', ' + str(blocked_resource_count_dict[pblock_name]['DSP48E2']))
for pblock_name in natsorted(blocked_resource_count_dict):
    if(len(pblock_page_dict[pblock_name]) == 2): 
        print(pblock_name + ', ' + str(blocked_resource_count_dict[pblock_name]['SLICE_LUTs']) +\
                            ', ' + str(blocked_resource_count_dict[pblock_name]['RAMB36']) +\
                            ', ' + str(blocked_resource_count_dict[pblock_name]['DSP48E2']))
for pblock_name in natsorted(blocked_resource_count_dict):
    if(len(pblock_page_dict[pblock_name]) == 4): 
        print(pblock_name + ', ' + str(blocked_resource_count_dict[pblock_name]['SLICE_LUTs']) +\
                            ', ' + str(blocked_resource_count_dict[pblock_name]['RAMB36']) +\
                            ', ' + str(blocked_resource_count_dict[pblock_name]['DSP48E2']))
print()

with open('util_all.json', 'r') as infile:
    util_all = json.load(infile)
# print(util_all)
print("util_all")

for pblock_name in natsorted(util_all):
    if(len(pblock_page_dict[pblock_name]) == 1): 
        # LUT, RAM36, RAM18, DSP
        print(pblock_name + ', ' + str(util_all[pblock_name][0]) +\
                            ', ' + str(util_all[pblock_name][2]) +\
                            ', ' + str(util_all[pblock_name][3]))
for pblock_name in natsorted(util_all):
    if(len(pblock_page_dict[pblock_name]) == 2): 
        # LUT, RAM36, RAM18, DSP
        print(pblock_name + ', ' + str(util_all[pblock_name][0]) +\
                            ', ' + str(util_all[pblock_name][2]) +\
                            ', ' + str(util_all[pblock_name][3]))
for pblock_name in natsorted(util_all):
    if(len(pblock_page_dict[pblock_name]) == 4): 
        # LUT, RAM36, RAM18, DSP
        print(pblock_name + ', ' + str(util_all[pblock_name][0]) +\
                            ', ' + str(util_all[pblock_name][2]) +\
                            ', ' + str(util_all[pblock_name][3]))



# with open('blocked_util_p2.json', 'r') as infile:
#     blocked_resource_count_dict = json.load(infile)
# # print(blocked_resource_count_dict)
# print("blocked_resource_count_dict")

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
