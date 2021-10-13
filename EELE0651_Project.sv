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
    input logic clk,        // clock signal
    input logic write,      // read/write control signal (read = 0, write = 1)
    input logic clr,        // clear/reset signal
    input logic pc_inc,     // increment pc signal
    input logic pc_ld,      // load pc data signal
    input logic dmu_wen,    // write enable for data memory unit

    /* input buses */
    input logic [4:0] read_reg_1,   // address of first register to read 
    input logic [4:0] read_reg_2,   // address of second register to read
    input logic [4:0] write_reg,    // address of register written
    input logic [31:0] write_data,  // bus of data to write to register
    input logic [31:0] pc_data_in,  // pc data input bus
    input logic [31:0] alu_op,      // alu operation
    input logic [7:0] dmu_adr,      // address for data memory unit access
    input logic [31:0] dmu_data_in, // data input bus for data memory unit

    /* output buses */
    output logic read_data_1,           // register file 32-bit output
    output logic read_data_2,           // register file 32-bit output
    output logic [31:0] pc_data_out,    // pc data output bus
    output logic [31:0] alu_result      // result from alu
    output logic [31:0] dmu_data_out    // data output from data memory unit
);

    /* internal logic */
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
        .inc (pc_inc), // increment program counter
        .ld (pc_ld),   // allow data to be stored

        /* input buses */
        .d (pc_data_in),    // input data bus

        /* output signals */
        .q (pc_data_out)    // output databus 
    );
    arithmetic_logic_unit alu (
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
        .result (alu_result)    // final result
    );
    data_memory_unit dmu (
        /* input signals */
        .clk (clk),     // clock signal
        .en (!clr),     // chip-enable signal
        .wen (dmu_wen), // write-enable signal

        /* input buses */
        .addr (dmu_adr),        // 8-bit address of word being read/written
        .data_in (dmu_data_in), // input data bus

        /* output buses */
        .data_out (dmu_data_out)    // output data bus
    );

endmodule
