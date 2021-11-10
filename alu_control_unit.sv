//=========================================================
// EELE 0651: Computer Organization
// Authors: PJ Cheyne-Miller, Brenden O'Donnell
// Date: 6 October 2021
// Description:
// 
// 
//=========================================================

module alu_control_unit (
    /* input buses */
    input logic [31:0] alu_op,  // ALU operation code
    input logic [5:0] funct,    // function code

    /* output buses */
    output logic [3:0] alu_ctl
);

    casex (alu_op)
        2'b00: alu_ctl <= 0010;                 // if opcode = LW/SW, add 
        2'b01: alu_ctl <= 0110;                 // if opcode = BEQ, subtract
        2'b1x: begin                            // if opcode = RTYPE and;
            case (funct)
                6'b100000: alu_ctl <= 4'b0010;  // if funct = ADD, add
                6'b100010: alu_ctl <= 4'b0110;  // if funct = SUB, subtract
                6'b100100: alu_ctl <= 4'b0000;  // if funct = AND, and
                6'b100101: alu_ctl <= 4'b0001;  // if funct = OR, or
                6'b101010: alu_ctl <= 4'b0111;  // if funct = SLT, set on less than
            endcase
        end
    endcase

endmodule
