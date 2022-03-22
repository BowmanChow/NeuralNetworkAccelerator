`timescale 1ns/10ps
`include "flags.sv"
`define STR(x) `"x`"
`define ICC_OUTPUT_DIR {"../icc/outputs/", `STR(`MODULE)}
`define TEST_DIR "../test"
`define INPUT_BITS 16
`define OUTPUT_BITS 9
module test_single_port ;

`ifdef IS_POST
initial
begin
    $sdf_annotate({`ICC_OUTPUT_DIR, "/", `STR(`MODULE), ".sdf"}, mod, , "sdf.log", "MAXIMUM");
end
`endif

logic [`INPUT_BITS-1:0] read_x;
logic [`OUTPUT_BITS-1:0] module_out;
`MODULE #(7, 8) mod(read_x, module_out);

logic [`OUTPUT_BITS-1:0] read_y;
initial begin : read
    integer file_x, file_y, file_x_status, file_y_status;

`ifdef IS_POST
    $set_toggle_region(test_single_port.mod);
    $toggle_start();
`endif

    # 2;
    file_x = $fopen({`TEST_DIR, "/x.txt"}, "r");
    file_y = $fopen({`TEST_DIR, "/y.txt"}, "r");
    repeat(5000) begin
        # 2;
        file_x_status = $fscanf(file_x, "%b", read_x);
        file_y_status = $fscanf(file_y, "%b", read_y);
    end

`ifdef IS_POST
    $toggle_stop();
    $toggle_report("power.saif", 1.0e-12, "test_single_port.mod");
`endif

    # 2;
    $finish;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
end

endmodule