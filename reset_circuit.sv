module reset_circuit (
    /* input signals */
    input logic clk,    // clock signal
    input logic rst,    // reset signal

    /* output signals */
    output logic enable,    // enable signal
    output logic clear_pc   // clear pc signal
);
    int i = 0;

    always @(posedge clk) begin
        if (rst) begin                          // if reset signal is high
            if (i < 4) begin                        // for 4 cycles
                enable <= 0;                        // disable processor
                clear_pc <= 1;                      // reset PC
            end else begin                      // else
                clear_pc <= 0;                      // allow PC to settle
                enable <= 1;                        // enable processor
                i = 0;                              // reset loop counter
            end
        end
    end

endmodule