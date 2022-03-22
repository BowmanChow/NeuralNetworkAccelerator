CC := vcs
SV_FLAG := -sverilog
TEST_DIR := ../test
TEST_FILE := ${TEST_DIR}/test_single_port.sv
FLAG_FILE := ${TEST_DIR}/flags.sv
SV_DIR := ../src
ICC_OUTPUT_DIR := ../icc/outputs
MODULES := sigmoid_PLAN
ICC_OUTPUT_FILE := $(foreach m, $(MODULES), ${ICC_OUTPUT_DIR}/${m}/${m}.output.v)
ICC_OUTPUT_FILE += ./scc40nll_vhsc40_rvt.v
SV_FILES := $(foreach m, $(MODULES), ${SV_DIR}/${m}.sv)
VCS_FLAGS := +v2k -debug_all -R +incdir+${SV_DIR} +incdir+${TEST_DIR}
NAME_FILE := ../name.tcl

all: dc icc post ptpx
	@echo 'make all'

rtl:
	@echo ${SV_FILES};
	@echo '`define MODULE ${MODULES}' > ${FLAG_FILE}
	$(CC) ${SV_FLAG} ${TEST_FILE} ${SV_FILES} ${VCS_FLAGS}

post:
	@echo ${ICC_OUTPUT_FILE};
	@echo '`define MODULE ${MODULES}' > ${FLAG_FILE}
	@echo '`define IS_POST' >> ${FLAG_FILE}
	$(CC) ${SV_FLAG} ${TEST_FILE} ${ICC_OUTPUT_FILE} ${VCS_FLAGS}

name: ${NAME_FILE}
	@echo 'set DESIGN ${MODULES}' > ${NAME_FILE}

dc: name
	cd ../dc; dc_shell -f synthesis.tcl | tee run.log

icc: name
	cd ../icc; icc_shell -f top.tcl | tee run.log

ptpx: name
	cd ../ptpx; pt_shell -f ptpx.tcl | tee run.log

.PHONY: all dc icc post ptpx name rtl