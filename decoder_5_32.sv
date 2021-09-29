module decoder_5_32 (
    /* input signals */
    input logic clk,            // clock signal
    
    /* input buses */
    input logic [4:0] sel,      // address of selected output line

    /* output buses */
    output logic [31:0] decoded // decoded 32-wire bus for output lines
);

    /* case statment of decoder */
    case (sel)
        5'b11111: decoded[31] = 1'b1;
        5'b11110: decoded[30] = 1'b1;
        5'b11101: decoded[29] = 1'b1;
        5'b11100: decoded[28] = 1'b1;
        5'b11011: decoded[27] = 1'b1;
        5'b11010: decoded[26] = 1'b1;
        5'b11001: decoded[25] = 1'b1;
        5'b11000: decoded[24] = 1'b1;
        5'b10111: decoded[23] = 1'b1;
        5'b10110: decoded[22] = 1'b1;
        5'b10101: decoded[21] = 1'b1;
        5'b10100: decoded[20] = 1'b1;
        5'b10011: decoded[19] = 1'b1;
        5'b10010: decoded[18] = 1'b1;
        5'b10001: decoded[17] = 1'b1;
        5'b10000: decoded[16] = 1'b1;
        5'b01111: decoded[15] = 1'b1;
        5'b01110: decoded[14] = 1'b1;
        5'b01101: decoded[13] = 1'b1;
        5'b01100: decoded[12] = 1'b1;
        5'b01011: decoded[11] = 1'b1;
        5'b01010: decoded[10] = 1'b1;
        5'b01001: decoded[9] = 1'b1;
        5'b01000: decoded[8] = 1'b1;
        5'b00111: decoded[7] = 1'b1;
        5'b00110: decoded[6] = 1'b1;
        5'b00101: decoded[5] = 1'b1;
        5'b00100: decoded[4] = 1'b1;
        5'b00011: decoded[3] = 1'b1;
        5'b00010: decoded[2] = 1'b1;
        5'b00001: decoded[1] = 1'b1;
        default: decoded[0] = 1'b1;
    endcase

endmodule
