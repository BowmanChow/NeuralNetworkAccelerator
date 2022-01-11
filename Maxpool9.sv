module Maxpool9 (
    input wire [7:0] data [0:8],
    output wire [7:0] out
);

wire [7:0] max [0:6];
assign max[0] = data[0] > data[1] ? data[0] : data[1];
assign max[1] = data[2] > data[3] ? data[2] : data[3];
assign max[2] = data[4] > data[5] ? data[4] : data[5];
assign max[3] = data[6] > data[7] ? data[6] : data[7];
assign max[4] = max[0] > max[1] ? max[0] : max[1];
assign max[5] = max[2] > max[3] ? max[2] : max[3];
assign max[6] = max[4] > max[5] ? max[4] : max[5];
assign out = max[6] > data[8] ? max[6] : data[8];

endmodule