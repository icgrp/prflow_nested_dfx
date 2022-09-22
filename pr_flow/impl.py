# -*- coding: utf-8 -*-   

import os  
import subprocess
from gen_basic import gen_basic
import re
import syn
import json
from p23_pblock import pblock_page_dict

class impl(gen_basic):

  def get_num_op(self, operator):
    return len(operator.split())

  def get_page_size(self, pblock_name):
    return len(pblock_page_dict[pblock_name])

  def get_page_inst(self, pblock_name):
    split_str = pblock_name.split('_')
    base_page = split_str[0] # split_str[0] is 'p12' 
    base_page_num = base_page.split('p')[1] # '12'

    if(len(split_str) >= 2):
        # print(split_str[1:])
        page_inst = 'page' + base_page_num + '_inst'
        for elem in split_str[1:]:
            page_inst = page_inst + '/' + elem
    else: # p2, p4, p8, p12, p16, p20
        page_inst = 'page' + base_page_num + '_inst'
    return page_inst

  # create one directory for each page 
  def create_page(self, pblock_op_impl, pblock_name, overlay_n, syn_dcp, monitor_on):
    num_op = self.get_num_op(pblock_op_impl)
    if(num_op > 1): # if pblock_op_impl="coloringFB_bot_m coloringFB_top_m", operator_impl=coloringFB_bot_m
      operator_impl = pblock_op_impl.split()[0]
    else:
      operator_impl = pblock_op_impl

    page_inst = self.get_page_inst(pblock_name)
    self.shell.re_mkdir(self.pr_dir+'/'+operator_impl)
    self.shell.cp_file('./common/script_src/impl_page_'+self.prflow_params['board']+'.tcl', \
                        self.pr_dir+'/'+operator_impl+'/impl_'+operator_impl+'.tcl')

    #if(num_op > 1):
    op_list =  pblock_op_impl.split() # e.g.: ["coloringFB_bot_m", "coloringFB_top_m"]
    set_operator_replace = ''
    set_user_logic_replace = ''
    set_bit_name_replace = 'set bit_name "../../F005_bits_${benchmark}/${operator_0}.bit"'
    set_logFileId_replace = 'set logFileId [open ./runLogImpl_${operator_0}.log "w"]'
    add_files_user_logic_dcp_replace = ''
    for i in range(num_op):
      set_operator_replace = set_operator_replace + 'set operator_' + str(i) + ' ' + op_list[i] + '\n'
      if(syn_dcp is not None):
        set_user_logic_replace = set_user_logic_replace \
                               + 'set user_logic_dcp_'+ str(i) +' "../../F003_syn_${benchmark}/'+syn_dcp+'/page_netlist.dcp"\n'
      else:
        set_user_logic_replace = set_user_logic_replace \
                               + 'set user_logic_dcp_'+ str(i) +' "../../F003_syn_${benchmark}/${operator_'+str(i)+'}/page_netlist.dcp"\n'
      add_files_user_logic_dcp_replace = add_files_user_logic_dcp_replace \
                                       + 'add_files $user_logic_dcp_' + str(i) + '\n'

    # else:
    #   set_operator_replace = 'set operator '+operator
    #   set_user_logic_replace = 'set user_logic_dcp "../../F003_syn_${benchmark}/${operator}/page_netlist.dcp"'
    #   set_bit_name_replace = 'set bit_name "../../F005_bits_${benchmark}/${operator}.bit"'
    #   set_logFileId_replace = 'set logFileId [open ./runLogImpl_${operator}.log "w"]'
    #   add_files_user_logic_dcp_replace = 'add_files $user_logic_dcp'

    tmp_dict = {'set operator'                : set_operator_replace,
                'set benchmark'               : 'set benchmark '+self.prflow_params['benchmark_name'],
                'set pblock_name'             : 'set pblock_name '+pblock_name,
                'set part'                    : 'set part '+self.prflow_params['part'],
                'set user_logic_dcp'          : set_user_logic_replace,
                'set bit_name'                : set_bit_name_replace,
                'set logFileId'               : set_logFileId_replace,
                'add_files $user_logic_dcp'   : add_files_user_logic_dcp_replace,
                'set_property SCOPED_TO_CELLS': '',
                'link_design'                 : 'link_design -mode default -reconfig_partitions {'\
                                                 + self.prflow_params['inst_name']\
                                                +'/'+page_inst + '} -part $part -top '\
                                                + self.prflow_params['top_name'],
                'report_timing_summary >'     : 'report_timing_summary > timing_${pblock_name}.rpt\n'
                                                +'report_utilization -hierarchical -file ' \
                                                + operator_impl + '_' + str(pblock_name) + '.rpt'
                }

    if(self.get_page_size(pblock_name) == 1):
      tmp_dict['set leaf_dcp']     = ''
    elif(self.get_page_size(pblock_name) == 2):
      if(num_op == 1):
        tmp_dict['set leaf_dcp']     = 'set leaf_dcp "../../F001_overlay/ydma/'+self.prflow_params['board']+\
                                    '/'+self.prflow_params['board']+'_dfx_manual/'+overlay_n+'/leaf_double_1.dcp"'
      elif(num_op == 2):
        tmp_dict['set leaf_dcp']     = 'set leaf_dcp "../../F001_overlay/ydma/'+self.prflow_params['board']+\
                                    '/'+self.prflow_params['board']+'_dfx_manual/'+overlay_n+'/leaf_double_2.dcp"'
      else:
        raise Exception("Invalid num_op")
    elif(self.get_page_size(pblock_name) == 4):
      if(num_op == 1):
        tmp_dict['set leaf_dcp']     = 'set leaf_dcp "../../F001_overlay/ydma/'+self.prflow_params['board']\
                                     +'/'+self.prflow_params['board']+'_dfx_manual/'+overlay_n+'/leaf_quad_1.dcp"'
      elif(num_op == 2):
        tmp_dict['set leaf_dcp']     = 'set leaf_dcp "../../F001_overlay/ydma/'+self.prflow_params['board']\
                                     +'/'+self.prflow_params['board']+'_dfx_manual/'+overlay_n+'/leaf_quad_2.dcp"'
      elif(num_op == 3):
        tmp_dict['set leaf_dcp']     = 'set leaf_dcp "../../F001_overlay/ydma/'+self.prflow_params['board']\
                                     +'/'+self.prflow_params['board']+'_dfx_manual/'+overlay_n+'/leaf_quad_3.dcp"'
      elif(num_op == 4):
        tmp_dict['set leaf_dcp']     = 'set leaf_dcp "../../F001_overlay/ydma/'+self.prflow_params['board']\
                                     +'/'+self.prflow_params['board']+'_dfx_manual/'+overlay_n+'/leaf_quad_4.dcp"'
      else:
        raise Exception("Invalid num_op")
    #elif(self.get_page_size(pblock_name) == 8):
    #  tmp_dict['set leaf_dcp']     = 'set leaf_dcp "../../F001_overlay/ydma/'+self.prflow_params['board']+\
    #                                    '/'+self.prflow_params['board']+'_dfx_manual/'+overlay_n+'/leaf_oct.dcp"'

    if self.prflow_params['overlay_type'] == 'hipr':
      tmp_dict['CELL_ANCHOR']     = 'set_property SCOPED_TO_CELLS { '+self.prflow_params['inst_name']+'/mono_inst/'+operator_impl+'_inst } [get_files $page_dcp]'
      tmp_dict['set inst_name']   = 'set inst_name "'+self.prflow_params['inst_name']+'/mono_inst/'+operator_impl+'_inst"'
      tmp_dict['set context_dcp'] = 'set context_dcp "../../F001_overlay_'+self.prflow_params['benchmark_name']+'/ydma/'+self.prflow_params['board']\
                                  +'/'+self.prflow_params['board']+'_dfx_hipr/checkpoint/'+operator_impl+'.dcp"'
    else:
      if(self.get_page_size(pblock_name) == 1): # don't need leaf_dcp
        tmp_dict['add_files $leaf_dcp'] = ''
        tmp_dict['CELL_ANCHOR']     = 'set_property SCOPED_TO_CELLS { '+self.prflow_params['inst_name']+'/' + page_inst + '} [get_files $user_logic_dcp_0]'
      else:
        tmp_dict['CELL_ANCHOR']     = 'set_property SCOPED_TO_CELLS { '+self.prflow_params['inst_name']+'/'+page_inst + '} [get_files $leaf_dcp]\n'
        for i in range(num_op):
          tmp_dict['CELL_ANCHOR']     = tmp_dict['CELL_ANCHOR']\
                                      + 'set_property SCOPED_TO_CELLS { '+self.prflow_params['inst_name']\
                                      +'/'+page_inst+ '/leaf_single_inst_'+str(i)+'} [get_files $user_logic_dcp_'+str(i)+']\n'
 
      tmp_dict['set inst_name']   = 'set inst_name "'+self.prflow_params['inst_name']+'/' + page_inst + '"'
      tmp_dict['set context_dcp'] = 'set context_dcp "../../F001_overlay/ydma/'+self.prflow_params['board']\
                                  +'/'+self.prflow_params['board']+'_dfx_manual/'+overlay_n+'/' + pblock_name + '.dcp"'


    self.shell.cp_dir('./common/script_src/monitor_impl.sh', self.pr_dir+'/monitor.sh') # syn and impl are type 2
    self.shell.cp_dir('./common/script_src/parse_htop.py', self.pr_dir)

    self.shell.cp_dir('./common/constraints/'+self.prflow_params['board']+'/*', self.pr_dir+'/'+operator_impl)
    self.shell.mkdir(self.pr_dir+'/'+operator_impl+'/output')
    os.system('touch '+self.pr_dir+'/'+operator_impl+'/output/_user_impl_clk.xdc') 
    self.shell.replace_lines(self.pr_dir+'/'+operator_impl+'/impl_'+operator_impl+'.tcl', tmp_dict)    
    self.shell.write_lines(self.pr_dir+'/'+operator_impl+'/run.sh', self.shell.return_run_sh_list(self.prflow_params['Xilinx_dir'], 
                                                                                 'impl_'+operator_impl+'.tcl', 
                                                                                 self.prflow_params['back_end'], 
                                                                                 monitor_on), True)
    self.shell.write_lines(self.pr_dir+'/'+operator_impl+'/main.sh', self.shell.return_main_sh_list('./run.sh', 
                                                                                 self.prflow_params['back_end'], 
                                                                                 'syn_'+operator_impl, 
                                                                                 'impl_'+operator_impl, 
                                                                                 self.prflow_params['grid'], 
                                                                                 'qsub@qsub.com',
                                                                                 self.prflow_params['mem'],
                                                                                 self.prflow_params['node']
                                                                                  ), True)
  

  def create_shell_file(self):
  # local run:
  #   main.sh <- |_ execute each impl_page.tcl
  #
  # qsub run:
  #   qsub_main.sh <-|_ Qsubmit each qsub_run.sh <- impl_page.tcl
    pass   

  def run(self, operator_impl, syn_dcp, monitor_on=False):
    # mk work directory
    if self.prflow_params['gen_impl']==True:
      print "gen_impl"
      self.shell.mkdir(self.pr_dir)
      self.shell.mkdir(self.bit_dir)
    
    # generate shell files for qsub run and local run
    #self.create_shell_file() 

    # create ip directories for all the pages
    # page_num_exist, page_num = self.pragma.return_pragma('./input_src/'+self.prflow_params['benchmark_name']+'/operators/'+operator_impl+'.h', 'page_num')
    # print(self.syn_dir)


    pblock_ops_dir = './input_src/' + self.prflow_params['benchmark_name'] + '/operators'
    with open(pblock_ops_dir + '/pblock_operators_list.json', 'r') as infile:
      pblock_operators_list = json.load(infile)
    for pblock_op in pblock_operators_list:
      if(operator_impl in pblock_op.split()):
        pblock_op_impl = pblock_op # replace representiative op to multiple pblock_op, e.g.:"coloringFB_bot_m" to "coloringFB_bot_m coloringFB_top_m"


    if('test_single_' in self.prflow_params['benchmark_name'] or\
        'test_double_' in self.prflow_params['benchmark_name'] or\
        'test_quad_' in self.prflow_params['benchmark_name']):
      # For routing test...
      with open(self.syn_dir+'/pblock_assignment.json', 'r') as infile:
        (overlay_n, pblock_assign_dict) = json.load(infile)
      pblock_name = pblock_assign_dict[pblock_op_impl]
    else:
      # For incremental compile, each op has its own pblock.json
      with open(self.syn_dir+'/'+operator_impl+'/pblock.json', 'r') as infile:
        (overlay_n, pblock_name, page_num) = json.load(infile)

    print("############################ PBLOCK NAME: " + pblock_name)
    # print("############################ OVERLAY_N: " + overlay_n)

    # if pblock_name_exist==True:
    #   self.create_page(pblock_op_impl, pblock_name, overlay_n, monitor_on)
    self.create_page(pblock_op_impl, pblock_name, overlay_n, syn_dcp, monitor_on)
