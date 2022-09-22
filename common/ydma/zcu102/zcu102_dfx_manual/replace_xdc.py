import os


xdc_list = ['./sub_p23.xdc']
for xdcfile in xdc_list:
  with open(xdcfile, "r") as file:
    filedata = file.read()
  filedata = filedata.replace("p_2", "p2")
  filedata = filedata.replace("p_4", "p4")
  filedata = filedata.replace("p_8", "p8")
  filedata = filedata.replace("p_12", "p12")
  filedata = filedata.replace("p_16", "p16")
  filedata = filedata.replace("p_20", "p20")
  with open(xdcfile, "w") as file:
    file.write(filedata)
