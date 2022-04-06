module PartialProductGen1 #(
    parameter BITS = 8
)(
    input wire [BITS-1:0] a,
    input wire neg, zero, two,
    output wire [BITS:0] partial_pro
);

wire [BITS+1:0] middle;
assign middle = two ? {a, 1'b0} : {a[BITS-1], a};

assign partial_pro =
    zero ? 0 :
        (neg ? (~middle + 1) : middle);

endmodule