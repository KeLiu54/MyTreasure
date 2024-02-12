module controller_tx(
    input clk,          // System clock signal.
    input rst,          // Asynchronous reset signal, active high.
    input pulse,        // Trigger signal for initiating data load, active high.
    input done,         // Signal from the bit counter indicating completion of transmission.
    output reg shift_en,// Control signal to enable shifting of data out of the shift register.
    output reg load     // Control signal to load data into the shift register.
);

    // State definitions using parameter
    parameter IDLE = 2'b00,  // IDLE state: waiting for a pulse to begin the process.
             LOAD = 2'b01,  // LOAD state: data is loaded into the shift register.
             SHIFT = 2'b10; // SHIFT state: data is being shifted out serially.

    reg [1:0] current_state, next_state; // Registers to hold the current and next state of the FSM.

    // Sequential block for state transitions
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE; // Reset to initial state
        end else begin
            current_state <= next_state; // Transition to the next state
        end
    end

    // Combinational block for next state logic and output logic
    always @(current_state, pulse, done) begin
        // Default assignments to prevent latch synthesis
        shift_en = 1'b0; // Default disabled
        load = 1'b0;     // Default disabled
        next_state = current_state; // Default to stay in the current state

        case (current_state)
            IDLE: begin
                if (pulse) begin
                    // On detecting a pulse, transition to the LOAD state.
                    next_state = LOAD;
                    load = 1'b1; // Assert load signal to load data into the shift register
                end
            end
            LOAD: begin
                // Transition to the SHIFT state to begin data transmission.
                next_state = SHIFT;
                shift_en = 1'b1; // Assert shift_en to enable shifting of data
            end
            SHIFT: begin
                if (done) begin
                    // If done, transition back to IDLE.
                    next_state = IDLE;
                end else begin
                    // Remain in SHIFT state and continue transmission.
                    shift_en = 1'b1; // Keep shift_en asserted
                end
            end
            default: begin
                // For any undefined state, reset to IDLE.
                next_state = IDLE;
            end
        endcase
    end

endmodule
