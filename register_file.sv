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
    output logic [31:0] read_data_1,	// register file 32-bit output
    output logic [31:0] read_data_2    // register file 32-bit output
);
    
    /* internal wiring */
    reg [31:0] reg_mem [31:0];

    /* module declarations */
        /* register reader */
        always @(read_reg_1 or reg_mem[read_reg_1]) begin
            if (0 == read_reg_1) begin
                read_data_1 = 0;
            end else begin
                read_data_1 = reg_mem[read_reg_1];
            end
        end

        always @(read_reg_2 or reg_mem[read_reg_2]) begin
            if (0 == read_reg_2) begin
                read_data_2 = 0;
            end else begin
                read_data_2 = reg_mem[read_reg_2];
            end
        end

        /* register writer */
        always @(posedge clk) begin
            if (write) begin
                reg_mem[write_reg] = write_data;
            end
        end

endmodule
