`include "Fundamental.sv"

module PartialProductCompressor #(
    parameter BITS = 8
)(
    input wire [8:0] partial_product [0:3],
    input wire [3:0] negs,
    output wire [15:0] out
);

`define P partial_product
`define N negs

assign out = 
    ({~`P[0][BITS], `P[0][BITS], `P[0]}) +
    ({1'b1, ~`P[1][BITS], `P[1][BITS-1:0], 1'b0, `N[0]}) +
    ({1'b1, ~`P[2][BITS], `P[2][BITS-1:0], 1'b0, `N[1], 2'b0}) +
    ({1'b1, ~`P[3][BITS], `P[3][BITS-1:0], 1'b0, `N[2], 4'b0}) +
    {`N[3], 6'b0};

endmodule