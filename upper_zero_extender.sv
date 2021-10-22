module upper_zero_extender (
    /* input buses */
    input logic [15:0] lower_bits,
    
    /* output buses */
    output logic [31:0] extended
    
);

    always_comb begin : upper_bit_extension
        extended[31:16] <= 16'b0000000000000000;    // upper 16 bits
        extended[15:0] <= lower_bits[15:0];         // lower 16 bits
    end

endmodule
