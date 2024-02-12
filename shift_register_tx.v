// This module implements a shift register for UART transmission.
// It handles loading of data, adding a parity bit, and shifting out serially.
module shift_register_tx(
    input clk,           // System clock signal.
    input baud_tick,     // Tick signal that indicates when to shift data.
    input rst,           // Asynchronous reset signal, active high.
    input load_data,     // Signal to trigger loading of data into the shift register.
    input shift_en,      // Enable signal for shifting operation.
    input [6:0] data_in, // 7-bit input data to be transmitted.
    input parity_bit,    // Parity bit for error checking.
    output reg [9:0] shift_reg, // 10-bit shift register to hold data and control bits.
    output txd          // Serial data output.
);

// Sequential logic to manage the shift register operations.
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // On reset, set the shift register to all high (idle state for UART).
        shift_reg <= 10'b1111111111;
    end else if (load_data) begin
        // When load_data is asserted, load the data into the shift register.
        // Format: start bit (0), data bits, parity bit, and stop bit (1).
        shift_reg <= {1'b1, parity_bit, data_in, 1'b0}; // Start bit is '0', stop bit is '1'.
    end else if (baud_tick && shift_en) begin
        // On each baud_tick, if shifting is enabled, shift the register to the right.
        // This will transmit the LSB and move the data towards the LSB position.
        shift_reg <= {1'b1, shift_reg[9:1]}; // Shift data, keeping the stop bit at the MSB.
    end
end

// Assign the least significant bit of the shift register to the UART transmit data (txd) output.
// This bit will be transmitted serially on the UART line.
assign txd = shift_reg[0];

endmodule
