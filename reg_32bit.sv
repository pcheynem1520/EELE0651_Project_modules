module reg_32bit (
    /* input signals */
    input logic clk,        // clock signal
    input logic rst,        // reset signal
    input logic cs,         // chip select

    /* input buses */
    input reg [31:0] d,   // input data bus

    /* output buses */
    output reg [31:0] q   // output data bus
);

    /* variables */
    genvar i;

    generate // generate 32 d-flip-flops
        for (i = 0; i < 32; i = i + 1) begin : gen_register
            d_flip_flop dff (
                    .d (d[i]),  // data input bus
                    .clk (clk), // clock signal
                    .rst (rst), // clear/reset signal
                    .q (q[i])   // data output bus
                );
        end
    endgenerate

    initial begin           // initialize reg with zeros
        assign q = 32'b0;   // clear output ports
    end


    always @(negedge clk) begin
        if (cs) begin   // if chip is selected
            q <= d;     // accept data write
        end
        else begin      // if not selected
            q <= q;     // maintain current data
        end
    end

endmodule
