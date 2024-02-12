module bit_counter_rx(
    input clk,         // Clock signal
    input rst,         // Reset signal
    input en,          // Enable signal, from controller
    input baud_tick_rx,   // Baud rate sampling pulse
    output reg done_rx    // Completion signal, to controller
);

reg [3:0] count; // 4-bit counter, sufficient to count up to 9

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // On reset, clear the counter and done signal
        count <= 0;
        done_rx <= 0;
    end else if (en && baud_tick_rx) begin
        // If enabled and a baud_tick pulse is received, start counting
        if (count < 8) begin
            // If count has not reached 9, continue counting
            count <= count + 1;
            done_rx <= 0; // Ensure the done signal remains low during counting
        end else begin
            // When count reaches 9, generate a pulse on the done signal
            done_rx <= 1;
            count <= 0; // Reset the counter after completion, ready for the next round
        end
    end else if (!en) begin
        // If not enabled, reset the counter and done signal without generating a pulse
        count <= 0;
        done_rx <= 0;
    end else if (done_rx) begin
        // Ensure the done signal only lasts for one clock cycle
        done_rx <= 0;
    end
end

endmodule
