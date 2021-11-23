//=========================================================
// EELE 0651: Computer Organization
// Authors: PJ Cheyne-Miller, Brenden O'Donnell
// Date: 
// Description: 
// 
// A single cycle processor for given a subset of the MIPS
// instructions set.
// 
// TESTBENCH FILE
//=========================================================

`timescale 1ns/1ns

/* testbench signals */
module project_TB;
    /* input signals */
    logic CLOCK;    // clock signal
    logic HALT;     // halt clock signal
    logic CLEAR;    // clear/reset signal
    logic PROG_W;   // write-enable signal for program memory

    /* input bus */
    logic [7:0] PROG_ADDR;  // address of written program line
    logic [31:0] PROG_DATA; // data of written program line

    /* define program to run on processor */
    reg [31:0] PROGRAM [31:0];
    int MAX_LINE = 8;   // final line number of program (1-based index)
    initial begin       // defining instructions of program
        PROGRAM[0] = 32'b00000000000000000000000000000000;
        PROGRAM[1] = 32'b00000000000000000000000000000000;
        PROGRAM[2] = 32'b00000000000000000000000000000000;
        PROGRAM[3] = 32'b00000000000000000000000000000000;
        PROGRAM[4] = 32'b00000000000000000000000000000000;
        PROGRAM[5] = 32'b00000000000000000000000000000000;
        PROGRAM[6] = 32'b00000000000000000000000000000000;
        PROGRAM[7] = 32'b00000000000000000000000000000000;
    end

    /* instantiation of unit under test */
    EELE0651_Project uut(
        /* input signals */
        .clk (CLOCK),   // clock signal
        .clr (CLEAR),   // clear/reset signal

        /* input buses */
        .prog_addr (PROG_ADDR), // 8-bit address of line for instruction
        .prog_data (PROG_DATA)  // 32-bit word to input to program memory
    );

    /* initialization */
    initial begin
        HALT <= 1'b1;    // initialize halt signal set
        CLOCK <= 1'b0;   // initialize clock signal unset

        PROG_W = 1'b1;                                                  // enable writing to program memory
        for (PROG_ADDR = 0; PROG_ADDR < 256; PROG_ADDR = PROG_ADDR + 1) begin   // for all addresses of program memory
            PROG_DATA <= 32'b00000000000000000000000000000000;              // clear line
        end
        PROG_W <= 1'b0;                                                 // disable writing to program memory
    end

    /* clock module */
    always begin
        while (!HALT) begin
            #5 CLOCK = ~CLOCK; // 100MHz, posedge -> posedge
        end
    end
 
    /* runtime signals */
    initial begin
        /* initialisation */
        CLEAR <= 1'b1;  // clear and reset processor
        #10             // wait 10ns/1 clock cycles
        CLEAR <= 1'b0;  // remove clear signal

        /* write program to memory */
        for (PROG_ADDR = 0; PROG_ADDR < MAX_LINE; PROG_ADDR = PROG_ADDR + 1) begin
            PROG_DATA <= PROGRAM[PROG_ADDR];
        end

        /* start processor */
        HALT <= 1'b0;   // start program
    end 

endmodule 
