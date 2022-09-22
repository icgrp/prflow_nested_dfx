ifndef XILINX_VIVADO
  $(error Environment variable XILINX_VIVADO is required and should point to Vitis install area)
endif

vitis_impl_tcl_name=pfm_top_wrapper
kl_name=ydma
workspace=..
impl_dir=$(workspace)/_x/link/vivado/vpl/prj/prj.runs/impl_1
final_route_design=./checkpoint/sub_p20_p1/p20_p1_subdivide_route_design.dcp
leaves=leaf_double_1 leaf_double_2 leaf_quad_1 leaf_quad_2 leaf_quad_3 leaf_quad_4
leaf_dcps=$(foreach leaf, $(leaves), ./checkpoint/$(leaf).dcp)
lowest_pblocks=p2_p0 p2_p1 $\
							 p4_p0_p0 p4_p0_p1 p4_p1_p0 p4_p1_p1 $\
							 p8_p0_p0 p8_p0_p1 p8_p1_p0 p8_p1_p1 $\
							 p12_p0_p0 p12_p0_p1 p12_p1_p0 p12_p1_p1 $\
							 p16_p0_p0 p16_p0_p1 p16_p1_p0 p16_p1_p1 $\
							 p20_p0_p0 p20_p0_p1 p20_p1_p0 p20_p1_p1
non_lowest_pblocks=p2 $\
									 p4 p4_p0 p4_p1 $\
									 p8 p8_p0 p8_p1 $\
									 p12 p12_p0 p12_p1 $\
									 p16 p16_p0 p16_p1 $\
									 p20 p20_p0 p20_p1
all_pblocks=$(lowest_pblocks) $(non_lowest_pblocks)
child_abs_shells=$(foreach p, $(lowest_pblocks), ./checkpoint/$(p).dcp)
parent_abs_shells=$(foreach p, $(non_lowest_pblocks), ./checkpoint/$(p).dcp)
abs_analysis_rpts=$(foreach p, $(all_pblocks), ./checkpoint/abs_analysis/$(p).rpt)

all: ../../../__overlay_is_ready__

../../../__overlay_is_ready__: $(impl_dir)/design_route.dcp all_nested
	touch ../../../__overlay_is_ready__


all_nested: gen_abs_shells pr_recombine_dynamic pr_recombine gen_leaf_dcps gen_abs_analysis_rpts


#####################
# Nested DFX starts #
#####################

gen_abs_analysis_rpts: $(abs_analysis_rpts)
$(abs_analysis_rpts):./checkpoint/abs_analysis/%.rpt: ./overlay_p23/%.dcp ./tcl/abs_analysis/abs_analysis_%.tcl
	./shell/run_tcl.sh ./tcl/abs_analysis/abs_analysis_$(basename $(notdir $(@))).tcl > ./checkpoint/logs/abs_analysis_$(basename $(notdir $(@))).log

##
## pr_recombine and generate abs shell for parent lvl dfx
## starts when the final routed design is created
##
# this command below needs to run in GUI mode(seems like a bug)
pr_recombine_dynamic: ./checkpoint/dynamic_region.bit
./checkpoint/dynamic_region.bit: $(final_route_design)
	./shell/run_tcl.sh ./tcl/nested/pr_recombine_dynamic_region.tcl > ./checkpoint/logs/pr_recombine_dynamic_region.log

pr_recombine: $(parent_abs_shells)
$(parent_abs_shells):./checkpoint/%.dcp: $(final_route_design)
	./shell/run_tcl.sh ./tcl/nested/pr_recombine_$(subst _subdivide,,$(basename $(notdir $@))).tcl > ./checkpoint/logs/pr_recombine_$(subst _subdivide,,$(basename $(notdir $@))).log

##
## abs shell for the lowest lvl dfx
## starts when the final routed design is created
##
gen_abs_shells: $(child_abs_shells)
$(child_abs_shells):./checkpoint/%.dcp: $(final_route_design)
	./shell/run_tcl.sh ./tcl/nested/abs_$(basename $(notdir $(@))).tcl > ./checkpoint/logs/abs_$(basename $(notdir $(@))).log


##
## different types of leaf dcp files, will be used in after synthesis phase
##
gen_leaf_dcps: $(leaf_dcps)
$(leaf_dcps):./checkpoint/%.dcp:./src4level2/leaf/%.v ./tcl/leaf_syn/ooc_syn_%.tcl
	./shell/run_tcl.sh ./tcl/leaf_syn/ooc_syn_$(basename $(notdir $(@))).tcl


##
## p20, p20_p0, p20_p1, 
##
impl_p20_p1_subdivide:./checkpoint/sub_p20_p1/p20_p1_subdivide_route_design.dcp
./checkpoint/sub_p20_p1/p20_p1_subdivide_route_design.dcp: ./checkpoint/sub_p20_p0/p20_p0_subdivide_route_design.dcp ./checkpoint/subdivide/page_double_subdivide_p20_p1.dcp ./xdc/nested/p20_p1_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p20_p1.tcl > ./checkpoint/logs/subdivide_p20_p1.log
	./shell/run_tcl.sh ./tcl/nested/impl_p20_p1_subdivide.tcl > ./checkpoint/logs/impl_p20_p1_subdivide.log
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p20_p1

impl_p20_p0_subdivide:./checkpoint/sub_p20_p0/p20_p0_subdivide_route_design.dcp
./checkpoint/sub_p20_p0/p20_p0_subdivide_route_design.dcp: ./checkpoint/sub_p20/p20_subdivide_route_design.dcp ./checkpoint/subdivide/page_double_subdivide_p20_p0.dcp ./xdc/nested/p20_p0_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p20_p0.tcl > ./checkpoint/logs/subdivide_p20_p0.log
	./shell/run_tcl.sh ./tcl/nested/impl_p20_p0_subdivide.tcl > ./checkpoint/logs/impl_p20_p0_subdivide.log
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p20_p0

impl_p20_subdivide:./checkpoint/sub_p20/p20_subdivide_route_design.dcp
./checkpoint/sub_p20/p20_subdivide_route_design.dcp: ./checkpoint/sub_p16_p1/p16_p1_subdivide_route_design.dcp ./checkpoint/subdivide/page_quad_subdivide_p20.dcp ./xdc/nested/p20_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p20.tcl > ./checkpoint/logs/subdivide_p20.log
	./shell/run_tcl.sh ./tcl/nested/impl_p20_subdivide.tcl > ./checkpoint/logs/impl_p20_subdivide.log
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p20

##
## p16, p16_p0, p16_p1, 
##
impl_p16_p1_subdivide:./checkpoint/sub_p16_p1/p16_p1_subdivide_route_design.dcp
./checkpoint/sub_p16_p1/p16_p1_subdivide_route_design.dcp: ./checkpoint/sub_p16_p0/p16_p0_subdivide_route_design.dcp ./checkpoint/subdivide/page_double_subdivide_p16_p1.dcp ./xdc/nested/p16_p1_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p16_p1.tcl > ./checkpoint/logs/subdivide_p16_p1.log
	./shell/run_tcl.sh ./tcl/nested/impl_p16_p1_subdivide.tcl > ./checkpoint/logs/impl_p16_p1_subdivide.log
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p16_p1

impl_p16_p0_subdivide:./checkpoint/sub_p16_p0/p16_p0_subdivide_route_design.dcp
./checkpoint/sub_p16_p0/p16_p0_subdivide_route_design.dcp: ./checkpoint/sub_p16/p16_subdivide_route_design.dcp ./checkpoint/subdivide/page_double_subdivide_p16_p0.dcp ./xdc/nested/p16_p0_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p16_p0.tcl > ./checkpoint/logs/subdivide_p16_p0.log
	./shell/run_tcl.sh ./tcl/nested/impl_p16_p0_subdivide.tcl > ./checkpoint/logs/impl_p16_p0_subdivide.log
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p16_p0

impl_p16_subdivide:./checkpoint/sub_p16/p16_subdivide_route_design.dcp
./checkpoint/sub_p16/p16_subdivide_route_design.dcp: ./checkpoint/sub_p12_p1/p12_p1_subdivide_route_design.dcp ./checkpoint/subdivide/page_quad_subdivide_p16.dcp ./xdc/nested/p16_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p16.tcl > ./checkpoint/logs/subdivide_p16.log
	./shell/run_tcl.sh ./tcl/nested/impl_p16_subdivide.tcl > ./checkpoint/logs/impl_p16_subdivide.log
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p16

##
## p12, p12_p0, p12_p1, 
##
impl_p12_p1_subdivide:./checkpoint/sub_p12_p1/p12_p1_subdivide_route_design.dcp
./checkpoint/sub_p12_p1/p12_p1_subdivide_route_design.dcp: ./checkpoint/sub_p12_p0/p12_p0_subdivide_route_design.dcp ./checkpoint/subdivide/page_double_subdivide_p12_p1.dcp ./xdc/nested/p12_p1_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p12_p1.tcl > ./checkpoint/logs/subdivide_p12_p1.log
	./shell/run_tcl.sh ./tcl/nested/impl_p12_p1_subdivide.tcl > ./checkpoint/logs/impl_p12_p1_subdivide.log
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p12_p1

impl_p12_p0_subdivide:./checkpoint/sub_p12_p0/p12_p0_subdivide_route_design.dcp
./checkpoint/sub_p12_p0/p12_p0_subdivide_route_design.dcp: ./checkpoint/sub_p12/p12_subdivide_route_design.dcp ./checkpoint/subdivide/page_double_subdivide_p12_p0.dcp ./xdc/nested/p12_p0_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p12_p0.tcl > ./checkpoint/logs/subdivide_p12_p0.log
	./shell/run_tcl.sh ./tcl/nested/impl_p12_p0_subdivide.tcl > ./checkpoint/logs/impl_p12_p0_subdivide.log
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p12_p0

impl_p12_subdivide:./checkpoint/sub_p12/p12_subdivide_route_design.dcp
./checkpoint/sub_p12/p12_subdivide_route_design.dcp: ./checkpoint/sub_p8_p1/p8_p1_subdivide_route_design.dcp ./checkpoint/subdivide/page_quad_subdivide_p12.dcp ./xdc/nested/p12_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p12.tcl > ./checkpoint/logs/subdivide_p12.log
	./shell/run_tcl.sh ./tcl/nested/impl_p12_subdivide.tcl > ./checkpoint/logs/impl_p12_subdivide.log
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p12

##
## p8, p8_p0, p8_p1, 
##
impl_p8_p1_subdivide:./checkpoint/sub_p8_p1/p8_p1_subdivide_route_design.dcp
./checkpoint/sub_p8_p1/p8_p1_subdivide_route_design.dcp: ./checkpoint/sub_p8_p0/p8_p0_subdivide_route_design.dcp ./checkpoint/subdivide/page_double_subdivide_p8_p1.dcp ./xdc/nested/p8_p1_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p8_p1.tcl > ./checkpoint/logs/subdivide_p8_p1.log
	./shell/run_tcl.sh ./tcl/nested/impl_p8_p1_subdivide.tcl > ./checkpoint/logs/impl_p8_p1_subdivide.log
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p8_p1

impl_p8_p0_subdivide:./checkpoint/sub_p8_p0/p8_p0_subdivide_route_design.dcp
./checkpoint/sub_p8_p0/p8_p0_subdivide_route_design.dcp: ./checkpoint/sub_p8/p8_subdivide_route_design.dcp ./checkpoint/subdivide/page_double_subdivide_p8_p0.dcp ./xdc/nested/p8_p0_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p8_p0.tcl > ./checkpoint/logs/subdivide_p8_p0.log
	./shell/run_tcl.sh ./tcl/nested/impl_p8_p0_subdivide.tcl > ./checkpoint/logs/impl_p8_p0_subdivide.log
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p8_p0

impl_p8_subdivide:./checkpoint/sub_p8/p8_subdivide_route_design.dcp
./checkpoint/sub_p8/p8_subdivide_route_design.dcp: ./checkpoint/sub_p4_p1/p4_p1_subdivide_route_design.dcp ./checkpoint/subdivide/page_quad_subdivide_p8.dcp ./xdc/nested/p8_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p8.tcl > ./checkpoint/logs/subdivide_p8.log
	./shell/run_tcl.sh ./tcl/nested/impl_p8_subdivide.tcl > ./checkpoint/logs/impl_p8_subdivide.log
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p8


##
## p4, p4_0, p4_1
##
impl_p4_p1_subdivide:./checkpoint/sub_p4_p1/p4_p1_subdivide_route_design.dcp
./checkpoint/sub_p4_p1/p4_p1_subdivide_route_design.dcp: ./checkpoint/sub_p4_p0/p4_p0_subdivide_route_design.dcp ./checkpoint/subdivide/page_double_subdivide_p4_p1.dcp ./xdc/nested/p4_p1_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p4_p1.tcl > ./checkpoint/logs/subdivide_p4_p1.log
	./shell/run_tcl.sh ./tcl/nested/impl_p4_p1_subdivide.tcl > ./checkpoint/logs/impl_p4_p1_subdivide.log
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p4_p1

impl_p4_p0_subdivide:./checkpoint/sub_p4_p0/p4_p0_subdivide_route_design.dcp
./checkpoint/sub_p4_p0/p4_p0_subdivide_route_design.dcp: ./checkpoint/sub_p4/p4_subdivide_route_design.dcp ./checkpoint/subdivide/page_double_subdivide_p4_p0.dcp ./xdc/nested/p4_p0_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p4_p0.tcl > ./checkpoint/logs/subdivide_p4_p0.log
	./shell/run_tcl.sh ./tcl/nested/impl_p4_p0_subdivide.tcl > ./checkpoint/logs/impl_p4_p0_subdivide.log
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p4_p0

impl_p4_subdivide:./checkpoint/sub_p4/p4_subdivide_route_design.dcp
./checkpoint/sub_p4/p4_subdivide_route_design.dcp: ./checkpoint/sub_p2/p2_subdivide_route_design.dcp ./checkpoint/subdivide/page_quad_subdivide_p4.dcp ./xdc/nested/p4_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p4.tcl > ./checkpoint/logs/subdivide_p4.log
	./shell/run_tcl.sh ./tcl/nested/impl_p4_subdivide.tcl > ./checkpoint/logs/impl_p4_subdivide.log
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p4


##
## p2
##
impl_p2_subdivide:./checkpoint/sub_p2/p2_subdivide_route_design.dcp
./checkpoint/sub_p2/p2_subdivide_route_design.dcp: $(impl_dir)/design_route.dcp ./checkpoint/subdivide/page_double_subdivide_p2.dcp ./xdc/nested/p2_subdivide.xdc
	./shell/run_tcl.sh ./tcl/nested/subdivide_p2.tcl > ./checkpoint/logs/subdivide_p2.log
	./shell/run_tcl.sh ./tcl/nested/impl_p2_subdivide.tcl > ./checkpoint/logs/impl_p2_subdivide.log
	mkdir -p ./hd_visual_dir
	cp -r ./hd_visual ./hd_visual_dir/hd_visual_p2


##
## page_oct, page_quad, page_double subdivided versions
## NOTE: Because we use "additive" design checkpoint to generate a new nested pblock for a new RP, pr_subdivide command for the 
##       specific cell doesn't work. Workaround is creating a separate netlist for each cell.
##
# page_oct_subdivide:./checkpoint/page_oct_subdivide.dcp
# ./checkpoint/page_oct_subdivide.dcp: ./src4level2/page_oct_subdivide/* ./tcl/out_of_context_syn_page_oct_subdivide.tcl
# 	./shell/run_tcl.sh ./tcl/out_of_context_syn_page_oct_subdivide.tcl

# page_quad_subdivide:./checkpoint/page_quad_subdivide.dcp
# ./checkpoint/page_quad_subdivide.dcp: ./src4level2/page_quad_subdivide/* ./tcl/out_of_context_syn_page_quad_subdivide.tcl
# 	./shell/run_tcl.sh ./tcl/out_of_context_syn_page_quad_subdivide.tcl

page_double_subdivide_p2:./checkpoint/subdivide/page_double_subdivide_p2.dcp
./checkpoint/subdivide/page_double_subdivide_p2.dcp: ./src4level2/subdivide/p_d_s_p2.v ./tcl/subdivide_syn/ooc_syn_p_d_s_p2.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_d_s_p2.tcl

page_quad_subdivide_p4:./checkpoint/subdivide/page_quad_subdivide_p4.dcp
./checkpoint/subdivide/page_quad_subdivide_p4.dcp: ./src4level2/subdivide/p_q_s_p4.v ./tcl/subdivide_syn/ooc_syn_p_q_s_p4.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_q_s_p4.tcl

page_double_subdivide_p4_p0:./checkpoint/subdivide/page_double_subdivide_p4_p0.dcp
./checkpoint/subdivide/page_double_subdivide_p4_p0.dcp: ./src4level2/subdivide/p_d_s_p4_p0.v ./tcl/subdivide_syn/ooc_syn_p_d_s_p4_p0.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_d_s_p4_p0.tcl

page_double_subdivide_p4_p1:./checkpoint/subdivide/page_double_subdivide_p4_p1.dcp
./checkpoint/subdivide/page_double_subdivide_p4_p1.dcp: ./src4level2/subdivide/p_d_s_p4_p1.v ./tcl/subdivide_syn/ooc_syn_p_d_s_p4_p1.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_d_s_p4_p1.tcl

page_quad_subdivide_p8:./checkpoint/subdivide/page_quad_subdivide_p8.dcp
./checkpoint/subdivide/page_quad_subdivide_p8.dcp: ./src4level2/subdivide/p_q_s_p8.v ./tcl/subdivide_syn/ooc_syn_p_q_s_p8.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_q_s_p8.tcl

page_double_subdivide_p8_p0:./checkpoint/subdivide/page_double_subdivide_p8_p0.dcp
./checkpoint/subdivide/page_double_subdivide_p8_p0.dcp: ./src4level2/subdivide/p_d_s_p8_p0.v ./tcl/subdivide_syn/ooc_syn_p_d_s_p8_p0.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_d_s_p8_p0.tcl

page_double_subdivide_p8_p1:./checkpoint/subdivide/page_double_subdivide_p8_p1.dcp
./checkpoint/subdivide/page_double_subdivide_p8_p1.dcp: ./src4level2/subdivide/p_d_s_p8_p1.v ./tcl/subdivide_syn/ooc_syn_p_d_s_p8_p1.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_d_s_p8_p1.tcl

page_quad_subdivide_p12:./checkpoint/subdivide/page_quad_subdivide_p12.dcp
./checkpoint/subdivide/page_quad_subdivide_p12.dcp: ./src4level2/subdivide/p_q_s_p12.v ./tcl/subdivide_syn/ooc_syn_p_q_s_p12.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_q_s_p12.tcl

page_double_subdivide_p12_p0:./checkpoint/subdivide/page_double_subdivide_p12_p0.dcp
./checkpoint/subdivide/page_double_subdivide_p12_p0.dcp: ./src4level2/subdivide/p_d_s_p12_p0.v ./tcl/subdivide_syn/ooc_syn_p_d_s_p12_p0.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_d_s_p12_p0.tcl

page_double_subdivide_p12_p1:./checkpoint/subdivide/page_double_subdivide_p12_p1.dcp
./checkpoint/subdivide/page_double_subdivide_p12_p1.dcp: ./src4level2/subdivide/p_d_s_p12_p1.v ./tcl/subdivide_syn/ooc_syn_p_d_s_p12_p1.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_d_s_p12_p1.tcl

page_quad_subdivide_p16:./checkpoint/subdivide/page_quad_subdivide_p16.dcp
./checkpoint/subdivide/page_quad_subdivide_p16.dcp: ./src4level2/subdivide/p_q_s_p16.v ./tcl/subdivide_syn/ooc_syn_p_q_s_p16.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_q_s_p16.tcl

page_double_subdivide_p16_p0:./checkpoint/subdivide/page_double_subdivide_p16_p0.dcp
./checkpoint/subdivide/page_double_subdivide_p16_p0.dcp: ./src4level2/subdivide/p_d_s_p16_p0.v ./tcl/subdivide_syn/ooc_syn_p_d_s_p16_p0.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_d_s_p16_p0.tcl

page_double_subdivide_p16_p1:./checkpoint/subdivide/page_double_subdivide_p16_p1.dcp
./checkpoint/subdivide/page_double_subdivide_p16_p1.dcp: ./src4level2/subdivide/p_d_s_p16_p1.v ./tcl/subdivide_syn/ooc_syn_p_d_s_p16_p1.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_d_s_p16_p1.tcl

page_quad_subdivide_p20:./checkpoint/subdivide/page_quad_subdivide_p20.dcp
./checkpoint/subdivide/page_quad_subdivide_p20.dcp: ./src4level2/subdivide/p_q_s_p20.v ./tcl/subdivide_syn/ooc_syn_p_q_s_p20.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_q_s_p20.tcl

page_double_subdivide_p20_p0:./checkpoint/subdivide/page_double_subdivide_p20_p0.dcp
./checkpoint/subdivide/page_double_subdivide_p20_p0.dcp: ./src4level2/subdivide/p_d_s_p20_p0.v ./tcl/subdivide_syn/ooc_syn_p_d_s_p20_p0.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_d_s_p20_p0.tcl

page_double_subdivide_p20_p1:./checkpoint/subdivide/page_double_subdivide_p20_p1.dcp
./checkpoint/subdivide/page_double_subdivide_p20_p1.dcp: ./src4level2/subdivide/p_d_s_p20_p1.v ./tcl/subdivide_syn/ooc_syn_p_d_s_p20_p1.tcl
	./shell/run_tcl.sh ./tcl/subdivide_syn/ooc_syn_p_d_s_p20_p1.tcl



#########################
# Nested DFX stuff ends #
#########################

# $(context_dcps):checkpoint/p_%.dcp:$(impl_dir)/abs_gen%.tcl $(impl_dir)/run_tcl.sh $(impl_dir)/design_route.dcp
# 	cd $(impl_dir)/ && ./run_tcl.sh $(notdir $<) 
# 	cp $(impl_dir)/p_$(notdir $(subst tcl,dcp, $(subst abs_gen,, $(notdir $<)))) ./checkpoint

overlay:$(impl_dir)/design_route.dcp
$(impl_dir)/design_route.dcp: $(impl_dir)/$(vitis_impl_tcl_name)_mk_overlay.tcl $(impl_dir)/run_tcl.sh ./checkpoint/page.dcp ./checkpoint/page_double.dcp ./checkpoint/page_quad.dcp ./checkpoint/hw_bb_divided.dcp ./xdc/sub_p23.xdc
	cd $(subst design_route,, $(basename $@)) && ./run_tcl.sh $(vitis_impl_tcl_name)_mk_overlay.tcl
	cp $(impl_dir)/design_route.dcp ./checkpoint/overlay.dcp

$(impl_dir)/run_tcl.sh: ./shell/run_tcl.sh
	cp ./shell/run_tcl.sh $(impl_dir)

page:./checkpoint/page.dcp
./checkpoint/page.dcp: ./src4level2/pages/page.v ./tcl/page_syn/ooc_syn_page.tcl
	./shell/run_tcl.sh ./tcl/page_syn/ooc_syn_page.tcl	

page_double:./checkpoint/page_double.dcp
./checkpoint/page_double.dcp: ./src4level2/pages/page_double.v ./tcl/page_syn/ooc_syn_page_double.tcl
	./shell/run_tcl.sh ./tcl/page_syn/ooc_syn_page_double.tcl	

page_quad:./checkpoint/page_quad.dcp
./checkpoint/page_quad.dcp: ./src4level2/pages/page_quad.v ./tcl/page_syn/ooc_syn_page_quad.tcl
	./shell/run_tcl.sh ./tcl/page_syn/ooc_syn_page_quad.tcl	


./checkpoint/hw_bb_divided.dcp: ./checkpoint/pfm_dynamic_new_bb.dcp ./checkpoint/hw_bb_locked.dcp ./tcl/sub_divided.tcl 
	./shell/run_tcl.sh ./tcl/sub_divided.tcl

./checkpoint/pfm_dynamic_new_bb.dcp:./checkpoint/pfm_dynamic_bb.dcp ./tcl/replace_sub_module_level1.tcl ./checkpoint/$(kl_name)_bb.dcp 
	./shell/run_tcl.sh ./tcl/replace_sub_module_level1.tcl

./checkpoint/$(kl_name)_bb.dcp: ./src4level2/ydma_bb/* ./tcl/out_of_context_syn_$(kl_name)_bb.tcl
	./shell/run_tcl.sh ./tcl/out_of_context_syn_$(kl_name)_bb.tcl	

./checkpoint/pfm_dynamic_bb.dcp:./checkpoint/pfm_dynamic.dcp ./tcl/empty_pfm_dynamic.tcl
	./shell/run_tcl.sh ./tcl/empty_pfm_dynamic.tcl

./checkpoint/pfm_dynamic.dcp: $(impl_dir)/gen_pfm_dynamic.tcl
	./shell/run_gen_pfm_dynamic.sh $(workspace) 

modify:$(impl_dir)/gen_pfm_dynamic.tcl

$(impl_dir)/gen_pfm_dynamic.tcl:$(impl_dir)/$(vitis_impl_tcl_name).tcl ./python/mk_gen_pfm_tcl.py
	./shell/run_python.sh ./python/mk_gen_pfm_tcl.py $(workspace) $(kl_name) $(vitis_impl_tcl_name)

overlay_tcl:$(impl_dir)/$(vitis_impl_tcl_name)_mk_overlay.tcl

# $(abs_gen_tcls): ./python/mk_abs_tcl.py
# 	./shell/run_python.sh ./python/mk_abs_tcl.py $(workspace) $(kl_name) $(vitis_impl_tcl_name)

$(impl_dir)/$(vitis_impl_tcl_name)_mk_overlay.tcl:$(impl_dir)/$(vitis_impl_tcl_name).tcl ./python/mk_overlay_tcl.py
	./shell/run_python.sh ./python/mk_overlay_tcl.py $(workspace) $(kl_name) $(vitis_impl_tcl_name)

checkpoint/hw_bb_locked.dcp: ../_x/link/vivado/vpl/.local/hw_platform/hw_bb_locked.dcp
	mkdir -p checkpoint
	mkdir -p checkpoint/logs
	mkdir -p checkpoint/subdivide
	mkdir -p checkpoint/abs_analysis	
	cp $< $@

clean:
	rm -rf *.log *.jou *.rpt .Xil hd_visual *.str *.txt checkpoint/* 
