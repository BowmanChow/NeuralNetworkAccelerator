`timescale 10ps/1ps
`include "flags.sv"
`include "TwosComplement.sv"
`define STR(x) `"x`"
`define ICC_OUTPUT_DIR {"../icc/outputs/", `STR(`MODULE)}
`define TEST_DIR "../test/data"
`define INPUT_BITS 16
`define OUTPUT_BITS 16
`define PERIOD 200
module test_single_port ;

`ifdef IS_POST
initial
begin
    $sdf_annotate({`ICC_OUTPUT_DIR, "/", `STR(`MODULE), ".sdf"}, mod, , "sdf.log", "MAXIMUM");
end
`endif

logic [`INPUT_BITS-1:0] read_x = 0;
wire [`OUTPUT_BITS-1:0] module_out;
`MODULE mod(read_x, module_out);

logic [`OUTPUT_BITS-1:0] read_y = 0;
wire [`OUTPUT_BITS-1:0] error;
assign error = read_y - module_out;
wire [`OUTPUT_BITS-1:0] error_true_form;
TwosComplement #(`OUTPUT_BITS) error_abs_(.in(error), .out(error_true_form));
wire [`OUTPUT_BITS-1:0] error_abs;
assign error_abs = {1'b0, error_true_form[`OUTPUT_BITS-2:0]};
initial begin : read
    integer file_x, file_y, file_x_status, file_y_status;

`ifdef IS_POST
    $set_toggle_region(test_single_port.mod);
    $toggle_start();
`endif

    file_x = $fopen({`TEST_DIR, "/x.txt"}, "r");
    file_y = $fopen({`TEST_DIR, "/y.txt"}, "r");
    while (!$feof(file_x)) begin
        # `PERIOD;
        file_x_status = $fscanf(file_x, "%b", read_x);
        file_y_status = $fscanf(file_y, "%b", read_y);
    end

`ifdef IS_POST
    $toggle_stop();
    $toggle_report("power.saif", 1.0e-12, "test_single_port.mod");
`endif

    # `PERIOD;
    $finish;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
end

endmodule