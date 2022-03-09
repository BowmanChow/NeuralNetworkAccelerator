CC := vcs
SV_FLAG := -sverilog
SV_DIR := ../
MODULES := test_sigmoid TwosComplement sigmoid_alippi
SV_FILES := $(foreach m, $(MODULES), ${SV_DIR}${m}.sv)
VCS_FLAGS := +v2k -debug_all -R

all:
	@echo ${SV_FILES};
	$(CC) ${SV_FLAG} ${SV_FILES} ${VCS_FLAGS}