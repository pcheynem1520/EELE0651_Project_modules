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
    output logic [2:0] alu_ctl
);

    always_comb begin
        casex (alu_op)
            2'b00: alu_ctl <= 0010;                 // if opcode = LW/SW, add 
            2'b01: alu_ctl <= 0110;                 // if opcode = BEQ, subtract
            2'b1x: begin                            // if opcode = RTYPE and;
                case (funct)
                    6'b100000: alu_ctl <= 3'b010;   // if funct = ADD, add
                    6'b100001: alu_ctl <= 3'b100;   // if funct = ROL, rotate 1 bit left
                    6'b100010: alu_ctl <= 3'b110;   // if funct = SUB, subtract
                    6'b100011: alu_ctl <= 3'b101;   // if funct = ROR, rotate 1 bit right
                    6'b100100: alu_ctl <= 3'b000;   // if funct = AND, and
                    6'b100101: alu_ctl <= 3'b001;   // if funct = OR, or
                endcase
            end
        endcase
    end

endmodule
