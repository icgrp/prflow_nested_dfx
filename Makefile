#prj_name=digit_reg_par_40
#prj_name=digit_reg_par_80

#prj_name=optical_flow_64_single
#prj_name=optical_flow_64_final
#prj_name=optical_flow_96_single
prj_name=optical_flow_96_final
#prj_name=optical_flow_incr

# prj_name=rendering_par_1
#prj_name=rendering_par_2

#prj_name=spam_filter_par_32
#prj_name=spam_filter_par_64


src=./common/verilog_src
ws=workspace
ws_overlay=$(ws)/F001_overlay
ws_hls=$(ws)/F002_hls_$(prj_name)
ws_syn=$(ws)/F003_syn_$(prj_name)
ws_impl=$(ws)/F004_impl_$(prj_name)
ws_bit=$(ws)/F005_bits_$(prj_name)

operators_dir=./input_src/$(prj_name)/operators
operators_src=$(wildcard $(operators_dir)/*.cpp)

operators=$(basename $(notdir $(operators_src)))
operators_hls_targets=$(foreach n, $(operators), $(ws_hls)/runLog$(n).log)
operators_syn_targets=$(foreach n, $(operators), $(ws_syn)/$(n)/page_netlist.dcp)

operators_pblocks=$(foreach n, $(operators), $(ws_syn)/$(n)/pblock.json)
operators_impl=$(shell python ./pr_flow/parse_op_list.py -prj $(prj_name))
# operators_syn_targets=$(foreach n, $(operators_impl), $(ws_syn)/$(n)/page_netlist.dcp)

operators_bit_targets=$(foreach n, $(operators_impl), $(ws_bit)/$(n).bit)
operators_xclbin_targets=$(foreach n, $(operators_impl), $(ws_bit)/$(n).xclbin)
operators_runtime_target=$(ws_bit)/sd_card/app.exe

mono_target=$(ws_mono)/ydma.xclbin
operators_ip_targets=$(foreach n, $(operators), $(ws_mbft)/ip_repo/$(n)/prj/floorplan_static.xpr)
mono_bft_target=$(ws_mbft)/prj/floorplan_static.runs/impl_1/floorplan_static_wrapper.bit


# overlay_type=hipr
ifeq ($(overlay_type),hipr)
overlay_suffix=_$(prj_name)
endif

# TEST_OPS := $(shell python ./pr_flow/parse_op_list.py -prj $(prj_name))
# test:
# 	echo $(TEST_OPS)
# 	echo $(operators)
# 	echo $(basename $(notdir $(operators_bit_targets)))
	

# all: $(mono_target)
all: $(operators_runtime_target)
mono: $(mono_target)

$(mono_target):./input_src/$(prj_name)/host/top.cpp ./pr_flow/monolithic.py $(operators_hls_targets)
	python2 pr_flow.py $(prj_name) -monolithic -op '$(basename $(notdir $(operators_bit_targets)))'
	cd $(ws_mono) && ./main.sh

runtime:$(operators_runtime_target) # NOTE: operators
$(operators_runtime_target):./input_src/$(prj_name)/host/host.cpp $(operators_xclbin_targets) ./pr_flow/runtime.py
	python2 pr_flow.py $(prj_name) -runtime -op '$(operators)'
# 	python2 pr_flow.py $(prj_name) -runtime -op '$(basename $(notdir $(operators_bit_targets)))'
	cp $(operators_xclbin_targets) $(ws_bit)/sd_card
	cd $(ws_bit)/$(prj_name)/host && ./gen_runtime.sh
# 	cd $(ws_bit)/$(prj_name)/host && ./gen_runtime_check_result.sh
	
xclbin: $(operators_xclbin_targets) # NOTE: operators_impl
$(operators_xclbin_targets):$(ws_bit)/%.xclbin:$(ws_bit)/%.bit
	python2 pr_flow.py $(prj_name) -xclbin -op $(basename $(notdir $@))
	cd $(ws_bit) && ./main_$(basename $(notdir $@)).sh $(operators_impl)

## uncomment for regular flow
bits:$(operators_bit_targets) # NOTE: operators_impl
# Implementation from post-synthesis DCP to bitstreams
# generate bitstream for each operator
$(operators_bit_targets):$(ws_bit)/%.bit:$(ws_overlay)$(overlay_suffix)/__overlay_is_ready__ $(ws_syn)/%/pblock.json $(ws_syn)/%/page_netlist.dcp
# $(operators_bit_targets):$(ws_bit)/%.bit:$(ws_overlay)$(overlay_suffix)/__overlay_is_ready__ $(operators_syn_targets)
# $(operators_bit_targets):$(ws_bit)/%.bit:$(ws_overlay)$(overlay_suffix)/__overlay_is_ready__ $(ws_syn)/%/page_netlist.dcp
	python2 pr_flow.py $(prj_name) -impl -op $(basename $(notdir $@))
	cd $(ws_impl)/$(basename $(notdir $@)) && ./main.sh $(operators_impl)

sync:$(operators_pblocks) 
$(operators_pblocks):$(ws_syn)/%/pblock.json: | pg_assign

# Page assignment after all synth jobs finished
pg_assign:$(ws_syn)/pblock_assignment.json
$(ws_syn)/pblock_assignment.json: $(operators_syn_targets) ./common/script_src/nested_pg_assign.py $(operators_dir)/pblock_operators_list.json
	cd $(ws_syn) && python nested_pg_assign.py -prj $(prj_name)
	#if [ ! -f $(ws_syn)/pblock_assignment.json ]; then cd $(ws_syn) && python nested_pg_assign.py -ops $(operators); fi

# pg_assign:$(ws_syn)/pblock_assignment.json
# $(ws_syn)/pblock_assignment.json:$(operators_syn_targets) ./common/script_src/nested_pg_assign.py $(operators_dir)/pblock_operators_list.json
# 	if [ ! -f $(ws_syn)/pblock_assignment.json ]; then cd $(ws_syn) && python nested_pg_assign.py -prj $(prj_name); fi
# # 	if [ ! -f $(ws_syn)/pblock_assignment.json ]; then cd $(ws_syn) && python nested_pg_assign.py -ops $(operators); fi


syn:$(operators_syn_targets)
# Out-of-Context Synthesis from Verilog to post-synthesis DCP
$(operators_syn_targets):$(ws_syn)/%/page_netlist.dcp:$(ws_hls)/runLog%.log $(ws_overlay)$(overlay_suffix)/__overlay_is_ready__ ./pr_flow/syn.py
	python2 pr_flow.py $(prj_name) -syn -op $(subst runLog,,$(basename $(notdir $<)))
	#cd $(ws_syn)/$(subst runLog,,$(basename $(notdir $<)))/riscv && ./qsub_run.sh
	cd $(ws_syn)/$(subst runLog,,$(basename $(notdir $<))) && ./main.sh $(operators)

.PHONY: report 
report: 
	 python2 ./pr_flow.py $(prj_name) -op '$(basename $(notdir $(operators_bit_targets)))' -rpt
## uncomment for regular flow


hls: $(operators_hls_targets)
# High-Level-Synthesis from C to Verilog
$(operators_hls_targets):$(ws_hls)/runLog%.log:$(operators_dir)/%.cpp $(operators_dir)/%.h ./pr_flow/hls.py
	python2 pr_flow.py $(prj_name) -hls -op $(basename $(notdir $<))
	cd $(ws_hls) && ./main_$(basename $(notdir $<)).sh $(operators)

overlay: $(ws_overlay)$(overlay_suffix)/__overlay_is_ready__
$(ws_overlay)$(overlay_suffix)/__overlay_is_ready__:
	python2 pr_flow.py $(prj_name) -g -op '$(basename $(notdir $(operators)))' -bft_n=$(bft_n)
	cd ./workspace/F001_overlay$(overlay_suffix) && ./main.sh


## uncomment for routing test or abs shell test
# bits:$(operators_bit_targets) # NOTE: operators_impl
# $(operators_bit_targets):$(ws_overlay)$(overlay_suffix)/__overlay_is_ready__ $(operators_syn_targets) $(ws_syn)/pblock_assignment.json
# 	python2 pr_flow.py $(prj_name) -impl -s_dcp $(syn_dcp) -op $(basename $(notdir $@))
# 	cd $(ws_impl)/$(basename $(notdir $@)) && ./main.sh $(operators_impl)

# pg_assign:$(ws_syn)/pblock_assignment.json
# $(ws_syn)/pblock_assignment.json:$(operators_syn_targets) $(operators_dir)/pblock_assignment.json
# 	cp ./common/script_src/test_pg_assign.py $(ws_syn)/
# 	cp $(operators_dir)/pblock_assignment.json $(ws_syn)/pblock_assignment.json
# 	cp $(operators_dir)/page_assignment.json $(ws_syn)/page_assignment.json
# 	cd $(ws_syn) && python test_pg_assign.py

# syn:$(operators_syn_targets)
# # Out-of-Context Synthesis from Verilog to post-synthesis DCP
# $(operators_syn_targets):$(ws_syn)/%/page_netlist.dcp:$(ws_hls)/runLog%.log $(ws_overlay)$(overlay_suffix)/__overlay_is_ready__ ./pr_flow/syn.py
# 	python2 pr_flow.py $(prj_name) -syn -op $(subst runLog,,$(basename $(notdir $<)))
# 	#cd $(ws_syn)/$(subst runLog,,$(basename $(notdir $<)))/riscv && ./qsub_run.sh
# 	cd $(ws_syn)/$(subst runLog,,$(basename $(notdir $<))) && ./main.sh $(operators)
# .PHONY: report 
# report:
# 	python2 ./pr_flow.py $(prj_name) -op '$(basename $(notdir $(operators_bit_targets)))' -rpt -rt
## uncomment for routing test

optical_test: optical_64_random optical_96_test

optical_64_random: ./optical_64_random/__done__
./optical_64_random/__done__:
	python page_assign_optical_64.py
	export prj_name=optical_flow512_original_64; make all -j24
	./run_op_64_random.sh

optical_96_test: ./optical_96_pg_assign/__done__
./optical_96_pg_assign/__done__:
	python page_assign_optical_96.py
	export prj_name=optical_flow512_original_96; make all -j24
	./run_op_96.sh

optical_64_sat: ./optical_64_sat/__done__
./optical_64_sat/__done__:
	cd pg_assign_sat/models && python3 pblock_assignment.py app=optical_flow board=zcu102 opt_level=O2 hydra.run.dir='./'
	export prj_name=optical_flow512_original_64; make all -j24
	./run_op_64.sh


# if bft_n==23: p2~p23 
# if bft_n==10, p2~p10
# if bft_n==12, p2~p12
bft_n=23
overlay_only:
	python2 pr_flow.py $(prj_name) -g -op '$(basename $(notdir $(operators)))' -bft_n=$(bft_n)
	cd ./workspace/F001_overlay$(overlay_suffix) && ./main.sh


# incremental compile
incr:
	python2 pr_flow.py $(prj_name) -incr -op '$(operators)'
run_on_fpga:
	if [ ! -f ./input_src/$(prj_name)/operators/__test_done__ ]; then cd $(ws_bit) && ./run_on_fpga.sh; fi


test_dir=$(wildcard ./input_src/$(prj_name)/operators/test_*)
done_signals=$(foreach d, $(test_dir), $(d)/__done__)
revert_to_init:
	rm -rf $(done_signals)
	rm -rf ./input_src/$(prj_name)/operators/__test_done__
	rm -rf ./input_src/$(prj_name)/operators/_best/
	rm -f ./input_src/$(prj_name)/operators/best_result.txt
	rm -rf ./input_src/$(prj_name)/operators/*.cpp ./input_src/$(prj_name)/operators/*.h ./input_src/$(prj_name)/operators/*.json
	cp ./input_src/$(prj_name)/operators/_original/* ./input_src/$(prj_name)/operators/
	mv ./input_src/$(prj_name)/operators/top.cpp ./input_src/$(prj_name)/host/top.cpp


# incr_1:
# 	python2 pr_flow.py $(prj_name) -incr --winner 1 -op '$(operators)'
# incr_2:
# 	python2 pr_flow.py $(prj_name) -incr --winner 2 -op '$(operators)'

# ifeq ("$(wildcard ./input_src/$(prj_name)/operators/test/__test_done__)","")
# 	COMPILE_SINGLE_TARGETS = hls_single syn_single bit_single xclbin_single runtime_single
# else
# 	COMPILE_SINGLE_TARGETS = test_done
# endif
# operator_test=$(basename $(notdir $(wildcard $(operators_dir)/*_test.cpp)))

# compile_single: $(COMPILE_SINGLE_TARGETS)

# runtime_single:
# 	python2 pr_flow.py $(prj_name) -runtime -op '$(basename $(notdir $(operators)))'
# 	cp $(operators_xclbin_targets) $(ws_bit)/sd_card
# 	cd $(ws_bit)/$(prj_name)/host && ./gen_runtime.sh
# 	cd $(ws_bit)/$(prj_name)/host && ./gen_runtime_check_result.sh
# 	#cd $(ws_bit)/$(prj_name)/host && ./gen_runtime_single.sh

# xclbin_single: 
# 	python2 pr_flow.py $(prj_name) -xclbin -op $(operator_test)
# 	cd $(ws_bit) && ./main_$(operator_test).sh $(operators)
# bit_single:
# 	python2 pr_flow.py $(prj_name) -impl -op $(operator_test)
# 	cd $(ws_impl)/$(operator_test) && ./main.sh $(operators)
# syn_single:
# 	python2 pr_flow.py $(prj_name) -syn -op $(operator_test)
# 	cd $(ws_syn)/$(operator_test) && ./main.sh $(operators)
# hls_single:
# 	python2 pr_flow.py $(prj_name) -hls -op $(operator_test)
# 	cd $(ws_hls) && ./main_$(operator_test).sh $(operators)
# test_done:
# 	echo "incremental compile done"
# run_on_fpga:
# 	if [ ! -f ./input_src/$(prj_name)/operators/test/__test_done__ ]; then cd $(ws_bit) && ./run_on_fpga.sh; fi
# run_on_fpga_single:
# 	if [ ! -f ./input_src/$(prj_name)/operators/test/__test_done__ ]; then cd $(ws_bit) && ./run_on_fpga_single.sh; fi



$(ws_overlay)$(overlay_suffix)/src : common/verilog_src/*  common/script_src/project_syn_gen_zcu102.tcl
	rm -rf ./workspace/F001_overlay
	mkdir -p ./workspace/F001_overlay
	python2 pr_flow.py $(prj_name) -g

mono_prj: $(mono_bft_target)

# prepare the logic equivalent monolithic project 
$(mono_bft_target): $(ws_overlay)$(overlay_suffix)/src  $(operators_ip_targets)
	python2 pr_flow.py $(prj_name) -mbft
	cd $(ws_mbft) && ./main.sh

# prepare the ip package for monolithic project
$(operators_ip_targets):$(ws_mbft)/ip_repo/%/prj/floorplan_static.xpr:$(ws_hls)/runLog%.log
	echo $@
	python2 pr_flow.py $(prj_name) -ip -op $(subst runLog,,$(basename $(notdir $<)))
	cd $(ws_mbft)/ip_repo/$(subst runLog,,$(basename $(notdir $<))) && ./qsub_run.sh

cp_mono_prj: ./workspace/vitis/floorplan_static_wrapper.xsa 

./workspace/vitis/floorplan_static_wrapper.xsa: ./workspace/F007_mono_bft_$(prj_name)/prj/floorplan_static.sdk/floorplan_static_wrapper.xsa
	mkdir -p workspace/vitis
	cp $< ./workspace/vitis


clear:
	rm -rf ./workspace/*$(prj_name) 
clean:
	rm -rf ./workspace
	rm -rf ./pr_flow/*.pyc

clear_impl:
	rm -rf ./workspace/F004_impl_$(prj_name)
	rm -rf ./workspace/F005_bits_$(prj_name)
