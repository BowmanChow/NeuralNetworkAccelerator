`timescale 1ns/10ps

module test_sigmoid ;

reg clk = 0;

always begin
    #1 clk = 0;
    #1 clk = 1;
end

logic [15:0] read_x;
TwosComplement #(16) read_x_cpl(read_x);
sigmoid_alippi #(7, 8) sig(read_x);


logic [15:0] read_y;
wire [8:0] validate;
TwosComplement #(16) read_y_cpl(read_y, validate);
initial begin : read
    integer file_x;
    integer file_y;
    # 2;
    file_x = $fopen("x.txt", "r");
    file_y = $fopen("y.txt", "r");
    repeat(5000) begin
        # 2;
        $fscanf(file_x, "%b", read_x);
        $fscanf(file_y, "%b", read_y);
    end
    # 2;
    $finish;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
end

endmodule