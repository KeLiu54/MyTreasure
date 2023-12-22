  module seven_segment_decoder(
    input wire clock,     // System clock
    input wire reset,     // Reset signal
    input wire [6:0] data_in, // 8-bit input data for hex display
    output reg [6:0] hex6,    // 7-segment display output for tens place
    output reg [6:0] hex7     // 7-segment display output for ones place
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
        4'b0000: hex6 = 7'b1000000; // Display 0
        4'b0001: hex6 = 7'b1111001; // Display 1
        4'b0010: hex6 = 7'b0100100; // Display 2
        4'b0011: hex6 = 7'b0110000; // Display 3
        4'b0100: hex6 = 7'b0011001; // Display 4
        4'b0101: hex6 = 7'b0010010; // Display 5
        4'b0110: hex6 = 7'b0000010; // Display 6
        4'b0111: hex6 = 7'b1111000; // Display 7
		  
		  4'b1000: hex6 = 7'b0000000; // 8
        4'b1001: hex6 = 7'b0010000; // 9
        4'b1010: hex6 = 7'b0001000; // A
        4'b1011: hex6 = 7'b0000011; // B
        4'b1100: hex6 = 7'b1000110; // C
        4'b1101: hex6 = 7'b0100001; // D
        4'b1110: hex6 = 7'b0000110; // E
        4'b1111: hex6 = 7'b0001110; // F
		  
		  
        default: hex6 = 7'b1111111; // Default, all segments off
    endcase
end

// Decoding logic for ones place
always @(* )begin
    case(internal_data_tens)
        3'b0000: hex7 = 7'b1000000; // Display 0
        3'b0001: hex7 = 7'b1111001; // Display 1
        3'b0010: hex7 = 7'b0100100; // Display 2
        3'b0011: hex7 = 7'b0110000; // Display 3
        3'b0100: hex7 = 7'b0011001; // Display 4
        3'b0101: hex7 = 7'b0010010; // Display 5
        3'b0110: hex7 = 7'b0000010; // Display 6
        3'b0111: hex7 = 7'b1111000; // Display 7
        default: hex7 = 7'b1111111; // Default, all segments off
    endcase
end

endmodule