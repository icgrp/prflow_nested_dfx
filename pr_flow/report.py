#!/usr/bin/env python
import sys
import os
import xml.etree.ElementTree
import argparse
import re
import math
import subprocess
import json
from gen_basic import gen_basic

class report(gen_basic):


  def get_pblock_op_impl(self, operator_impl):
    pblock_ops_dir = './input_src/' + self.prflow_params['benchmark_name'] + '/operators'
    with open(pblock_ops_dir + '/pblock_operators_list.json', 'r') as infile:
      pblock_operators_list = json.load(infile)
    for pblock_op in pblock_operators_list:
      if(operator_impl in pblock_op.split()):
        pblock_op_impl = pblock_op # replace representiative op to multiple pblock_op, e.g.:"coloringFB_bot_m" to "coloringFB_bot_m coloringFB_top_m"
    return pblock_op_impl

  def gen_compile_time_report(self, benchmark_name, operators_list):
    time_report_dict = {}
    time_data_dict = {}

    with open(self.syn_dir+'/pblock_assignment.json', 'r') as infile:
      (overlay_n, pblock_assign_dict) = json.load(infile)
    with open(self.syn_dir+'/page_assignment.json', 'r') as infile:
      (overlay_n, page_assign_dict) = json.load(infile)


    t_syn_max = 0
    for fun_name in sorted(operators_list):
      #process syn timing
      try:
        file_name = './workspace/F003_syn_'+benchmark_name+'/' + fun_name + '/runLog_' + fun_name + '.log'
        file_in = open(file_name, 'r')
        for line in file_in:
          t_syn = re.findall(r"\d+", line)[0]
          if(t_syn > t_syn_max):
            t_syn_max = t_syn
        file_in.close()
      except:
        print ('Something is wrong with '+file_name) 


    for fun_name in sorted(operators_list):
      # map_target_exist, map_target = self.pragma.return_pragma('./input_src/'+self.prflow_params['benchmark_name']+'/operators/'+fun_name+'.h', 'map_target')
      # page_exist, page_num = self.pragma.return_pragma('./input_src/'+self.prflow_params['benchmark_name']+'/operators/'+fun_name+'.h', 'page_num')
      map_target = 'HW'

      page_num = page_assign_dict[fun_name]
      pblock_op_impl = self.get_pblock_op_impl(fun_name)
      pblock_name = pblock_assign_dict[pblock_op_impl]

      #process hls timing
      try:
        file_name = './workspace/F002_hls_'+benchmark_name+'/runLog' + fun_name + '.log'
        file_in = open(file_name, 'r')
        for line in file_in:
          t_hls = re.findall(r"\d+", line)[0]
        file_in.close()
      except:
        print ('Something is wrong with '+file_name) 

      #process syn timing
      try:
        file_name = './workspace/F003_syn_'+benchmark_name+'/' + fun_name + '/runLog_' + fun_name + '.log'
        file_in = open(file_name, 'r')
        for line in file_in:
          t_syn = re.findall(r"\d+", line)[0]
        file_in.close()
      except:
        print ('Something is wrong with '+file_name) 

      #process impl timing
      try: 
        file_name = './workspace/F004_impl_'+benchmark_name+'/' + fun_name + '/runLogImpl_' + fun_name + '.log'
        file_in = open(file_name, 'r')
        for line in file_in:
          if(line.startswith('read_checkpoint:')):
            t_rdchk = re.findall(r"\d+", line)[0]
          elif(line.startswith('opt:')):
            t_opt = re.findall(r"\d+", line)[0]
          elif(line.startswith('place:')):
            t_place = re.findall(r"\d+", line)[0]
          elif(line.startswith('opt_physical:')):
            t_popt = re.findall(r"\d+", line)[0]
          elif(line.startswith('route:')):
            t_route = re.findall(r"\d+", line)[0]
          elif(line.startswith('bitgen:')):
            t_bitgen = re.findall(r"\d+", line)[0]

        file_in.close()
        t_total_max_syn = str(int(t_hls) + int(t_syn_max) + int(t_rdchk) + int(t_opt) + int(t_place) + int(t_popt) + int(t_route) + int(t_bitgen))
        t_total = str(int(t_hls) + int(t_syn) + int(t_rdchk) + int(t_opt) + int(t_place) + int(t_popt) + int(t_route) + int(t_bitgen))
        time_report_dict[fun_name] = " {: <30}{: <10}{: <15}{: <8}{: <8}{: <8}{: <8}{: <8}{: <8}{: <8}{: <8}{: <8}{: <16}{: <8}"\
                                        .format(fun_name, map_target, pblock_name, page_num, t_hls, t_syn, t_rdchk, t_opt, t_place, t_popt, t_route, t_bitgen, t_total_max_syn, t_total)
      except:
        print "Something is wrong with "+file_name

    time_report_file = open('./workspace/report/time_report_'+benchmark_name+'.csv', 'w')
    top_row_str = 'operator,target,pblock,page,hls,syn,rdchk,opt,place,popt,route,bitgen,total\n'
    time_report_file.write(top_row_str)

    for key, value in sorted(time_report_dict.items()):
      value_list = value.split()
      value_csv = ','.join(value_list)
      time_report_file.write(value_csv+'\n')  
    print '\n                               operator',' ' * 22, 'target',' ' * 2, 'pblock',' ' * 7, 'page',' ' * 2, 'hls',' ' * 3,'syn',' ' * 3,'rdchk',' ' * 1,'opt',' ' * 3,\
          'place',' ' * 1,'popt',' ' * 2,'route',' ' * 1,'bitgen  total(max_syn)  total'
    print '-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
    self.print_dict(time_report_dict)

  def gen_resource_report(self, benchmark_name, operators_list):
    resource_report_dict = {}

    with open(self.syn_dir+'/pblock_assignment.json', 'r') as infile:
      (overlay_n, pblock_assign_dict) = json.load(infile)
    with open(self.syn_dir+'/page_assignment.json', 'r') as infile:
      (overlay_n, page_assign_dict) = json.load(infile)


    for fun_name in operators_list:
      # map_target_exist, map_target = self.pragma.return_pragma('./input_src/'+self.prflow_params['benchmark_name']+'/operators/'+fun_name+'.h', 'map_target')
      # page_exist, page_num = self.pragma.return_pragma('./input_src/'+self.prflow_params['benchmark_name']+'/operators/'+fun_name+'.h', 'page_num')
      map_target = 'HW'

      page_num = page_assign_dict[fun_name]
      pblock_op_impl = self.get_pblock_op_impl(fun_name)
      pblock_name = pblock_assign_dict[pblock_op_impl]

      # resource_report_dict[fun_name] = fun_name.ljust(30) + '\t' + map_target + '\t' + pblock_name + tab_str + page_num
      #####################################################################################
      #process resource utilization
      try:
        file_name = './workspace/F003_syn_'+benchmark_name+'/' + fun_name + '/utilization.rpt'
        file_list = self.shell.file_to_list(file_name)
        for idx, line in enumerate(file_list):
          if self.shell.have_target_string(line, 'Instance'):
            resource_list =  file_list[idx+2].replace(' ', '').split('|')
            num_luts = resource_list[3]
            num_ffs = resource_list[7]
            num_brams = int(resource_list[8])*2+int(resource_list[9])
            num_dsps = resource_list[11]
            resource_report_dict[fun_name] = " {: <30}{: <10}{: <15}{: <8}{: <8}{: <8}{: <8}{: <8}"\
                                            .format(fun_name, map_target, pblock_name, page_num, num_luts, num_ffs, num_brams, num_dsps)
      except:
        print ('Something is wrong with '+file_name) 


    resource_report_file = open('./workspace/report/resource_report_'+benchmark_name+'.csv', 'w')
    top_row_str = 'operator,target,pblock,page,LUTs,FFs,BRAM18s,DSPs\n'
    # resource_report_file.write('operator                  \ttarget\tpblock\t\tpage\tLUTs\tFFs\tBRAM18s\tDSPs\n')
    resource_report_file.write(top_row_str)
    for key, value in sorted(resource_report_dict.items()):
      value_list = value.split()
      value_csv = ','.join(value_list)
      resource_report_file.write(value_csv+'\n')  
    print '\n                               operator',' ' * 22, 'target',' ' * 2, 'pblock',' ' * 7, 'page',' ' * 2, 'LUTs',' ' * 2, 'FFs',' ' * 3, 'BRAM18s DSPs'
    # print '\n                               operator                  \ttarget\tpblock\t\tpage\tLUTs\tFFs\tBRAM18s\tDSPs'
    print '----------------------------------------------------------------------------------------------------------------------------'
    self.print_dict(resource_report_dict)

  def gen_timing_report(self, benchmark_name, operators_list):
    timing_report_dict = {}

    with open(self.syn_dir+'/pblock_assignment.json', 'r') as infile:
      (overlay_n, pblock_assign_dict) = json.load(infile)
    with open(self.syn_dir+'/page_assignment.json', 'r') as infile:
      (overlay_n, page_assign_dict) = json.load(infile)

    for fun_name in operators_list:
      # map_target_exist, map_target = self.pragma.return_pragma('./input_src/'+self.prflow_params['benchmark_name']+'/operators/'+fun_name+'.h', 'map_target')
      # page_exist, page_num = self.pragma.return_pragma('./input_src/'+self.prflow_params['benchmark_name']+'/operators/'+fun_name+'.h', 'page_num')
      map_target = 'HW'

      page_num = page_assign_dict[fun_name]
      pblock_op_impl = self.get_pblock_op_impl(fun_name)
      pblock_name = pblock_assign_dict[pblock_op_impl]

      #####################################################################################
      #process timing report
      try:
        file_name = './workspace/F004_impl_'+benchmark_name+'/' + fun_name + '/timing_'+str(pblock_name)+'.rpt'
        # file_name = './workspace/F004_impl_'+benchmark_name+'/' + fun_name + '/timing_page'+str(page_num)+'.rpt'
        file_in = open(file_name, 'r')
        find_summary_flag = False
        line_offset = 0
        for line in file_in:
          if line.replace('Design Timing Summary', '') != line:
            find_summary_flag = True
          if find_summary_flag:
            line_offset += 1
          if line_offset == 7:
            timing_list =  line.split()
            WNS = timing_list[0]
            # timing_report_dict[fun_name] += '\t' + timing_list[0]
            timing_report_dict[fun_name] = " {: <30}{: <10}{: <15}{: <8}{: <8}"\
                                            .format(fun_name, map_target, pblock_name, page_num, WNS)

        file_in.close()
      except:
        print ('Something is wrong with '+file_name) 

    timing_report_file = open('./workspace/report/timing_report_'+benchmark_name+'.csv', 'w')
    top_row_str = 'operator,target,pblock,page,slack\n'
    timing_report_file.write(top_row_str)
    for key, value in sorted(timing_report_dict.items()):
      value_list = value.split()
      value_csv = ','.join(value_list)
      timing_report_file.write(value_csv+'\n')  
    print '\n                               operator',' ' * 22, 'target',' ' * 2, 'pblock',' ' * 7, 'page',' ' * 2, 'slack'
    # print '\n                               operator                  \ttarget\tpblock\t\tpage\tslack'
    print '-----------------------------------------------------------------------------------------------------'
    self.print_dict(timing_report_dict)

 
  def run(self, operators_str, is_routing_test):

    self.shell.mkdir(self.rpt_dir)
    benchmark_name = self.prflow_params['benchmark_name']
    operators_list = operators_str.split() 
    if(not is_routing_test):
      self.gen_resource_report(benchmark_name, operators_list)
      self.gen_compile_time_report(benchmark_name, operators_list)
    self.gen_timing_report(benchmark_name, operators_list)
    print 'You can find the comile time report and resource report under: ./workspace/report' 

