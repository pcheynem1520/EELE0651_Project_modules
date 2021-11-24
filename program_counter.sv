//=========================================================
// EELE 0651: Computer Organization
// Authors: PJ Cheyne-Miller, Brenden O'Donnell
// Date: 29 September 2021
// Description: 
// 
// The program counter is the processing unit that controls
// which operations are executed and when through control
// signals and access to the program memory.
//=========================================================

module program_counter (
    /* input signals */
    input logic clk,    // clock signal
    input logic clr,    // clear/reset signal

    /* input buses */
    input logic [31:0] d,   // input data bus

    /* output signals */
    output logic [31:0] q   // output databus 
);

	initial begin           // initialise the output
		q <= 0;
	end

    always @(posedge clk) begin         // on positive edge of clock
        case (!clr)                     // based on clear/reset signal
            1'b1: begin                 // if clr is low
                q <= d;                     // next instruction is input line address 
            end
            default: q <= 8'b00000000;  // else, reset PC to line 0
        endcase
    end

endmodule
