//=========================================================
// EELE 0651: Computer Organization
// Authors: PJ Cheyne-Miller, Brenden O'Donnell
// Date: 29 September 2021
// Description: 
// 
//=========================================================

module program_counter (
    /* input signals */
    input logic clk,        // clock signal
    input logic clr,        // clear/reset signal
    input logic inc,        // increment program counter
    input logic ld,         // allow data to be stored

    /* input buses */
    input logic [31:0] d,   // input data bus

    /* output signals */
    output logic [31:0] q   // output databus 
);

	initial begin
		q <= 32'b00000000;  // when initialized q = 0
	end

    always @(posedge clk) begin             // at the positive edge of clock signal
    	if (clr) begin                      // when clear signal is active
    		q <= 32'b00000000;              // set output q to 0
    	end
    	else begin                          // when clear signal is inactive
            if (ld) begin                   // and load signal is active
                if (inc) begin              // and increment signal is active
                    q <= d + 32'b00000100;  // output q becomes d plus an increment of 4 byte-addresses
                end
                else begin                  // if incrememnt signal is inactive
                    q <= d;                 // q does not increment and instead takes on the present value of d
                end
            end
			else begin                      // if load signal is inactive
                q <= q;                     // keep q the same
            end
    	end
    end

endmodule
