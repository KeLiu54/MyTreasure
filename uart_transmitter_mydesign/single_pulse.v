
module single_pulse(
    input clk,         // 
    input rst,       // 
    input key1,        // ）
    output reg pulse   // ）
);

reg key1_delayed;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        key1_delayed <= 1;  // 
        pulse <= 0;         // 
    end else begin
        key1_delayed <= key1;  // 
        pulse <= !key1 && key1_delayed; // 
    end
end

endmodule





