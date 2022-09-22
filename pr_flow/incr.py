import os, re, json, time
from gen_basic import gen_basic
import filecmp

class incr(gen_basic):


  def create_page(self, operators, input_dir, monitor_on):
    
    test_dir_list = [x for x in os.listdir(input_dir) if(os.path.isdir(input_dir + x) and x.startswith('test_'))]
    test_dir_list = sorted(test_dir_list, key=lambda x:int(x.split('_')[1])) # sort test cases in order

    is_test_done = True
    for test_dir in test_dir_list:
      if(not os.path.exists(input_dir + test_dir + '/__done__')):
        # enter to the non-tested directory
        new_files = [x for x in os.listdir(input_dir + test_dir)]
        old_files = [x for x in os.listdir(input_dir) if(not os.path.isdir(input_dir + x))]
        # print(old_files)
        if(len(new_files) == 1 and new_files[0] == 'typedefs.h'): # only change params
          #touch all files that have chagned datatype or unroll pragma, etc
          break
        else:
          for f in new_files:
            if(f == 'typedefs.h' or f == 'top.cpp'):
              if(not filecmp.cmp(input_dir + test_dir + '/' + f, input_dir + '../host/' + f)):
                os.system('cp ' + input_dir + test_dir + '/' + f + ' ' +input_dir + '../host/' + f)
                print(f + ' is modified')
            elif(f in old_files):
              if(not filecmp.cmp(input_dir + test_dir + '/' + f, input_dir + f)): # if diff file, cp it
                os.system('cp ' + input_dir + test_dir + '/' + f + ' ' +input_dir)
                print(f + ' is modified')
            elif(f not in old_files):
                os.system('cp ' + input_dir + test_dir + '/' + f + ' ' +input_dir)
                print(f + ' is added')
          for f in old_files:
            if((f.endswith('.cpp') or f.endswith('.h') or f.endswith('.json')) and f not in new_files):
              os.system('rm ' + input_dir + f)
              print(f + ' is removed')
        os.system('touch ' + input_dir + test_dir + '/__done__')              
        is_test_done = False
        break

    if(is_test_done):
      os.system('touch ' + input_dir + '__test_done__')


  def update_best(self, input_dir):
    if(os.path.exists('result.txt')):
      with open('result.txt', 'r') as infile:
        for line in infile:
          if('fom' in line):
            val = float(line.split()[1])

      if(os.path.exists(input_dir + 'best_result.txt')):
        with open(input_dir + 'best_result.txt', 'r') as infile:
          last_line = infile.readlines()[-1]
          if('fom' in last_line):
            min_val = float(last_line.split()[1])

        if(val < min_val): # found the new best result
          with open(input_dir + 'best_result.txt', 'a') as infile:
            infile.write(val + '\n')
          os.system('rm ' + input_dir + '_best/*')
          os.system('cp ' + input_dir + '*.cpp ' + input_dir + '_best/')
          os.system('cp ' + input_dir + '*.h ' + input_dir + '_best/')
          os.system('cp ' + input_dir + '*.json ' + input_dir + '_best/')
          os.system('cp ' + input_dir + '../host/top.cpp ' + input_dir + '_best/')

      else: # first result
        with open(input_dir + 'best_result.txt', 'w') as outfile:
          outfile.write('fom: ' + str(val) + '\n')
        os.system('mkdir -p ' + input_dir + '_best')
        os.system('rm -f ' + input_dir + '_best/*')
        os.system('cp ' + input_dir + '*.cpp ' + input_dir + '_best/')
        os.system('cp ' + input_dir + '*.h ' + input_dir + '_best/')
        os.system('cp ' + input_dir + '*.json ' + input_dir + '_best/')
        os.system('cp ' + input_dir + '../host/top.cpp ' + input_dir + '_best/')

  def run(self, operators, monitor_on=False):
    input_dir = './input_src/'+self.prflow_params['benchmark_name']+'/operators/'

    self.update_best(input_dir)
    self.create_page(operators, input_dir, monitor_on)
    
