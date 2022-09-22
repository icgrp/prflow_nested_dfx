import os
# import pickle
import json

# e.g.: returns 'p2_p0' from 'utilization_p2_p0.rpt'
def get_n_rpt(rpt_file):
	return (rpt_file.split('utilization_')[1]).split('.')[0]

def main():
	# rpt_files = [f for f in os.listdir('.') if f.endswith('.rpt')]
	# # print(rpt_files)
	# n = len(rpt_files) + 1 # returns 10 when overlay_p10
	# # print(n)
	# rpt_files = ['utilization'+ str(i) +'.rpt' for i in range(2,n+1)] # sorted

	rpt_files = [f for f in os.listdir('.') if f.endswith('.rpt')]
	# print(rpt_files)
	# filedata=''
	util_dict = {}
	(num_clb, num_ram36, num_ram18, num_dsp) = (0, 0, 0, 0)	
	for rpt_file in rpt_files:
		with open(rpt_file, 'r') as file:
			for line in file:
				if(line.startswith('| CLB LUTs')):
					num_clb = line.split()[16] # 16 is magic number for "Available" 
					# print(line.split()[16]) # 16 is magic number for "Available"
				elif(line.startswith('|   RAMB36')):
					num_ram36 = line.split()[15] # 15 is magic number for "Available"
					# print(line.split()[15]) # 15 is magic number for "Available"
				elif(line.startswith('|   RAMB18')):
					num_ram18 = line.split()[15] # 15 is magic number for "Available"
					# print(line.split()[15]) # 15 is magic number for "Available"
				elif(line.startswith('| DSPs')):
					num_dsp = line.split()[15] # 15 is magic number for "Available"
					# print(line.split()[15]) # 15 is magic number for "Available"
		util_dict[get_n_rpt(rpt_file)] = (num_clb, num_ram36, num_ram18, num_dsp)
		# filedata = filedata + rpt_file + ': ' + str((num_clb, num_ram36, num_ram18, num_dsp)) + '\n'

	# print(util_dict)
	# print(len(util_dict))
	with open('util_all_pre_blocked.json', 'w') as outfile:
		json.dump(util_dict, outfile)


	with open('blocked_util.json', 'r') as infile:
		blocked_resource_count_dict = json.load(infile)
	print(blocked_resource_count_dict)

	for pblock_name in util_dict:
		num_blocked_clb = blocked_resource_count_dict[pblock_name]['SLICE_LUTs']
		num_blocked_ram36 = blocked_resource_count_dict[pblock_name]['RAMB36']
		num_blocked_ram18_extra = blocked_resource_count_dict[pblock_name]['RAMB18_extra']
		num_blocked_dsp = blocked_resource_count_dict[pblock_name]['DSP48E2']

		num_clb = str(int(util_dict[pblock_name][0]) - int(num_blocked_clb))
		num_ram36 = str(int(util_dict[pblock_name][1]) - int(num_blocked_ram36))
		num_ram18 = str(int(util_dict[pblock_name][2]) - int(num_blocked_ram36)*2 - int(num_blocked_ram18_extra))
		num_dsp = str(int(util_dict[pblock_name][3]) - int(num_blocked_dsp))
		util_dict[pblock_name] = (num_clb, num_ram36, num_ram18, num_dsp) # rewrite util_dict reflecting blocked resources
	print(util_dict)
	with open('util_all.json', 'w') as outfile:
		json.dump(util_dict, outfile)

if __name__ == '__main__':
	main()
