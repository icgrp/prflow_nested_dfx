import os

def main():
    # overlay_n: e.g.: overlay_p17
    directories = os.getcwd().split('/')
    overlay_n = directories[-2]
    n = overlay_n.split('_p')[1] # n = 17 in overlay_p17
    tandem_info_file_dir = '../../xdc/tandem_p' + str(n) + '.txt'
    tandem_page_num_dict = {}
    with open(tandem_info_file_dir, 'r') as file:
      for line in file:
        page_num = line.split()[0]
        tandem_unit = line.split()[1]
        tandem_page_num_dict[tandem_unit] = page_num
    print(tandem_page_num_dict)

    #modify impl_*.tcl files with page_num in tandem_info_file_dir
    file_dict = {'t_1': './impl/t_1/impl_t_1.tcl', 't_2': './impl/t_2/impl_t_2.tcl',
      't_3': './impl/t_3/impl_t_3.tcl', 
      'tc_1_1': './impl/tc_1_1/impl_tc_1_1.tcl', 'tc_1_2': './impl/tc_1_2/impl_tc_1_2.tcl', 
      'tc_2_1': './impl/tc_2_1/impl_tc_2_1.tcl', 'tc_2_2': './impl/tc_2_2/impl_tc_2_2.tcl',
      'tc_3_1': './impl/tc_3_1/impl_tc_3_1.tcl', 'tc_3_2': './impl/tc_3_2/impl_tc_3_2.tcl',
      'tc_all_1': './impl/tc_all_1/impl_tc_all_1.tcl', 'tc_all_2': './impl/tc_all_2/impl_tc_all_2.tcl', 
      'tc_all_3': './impl/tc_all_3/impl_tc_all_3.tcl'}

    for tandem_unit, impl_tcl in file_dict.items():
      with open(impl_tcl, 'r') as file:
        filedata = file.read()
      page_num = tandem_page_num_dict[tandem_unit]
      filedata = filedata.replace("PAGE_NUM_MODIFY", page_num)

      with open(impl_tcl, 'w') as file:
        filedata = file.write(filedata)


if __name__ == '__main__':
    main()