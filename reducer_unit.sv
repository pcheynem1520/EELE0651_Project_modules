module reducer_unit (
    /* input buses */
    input logic [31:0] data_in, // data input from instruction register

    /* output buses */
    output logic [7:0] data_out // data output from reducer unit
);

    always_comb begin : reducing
        data_out[7:0] <= data_in[7:0];  // assign lower 8 bits of input to output
    end

endmodule
