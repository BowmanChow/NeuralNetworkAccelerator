`include "Booth/BoothEncoder.sv"
`include "Booth/PartialProduct_Neg.sv"
`include "Fundamental.sv"

module BoothMultiplier #(
    parameter BITS = 8
) (
    input wire [2*BITS-1:0] in,
    output wire [2*BITS-1:0] out
);

wire [BITS-1:0] a_num, b_num;
assign a_num = in[2*BITS-1:BITS];
assign b_num = in[BITS-1:0];

logic [BITS/2-1:0] negs;
logic [BITS/2-1:0] zeros;
logic [BITS/2-1:0] ones;
logic [BITS/2-1:0] twos;
wire [BITS:0] partial_pro [0:BITS/2-1];

BoothEncoder booth_enc(
            {b_num[1:0], 1'b0},
            negs[0],
            zeros[0],
            ones[0],
            twos[0]
        );

genvar i;
generate
    for (i = 1; i < (BITS/2); i++) begin
        BoothEncoder booth_enc(
            b_num[2*i+1:2*i-1],
            negs[i],
            zeros[i],
            ones[i],
            twos[i]
        );
    end
endgenerate

generate
    for (i = 0; i < (BITS/2); i++) begin
        PartialProduct_Neg #(BITS) psum(
            a_num,
            negs[i],
            zeros[i],
            ones[i],
            twos[i],
            partial_pro[i]
        );
    end
endgenerate

// assign out = 
//     ({~partial_pro[0][BITS], partial_pro[0][BITS], partial_pro[0]}) +
//     ({1'b1, ~partial_pro[1][BITS], partial_pro[1][BITS-1:0], 1'b0, negs[0]}) +
//     ({1'b1, ~partial_pro[2][BITS], partial_pro[2][BITS-1:0], 1'b0, negs[1], 2'b0}) +
//     ({1'b1, ~partial_pro[3][BITS], partial_pro[3][BITS-1:0], 1'b0, negs[2], 4'b0}) +
//     {negs[3], 6'b0};

`define P partial_pro
`define N negs

wire S1_4, C1_4;
FULL_ADDER adder1_4( .co(C1_4), .sum(S1_4), .a(1'b1), .b(`P[2][7]), .ci(`P[3][5]));
wire S1_5, C1_5;
FULL_ADDER adder1_5( .co(C1_5), .sum(S1_5), .a(~`P[0][8]), .b(~`P[1][8]), .ci(`P[2][6]));
wire S1_6, C1_6;
FULL_ADDER adder1_6( .co(C1_6), .sum(S1_6), .a(`P[0][8]), .b(`P[1][7]), .ci(`P[2][5]));
wire S1_7, C1_7;
FULL_ADDER adder1_7( .co(C1_7), .sum(S1_7), .a(`P[0][8]), .b(`P[1][6]), .ci(`P[2][4]));
wire S1_8, C1_8;
FULL_ADDER adder1_8( .co(C1_8), .sum(S1_8), .a(`P[0][7]), .b(`P[1][5]), .ci(`P[2][3]));
wire S1_9, C1_9;
FULL_ADDER adder1_9( .co(C1_9), .sum(S1_9), .a(`P[0][6]), .b(`P[1][4]), .ci(`P[2][2]));
wire S1_10, C1_10;
FULL_ADDER adder1_10( .co(C1_10), .sum(S1_10), .a(`P[0][5]), .b(`P[1][3]), .ci(`P[2][1]));
wire S1_11, C1_11;
FULL_ADDER adder1_11( .co(C1_11), .sum(S1_11), .a(`P[0][4]), .b(`P[1][2]), .ci(`P[2][0]));

wire S2_2, C2_2;
HALF_ADDER adder2_2( .co(C2_2), .sum(S2_2), .a(1'b1), .b(`P[3][7]));
wire S2_3, C2_3;
FULL_ADDER adder2_3( .co(C2_3), .sum(S2_3), .a(~`P[2][8]), .b(`P[3][6]), .ci(C1_4));
wire S2_4, C2_4;
HALF_ADDER adder2_4( .co(C2_4), .sum(S2_4), .a(S1_4), .b(C1_5));
wire S2_5, C2_5;
FULL_ADDER adder2_5( .co(C2_5), .sum(S2_5), .a(S1_5), .b(`P[3][4]), .ci(C1_6));
wire S2_6, C2_6;
FULL_ADDER adder2_6( .co(C2_6), .sum(S2_6), .a(S1_6), .b(`P[3][3]), .ci(C1_7));
wire S2_7, C2_7;
FULL_ADDER adder2_7( .co(C2_7), .sum(S2_7), .a(S1_7), .b(`P[3][2]), .ci(C1_8));
wire S2_8, C2_8;
FULL_ADDER adder2_8( .co(C2_8), .sum(S2_8), .a(S1_8), .b(`P[3][1]), .ci(C1_9));
wire S2_9, C2_9;
FULL_ADDER adder2_9( .co(C2_9), .sum(S2_9), .a(S1_9), .b(`P[3][0]), .ci(`N[3]));

assign out =
{{1'b1, ~`P[3][8], S2_2, S2_3, S2_4, S2_5, S2_6, S2_7, S2_8, S2_9, S1_10, S1_11, `P[0][3]} +
{C2_2, C2_3, C2_4, C2_5, C2_6, C2_7, C2_8, C2_9, C1_10, C1_11, `N[2], 1'b1}, `P[0][2], `P[0][1], `P[0][0]}
;

endmodule