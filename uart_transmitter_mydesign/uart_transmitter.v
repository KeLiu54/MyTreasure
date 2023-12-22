
module uart_transmitter(
    input clk,         // 
    input key0,         // 
    input key1,       // 
    input [6:0] data_in, //                
    output txd,
    output [6:0]hex6,
    output [6:0]hex7	 // UART
);



// 
wire load_data;
wire shift_en;
wire done;
wire baud_tick;
wire pulse;
wire parity_bit;
wire rst;
assign rst = ~key0;
//wire clk_1;


even_parity_generator even_parity_generator_inst (

     .data_in(data_in), 
     .parity_bit(parity_bit) 


);



single_pulse single_pulse_inst(
    .clk(clk),
    .rst(rst),
    .pulse(pulse),
    .key1(key1)
);





// 
controller ctrl_inst(
    .clk(clk ),
    .rst(rst),
    .pulse(pulse),
    .done(done),
    .shift_en(shift_en),
    .load(load_data)
);

// 
bit_counter bit_counter_inst(
    .clk(clk ),
	 .baud_tick(baud_tick),
    .rst(rst),
    .shift_en(shift_en),
    .done(done)
);

// 
shift_register shift_reg_inst(
    .clk(clk ),
	 .baud_tick(baud_tick),  // 
    .rst(rst),
    .load_data(load_data),
    .shift_en(shift_en),
    .data_in(data_in),
    .parity_bit(parity_bit),
    .shift_reg(),     // 
    .txd(txd)
);




baud_rate_generator baud_rate_generator_inst(
    .clk(clk),  // 
    .rst(rst),
    .baud_tick(baud_tick)
    
);


  seven_segment_decoder seven_segment_decoder_inst(
     .clock(clk),     // System clock
     .reset(key0),     // Reset signal
     .data_in(data_in), // 8-bit input data for hex display
     .hex6(hex6),    // 7-segment display output for tens place
     .hex7(hex7)     // 7-segment display output for ones place
);





endmodule
