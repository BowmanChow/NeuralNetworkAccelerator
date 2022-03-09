module sigmoid_A_law #(
    parameter INT_BIT = 7,
    parameter FRAC_BIT = 8
    ) (
    input wire [INT_BIT+FRAC_BIT : 0] in, // 1 bit sign
    output wire [FRAC_BIT : 0] out // unsigned, 1 bit integer
);

localparam [INT_BIT+FRAC_BIT : 0] cut_point [3:0] = 
'{
    {{(INT_BIT-4){1'b0}}, 4'b1000, {FRAC_BIT{1'b0}}},
    {{(INT_BIT-3){1'b0}}, 3'b100, {FRAC_BIT{1'b0}}},
    {{(INT_BIT-2){1'b0}}, 2'b10, {FRAC_BIT{1'b0}}},
    {{(INT_BIT-1){1'b0}}, 1'b1, {FRAC_BIT{1'b0}}}
};

localparam [INT_BIT+FRAC_BIT : 0] cut_point_neg [3:0] = 
'{
    -cut_point[3],
    -cut_point[2],
    -cut_point[1],
    -cut_point[0]
};

wire [3:0] range;
assign range =
    ($signed(in) > $signed(cut_point[3])) ? 8 :
    ($signed(in) > $signed(cut_point[2])) ? 7 :
    ($signed(in) > $signed(cut_point[1])) ? 6 :
    ($signed(in) > $signed(cut_point[0])) ? 5 :
    ($signed(in) >= $signed(cut_point_neg[0])) ? 4 :
    ($signed(in) >= $signed(cut_point_neg[1])) ? 3 :
    ($signed(in) >= $signed(cut_point_neg[2])) ? 2 :
    ($signed(in) >= $signed(cut_point_neg[3])) ? 1 : 0
;

logic [FRAC_BIT : 0] in_shift;
always_comb
    unique case (range)
    8, 0: in_shift = 'b0;
    7, 1: in_shift = (in >> 6);
    6, 2: in_shift = (in >> 5);
    5, 3: in_shift = (in >> 3);
    4: in_shift = (in >> 2);
    endcase

wire [FRAC_BIT : 0] add_num [8:0];
assign add_num [8:4] = 
'{
{1'b1, {FRAC_BIT{1'b0}}},
{1'b0, 3'b111, {(FRAC_BIT-3){1'b0}}},
{1'b0, 4'b1101, {(FRAC_BIT-4){1'b0}}},
{1'b0, 3'b101, {(FRAC_BIT-3){1'b0}}},
{1'b0, 1'b1, {(FRAC_BIT-1){1'b0}}}
};

assign add_num [3:0] = 
'{
{1'b1, {FRAC_BIT{1'b0}}} - add_num[5],
{1'b1, {FRAC_BIT{1'b0}}} - add_num[6],
{1'b1, {FRAC_BIT{1'b0}}} - add_num[7],
{1'b1, {FRAC_BIT{1'b0}}} - add_num[8]
};

assign out = add_num[range] + in_shift;

endmodule