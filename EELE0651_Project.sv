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
    input logic pc_ld,      // load program counter data signal
    input logic ir_ld,      // load instruction register data signal
    input logic dmu_wen,    // write enable for data memory unit
    input logic mux_a,      // select signal for A register mux
    input logic mux_b,      // select signal for B register mux
    input logic mux_data,   // select signal for data memory mux
    input logic mux_im_1,   // select signal for ALU input 1 between IR bus or data bus

    /* input buses */
    input logic [1:0] mux_im_2, // select signal for ALU input 1 between IR bus or data bus

    /* output signals */
    output logic F_zero,        // zero flag
    output logic F_overflow,    // overflow flag

    /* output buses */
    output logic [31:0] data_bus    // output data bus
);

    /* internal logic */
		/* program counter */
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
        logic [31:0] alu_in_a;      // input bus A of ALU      
        logic [31:0] alu_in_b;      // input bus B of ALU
		logic [31:0] alu_result;    // result from ALU
		
		/* data memory unit */
		logic [7:0] dmu_addr;       // address for data memory unit access
		logic [31:0] dmu_data_in;   // data input bus for data memory unit
		logic [31:0] dmu_data_out;  // data output from data memory unit

        /* zero extenders and reducer unit */
        logic [15:0] uze_in;    // upper zero extender input
        logic [31:0] uze_out;   // upper zero extender output

        logic [15:0] lze_pc_in;  // lower zero extender input
        logic [31:0] lze_pc_out; // lower zero extender output
        
        logic [15:0] lze_a_in;  // lower zero extender input
        logic [31:0] lze_a_out; // lower zero extender output
        
        logic [15:0] lze_b_in;  // lower zero extender input
        logic [31:0] lze_b_out; // lower zero extender output
        
        logic [15:0] lze_alu_in;  // lower zero extender input
        logic [31:0] lze_alu_out; // lower zero extender output

        /* datapath */
		logic [31:0] reg_a;         // A register
		logic [31:0] reg_b;         // B register

        /* instruction register */
        logic [31:0] ir_in;     // instruction register output
        logic [31:0] ir_out;    // instruction register input

        /* unknown */
        logic [31:0] M; // placeholder, from datapath diagram

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
        .A (alu_in_a),      // ALU input A
        .B (alu_in_b),      // ALU input B

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
    upper_zero_extender uze (
        /* input buses */
        .lower_bits (uze_in),   // output of uze
        
        /* output buses */
        .extended (uze_out) // output of uze
    );
    lower_zero_extender lze_pc (
        /* input buses */
        .lower_bits (lze_pc_in), // input of lze

        /* output buses */
        .extended (lze_pc_out)   // output of lze
    );
    lower_zero_extender lze_a (
        /* input buses */
        .lower_bits (lze_a_in), // input of lze

        /* output buses */
        .extended (lze_a_out)   // output of lze
    );
    lower_zero_extender lze_b (
        /* input buses */
        .lower_bits (lze_b_in), // input of lze

        /* output buses */
        .extended (lze_b_out)   // output of lze
    );
    lower_zero_extender lze_alu (
        /* input buses */
        .lower_bits (lze_alu_in), // input of lze

        /* output buses */
        .extended (lze_alu_out)   // output of lze
    );
    reducer_unit red (
        /* input buses */
        .data_in (red_in),  // input of reducer

        /* output buses */
        .data_out (red_out) // output of reducer
    );

    /* clock division */
    logic clk_mem;  // memory clock
    logic clk;      // standard clock
    always_comb begin : clk_sync        // sync memory clock signal
        clk_mem <= clk_in;              // memory clock is same speed as input clock signal
    end
    always @(negedge clk_mem) begin     // on negative edge of memory clock signal
        clk <= !clk;                    // flip standard clock signal
    end                                 // therefore divide clk_in by 2

    /* datapath logic */
    always_comb begin : datapath
        /* program counter input */
        pc_data_in <= lze_pc_out;   // PC input is lower-zero-extended

        /* no idea */
        M <= pc_data_out;   // placeholder, no idea what this is

        /* instruction register inputs */
        ir_in <= data_bus;  // output data bus connected to instruction register input
        ir_out <= ir_in;    // placeholder, until instruction register is made

        /* instruction register outputs */
        red_in <= ir_out;       // reducer input is instruction register output
        uze_in <= ir_out;       // UZE input is instruction register output
        lze_pc_in <= ir_out;    // PC's LZE input is instruction register output
        lze_a_in <= ir_out;     // A register's LZE input is instruction register output
        lze_b_in <= ir_out;     // B register's LZE input is instruction register output
        lze_alu_in <= ir_out;   // ALU's LZE input is instruction register output

        /* data memory unit input */
        dmu_addr <= red_out;    // reduce IR output to 8-bit DMU address
        case (mux_data)                     // select signal: mux_data
            1'b1: dmu_data_in <= reg_a;     // 1:   register A is data input
            default: dmu_data_in <= reg_b;  // 0:   register B is data input
        endcase
        
        /* A register inputs */
        case (mux_a)                    // select signal: mux_a
            1'b1: reg_a <= lze_a_out;   // 1:   A register is LZE 2 output
            default: reg_a <= data_bus; // 0:   A register is output data bus
        endcase

        /* B register inputs */
        case (mux_b)                    // select signal: mux_a
            1'b1: reg_b <= lze_b_out;   // 1:   A register is LZE 3 output
            default: reg_b <= data_bus; // 0:   A register is output data bus
        endcase

        /* arithmetic logic unit inputs */
        case (mux_im_1)                 // select signal: mux_im_1
            1'b1: alu_in_a <= uze_out;  // 1:   UZE output
            default: alu_in_a <= reg_a; // 0:   A register
        endcase
        case (mux_im_2)                                                 // select signal: mux_im_2
            2'b01: alu_in_b <= lze_alu_out;                             // 1:   LZE output  
            2'b10: begin                                                // 2:   set each bit
                for (int i = 0; i < $size(alu_in_b); i = i + 1) begin       // for each bit of alu_in_b
                    alu_in_b[i] <= 1;                                       // set it
                end 
            end
            default: alu_in_b <= reg_b;                                 // 0:   B register
        endcase

        /* data bus inputs */
        case (mux_data)                         // select signal: mux_data
            2'b01: data_bus <= dmu_data_out;    // 1:   data bus is data memory output
            2'b10: data_bus <= alu_result;      // 2:   data bus is ALU output
            default: data_bus <= M;             // 0:   data bus is ??? placeholder ???
        endcase
    end

endmodule
