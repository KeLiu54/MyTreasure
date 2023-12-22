module controller(
    input clk,
    input rst,
    input pulse,
    input done, // Signal from the bit counter indicating completion
    output reg shift_en,
    output reg load
);

// State definitions
localparam IDLE = 2'b00,
           LOAD = 2'b01,
           SHIFT = 2'b10;

reg [1:0] state; // State variable

// Controller FSM Logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset state
        state <= IDLE;
        shift_en <= 1'b0;
        load <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                // Wait for pulse signal to start operation
                if (pulse) begin
                    state <= LOAD;
                end
                shift_en <= 1'b0;
                load <= 1'b0;
            end
            LOAD: begin
                // Load data into shift register and start shifting
                load <= 1'b1;
                shift_en <= 1'b1;
                state <= SHIFT;
            end
            SHIFT: begin
                // Keep shifting until done signal is received
                load <= 1'b0;
                if (done) begin
                    // Reset shift enable when done
                    shift_en <= 1'b0;
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule