module multiplexer (
    /* input signals */
    input logic clk,                // clock signal

    /* input buses */
    input logic [4:0] reg_adr,      // 5-bit register address bus
    input logic [31:0] reg_data,    // register data bus

    /* output bus */
    output reg [31:0] read_data   // 32-bit bus for selected data to be read
);
        
    /* resolve 5-bit address to selected register */
    always @(posedge clk) begin
        read_data = reg_data[reg_adr]; // multiplexer output = selected register
    end

endmodule
