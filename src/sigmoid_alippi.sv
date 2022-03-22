`include "TwosComplement.sv"

module sigmoid_alippi #(
    parameter INT_BIT = 7,
    parameter FRAC_BIT = 8
    ) (
    input wire [INT_BIT+FRAC_BIT : 0] in, // 1 bit sign
    output wire [FRAC_BIT : 0] out // unsigned, 1 bit integer
);

wire sign;
assign sign = in[INT_BIT+FRAC_BIT];
wire [INT_BIT+FRAC_BIT : 0] in_true_form_out;
TwosComplement #(INT_BIT+FRAC_BIT+1) in_true_form(in, in_true_form_out);
wire [INT_BIT:0] int_in_true_form;
assign int_in_true_form = in_true_form_out[INT_BIT+FRAC_BIT:FRAC_BIT];
wire [INT_BIT-1:0] abs_int_in;
assign abs_int_in = int_in_true_form[INT_BIT-1:0];

wire [FRAC_BIT : 0] frac_true_form = in_true_form_out[FRAC_BIT-1:0] >> 2;

wire [INT_BIT+FRAC_BIT : 0] middle;
assign middle = ({{(INT_BIT){1'b0}}, 1'b1, {(FRAC_BIT-1){1'b0}}} - frac_true_form) >> (abs_int_in);

assign out =
    sign ? middle : ({{(INT_BIT-1){1'b0}}, 1'b1, {FRAC_BIT{1'b0}}} - middle);

endmodule