
module bit_counter (
    input wire baud_tick,
    input wire clk,
    input wire shift_en,
    input wire rst, // 
    output wire done
);

reg [3:0] count;
reg done_pulse;
reg prev_shift_en;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // 
        count <= 4'b0;
    end else if (shift_en && !prev_shift_en) begin
        // Reset count when shift_en transitions from low to high
        count <= 4'b0;
    end else if (baud_tick && shift_en) begin
        // Increment count on baud_tick when shift_en is high
        count <= count + 1'b1;
    end

    prev_shift_en <= shift_en;
end

always @(posedge clk) begin
    if (count == 4'b1001 && baud_tick && shift_en) begin
        done_pulse <= 1'b1;
    end else begin
        done_pulse <= 1'b0;
    end
end

assign done = done_pulse;

endmodule