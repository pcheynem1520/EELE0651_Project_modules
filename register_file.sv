//=========================================================
// EELE 0651: Computer Organization
// Authors: PJ Cheyne-Miller, Brenden O'Donnell
// Date: 29 September 2021
// Description:
// 
//=========================================================

module register_file (
    /* input signals */
    input logic clk,                // clock signal
    input logic write,              // read/write control signal (read = 0, write = 1)
    input logic clr,                // clear/reset signal

    /* input buses */
    input logic [4:0] read_reg_1,   // address of first register to read 
    input logic [4:0] read_reg_2,   // address of second register to read
    input logic [4:0] write_reg,    // address of register written
    input logic [31:0] write_data,  // bus of data to write to register

    /* output buses */
    output logic read_data_1,       // register file 32-bit output
    output logic read_data_2        // register file 32-bit output
);

    

    /* variables & wires*/
    genvar i;
    wire [31:0] reg_data;
    wire [31:0] decode_sel;
    wire [31:0] reg_sel;

    /* module declarations */
        /* register reader */
            multiplexer MUX_1(
                /* inputs */
                .clk (clk),                 // clock signal
                .reg_adr (read_reg_1),      // register address for input of MUX_1
                .reg_data (reg_data),       // data buses of registers
                
                /* outputs */
                .read_data (read_data_1)    // 32-bit output of MUX_1
            );
            multiplexer MUX_2(
                /* inputs */
                .clk (clk),                 // clock signal
                .reg_adr (read_reg_2),      // register address for input of MUX_2
                .reg_data (reg_data),       // data buses of registers
            
                /* outputs */
                .read_data (read_data_2)    // 32-bit ouput of MUX_2
            );

        /* register writer */
            decoder_5_32 decoder (
                /* input ports */
                .sel (reg_adr),         // address of register to write
                
                /* output ports */
                .decoded (decode_sel)   // 32-wire bus to be ANDed with write signal for chip select
            );
            generate // generate 32 32-bit registers
                for (i = 0; i < 32; i = i + 1) begin : gen_memory
                    reg_32bit register (
                        .clk (clk),         // clock signal
                        .rst (clr),         // clear/reset signal
                        .cs (reg_sel[i]),   // chip select bus
                        .d (write_data),    // bus for data to be written to registers
                        .q (reg_data)       // bus for data to be read from registers
                    );
                end
            endgenerate

            /* select register to write  */
            always_comb begin
                reg_sel = write & decode_sel;   // bitwise AND write signal with decode_sel bus
            end
    
    /* initialisation */
    /* 
    initial begin
        assign clk <= 0;    // start clock signal low
        assign write <= 0;  // start write signal low
        assign clr = 1;     // send clear signal
        assign clr = 0;     // set clear signal low
    end
    */
endmodule
