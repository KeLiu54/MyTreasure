module controller_rx(
    input clk,       // Clock signal
    input reset,     // Reset signal
    input serial_in, // Serial input
    input done_rx,      // Done signal, indicates that data reception is complete
    output reg en    // Enable signal for other modules
);

    // Define states using parameters for readability
    parameter WAIT_FOR_START = 1'b0,
              TRANSMITTING = 1'b1;

    // Variables for current and next state
    reg current_state, next_state;

    // Sequential logic to handle state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, initialize to waiting for start bit state
            current_state <= WAIT_FOR_START;
        end else begin
            // Otherwise, move to the next determined state
            current_state <= next_state;
        end
    end

    // Combinational logic to determine next state and control outputs
    always @(current_state, serial_in, done_rx) begin
        // Default assignments to avoid latch creation
        next_state = current_state; // Stay in current state by default
        en = 1'b0; // Disable enable signal by default

        case (current_state)
            WAIT_FOR_START: begin
                if (serial_in == 1'b0) begin
                    // If start bit detected (serial_in low), change state to TRANSMITTING
                    // and enable transmission
                    next_state = TRANSMITTING;
                    en = 1'b1;
                end
            end
            TRANSMITTING: begin
                // While in TRANSMITTING state, keep the module enabled
                en = 1'b1;
                if (done_rx) begin
                    // If data reception is complete (done signal high), 
                    // return to waiting for the next start bit
                    next_state = WAIT_FOR_START;
                end
            end
            // No default case needed as all possible states are handled
        endcase
    end

endmodule
