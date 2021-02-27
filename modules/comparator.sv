module comparator
    #(parameter WIDTH=32)
    (input logic [WIDTH-1:0] in1, in2,
    output logic result);

    assign result = (in1===in2)?1:0;
endmodule
