import os

# abs_list = ['p2', 'p2_p0', 'p2_p0_p0', 'p2_p0_p1', 'p2_p1', 'p2_p1_p0', 'p2_p1_p1',\

#             'p6', 'p6_p0', 'p6_p0_p0', 'p6_p0_p1', 'p6_p1', 'p6_p1_p0', 'p6_p1_p1',\
#             'p6_p0_p0_p0', 'p6_p0_p0_p1', 'p6_p0_p1_p0', 'p6_p0_p1_p1', 'p6_p1_p0_p0', 'p6_p1_p0_p1', 'p6_p1_p1_p0', 'p6_p1_p1_p1',\

#             'p14', 'p14_p0', 'p14_p0_p0', 'p14_p0_p1', 'p14_p1', 'p14_p1_p0', 'p14_p1_p1',\
#             'p14_p0_p0_p0', 'p14_p0_p0_p1', 'p14_p0_p1_p0', 'p14_p0_p1_p1', 'p14_p1_p0_p0', 'p14_p1_p0_p1', 'p14_p1_p1_p0', 'p14_p1_p1_p1',\

#             'p22', 'p22_p0', 'p22_p0_p0', 'p22_p0_p1', 'p22_p1', 'p22_p1_p0', 'p22_p1_p1',\
#             'p22_p0_p0_p0', 'p22_p0_p0_p1', 'p22_p0_p1_p0', 'p22_p0_p1_p1', 'p22_p1_p0_p0', 'p22_p1_p0_p1', 'p22_p1_p1_p0', 'p22_p1_p1_p1']

abs_list = ['p2', 'p2_p0', 'p2_p1',\
            'p6', 'p6_p0', 'p6_p0_p0', 'p6_p0_p1', 'p6_p1', 'p6_p1_p0', 'p6_p1_p1',\
            'p14', 'p14_p0', 'p14_p0_p0', 'p14_p0_p1', 'p14_p1', 'p14_p1_p0', 'p14_p1_p1',\
            'p22', 'p22_p0', 'p22_p0_p0', 'p22_p0_p1', 'p22_p1', 'p22_p1_p0', 'p22_p1_p1']

directory = './tcl/'

def get_cell(pblock_name):
  lvl_list = pblock_name.split('_')
  page_str = 'page' + lvl_list[0].split('p')[1] + '_inst'
  added_str = ''
  if(len(lvl_list) > 0):
    for elem in lvl_list[1:]:
      added_str = added_str + '/' + elem 
  page_str = page_str + added_str
  return(page_str)

# print(get_cell('p22_p0_p1'))

for f in abs_list:
  filedata = ''
  f_name = 'pr_recombine_' + f + '.tcl'
  with open(directory + f_name, "w") as file:
    abs_name = f
    page_cell = get_cell(f)
    filedata = 'open_checkpoint ./checkpoint/sub_p22_p1_p1/p22_p1_p1_subdivide_route_design.dcp\n'+\
    'pr_recombine -cell pfm_top_i/dynamic_region/ydma_1/' + page_cell + '\n' +\
    'write_checkpoint -force ./checkpoint/sub_' + f + '/' + f + '_subdivide_recombined.dcp' + '\n'+\
    'write_bitstream -force -cell pfm_top_i/dynamic_region/ydma_1/' + page_cell + ' ./checkpoint/' + f + '_subdivide.bit\n'+\
    'write_abstract_shell -force -cell pfm_top_i/dynamic_region/ydma_1/' + page_cell + ' ./checkpoint/' + f + '\n'+\
    'report_utilization -pblocks ' + f +' > ./checkpoint/utilization_' + f + '.rpt\n'+\
    'close_project'
    file.write(filedata)