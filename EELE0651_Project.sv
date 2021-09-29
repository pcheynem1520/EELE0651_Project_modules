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

    /* output buses */
    output logic read_data_1,           // register file 32-bit output
    output logic read_data_2,           // register file 32-bit output
    output logic [31:0] pc_data_out     // pc data output bus
);

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

endmodule