set power_enable_analysis TRUE
set power_analysis_mode time_based
# set power_analysis_mode averaged

set LIB_DIR "../lib"
set DB_DIR "${LIB_DIR}/db"

set search_path "${DB_DIR} "
set link_library " * scc40nll_vhsc40_rvt_ff_v1p21_-40c_basic.db"
set link_library " * scc40nll_vhsc40_rvt_tt_v1p1_25c_basic.db"

source ../name.tcl
set ICC_DIR ../icc
set ICC_OUTPUT_DIR $ICC_DIR/outputs/$DESIGN

read_verilog $ICC_OUTPUT_DIR/$DESIGN.output.v
current_design $DESIGN
link

read_sdc $ICC_OUTPUT_DIR/$DESIGN.sdc


read_parasitics $ICC_DIR/$DESIGN.spef.min

check_timing
update_timing
report_timing

set VCS_DIR ../vcs

read_vcd $VCS_DIR/wave.vcd -strip_path "test_single_port/mod"

check_power
set_power_analysis_options -waveform_format out -waveform_output powervcd
set_power_analysis_options -waveform_format fsdb -waveform_output powervcd
update_power
set REPORT_DIR ./reports
exec ../create_dir.sh $REPORT_DIR
report_power > $REPORT_DIR/$DESIGN.rpt

exit