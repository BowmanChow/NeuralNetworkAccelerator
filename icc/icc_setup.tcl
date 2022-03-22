source ../name.tcl
set core_width 10
set core_height 10

set _RUNDIR ./

set DESIGN_LIB "${DESIGN}_lib"
set NETLIST_DIR "../netlist/${DESIGN}"
set _VLOG "${NETLIST_DIR}/${DESIGN}.v"

set LIB_DIR "../lib"
set TF_DIR "${LIB_DIR}/tf"
set MW_DIR "${LIB_DIR}/mw"
set TLUP_DIR "${LIB_DIR}/tlup"
set OTHERS_DIR "${LIB_DIR}/others"

set _TECH_FILE "${TF_DIR}/scc40nll_vhs_10lm_2tm.tf"

set _STDCELL_MW_REF_LIB_DIR "${MW_DIR}/scc40nll_vhsc40_rvt"

set _DB_REFERENCE_LIB_DIR "${LIB_DIR}/db"

append search_path " ${_DB_REFERENCE_LIB_DIR} ${LIB_DIR}"
set target_library "scc40nll_vhsc40_rvt_tt_v1p1_25c_basic.db"
set symbol_library "scc40nll_vhsc40_rvt.sdb"

set link_library "* $target_library"

set_min_library scc40nll_vhsc40_rvt_ss_v0p99_125c_basic.db -min_ver scc40nll_vhsc40_rvt_ff_v1p21_-40c_basic.db

set p_name "VDD"
set g_name "VSS"
set mw_logic1_net VDD
set mw_logic0_net VSS

set disable_mw_batch_mode "false"
set save_mw_cel_lib_setup "false"
set auto_restore_mw_cel_lib "false"
set auto_restore_mw_cel_lib_setup "false"
set placer_enable_enhanced_router "true"
set auto_link_disable "false"
set echo_include_commands "false"
set echo_include_commands "false"
set exit_delete_command_log_file "true"
set sh_enable_page_mode "true"
set physopt_monitor_cpu_memory "false"
set complete_mixed_mode_extraction "true"
set icc_track_net_changes "true"
set timing_use_enhanced_capacitance_modeling "true"
