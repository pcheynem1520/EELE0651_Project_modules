//=========================================================
// EELE 0651: Computer Organization
// Authors: PJ Cheyne-Miller, Brenden O'Donnell
// Date: 6 October 2021
// Description:
// 
// Takes 3-bit opcodes which specify the operation to be
// performed. Should the operations result in zero or
// overflow, the appropriate flags will be set.
//=========================================================

module arithmetic_logic_unit (
    /* input signals */
    input logic clk,    // clock signal

    /* input buses */
    input logic [2:0] alu_op,   // three bit number to choose result op code
    input logic [31:0] A,       // A register
    input logic [31:0] B,       // B register

    /* output signal */
    output logic F_zero,        // zero flag, set if result is zero
    output logic F_overflow,    // overflow flag, set if result has overflowed

    /* output buses */
    output logic [31:0] result  // final result
);

    /* internal wiring */
    wire [32:0] tmp_res;                    // result register plus overflow bit
    /*
    always_comb begin : result_and_overflow // combinational logic
        tmp_res[31:0] = result[31:0];
        tmp_res[32] = F_overflow;
    end
    */

    /* initialization */
    initial begin       // initialise the following values:
        result = 0;     // result bus = 0
        F_zero = 0;     // zero flag = unset
        F_overflow = 0; // overfow flag = unset
    end

    /* ALU definition */
    always @(posedge clk) begin             // on the positive edge of the clock signal,
        case (alu_op)                       // depending on the op code,
            3'b000:     tmp_res <= A & B;   // AND A and B,
            3'b001:     tmp_res <= A | B;   // Or A and B,
            3'b010:     tmp_res <= A + B;   // add A and B,
            3'b110:     tmp_res <= A - B;   // subtract B from A,
            3'b100:     tmp_res <= A << 1;  // rotate A 1 bit left,
            3'b101:     tmp_res <= A >> 1;  // rotate A 1 bit right, or
        endcase
        result[31:0] <= tmp_res[31:0];    // assign output to temporary value
        F_overflow <= tmp_res[32];  // assign overflow flag

        if (result == 0) begin  // if the result bus is all zeros,
            F_zero = 1;         // set the zero flag,
        end else begin          // otherwise,
            F_zero = 0;         // unset the zero flag
        end
    end

endmodule
