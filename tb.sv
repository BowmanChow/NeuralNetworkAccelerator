`timescale 1ns/1ps

module test ;

reg clk = 0;

always begin
    #100 clk = 0;
    #100 clk = 1;
end

initial begin
    #100000
    $finish;
end

reg [7:0] random [0:3];
wire [7:0] max;

Maxpool4 maxpool4(
    .data(random),
    .out(max)
);

reg [7:0] random9 [0:8];
wire [7:0] max9;

Maxpool9 maxpool9(
    .data(random9),
    .out(max9)
);

always_ff @( clk ) begin
    {random[0], random[1], random[2], random[3]} = $random;
    {random9[0], random9[1], random9[2], random9[3]} = $random;
    {random9[4], random9[5], random9[6], random9[7]} = $random;
    random9[8] = $random;
end

endmodule