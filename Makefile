############################################################################################

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

#############################################################################################

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
# WIP: operators_impl is necessary only when there exists multiple operators in one PR 
operators_impl=$(shell python ./pr_flow/parse_op_list.py -prj $(prj_name))

operators_bit_targets=$(foreach n, $(operators_impl), $(ws_bit)/$(n).bit)
operators_xclbin_targets=$(foreach n, $(operators_impl), $(ws_bit)/$(n).xclbin)
operators_runtime_target=$(ws_bit)/sd_card/app.exe


# overlay_type=hipr
ifeq ($(overlay_type),hipr)
overlay_suffix=_$(prj_name)
endif


all: $(operators_runtime_target)

runtime:$(operators_runtime_target) # NOTE: operators
$(operators_runtime_target):./input_src/$(prj_name)/host/host.cpp $(operators_xclbin_targets) ./pr_flow/runtime.py
	python2 pr_flow.py $(prj_name) -runtime -op '$(operators)'
	cp $(operators_xclbin_targets) $(ws_bit)/sd_card
	cd $(ws_bit)/$(prj_name)/host && ./gen_runtime.sh
	
xclbin: $(operators_xclbin_targets) # NOTE: operators_impl
$(operators_xclbin_targets):$(ws_bit)/%.xclbin:$(ws_bit)/%.bit
	python2 pr_flow.py $(prj_name) -xclbin -op $(basename $(notdir $@))
	cd $(ws_bit) && ./main_$(basename $(notdir $@)).sh $(operators_impl)

bits:$(operators_bit_targets) # NOTE: operators_impl
$(operators_bit_targets):$(ws_bit)/%.bit:$(ws_overlay)$(overlay_suffix)/__overlay_is_ready__ $(ws_syn)/%/pblock.json $(ws_syn)/%/page_netlist.dcp
	python2 pr_flow.py $(prj_name) -impl -op $(basename $(notdir $@))
	cd $(ws_impl)/$(basename $(notdir $@)) && ./main.sh $(operators_impl)

sync:$(operators_pblocks) 
$(operators_pblocks):$(ws_syn)/%/pblock.json: | pg_assign

# Page assignment starts after all synth jobs finished
pg_assign:$(ws_syn)/pblock_assignment.json
$(ws_syn)/pblock_assignment.json: $(operators_syn_targets) ./common/script_src/nested_pg_assign.py $(operators_dir)/pblock_operators_list.json
	cd $(ws_syn) && python nested_pg_assign.py -prj $(prj_name)

# Synthesis
syn:$(operators_syn_targets)
# Out-of-Context Synthesis from Verilog to post-synthesis DCP
$(operators_syn_targets):$(ws_syn)/%/page_netlist.dcp:$(ws_hls)/runLog%.log $(ws_overlay)$(overlay_suffix)/__overlay_is_ready__ ./pr_flow/syn.py
	python2 pr_flow.py $(prj_name) -syn -op $(subst runLog,,$(basename $(notdir $<)))
	#cd $(ws_syn)/$(subst runLog,,$(basename $(notdir $<)))/riscv && ./qsub_run.sh
	cd $(ws_syn)/$(subst runLog,,$(basename $(notdir $<))) && ./main.sh $(operators)

# HLS
hls: $(operators_hls_targets)
# High-Level-Synthesis from C to Verilog
$(operators_hls_targets):$(ws_hls)/runLog%.log:$(operators_dir)/%.cpp $(operators_dir)/%.h ./pr_flow/hls.py
	python2 pr_flow.py $(prj_name) -hls -op $(basename $(notdir $<))
	cd $(ws_hls) && ./main_$(basename $(notdir $<)).sh $(operators)

overlay: $(ws_overlay)$(overlay_suffix)/__overlay_is_ready__
$(ws_overlay)$(overlay_suffix)/__overlay_is_ready__:
	python2 pr_flow.py $(prj_name) -g -op '$(basename $(notdir $(operators)))' -bft_n=$(bft_n)
	cd ./workspace/F001_overlay$(overlay_suffix) && ./main.sh

.PHONY: report 
report: 
	 python2 ./pr_flow.py $(prj_name) -op '$(basename $(notdir $(operators_bit_targets)))' -rpt

# When pre-stocking overlays,
# if bft_n==23: p2~p23 
# if bft_n==10, p2~p10
# if bft_n==12, p2~p12
bft_n=23
overlay_only:
	python2 pr_flow.py $(prj_name) -g -op '$(basename $(notdir $(operators)))' -bft_n=$(bft_n)
	cd ./workspace/F001_overlay$(overlay_suffix) && ./main.sh

# Incremental compile
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


clear:
	rm -rf ./workspace/*$(prj_name)

clean:
	rm -rf ./workspace
	rm -rf ./pr_flow/*.pyc

clear_impl:
	rm -rf ./workspace/F004_impl_$(prj_name)
	rm -rf ./workspace/F005_bits_$(prj_name)