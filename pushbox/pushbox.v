// Part 2 skeleton

module pushbox
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,  						//	VGA Blue[9:0]
		test,
		odata0,
		odata1,
		direct_test
	);
   output test;
	output [3:0] direct_test;
	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	output [6:0] odata0,odata1;
	
	wire resetn;
	assign resetn = SW[9];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK),
			.VGA_SYNC(VGA_SYNC),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	wire [7:0] x_position_w;
	wire [6:0] y_position_w;
	wire point_cnt_en_w;
    point_cnt point_cnt_u(.clk50M(CLOCK_50),
	                       .rst_n(resetn),
								  .point_cnt_en(point_cnt_en_w),
								  .x(x_position_w),
								  .y(y_position_w));
	wire [2:0] colour_draw;
	wire writeEn_draw;
	picture_draw picture_draw_u(.clk50M(CLOCK_50),
	                            .rst_n(resetn),
										 .point_cnt_en(point_cnt_en_w),
										 .x_position(x_position_w),
										 .y_position(y_position_w),
										 .x0(x0_w),
										 .y0(y0_w),
										 .object_select(object_sel_w),
										 .colour(colour_draw),
										 .writen(writeEn_draw));
	wire [1:0] object_sel_w;
	wire [7:0] x0_w;
	wire [6:0] y0_w;
	fsm fsm_u(.clk50M(CLOCK_50),
	          .rst_n(resetn),
				 .key(KEY),
				 .sw(SW[0]),
				 .time_remain(time_remain_w),
				 .object_sel(object_sel_w),
				 .x0(x0_w),
				 .y0(y0_w),
				 .test(test),
				 .direct_test(direct_test),
				 .point_cnt_en(point_cnt_en_w),
				 .win_or_lose(win_or_lose_w),
				 .gaming(gaming_w),
				 .time_dis());
	wire [1:0] win_or_lose_w;
	//wire [7:0] x_w;
	//wire [6:0] y_w;
	wire gaming_w;
	picture_select picture_select_u(
	          .clk50M(CLOCK_50),
				 .rst_n(resetn),
				 .gaming(gaming_w),
				 .win_or_lose(win_or_lose_w),
				 .x_in(x_position_w),
				 .y_in(y_position_w),
				 .colour_in(colour_draw),
				 .writeEn_in(writeEn_draw),
				 .x_choose(x),
				 .y_choose(y),
				 .colour_choose(colour),
				 .writeEn_choose(writeEn));
	wire [5:0] time_remain_w;
   time_remain time_remain_u(
	          .clk50M(CLOCK_50),
				 .rst_n(resetn),
				 .start(SW[0]),
				 .time_remain(time_remain_w));
	wire [3:0] d0_w,d1_w;
	bin2dec bin2dec_u(
	          .clk50M(CLOCK_50),
				 .rst_n(resetn),
				 .data_in({26'd0,time_remain_w}),
				 .d0(d0_w),
				 .d1(d1_w));
	HEX HEX_u(
	          .idata({24'd0,d1_w,d0_w}),
				 .rst(resetn),
				 .clk(CLOCK_50),
				 .odata0(odata0),
				 .odata1(odata1));
    // Instanciate datapath
	
    // Instanciate FSM control

endmodule
