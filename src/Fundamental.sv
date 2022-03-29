`ifndef FUNDAMENTAL_SV
`define FUNDAMENTAL_SV

module HALF_ADDER(
	input a, b,
	output co, sum
);
CLKAND2V0_12TR40 and1(.Z(co), .A1(a), .A2(b));
OA21BV12_12TR40 oab1(.Z(sum), .A1(a), .A2(b), .B(co));
endmodule

module FULL_ADDER(
	input a, b, ci,
	output co, sum
);
AD1V2C_12TR40 ad1( .CO(co), .S(sum), .A(a), .B(b), .CI(ci)); 
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