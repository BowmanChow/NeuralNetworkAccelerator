`include "Booth/BoothEncoder.sv"
`include "Booth/PartialProduct_Neg_2.sv"
`include "Booth/PartialProductCompressor.sv"
`include "Fundamental.sv"

module BoothMultiplier #(
    parameter BITS = 8
) (
    input wire [2*BITS-1:0] in,
    output wire [2*BITS-1:0] out
);

wire [BITS-1:0] a_num, b_num;
assign b_num = in[2*BITS-1:BITS];
assign a_num = in[BITS-1:0];

logic [BITS/2-1:0] negs;
logic [BITS/2-1:0] zeros;
logic [BITS/2-1:0] twos;
wire [BITS:0] partial_pro [0:BITS/2-1];

BoothEncoder booth_enc(
            {b_num[1:0], 1'b0},
            negs[0],
            zeros[0],
            twos[0]
        );

genvar i;
generate
    for (i = 1; i < (BITS/2); i++) begin
        BoothEncoder booth_enc(
            b_num[2*i+1:2*i-1],
            negs[i],
            zeros[i],
            twos[i]
        );
    end
endgenerate

generate
    for (i = 0; i < (BITS/2); i++) begin
        PartialProduct_Neg_2 #(BITS) p_pro(
            a_num,
            negs[i],
            zeros[i],
            twos[i],
            partial_pro[i]
        );
    end
endgenerate

PartialProductCompressor compressor(
    .partial_product(partial_pro),
    .negs(negs),
    .out(out));

endmodule