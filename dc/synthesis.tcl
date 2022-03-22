
set access_internal_pins "true"

set search_path "/software/synopsys/syn/libraries/syn ../lib ../src"
set target_library "scc40nll_vhsc40_rvt_tt_v1p1_25c_basic.db"
set symbol_library "scc40nll_vhsc40_rvt.sdb"
set link_library "* scc40nll_vhsc40_rvt_tt_v1p1_25c_basic.db"
set link_path "scc40nll_vhsc40_rvt_tt_v1p1_25c_basic.db"
set synthetic_library "dw_foundation.sldb"
check_library

#set compile_ultra_ungroup_dw false


#set MW_DESIGN_LIB TOP_LIB
#set MW_REFERENCE_LIB_DIR ./mwlib
#set TECH_FILE ./mwlib/smic18_4lm.tf
#set MAP_FILE ./mwlib/gds2InLayer_4lm.map
#set TLUPLUS_MAX_FILE ./mwlib/smiclog018_4lm_cell_typ.TLUPlus

#set_app_var mw_reference_library $MW_REFERENCE_LIB_DIR
#set_app_var mw_design_library $MW_DESIGN_LIB

#create_mw_lib -technology $TECH_FILE \
#              -mw_reference_library $mw_reference_library \
#              $mw_design_library
#open_mw_lib $mw_design_library
#set_tlu_plus_files -max_tluplus $TLUPLUS_MAX_FILE \
#                   -tech2itf_map $MAP_FILE



#--------------------set design name--------------
source ../name.tcl
#-------------------design read in----------------
set SV_DIR "../src"
set MODULES {}
lappend MODULES "$DESIGN"
set SV_FILES {}
foreach m $MODULES {;
    puts " $m"
    lappend SV_FILES "$SV_DIR/$m.sv"
}
puts $SV_FILES
read_file $SV_FILES -autoread -format sverilog -top $DESIGN


elaborate $DESIGN

#-----------------------Naming rules----------------------------


#---------------------clock define-----------------------
	
#1.main clock 
#set clkmain_period 15.0
#set clkName {clk}
#set clkPort {clk}
#create_clock -name clk -period $clkmain_period -waveform "0 [expr $clkmain_period/2]" clk

#set_clock_latency -source 1.0 [get_clocks clk]
#set_clock_uncertainty -setup 0.2 [get_clocks clk]
#set_clock_uncertainty -hold 0.18 [get_clocks clk]

create_clock -period 1.0 -name Vclk
set_clock_uncertainty -setup 0.0 [get_clocks Vclk]
set_input_delay -clock Vclk -max 0.0 [all_inputs]
set_output_delay -clock Vclk -max 0.0 [all_outputs]

#--------------------------reset define--------------------------

#set resetName {reset}
#set resetPort {reset}
#set resetNet {reset}

#------------------------

#set_ideal_network [get_ports $resetPort]

#set_ideal_network [get_ports "clk"]

#set_dont_touch_network [get_clocks *]

#set_ideal_latency 2.0 [get_ports reset]
#set_ideal_transition 1.0 [get_ports reset]

#----------------------------io cnst define----------------------


#----------------------------drc cnst define----------------------


#---------------------------timing excpt--------------------------
#set_input_delay -max 1.0 -clock clk [all_inputs]
#remove_input_delay [get ports clk]
#set_output_delay -max 1.0 -clock clk [all_outputs]

#---------------------------global-------------------


#--------------------------async clk--------

#--------------------------complie-----------------------------
set max_area 0


compile_ultra



#------------------------remove unconnet ports----------------------
set verilogout_show_unconnected_pins true


#-------------------------no tri or tran---------------------------

#----------------------------netlist&sdf&sdc---------------------
set NETLIST_OUT ../netlist/$DESIGN
exec ../create_dir.sh $NETLIST_OUT
write -f verilog -hier -output $NETLIST_OUT/$DESIGN.v
#write -hierarchy -format sdf -output $NETLIST_OUT/$DESIGN.sdf
#write -hierarchy -format sdc -output $NETLIST_OUT/$DESIGN.sdc
write_sdc $NETLIST_OUT/$DESIGN.sdc
write_sdf $NETLIST_OUT/$DESIGN.sdf

#--------------------------------report--------------------------
set REPORT_OUT reports/$DESIGN
exec ../create_dir.sh $REPORT_OUT
report_clock > $REPORT_OUT/clock.rpt
report_port -verbose > $REPORT_OUT/port.rpt
report_design -verbose > $REPORT_OUT/design.rpt
report_area  > $REPORT_OUT/area.rpt
report_timing > $REPORT_OUT/timing.rpt
report_constraint -all > $REPORT_OUT/constrain.rpt
report_power > $REPORT_OUT/power.rpt
write -format ddc -hierarchy -output $DESIGN.ddc

exit