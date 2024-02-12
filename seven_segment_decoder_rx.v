  module seven_segment_decoder_rx(
    input wire clock,     // System clock
    input wire reset,     // Reset signal
    input wire [6:0] data_in, // 8-bit input data for hex display
    output reg [6:0] hex1,    // 7-segment display output for tens place
    output reg [6:0] hex2     // 7-segment display output for ones place
);

reg [2:0] internal_data_tens;  // Data for tens place
reg [3:0] internal_data_ones;  // Data for ones place

always @(posedge clock or negedge reset) begin
    if (~reset) begin
        internal_data_tens <= 3'b000;
        internal_data_ones <= 4'b0000;
    end
    else begin
        internal_data_tens <= data_in[6:4]; // Taking the higher 4 bits
        internal_data_ones <= data_in[3:0]; // Taking the lower 4 bits
    end
end

// Decoding logic for tens place
always @(* )begin
    case(internal_data_ones)
        4'b0000: hex1 = 7'b1000000; // Display 0
        4'b0001: hex1 = 7'b1111001; // Display 1
        4'b0010: hex1 = 7'b0100100; // Display 2
        4'b0011: hex1 = 7'b0110000; // Display 3
        4'b0100: hex1 = 7'b0011001; // Display 4
        4'b0101: hex1 = 7'b0010010; // Display 5
        4'b0110: hex1 = 7'b0000010; // Display 6
        4'b0111: hex1 = 7'b1111000; // Display 7
		  
		  4'b1000: hex1 = 7'b0000000; // 8
        4'b1001: hex1 = 7'b0010000; // 9
        4'b1010: hex1 = 7'b0001000; // A
        4'b1011: hex1 = 7'b0000011; // B
        4'b1100: hex1 = 7'b1000110; // C
        4'b1101: hex1 = 7'b0100001; // D
        4'b1110: hex1 = 7'b0000110; // E
        4'b1111: hex1 = 7'b0001110; // F
		  
		  
        default: hex1 = 7'b1111111; // Default, all segments off
    endcase
end

// Decoding logic for ones place
always @(* )begin
    case(internal_data_tens)
        3'b0000: hex2 = 7'b1000000; // Display 0
        3'b0001: hex2 = 7'b1111001; // Display 1
        3'b0010: hex2 = 7'b0100100; // Display 2
        3'b0011: hex2 = 7'b0110000; // Display 3
        3'b0100: hex2 = 7'b0011001; // Display 4
        3'b0101: hex2 = 7'b0010010; // Display 5
        3'b0110: hex2 = 7'b0000010; // Display 6
        3'b0111: hex2 = 7'b1111000; // Display 7
        default: hex2 = 7'b1111111; // Default, all segments off
    endcase
end

endmodule