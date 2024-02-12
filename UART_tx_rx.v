// Top-level module for a UART transmitter system.
// This module integrates all submodules necessary for UART transmission and control.
module UART_tx_rx(

    // tx part
    input clk,           // System clock signal.
    input key0,          // Active-low reset signal.
    input key1,          // Button input for initiating transmission.
    input [6:0] data_in, // 7-bit data to be transmitted via UART.
    output txd,          // UART transmission line.
    output [6:0] hex6,   // Output for tens place of seven-segment display.
    output [6:0] hex7,    // Output for ones place of seven-segment display.
	 
	 
	 // rx part
	 input serial_in,    // Serial input
    output [6:0] hex1,  // 7-segment display for tens digit
    output [6:0] hex2,  // 7-segment display for units digit
    output [6:0] seven_bit_data, // Data bits output for data comparison
    output framing_err, // Framing error indicator
    output parity_err   // Parity error indicator  
);


// Internal signal declarations.
wire load_data;    // Signal to load data into the shift register.
wire shift_en;     // Signal to enable the shift register to begin shifting data out.
wire done;         // Signal indicating that data transmission is complete.
wire baud_tick;    // Timing signal derived from the baud rate generator.
wire pulse;        // Single pulse signal generated in response to button press.
wire parity_bit;   // Calculated parity bit for the data to be transmitted.
wire rst;          // Internal reset signal, active-high.
assign rst = ~key0; // Inverting the active-low reset signal for internal use.
// Instantiation of the even parity generator submodule.

wire en; // Enable signal for baud rate generator and bit counter
wire baud_tick_rx; // Baud rate clock tick
wire done_rx; // Signal to indicate the end of reception
wire [8:0] parallel_out; // Internal parallel data output




// transmitter part

even_parity_generator_tx even_parity_generator_inst (
    .data_in(data_in),    // Input data for which parity is to be generated.
    .parity_bit(parity_bit) // Output parity bit.
);


// Instantiation of the single pulse generator submodule.
single_pulse_tx single_pulse_inst(
    .clk(clk),        // System clock signal.
    .rst(rst),        // Active-high reset signal.
    .pulse(pulse),    // Output single pulse signal.
    .key1(key1)       // Input signal for pulse generation (button press).
);

// Instantiation of the controller submodule.
controller_tx ctrl_inst(
    .clk(clk),        // System clock signal.
    .rst(rst),        // Active-high reset signal.
    .pulse(pulse),    // Input pulse signal indicating a button press.
    .done(done),      // Input signal indicating transmission completion.
    .shift_en(shift_en), // Output signal to enable shifting of data.
    .load(load_data)  // Output signal to load data into the shift register.
);

// Instantiation of the bit counter submodule.
bit_counter_tx bit_counter_inst(
    .clk(clk),        // System clock signal.
    .baud_tick(baud_tick), // Baud rate timing signal.
    .rst(rst),        // Active-high reset signal.
    .shift_en(shift_en), // Input signal to enable bit counting.
    .done(done)       // Output signal indicating a full frame has been transmitted.
);

// // Instantiation of the shift register submodule.
shift_register_tx shift_reg_inst(
    .clk(clk ),
	 .baud_tick(baud_tick),  // 
    .rst(rst),
    .load_data(load_data),
    .shift_en(shift_en),
    .data_in(data_in),
    .parity_bit(parity_bit),
    .shift_reg(),     // 
    .txd(txd)  // Output transmission line for UART data
);


// Instantiation of the baud rate generator submodule.
baud_rate_generator_tx baud_rate_generator_inst(
    .clk(clk),        // System clock signal.
    .rst(rst),        // Active-high reset signal.
    .baud_tick(baud_tick) // Output baud rate timing signal.
);


  seven_segment_decoder_tx seven_segment_decoder_tx_inst(
     .clock(clk),     // System clock
     .reset(key0),     // Reset signal
     .data_in(data_in), // 8-bit input data for hex display
     .hex6(hex6),    // 7-segment display output for tens place
     .hex7(hex7)     // 7-segment display output for ones place
);


/////////////////////////////////////////////////

// Controller
controller_rx ctrl(
    .clk(clk),
    .reset(rst),
    .serial_in(serial_in),
    .done_rx(done_rx),
    .en(en) // Enables baud rate generator and bit counter
);

// Baud Rate Generator
baud_rate_generator_rx brg(
    .clk(clk),
    .rst(rst),
    .en(en), // Enabled by controller
    .baud_tick_rx(baud_tick_rx) // Generates baud rate ticks
);

// Bit Counter
bit_counter_rx bc(
    .clk(clk),
    .rst(rst),
    .en(en), // Enabled by controller
    .baud_tick_rx(baud_tick_rx), // Uses baud rate ticks to count bits
    .done_rx(done_rx) // Indicates completion of bit counting
);

// Receiver Shift Register
shift_register_rx receiver(
    .clk(clk),
    .reset(rst),
    .serial_in(serial_in),
    .baud_tick_rx(baud_tick_rx), // Uses baud rate ticks for shifting
    .en(en), // Enabled by controller
    .parallel_out(parallel_out), // Internal parallel output
    .seven_bit_data(seven_bit_data) // External parallel output for comparison
);

// Seven Segment Decoder
seven_segment_decoder_rx ssd(
     .clock(clk),     // System clock
     .reset(key0),     // Reset signal
     .data_in(seven_bit_data), // 7-bit input data for hex display
     .hex1(hex1),    // 7-segment display output for tens place
     .hex2(hex2)     // 7-segment display output for ones place
);

// Framing Error Detection
framing_error framing_err_inst(
    .parallel_out(parallel_out), // Uses parallel output to detect framing errors
    .error(framing_err) // Indicates a framing error
);

// Parity Error Detection
parity_error parity_err_inst(
    .parallel_out(parallel_out), // Uses parallel output to detect parity errors
    .error(parity_err) // Indicates a parity error
);








endmodule
