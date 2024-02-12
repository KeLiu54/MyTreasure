
module baud_rate_generator_tx (
    input clk,// System clock signal
    input rst, // Asynchronous reset signal, active high.
    output reg baud_tick// Tick signal that indicates when to shift data.
);
    reg [11:0] count; // 12-bit counter for maximum count of 4095

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            baud_tick <= 0;
        end else begin
            if (count >= 2603) begin // Adjust based on clock and baud rate
                count <= 0;
                baud_tick <= 1;
            end else begin
                count <= count + 1;
                baud_tick <= 0;
            end
        end
    end
endmodule







