//=========================================================
// EELE 0651: Computer Organization
// Authors: PJ Cheyne-Miller, Brenden O'Donnell
// Date: 6 October 2021
// Description:
// 
// Takes 3-bit opcodes which specify the operation to be
// performed. Should the operations result in zero or
// overflow, the appropriate flags will be set.
//=========================================================

module data_memory_unit (
    /* input signals */
    input logic clk,    // clock signal
    input logic en,     // chip-enable signal
    input logic wen,    // write-enable signal

    /* input buses */
    input logic [7:0] addr,     // 8-bit address of word being read/written
    input logic [31:0] data_in, // input data bus

    /* output buses */
    input logic [31:0] data_out // output data bus
);

    /* internal logic */
    reg [7:0] data_mem[31:0];   // data memory of 256 32-bit words 

    /* initialization */
    initial begin   // initialise the memory unit to zeros
        for (int i = 0; i < 2^8; i = i + 1) begin       // for each word
            data_mem[i][31:0] = 32'b0;                  // clear each bit
        end
    end

    /* Data memory unit definition */
    always @(posedge clk) begin                                     // on the positive edge of the clock signal,
        case (en)                                                   // depending on enable signal
            1'b1: begin                                             // en = 1: chip enabled
                case (wen)                                          // depending on write enable signal
                    1'b1: data_mem[addr][31:0] <= data_in[31:0]     // wen = 1: write into data memory
                    default: data_out[31:0] <= data_mem[addr][31:0] // wen = 0: read out of data_memory
                endcase
            end
            default: data_out[31:0] <= 32'b0;                       // en = 0: chip disabled
        endcase
    end

endmodule
