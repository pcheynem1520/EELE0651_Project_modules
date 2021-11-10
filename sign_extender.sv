//=========================================================
// EELE 0651: Computer Organization
// Authors: PJ Cheyne-Miller, Brenden O'Donnell
// Date: 6 October 2021
// Description:
// 
// Extends a 16-bit input to a 32-bit output. Extends the
// MSB of the input to fill the output to maintain 2's
// complement.
// E.g. 0x0FFF -> 0x00000FFF and 0xF000 -> 0xFFFFF000
//=========================================================


module sign_extender(
    /* input buses */
    input logic [15:0] inst_mem,        // instruction memory data

    /* output buses */
    output logic [31:0] sign_ext        // sign-extended value
);

    always_comb begin : sign_extend
        sign_ext[15:0] <= inst_mem[15:0];                       // lower 16 bits are identical
        case (inst_mem[15])
            1'b1: sign_ext[31:16] <= 16'b1111111111111111;      // if upper bit from input bus is 1, extend by 16 1s
            default: sign_ext[31:16] <= 16'b0000000000000000;   // if lower bit from input bus is 0, extend by 16 0s
        endcase
    end

endmodule
