import os

# files = [f for f in os.listdir('./' if isfile(f))]

# filelist = [] 
# for f in os.listdir('./'):
#     if(not f.endswith('.swp')):
#         filelist.append(f)

# for f in filelist:
#     command = 'diff '
#     command = command + f
#     diff_f = '/home/dopark/icgrid/simple_sim/v_src/pure_verilog/' + f
#     if(os.path.exists(diff_f)):
#         command = command + ' ' + diff_f
#         print("#########################################")
#         print("#### file name: " + f)
#         print("#########################################")
#         os.system(command)
#         print("")

except_list = ['bft.v', 'test.v']

filelist = [] 
for f in os.listdir('./'):
    if(not f.endswith('.swp')):
        filelist.append(f)

for f in filelist:
    command = 'diff '
    command = command + f
    diff_f = '/home/dopark/workspace/zcu102_tuning/prflow_riscv/common/verilog_src/' + f
    if(os.path.exists(diff_f) and f not in except_list):
        command = command + ' ' + diff_f
        print("#########################################")
        print("#### file name: " + f)
        print("#########################################")
        os.system(command)
        print("")