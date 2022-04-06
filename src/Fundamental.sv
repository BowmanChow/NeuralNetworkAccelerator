`ifndef FUNDAMENTAL_SV
`define FUNDAMENTAL_SV

module HALF_ADDER(
	input a, b,
	output co, sum
);
// CLKAND2V0_12TR40 and1(.Z(co), .A1(a), .A2(b));
// OA21BV12_12TR40 oab1(.Z(sum), .A1(a), .A2(b), .B(co));
ADH1V2C_12TR40 adh1(.S(sum), .CO(co), .A(a), .B(b));
endmodule

module HALF_ADDER_1_BIT_1(
	input a,
	output co, sum
);
assign co = a;
assign sum = ~a;
endmodule

module FULL_ADDER(
	input a, b, ci,
	output co, sum
);
AD1V2C_12TR40 ad1( .CO(co), .S(sum), .A(a), .B(b), .CI(ci)); 
endmodule

module FULL_ADDER_1_BIT_1(
	input a, b,
	output co, sum
);
assign co = a | b;
assign sum = ~^{a, b};
endmodule

module APPROX_ADDER_4(
	input a, b, c, d,
	output co, sum
);
wire xor_a_b;
assign xor_a_b = a ^ b;
assign co = xor_a_b ? (c | d) : ((c & d) | a);
assign sum = xor_a_b ? ~^{c, d} : (c | d);
endmodule

module APPROX_ADDER_4_1_BIT_1(
	input a, b, ci,
	output co, sum
);
assign co = a | b | ci;
assign sum = ci ? (a | b) : ~^{a, b};
endmodule

module MY_NAND(
    input wire a, b,
    output wire out
);
NAND2CV0_12TR40 nand1(.ZN(out), .A1(a), .A2(b));
endmodule

module MY_NOR(
    input wire a, b,
    output wire out
);
NOR2CV0_12TR40 nor1(.ZN(out), .A1(a), .A2(b));
endmodule

module MY_XOR(
    input wire a, b,
    output wire out
);
XOR2V0_12TR40 xor1(.Z(out), .A1(a), .A2(b));
endmodule

`endif