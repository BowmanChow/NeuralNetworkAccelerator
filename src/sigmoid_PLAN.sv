module sigmoid_PLAN #(
    parameter INT_BIT = 7,
    parameter FRAC_BIT = 8
    ) (
    input wire [INT_BIT+FRAC_BIT : 0] in, // 1 bit sign
    output wire [FRAC_BIT : 0] out // unsigned, 1 bit integer
);

localparam [INT_BIT+FRAC_BIT : 0] cut_point [2:0] = 
'{
{{(INT_BIT-3){1'b0}}, 3'b101, {FRAC_BIT{1'b0}}},
{{(INT_BIT-2){1'b0}}, 2'b10, 3'b011, {(FRAC_BIT-3){1'b0}}},
{{(INT_BIT-1){1'b0}}, 1'b1, {FRAC_BIT{1'b0}}}
};

localparam [INT_BIT+FRAC_BIT : 0] cut_point_neg [2:0] = 
'{
-cut_point[2],
-cut_point[1],
-cut_point[0]
};

wire [2:0] range;
assign range = 
    ($signed(in) > $signed(cut_point[2])) ? 3'b111 :
    ($signed(in) < $signed(cut_point_neg[2])) ? 3'b011 :
    ($signed(in) > $signed(cut_point[1])) ? 3'b110 :
    ($signed(in) < $signed(cut_point_neg[1])) ? 3'b010 :
    ($signed(in) > $signed(cut_point[0])) ? 3'b101 :
    ($signed(in) < $signed(cut_point_neg[0])) ? 3'b001 : 3'b000;

logic [FRAC_BIT : 0] in_shift;
always_comb
    case (range[1:0])
    2'b11: in_shift = 'b0;
    2'b10: in_shift = (in >> 5);
    2'b01: in_shift = (in >> 3);
    2'b00: in_shift = (in >> 2);
    endcase

wire [FRAC_BIT : 0] add_num [7:0];
assign add_num [7:5] = 
'{
{1'b1, {FRAC_BIT{1'b0}}},
{1'b0, 5'b11011, {(FRAC_BIT-5){1'b0}}},
{1'b0, 3'b101, {(FRAC_BIT-3){1'b0}}}
};

assign add_num [3:0] = 
'{
{1'b1, {FRAC_BIT{1'b0}}} - add_num[7],
{1'b1, {FRAC_BIT{1'b0}}} - add_num[6],
{1'b1, {FRAC_BIT{1'b0}}} - add_num[5],
{1'b0, 1'b1, {(FRAC_BIT-1){1'b0}}}
};

assign out = add_num[range] + in_shift;

endmodule