module sigmoid_alippi #(
    parameter INT_BIT = 7,
    parameter FRAC_BIT = 8
    ) (
    input wire [INT_BIT+FRAC_BIT : 0] in, // 1 bit sign
    output wire [FRAC_BIT : 0] out // unsigned, 1 bit integer
);

wire [INT_BIT:0] int_in;
assign int_in = in[INT_BIT+FRAC_BIT:FRAC_BIT];
wire [INT_BIT-1:0] abs_int_in;
wire [INT_BIT:0] int_in_true_form_out;
TwosComplement #(INT_BIT+1) int_in_true_form(int_in, int_in_true_form_out);
assign abs_int_in = int_in_true_form_out[INT_BIT-1:0];

wire [INT_BIT+FRAC_BIT : 0] frac = 
    (in[INT_BIT+FRAC_BIT] ?
        (in + {abs_int_in, {FRAC_BIT{1'b0}}}) :
        ((-in) + {abs_int_in, {FRAC_BIT{1'b0}}})
        ) >> 2;

wire [INT_BIT+FRAC_BIT : 0] middle;
assign middle = ({{(INT_BIT){1'b0}}, 1'b1, {(FRAC_BIT-1){1'b0}}} + frac) >> (abs_int_in);

assign out =
    in[INT_BIT+FRAC_BIT] ? middle : ({{(INT_BIT-1){1'b0}}, 1'b1, {FRAC_BIT{1'b0}}} - middle);

endmodule