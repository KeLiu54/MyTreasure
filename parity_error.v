module parity_error(
    input wire [8:0] parallel_out, // Output from the shift register
    output wire error              // Parity error indicator
);

// Calculate even parity
wire parity = ^(parallel_out[6:0]);

// Check if the even parity bit is correct (the parity bit should be the inverse of the calculation, hence using XOR to check the difference)
assign error = parity ^ parallel_out[7];

endmodule
