module d_flip_flop (
    /* input signals */
    input logic d,      // data line in
    input logic clk,    // clock signal
    input logic rst,    // clear/reset signal

    /* output signals */
    output reg q      // data line out
);

    initial begin // initial conditions
        q <= 1'b0;
    end
    always @(negedge clk) begin
        if(rst)
            q <= 1'b0;  // output 0 on reset signal
        else
            q <= d;     // output = input, non-blocking
    end

endmodule
