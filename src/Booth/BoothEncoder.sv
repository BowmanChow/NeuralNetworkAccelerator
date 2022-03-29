module BoothEncoder (
    input wire [2:0] code,
    output wire neg, zero, one, two
);
wire not_bits_1_0_are_1;
// MY_NAND not_bits_1_0_are_1_(.out(not_bits_1_0_are_1), .a(code[1]), .b(code[0]));
assign not_bits_1_0_are_1 = ~&code[1:0];
assign neg = code[2] & not_bits_1_0_are_1;
// wire bits_1_0_are_0;
// assign bits_1_0_are_0 = (~code[1]) & (~code[0]);
// wire bits_1_0_are_1;
// assign bits_1_0_are_1 = code[1] & code[0];
wire bits_1_0_are_0;
// MY_NOR bits_1_0_are_0_(.out(bits_1_0_are_0), .a(code[1]), .b(code[0]));
assign bits_1_0_are_0 = ~|code[1:0];
// assign zero = (~code[2] & bits_1_0_are_0) || (code[2] & bits_1_0_are_1);
// assign two = (code[2] & bits_1_0_are_0) || (~code[2] & bits_1_0_are_1);
assign zero = ~&{~&{(~code[2]), bits_1_0_are_0}, ~&{code[2], ~not_bits_1_0_are_1}};
assign two = ~&{~&{code[2], bits_1_0_are_0}, (code[2] | not_bits_1_0_are_1)};
assign one = code[1] ^ code[0];

// wire bits_1_0_diff;
// MY_XOR bits_1_0_diff_(.out(bits_1_0_diff), .a(code[1]), .b(code[0]));
// wire bits_2_1_diff;
// MY_XOR bits_2_1_diff_(.out(bits_2_1_diff), .a(code[2]), .b(code[1]));
// MY_NOR zero_(.out(zero), .a(bits_1_0_diff), .b(bits_2_1_diff));
// MY_NOR two_(.out(two), .a(bits_1_0_diff), .b(~bits_2_1_diff));
// assign one = bits_1_0_diff;


endmodule