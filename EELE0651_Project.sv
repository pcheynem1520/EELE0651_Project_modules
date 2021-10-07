//=========================================================
// EELE 0651: Computer Organization
// Authors: PJ Cheyne-Miller, Brenden O'Donnell
// Date: 
// Description: 
// 
// A single cycle processor for given a subset of the MIPS
// instructions set.
//=========================================================

module EELE0651_Project (
    /* input signals */
    input logic clk,    // clock signal
    input logic write,  // read/write control signal (read = 0, write = 1)
    input logic clr,    // clear/reset signal
    input logic inc,    // increment pc signal
    input logic ld,     // load pc data signal 

    /* input buses */
    input logic [4:0] read_reg_1,   // address of first register to read 
    input logic [4:0] read_reg_2,   // address of second register to read
    input logic [4:0] write_reg,    // address of register written
    input logic [31:0] write_data,  // bus of data to write to register
    input logic [31:0] pc_data_in,  // pc data input bus
    input logic [31:0] alu_op,      // alu operation

    /* output buses */
    output logic read_data_1,           // register file 32-bit output
    output logic read_data_2,           // register file 32-bit output
    output logic [31:0] pc_data_out,    // pc data output bus
    output logic [31:0] alu_result      // result from alu
);

    /* internal wiring */
    reg [31:0] flags;       // flags register
    reg [31:0] reg_A;       // A register
    reg [31:0] reg_B;       // B register
    reg [31:0] reg_out;     // output register

    /* module declarations */
    register_file reg_file (
            .clk (clk),     // clock signal
            .write (write), // read/write control signal (read = 0, write = 1)
            .clr (clr),     // clear/reset signal

            /* input buses */
            .read_reg_1 (read_reg_1),   // address of first register to read 
            .read_reg_2 (read_reg_2),   // address of second register to read
            .write_reg (write_reg),     // address of register written
            .write_data (write_data),   // bus of data to write to register

            /* output buses */
            .read_data_1 (read_data_1), // register file 32-bit output
            .read_data_2 (read_data_2)  // register file 32-bit output
    );
    program_counter pc (
        /* input signals */
        .clk (clk), // clock signal
        .clr (clr), // clear/reset signal
        .inc (inc), // increment program counter
        .ld (ld),   // allow data to be stored

        /* input buses */
        .d (pc_data_in),    // input data bus

        /* output signals */
        .q (pc_data_out)    // output databus 
    );
    arithmetic_logic_unit ALU (
        /* input signals */
        .clk (clk), // clock signal

        /* input buses */
        .alu_op (alu_op),   // two bit number to choose result op code
        .A (reg_A),         // A register
        .B (reg_B),         // B register

        /* output signal */
        .F_zero (flags[0]),     // zero flag 1st bit of flags register
        .F_overflow (flags[1]), // overflow flag 2nd bit of flags register

        /* output buses */
        .result (alu_result),   // final result
    );

endmodule
