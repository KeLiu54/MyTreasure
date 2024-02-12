// The bit_counter module counts the number of bits that have been shifted out
// during a UART transmission and asserts a 'done' signal when the count is complete.
module bit_counter_tx (
    input wire baud_tick,   // Tick signal for each bit period based on the baud rate.
    input wire clk,         // System clock signal.
    input wire shift_en,    // Enable signal for shifting operation.
    input wire rst,         // Asynchronous reset signal, active high.
    output wire done        // Signal indicating the completion of bit transmission.
);

reg [3:0] count;           // 4-bit counter to track the number of bits shifted out.
reg done_pulse;            // Register to hold the 'done' pulse.
reg prev_shift_en;         // Register to detect the rising edge of 'shift_en'.

// Sequential logic block to manage bit counting and detect transmission completion.
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // When reset is active, clear the counter.
        count <= 4'b0;
    end else if (shift_en && !prev_shift_en) begin
        // When 'shift_en' goes high, indicating the start of a new transmission, reset the counter.
        count <= 4'b0;
    end else if (baud_tick && shift_en) begin
        // If 'shift_en' is active and 'baud_tick' occurs, increment the counter.
        count <= count + 1'b1;
    end
    // Store the current state of 'shift_en' to detect its rising edge in the next clock cycle.
    prev_shift_en <= shift_en;
end

// Sequential logic block to output a 'done' pulse when the bit count is complete.
always @(posedge clk) begin
    if (count == 4'b1001 && baud_tick && shift_en) begin
        // If the counter reaches 9 (indicating 10 bits including the start bit have been shifted out)
        // and 'baud_tick' and 'shift_en' are active, assert 'done_pulse'.
        done_pulse <= 1'b1;
    end else begin
        // Otherwise, deassert 'done_pulse'.
        done_pulse <= 1'b0;
    end
end

// Output the 'done' signal, indicating the end of the transmission cycle.
assign done = done_pulse;

endmodule
