//=========================================================
// EELE 0651: Computer Organization
// Authors: PJ Cheyne-Miller, Brenden O'Donnell
// Date: 10 November 2021
// Description:
// 
// Sets the control signals being fed to the data-path
// during instruction execution. It uses the current state,
// status bits (C and Z) and the INST contents to determine
// which instruction to execute.
//=========================================================

module processor_control_unit (
    /* input signals */
    input logic clk,    // clock signal

    /* input buses */
    input logic [5:0] ctl_op,   // control unit operation

    /* output signal */
    output logic reg_dst,
    output logic alu_src,
    output logic mem_to_reg,
    output logic reg_write,
    output logic mem_read,
    output logic mem_write,
    output logic branch,

    /* output buses */
    output logic [1:0] alu_op
);

    /* internal logic */
    logic [8:0] ctl_out;                // operation decoder output bus
    always_comb begin : control_output  // assigning bus lines to named signals
        reg_dst = ctl_out[8];           // mux select for destination of register writer
        alu_src = ctl_out[7];           // mux select for ALU source
        mem_to_reg = ctl_out[6];        // mux select for registers' write data source
        reg_write = ctl_out[5];         // enable signal for writing to registers
        mem_read = ctl_out[4];          // enable signal for reading from data memory
        mem_write = ctl_out[3];         // enable signal for writing to data memory
        branch = ctl_out[2];            // ANDed with zero flag for mux select forprogram counter
        alu_op = ctl_out[1:0];          // operation for ALU
    end

    case (ctl_op)                          // if the control unit operation is
        6'b000000: ctl_out <= 9'b100100010; // RTYPE, 100100010
        6'b100011: ctl_out <= 9'b011110000; // LW, 011110000
        6'b101011: ctl_out <= 9'b010001000; // SW, x1x001000
        6'b000100: ctl_out <= 9'b000000101; // BEQ, x0x000101
    endcase

endmodule
