module baud_rate_generator_rx (
    input clk,
    input rst,
    input en,           // Enable signal, enables baud rate generation
    output reg baud_tick_rx
);
    reg [11:0] count;          // Counter for generating baud_tick
    reg first_tick_generated;  // Flag to indicate if the first baud_tick has been generated

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            baud_tick_rx <= 0;
            first_tick_generated <= 0; // Upon reset, the first baud_tick has not been generated
        end else if (en) begin
            if (!first_tick_generated) begin
                // The first baud_tick is generated after 1.5 baud rate cycles
                if (count >= (3906)) begin // Counter value for 1.5 cycles, assuming 2604 counts per cycle
                    baud_tick_rx <= 1;
                    count <= 0; // Reset counter to generate the next baud_tick
                    first_tick_generated <= 1; // Mark that the first baud_tick has been generated
                end else begin
                    count <= count + 1;
                    baud_tick_rx <= 0;
                end
            end else begin
                // After the first baud_tick, pulses are generated every cycle
                if (count >= 2604) begin // Assuming 2604 counts per cycle
                    baud_tick_rx <= 1;
                    count <= 0; // Reset counter
                end else begin
                    count <= count + 1;
                    baud_tick_rx <= 0;
                end
            end
        end else if (!en) begin
            // If the enable signal goes low, reset all states
            count <= 0;
            baud_tick_rx <= 0;
            first_tick_generated <= 0;
        end
    end
endmodule
