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
    input logic clk_in     // input clock signal

    /* input buses */
    

    /* output signals */

    /* output buses */

);

    /* declare variables */
        /* program counter */
        logic [31:0] pc_in;     // pc input bus
        logic [31:0] pc_out;    // pc output bus

        /* instruction memory */
        logic [31:0] imu_read_addr;  // input bus of instruction memory
        logic [31:0] instruction;    // output bus of intruction memory

        /* processor control unit */
        logic [5:0] pcu_in; // input of processor control unit
        logic reg_dst;      // mux select for source of register writer
        logic alu_src;      // mux select for ALU source
        logic mem_to_reg;   // mux select for registers' write data source
        logic reg_write;    // enable signal for writing to registers
        logic mem_read;     // enable signal for reading from data memory
        logic mem_write;    // enable signal for writing to data memory
        logic branch;       // ANDed with zero flag for mux select for program counter
        logic alu_op[1:0];  // operation for ALU

        /* ALU control unit */
        logic [3:0] alu_ctl;    // ALU control bus

        /* register file */
        logic [31:0] read_data_1;	// register file 32-bit output
        logic [31:0] read_data_2;   // register file 32-bit output
        logic [31:0] write_data;    // register file 32-bit input
        logic [4:0] read_reg_1;     // address of first register to read 
        logic [4:0] read_reg_2;     // address of second register to read
        logic [4:0] write_reg;      // address of register written

        /* arithmetic logic unit */
        logic [31:0] alu_in_a;      // input bus A of ALU      
        logic [31:0] alu_in_b;      // input bus B of ALU
        logic [31:0] alu_result;    // result from ALU
        logic F_zero;               // zero flag
        logic F_overflow;           // overflow flag

        /* sign extender */
        logic [15:0] sign_ext_in;   // sign extender input
        logic [31:0] sign_ext_out;  // sign extended output
        
        /* data memory unit */
        logic [7:0] dmu_addr;       // address for data memory unit access
        logic [31:0] dmu_data_in;   // data input bus for data memory unit
        logic [31:0] dmu_data_out;  // data output from data memory unit

    /* module declarations */
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
    processor_control_unit pcu (
        /* input signals */
        .clk (clk), // clock signal

        /* input buses */
        .ctl_op (pcu_in),   // input bus

        /* output signals */
        .reg_dst (reg_dst),         // write destination for register file
        .alu_src (alu_src),         // source of ALU port B data
        .mem_to_reg (mem_to_reg),   // data input to register file
        .reg_write (reg_write),     // write-enable signal for register file
        .mem_read (mem_read),       // read-enable signal for data memory
        .mem_write (mem_write),     // write-enable signal for data memory
        .branch (branch),           // branch instruction signal

        /* output buses */
        .alu_op (alu_op)    // opcode for ALU control unit
    );
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
    sign_extender extender (
        /* input buses */
        .instr_mem (sign_ext_in),   // data to be sign extended

        /* output buses */
        .sign_ext (sign_ext_out)    // sign extended data
    );
    memory_unit dmu (
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
    memory_unit imu(
        /* input signals */
        .clk (clk_mem), // clock signal
        .en (!clr),     // chip-enable signal
        .wen (1'b1),    // write-enable signal

        /* input buses*/
        .addr (imu_addr),       // address of word instruction coming in
        .data_in (imu_data_in), // input data bus

        /* output buses */
        .data_out (imu_data_out)    // output data bus
    );

    /* clock division */
    logic clk_mem;                      // memory clock
    logic clk;                          // standard clock
    always_comb begin : clk_sync        // sync memory clock signal
        clk_mem <= clk_in;              // memory clock is same speed as input clock signal
    end
    always @(negedge clk_mem) begin     // on negative edge of memory clock signal
        clk <= !clk;                    // flip standard clock signal
    end                                 // therefore divide clk_in by 2

    /* datapath logic */
    always_comb begin : datapath_logic
        /* next line of program */
        case ((branch & F_zero))                            // mux select
            1'b1: begin                                     // if (branch & F_zero) = 1,
                pc_in <= (pc_out + 4) + (sign_ext << 2);    // branch to
            end
            default: pc_in <= pc_out + 4;                   // else, next line
        endcase
        imu_read_addr <= pc_out;                            // read line specified by pc

        /* processor control unit */
        pcu_in[5:0] <= instruction[31:26];                  // portion of instruction for processor control unit
        
        /* register file */
        read_reg_1[4:0] <= instruction[25:21];              // portion of instruction for reading from register file
        read_reg_2[4:0] <= instruction[20:16];              // portion of instruction for reading from register file
        case (reg_dst)                                      // choosing correct bits from instruction for write address
            1'b1: write_reg[4:0] <= instruction[15:11];         // if reg_dst = 1
            default: write_reg[4:0] <= instruction[20:16];      // if reg_dst = 1
        endcase
        case (mem_to_reg)                       // choosing which data is written to register file
            1'b1: write_data <= dmu_data_out;       // from data memory
            default: write_data <= alu_result;      // from ALU
        endcase

        /* sign extender */
        sign_ext_in[15:0] <= instruction[15:0]; // sign extending 16 LSBs

        /* aritmetic logic unit */
        alu_ctl[5:0] <= instruction[5:0];   // funct for ALU controller
        alu_in_a <= read_data_1;            // ALU port A
        case (alu_src)                      // choosing ALU port B based on control signal
            1'b1: alu_in_b <= sign_ext_out;
            default: alu_in_b <= read_data_2; 
        endcase

        /* data memory unit */
        dmu_addr[7:0] <= alu_result[7:0];   // address to be written
        dmu_data_in <= read_data_2;         // data to be written
    end

endmodule

