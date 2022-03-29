module PartialProductGen1 #(
    parameter BITS = 8
)(
    input wire [BITS-1:0] a,
    input wire neg, zero, one, two,
    output wire [BITS:0] out
);

wire [BITS+1:0] middle;
assign middle = two ? {a, 1'b0} : {a[BITS-1], a};

assign out =
    zero ? 0 :
        (neg ? (~middle + 1) : middle);

endmodule