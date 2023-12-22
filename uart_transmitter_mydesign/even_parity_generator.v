
module even_parity_generator(
    input [6:0] data_in, // 7-bit input data
    output parity_bit    // Output parity bit
);

assign parity_bit = ^data_in; // XOR all bits of data_in to generate parity

endmodule







