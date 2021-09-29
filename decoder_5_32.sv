module decoder_5_32 (
    /* input signals */
    input logic clk,            // clock signal
    
    /* input buses */
    input logic [4:0] sel,      // address of selected output line

    /* output buses */
    output logic [31:0] decoded // decoded 32-wire bus for output lines
);

    always_comb begin
        decoded[sel] = 1; // set output line high if equal to select bus
    end

endmodule
