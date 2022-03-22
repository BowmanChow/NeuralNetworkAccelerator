source icc_setup.tcl

file delete -force $DESIGN_LIB

create_mw_lib $DESIGN_LIB \
-open \
-case_sensitive \
    -bus_naming_style {[%d]} \
    -technology ${_TECH_FILE} \
-mw_reference_library "$_STDCELL_MW_REF_LIB_DIR"
close_mw_lib
open_mw_lib $DESIGN_LIB

read_verilog $NETLIST_DIR/$DESIGN\.v
uniquify_fp_mw_cel
current_design $DESIGN
link
set_dont_touch [get_nets -hierarchica *]
source -e -v $NETLIST_DIR/$DESIGN\.sdc

derive_pg_connection -power_net $p_name -power_pin $p_name -ground_net $g_name -ground_pin $g_name
derive_pg_connection -power_net $p_name -ground_net $g_name -tie
save_mw_cel -as $DESIGN\_init

create_floorplan -control_type width_and_height -core_width $core_width -core_height $core_height -start_first_row

create_floorplan -core_aspect_ratio 1 -core_utilization 0.5 -row_core_ratio 1

create_port {VDD VSS}
connect_net VDD [get_ports VDD]
connect_net VSS [get_ports VSS]

set oldSnapState [set_object_snap_type -enabled false]

insert_stdcell_filler -cell_with_metal {F_FILL1_12TR40} -avoid_layers {M1} -connect_to_power VDD -connect_to_ground VSS

insert_stdcell_filler -cell_with_metal {F_FILL128_12TR40 F_FILL64_12TR40 F_FILL32_12TR40 F_FILL16_12TR40 F_FILL8_12TR40 F_FILL4_12TR40 F_FILL2_12TR40 F_FILL1_12TR40} -avoid_layers {M1} -connect_to_power VDD -connect_to_ground VSS

set_tlu_plus_files -max_tluplus [subst {$TLUP_DIR/1P10M_2TM/StarRC_40LL_1P10M_2TM_RCMAX.tluplus}] -min_tluplus [subst {$TLUP_DIR/1P10M_2TM/StarRC_40LL_1P10M_2TM_RCMIN.tluplus}] -tech2itf_map [subst {$TLUP_DIR/1P10M_2TM/StarRC_40LL_1P10M_2TM_cell.map}]
preroute_standard_cells -do_not_route_over_macros -no_routing_outside_working_area -route_pins_on_layer M3 -connect horizontal -port_filter_mode off -cell_master_filter_mode off -cell_instance_filter_mode off -voltage_area_filter_mode off
remove_stdcell_filler -stdcell

insert_boundary_cell -left_boundary_cell FDCAP8_12TR40 -right_boundary_cell FDCAP8_12TR40 -bottom_right_outside_corner_cell FDCAP8_12TR40 -bottom_left_outside_corner_cell FDCAP8_12TR40 -top_right_outside_corner_cell FDCAP8_12TR40 -top_left_outside_corner_cell FDCAP8_12TR40

set cellList [gets [open ${OTHERS_DIR}/cell_list r]]

create_fp_placement
create_fp_placement -incremental all -timing_driven
place_opt

save_mw_cel -as $DESIGN\_placed

set_route_zrt_common_options \
-rotate_default_vias false \
-read_user_metal_blockage_layer true \
-single_connection_to_pins standard_cell_pins \
    -connect_within_pins_by_layer_name {{M1 via_all_pins} {M2 via_all_pins}}

set_ignored_layers -min_routing_layer M2 -max_routing_layer M8

set_preferred_routing_direction -layers M2 -direction horizontal
set_preferred_routing_direction -layers M3 -direction vertical
check_routeability

route_auto -effort high -search_repair_loop 20
route_search_repair -rerun_drc -loop 20

route_opt -initial_route_only
route_opt -skip_initial_route -effort medium
route_opt -effort high -incremental -only_design_rule
derive_pg_connection -power_net $p_name -power_pin $p_name -ground_net $g_name -ground_pin $g_name
derive_pg_connection -power_net $p_name -ground_net $g_name -tie
verify_lvs
save_mw_cel -as $DESIGN\_routed

insert_stdcell_filler -cell_with_metal {FILLTIE128_12TR40 FILLTIE16_12TR40 FILLTIE32_12TR40 FILLTIE3_12TR40 FILLTIE4_12TR40 FILLTIE64_12TR40 FILLTIE8_12TR40} -avoid_layers {M1} -connect_to_power VDD -connect_to_ground VSS
legalize_placement
insert_stdcell_filler -cell_without_metal {F_FILL128_12TR40 F_FILL64_12TR40 F_FILL32_12TR40 F_FILL16_12TR40 F_FILL8_12TR40 F_FILL4_12TR40 F_FILL2_12TR40 F_FILL1_12TR40} -avoid_layers {M1} -connect_to_power VDD -connect_to_ground VSS
legalize_placement
route_opt -incremental

derive_pg_connection -power_net $p_name -power_pin $p_name -ground_net $g_name -ground_pin $g_name
verify_lvs

change_names -rules verilog -hierarchy

save_mw_cel -as $DESIGN\_icc

echo "#### Qid-Info: write ref GDS for cadence in"
set OUTPUT_DIR ./outputs/$DESIGN
exec ../create_dir.sh $OUTPUT_DIR
set_write_stream_options -reset
set_write_stream_options \
       -child_depth 20 \
       -map_layer  ${OTHERS_DIR}/gds2InLayer.map \
       -output_pin {text geometry} \
       -pin_name_mag 0.2 \
       -output_polygon_pin \
       -contact_prefix apr_ \
       -rotate_pin_text_by_access_dir \
       -keep_data_type \
       -output_geometry_property \
       -output_instance_name_as_property 1 \
       -output_net_name_as_property 1 \
       -skip_ref_lib_cells
write_stream -format gds -lib_name  $DESIGN_LIB  -cells ${DESIGN}\_icc ${OUTPUT_DIR}/$DESIGN\_icc.gds

#####################################################################################
set REPORT_DIR ./report/$DESIGN
exec ../create_dir.sh $REPORT_DIR
report_timing              -transition_time -cap -input_pins  > $REPORT_DIR/$DESIGN\_setup.rpt
report_timing -delay min   -transition_time -cap -input_pins  > $REPORT_DIR/$DESIGN\_hold.rpt
report_constraints -all_violators > $REPORT_DIR/$DESIGN\_constraints.summary
report_power > $REPORT_DIR/$DESIGN\_power.rpt
#####################################################################################

#source ./scripts/pad_label.tcl
set out_list "FILLTIE128_12TR40 FILLTIE16_12TR40 FILLTIE32_12TR40 FILLTIE3_12TR40 FILLTIE4_12TR40 FILLTIE64_12TR40 FILLTIE8_12TR40 F_FILL128_12TR40 F_FILL64_12TR40 F_FILL32_12TR40 F_FILL16_12TR40 F_FILL8_12TR40 F_FILL4_12TR40 F_FILL2_12TR40 F_FILL1_12TR40"
write_verilog -unconnected_ports -wire_declaration -keep_backslash_before_hiersep -no_physical_only_cells $OUTPUT_DIR/$DESIGN\.output.v
write_verilog -wire_declaration -keep_backslash_before_hiersep -no_physical_only_cells -pg -force_output_references $out_list $OUTPUT_DIR/$DESIGN\_pg.v
write_verilog -no_pad_filler_cells -no_core_filler_cells $OUTPUT_DIR/$DESIGN\_nofiller.v

write_sdc $OUTPUT_DIR/$DESIGN\.sdc
write_sdf $OUTPUT_DIR/$DESIGN\.sdf
write_parasitics

exit