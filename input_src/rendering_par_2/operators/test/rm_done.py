import os

for f in os.listdir('./'):
    if(f.endswith('.cpp')):
        new_f_name = f.replace('_done','')
        os.system('mv ' + f + ' ' + new_f_name)
    if(f.endswith('.h')):
        new_f_name = f.replace('_done','')
        os.system('mv ' + f + ' ' + new_f_name)
os.system('rm -f __test_done__')
