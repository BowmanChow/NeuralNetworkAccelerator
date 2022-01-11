module Maxpool4 (
    input wire [7:0] data [0:3],
    output wire [7:0] out
);

wire [7:0] max [0:1];
assign max[0] = data[0] > data[1] ? data[0] : data[1];
assign max[1] = data[2] > data[3] ? data[2] : data[3];
assign out = max[0] > max[1] ? max[0] : max[1];

endmodule