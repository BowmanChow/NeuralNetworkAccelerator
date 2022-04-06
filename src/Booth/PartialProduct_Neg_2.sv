module PartialProduct_Neg_2 #(
    parameter BITS = 8
)(
    input wire [BITS-1:0] a,
    input wire neg, zero, two,
    output logic [BITS:0] partial_pro
);

wire [BITS:0] a_ext ;
assign a_ext = {a[BITS-1], a};

logic [BITS:0] middle;
always_comb begin : middle_gen
    integer i;
    middle[0] = (~two) & a_ext[0];
    for ( i = 1; i <= BITS; i=i+1 )
        middle[i] = two ? a_ext[i-1] : a_ext[i];
end

always_comb begin : pp_gen
    integer i;
    for ( i = 0; i <= BITS; i=i+1 )
        partial_pro[i] = ~zero & (neg ^ middle[i]);
end

endmodule