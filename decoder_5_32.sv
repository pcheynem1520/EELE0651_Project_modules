module decoder_5_32 (
    /* input signals */
    input logic clk,            // clock signal
    
    /* input buses */
    input logic [4:0] sel,      // address of selected output line

    /* output buses */
    output logic [31:0] decoded // decoded 32-wire bus for output lines
);

    /* case statment of decoder */
    always @(sel) begin
        case (sel)
            5'b11111: begin decoded[31] = 1'b1; end
            5'b11110: begin decoded[30] = 1'b1; end
            5'b11101: begin decoded[29] = 1'b1; end
            5'b11100: begin decoded[28] = 1'b1; end
            5'b11011: begin decoded[27] = 1'b1; end
            5'b11010: begin decoded[26] = 1'b1; end
            5'b11001: begin decoded[25] = 1'b1; end
            5'b11000: begin decoded[24] = 1'b1; end
            5'b10111: begin decoded[23] = 1'b1; end
            5'b10110: begin decoded[22] = 1'b1; end
            5'b10101: begin decoded[21] = 1'b1; end
            5'b10100: begin decoded[20] = 1'b1; end
            5'b10011: begin decoded[19] = 1'b1; end
            5'b10010: begin decoded[18] = 1'b1; end
            5'b10001: begin decoded[17] = 1'b1; end
            5'b10000: begin decoded[16] = 1'b1; end
            5'b01111: begin decoded[15] = 1'b1; end
            5'b01110: begin decoded[14] = 1'b1; end
            5'b01101: begin decoded[13] = 1'b1; end
            5'b01100: begin decoded[12] = 1'b1; end
            5'b01011: begin decoded[11] = 1'b1; end
            5'b01010: begin decoded[10] = 1'b1; end
            5'b01001: begin decoded[9] = 1'b1; end
            5'b01000: begin decoded[8] = 1'b1; end
            5'b00111: begin decoded[7] = 1'b1; end
            5'b00110: begin decoded[6] = 1'b1; end
            5'b00101: begin decoded[5] = 1'b1; end
            5'b00100: begin decoded[4] = 1'b1; end
            5'b00011: begin decoded[3] = 1'b1; end
            5'b00010: begin decoded[2] = 1'b1; end
            5'b00001: begin decoded[1] = 1'b1; end
            default: begin decoded[0] = 1'b1; end
        endcase
    end

endmodule
