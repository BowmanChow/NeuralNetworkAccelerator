check_library

set WORKING_DESIGN sigmoid_alippi
set REPORT_OUT reports/$WORKING_DESIGN
read_file {../TwosComplement.sv ../sigmoid_alippi.sv} -autoread -format sverilog -top $WORKING_DESIGN

elaborate $WORKING_DESIGN
current_design $WORKING_DESIGN
link

set UNMAPPED_DIR unmapped
exec ./create_dir.sh $UNMAPPED_DIR
write -hierarchy -f ddc -out $UNMAPPED_DIR/$WORKING_DESIGN.ddc

source ./contraints.con

compile_ultra
# report_constraint -all
exec ./create_dir.sh $REPORT_OUT
report_timing > $REPORT_OUT/timing.rpt
report_area > $REPORT_OUT/area.rpt
