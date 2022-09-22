import os
# import pickle
import json
from natsort import natsorted

# e.g.: returns 'p2_p0' from 'p2_p0.rpt'
def get_pblock_rpt(rpt_file):
	return rpt_file.split('.')[0]

def main():

	rpt_files = [f for f in os.listdir('./overlay_p23/abs_analysis/') if f.endswith('.rpt')]
	print(rpt_files)
	print(len(rpt_files))
	filedata=''
	util_dict = {}
	(num_clb, num_ram18, num_dsp) = (0, 0, 0)	
	for rpt_file in rpt_files:
		with open('./overlay_p23/abs_analysis/' + rpt_file, 'r') as file:
			for line in file:
				if(line.startswith('| CLB LUTs')):
					# print(line.split())
					num_clb = line.split()[4] # 4 is magic number for "Used" 
				elif(line.startswith('|   RAMB18')):
					# print(line.split())
					num_ram18 = line.split()[3] # 3 is magic number for "Used"
				elif(line.startswith('| DSPs')):
					# print(line.split())
					num_dsp = line.split()[3] # 3 is magic number for "Available"
		util_dict[get_pblock_rpt(rpt_file)] = (num_clb, num_ram18, num_dsp)
		filedata = filedata + rpt_file + ': ' + str((num_clb, num_ram18, num_dsp)) + '\n'

	# print(util_dict)
	# print(natsorted(list(util_dict.items())))
	for elem in natsorted(list(util_dict.items())):
		print(elem[0] + ', ' + ', '.join(elem[1]))

	# print(len(util_dict))

	# with open('util_all.rpt', 'w') as file:
	# 	file.write(filedata)

	# # with open('util_all.pickle', 'wb') as handle:
	# # 	pickle.dump(util_dict, handle, protocol=2) # protocol=2 so that python2 can read it
	# with open('util_all.json', 'w') as outfile:
	# 	json.dump(util_dict, outfile) # json for human readable file

if __name__ == '__main__':
	main()
