`include "Fundamental.sv"

module Gate(
    input wire in[1:0],
    output wire out
);

assign out = ~&{in[1], in[0]};

endmodule