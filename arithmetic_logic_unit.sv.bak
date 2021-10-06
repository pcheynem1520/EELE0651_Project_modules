//=========================================================
// EELE 0651: Computer Organization
// Authors: PJ Cheyne-Miller, Brenden O'Donnell
// Date: 6 October 2021
// Description:
// 
// Arithmetic Logic Unit
// Takes 3-bit opcodes which specify the operation to be
// performed. Should the operations result in zero or
// overflow, the appropriate flags will be set.
//=========================================================

module arithmetic_logic_unit (
    /* input signals */
    input logic clk,        // clock signal

    /* input buses */
    input logic [2:0] alu_op,    // two bit number to choose result op code
    input logic [31:0] A,           // A register
    input logic [31:0] B,           // B register

    /* output signal */
    output logic F_zero,        // zero flag:       set if result is zero
    output logic F_overflow,    // overflow flag:   set if result has overflowed

    /* output buses */
    output logic [31:0] result,     // final result
);

    /* internal wiring */
    wire [32:0] tmp_res;
    always_comb begin : result+overflow
        result[31:0] = tmp_res[31:0];
        F_overflow = tmp_res[32];
    end

    /* initialization */
    initial begin
        result = 0;     // result bus starts as 0
        F_zero = 0;     // zero flag unset
        F_overflow = 0; // overfow flag unset
    end

    /* ALU definition */
    always @(posedge clk) begin
        case (alu_op)
            3'b000:     result <= A & B;
            3'b001:     result <= A | B;
            3'b010:     result <= A + B;
            3'b110:     result <= A - B;
            3'b100:     result <= A << 1;
            3'b101:     result <= A >> 1;
            default:    result <= result;   // error, do nothing
        endcase

        // check result for zero flag
        if (result == 0) begin
            F_zero = 1;
        end else begin
            F_zero = 0;
        end
    end

endmodule
