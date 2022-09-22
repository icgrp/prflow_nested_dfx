import os

abs_list = ['p2', 'p2_p0', 'p2_p1',\
            'p4', 'p4_p0', 'p4_p0_p0', 'p4_p0_p1', 'p4_p1', 'p4_p1_p0', 'p4_p1_p1',\
            'p8', 'p8_p0', 'p8_p0_p0', 'p8_p0_p1', 'p8_p1', 'p8_p1_p0', 'p8_p1_p1',\
            'p12', 'p12_p0', 'p12_p0_p0', 'p12_p0_p1', 'p12_p1', 'p12_p1_p0', 'p12_p1_p1',\
            'p16', 'p16_p0', 'p16_p0_p0', 'p16_p0_p1', 'p16_p1', 'p16_p1_p0', 'p16_p1_p1',\
            'p20', 'p20_p0', 'p20_p0_p0', 'p20_p0_p1', 'p20_p1', 'p20_p1_p0', 'p20_p1_p1']

directory = './tcl/abs_analysis/'

for f in abs_list:
  filedata = ''
  f_name = 'abs_analysis_' + f + '.tcl'
  with open(directory + f_name, "w") as file:
    abs_name = f
    filedata = 'open_checkpoint ./checkpoint/' + f + '.dcp\nreport_utilization > ./checkpoint/abs_analysis/' + f + '.rpt\nclose_project'
    file.write(filedata)
