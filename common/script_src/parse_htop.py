#!/usr/bin/env python
import re


def main():
	with open("htop.html", "r") as htop_file:
		for line in htop_file:
			if(line.startswith("  Mem")):
				mem_total = re.findall(r"\d+\.\d+G/\d+G|\d+G/\d+G", line)[0] # ex: 15.6G/126G
				mem_load = mem_total.split("G")[0] # 15.6
				# print(mem_load)
				str_after_thr = line.split("thr")[1] # string after "thr"
				running_threads = re.findall(r"\d+", str_after_thr)[0] # there's only one number
				# print(running_threads)
	print(str(mem_load) + " " + str(running_threads))

if __name__ == '__main__':
	main()
