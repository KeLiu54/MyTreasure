module shift_register_rx (
    input clk,                  // Clock signal
    input reset,                // Reset signal
    input serial_in,            // Serial input
    input baud_tick_rx,            // Baud rate sampling pulse
    input en,                   // Enable signal
    output reg [8:0] parallel_out,  // Parallel output (includes all received bits)
    output reg [6:0] seven_bit_data // Output containing only the data bits, conditionally updated
);

reg [3:0] bit_counter;      // Counter to track the number of received input bits, 0 to 9 for a total of 10 bits
reg input_complete;         // Flag to indicate whether all input bits have been received

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialization
        bit_counter <= 0;
        input_complete <= 0;
        parallel_out <= 0;
        seven_bit_data <= 0; // Initialize parallel_output
    end else if (en && baud_tick_rx && !input_complete) begin
        // Process input when enabled, a baud_tick pulse arrives, and reception is not complete
        parallel_out[bit_counter] <= serial_in;
        bit_counter <= bit_counter + 1;

        // Check if all input bits have been received
        if (bit_counter == 8) begin
            input_complete <= 1;  // Mark input as complete
            bit_counter <= 0;     // Reset counter for the next reception
            seven_bit_data <= parallel_out[6:0]; // Update parallel_output
        end
    end else if (!en) begin
        // Reset state when disabled, preparing for the next reception
        input_complete <= 0;
    end
end

endmodule
