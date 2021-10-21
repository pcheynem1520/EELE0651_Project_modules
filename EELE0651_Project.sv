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
    input logic clk_in,     // input clock signal
    input logic write,      // read/write control signal (read = 0, write = 1)
    input logic clr,        // clear/reset signal
    input logic pc_inc,     // increment pc signal
    input logic pc_ld,      // load pc data signal
    input logic dmu_wen,    // write enable for data memory unit

    /* output signals */
    output logic F_zero,    // zero flag
    output logic F_overflow // overflow flag
);

    /* internal logic */
		/* program counter */
		logic [31:0] reg_A;         // A register
		logic [31:0] reg_B;         // B register
		logic [31:0] reg_out;       // output register
		logic [31:0] pc_data_out;   // pc data output bus
        logic [31:0] pc_data_in;    // pc data input bus
		
		/* register file */
		logic [31:0] read_data_1;	// register file 32-bit output
		logic [31:0] read_data_2;   // register file 32-bit output
        logic [31:0] write_data;    // register file 32-bit input
        logic [4:0] read_reg_1;     // address of first register to read 
        logic [4:0] read_reg_2;     // address of second register to read
        logic [4:0] write_reg;      // address of register written

        /* arithmetic logic unit */
        logic [31:0] alu_op;        // alu operation
		logic [31:0] alu_result;    // result from alu
		
		/* data memory unit */
		logic [7:0] dmu_addr;       // address for data memory unit access
		logic [31:0] dmu_data_in;   // data input bus for data memory unit
		logic [31:0] dmu_data_out;  // data output from data memory unit

    /* module declarations */
    register_file reg_file (
        /* input signals */
        .clk (clk),     // clock signal
        .clr (clr),     // clear/reset signal
        .write (write), // read/write control signal (read = 0, write = 1)

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
        .clk (clk),     // clock signal
        .clr (clr),     // clear/reset signal
        .inc (pc_inc),  // increment program counter
        .ld (pc_ld),    // allow data to be stored

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
        .F_zero (F_zero),           // zero flag 1st bit of flags register
        .F_overflow (F_overflow),   // overflow flag 2nd bit of flags register

        /* output buses */
        .result (alu_result)    // final result
    );
    data_memory_unit dmu (
        /* input signals */
        .clk (clk_mem), // clock signal
        .en (!clr),     // chip-enable signal
        .wen (dmu_wen), // write-enable signal

        /* input buses */
        .addr (dmu_addr),       // 8-bit address of word being read/written
        .data_in (dmu_data_in), // input data bus

        /* output buses */
        .data_out (dmu_data_out)    // output data bus
    );

    /* clock division */
    logic clk_mem;  // memory clock
    logic clk;      // standard clock

    always_comb begin : clk_sync        // sync memory clock signal
        clk_mem <= clk_in;              // memory clock is same speed as input clock signal
    end always @(negedge clk_mem) begin // on negative edge of memory clock signal
        clk = !clk;                     // flip standard clock signal
    end                                 // therefore divide clk_in by 2

    

endmodule
