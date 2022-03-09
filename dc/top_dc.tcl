check_library

set WORKING_DESIGN sigmoid_PLAN
set SV_DIR ".."
set MODULES {TwosComplement}
lappend MODULES "$WORKING_DESIGN"
set SV_FILES {}
foreach m $MODULES {;
    puts " $m"
    lappend SV_FILES "$SV_DIR/$m.sv"
}
puts $SV_FILES
read_file $SV_FILES -autoread -format sverilog -top $WORKING_DESIGN

elaborate $WORKING_DESIGN
current_design $WORKING_DESIGN
link

set UNMAPPED_DIR unmapped
exec ./create_dir.sh $UNMAPPED_DIR
write -hierarchy -f ddc -out $UNMAPPED_DIR/$WORKING_DESIGN.ddc

source ./contraints.con

compile_ultra

set REPORT_OUT reports/$WORKING_DESIGN
# report_constraint -all
exec ./create_dir.sh $REPORT_OUT
report_timing > $REPORT_OUT/timing.rpt
report_area > $REPORT_OUT/area.rpt
