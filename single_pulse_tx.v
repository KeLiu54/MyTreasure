// The single_pulse module generates a single pulse output when the input key1 is pressed.
module single_pulse_tx(
    input clk,         // System clock signal.
    input rst,         // Asynchronous reset signal, active high.
    input key1,        // Input signal from a button, active low (button press when low).
    output reg pulse   // Output pulse signal.
);

reg key1_delayed; // Register to hold the delayed state of key1.

// Sequential logic to generate a single pulse on the falling edge of key1.
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // When reset is active, clear the delayed state and output pulse.
        key1_delayed <= 1'b1; // Set delayed state to high, assuming pull-up on key1.
        pulse <= 1'b0;        // Set output pulse to low.
    end else begin
        // On each clock cycle, capture the current state of key1.
        key1_delayed <= key1; // Delay key1 by one clock cycle.
                                   // Generate a pulse when a falling edge is detected on key1 (button press).
                                    // The pulse is high only for one clock cycle.
        pulse <= !key1 && key1_delayed; // Pulse is high when key1 goes from high to low.
    end
end

endmodule


