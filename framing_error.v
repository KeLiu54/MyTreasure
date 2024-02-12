module framing_error(
    input wire [8:0] parallel_out, // Output from the shift register
    output wire error              // Framing error indicator
);

// Assuming the stop bit is at parallel_out[8], it should be 1 for correct framing
assign error = ~parallel_out[8];

endmodule
