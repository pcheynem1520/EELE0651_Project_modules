//=========================================================
// EELE 0651: Computer Organization
// Authors: PJ Cheyne-Miller, Brenden O'Donnell
// Date: 6 October 2021
// Description:
// 
// The instruction memory unit has an 32-bit address input
// (addr), 32-bit data input and output (data_in and
// data_out), and other control lines such as clock, write
// enable (wen), and enable (en). This allows for the
// storage of data for use by the processor.
//=========================================================

module instruction_memory_unit (
    /* input signals */
    input logic clk,    // clock signal
    input logic en,     // chip-enable signal
    input logic wen,    // write-enable signal

    /* input buses */
    input logic [31:0] addr,     // 8-bit address of word being read/written
    input logic [31:0] data_in, // input data bus

    /* output buses */
    output logic [31:0] data_out // output data bus
);

    /* internal logic */
    reg [31:0] mem[4294967295:0];   // instruction memory of 32-bit addresses for 32-bit words

    /* initialization */
    initial begin
        for (int i = 0; i <= 4294967295; i = i + 1) begin  // for all instruction memory addresses
            mem[i] = 0;                                    // clear word
        end
    end

    /* Data memory unit definition */
    always @(posedge clk) begin             // on the positive edge of clock signal
        if (en) begin                       // if chip is enabled
            if (wen) begin                  // if writing is enabled
                mem[addr] <= data_in;       // input data into memory
            end else begin                  // if writing is disabled
                data_out <= mem[addr];      // output data from memory
            end
        end else begin                      // if chip is disabled
            data_out <= 0;                  // clear data memory output
        end
    end

endmodule
