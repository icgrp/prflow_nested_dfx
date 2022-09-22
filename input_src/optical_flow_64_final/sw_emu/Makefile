PRJ_NAME=ydma
SRC_DIR=..
#img_src=$(basename $(notdir $(wildcard $(SRC_DIR)/imageLib/*.cpp)))
img_name=$(basename $(wildcard $(SRC_DIR)/host/imageLib/*.cpp))
img_obj=$(addsuffix .o, $(img_name))
#img_src=$(wildcard $(SRC_DIR)/imageLib/*.cpp)
operators_src=$(wildcard $(SRC_DIR)/operators/*.cpp)



all: package/sd_card.img
# all: app.exe emconfig.json $(PRJ_NAME).xclbin

app.exe: $(SRC_DIR)/host/host.cpp $(img_obj)
	${CXX} -Wall -g -std=c++11 $(SRC_DIR)/host/host.cpp $(img_obj) -o app.exe \
		-I${XILINX_XRT}/include/ \
		-I${XILINX_VIVADO}/include/ \
		-L${XILINX_XRT}/lib/ -lOpenCL -lpthread -lrt -lstdc++

$(img_obj):$(SRC_DIR)/host/imageLib/%.o:$(SRC_DIR)/host/imageLib/%.cpp 
	${CXX} -Wall -g -std=c++11 -c $^ -o $@


$(PRJ_NAME).xo: $(SRC_DIR)/host/top.cpp $(SRC_DIR)/host/typedefs.h $(operators_src)
	v++ -c -t ${TARGET} --config $(SRC_DIR)/cfg/zcu102_dfx.cfg -k $(PRJ_NAME) \
	-I${XILINX_VIVADO}/include/ \
	-I$(SRC_DIR)/ \
	-I$(SRC_DIR)/host \
	$^ -o $(PRJ_NAME).xo 

$(PRJ_NAME).xclbin: ./$(PRJ_NAME).xo
	v++ -l -t ${TARGET} --config $(SRC_DIR)/cfg/zcu102_dfx.cfg ./$(PRJ_NAME).xo -o $(PRJ_NAME).xclbin

package/sd_card.img: app.exe emconfig.json $(PRJ_NAME).xclbin xrt.ini run_app.sh
	$(call ndef,ROOTFS)
	v++ -p -t ${TARGET} --config $(SRC_DIR)/cfg/zcu102_dfx.cfg $(PRJ_NAME).xclbin \
		--package.out_dir package \
		--package.rootfs ${ROOTFS}/rootfs.ext4 \
		--package.sd_file $(PRJ_NAME).xclbin \
		--package.sd_file ${ROOTFS}/Image \
		--package.sd_file xrt.ini \
		--package.sd_file emconfig.json \
		--package.sd_file app.exe \
		--package.sd_file run_app.sh \
		--package.sd_file ./current

emconfig.json:
	emconfigutil --platform xilinx_zcu102_base_dfx_202110_1 --nd 1

clean:
	rm -rf $(PRJ_NAME)* app.exe *json *csv *log *summary _x xilinx* .run .Xil .ipcache *.jou
	rm -rf $(SRC_DIR)/host/imageLib/*.o

# Unless specified, use the current directory name as the v++ build target
TARGET ?= $(notdir $(CURDIR))
