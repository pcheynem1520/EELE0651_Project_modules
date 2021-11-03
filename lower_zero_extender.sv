//=========================================================
// EELE 0651: Computer Organization
// Authors: PJ Cheyne-Miller, Brenden O'Donnell
// Date: 6 October 2021
// Description:
// 
// Keeps the value of the lower bits and sets it
// as the higher bits of a sequence. The lower 16 bits
// are then all set to be zeros.
//=========================================================

module lower_zero_extender (
    /* input buses */
    input logic [15:0] lower_bits,

    /* output buses */
    output logic [31:0] extended
);

    always_comb begin : lower_bit_extension
        extended[31:16] <= lower_bits[15:0];    // upper 16 bits
        extended[15:0] <= 16'b0000000000000000; // lower 16 bits
    end

endmodule
