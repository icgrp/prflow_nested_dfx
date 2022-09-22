import os


# sh_list = [f for f in os.listdir(directory) if f.endswith('.sh')]
# for shfile in sh_list:
#   with open(shfile, "r") as file:
#     filedata = file.read()
#   filedata = filedata.replace("overlay_p23", "checkpoint")

#   with open(shfile, "w") as file:
#     file.write(filedata)

# files = ['Makefile']
# for f in files:
#   with open(f, "r") as file:
#     filedata = file.read()
#   filedata = filedata.replace("overlay_p23", "checkpoint")

#   with open(f, "w") as file:
#     file.write(filedata)

# directory = './shell/'
# sh_list = [f for f in os.listdir(directory) if f.endswith('.sh')]
# print(sh_list)
# for shfile in sh_list:
#   with open(directory + shfile, "r") as file:
#     filedata = file.read()
#   filedata = filedata.replace("overlay_p23", "checkpoint")
#   with open(directory + shfile, "w") as file:
#     file.write(filedata)

# directory = './shell/nested/'
# sh_list = [f for f in os.listdir(directory) if f.endswith('.sh')]
# print(sh_list)
# for shfile in sh_list:
#   with open(directory + shfile, "r") as file:
#     filedata = file.read()
#   filedata = filedata.replace("overlay_p23", "checkpoint")
#   with open(directory + shfile, "w") as file:
#     file.write(filedata)

# directory = './tcl/subdivide_syn/'
# f_list = [f for f in os.listdir(directory) if f.endswith('.tcl')]
# print(f_list)
# for f in f_list:
#   with open(directory + f, "r") as file:
#     filedata = file.read()
#   filedata = filedata.replace("overlay_p23", "checkpoint")
#   with open(directory + f, "w") as file:
#     file.write(filedata)

# directory = './tcl/nested/'
# f_list = [f for f in os.listdir(directory) if f.endswith('.tcl')]
# print(f_list)
# for f in f_list:
#   with open(directory + f, "r") as file:
#     filedata = file.read()
#   filedata = filedata.replace("overlay_p23", "checkpoint")
#   with open(directory + f, "w") as file:
#     file.write(filedata)

# directory = './tcl/'
# f_list = [f for f in os.listdir(directory) if f.endswith('.tcl')]
# print(f_list)
# for f in f_list:
#   with open(directory + f, "r") as file:
#     filedata = file.read()
#   filedata = filedata.replace("overlay_p23", "checkpoint")
#   with open(directory + f, "w") as file:
#     file.write(filedata)


directory = './tcl/nested/'
f_list = [f for f in os.listdir(directory) if f.endswith('.tcl')]
print(f_list)

pblock_dict = {}
for f in f_list:
  if(f.startswith('abs_')):
    pblock_name = f.split('abs_')[1].split('.tcl')[0]
    pblock_dict[f] = pblock_name
    print(pblock_name)
  elif(f.startswith('pr_recombine_') and f != 'pr_recombine_dynamic_region.tcl'):
    pblock_name = f.split('pr_recombine_')[1].split('.tcl')[0]
    pblock_dict[f] = pblock_name    
    print(pblock_name)
print(pblock_dict)
print(len(pblock_dict))


for f in pblock_dict:
  with open(directory + f, "r") as file:
    filedata = file.read()
  filedata = filedata.replace("close_project", "report_utilization > ./checkpoint/abs_analysis/" + pblock_dict[f] +".rpt\nclose_project")
  with open(directory + f, "w") as file:
    file.write(filedata)


# for f in f_list:
#   with open(directory + f, "r") as file:
#     filedata = file.read()
#   filedata = filedata.replace("../../..", "./checkpoint")
#   with open(directory + f, "w") as file:
#     file.write(filedata)










# for tclfile in tcl_list:
#   with open(tclfile, "r") as file:
#     filedata = file.read()
#   filedata = filedata.replace("overlay_p31", "checkpoint")

#   with open(tclfile, "w") as file:
#     file.write(filedata)


# for f in os.listdir('.'):
#     if f.endswith('.tcl'):
#         print(f)

# for f in os.

# except_list = ['bft.v', 'test.v']

# filelist = [] 
# for f in os.listdir('./'):
#     if(not f.endswith('.swp')):
#         filelist.append(f)

# for f in filelist:
#     command = 'diff '
#     command = command + f
#     diff_f = '/home/dopark/workspace/zcu102_tuning/prflow_riscv/common/ydma/zcu102/zcu102_dfx_manual/tandem/syn/t_1/src/' + f
#     if(os.path.exists(diff_f) and f not in except_list):
#         command = command + ' ' + diff_f
#         print("#########################################")
#         print("#### file name: " + f)
#         print("#########################################")
#         os.system(command)
#         print("")

# def update_tcl_overlay(self, directory, bft_n):
# tclfiles = ['empty_pfm_dynamic.tcl','out_of_context_syn_page.tcl','out_of_context_syn_page_sexa.tcl','out_of_context_syn_page_oct.tcl','out_of_context_syn_ydma_bb.tcl','replace_sub_module_level1.tcl','sub_divided.tcl']
# tclfiles = [directory+elem for elem in tclfiles]
# for tclfile in tclfiles:
#   with open(tclfile, "r") as file:
#     filedata = file.read()
#   filedata = filedata.replace("/checkpoint", "/overlay_p"+str(bft_n))

#   with open(tclfile, "w") as file:
#     file.write(filedata)
