# -*- coding: utf-8 -*-   
# Company: IC group, University of Pennsylvania
# Contributor: Yuanlong Xiao
#
# Create Date: 02/23/2021
# Design Name: overlay
# Project Name: PLD
# Versions: 1.0
# Description: This is a python script to prepare the script for static region 
#              compile for PLD (https://github.com/icgrp/pld2022).
# Dependencies: python2, gen_basic.py hls.py
# Revision:
# Revision 0.01 - File Created
# Revision 0.02 - Update cotents for HiPR
#
# Additional Comments:


import os  
import subprocess
from gen_basic import gen_basic
from hls       import hls

class overlay(gen_basic):
  def __init__(self, prflow_params):
    gen_basic.__init__(self, prflow_params)

  def update_connect_for_hipr(self, connection_list):
    list_out  = []
    for connect in connection_list:
      connect_list = connect.split('->')
      str_ele = connect_list[0].split('.')[0]+'\t'+connect_list[1].split('.')[0]
      # if (str_ele.replace('DMA', '') == str_ele): list_out.append(str_ele) 
      list_out.append(str_ele) 
      #list_out.append(connect_list[0].split('.')[0]+'\t'+connect_list[1].split('.')[0]) 
    # list_out = set(list_out)
    file_out = open(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_hipr/cpp/src/app/connect.txt', 'w')
    for line in list_out: file_out.write(line+'\n')
    file_out.close()

  # create dummy directory for each empty block
  def create_place_holder(self, operators):
    # extract the stream arguments and types (in/out and width) for all the operators
    operator_arg_dict, operator_width_dict = self.dataflow.return_operator_io_argument_dict(operators)

    # extract the variables used in top.cpp 
    operator_var_dict = self.dataflow.return_operator_inst_dict(operators)
   
    # extract the how different operators are connected from top.cpp 
    connection_list=self.dataflow.return_operator_connect_list(operator_arg_dict, operator_var_dict, operator_width_dict)
    # self.update_connect_for_hipr(connection_list)

    # generate Verilog netlist for the dataflow graph
    mono_v_list = self.verilog.return_operator_inst_v_list(operator_arg_dict, connection_list, operator_var_dict, operator_width_dict)

    # write the Verilog netlist to hipr directory
    # self.shell.write_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_hipr/src4level2/ydma_bb/mono.v', mono_v_list)

    # Utilize hls class to prepare the high-level-synthesis work directory
    hls_inst = hls(self.prflow_params)
    for operator in operators.split():
 
      in_width_list, out_width_list = self.dataflow.return_io_width(operator_width_dict[operator], operator_arg_dict[operator])
      is_pr_page, value = self.pragma.return_pragma('./input_src/'+self.prflow_params['benchmark_name']+'/operators/'+operator+'.h', 'HLS_PR') 
      # prepare the hls workspace

      if is_pr_page == True: # if the operator is hipr type, prepare the RTL syn tcl and verilog dummy netlist
        hls_inst.run(operator, self.overlay_dir+'/place_holder', '../../..', ['syn_'+operator+'.tcl', 'syn_'+operator+'_dummy.tcl'])
        self.shell.write_lines(self.overlay_dir+'/place_holder/syn_'+operator+'.tcl', self.tcl.return_syn_page_tcl_list(operator,  [], top_name=operator, hls_src='./'+operator+'_prj/'+operator+'/syn/verilog', dcp_name='netlist.dcp', rpt_name='utilization_'+operator+'.rpt'))
        self.shell.write_lines(self.overlay_dir+'/place_holder/syn_'+operator+'_dummy.tcl', self.tcl.return_syn_page_tcl_list(operator,  [], top_name=operator, hls_src='./'+operator+'_prj/'+operator+'/verilog_dummy', dcp_name=operator+'_netlist.dcp', rpt_name='utilization.rpt'))
        self.shell.write_lines(self.overlay_dir+'/place_holder/'+operator+'_prj/'+operator+'/verilog_dummy/'+operator+'.v', self.verilog.return_place_holder_v_list(operator, in_width_list, out_width_list)) 
      else: # if the operator is noc type, prepare the RTL syn tcl script
        hls_inst.run(operator, self.overlay_dir+'/place_holder', '../../..', ['syn_'+operator+'.tcl'])
        self.shell.write_lines(self.overlay_dir+'/place_holder/syn_'+operator+'.tcl', self.tcl.return_syn_page_tcl_list(operator,  [], top_name=operator, hls_src='./'+operator+'_prj/'+operator+'/syn/verilog', dcp_name=operator+'_netlist.dcp', rpt_name='utilization_'+operator+'.rpt'))


      # write the dummy netlist with only ports definitions to the hipr workspace
      # self.shell.write_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_hipr/src4level2/ydma_bb/'+operator+'.v', self.verilog.return_place_holder_v_list(operator, in_width_list, out_width_list, is_dummy=True)) 

  # run.sh will be used for generating the overlay.dcp 
  def return_run_sh_list_local(self, operators, bft_n, tandem_mode):
    lines_list = []
    lines_list.append('#!/bin/bash -e')
    lines_list.append('#place_holder anchor')
    str_line = 'cd place_holder\n'

    # launch hls for each operator
    operators_list = operators.split()
    for idx, operator in enumerate(operators_list):
      if idx % 8 == 7 or idx+1 == len(operators_list): str_line += './run_'+operator+'.sh\n'
      else: str_line += './run_'+operator+'.sh&\n'
    str_line += 'cd -\n' 

    # launch the vitis compilation for ydma kernel
    lines_list.append(str_line) 
    # if not the 1st overlay gen, remove previously generated utilization*.rpt
    # lines_list.append('rm -rf utilization*.rpt') 

    lines_list.append('cd ydma/'+self.prflow_params['board'])
    lines_list.append('./build.sh')

    # generate the 2nd-level DFX regions 
    if self.prflow_params['overlay_type'] == 'hipr': # generate abstract shell dcps for hipr overlay 
      lines_list.append('cd '+self.prflow_params['board']+'_dfx_hipr')
    else: # generate abstract shell dcps for psnoc overlay
      lines_list.append('cd '+self.prflow_params['board']+'_dfx_manual')
    lines_list.append('source '+self.prflow_params['Xilinx_dir'])
    lines_list.append('make -j$(nproc)')
    lines_list.append('./shell/run_xclbin.sh')

    if(tandem_mode):
      lines_list.append('cp -r ./tandem/ ./overlay_p'+str(bft_n)+'/')
      lines_list.append('cd ./overlay_p'+str(bft_n)+'/tandem/ && ./run_tandem_units.sh')
      lines_list.append('cd ../../')

    lines_list.append('cd ../../../')
    
    # copy the dcps and xclbins from overlay workspace
    # lines_list.append('cp ./ydma/'+self.prflow_params['board']+'/_x/link/int/ydma.xml ./dynamic_region.xml')
    # lines_list.append('cp ./ydma/'+self.prflow_params['board']+'/_x/link/vivado/vpl/prj/prj.runs/impl_1/dynamic_region.bit ./')
    # lines_list.append('./gen_xclbin_'+self.prflow_params['board']+'.sh dynamic_region.bit dynamic_region.xml dynamic_region.xclbin')
    lines_list.append('cp -r ./ydma/'+self.prflow_params['board']+'/package ./ydma/'+self.prflow_params['board']+'/'+\
      self.prflow_params['board']+'_dfx_manual/'+'overlay_p'+str(bft_n)+'/')
    # lines_list.append('cp dynamic_region.xclbin ./ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/'+'overlay_p'+str(bft_n)+'/sd_card/')
    lines_list.append('cp ./ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/'+'overlay_p'+str(bft_n)+'/*.xclbin ./ydma/'+\
      self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/'+'overlay_p'+str(bft_n)+'/package/sd_card')
    # lines_list.append('mv *.rpt ./ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/'+'overlay_p'+str(bft_n)+'/')
    lines_list.append('mv parse_ovly_util.py ./ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/'+'overlay_p'+str(bft_n)+'/')
    lines_list.append('mv get_blocked_resources.py ./ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/'+'overlay_p'+str(bft_n)+'/')
    lines_list.append('cd ./ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/'+'overlay_p'+\
      str(bft_n)+'/ && python get_blocked_resources.py')
    lines_list.append('python parse_ovly_util.py')


    if(tandem_mode):
      lines_list.append('cd ../../../../')
      lines_list.append('cp ./ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/'+'overlay_p'+\
        str(bft_n)+'/tandem/bits/*.xclbin ./ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/'+'overlay_p'+str(bft_n)+'/package/sd_card/')
      # lines_list.append('cp -r ./ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/tandem',\
      #                 ' ./ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/'+'overlay_p'+str(bft_n)+'/')
    return lines_list

 
  def create_shell_file(self, operators, bft_n, tandem_mode):
    # copy the shell script to generate xclbin
    self.shell.cp_file('./common/script_src/gen_xclbin_'+self.prflow_params['board']+'.sh ', self.overlay_dir)

    # generate the shell script to generate the overlay
    self.shell.write_lines(self.overlay_dir+'/run.sh', self.return_run_sh_list_local(operators, bft_n, tandem_mode), True)
    
    # generate the shell script to call run.sh depends on the scheduler.
    # scheduler: slurm, qsub, local 
    self.shell.write_lines(self.overlay_dir+'/main.sh', self.shell.return_main_sh_list(\
                                                       './run.sh', \
                                                       self.prflow_params['back_end'], \
                                                       'NONE',\
                                                       'overlay', \
                                                       self.prflow_params['grid'],  \
                                                       self.prflow_params['email'], \
                                                       self.prflow_params['mem'],  \
                                                       self.prflow_params['maxThreads']), True)
 
  def update_cad_path(self, operators):
    # update the cad path for build.sh
    self.shell.replace_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/build.sh', {'export ROOTFS'      : 'export ROOTFS='+self.prflow_params['ROOTFS']})
    self.shell.replace_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/build.sh', {'export PLATFORM_REPO_PATHS=': 'export PLATFORM_REPO_PATHS='+self.prflow_params['PLATFORM_REPO_PATHS']})
    self.shell.replace_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/build.sh', {'export PLATFORM='   : 'export PLATFORM='+self.prflow_params['PLATFORM']})
    self.shell.replace_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/build.sh', {'xrt_dir'            : 'source '+self.prflow_params['xrt_dir']})
    self.shell.replace_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/build.sh', {'sdk_dir'            : 'source '+self.prflow_params['sdk_dir']})
    self.shell.replace_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/build.sh', {'Xilinx_dir'         : 'source '+self.prflow_params['Xilinx_dir']})
    os.system('chmod +x '+self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/build.sh')

    # replace device definistion in cfg file
    self.shell.replace_lines(self.overlay_dir+'/ydma/src/'+self.prflow_params['board']+'_dfx.cfg', {'platform'         : 'platform='+self.prflow_params['PLATFORM']})

    # replace fifo_512X1024 with mono instance
    # subs_str='\n'
    # subs_str+='mono mono_inst(\n'
    # subs_str+='  .ap_clk(ap_clk),\n'
    # subs_str+='  .ap_rst_n(ap_rst_n),\n'
    # subs_str+='  .Input_1_V_TDATA(Loop_VITIS_LOOP_35_3_proc3_U0_v2_buffer_V_din),\n'
    # subs_str+='  .Input_1_V_TVALID(Loop_VITIS_LOOP_35_3_proc3_U0_v2_buffer_V_write),\n'
    # subs_str+='  .Input_1_V_TREADY(v2_buffer_V_full_n),\n'
    # subs_str+='  .Output_1_V_TDATA(v2_buffer_V_dout),\n'
    # subs_str+='  .Output_1_V_TVALID(v2_buffer_V_empty_n),\n'
    # subs_str+='  .Output_1_V_TREADY(Loop_VITIS_LOOP_36_4_proc4_U0_v2_buffer_V_read),\n'
    # subs_str+='  .ap_start(ap_start)\n'
    # subs_str+=');\n'
    # self.shell.replace_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_hipr/src4level2/ydma_bb/ydma.v', {'ydma_fifo_w512_d1024_A': subs_str})

    # update the second-level definition tcl scripts 
    str_line =  'pr_subdivide -cell '+self.prflow_params['inst_name'].replace('/ydma_1', '') +' -subcells {'
    for operator in operators.split(): str_line += self.prflow_params['inst_name'] + '/mono_inst/'+operator+'_inst '
    str_line += '} ./checkpoint/pfm_dynamic_new_bb.dcp'
    # self.shell.replace_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_hipr/tcl/sub_divided.tcl', {'pr_subdivide': str_line})

    # update the tcl script to place&route the overlay with dummy logic
    str_line = ''
    for operator in operators.split():
      str_line += '      file_out.write(\'set_property SCOPED_TO_CELLS {'+self.prflow_params['inst_name']+'/mono_inst/'+operator+'_inst }  [get_files ../../../../../../../../../place_holder/'+operator+'_netlist.dcp]\\n\')\n'
    # self.shell.replace_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_hipr/python/mk_overlay_tcl.py', {'scope_anchor': str_line})

    str_line = ''
    for operator in operators.split():
      str_line += '      file_out.write(\'add_files ../../../../../../../../../place_holder/'+operator+'_netlist.dcp\\n\')\n'
    # self.shell.replace_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_hipr/python/mk_overlay_tcl.py', {'page.dcp': str_line})
        
    str_line = '      file_out.write(\'link_design -mode default -part '+self.prflow_params['part']+' -reconfig_partitions {'
    for operator in operators.split():
      str_line += self.prflow_params['inst_name']+'/mono_inst/'+operator+'_inst '
    str_line += '} -top '+self.prflow_params['top_name']+'\\n\')'
    # self.shell.replace_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_hipr/python/mk_overlay_tcl.py', {'link_design': str_line})

    str_line = ''
    for operator in operators.split(): str_line += '      file_out.write(\'report_utilization -pblocks '+operator+' > ../../../../../../../../../utilization_'+operator+'.rpt\\n\')\n'
    # self.shell.replace_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_hipr/python/mk_overlay_tcl.py', {'utilization_anchor': str_line})

    # update the DFX region shell targets according to the benchmark in the Makefile
    str_line = 'base_list='
    for operator in operators.split(): str_line += operator+' '
    # self.shell.replace_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_hipr/Makefile', {'base_list=': str_line})
    # self.shell.replace_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_hipr/Makefile', {'vitis_impl_tcl_name=': 'vitis_impl_tcl_name='+self.prflow_params['top_name']})

    # construct the tcl script to generate the abstract shell 
    # for operator in operators.split(): 
    #   self.shell.write_lines(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_hipr/tcl/gen_abs_'+operator+'.tcl',\
    #                          self.tcl.return_gen_abs_tcl_list('./checkpoint/overlay.dcp', self.prflow_params['inst_name']+'/mono_inst/'+operator+'_inst ', './checkpoint/'+operator+'.dcp'))

  def update_resource_pragma(self, operators):
    pragma_dict = {}
    for operator in operators.split():
      is_pr_page, value = self.pragma.return_pragma('./input_src/'+self.prflow_params['benchmark_name']+'/operators/'+operator+'.h', 'HLS_PR') 
      if is_pr_page:
        cls_exist,  value_c = self.pragma.return_pragma('./input_src/'+self.prflow_params['benchmark_name']+'/operators/'+operator+'.h', 'clb') 
        ff_exist,   value_f = self.pragma.return_pragma('./input_src/'+self.prflow_params['benchmark_name']+'/operators/'+operator+'.h', 'ff') 
        bram_exist, value_b = self.pragma.return_pragma('./input_src/'+self.prflow_params['benchmark_name']+'/operators/'+operator+'.h', 'bram') 
        dsp_exist,  value_d = self.pragma.return_pragma('./input_src/'+self.prflow_params['benchmark_name']+'/operators/'+operator+'.h', 'dsp') 
        pragma_dict[operator] = [value_c, value_f, value_b, value_d]

    file_out = open(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_hipr/cpp/src/app/pragma.txt', 'w')
    for key, value in sorted(pragma_dict.items()):
      # print key.ljust(30)+'\t'+'\t'.join(value)+'\n'
      file_out.write(key.ljust(30)+'\t'+'\t'.join(value)+'\n')
    file_out.close()

  def update_makefile_overlay(self, directory, bft_n):
    makefile = directory+'Makefile'
    with open(makefile, "r") as file:
      filedata = file.read()
    filedata = filedata.replace("checkpoint", "overlay_p"+str(bft_n))
    filedata = filedata.replace("_p31", "_p"+str(bft_n))

    # old_str = ("base_list=page2 page3 page4 page5 page6 page7 page8 page9 page10 page11 page12 page13 page14 page15 page16 page17 page18 page19 page20"
    #             " page21 page22 page23 page24 page25 page26 page27 page28 page29 page30 page31")
    # new_pagelist = ["page"+str(n) for n in range(2,int(bft_n)+1)]
    # new_str = ' '.join(new_pagelist)
    # new_str = 'base_list='+new_str
    # filedata = filedata.replace(old_str, new_str)

    filedata = filedata.replace('sub.xdc', 'sub_p'+str(bft_n)+'.xdc')

    with open(makefile, "w") as file:
      file.write(filedata)

  def update_py_overlay(self, directory, bft_n):
    pyfile = directory + 'mk_overlay_tcl.py'
    with open(pyfile, "r") as file:
      filedata = file.read()
    filedata = filedata.replace("/checkpoint", "/overlay_p"+str(bft_n))

    # old_str = ("file_out.write('set_property SCOPED_TO_CELLS { pfm_top_i/dynamic_region/ydma_1/page2_inst pfm_top_i/dynamic_region/ydma_1/page3_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page4_inst pfm_top_i/dynamic_region/ydma_1/page5_inst pfm_top_i/dynamic_region/ydma_1/page6_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page7_inst pfm_top_i/dynamic_region/ydma_1/page8_inst pfm_top_i/dynamic_region/ydma_1/page9_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page10_inst pfm_top_i/dynamic_region/ydma_1/page11_inst pfm_top_i/dynamic_region/ydma_1/page12_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page13_inst pfm_top_i/dynamic_region/ydma_1/page14_inst pfm_top_i/dynamic_region/ydma_1/page15_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page16_inst pfm_top_i/dynamic_region/ydma_1/page17_inst pfm_top_i/dynamic_region/ydma_1/page18_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page19_inst pfm_top_i/dynamic_region/ydma_1/page20_inst pfm_top_i/dynamic_region/ydma_1/page21_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page22_inst pfm_top_i/dynamic_region/ydma_1/page23_inst pfm_top_i/dynamic_region/ydma_1/page24_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page25_inst pfm_top_i/dynamic_region/ydma_1/page26_inst pfm_top_i/dynamic_region/ydma_1/page27_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page28_inst pfm_top_i/dynamic_region/ydma_1/page29_inst pfm_top_i/dynamic_region/ydma_1/page30_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page31_inst}")
    # new_page_inst_list = ["pfm_top_i/dynamic_region/ydma_1/page"+str(n) for n in range(2,int(bft_n)+1)]
    # new_page_inst_list = [elem + '_inst' for elem in new_page_inst_list]
    # new_str = ' '.join(new_page_inst_list)
    # new_str = "file_out.write('set_property SCOPED_TO_CELLS { " + new_str + "}"
    # # print(old_str)
    # # print(new_str)
    # filedata = filedata.replace(old_str, new_str)

    # old_str = ("file_out.write('link_design -mode default -part xczu9eg-ffvb1156-2-e -reconfig_partitions {"
    #   "pfm_top_i/dynamic_region/ydma_1/page2_inst pfm_top_i/dynamic_region/ydma_1/page3_inst pfm_top_i/dynamic_region/ydma_1/page4_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page5_inst pfm_top_i/dynamic_region/ydma_1/page6_inst pfm_top_i/dynamic_region/ydma_1/page7_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page8_inst pfm_top_i/dynamic_region/ydma_1/page9_inst pfm_top_i/dynamic_region/ydma_1/page10_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page11_inst pfm_top_i/dynamic_region/ydma_1/page12_inst pfm_top_i/dynamic_region/ydma_1/page13_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page14_inst pfm_top_i/dynamic_region/ydma_1/page15_inst pfm_top_i/dynamic_region/ydma_1/page16_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page17_inst pfm_top_i/dynamic_region/ydma_1/page18_inst pfm_top_i/dynamic_region/ydma_1/page19_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page20_inst pfm_top_i/dynamic_region/ydma_1/page21_inst pfm_top_i/dynamic_region/ydma_1/page22_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page23_inst pfm_top_i/dynamic_region/ydma_1/page24_inst pfm_top_i/dynamic_region/ydma_1/page25_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page26_inst pfm_top_i/dynamic_region/ydma_1/page27_inst pfm_top_i/dynamic_region/ydma_1/page28_inst"
    #   " pfm_top_i/dynamic_region/ydma_1/page29_inst pfm_top_i/dynamic_region/ydma_1/page30_inst pfm_top_i/dynamic_region/ydma_1/page31_inst}")
    # new_page_inst_list = ["pfm_top_i/dynamic_region/ydma_1/page"+str(n) for n in range(2,int(bft_n)+1)]
    # new_page_inst_list = [elem + '_inst' for elem in new_page_inst_list]
    # new_str = ' '.join(new_page_inst_list)
    # new_str = "file_out.write('link_design -mode default -part xczu9eg-ffvb1156-2-e -reconfig_partitions {" + new_str + "}"
    # filedata = filedata.replace(old_str, new_str)

    # filedata = filedata.replace('for p in range(2, 18):','for p in range(2, ' + str(int(bft_n)+1) + '):')

    filedata = filedata.replace('sub.xdc', 'sub_p'+str(bft_n)+'.xdc')

    with open(pyfile, "w") as file:
      file.write(filedata)


  def update_sh_overlay(self, directory, bft_n):
    shellfiles = ['run_gen_pfm_dynamic.sh']
    for shellfile in shellfiles:
      with open(directory + shellfile, "r") as file:
        filedata = file.read()
      filedata = filedata.replace("/checkpoint", "/overlay_p"+str(bft_n))
      with open(directory + shellfile, "w") as file:
        file.write(filedata)

    shellfiles_nested = [f for f in os.listdir(directory+'nested/') if f.endswith('.sh')]
    for shellfile in shellfiles_nested:
      with open(directory + 'nested/' + shellfile, "r") as file:
        filedata = file.read()
      filedata = filedata.replace("/checkpoint", "/overlay_p"+str(bft_n))
      with open(directory + 'nested/' + shellfile, "w") as file:
        file.write(filedata)

  def update_tcl_overlay(self, directory, bft_n):
    # tclfiles = ['empty_pfm_dynamic.tcl','out_of_context_syn_page.tcl','out_of_context_syn_ydma_bb.tcl','replace_sub_module_level1.tcl','sub_divided.tcl']
    # tclfiles = [directory+elem for elem in tclfiles]

    sub_dir_list = ['','leaf_syn/','nested/','page_syn/','subdivide_syn/' ,'abs_analysis/']
    for sub_dir in sub_dir_list:
      tclfiles = [f for f in os.listdir(directory + sub_dir) if f.endswith('.tcl')]

      for tclfile in tclfiles:
        with open(directory + sub_dir + tclfile, "r") as file:
          filedata = file.read()
        filedata = filedata.replace("/checkpoint", "/overlay_p"+str(bft_n))
        with open(directory + sub_dir + tclfile, "w") as file:
          file.write(filedata)

    # tclfiles_nested = [f for f in os.listdir(directory+'nested/') if f.endswith('.tcl')]
    # # print(tclfiles_nested)
    # for tclfile in tclfiles_nested:
    #   with open(directory + 'nested/' + tclfile, "r") as file:
    #     filedata = file.read()
    #   filedata = filedata.replace("/checkpoint", "/overlay_p"+str(bft_n))
    #   with open(directory + 'nested/' + tclfile, "w") as file:
    #     file.write(filedata)


    # tclfile = directory+'sub_divided.tcl'
    # with open(tclfile, "r") as file:
    #   filedata = file.read()
    # old_str = ("pr_subdivide -cell pfm_top_i/dynamic_region -subcells {pfm_top_i/dynamic_region/ydma_1/page2_inst pfm_top_i/dynamic_region/ydma_1/page3_inst"
    #  " pfm_top_i/dynamic_region/ydma_1/page4_inst pfm_top_i/dynamic_region/ydma_1/page5_inst pfm_top_i/dynamic_region/ydma_1/page6_inst pfm_top_i/dynamic_region/ydma_1/page7_inst" 
    #  " pfm_top_i/dynamic_region/ydma_1/page8_inst pfm_top_i/dynamic_region/ydma_1/page9_inst pfm_top_i/dynamic_region/ydma_1/page10_inst pfm_top_i/dynamic_region/ydma_1/page11_inst" 
    #  " pfm_top_i/dynamic_region/ydma_1/page12_inst pfm_top_i/dynamic_region/ydma_1/page13_inst pfm_top_i/dynamic_region/ydma_1/page14_inst pfm_top_i/dynamic_region/ydma_1/page15_inst"
    #  " pfm_top_i/dynamic_region/ydma_1/page16_inst pfm_top_i/dynamic_region/ydma_1/page17_inst pfm_top_i/dynamic_region/ydma_1/page18_inst pfm_top_i/dynamic_region/ydma_1/page19_inst"
    #  " pfm_top_i/dynamic_region/ydma_1/page20_inst pfm_top_i/dynamic_region/ydma_1/page21_inst pfm_top_i/dynamic_region/ydma_1/page22_inst pfm_top_i/dynamic_region/ydma_1/page23_inst"
    #  " pfm_top_i/dynamic_region/ydma_1/page24_inst pfm_top_i/dynamic_region/ydma_1/page25_inst pfm_top_i/dynamic_region/ydma_1/page26_inst pfm_top_i/dynamic_region/ydma_1/page27_inst"
    #  " pfm_top_i/dynamic_region/ydma_1/page28_inst pfm_top_i/dynamic_region/ydma_1/page29_inst pfm_top_i/dynamic_region/ydma_1/page30_inst pfm_top_i/dynamic_region/ydma_1/page31_inst}")
    # new_page_inst_list = ["pfm_top_i/dynamic_region/ydma_1/page"+str(n) for n in range(2,int(bft_n)+1)]
    # new_page_inst_list = [elem + '_inst' for elem in new_page_inst_list]
    # new_str = ' '.join(new_page_inst_list)
    # new_str = "pr_subdivide -cell pfm_top_i/dynamic_region -subcells {" + new_str + "}"
    # filedata = filedata.replace(old_str, new_str)

    # with open(tclfile, "w") as file:
    #   file.write(filedata)


  def update_main_overlay(self, directory, bft_n):
    mainfile = directory+"main.sh"
    with open(mainfile, "r") as file:
      filedata = file.read()

    check_file = './ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/overlay_p'+str(bft_n) + '/overlay.dcp'
    new_str = 'if [ ! -f "' + check_file + '" ]; then ./run.sh "$@"; fi'
    filedata = filedata.replace('./run.sh "$@"', new_str)
 
    with open(mainfile, "w") as file:
      file.write(filedata)


  def update_ydma_bb(self, directory, bft_n):
    ydmabbfile = directory+"ydma_bb.v"
    bft_n = int(bft_n)
    filedata = ''
    with open(ydmabbfile, "r") as file:
      isComment = False
      for line in file:
        # line = line.strip()
        # Handles 'assign dout_leaf*'
        if(line.startswith('assign dout_leaf_')):
          n = line.split('assign dout_leaf_')[1]
          n = int(n.split()[0]) # extract leaf number
          # print(n, line)
          if(n == 0):
            newline = line
          elif(n < bft_n+1):
            newline = '// ' + line
            # print(newline)
          else:
            newline = line
            # print(newline)
        elif(line.startswith('// assign dout_leaf')):
          n = line.split('// assign dout_leaf_')[1]
          n = int(n.split()[0]) # extract leaf number
          # print(n)
          if(n < bft_n+1):
            newline = line
            # print(newline)
          else:
            newline = line.split('// ')[1] # remove '// '
            # print(newline)

        # Handles page_bb page*_inst
        elif(line.startswith('page_bb page')):
          n = line.split('page_bb page')[1]
          n = int(n.split('_')[0]) # extract leaf number
          if(n > bft_n):
            isComment = True
            counter = 7
            newline = '// ' + line
          else:
            newline = line
          # print(newline)

        elif(isComment):
          newline = '// ' + line
          counter = counter-1
          if(counter == 0):
            isComment = False
          # print(newline)

        else:
          newline = line

        filedata = filedata + newline

    with open(ydmabbfile, "w") as file:
      file.write(filedata)



  def run(self, operators, bft_n=29, tandem_mode=False):
    # initial run
    if(not os.path.isdir(self.overlay_dir)):
      self.shell.mkdir(self.prflow_params['workspace'])
      self.shell.re_mkdir(self.overlay_dir)
      
      # copy the hld/xdc files from input source directory
      self.shell.del_dir(self.overlay_dir+'/src')
      self.shell.cp_dir('./common/verilog_src', self.overlay_dir+'/src')

      # copy the initial source files for vitis compile
      self.shell.cp_dir('./common/ydma', self.overlay_dir)

      # copy the parsing script to generate overlay's resource map
      self.shell.cp_dir('./common/script_src/get_blocked_resources.py', self.overlay_dir)
      self.shell.cp_dir('./common/script_src/parse_ovly_util.py', self.overlay_dir)

      # modifications for single-overlay-version to multiple-overlays-version
      self.update_makefile_overlay(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/',bft_n)
      self.update_py_overlay(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/python/',bft_n)
      self.update_sh_overlay(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/shell/',bft_n)
      self.update_tcl_overlay(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/tcl/',bft_n)
      # self.update_ydma_bb(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/src4level2/ydma_bb/', bft_n)

    
      # update the cad tool path
      self.update_cad_path(operators)

      # update the pragma for hipr ovelay generation
      # self.update_resource_pragma(operators)

      # generate shell files for local run
      self.create_shell_file(operators,bft_n, tandem_mode)
      self.update_main_overlay(self.overlay_dir+'/',bft_n)

      # create dummy logic place and route the overlay.dcp
      self.create_place_holder(operators)

      # create a folder to store the partial bitstreams for different versions of riscv
      # implementations for different pages
      self.shell.re_mkdir(self.overlay_dir+'/riscv_bit_lib')

    else:
      # subsequent overlay generations
      if(not os.path.exists(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/overlay_p'+str(bft_n)+'/overlay.dcp')):
        self.shell.cp_dir('./common/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/Makefile', \
          self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/Makefile')        
        self.shell.cp_dir('./common/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/python/', \
          self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/')
        self.shell.cp_dir('./common/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/shell/', \
          self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/')
        self.shell.cp_dir('./common/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/tcl/', \
          self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/')
        self.shell.cp_dir('./common/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/src4level2/', \
          self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual/')


        # self.shell.re_mkdir(self.overlay_dir)
        
        # # copy the hld/xdc files from input source directory
        # self.shell.del_dir(self.overlay_dir+'/src')
        # self.shell.cp_dir('./common/verilog_src', self.overlay_dir+'/src')

        # # copy the initial source files for vitis compile
        # self.shell.cp_dir('./common/ydma', self.overlay_dir)
        # copy the parsing script to generate overlay's resource map
        # self.shell.cp_dir('./common/script_src/parse_ovly_util.py', self.overlay_dir)

        # modifications for single-overlay-version to multiple-overlays-version
        self.update_makefile_overlay(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/',bft_n)
        self.update_py_overlay(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/python/',bft_n)
        self.update_sh_overlay(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/shell/',bft_n)
        self.update_tcl_overlay(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/tcl/',bft_n)
        # self.update_ydma_bb(self.overlay_dir+'/ydma/'+self.prflow_params['board']+'/'+self.prflow_params['board']+'_dfx_manual'+'/src4level2/ydma_bb/', bft_n)

        # update the cad tool path
        self.update_cad_path(operators)

        # update the pragma for hipr ovelay generation
        # self.update_resource_pragma(operators)

        # generate shell files for local run
        self.create_shell_file(operators,bft_n,tandem_mode)
        self.update_main_overlay(self.overlay_dir+'/',bft_n)

        # create dummy logic place and route the overlay.dcp
        self.create_place_holder(operators)

        # create a folder to store the partial bitstreams for different versions of riscv
        # implementations for different pages
        self.shell.re_mkdir(self.overlay_dir+'/riscv_bit_lib')
