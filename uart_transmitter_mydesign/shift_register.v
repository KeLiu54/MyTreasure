module shift_register(
    input clk,           // 
    input baud_tick,     // 
    input rst,           // 
    input load_data,
    input shift_en,
    input [6:0] data_in,
    input parity_bit,
    output reg [9:0] shift_reg,
    output txd
);

// 
always @(posedge clk or posedge rst) begin
    if (rst) begin
        shift_reg <= 10'b1111111111;
    end else if (load_data) begin
        shift_reg <= {1'b1, parity_bit, data_in, 1'b0}; // 
    end else if (baud_tick && shift_en) begin
        shift_reg <= {1'b1, shift_reg[9:1]}; // 
    end
end

assign txd = shift_reg[0];

endmodule



