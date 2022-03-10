module TwosComplement #(
    parameter BIT_WIDTH
) (
    input wire [BIT_WIDTH-1:0] in,
    output wire [BIT_WIDTH-1:0] out
);

assign out[BIT_WIDTH-1] = in[BIT_WIDTH-1];
assign out[BIT_WIDTH-2:0] = in[BIT_WIDTH-1] ? (~in[BIT_WIDTH-2:0] + 1) : in[BIT_WIDTH-2:0];

endmodule